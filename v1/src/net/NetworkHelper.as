package net
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.messaging.*;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import mx.utils.URLUtil;
	
	public class NetworkHelper
	{
		static public var serverHostName:String;
		static private var cs:ChannelSet;
		static private var errorWindow:ErrorHandler;
		static public function makeDefaultChannelSet():ChannelSet
		{
			serverHostName ="http://"+URLUtil.getServerNameWithPort(Application.application.url);
			if (serverHostName=="http://")
				serverHostName = serverHostName+"matrix.localhost";
			if (cs == null)
			{
				cs = new ChannelSet();
				var endpointUrl:String = serverHostName + "/graniteamf/amf";
				var amfChannel:AMFChannel = new AMFChannel("my-polling-amf", endpointUrl);
				cs.addChannel(amfChannel);
			}
			return cs;
		}
		
		static public function makeRO(name:String):RemoteObject
		{
			var ro:RemoteObject = new RemoteObject(name);
			ro.channelSet = makeDefaultChannelSet();
			ro.showBusyCursor=true;
			ro.addEventListener(FaultEvent.FAULT, commonErrorhandler);
			return ro;
		}
		static private function commonErrorhandler(event:FaultEvent):void
		{
			if (errorWindow == null)
			{
				errorWindow = new ErrorHandler;
				errorWindow.initialize();
			}
			if (!checkForSessionExpired(event.fault))
			{
				var msg:String = event.fault.toString()+"\n"+event.fault.getStackTrace();
				errorWindow.errorMsg.text = msg;
				errorWindow.explanation.text = getExplanation(event.fault);
				PopUpManager.addPopUp(errorWindow,DisplayObject(Application.application),true);
				PopUpManager.centerPopUp(errorWindow);
			}
		}
		static private function checkForSessionExpired(fault:Fault):Boolean
		{
			if (fault.faultString.indexOf("SessionExpiredException")!=-1
				|| fault.faultString.indexOf("security")!=-1
			)
			{
				Alert.show("Invalid user session. Application will be reloaded", "User session error",Alert.OK,
				Sprite(Application.application),alertHandler);
				return true
			}
			return false;
		}
		static private function getExplanation(fault:Fault):String
		{
			var unhandledError:String ="Unknown error.\nThis type of errors should be reported to support team.\n"+
			"Please, contact support@idubee.com";
			if (fault.faultString.indexOf("SessionExpiredException")!=-1)
			{
				return "Your session is expired. Please, login again (press CTRL+F5)";
			}
			if (fault.faultDetail.indexOf("NetConnection.Call.Failed")!=-1)
			{
				return "Server is not accessible and may be down.\n"+
				"Please, contact support team. \nTry to reload application by pressing CTRL+F5"
			}
			if (fault.faultString.indexOf("action is denied")!=-1)
			{
				return "You don't have rights to access this module.\n"+
				"Please, contact administrator. \nTry to reload application by pressing CTRL+F5"
			}
			return unhandledError;
		}
		static private function alertHandler(event:CloseEvent):void
		{
			navigateToURL(new URLRequest("../spreadsheet"),"_self");
		}
	}
}
