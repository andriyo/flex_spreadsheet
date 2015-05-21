package docManager
{
	import controls.BorderedTable;
	import controls.tableClasses.SparseMatrix;
	import controls.tableClasses.Utils;
	
	import flash.geom.Rectangle;
	
	import model.Spreadsheet;
	
	public class SearchEngine
	{
		public var spreadSheet : Spreadsheet;
		public var searchResult : SparseMatrix;
		public var replaceResult : SparseMatrix;
		private var _table : BorderedTable;
		private var currentResultPos : int = 1;
		private var currentReplacePos : int = 0;
		private static var _searchEngine : SearchEngine;
		
		
		public static function getSearchEngine(table : BorderedTable = null):SearchEngine
		{
			if (!_searchEngine)
			{
				_searchEngine = new SearchEngine(table);
			} 
			return _searchEngine;
		}		
				
		public function SearchEngine(table : BorderedTable):void
		{
			replaceResult = new SparseMatrix(spreadSheet.rowsCount, spreadSheet.columnsCount);
			searchResult = new SparseMatrix(spreadSheet.rowsCount, spreadSheet.columnsCount);
			_table = table;
		}
		
		public function search(searchValue : String, matchCase : Boolean = false, highlight : Boolean = false):int
		{
			var firstPosX : int; 
			var firstPosY : int;
			
			if (searchResult.cells.length)
			{
				searchResult.clear();
			} 
			
			
			if (searchValue)
			{
				currentResultPos = 1;
				
				var countResults : int = 0; 
				for (var i : int = 0; i < spreadSheet.columnsCount; i++)
				{
					for (var j : int = 0; j < spreadSheet.rowsCount; j++)
					{
						if (spreadSheet.getTextValueAt(i, j))
						{
							var currentValue : String = (!matchCase)? spreadSheet.getTextValueAt(i, j).toUpperCase() : spreadSheet.getTextValueAt(i, j);
							searchValue = (matchCase)? searchValue : searchValue.toUpperCase();
							
							if (currentValue.indexOf(searchValue) != -1)
							{
								if (countResults == 0) //remember position of the first element
								{
									firstPosX = i;
									firstPosY = j;
								}
								searchResult.setValueAt(i, j, true);
								countResults++;	
							}
						}		
					}
				}
				
				// select first item in result
				if (searchResult.getValueAt(firstPosX, firstPosY))
				{
					_table.table.selectionLayer.clearSelection();
					_table.table.selectionLayer._startColIndex = _table.table.selectionLayer._endColIndex = firstPosX;
					_table.table.selectionLayer._startRowIndex = _table.table.selectionLayer._endRowIndex = firstPosY;
					_table.table.selectionLayer.invalidateDisplayList();
				} 
				
				if (highlight) highlightResults(searchResult);
			}
			
			return countResults;
		}
		
		public function gotoNextResult():void
		{
			var x : int = 0;
			for (var i : int = 0; i < searchResult.columnsCount; i++)
			{
				for (var j : int = 0; j < searchResult.rowsCount; j++)
				{
					if (searchResult.getValueAt(i, j))
					{ 
						if (x == currentResultPos)
						{	
							//_table.table.selectionLayer.clearSelection();
							_table.table.selectionLayer._startColIndex = _table.table.selectionLayer._endColIndex = i;
							_table.table.selectionLayer._startRowIndex = _table.table.selectionLayer._endRowIndex = j;
							_table.table.selectionLayer.invalidateDisplayList();
							currentResultPos++;
							return;	
						}
						x++;
					} 
				}	
			}
		}
		
		private function highlightResults(results : SparseMatrix):void
		{
			for (var i : int = 0; i < results.columnsCount; i++)
			{
				for (var j : int = 0; j < results.rowsCount; j++)
				{
					if (results.getValueAt(i, j))
					{
						var rect : Rectangle = Utils.toRectangle(Utils.convertNumberToABC(i + 1) + (j + 1));
						_table.table.selectionLayer.selected.setValues(rect, true);
						_table.invalidateDisplayList();
						_table.table.selectionLayer.invalidateDisplayList();
						
					} 
				}
			}
		}
	}
}