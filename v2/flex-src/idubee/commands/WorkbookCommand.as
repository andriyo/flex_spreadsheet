package idubee.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import idubee.events.WorkbookEvent;
	import idubee.model.EditorCtx;
	
	import mx.collections.ArrayCollection;

	public class WorkbookCommand implements ICommand
	{
		public var ctx:EditorCtx;
		public function WorkbookCommand()
			{
			super();
		}

		public function execute(event:CairngormEvent):void
		{
			if (!ctx.workbook) return;
			switch (event.type)
			{
				case WorkbookEvent.ADD_SHEET: addSheet(); break;
				case WorkbookEvent.REMOVE_SHEET: removeSheet(); break;
				case WorkbookEvent.SELECT_SHEET: selectSheet(WorkbookEvent(event)); break;
				case WorkbookEvent.SWAP_SHEETS: swapSheets(WorkbookEvent(event)); break;
			}
		}
		private function addSheet():void
		{
			ctx.workbook.addSheet();
			ctx.table.spreadsheet = ctx.s;
		}
		private function removeSheet():void
		{
			var spreadsheets:ArrayCollection = ctx.workbook.spreadsheets;
			if (spreadsheets.length > 1)
			{
				var index:int = spreadsheets.getItemIndex(ctx.s);
				spreadsheets.removeItemAt(index);
				ctx.workbook.currentSpreadsheet = index > 0 ?index - 1:0;
				ctx.table.spreadsheet = ctx.s;
				
			}
		}
		private function selectSheet(event:WorkbookEvent):void
		{
			ctx.workbook.currentSpreadsheet = event.index;
			ctx.table.spreadsheet = ctx.s;
		}
		private function swapSheets(event:WorkbookEvent):void
		{
			var ss:ArrayCollection = ctx.workbook.spreadsheets;
			var oldItem:Object = ss.getItemAt(event.index);
			var newItem:Object = ss.getItemAt(event.relatedIndex);
			ss.setItemAt(oldItem, event.relatedIndex);
			ss.setItemAt(newItem, event.index);
		}
		
	}
}