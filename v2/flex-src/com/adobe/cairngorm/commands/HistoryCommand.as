package com.adobe.cairngorm.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.history.HistoryEvent;
	import com.adobe.cairngorm.history.HistoryModel;
	import com.adobe.cairngorm.history.HistoryToken;
	
	import mx.collections.ArrayCollection;

	public class HistoryCommand implements ICommand
	{
		public var history:HistoryModel;		

		public function execute(event:CairngormEvent):void
		{
			var e:HistoryEvent = HistoryEvent(event);
			switch(event.type)
			{
				case HistoryEvent.REDO: redo(e); break;
				case HistoryEvent.UNDO: undo(e); break;
			}
		}
		
		private function undo(event:HistoryEvent):void
		{
			var h:ArrayCollection = history.undoHistory; 
			var a:HistoryToken = getLastToken(h);
			if (!a) return;
			try
			{
				a.command.rollback(a);
			}
			catch (er:Error)
			{
				trace("Unable to undo action: " + a);	
			}
			
			history.redoHistory.addItem(a);
			
		}
		private function getLastToken(history:ArrayCollection):HistoryToken
		{
			if (!history.length) return null;
			var a:HistoryToken = HistoryToken(history.getItemAt(history.length - 1));
			history.removeItemAt(history.length - 1);
			return a;
		}
		private function redo(event:HistoryEvent):void
		{
			var a:HistoryToken = getLastToken(history.redoHistory);
			if (!a) return;
			try
			{
				a = a.command.startTransaction(a.commandEvent);
				a.command.execute(a.commandEvent);
				history.undoHistory.addItem(a);
			}
			catch(er:Error)
			{
				trace("Unable to redo action: "+ a);				
			}			
		}
	}
}