package idubee.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import idubee.events.FileEvent;
	import idubee.model.EditorCtx;
	import idubee.model.Workbook;
	import idubee.view.editor.TableWindow;
	
	import mx.events.FlexEvent;

	public class FileCommand implements ICommand
	{
		public var ctx:EditorCtx;
		public function FileCommand()
		{
			super();
		}

		public function execute(event:CairngormEvent):void
		{
			switch (event.type)
			{
				case FileEvent.OPEN_NEW: addNewWorkbook(); break; 
				case FileEvent.CLOSE_FILE: closeWorkbook(); break;
			}
		}
		private function closeWorkbook():void
		{
			if (!ctx.workbook) return;
			ctx.documents.removeItemAt(ctx.documents.getItemIndex(ctx.workbook));
//			hideWorkbook(ctx.workbook);
			delete ctx.workbookEditorMap[ctx.workbook];
			ctx.workbook = null;
		}
		private function addNewWorkbook():void
		{
			var w:Workbook = new Workbook;
			ctx.documents.addItem(w);
			ctx.workbook = w;
			showWorkbook(w);	
		}
		private function hideWorkbook(w:Workbook):void
		{
			var tableWindow:TableWindow;
			tableWindow = TableWindow(ctx.workbookEditorMap[w]);
			ctx.windowManager.remove(tableWindow);
		}
		private function showWorkbook(w:Workbook):void
		{
			if (ctx.windowManager)
			{
				var tableWindow:TableWindow;
				if (ctx.workbookEditorMap[w])
				{
					tableWindow = TableWindow(ctx.workbookEditorMap[w]);
					ctx.windowManager.bringToFront(tableWindow);
				}
				else
				{
					tableWindow = new TableWindow;
					tableWindow.initialize();
					tableWindow.table.workbook = w;
					tableWindow.title = w.name;
					ctx.windowManager.add(tableWindow);
					ctx.workbookEditorMap[w] = tableWindow;
				}
				
				
			}	
		}
		
		private function tableWindowCreationHandler(event:FlexEvent):void
		{
			TableWindow(event.currentTarget).maximize();	
		}
	}
}