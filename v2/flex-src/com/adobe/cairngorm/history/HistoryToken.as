package com.adobe.cairngorm.history
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class HistoryToken
	{
		public var commandEvent:CairngormEvent;
		public var originalState:Object;
		public var command:IUndoableCommand;

	}
}