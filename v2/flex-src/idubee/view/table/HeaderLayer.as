package idubee.view.table
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import idubee.model.Pnt;
	import idubee.model.Rect;
	import idubee.model.Spreadsheet;
	
	import mx.core.UIComponent;
	
	public class HeaderLayer extends BaseLayer
	{
		private var headersHolder:UIComponent;
		private var slidersHolder:UIComponent;
		private var measureTextField:TextField;
		private var headerRenderersCache:Array;
		private var used:Array;
		private var usedSliders:Array;
		private var sliderCache:Array;
		private var activeIndex:uint;
		public var activeDrag:Boolean;
		private var activeSlider:HeaderSlider;
		private var sliderStartPosition:int;
		private var sliderPosition:int;
		private var dragDelta:int;
		
		public function HeaderLayer(table:Table)
		{
			super(table);
			mouseChildren = true;
			headerRenderersCache = [];
			used = [];
			usedSliders = []
			sliderCache = [];
		}
		override protected function createChildren():void
		{
			headersHolder = new UIComponent;
			addChild(headersHolder);
			slidersHolder = new UIComponent;
			slidersHolder.mouseEnabled = true;
			addChild(slidersHolder);
		}
		public function measureLeftHolderWidth():int
		{
			if (!measureTextField) measureTextField = new TextField();
			measureTextField.text = (table.visibleIndexRect.bottom + 1).toString();
			measureTextField.setTextFormat(table.workbook.defaultTextStyle);
			return measureTextField.textWidth +5;
		}
		public function measureTopHolderHeight():int
		{
			if (!measureTextField) measureTextField = new TextField();
			measureTextField.text = "ABC";
			measureTextField.setTextFormat(table.workbook.defaultTextStyle);
			return measureTextField.textHeight +4;
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (!table) return;
			if (!table.workbook) return;
			headerRenderersCache = headerRenderersCache.concat(used);
			sliderCache = sliderCache.concat(usedSliders);
			for each (var hr:HeaderRenderer in headerRenderersCache)
			{
				hr.visible = false;
			}
			for each (var hs:HeaderSlider in sliderCache)
			{
				hs.visible = false;
			}
			used = [];
			usedSliders = [];
			var vr:Rect = table.visibleIndexRect;
			var sh:int = measureTopHolderHeight();
			var sw:int = measureLeftHolderWidth();
			renderLine(sw, 0, new Pnt(1,0),table.spreadsheet.getColumnWidth, sh,
				vr.x, vr.right, Pnt.num2abc);
			renderLine(0, sh, new Pnt(0,1),table.spreadsheet.getRowHeight, sw,
				vr.y, vr.bottom, labelNum);
		}
		private function renderLine(x:int, y:int, deltaIndex:Pnt, 
		sizeFunc:Function, otherSize:int, startIndex:uint, endIndex:uint, labelFunc:Function):void
		{
			var r:Rect = new Rect(x,y);
			for (var i:uint = startIndex; i <= endIndex; i++)
			{
				var shiftVector:Point = deltaIndex.clone();
				shiftVector.normalize(sizeFunc(i)); 
				r.width = shiftVector.x;
				r.height = shiftVector.y;
				var nt:String = labelFunc(i);
				var hr:HeaderRenderer = HeaderRenderer(fetchRenderer(headerRenderersCache, HeaderRenderer, headersHolder));
				hr.deltaIndex = deltaIndex;
				hr.index = i;
				hr.textField.text = nt;
				hr.x = r.x;
				hr.y = r.y;
				hr.setActualSize(r.width > 0 ? r.width : otherSize, r.height > 0 ? r.height : otherSize);
				var selectionVector:Pnt = deltaIndex.clonePnt();
				selectionVector.normalize(i);
				if (deltaIndex.x == 0) selectionVector.x = -1;
				if (deltaIndex.y == 0) selectionVector.y = -1;
				hr.selected = table.spreadsheet.vectorHasSelection(selectionVector);
				var hs:HeaderSlider = HeaderSlider(fetchRenderer(sliderCache, HeaderSlider,slidersHolder));
				hs.index = i;
				hs.x = deltaIndex.x > 0 ? r.right : 0;
				hs.y = deltaIndex.y > 0 ? r.bottom : 0;
				hs.draw(deltaIndex,otherSize);
				r.x += shiftVector.x;
				r.y += shiftVector.y;
				used.push(hr);
				usedSliders.push(hs);
			}
		}
		private function labelNum(n:uint):String
		{
			return (n + 1).toString();
		}
		private function fetchRenderer(cache:Array, clazz:Class, holder:UIComponent):Object
		{
			var r:Object;
			if (cache.length)
			{
				r = cache.pop();
			}
			else
			{
				r = new clazz(table);
				holder.addChild(DisplayObject(r));
			}
			r.visible = true;
			return r;
		}
		public function startSliderDrag(slider:HeaderSlider, event:MouseEvent):void
		{
			if (activeDrag) return;
			activeDrag = true;
			activeSlider = slider;
			activeIndex = slider.index;
			sliderStartPosition = slider.deltaIndex.x * slider.x + slider.deltaIndex.y * slider.y;
			sliderPosition = getMousePosition(slider,event);
			dragDelta = 0;
			systemManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
			systemManager.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
		}
		private function getMousePosition(slider:HeaderSlider, event:MouseEvent):Number
		{
	        var point:Point = new Point(event.stageX, event.stageY);
	        point = globalToLocal(point);
			return slider.deltaIndex.x * point.x + slider.deltaIndex.y * point.y;
		}
		public function mouseMoveHandler(event:MouseEvent):void
		{
			dragDelta = getMousePosition(activeSlider, event) - sliderPosition;
			activeSlider.x = (sliderStartPosition + dragDelta) * activeSlider.deltaIndex.x;
			activeSlider.y = (sliderStartPosition + dragDelta) * activeSlider.deltaIndex.y;
			
		}
		public function mouseUpHandler(event:MouseEvent):void
		{
			stopSliderDrag(activeSlider, event);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
		}
		public function stopSliderDrag(slider:HeaderSlider, event:MouseEvent):void
		{
			dragDelta = getMousePosition(activeSlider, event) - sliderPosition;
			if (Math.abs(dragDelta) > 0)
			{
				var s:Spreadsheet = table.spreadsheet;
				var currentSize:int = activeSlider.deltaIndex.x * s.getColumnWidth(activeIndex)+
									activeSlider.deltaIndex.y * s.getRowHeight(activeIndex)	;
				if (activeSlider.deltaIndex.x) s.setColumnWidth(activeIndex, Math.max(2,currentSize + dragDelta));
				if (activeSlider.deltaIndex.y) s.setRowHeight(activeIndex, Math.max(2,currentSize + dragDelta));
			}
			activeSlider = null;
			activeIndex = 0;
			activeDrag = false;
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
		}

	}
}