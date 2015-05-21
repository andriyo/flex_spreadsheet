package idubee.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import idubee.events.FindEvent;
	import idubee.events.SelectionEvent;
	import idubee.model.Cell;
	import idubee.model.EditorCtx;
	import idubee.model.Rect;
	import idubee.model.Spreadsheet;
	import idubee.model.SpreadsheetEvent;
	import idubee.model.Workbook;
	
	import mx.collections.ArrayCollection;

	public class FindCommand implements ICommand
	{
		public var ctx:EditorCtx;
		private var highlightAll : Boolean = false;
		
		public function FindCommand()
		{
			super();
		}

		public function execute(event:CairngormEvent):void
		{
			switch (event.type)
			{
				case FindEvent.SHOW_FIND: showFindBar(); break;
				case FindEvent.FIND: find(event as FindEvent); break;
				case FindEvent.NEXT: next(); break;
				case FindEvent.PREVIOUS: previous(); break;
				case FindEvent.SHOW_FIND_ALL: showFindAll(); break;
				case FindEvent.CLOSE_FIND_ALL: closeFindAll(); break;
				case FindEvent.OPEN_SEARCH_ENGINE: openAdvancedSearch(); break;
				case FindEvent.CLOSE_SEARCH_ENGINE: closeAdvancedSearch(); break;
				case FindEvent.FIND_ADVANCED: findAdvanced(event as FindEvent); break;
			}
		}
		private function showFindBar():void
		{
			ctx.currentTableWindow.showFinderBar.play(null, ctx.currentTableWindow.isFinderShown);
		}
		
		private function showFindAll():void
		{
			ctx.openSearchResultsWindow();		
		}
		
		private function closeFindAll():void
		{
			ctx.closeSearchResultsWindow()
		}
		
		private function next():void
		{
			var workbook : Workbook = ctx.workbook;
			if (workbook.searchResults && workbook.searchResults.length > 0)
			{
				var selectEvent : SelectionEvent = new SelectionEvent(SelectionEvent.SELECT_CELLS);
				if (workbook.currentSearchPosition == workbook.searchResults.length - 1)
				{
					workbook.currentSearchPosition = 0;
				} else 
				{
					workbook.currentSearchPosition += 1;
				}
				var c : Cell = workbook.searchResults.getItemAt(workbook.currentSearchPosition) as Cell
				selectEvent.selectCells.addItem(new Rect(c.currentAddress().x, c.currentAddress().y));
				selectEvent.dispatch();
			}	
		}
		
		private function previous():void
		{
			var workbook : Workbook = ctx.workbook;
			if (workbook.searchResults && workbook.searchResults.length > 0)
			{
				var selectEvent : SelectionEvent = new SelectionEvent(SelectionEvent.SELECT_CELLS);
				if (workbook.currentSearchPosition == 0)
				{
					workbook.currentSearchPosition = workbook.searchResults.length - 1;
				} else 
				{
					workbook.currentSearchPosition -= 1;
				}
				var c : Cell = workbook.searchResults.getItemAt(workbook.currentSearchPosition) as Cell;
				selectEvent.selectCells.addItem(new Rect(c.currentAddress().x, c.currentAddress().y))
				selectEvent.dispatch();
			}
		}
		
		private function find(event : FindEvent):void
		{
			var s:Spreadsheet = ctx.workbook.selectedSpreadsheet;
			
			s.selections.length = 0;
			ctx.table.headerLayer.invalidateDisplayList();
			ctx.table.selectionLayer.invalidateDisplayList();
			
			highlightAll = event.highlightAll;
			ctx.workbook.searchResults = new ArrayCollection;
			
			s.addEventListener(SpreadsheetEvent.CELL_FOUND, onCellFound);
			s.addEventListener(SpreadsheetEvent.SEARCH_ENDED, onSearchEnded);
			var regExp : RegExp = (event.matchCase)?  new RegExp(event.what, 'i') : new RegExp(event.what);
			s.findCells(regExp);
		}
		
		private function onCellFound(event : SpreadsheetEvent):void
		{
			ctx.workbook.searchResults.addItem(event.cell);
			var selectEvent : SelectionEvent = new SelectionEvent(SelectionEvent.SELECT_CELLS);
			
			//highlight first element
			if (ctx.workbook.searchResults.getItemIndex(event.cell) == 0)
			{
				var c:Cell = ctx.workbook.searchResults.getItemAt(0) as Cell 
				selectEvent.selectCells.addItem(new Rect(c.currentAddress().x, c.currentAddress().y));
				selectEvent.dispatch();	
			}
			if (highlightAll)
			{
				if (ctx.workbook.searchResults.getItemIndex(event.cell) == 0) return;
				selectEvent.highlightAll = highlightAll;
				selectEvent.selectCells.addItem(new Rect(event.cell.currentAddress().x, event.cell.currentAddress().y));
				selectEvent.dispatch();
			}
		}
		
		private function onSearchEnded(event : SpreadsheetEvent):void
		{
			ctx.s.removeEventListener(SpreadsheetEvent.CELL_FOUND, onCellFound);
			ctx.s.removeEventListener(SpreadsheetEvent.SEARCH_ENDED, onSearchEnded);
		}
		
		private function openAdvancedSearch():void
		{
			ctx.openAdvancedSearchWindow()
		}
		
		private function closeAdvancedSearch():void
		{
			ctx.closeAdvancedSearchWindow()
		}
		
		private function findAdvanced(event : FindEvent):void
		{
			
		}
		
	}
}