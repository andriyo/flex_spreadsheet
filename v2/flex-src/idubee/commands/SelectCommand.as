package idubee.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import idubee.events.SelectionEvent;
	import idubee.model.EditorCtx;
	import idubee.model.Pnt;
	import idubee.model.Rect;
	import idubee.model.Spreadsheet;

	public class SelectCommand implements ICommand
	{
		public var ctx : EditorCtx;
		public function SelectCommand()
			{
			super();
		}
		
		public function execute(event:CairngormEvent):void
		{
			switch (event.type)
			{
				case SelectionEvent.SELECT_CELLS: onSelectionAllCellsEvent(event as SelectionEvent); break;
			}
		}
		
		private function onSelectionAllCellsEvent(event : SelectionEvent):void
		{
			var s : Spreadsheet = ctx.workbook.selectedSpreadsheet;
			if (!event.highlightAll) s.selections.length = 0;
			for each (var rect : Rect in event.selectCells)
			{
				s.selections.push(rect);
			}
			var fRect:Rect = Rect(event.selectCells.getItemAt(0));
			s.startPnt = new Pnt(fRect.x, fRect.y);
			s.endPnt = new Pnt(fRect.right, fRect.bottom);
			ctx.table.headerLayer.invalidateDisplayList();
			ctx.table.selectionLayer.invalidateDisplayList();
		}
		
	}
}