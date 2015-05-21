package docManager
{
	import controls.BorderedTable;
	import controls.tableClasses.SparseMatrix;
	import controls.tableClasses.Utils;
	
	import flash.geom.Rectangle;
	
	import model.Spreadsheet;
	
	public class ReplaceEngine
	{
		
		private static var _replaceEngine : ReplaceEngine;
		public var spreadSheet : Spreadsheet;
		public var replaceResult : SparseMatrix;
		private var _table : BorderedTable;
		private var currentReplacePos : int = 0;
		private var replacePattern : RegExp; 
		
		public function ReplaceEngine(table : BorderedTable):void
		{
			replaceResult = new SparseMatrix(spreadSheet.rowsCount, spreadSheet.columnsCount);
			_table = table;
		}
		
		public static function getReplaceEngine(table : BorderedTable = null):ReplaceEngine
		{
			if (!_replaceEngine)
			{
				_replaceEngine = new ReplaceEngine(table);
			} 
			return _replaceEngine;
		}
		
		public function replace(searchValue : String, replaceValue : String, matchCase : Boolean = false, highlight : Boolean = false):int
		{
			if (replaceResult.cells.length) replaceResult.clear();
			
			var firstPosX : int; 
			var firstPosY : int;
			
			var counter : int = 0;
			for (var i : int = 0; i < spreadSheet.columnsCount; i++)
			{
				for (var j : int = 0; j < spreadSheet.rowsCount; j++)
				{
					if (spreadSheet.getTextValueAt(i, j))
					{
						var currentValue : String = (matchCase)? spreadSheet.getTextValueAt(i, j) : spreadSheet.getTextValueAt(i, j).toUpperCase();
						searchValue = (matchCase)? searchValue : searchValue.toUpperCase();
						
						if (currentValue.indexOf(searchValue) != -1)
						{
							if (counter == 0) //remember position of the first element
							{
								firstPosX = i;
								firstPosY = j;
							}
							
							replaceResult.setValueAt(i, j, true);
							counter++;
						}
					}		
				}
			}
			
			// select first item in result and replace it 
			if (replaceResult.getValueAt(firstPosX, firstPosY))
			{
				_table.table.selectionLayer.clearSelection();
				_table.table.selectionLayer._startColIndex = _table.table.selectionLayer._endColIndex = firstPosX;
				_table.table.selectionLayer._startRowIndex = _table.table.selectionLayer._endRowIndex = firstPosY;
				_table.table.selectionLayer.invalidateDisplayList();
				
				var tmp :String = spreadSheet.getTextValueAt(firstPosX, firstPosY);
				if (matchCase)
				{
					replacePattern = new RegExp(searchValue, "g"); 
				} else {
					
					replacePattern = new RegExp(searchValue, "gi");
				}
				spreadSheet.setTextValueAt(firstPosX, firstPosY, tmp.replace(replacePattern, replaceValue));
				currentReplacePos = 1;
			}
			
			if (highlight) highlightResults(replaceResult);
			
			return counter;
		}
		
		/* public function replaceNext(replaceValue : String):int
		{
			var x : int = 0; 
			for (var i : int = 0; i < spreadSheet.columnsCount; i++)
			{
				for (var j : int = 0; j < spreadSheet.rowsCount; j++)
				{
					if (spreadSheet.getTextValueAt(i, j))
					{
						//if (x == currentReplacePos)
						//{
							replaceResult.setValueAt(i, j, true);
							spreadSheet.setTextValueAt(i, j, replaceValue);
							
							_table.table.selectionLayer._startColIndex = _table.table.selectionLayer._endColIndex = i;
							_table.table.selectionLayer._startRowIndex = _table.table.selectionLayer._endRowIndex = j;
							_table.table.selectionLayer.invalidateDisplayList();
							
							currentReplacePos++;
							break;
							//return currentReplacePos;	
						//}
						//x++;	
					}
				}
			}
			
			return currentReplacePos;	
		} */
		
		public function replaceAll(searchValue : String, replaceValue : String, matchCase : Boolean = false, highlight : Boolean = false):int
		{
			if (replaceResult.cells.length) replaceResult.clear();
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
							var tmp :String = spreadSheet.getTextValueAt(i, j);
							if (matchCase)
							{
								replacePattern = new RegExp(searchValue, "g"); 
							} else {
								
								replacePattern = new RegExp(searchValue, "gi");
							}
							spreadSheet.setTextValueAt(i, j, tmp.replace(replacePattern, replaceValue));
							
							replaceResult.setValueAt(i, j, true);
							//spreadSheet.setTextValueAt(i, j, replaceValue);
							countResults++;	
						}
					}		
				}
			}
			
			if (highlight) highlightResults(replaceResult);
			
			return countResults;
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