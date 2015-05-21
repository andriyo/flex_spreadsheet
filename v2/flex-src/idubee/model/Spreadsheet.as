package idubee.model
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.utils.Timer;
	
	import idubee.util.IOUtils;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;

	[Event(name="cellAdded", type="idubee.model.SpreadsheetEvent")]
	[Event(name="cellRemoved", type="idubee.model.SpreadsheetEvent")]
	[Event(name="columnWidthChanged", type="idubee.model.SpreadsheetEvent")]
	[Event(name="rowHeightChanged", type="idubee.model.SpreadsheetEvent")]
	[Event(name="cellFound", type="idubee.model.SpreadsheetEvent")]
	[Event(name="searchStarted", type="idubee.model.SpreadsheetEvent")]
	[Event(name="searchEnded", type="idubee.model.SpreadsheetEvent")]
	[RemoteClass(alias="com.idubee.model.Spreadsheet")]
	public class Spreadsheet extends EventDispatcher implements IExternalizable
	{
		public var name:String;
		private var _rows:Array;
		private var defaultColumnWidth:uint = 80;
		private var defaultRowHeight:uint = 20;
		public var columnWidth:Array = [];
		public var columnAutoWidth:Array = [];
		public var rowHeight:Array = [];
		public var rowAutoHeight:Array = [];
		public var startXIndex:uint = 0;
		public var startYIndex:uint = 0;
		public var noEvents:Boolean;
		public var maxEnteredX:uint;
		public var maxEnteredY:uint;
		public var selections:Array = []; //of Rects
		private var _startPnt:Pnt;
		public var endPnt:Pnt;
		public var maxX:uint = 64000;
		public var maxY:uint = 64000;
		private var _finderTimer:Timer;
		private var _searchIterator:IViewCursor;
		private var _re:RegExp;
		public var searchInProcess:Boolean;
		
		public function Spreadsheet(name:String = "Spreadsheet")
		{
			this.name = name;
			_rows = [];
			startPnt = new Pnt();
			endPnt = new Pnt();
		}
		public function get startPnt():Pnt
		{
			return _startPnt;
		}
		public function set startPnt(value:Pnt):void
		{
			_startPnt = value;
		}
		public function getCellAt(x:uint, y:uint):Cell
		{
			if (!_rows[y])
			{
				return null;
			}
			return _rows[y][x] as Cell;
		}
		public function setCellAt(x:uint, y:uint, cell:Cell):void
		{
			if (x > maxX || y > maxY) return;
			if (!_rows[y])
			{
				_rows[y] = [];
			}
			if (_rows[y][x])
			{
				if (_rows[y][x] == cell) return;
				if (!noEvents) dispatchEvent(new SpreadsheetEvent(SpreadsheetEvent.CELL_REMOVED, _rows[y][x] as Cell,true));
			}
			_rows[y][x] = cell;
			if (!noEvents) dispatchEvent(new SpreadsheetEvent(SpreadsheetEvent.CELL_ADDED, _rows[y][x] as Cell,true));
			if (x > maxEnteredX) maxEnteredX = x;
			if (y > maxEnteredY) maxEnteredY = y;
		}
		private function valueChangedHandler(event:CellEvent):void
		{
			dispatchEvent(event);
		}
		public function removeCellAt(x:uint, y:uint):void
		{
			if (!_rows[y])
			{
				return;
			}
			
			delete _rows[y][x];
						
			if (!noEvents) 
			{
				var e:SpreadsheetEvent = new SpreadsheetEvent(SpreadsheetEvent.CELL_REMOVED);
				e.columnIndex = x;
				e.rowIndex = y;
				dispatchEvent(e);
			}
			deleteUnusedRow(y);
		}
		private function deleteUnusedRow(y:uint):void
		{
			for each (var o:Object in _rows[y])
			{
				if (o) 
				{
					return;
				}
			}
			delete _rows[y];
		}
		public function getColumnWidth(xi:uint):uint
		{
			if (columnWidth[xi])
			{
				return columnWidth[xi];
			}
			else if (columnAutoWidth[xi])
			{
				return columnAutoWidth[xi];
			}
			else
			{
				return defaultColumnWidth;
			}
		}
		public function getRowHeight(yi:uint):uint
		{
			if (rowHeight[yi])
			{
				return rowHeight[yi];
			}
			else if (rowAutoHeight[yi])
			{
				return rowAutoHeight[yi];
			}
			else
			{
				return defaultRowHeight;
			}
		}
		public function setColumnWidth(xi:uint, width:int):void
		{
			var oldValue:int = getColumnWidth(xi);
			columnWidth[xi] = width;
			dispatchColumnWidthChangedEvent(xi, oldValue, width);
		}
		public function setAutoColumnWidth(xi:uint, width:int):void
		{
			var oldValue:int = getColumnWidth(xi);
			columnAutoWidth[xi] = width;
			dispatchColumnWidthChangedEvent(xi, oldValue, width);
		}
		private function dispatchColumnWidthChangedEvent(xi:uint, oldValue:int, newValue:int):void
		{
			if (noEvents) return; 
			var event:SpreadsheetEvent = new SpreadsheetEvent(SpreadsheetEvent.COLUMN_WIDTH_CHANGED, null, true);
			event.oldValue = oldValue;
			event.newValue = newValue;
			event.columnIndex = xi;
			dispatchEvent(event);
		}
		public function setRowHeight(yi:uint, height:int):void
		{
			var oldValue:int = getRowHeight(yi);
			rowHeight[yi] = height;
			dispatchRowHeightChangedEvent(yi, oldValue, height);
		}
		public function setAutoRowHeight(yi:uint, height:int):void
		{
			var oldValue:int = getRowHeight(yi);
			rowAutoHeight[yi] = height;
			dispatchRowHeightChangedEvent(yi, oldValue, height);
		}
		private function dispatchRowHeightChangedEvent(yi:uint, oldValue:int, newValue:int):void
		{
			if (noEvents) return;
			var event:SpreadsheetEvent = new SpreadsheetEvent(SpreadsheetEvent.ROW_HEIGHT_CHANGED, null, true);
			event.oldValue = oldValue;
			event.newValue = newValue;
			event.rowIndex = yi;
			dispatchEvent(event);
		}
		public function getCellsInRect(rect:Rect, copy:Boolean = false, create:Boolean = false):Array
		{
			var r:Array = new Array;
			for (var y:uint = rect.y; y <=rect.bottom; y++)
			{
				for (var x:uint = rect.x; x<=rect.right; x++)
				{
					var cell:Cell = getCellAt(x,y);
					if (cell && copy) cell = cell.clone();
					if (!cell && create) cell = fetchCursorCell(new Pnt(x, y)); 
					r.push(cell);
				}
			}
			return r;
		}
		public function getAllNotEmptyCells():ArrayCollection
		{
			var a:ArrayCollection = new ArrayCollection;
			for each (var r:Array in _rows)
			{
				for each (var cell:Cell in r)
				{
					a.addItem(cell);
				}
			}
			return a;
		}
		public function setCellsInRect(rect:Rect, values:Array):void
		{
			var i:int = 0;
			for (var y:uint = rect.y; y <=rect.bottom; y++)
			{
				for (var x:uint = rect.x; x<=rect.right; x++)
				{
					setCellAt(x, y, values[i++]);
				}
			}
		}
		public function insertRow(rowIndex:uint, count:uint):void
		{
			while (count-- > 0)
			{
				_rows.splice(rowIndex,0,[]);
			}
			var e:SpreadsheetEvent = new SpreadsheetEvent(SpreadsheetEvent.ROW_INSERTED);
			e.rowIndex = rowIndex;
			e.newValue = count;
			dispatchEvent(e);
		}
		public function removeRow(rowIndex:uint, count:uint):void
		{
			_rows.splice(rowIndex,count);
			var e:SpreadsheetEvent = new SpreadsheetEvent(SpreadsheetEvent.ROW_REMOVED);
			e.rowIndex = rowIndex;
			e.newValue = count;
			dispatchEvent(e);
		}
		public function insertCol(colIndex:uint, count:uint):void
		{
			for each (var r:Array in _rows)
			{
				if (!r) continue;
				for (var i:uint = colIndex; i < colIndex + count; i++)
				{
					r.splice(i,0,null);
					delete r[i];
				}
			}
			var e:SpreadsheetEvent = new SpreadsheetEvent(SpreadsheetEvent.COLUMN_INSERTED);
			e.columnIndex = colIndex;
			e.newValue = count;
			dispatchEvent(e);
		}
		
		public function removeCol(colIndex:uint, count:uint):void
		{
			for each (var r:Array in _rows)
			{
				if (!r) continue;
				r.splice(colIndex, count);
			}
			var e:SpreadsheetEvent = new SpreadsheetEvent(SpreadsheetEvent.COLUMN_REMOVED);
			e.columnIndex = colIndex;
			e.newValue = count;
			dispatchEvent(e);
		}
		
		public function clear(rect:Rect = null):void
		{
			if (!rect) rect = new Rect(0,0,maxEnteredX,maxEnteredY);
			for (var y:uint = rect.y; y <=rect.bottom; y++)
			{
				for (var x:uint = rect.x; x<=rect.right; x++)
				{
					removeCellAt(x,y);
				}
			}
		}
		public function fetchCursorCell(cursor:Pnt = null):Cell
		{
			if (!cursor)
			{
				cursor = startPnt;
			}
			var c:Cell = getCellAt(cursor.x,cursor.y);
			if (!c)
			c = new Cell;
			setCellAt(cursor.x,cursor.y,c);
			return c;
		}
		public function vectorHasSelection(vector:Pnt):Boolean
		{
			for each (var rect:Rect in selections)
			{
				if (vectorIntersectsRect(vector, rect))
					return true;
				
			}
			var currentSelection:Rect = new Rect(startPnt.x, startPnt.y);
			currentSelection.bottomRight = endPnt;
			currentSelection = currentSelection.swap();
			if (vectorIntersectsRect(vector, currentSelection)) return true;
			return false;
		}
		private function vectorIntersectsRect(vector:Pnt, rect:Rect):Boolean
		{
			var a:Boolean = rect.x <= vector.x && rect.right >= vector.x;
			var b:Boolean = rect.y <= vector.y && rect.bottom >= vector.y
			var r:Boolean = (a && !b) || (!a && b);
			return r;
		}
		public function findNextNotEmptyCell(dir:Point, start:Point):Point
		{
			do
			{
				start = start.add(dir);
				if (start.x == -1 || start.y == -1 || start.x > maxX || start.y > maxY)
				{
					return null;
				}
			} while (!getCellAt(start.x, start.y));
			return start;
		}
		public function getAllSelectedCells():ArrayCollection
		{
			var r:ArrayCollection = new ArrayCollection;
			for each (var rect:Rect in selections)
			{
				for each (var cell:Cell in getCellsInRect(rect))
				{
					r.addItem(cell);
				}
			}
			return r;
		}
		public function makeCurrentSelectionRect():Rect
		{
			var r:Rect = new Rect(startPnt.x, startPnt.y);
			r.bottomRight = endPnt;
			return r;
		}
		public function readExternal(input:IDataInput):void
		{
			name = input.readObject() as String;
			defaultColumnWidth = input.readInt();
			defaultRowHeight = input.readInt();
			columnWidth = readSparseArray(input);
			columnAutoWidth = readSparseArray(input);
			rowHeight = readSparseArray(input);
			rowAutoHeight = readSparseArray(input);
			maxEnteredX = input.readInt();
			maxEnteredY = input.readInt();
			maxX = input.readInt();
			maxY = input.readInt();
			readCells(input);
			dispatchEvent(new SpreadsheetEvent(SpreadsheetEvent.LOADED));
		}
		private function readSparseArray(input:IDataInput):Array
		{
			var a:Array = [];
			IOUtils.readMap(input,a);
			return a; 
		}
		
		private function readCells(input:IDataInput):void
		{
			var cells:ArrayCollection = ArrayCollection(input.readObject());
			var addresses:ArrayCollection = ArrayCollection(input.readObject());
			noEvents = true;
			for (var i:int = 0; i < cells.length; i++)
			{
				var p:Pnt = Pnt(addresses.getItemAt(i));
				var c:Cell = Cell(cells.getItemAt(i));
				setCellAt(p.x, p.y, c);
			} 
			noEvents = false;
		}
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(name);
			output.writeInt(defaultColumnWidth);
			output.writeInt(defaultRowHeight);
			writeSparseArray(output, columnWidth);
			writeSparseArray(output, columnAutoWidth);
			writeSparseArray(output, rowHeight);
			writeSparseArray(output, rowAutoHeight);
			output.writeInt(maxEnteredX);
			output.writeInt(maxEnteredY);
			output.writeInt(maxX);
			output.writeInt(maxY);
			writeCells(output);
		}
		
		private function writeSparseArray(output:IDataOutput, a:Array):void
		{
			IOUtils.writeMap(output,a);
		}
		private function writeCells(output:IDataOutput):void
		{
			var ca:ArrayCollection = getAllNotEmptyCells();
			output.writeObject(ca);
			var aa:ArrayCollection = new ArrayCollection();
			for each (var c:Cell in ca)
			{
				aa.addItem(findAddress(c));
			}
			output.writeObject(aa);
		}
		public function findAddress(cell:Cell):Pnt
		{
			for each (var r:Array in _rows)
			{
				if (r.indexOf(cell) != -1)
				{
					return new Pnt(r.indexOf(cell), _rows.indexOf(r));
				}
			}
			return null;
		}
		public function findCellByAddress(p:Pnt):Cell
		{
			return getCellAt(p.x, p.y);
		}
		public function findCells(re:RegExp):void
		{
			_re = re;
			_finderTimer = new Timer(100);
			_finderTimer.addEventListener(TimerEvent.TIMER, findTimerHandler);
			searchInProcess = true;
			_searchIterator = getAllNotEmptyCells().createCursor();
			_finderTimer.start();
			var e:SpreadsheetEvent = new SpreadsheetEvent(SpreadsheetEvent.SEARCH_STARTED);
			dispatchEvent(e);
		}
		public function stopSearch():void
		{
			if (!searchInProcess) return;
			searchInProcess = false;
			_searchIterator = null;
			_finderTimer.stop();
			_finderTimer.removeEventListener(TimerEvent.TIMER, findTimerHandler);
			var e:SpreadsheetEvent = new SpreadsheetEvent(SpreadsheetEvent.SEARCH_ENDED);
			dispatchEvent(e);
		} 
		private function findTimerHandler(event:TimerEvent):void
		{
			if (!_searchIterator.afterLast)
			{
				var cell:Cell = Cell(_searchIterator.current);
				_searchIterator.moveNext();
				if (_re.test(cell.t))
				{
					var e:SpreadsheetEvent = new SpreadsheetEvent(SpreadsheetEvent.CELL_FOUND,cell);
					dispatchEvent(e);
				}
			}
			else
			{
				stopSearch();
			}
		}
		public function getAbsoluteCopy(rects:Array):Array
		{
			var adata:Array = [];
			for each (var r:Rect in rects)
			{
				var cells:Array = getCellsInRect(r,true);
				var arec:Object = {rec:r, cells:cells};
				adata.push(arec);
			}
			return adata;
		}
		
		public function applyAbsoluteCopy(adata:Array):void
		{
			for each (var arec:Object in adata)
			{
				setCellsInRect(arec.rec,arec.cells);
			}
		}
	}
}