package idubee.model
{
	import idubee.commands.KeyEditorCommand;
	import idubee.events.AddressBarEvent;
	import idubee.events.FindEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AbstractOperation;
	import mx.rpc.events.ResultEvent;
	
	[Bindable]
	public class Workspace
	{
		public function Workspace()
		{
			super();
			clearAndInitWorkspace();
		}
		public function clearAndInitWorkspace():void
		{
			hotKeys = new ArrayCollection;
			initHotKeys();
//			initMenu();
		}
		private function initHotKeys():void
		{
			var hk:HotKey = new HotKey;
			hk.context = HotKey.CONTEXT_SHEET;
			hk.charCode = ";".charCodeAt(0);
			hk.ctrl = true;
			hk.label = "Insert date";
			hk.operation = KeyEditorCommand.execInsertDate;
			hotKeys.addItem(hk);
			
			hk = new HotKey;
			hk.context = HotKey.CONTEXT_SHEET;
			hk.charCode = "f".charCodeAt(0);
			hk.ctrl = true;
			hk.label = "Find/Replace";
			hk.throwEvent = true;
			hk.eventClass = FindEvent;
			hk.eventType = FindEvent.SHOW_FIND;
			hotKeys.addItem(hk);
			
			hk = new HotKey;
			hk.context = HotKey.CONTEXT_SHEET;
			hk.charCode = "a".charCodeAt(0);
			hk.ctrl = true;
			hk.label = "Show address bar";
			hk.throwEvent = true;
			hk.eventClass = AddressBarEvent;
			hk.eventType = AddressBarEvent.SHOW_HIDE_BAR;
			hotKeys.addItem(hk);
			
			hk = new HotKey;
			hk.context = HotKey.CONTEXT_SHEET;
			hk.charCode = "p".charCodeAt(0);
			hk.ctrl = true;
			hk.label = "Ping Server";
			hk.operation = pingServer;
			hotKeys.addItem(hk);
			
			hk = new HotKey;
			hk.context = HotKey.CONTEXT_SHEET;
			hk.charCode = "m".charCodeAt(0);
			hk.ctrl = true;
			hk.label = "Insert million records";
			hk.operation = KeyEditorCommand.execInsertMillion;
			hotKeys.addItem(hk);
		} 
		private function pingServer():void
		{
			var ao:AbstractOperation = AbstractOperation(ServerCtx.ctx.dm.ping);
			ao.addEventListener(ResultEvent.RESULT, pingHandler);
			ao.send();
		}
		private function pingHandler(event:ResultEvent):void
		{
			Alert.show(event.result.toString(), "Ping");
		}
		
		public var hotKeys:ArrayCollection;
		public var mainMenu:XML = 
		<root>
			<item label="File" eventClass="FileEvent">
				<item label="New" action="openNew"/>
				<item label="Open URL" action="openURL"/>
				<item label="Open File" action="openFile"/>
				<item label="Save to Disk" action="saveLocal"/>
				<item label="Save Online" action="saveOnline"/>
				<item label="Properties" action="fileProperties"/>
				<item label="Close" action="closeFile"/>
			</item>
			<item label="Edit" eventClass="EditorEvent">
				<item label="Undo" action="undo" eventClass="com.adobe.cairngorm.history.HistoryEvent"/>
				<item label="Redo" action="redo" eventClass="com.adobe.cairngorm.history.HistoryEvent"/>
				<item label="Copy" action="copy"/>
				<item label="Paste" action="paste"/>
				<item label="Cut" action="cut"/>
				<item label="Delete" action="delete"/>
				<item label="Find/Replace" eventClass="FindEvent" action="showFind"/>
				<item label="Address bar" eventClass="AddressBarEvent" action="showHideBar"/>
				<item type="separator"/>
				<item label="Insert Row"  action="insertRow"/>
				<item label="Remove Row"  action="removeRow"/>
				<item label="Insert Column"  action="insertColumn"/>
				<item label="Remove Column"  action="removeColumn"/>
			</item>
		</root>;
	}
}