package controls.selectionClasses
{
	import controls.Table;
	import controls.tableClasses.SparseMatrix;
	import controls.tableClasses.Utils;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import model.Spreadsheet;
	
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.UIComponent;

	[Event(name="selection", type="controls.selectionClasses.SelectionEvent")]
	public class SelectionLayer extends UIComponent
	{
		public var table:Table;
		private var selectionRenderer:IFactory;
		private var availableRenderers:Array;
		private var usedRenderers:Array;
		private var selectionContentHolder : UIComponent;
		private var selectionStarted : Boolean;
		
		public var _startColIndex : int = 0;
		public var _startRowIndex : int = 0;
		public var _endColIndex : int;
		public var _endRowIndex : int;
		private var selectedChanged : Boolean;
		
		public var selected:SparseMatrix;
		private var formulaAddresses:Array;
		public var topRowIndex:int;
		public var leftColumnIndex:int;
		public var visisbleItems:Rectangle = new Rectangle;
		private var background:Shape;
		protected var tool:SelectTool;
		protected var showTool:Boolean = true;
		protected var addressSelectionMode:Boolean;
		public var fillSelectionMode:Boolean;
		public function SelectionLayer(table:Table)
		{
			this.table = table;
			registerKeyboardListeners();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			table.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, selectionKeyFocusOut);
			selectionRenderer = new ClassFactory(SelectionRenderer);
			availableRenderers = new Array;
			usedRenderers = new Array;
		}
		protected function selectionKeyFocusOut(event:FocusEvent):void
		{
			event.preventDefault();
		}
		protected function registerKeyboardListeners():void
		{
			table.addEventListener(KeyboardEvent.KEY_DOWN, selectionKeyDownHandler);
		}
		protected function unregisterKeyboardListeners():void
		{
			table.removeEventListener(KeyboardEvent.KEY_DOWN, selectionKeyDownHandler);
		}

		override protected function createChildren():void
		{
			selectionContentHolder = new UIComponent();
			selectionContentHolder.mouseEnabled = false;
			addChild(selectionContentHolder);
			tool = new SelectTool(this);
			addChild(tool);
		}
		
		public function updateDataProvider():void
		{
			if (table.dataProvider)
			{				
				selected = new SparseMatrix(Spreadsheet(table.dataProvider).rowsCount,
											Spreadsheet(table.dataProvider).columnsCount);
			}
		}
		
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			
			if (event.target != this) return;
			selectionStarted = true;
			if (event.ctrlKey)
			{
				showTool = false;
				tool.visible = false;
			}
			else
			{
				clearSelection();
			}
			startSelecting(event.localX , event.localY);
		}
		
		private function selectionKeyDownHandler(event:KeyboardEvent):void
		{
			if (moveByKey(event))
			{
				processKeyPressed(event);
			}
		}
		
		private function shiftDownSelection(event : KeyboardEvent):void
		{
			if (event.shiftKey)
			{
				_endRowIndex += 1;
				rememberSelection();
			 	invalidateDisplayList();
			} else {
				
				clearSelection();
				_endColIndex = _startColIndex += 0;
				_endRowIndex = _startRowIndex += 1;
				moveVisibleRect(_startColIndex, _startRowIndex);
			}
		}
		
		private function shiftUpSelection(event : KeyboardEvent):void
		{
			if (event.shiftKey)
			{
				_endRowIndex -= 1;
				rememberSelection();
			 	invalidateDisplayList();
			} else {
				
				clearSelection();
				_endColIndex = _startColIndex += 0;
				_endRowIndex = _startRowIndex += -1;
				moveVisibleRect(_startColIndex, _startRowIndex);
			}
		}
		
		private function shiftRightSelection(event : KeyboardEvent):void
		{
			if (event.shiftKey)
			{
				_endColIndex += 1;
				rememberSelection();
			 	invalidateDisplayList();
			} else {
				
				clearSelection();
				_endColIndex = _startColIndex += 1;
				_endRowIndex = _startRowIndex += 0;
				moveVisibleRect(_startColIndex, _startRowIndex);
			}
		}
		
		private function shiftLeftSelection(event : KeyboardEvent):void
		{
			if (event.shiftKey)
			{
				_endColIndex -= 1;
				rememberSelection();
			 	invalidateDisplayList();
			} else {
				
				clearSelection();
				_endColIndex = _startColIndex += -1;
				_endRowIndex = _startRowIndex += 0;
				moveVisibleRect(_startColIndex, _startRowIndex);
			}
		}
		
		protected function moveByKey(event:KeyboardEvent):Boolean
		{
			var dX:int = 0;
			var dY:int = 0;
			var navKeyPressed:Boolean;
			switch(event.keyCode)
			{
				case Keyboard.SHIFT: return false;
				case Keyboard.LEFT: dX = -1; navKeyPressed = true; shiftLeftSelection(event); break;
				case Keyboard.UP: dY = -1; navKeyPressed = true; shiftUpSelection(event); break;
				case Keyboard.DOWN: dY = 1; navKeyPressed = true; shiftDownSelection(event); break;
				case Keyboard.RIGHT: dX = 1; navKeyPressed = true; shiftRightSelection(event); break;
				case Keyboard.TAB: dX = 1; navKeyPressed = false; break;
				case Keyboard.ENTER: dY = 1; navKeyPressed = false; break;
				case Keyboard.DELETE:
					var s:Spreadsheet = Spreadsheet(table.dataProvider);
					if (_startColIndex != _endColIndex || _startRowIndex != _endRowIndex)
					{
						for ( var i : int = _startColIndex; i < _endColIndex + 1; i++)
						{
							for (var j : int = _startRowIndex; j < _endRowIndex + 1; j++)
							{
								s.setTextValueAt(i, j, ""); // удаляем все из выделенной области
							}
						}
						
					} else 
					{
						s.setTextValueAt(_startColIndex, _startRowIndex,"");  //удаляется только из одной ячейки
					}
					
					table.invalidateDisplayList();
					break;
				default: return true;
			}
			if (event.shiftKey && !navKeyPressed)
			{
				dX = -dX;
				dY = -dY;
			}
			
			if (!navKeyPressed)
			{
				clearSelection();
				_endColIndex = _startColIndex +=dX;
				_endRowIndex = _startRowIndex +=dY;
				moveVisibleRect(_startColIndex, _startRowIndex);
				
			}
			if (!checkVector(dX, dY)) return false;
			dispatchSelectionEvent(null);
			invalidateDisplayList();
			table.invalidateDisplayList();
			return false;
		}
		protected function processKeyPressed(event:KeyboardEvent):void
		{
			event.preventDefault();
		}
		private function checkVector(dX:int, dY:int):Boolean
		{
			if (dX + dY == 0) return false;
			var x:int = _startColIndex + dX;
			if (x < 0 || x >= Spreadsheet(table.dataProvider).columnsCount) return false;
			var y:int = _startRowIndex + dY;
			if (y < 0 || y >= Spreadsheet(table.dataProvider).rowsCount) return false;
			return true;
		}
		private function moveVisibleRect(x:int, y:int):void
		{
			var x1:int = table.leftColumnIndex;
			var y1:int = table.topRowIndex;
			var x2:int = table.leftColumnIndex + table.visibleColumnsCount;
			var y2:int = table.topRowIndex + table.visibleRowsCount;
			var dX:int = Math.max((x - x2 + 1),0) - Math.max((x1 - x), 0);
			var dY:int = Math.max((y - y2 + 1),0) - Math.max((y1 - y), 0);
			table.horizontalScrollPosition = table.horizontalScrollPosition + dX;
			table.verticalScrollPosition = table.verticalScrollPosition + dY; 
			table.tableScrollHandler(null);
		}
		private function mouseMoveHandler(event:MouseEvent):void
		{
			if ((addressSelectionMode || selectionStarted) && event.buttonDown) 
			{
				endSelecting(event.localX , event.localY);	
			}
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			if (!selectionStarted && !addressSelectionMode) return;
			selectionStarted = false;
			showTool = true;
			invalidateDisplayList();
			endSelecting(event.localX , event.localY);
			rememberSelection();
			dispatchSelectionEvent(event);
		}
		
		private function startSelecting(startX:int, startY:int):void
		{
			var p:Point = table.mouseToDataPoint(startX, startY);
			var startColIndex:int = p.x + leftColumnIndex;
			var startRowIndex:int = p.y + topRowIndex;
			
			_startColIndex = _endColIndex = startColIndex;
			_startRowIndex = _endRowIndex = startRowIndex;
			selectedChanged = true;
			invalidateDisplayList();
		}
		
		private function endSelecting(x:int, y:int):void
		{
			var p:Point = table.mouseToDataPoint(x, y);
			var colIndex:int = p.x + leftColumnIndex;
			var rowIndex:int = p.y + topRowIndex;
			
			if (_endColIndex == colIndex && _endRowIndex == rowIndex) return;
			
			_endColIndex = colIndex;
			_endRowIndex = rowIndex;
			selectedChanged = true;
			invalidateDisplayList();
		}
		
		public function startAddressSelection():void
		{
			formulaAddresses = [];
			addressSelectionMode = true;
		}
		public function endAddressSelection():void
		{
			addressSelectionMode = false;
			
		}
		protected function addAddress(range:Rectangle):void
		{
			formulaAddresses.push(range);
			
		}
		private function rememberSelection():void
		{
			if (addressSelectionMode)
			{
				addAddress(makeRectFromIndexes());
			}
			else
			{
				selected.setValues(makeRectFromIndexes(), true);				
			}
			
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var xi:int;
			var yi:int;
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (!selected) return;
			availableRenderers = availableRenderers.concat(usedRenderers);
			usedRenderers.length = 0;
			drawFakeBackground(unscaledWidth, unscaledHeight);
			if (addressSelectionMode)
			{
				renderAddressSelection(unscaledWidth, unscaledHeight);		
			}
			else
			{
				renderSelection(unscaledWidth, unscaledHeight);				
			}
			hideUnusedrenderers();
			if (showTool && !addressSelectionMode)
			{
				tool.visible = true;
				tool.setActualSize(unscaledWidth, unscaledHeight);
				tool.setCoordinates(leftColumnIndex, topRowIndex, _startColIndex, _startRowIndex, _endColIndex, _endRowIndex);
			}
		}
		private function drawFakeBackground(width:int, heigth:int):void
		{
			if (!background)
	    	{
	    		background = new Shape;
	            addChildAt(background, 0);
	    	}
	    	var g:Graphics = background.graphics;
	    	g.clear();
	        g.beginFill(0, 0);
	        g.drawRect(0, 0, width, height);
	        g.endFill();
		}
		private function renderAddressSelection(width:int, heigth:int):void
		{
	    	
	    	if (selectionStarted)
	    	{
	    		drawAddressSelection(makeRectFromIndexes());
	    	}
			for each(var rect:Rectangle in formulaAddresses)
			{
				drawAddressSelection(rect);
			}
		}
		private function drawAddressSelection(rect:Rectangle):void
		{
			var actualWidth:int;
	    	var actualHeight:int;
			var x:int;
	    	var y:int;
	    	var xiR : int;
	    	var yiR : int;
	    	var renderer : SelectionRenderer;
			xiR = rect.x - leftColumnIndex;
    		x = (xiR > 0)? table.xPoints[xiR - 1] : 0;
    		actualWidth = table.xPoints[xiR + rect.width] - x;
    		yiR = rect.y - topRowIndex;
    		y = (yiR > 0)? table.yPoints[yiR - 1] : 0;
    		actualHeight = table.yPoints[yiR+rect.height] - y;
    		renderer = fetchSelectionRenderer();
    			
    		renderer.x = x;
    		renderer.y = y;
    		renderer.explicitHeight = actualHeight;
    		renderer.explicitWidth = actualWidth;
    		renderer.paint(0x00ff00);
		}
		private function renderSelection(width:int, heigth:int):void
	    {
	    	var ix:int;
	    	var iy:int;
	    	var x:int;
	    	var y:int;
	    	var xiR : int;
	    	var yiR : int;
	    	var renderer : SelectionRenderer;
	    	
	    	var actualWidth:int;
	    	var actualHeight:int;
	    	
	    	if (!table.dataProvider) return;
	    	
	    	for (var xi:int = leftColumnIndex; xi <= leftColumnIndex + table.visibleColumnsCount; xi++)
	    	{
	    		xiR = xi - leftColumnIndex;
	    		x = (xiR > 0)? table.xPoints[xiR - 1] : 0;
	    		actualWidth = table.xPoints[xiR] - x;
	    		
	    		for (var yi:int = topRowIndex; yi<=topRowIndex+table.visibleRowsCount; yi++)
	    		{
					var cellSelected : Boolean = selected.getValueAt(xi, yi) || isInCurrentSelection(xi, yi);
					
					
					if (!(cellSelected || isInCurrentSelection(xi, yi))) continue;
					if (xi==_startColIndex && yi==_startRowIndex) continue;
					
	    			yiR = yi - topRowIndex;
	    			y = (yiR > 0)? table.yPoints[yiR - 1] : 0;
	    			actualHeight = table.yPoints[yiR] - y;
	    			
	    			renderer = fetchSelectionRenderer();
	    			
	    			renderer.x = x;
	    			renderer.y = y;
	    			renderer.explicitHeight = actualHeight;
	    			renderer.explicitWidth = actualWidth;
	    			renderer.paint();
	    		}
	    	}
	    }
		
		
		private function hideUnusedrenderers():void
		{
			for each (var renderer : DisplayObject in  availableRenderers)
			{
				renderer.visible = false;
			}
		}
		
		private function isInCurrentSelection(x:int, y:int):Boolean
		{
			if (!selectionStarted) return false;
			if (Math.abs(x - _startColIndex) + Math.abs(_endColIndex - x) != Math.abs(_endColIndex - _startColIndex)) return false;
			if (Math.abs(y - _startRowIndex) + Math.abs(_endRowIndex - y) != Math.abs(_endRowIndex - _startRowIndex)) return false;
			return true;
		}
		
		private function fetchSelectionRenderer():SelectionRenderer
		{
			var renderer : SelectionRenderer;
			if (availableRenderers.length > 0)
			{
				renderer = SelectionRenderer(availableRenderers.pop());
				DisplayObject(renderer).visible = true;				
			}
			else
			{
				renderer = SelectionRenderer(selectionRenderer.newInstance());
				selectionContentHolder.addChild(DisplayObject(renderer));
			}
			usedRenderers.push(renderer);
			return renderer;
		}
		
		public function clearSelection():void
		{
			if (selected) selected.clear();
		}
		public function selectRow(rowIndex:int):void
		{
			for (var i:int = 0; i < Spreadsheet(table.dataProvider).columnsCount; i++)
			{
				selected.setValueAt(i, rowIndex, true);
			}
			_startColIndex = 0;
			_startRowIndex = rowIndex;
			_endColIndex = Spreadsheet(table.dataProvider).columnsCount;
			_endRowIndex = rowIndex;
			invalidateDisplayList();
			dispatchSelectionEvent(null);
		}
		public function selectColumn(colIndex:int):void
		{
			for (var i:int = 0; i < Spreadsheet(table.dataProvider).rowsCount; i++)
			{
				selected.setValueAt(colIndex, i, true);
			}
			_startColIndex = colIndex;
			_startRowIndex = 0;
			_endColIndex = colIndex;
			_endRowIndex = Spreadsheet(table.dataProvider).rowsCount;
			invalidateDisplayList();
			dispatchSelectionEvent(null);
		}
		private function dispatchSelectionEvent(event:MouseEvent):void
		{
			dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION, _startColIndex, _startRowIndex, _endColIndex, _endRowIndex, event));
		}
		public function makeRectFromIndexes():Rectangle
		{
			return Utils.makeRect(_startColIndex, _startRowIndex, _endColIndex, _endRowIndex);
		}
	}
}
