package controls
{
	import controls.selectionClasses.SelectionEvent;
	import controls.selectionClasses.SelectionLayer;
	import controls.tableClasses.*;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.Spreadsheet;
	
	import mx.containers.HDividedBox;
	import mx.containers.VDividedBox;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
	public class BorderedTable extends UIComponent
	{
		
		public var table:Table;
		
		private var horizontalRenderersCache:Array = new Array;
		private var verticalRenderersCache:Array = new Array;
		
		private var horizontalSlidersCache:Array = new Array;
		private var verticalSlidersCache:Array = new Array;
		
		public var verticalSelectedHeaders:Array = new Array;
		public var horizontalSelectedHeaders:Array = new Array;
		private var horizontalHeadersHolder:HDividedBox;
		private var verticalHeadersHolder:VDividedBox;
		
		private var cornerHeader:UIComponent;
		public var activeDivider:HeaderSlider;
		private var activeDividerIndex:int = -1;
		private var activeDividerStartPosition:Number;
		private var dragStartPosition:Number;
		private var dragDelta:Number;
		private var minDelta:Number;
		private var maxDelta:Number;
		private var cursorID:int = CursorManager.NO_CURSOR;
		
		private var slidersHolder:UIComponent;
		private var headersHolder:UIComponent;
		
		[Embed(source="/assets/cursors/splith.png")]
		private var splitHorizontalCursor : Class;
		
		[Embed(source="/assets/cursors/splitv.png")]
		private var splitVerticalCursor : Class;
		
		public function BorderedTable():void
		{
			percentHeight = 100;
			percentWidth = 100;
			addEventListener(SelectionEvent.SELECTION, onSelectionHandler, true); 	
		}
		
		public function changeCursor(divider:HeaderSlider):void
		{
			if (cursorID == CursorManager.NO_CURSOR)
			{
				var cursorClass:Class = divider.orientation==HeaderCell.ORIENTATION_VERTICAL ?
										splitVerticalCursor :
										splitHorizontalCursor;
	
				cursorID = CursorManager.setCursor(cursorClass,
												   CursorManagerPriority.HIGH,
												   -8, -10);
			}
		}
		public function restoreCursor():void
		{
			if (cursorID != CursorManager.NO_CURSOR)
			{
				CursorManager.removeCursor(cursorID);
				cursorID = CursorManager.NO_CURSOR;
			}
		}
		private function getMousePosition(divider:HeaderSlider, event:MouseEvent):Number
		{
	        var point:Point = new Point(event.stageX, event.stageY);
	        point = globalToLocal(point);
			return divider.orientation == HeaderCell.ORIENTATION_VERTICAL ? 
					point.y : point.x;
		}
		public function startDividerDrag(divider:HeaderSlider,
	                                          trigger:MouseEvent):void
		{
			// Make sure the user is not currently dragging.
			if (activeDividerIndex >= 0)
				return;
			
			activeDividerIndex = divider.index;
			activeDivider = divider;
			
	
			if (divider.orientation == HeaderCell.ORIENTATION_VERTICAL)
				activeDividerStartPosition = activeDivider.y;
			else
				activeDividerStartPosition = activeDivider.x;
	
	        dragStartPosition = getMousePosition(divider, trigger);
			dragDelta = 0;
	
			systemManager.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
		}
		private function mouseMoveHandler(event:MouseEvent):void
		{
			dragDelta = getMousePosition(activeDivider, event) - dragStartPosition;

			if (activeDivider.orientation == HeaderCell.ORIENTATION_VERTICAL)
					activeDivider.move(0, activeDividerStartPosition + dragDelta);
				else
					activeDivider.move(activeDividerStartPosition + dragDelta, 0);
			
		}
		public function stopDividerDrag(divider:HeaderSlider,
                                         trigger:MouseEvent):void
		{
			dragDelta = getMousePosition(activeDivider, trigger) - dragStartPosition;
			var s:Spreadsheet = Spreadsheet(dataProvider);
			var current:int;
			if (activeDivider.orientation == HeaderCell.ORIENTATION_VERTICAL)
			{
				current =  table.getRowHeigth(activeDividerIndex);		
				s.setRowHeigth(activeDividerIndex,Math.max(2, current + dragDelta)); 
			}
			else
			{
				current =  table.getColumnWidth(activeDividerIndex);		
				s.setColumntWidth(activeDividerIndex,Math.max(2, current + dragDelta)); 
			}
			activeDivider = null;
			activeDividerIndex = -1;
			activeDividerStartPosition = NaN;
			dragStartPosition = NaN;
			dragDelta = NaN;
			invalidateDisplayList();
			table.invalidateDisplayList();
			table.selectionLayer.invalidateDisplayList();
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			table = new Table();
			addChild(table);
			cornerHeader = new Label();
			cornerHeader.move(0,0);
			headersHolder = new UIComponent;
			addChild(headersHolder);
			slidersHolder = new UIComponent;
			addChild(slidersHolder);
			
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var shiftX:int = measureText(String(Spreadsheet(dataProvider).rowsCount)).width + 4;
			var shiftY:int = 20;
			cornerHeader.setActualSize(shiftX, shiftY);
			table.move(shiftX, shiftY);
			table.setActualSize(unscaledWidth - shiftX, unscaledHeight - shiftY);
			hideRenderers(verticalRenderersCache);
			hideRenderers(horizontalRenderersCache);
			hideRenderers(verticalSlidersCache);
			hideRenderers(horizontalSlidersCache);
			
			renderVerticalLine(0,shiftY, shiftX,unscaledHeight - 20, shiftX);			
			renderHorizintalLine(shiftX, 0, unscaledWidth, shiftY, shiftY);	
		}
		

		private function renderVerticalLine(x1:int, y1:int, x2:int, y2:int, stickSize:int):void
		{
			var startIndex:int = table.topRowIndex;
			var endIndex:int = Spreadsheet(dataProvider).rowsCount;
			var cache:Array = verticalRenderersCache;
			var prevY:int = y1;
			var w:int = x2 - x1;
						
			for (var i:int = startIndex; i < endIndex; i++)
			{
				if (prevY >= y2) break;
				var rend:HeaderCell = fetchRenderer(cache, i,  i - startIndex, HeaderCell.ORIENTATION_VERTICAL);
				var slider:HeaderSlider = fetchSlider(verticalSlidersCache, i, i - startIndex, HeaderCell.ORIENTATION_VERTICAL, stickSize);
				rend.move(x1, prevY);
				var h:int = table.getRowHeigth(i);
				if (prevY + h > y2) h = y2 - prevY;
				slider.x = x1;
				slider.y = prevY + h;
				rend.setActualSize(w,h);
				prevY = prevY + h;
				rend.text = String(i+1);
				rend.refreshHeader();
			}
		}
		
		private function renderHorizintalLine(x1:int, y1:int, x2:int, y2:int, stickSize:int):void
		{
			var startIndex : int = table.leftColumnIndex;
			var endIndex : int = Spreadsheet(dataProvider).columnsCount;
			var cache : Array = horizontalRenderersCache;
			var prevX : int = x1;
			var h : int = y2 - y1;
			
			for (var i : int = startIndex; i < endIndex; i++)
			{
				if (prevX >= x2) break;
				var rend : HeaderCell = fetchRenderer(cache,i,  i - startIndex, HeaderCell.ORIENTATION_HORIZONTAL);
				var slider:HeaderSlider = fetchSlider(horizontalSlidersCache, i, i - startIndex, HeaderCell.ORIENTATION_HORIZONTAL, stickSize);
				rend.move(prevX, y1);
				var w : int = table.getColumnWidth(i);
				if (prevX + w > x2) w = x2 - prevX;
				slider.x = prevX + w;
				slider.y = y1;
				rend.setActualSize(w, h);
				prevX = prevX + w;
				rend.text = Utils.convertNumberToABC(i+1);
				rend.refreshHeader();
			}
		}
		
		public function set dataProvider(value:Object):void
		{
			table.dataProvider = value;
		}
		
		public function get dataProvider():Object
		{
			return table.dataProvider;
		}
		private function fetchRenderer(cache:Array, position:int, index:int, orientation:int):HeaderCell
		{
			var renderer:HeaderCell = HeaderCell(cache[index]);
			if (renderer == null) 
			{
				renderer = cache[index] = new HeaderCell(orientation, this);
				headersHolder.addChild(renderer);
			}
			renderer.visible = true;
			renderer["index"] = position;
			return renderer;
		}
		private function fetchSlider(cache:Array, position:int, index:int, orientation:int, stickSize:int):HeaderSlider
		{
			var renderer:HeaderSlider = HeaderSlider(cache[index]);
			if (renderer == null) 
			{
				renderer = cache[index] = new HeaderSlider(orientation, this);
				renderer.stickSize = stickSize;
				renderer.paint();
				slidersHolder.addChild(renderer);
			}
			renderer.visible = true;
			renderer["index"] = position;
			return renderer;
		}
		private function hideRenderers(cache:Array):void
		{
			for each (var renderer:DisplayObject in cache)
			{
				renderer.visible = false;
			}
		}
		private var startColIndex:int;
		private var endColIndex:int;
		private var startRowIndex:int;
		private var endRowIndex:int;
		private function onSelectionHandler(event : SelectionEvent):void
		{
			startColIndex = event.x1;
			endColIndex = event.x2;
			startRowIndex = event.y1;
			endRowIndex = event.y2;
			
			if (!(event.mouseEvent && event.mouseEvent.ctrlKey))
			{
				verticalSelectedHeaders.length = 0;
				horizontalSelectedHeaders.length = 0;
			}
			for (var xi:int =  event.x1; xi <=event.x2; xi++)
			{
				horizontalSelectedHeaders[xi] = true;
			}
			for (var yi:int =  event.y1; yi <=event.y2; yi++)
			{
				verticalSelectedHeaders[yi] = true;
			}

			invalidateDisplayList();
		}
		public function applyStyleToCurrentSelection(typeName:String, value:Object):void
		{
			trace(typeName, value)
			//TODO fix this method
			var s:Spreadsheet = Spreadsheet(dataProvider);
			var style:XML = <style/>;
			var st:XML = <s/>;
			style.appendChild(st);
			st.@typeName = typeName;
			st.@value = value;
			var styleId:int = style.@id = s.addStyle(style) - 1;
			var sl:SelectionLayer = table.selectionLayer;
			for (var x:int = sl._startColIndex ; x <= sl._endColIndex; x++)
			{
				for (var y:int = sl._startRowIndex; y <=sl._endRowIndex; y++)
				{
					s.setStyleIdAt(x, y, styleId); 					
				}

			}
			invalidateDisplayList();
			table.invalidateDisplayList();
		}
		
		public function setSelection(addresses : String):void
		{
			table.selectionLayer.clearSelection();
			
			var rects : Array = addresses.split(",");
			
			for (var i : int = 0; i < rects.length; i++)
			{
				var rect : Rectangle = Utils.toRectangle(rects[i]);
				table.selectionLayer.selected.setValues(rect, true);
				
				if (i == rects.length - 1)
				{
					table.selectionLayer._startColIndex = rect.x;
					table.selectionLayer._startRowIndex = rect.y;
					table.selectionLayer._endColIndex = rect.x + rect.width;
					table.selectionLayer._endRowIndex = rect.y + rect.height;
				}
			}
			
			invalidateDisplayList();
			table.selectionLayer.invalidateDisplayList();
		}
	}
}