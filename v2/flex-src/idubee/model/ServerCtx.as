package idubee.model
{
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	
	import mx.core.Application;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.remoting.mxml.RemoteObject;
	import mx.utils.URLUtil;
	
	public class ServerCtx
	{
		static private var _ctx:ServerCtx;
		static public const MODEL_NAME:String = "serverCtx";
		private var _channelSet:ChannelSet;
		public var dm:RemoteObject;
		public function ServerCtx()
		{
			if (!_ctx)
			{
				_ctx = this;
				initCtx();
			}
			else
			{
				throw new CairngormError(CairngormMessageCodes.SINGLETON_EXCEPTION);
			}
		}
		public static function get ctx():ServerCtx
		{
			if (!_ctx) new ServerCtx;
			return _ctx; 
		} 
		private function initCtx():void
		{
			var serverHostName:String ="http://"+URLUtil.getServerNameWithPort(Application.application.url);
			if (serverHostName=="http://")
				serverHostName = serverHostName+"localhost:8080";
			_channelSet = new ChannelSet();
			var endpointUrl:String = serverHostName + "/graniteamf/amf";
			var amfChannel:AMFChannel = new AMFChannel("idb-channel", endpointUrl);
			_channelSet.addChannel(amfChannel);
			dm = new RemoteObject("docManagerService");
			dm.channelSet = _channelSet;
			dm.showBusyCursor = true;
		}

	}
}