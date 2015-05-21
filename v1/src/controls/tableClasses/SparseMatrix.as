package controls.tableClasses
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * This is simple representation of sparse matrix
	 * */
	public class SparseMatrix extends EventDispatcher implements IMatrix
	{
		public var cells:Array;
		
 		private var _rowsCount:int;
 		private var _columnsCount:int;
 		public function SparseMatrix(rowsCount:int, columnsCount:int)
 		{
 			cells = new Array(rowsCount * columnsCount);
 			this._rowsCount = rowsCount;
 			this._columnsCount = columnsCount;	
 		}
 		public function get rowsCount():int{
 			return _rowsCount;
 		}
		public function get columnsCount():int{
			return _columnsCount;
		}
		public function getValueAt(columnIndex:int, rowIndex:int):Object
		{
			return cells[convert(columnIndex, rowIndex)];
		}
		
		public function setValueAt(columnIndex:int, rowIndex:int,  value:Object):Object
		{
//			var old:Object = getValueAt(columnIndex, rowIndex);
			cells[convert(columnIndex, rowIndex)] = value;
			return value;
		}
		public function removeAt(columnIndex:int, rowIndex:int):void
		{
			delete cells[convert(columnIndex, rowIndex)];
		}
		public function remove(area:Rectangle):void
		{
			for (var y:int = area.y; y<=area.y + area.height; y++)
			{
				for (var x:int = area.x; x<=area.x + area.width; x++)
				removeAt(x,y);
			}
		}
		public function clear():void
		{
			cells.length = 0;
		}
		public function getArray():Array
		{
			return cells;
		}
		public function getValues(area:Rectangle):Array
		{
			var r:Array = new Array;
			for(var x:int = area.x; x <= area.x + area.width; x++)
			{
				for(var y:int = area.y; y <= area.y + area.height; y++)
				{
					var value:Object = getValueAt(x, y); 
					if (value)
					{
						r.push(value);	
					}
				}
			}
			return r;
		}
		public function setValues(area:Rectangle, value:Object):void
		{
			for(var x:int = area.x; x <= area.x + area.width; x++)
			{
				for(var y:int = area.y; y <= area.y + area.height; y++)
				{
					setValueAt(x, y, value); 
				}
			}
		}
		public function getIndexOf(value:Object):Point
		{
			var i:int = cells.indexOf(value);
			
			return new Point(i % _columnsCount, i / _columnsCount);
		}
		private function convert(x:int, y:int):int
		{
			return y * _columnsCount + x;
		}
		
		public function getSubSparseMatrix(rect : Rectangle):SparseMatrix
		{
			var subSpreadSheet : SparseMatrix = new SparseMatrix(rect.height +1, rect.width +1);
			
			for (var x : int = 0; x <= rect.width; x++)
			{
				for (var y : int = 0; y <= rect.height; y++)
				{
					var tre : * = getValueAt(x + rect.x, y + rect.y);
					subSpreadSheet.setValueAt(x, y, getValueAt(x + rect.x, y + rect.y));
				}
			}
			
			return 	subSpreadSheet;	
		}
		
		public function setSubSparseMatrix(startX : int, startY : int, subSparseMatrix : SparseMatrix):void
		{
			for (var x : int = 0; x < subSparseMatrix._columnsCount; x++)
			{
				for (var y : int = 0; y < subSparseMatrix._rowsCount; y++)
				{
					setValueAt(x + startX, y + startY, 
									subSparseMatrix.getValueAt(x, y));
				}
			}
		}
		public function getRow(rowIndex:int):Array
		{
			var offset:int = rowIndex * _columnsCount;
			return cells.slice(offset, offset + _columnsCount);
		}
		public function getCol(colIndex:int):Array
		{
			var t:Array = [];
			for (var i:int = 0; i < _rowsCount; i++)
				t[i] = cells[int(i * _columnsCount + colIndex)];
			return t;
		}
		public function shiftLeft():void
		{
			if (_columnsCount == 1) return;
			
			var j:int = _columnsCount - 1, k:int;
			for (var i:int = 0; i < _rowsCount; i++)
			{
				k = i * _columnsCount + j;
				cells.splice(k, 0, cells.splice(k - j, 1));
			}
		}
		
		public function shiftRight():void
		{
			if (_columnsCount == 1) return;
			
			var j:int = _columnsCount - 1, k:int;
			for (var i:int = 0; i < _rowsCount; i++)
			{
				k = i * _columnsCount + j;
				cells.splice(k - j, 0, cells.splice(k, 1));
			}
		}
	
		public function shiftUp():void
		{
			if (_rowsCount == 1) return;
			
			cells = cells.concat(cells.slice(0, _columnsCount));
			cells.splice(0, _columnsCount);
		}
		
		public function shiftDown():void
		{
			if (_rowsCount == 1) return;
			
			var offset:int = (_rowsCount - 1) * _columnsCount;
			cells = cells.slice(offset, offset + _columnsCount).concat(cells);
			cells.splice(_rowsCount * _columnsCount, _columnsCount);
		}
	
		public function appendRow(a:Array):void
		{
			a.length = _columnsCount;
			cells = cells.concat(a);
			_rowsCount++
		}
		
		
		public function prependRow(a:Array):void
		{
			a.length = _columnsCount;
			cells = a.concat(cells);
			_rowsCount++;
		}
		
		public function appendCol(a:Array):void
		{
			a.length = _rowsCount;
			for (var y:int = 0; y < _rowsCount; y++)
				cells.splice(y * _columnsCount + _columnsCount + y, 0, a[y]);
			_columnsCount++;
		}
		
		public function prependCol(a:Array):void
		{	
			a.length = _rowsCount;
			for (var y:int = 0; y < _rowsCount; y++)
				cells.splice(y * _columnsCount + y, 0, a[y]);
			_columnsCount++;
		}
		
		public function sort(options:int = 0):Array
		{
			options |= Array.RETURNINDEXEDARRAY;
			var indexes:Array = getCol(0).sort(options);
			sortByIndexes(indexes);
			return indexes;
		}
		public function sortByIndexes(indexes:Array):void
		{
			var t:SparseMatrix = new SparseMatrix(0, _columnsCount);
			for (var i:int = 0; i < indexes.length; i++)
			{
				t.appendRow(getRow(indexes[i]));				
			}
			cells = t.cells;	
		}
				
	}
}