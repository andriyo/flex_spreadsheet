package idubee.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import idubee.events.KeyEditorEvent;
	import idubee.model.EditorCtx;
	import idubee.model.HotKey;
	import idubee.model.Pnt;
	import idubee.model.Spreadsheet;

	public class KeyEditorCommand implements ICommand
	{
		public var ctx:EditorCtx;
		public function KeyEditorCommand()
		{
			super();
		}

		public function execute(event:CairngormEvent):void
		{
			var e:KeyEditorEvent = KeyEditorEvent(event);
			for each (var hk:HotKey in ctx.workspace.hotKeys)
			{
				if (hk.context == e.context && hk.charCode == e.event.charCode && hk.ctrl == e.event.ctrlKey
				&& hk.shift == e.event.shiftKey)
				{
					if (hk.operation != null)
					{
						hk.operation();
					}
					if (hk.throwEvent)
					{
						var clazz:Class = hk.eventClass;
						var newEvent:CairngormEvent = CairngormEvent(new clazz(hk.eventType));
						newEvent.dispatch();
					}
				}
			}
		}
		static public function execInsertDate():void
		{
			var ctx:EditorCtx = EditorCtx.ctx;
			var s:Spreadsheet = Spreadsheet(ctx.workbook.spreadsheets[ctx.workbook.currentSpreadsheet]);
			var date:Date = new Date;
			s.fetchCursorCell().v = date.toDateString();
		}
		static public function execInsertMillion():void
		{
			var ctx:EditorCtx = EditorCtx.ctx;
			var s:Spreadsheet = Spreadsheet(ctx.workbook.spreadsheets[ctx.workbook.currentSpreadsheet]);
			var i:int = 0;
			var c:Pnt = s.startPnt.clonePnt();
			while (i < 1000000)
			{
				s.fetchCursorCell(c).v = "Record "+i;
				c.y +=1;
				i++;
			}
			
		}
	}
}