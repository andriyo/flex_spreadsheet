package idubee.view.table
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import idubee.model.Pnt;
	import idubee.model.Rect;
	import idubee.model.Spreadsheet;
	import idubee.model.SpreadsheetEvent;
	import idubee.model.Workbook;
	import idubee.view.cell.CellRenderer;
	
	import mx.controls.VScrollBar;
	import mx.core.UIComponent;
	import mx.events.ListEvent;
	import mx.events.ResizeEvent;
	import mx.events.ScrollEvent;
	import mx.events.ScrollEventDirection;
	import mx.managers.IFocusManagerComponent;
	
	[Event(name="scroll", type="mx.events.ScrollEvent")]
	[Event(name="selectionChanged", type="idubee.model.SpreadsheetEvent")]
	public class Table extends UIComponent implements IFocusManagerComponent
	{
		private static const BBAR_HEIGHT:int = 20;
		private static const RBAR_WIDTH:int = 20;
		private var startPositionChanged:Boolean;
		public var visibleColumnsCount:int;
		public var visibleRowsCount:int;
		public var xPos:Array;
		public var yPos:Array;
		public var dataLayer:DataLayer;
		private var backgroundLayer:BackgroundLayer;
		public var selectionLayer:SelectionLayer;
		public var headerLayer:HeaderLayer;
		private var _w:Workbook;
		private var _s:Spreadsheet;
		private var spreadsheetChanged:Boolean;
		public var visibleIndexRect:Rect;
		public var bBar:WorksheetNavBar;
		public var vScroll:VScrollBar;
		public var maxColumnCount:uint = 50;
		public var maxRowCount:uint = 100;
		public var editable:Boolean = true;
		private var _oldS:Spreadsheet;
		
		public function Table()
		{
			super();
			xPos = [];
			yPos = [];
			addEventListener(ResizeEvent.RESIZE, tableResizeHandler);
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
//			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			visibleIndexRect = new Rect;
			enabled = false;
		}
		private function mouseOutHandler(event:MouseEvent):void
		{
			//TODO: IMPLEMENT THIS
		}
		private function mouseWheelHandler(event:MouseEvent):void
		{
			if (vScroll)
	        {
	            event.stopPropagation();
	
	            var scrollDirection:int = event.delta <= 0 ? 1 : -1;
	
	            // Make sure we scroll by at least one line
	            var scrollAmount:Number = Math.max(Math.abs(event.delta),
	                                               vScroll.lineScrollSize);
	
	            // Multiply by 3 to make scrolling a little faster
	            var oldPosition:Number = startYIndex;
	            startYIndex = Math.max(0, startYIndex + 3 * scrollAmount * scrollDirection);
				
	            var scrollEvent:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
	            scrollEvent.direction = ScrollEventDirection.VERTICAL;
	            scrollEvent.position = startYIndex;
	            scrollEvent.delta = startYIndex - oldPosition;
	            dispatchEvent(scrollEvent);
	            vScrollHandler(scrollEvent);
	        }
		}
		public function get startXIndex():uint
		{
			return _s.startXIndex;
		}
		public function get startYIndex():uint
		{
			return _s.startYIndex;
		}
		public function set startXIndex(value:uint):void
		{
			if (_s.startXIndex == value) return;
			_s.startXIndex = value;
			startPositionChanged = true;
			invalidateAll();
		}
		public function set startYIndex(value:uint):void
		{
			if (_s.startYIndex == value) return;
			_s.startYIndex = value;
			startPositionChanged = true;
			invalidateAll();
		}
		public function invalidateAll():void
		{
			invalidateProperties();
			invalidateDisplayList();
			if (backgroundLayer) backgroundLayer.invalidateDisplayList();
			if (dataLayer) dataLayer.invalidateDisplayList();
			if (selectionLayer) selectionLayer.invalidateDisplayList();
			if (headerLayer) headerLayer.invalidateDisplayList();
		}
		public function set spreadsheet(value:Spreadsheet):void
		{
			if (_s == value) return;
			if (_s)
			{
				_oldS = _s;
			}		
			_s = value;
			spreadsheetChanged = true;
			invalidateAll();
		}
		public function get spreadsheet():Spreadsheet
		{
			return _s;
		}
		
		[Bindable]
		public function set workbook(value:Workbook):void
		{
			_w = value;
			if (bBar)
			{
				if (_w) bBar.spreadsheets = _w.spreadsheets;
			}
			if (_w)
			{
				enabled = true;
				spreadsheet = _w.spreadsheets[0];
			}
			else
			{
				enabled = false;
				spreadsheet = null;
			}
			
		}
		
		public function get workbook():Workbook
		{
			return _w;
		}
		override protected function createChildren():void
		{
			bBar = new WorksheetNavBar;
			vScroll = new VScrollBar;
			bBar.addEventListener(ListEvent.CHANGE, selectedSpreadsheetChanged);
			bBar.addEventListener(ScrollEvent.SCROLL, hScrollHandler);
			vScroll.addEventListener(ScrollEvent.SCROLL, vScrollHandler);
			addChild(bBar);
			addChild(vScroll);
			backgroundLayer = new BackgroundLayer(this);
			addChild(backgroundLayer);
			dataLayer = new DataLayer(this);
			addChild(dataLayer);
			selectionLayer = new SelectionLayer(this);
			addChild(selectionLayer);
			headerLayer = new HeaderLayer(this)
			addChild(headerLayer);
		}
		
		private function updateScrollBars():void
		{
			if (bBar.hScroll)
			{
				bBar.hScroll.setScrollProperties(visibleColumnsCount,0,maxColumnCount);
				bBar.hScroll.scrollPosition = startXIndex;
			}
			if (vScroll)
			{
				vScroll.setScrollProperties(visibleRowsCount,0,maxRowCount);
				vScroll.scrollPosition = startYIndex;
			}
		}
		private function hScrollHandler(event:ScrollEvent):void
		{
			var hNew:uint = event.position;
			if (hNew < 0) hNew = 0;
			if (hNew > maxColumnCount - 10 && event.delta > 0)
			{
				maxColumnCount += 20;
				updateScrollBars();
			}
			if (maxColumnCount > (spreadsheet.maxEnteredX + 50) && maxColumnCount > 70 && event.delta < 0)
			{
				maxColumnCount -= 20;
				updateScrollBars();
			}
			if (hNew > Number.MAX_VALUE) hNew = Number.MAX_VALUE;
			startXIndex = hNew;
		}
		
		private function vScrollHandler(event:ScrollEvent):void
		{
			var vNew:uint = event.position;
			if (vNew < 0) vNew = 0;
			if (vNew > maxRowCount - 10 && event.delta > 0)
			{
				maxRowCount += 20;
				updateScrollBars();
			}
			if (maxRowCount > (spreadsheet.maxEnteredY + 100) && maxRowCount > 120 && event.delta < 0)
			{
				maxRowCount -= 20;
				updateScrollBars();
			}
			if (vNew > Number.MAX_VALUE) vNew = Number.MAX_VALUE;
			startYIndex = vNew;
		}
		private function selectedSpreadsheetChanged(event:ListEvent):void
		{
			spreadsheet = Spreadsheet(event.itemRenderer.data);
		}
		override protected function commitProperties():void
		{
			if (spreadsheetChanged)
			{
				spreadsheetChanged = false;
				commitSpreadsheet();
			}
			if (startPositionChanged)
			{
				startPositionChanged = false;
			}
			
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (!workbook) return;
			var w:int = unscaledWidth - RBAR_WIDTH - offsetX;
	    	var h:int = unscaledHeight - BBAR_HEIGHT - offsetY;
    		xPos = [];
    		yPos = [];
    		calculateLines(startXIndex, xPos, _s.getColumnWidth, w);
			calculateLines(startYIndex, yPos, _s.getRowHeight, h);
	    	calculateVisible(w, h);
	    	var offsetX:int = headerLayer.measureLeftHolderWidth();
			var offsetY:int = headerLayer.measureTopHolderHeight();
	    	w -= offsetX;
	    	h -= offsetY;
	    	backgroundLayer.move(offsetX, offsetY);
	    	backgroundLayer.setActualSize(w, h);
	    	dataLayer.move(offsetX, offsetY);
	    	dataLayer.setActualSize(w, h);
	    	bBar.move(0, unscaledHeight - BBAR_HEIGHT);
			bBar.setActualSize(unscaledWidth - RBAR_WIDTH, BBAR_HEIGHT);
			vScroll.move(unscaledWidth - RBAR_WIDTH,0);
			vScroll.setActualSize(RBAR_WIDTH,unscaledHeight - BBAR_HEIGHT);
			var scrollRect:Rectangle = new Rectangle(0,0,w,h);
			backgroundLayer.scrollRect = scrollRect;
			dataLayer.scrollRect = scrollRect;
			selectionLayer.scrollRect = scrollRect;
			
			selectionLayer.move(offsetX, offsetY);
	    	selectionLayer.setActualSize(w, h);
	    	headerLayer.setActualSize(unscaledWidth, unscaledHeight);
	    	scrollRect.width += offsetX;
	    	scrollRect.height += offsetY;
	    	headerLayer.scrollRect = scrollRect;
		}
		
		private function commitSpreadsheet():void
		{
			if (_oldS)
			{
				if (selectionLayer.editMode)
				{
					selectionLayer.exitEdit();
				}
				_oldS.removeEventListener(SpreadsheetEvent.COLUMN_WIDTH_CHANGED, spreadsheetChangedHandler,false);
				_oldS.removeEventListener(SpreadsheetEvent.ROW_HEIGHT_CHANGED, spreadsheetChangedHandler,false);
				_oldS.removeEventListener(SpreadsheetEvent.CELL_ADDED, spreadsheetChangedHandler,false);
				_oldS.removeEventListener(SpreadsheetEvent.CELL_REMOVED, spreadsheetChangedHandler,false);
				_oldS.removeEventListener(SpreadsheetEvent.ROW_INSERTED, spreadsheetChangedHandler,false);
				_oldS.removeEventListener(SpreadsheetEvent.ROW_REMOVED, spreadsheetChangedHandler,false);
				_oldS.removeEventListener(SpreadsheetEvent.COLUMN_INSERTED, spreadsheetChangedHandler,false);
				_oldS.removeEventListener(SpreadsheetEvent.COLUMN_REMOVED, spreadsheetChangedHandler,false);
				
				_oldS = null;
			}
			if (_s)
			{
				_s.addEventListener(SpreadsheetEvent.COLUMN_WIDTH_CHANGED, spreadsheetChangedHandler,false,0,true);
				_s.addEventListener(SpreadsheetEvent.ROW_HEIGHT_CHANGED, spreadsheetChangedHandler,false,0,true);
				_s.addEventListener(SpreadsheetEvent.CELL_ADDED, spreadsheetChangedHandler,false,0,true);
				_s.addEventListener(SpreadsheetEvent.CELL_REMOVED, spreadsheetChangedHandler,false,0,true);
				_s.addEventListener(SpreadsheetEvent.ROW_INSERTED, spreadsheetChangedHandler,false,0,true);
				_s.addEventListener(SpreadsheetEvent.ROW_REMOVED, spreadsheetChangedHandler,false,0,true);
				_s.addEventListener(SpreadsheetEvent.COLUMN_INSERTED, spreadsheetChangedHandler,false, 0, true);
				_s.addEventListener(SpreadsheetEvent.COLUMN_REMOVED, spreadsheetChangedHandler,false, 0, true);
			
				maxColumnCount = Math.max(_s.maxEnteredX, maxColumnCount);
				maxRowCount = Math.max(_s.maxEnteredY, maxRowCount);
			}
			else
			{
				if (backgroundLayer) backgroundLayer.table = null;
				if (dataLayer) dataLayer.table = null;
				if (selectionLayer) selectionLayer.table = null;
				if (headerLayer) headerLayer.table = null;
				removeChild(backgroundLayer);
				removeChild(dataLayer);
				removeChild(selectionLayer);
				removeChild(headerLayer);
			}
			
		}
		private function spreadsheetChangedHandler(event:Event):void
		{
			invalidateAll();
		}
		private function tableResizeHandler(event:ResizeEvent):void
		{
			invalidateAll();
		}
		private function calculateLines(startZIndex:uint, zPos:Array, measureFunc:Function, max:int):void
		{
			var prevZ:int = 0;
			var i:uint = 0;
			while(prevZ < max)
			{
				var measured:int = measureFunc(i + startZIndex);
				var z:int = prevZ + measured;
				zPos[i++] = z;
				prevZ = z;
			}
			
		}
		private function calculateVisible(width:int, height:int):void
		{
			visibleColumnsCount = findIndexOfPoint(width, xPos);
			visibleRowsCount = findIndexOfPoint(height, yPos);
			visibleIndexRect.x = startXIndex;
			visibleIndexRect.y = startYIndex;
			visibleIndexRect.width = visibleColumnsCount;
			visibleIndexRect.height = visibleRowsCount;
			updateScrollBars();
		}
		private function findIndexOfPoint(z:int, zPos:Array):int
	    {
	    	for (var i:int = 0; i < zPos.length; i++)
	    	{
	    		if (zPos[i] > z) return i;
	    	}
	    	return zPos.length;
	    }
	    private function placeZ(zi:int, zPos:Array):int
		{
			if (zi > zPos.length) return zPos[zPos.length -1];
			if (zi > 0) return zPos[zi - 1]
			return 0;
		}
		private function buildStartRect(xi:uint, yi:uint):Rect
		{
			var r:Rect = new Rect;
			r.x = placeZ(xi - startXIndex, xPos) + 1;
			r.y = placeZ(yi - startYIndex, yPos) + 1;
			return r;
		}
	    public function buildCellRect(xi:uint, yi:uint, colSpan:int, rowSpan:int):Rect
	    {
			var r:Rect = buildStartRect(xi, yi);
			r.right = placeZ(xi - startXIndex + colSpan, xPos);
			r.bottom = placeZ(yi - startYIndex + rowSpan, yPos);
			return r;
	    }
	    public function buildSnappedCellRect(xi:uint, yi:uint, w:int):Rect
	    {
	    	var r:Rect = buildStartRect(xi, yi);
	    	var ri:uint = findIndexOfPoint(r.x + w,xPos) + startXIndex;
	    	var i:uint;
	    	if (ri != xi)
	    	{
		    	for (i = xi; i < ri; i++)
		    	{
		    		if (spreadsheet.getCellAt(i + 1, yi))
		    		{
		    			break;
		    		}
		    	}	
	    	}
	    	else
	    	{
	    		i = xi;
	    	}
	    	
	    	r.right = placeZ(i - startXIndex + 1,xPos);
	    	r.bottom = placeZ(yi - startYIndex + 1, yPos);
	    	return r;
	    }
	    public function mouseToIndex(event:MouseEvent):Pnt
	    {
	    	var p:Pnt = 
	    		new Pnt(findIndexOfPoint(event.localX,xPos) + startXIndex,
	    		 findIndexOfPoint(event.localY,yPos) + startYIndex);
	    	return p;
	    }
	    public function layoutRenderer(cr:CellRenderer, xi:uint, yi:uint):void
		{
			var r:Rect;
			if (cr.cell.colSpan > 1 || cr.cell.rowSpan > 1)
			{
				r = buildCellRect(xi, yi, cr.cell.colSpan, cr.cell.rowSpan);
			}
			else
			{
				r = buildSnappedCellRect(xi, yi, cr.textWidth);	
			}
			cr.x = r.x;
			cr.y = r.y;
			cr.width = r.width;
			cr.height = r.height;
		}
		public function layoutDisplayObject(displayObj:DisplayObject, xi:uint, yi:uint):void
		{
			var r:Rect = buildCellRect(xi, yi, 1, 1);
			displayObj.x = r.x;
			displayObj.y = r.y;
			displayObj.width = r.width;
			displayObj.height = r.height;
		}
		
		public function getCursorRenderer():CellRenderer
		{
			return getRendererAt(spreadsheet.startPnt);
		}
		public function getRendererAt(p:Pnt):CellRenderer
		{
			if (dataLayer) return dataLayer.getRendererAt(p);
			return  null;
		}
		override public function drawFocus(isFocused:Boolean):void
		{
		}
		
	}
}