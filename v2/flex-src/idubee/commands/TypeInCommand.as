package idubee.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.history.HistoryToken;
	import com.adobe.cairngorm.history.IUndoableCommand;
	
	import idubee.events.TypeInEvent;
	import idubee.model.Cell;
	import idubee.model.EditorCtx;
	import idubee.model.Spreadsheet;

	public class TypeInCommand implements IUndoableCommand
	{
		public var ctx:EditorCtx;
		
		public function TypeInCommand()
		{
		}

		public function startTransaction(event:CairngormEvent):HistoryToken
		{
			var t:HistoryToken = new HistoryToken;
			t.command = this;
			t.commandEvent = event;
			var e:TypeInEvent = TypeInEvent(event);
			var s:Spreadsheet = ctx.s;
			var cells:Array = s.getCellsInRect(e.range, true);
			t.originalState = cells;
			return t;
		}
		
		public function rollback(ht:HistoryToken):void
		{
			var e:TypeInEvent = TypeInEvent(ht.commandEvent);
			var s:Spreadsheet = ctx.s;
			s.setCellsInRect(e.range, ht.originalState as Array);
		}
		
		public function execute(event:CairngormEvent):void
		{
			//type in only
			var e:TypeInEvent = TypeInEvent(event);
			var s:Spreadsheet = ctx.s;
			var cells:Array = s.getCellsInRect(e.range, false, true);
			for each (var c:Cell in cells)
			{
				c.v = e.value;
			}
						
		}
		
	}
}