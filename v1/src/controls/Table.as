package controls
{
	import controls.selectionClasses.*;
	import controls.tableClasses.*;
	
	import flash.display.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import model.FormulaEngine;
	import model.Spreadsheet;
	import model.SpreadsheetEvent;
	
	import mx.core.*;
	import mx.events.ResizeEvent;
	import mx.events.ScrollEvent;
	import mx.managers.IFocusManagerComponent;
	
	public class Table extends ScrollControlBase implements IFocusManagerComponent
	{
		public var _defaultRowHeight:Number;
		public var _defaultColumnWidth:Number;
		public var defaultColumnCount:Number;
		public var defaultRowCount:Number;
		public var backgroundColor:Number;
		public var linesColor:Number;
		public var topRowIndex:int;
		public var leftColumnIndex:int;
		private var m:Spreadsheet;
	    private var renderersToDataMap:Dictionary;
	    private var _dataProvider:Object;
	    private var _itemRenderersCache:IMatrix;
	    public var selectionLayer : EditLayer;
   		public var visibleRowsCount:int;
		public var visibleColumnsCount:int;
		private var _itemRenderer:IFactory;
		private var dataProviderChanged:Boolean;
		public var contentHolder:TableContentHolder;
		private var background:Shape;
		public var xPoints : Array;
		public var yPoints : Array;
		
   		protected var explicitRowCount:Number;
		protected var explicitColumnCount:Number;
		public var currentRenderer:UITextField;
		private var formulaEngine:FormulaEngine;
		
		private var clipboardSpreadSheet : Spreadsheet;
		private var clipboardRectangle : Rectangle;
	    
		public function Table()
		{
			dataProvider = new Spreadsheet(100, 100);
			explicitColumnCount = defaultColumnCount = 100;
			explicitRowCount = defaultRowCount = 100;
			_defaultColumnWidth = 80;
			_defaultRowHeight = 20;
			backgroundColor = 0xffffff;
			linesColor = 0xaaaaaa;
			horizontalScrollPolicy="auto";
			itemRenderer = new ClassFactory(TableItemEditor);
			topRowIndex = 0;
			leftColumnIndex = 0;
			addEventListener(ScrollEvent.SCROLL, tableScrollHandler);
			addEventListener(ResizeEvent.RESIZE, tableResizeHandler);
			addEventListener(TableEvent.ITEM_EDIT_END, tableEditEndHandler, true);
			//m.addEventListener(SpreadsheetEvent.CHANGED, onSpreadSheetChanged, true)
			//addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		}
		private function valueChanged(event:SpreadsheetEvent):void
		{
			invalidateDisplayList();
		}
		private function tableEditEndHandler(event:TableEvent):void
		{
			invalidateDisplayList();
		}
		private function tableResizeHandler(event:ResizeEvent):void
		{
			invalidateDisplayList();
		}
		
		public function tableScrollHandler(event:ScrollEvent):void
		{
			if (verticalScrollPosition < 0) verticalScrollPosition = 0;
			if (horizontalScrollPosition < 0) horizontalScrollPosition = 0;
			topRowIndex = selectionLayer.topRowIndex =  verticalScrollPosition;
			leftColumnIndex = selectionLayer.leftColumnIndex = horizontalScrollPosition;
			invalidateDisplayList();
			selectionLayer.invalidateDisplayList();
			UIComponent(parent).invalidateDisplayList();
//			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, true));
		}
		
		public function set dataProvider(value:Object):void
		{
			_dataProvider = value;
			dataProviderChanged = true;
			m = Spreadsheet(_dataProvider);
			m.addEventListener(SpreadsheetEvent.CHANGED, valueChanged);
			m.addEventListener(SpreadsheetEvent.FORMULA_CHANGED, valueChanged);
			m.addEventListener(SpreadsheetEvent.SORTED, valueChanged);
			formulaEngine = new FormulaEngine(m);
			invalidateProperties();
			invalidateDisplayList();
		}
		
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		override protected function createChildren():void
		{
			super.createChildren();
			contentHolder = new TableContentHolder(this);
			addChild(contentHolder);
			selectionLayer = new EditLayer(this);
			addChild(selectionLayer);
		}
		private var itemRendererChanged:Boolean = true;
		public function set itemRenderer(value:IFactory):void
		{
			_itemRenderer = value;
			itemRendererChanged = true;
			invalidateProperties();	
		}
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		override protected function commitProperties():void
		{
			super.commitProperties();
			if (dataProviderChanged)
			{
				dataProviderChanged = false;
				itemRendererChanged = true;// hack
				selectionLayer.updateDataProvider();
			}
			if (itemRendererChanged)
			{
				itemRendererChanged = false;
				if (!_itemRenderersCache)
				{
					_itemRenderersCache =new SparseMatrix(m.rowsCount, m.columnsCount);
				}
			}
			
		}
		override protected function measure():void
	    {
	        super.measure();
			measuredHeight = explicitRowCount * _defaultRowHeight;
			measuredWidth = explicitColumnCount * _defaultColumnWidth;
	    }
	    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	    {
	    	super.updateDisplayList(unscaledWidth, unscaledHeight);
	    	var w:int = maskShape.width;
	    	var h:int = maskShape.height;
	    	
	    	clearBackgound(w, h);    	
	    	drawGrid(w, h);
	    	renderData(w, h);
	    	setClipping(w, h);
	    }
	    private function clearBackgound(width:Number, height:Number):void
	    {
	    	if (!background)
	    	{
	    		background = new Shape;
	            contentHolder.addChildAt(background, 0);
	    	}
	    	var g:Graphics = background.graphics;
	    	g.clear();
	        g.beginFill(backgroundColor, 1);
	        g.lineStyle(1,0xcccccc);
	        g.drawRect(0, 0, width, height);
	        g.endFill();
	    }
	    
	    private function drawGrid(width:Number, height:Number):void
	    {
	    	var g:Graphics = background.graphics;
	    	var prevX : int = 0;
	    	var prevY : int = 0;
	        g.lineStyle(1,0xAAAAAA);
			visibleColumnsCount = 0;
			visibleRowsCount = 0;
			xPoints = new Array();
			yPoints = new Array();
			
			for (var iV:int = 0; iV < m.rowsCount; iV++)
			{
				var columnWidth : int = getColumnWidth(iV+leftColumnIndex);
				var Vx : int = prevX + columnWidth;
				xPoints.push(Vx);
				if (Vx > width) break;
				prevX = Vx;
				g.moveTo(Vx, 0);
				g.lineTo(Vx, height);
				visibleColumnsCount++;
			}			
			for (var iH:Number = 0; iH < m.columnsCount; iH++)
			{
				var rowHeigth : int = getRowHeigth(iH+topRowIndex);
				var Vy : int = prevY + rowHeigth;
				yPoints.push(Vy);				
				if (Vy > height) break;
				prevY = Vy;
				g.moveTo(0, Vy);
				g.lineTo(width, Vy);
				visibleRowsCount++;
			}
			setScrollBarProperties(m.columnsCount,visibleColumnsCount, m.rowsCount, visibleRowsCount);
	    }
	    private function setClipping(width:Number, heigth:Number):void
	    {
	    	var visibleContentRect:Rectangle = contentHolder.scrollRect;
	    	visibleContentRect.width = width;
	    	visibleContentRect.height = heigth;
	    	contentHolder.scrollRect = visibleContentRect;
	    	selectionLayer.scrollRect = visibleContentRect;
	    	selectionLayer.setActualSize(width, heigth);
	    }
	    private function renderData(width:Number, heigth:Number):void
	    {
	    	var ix:int;
	    	var iy:int;
	    	var x:int;
	    	var y:int;
	    	var item:Object;
	    	var data:String;
	    	var actualWidth:int;
	    	var actualHeight:int;
	    	if (!_dataProvider) return;
	    	hideRenderers();
	    	for (var xi:int = leftColumnIndex; xi<=leftColumnIndex+visibleColumnsCount;xi++)
	    	{
	    		x = (xi - leftColumnIndex > 0) ? xPoints[xi - leftColumnIndex - 1] : 0;
				actualWidth = xPoints[xi - leftColumnIndex] - x;
	    		for (var yi:int = topRowIndex; yi<=topRowIndex+visibleRowsCount;yi++)
	    		{
	    			data = m.getTextValueAt(xi,yi);
	    			if (!data) continue;
	    			
	    			y = (yi - topRowIndex > 0) ? yPoints[yi - topRowIndex - 1] : 0
	    			item = getRenderer(yi - topRowIndex, xi - leftColumnIndex);
	    			item.move(x+1,y+1);
	    			item.text = data;
	    			
	    			FormatUtils.applyStyle(Spreadsheet(dataProvider), xi, yi, UITextField(item));
	    			UITextField(item).validateNow();
	    			var format:int = m.getFormatAt(xi,yi);
	    			actualWidth = FormatUtils.formatValue(format, UITextField(item), actualWidth,
	    							getTextFieldWidth(x,UITextField(item), format));
							    			
	    			actualHeight = yPoints[yi - topRowIndex] - y;
					item.setActualSize(actualWidth - 1,actualHeight - 1);
					var tableData:TableData = new TableData;
					tableData.columnIndex = xi;
					tableData.rowIndex = yi;
					tableData.owner = this;
					tableData.label = data.toString();
					IDropInTableRenderer(item).tableData = tableData;
					
	    		}
	    	}
	    }
	    public function getTextFieldWidth(x:int, item:UITextField, format:int):int
	    {
	    	var eX:int;
	    	if (format == Spreadsheet.FORMAT_NUMBER)
	    	{
	    		eX = 1;
	    	}
	    	else
	    	{
	    		eX = item.getExplicitOrMeasuredWidth() + 8;
	    	}
			var eXi:int = findIndexOfPoint(x + eX, xPoints);
			return xPoints[eXi] - x;
	    }
	    public function getColumnWidth(xi : int):int
	    {
			var w:int = m.getColumnWidth(xi);
	    	if (w == -1) return _defaultColumnWidth;
	    	return w;	    
	    }
	    
	    public function getRowHeigth(yi : int):int
	    {
	    	var h:int = m.getRowHeigth(yi);
	    	if (h == -1) return _defaultRowHeight;
	    	return h;
	    }
	    
	    public function mouseToDataPoint(mouseX:int, mouseY:int):Point
	    {	    	
	    	return new Point(findIndexOfPoint(mouseX, xPoints), 
	    					findIndexOfPoint(mouseY, yPoints));	
	    }
	    public function findIndexOfPoint(a:int, points:Array):int
	    {
	    	for (var i:int; i < points.length; i++)
	    	{
	    		if (points[i]>=a) return i;
	    	}
	    	return points.length;
	    }
	    
	    public function isRendererInPosition(rowIndex : int, columnIndex : int):Boolean
	    {
	    	var item : DisplayObject = DisplayObject(_itemRenderersCache.getValueAt(columnIndex, rowIndex));
	    	
	    	return !!item;
	    	
	    }
	    
	    public function getRenderer(rowIndex:int, columnIndex:int):Object
	    {
	    	var item:DisplayObject = DisplayObject(_itemRenderersCache.getValueAt(columnIndex, rowIndex));
	    	if (!item)
	    	{
	    		item = DisplayObject(_itemRenderersCache.setValueAt
	    			(columnIndex, rowIndex, itemRenderer.newInstance()));
	    		contentHolder.addChild(item);
	    	}
	    	item.visible = true;
	    	return item;
	    }
	    private function hideRenderers():void
	    {
	    	for (var x:int = 0; x < _itemRenderersCache.columnsCount; x ++)
	    	{
	    		for (var y:int = 0 ; y < _itemRenderersCache.rowsCount; y++)
	    		{
	    			var obj:Object = _itemRenderersCache.getValueAt(x, y);
	    			if (obj)
	    			{
	    				DisplayObject(obj).visible = false;
	    			}
	    		}
	    	}
	    }
	    override public function drawFocus(isFocused:Boolean):void
	    {
	    	
	    }
	    
	    private function onSpreadSheetChanged(event : SpreadsheetEvent):void
	    {
	    	invalidateDisplayList();
	    }
	    
	    public function doCopy():void
		{
			// m - SpreadSheet
			var x1 : int = selectionLayer._startColIndex;
			var x2 : int = selectionLayer._endColIndex;
			var y1 : int = selectionLayer._startRowIndex;
			var y2 : int = selectionLayer._endRowIndex;
			
			clipboardRectangle = Utils.makeRect(x1, y1, x2, y2); 
			clipboardSpreadSheet = m.getSubSpreadSheet(clipboardRectangle);
		}
		
		public function doPaste():void
		{
			m.setSubSpreadSheet(selectionLayer._startColIndex, selectionLayer._startRowIndex, clipboardSpreadSheet);
						
			invalidateDisplayList();
		}
		
		public function doCut():void
		{
			// m - SpreadSheet
			var x1 : int = selectionLayer._startColIndex;
			var x2 : int = selectionLayer._endColIndex;
			var y1 : int = selectionLayer._startRowIndex;
			var y2 : int = selectionLayer._endRowIndex;
			
			clipboardRectangle = Utils.makeRect(x1, y1, x2, y2); 
			clipboardSpreadSheet = m.getSubSpreadSheet(clipboardRectangle);
			m.remove(clipboardRectangle);
			invalidateDisplayList();
		}
		
		public function doDelete():void
		{
			m.remove(Utils.makeRect(selectionLayer._startColIndex, selectionLayer._startRowIndex,
										selectionLayer._endColIndex, selectionLayer._endRowIndex));
			invalidateDisplayList();							
		}	
	}
}
