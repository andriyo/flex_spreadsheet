package com.adobe.cairngorm.history
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;

	public interface IUndoableCommand extends ICommand
	{
		function startTransaction(event:CairngormEvent):HistoryToken;
		
		function rollback(ht:HistoryToken):void;
	}
}