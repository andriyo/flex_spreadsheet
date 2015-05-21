package idubee.view.table
{
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import idubee.model.ExtTextFormat;
	import idubee.model.Pnt;
	import idubee.model.Rect;
	import idubee.model.Spreadsheet;
	
	import mx.core.UIComponent;

	public class HeaderRenderer extends UIComponent
	{
		private var table:Table;
		private var _selected:Boolean;
		private static var headerTextFormat:TextFormat;

		public var deltaIndex:Pnt;
		public var index:uint;
		public var textField:TextField;
		private var selectionDeltaIndex:Pnt;
		
		private static const BASE_COLOR : uint = 0xFFFFFF;
		
		private static const BASE_OVER : uint = 0x990000;
		
		private static const SELECTED_COLOR : uint = 0x111111;
		
		private static const SELECTED_OVER : uint = 0x009900;
		
		public function HeaderRenderer(table:Table)
		{
			super();
			this.table = table;
			mouseEnabled = true;
			mouseChildren = false;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}
		
		private function mouseOverHandler(event : MouseEvent) : void {
			var color : uint = HeaderRenderer.BASE_OVER;
			if(_selected){
				color = HeaderRenderer.SELECTED_OVER;
			}
			renderSelection(true, width, height, color);
		}
		
		private function mouseOutHandler(event : MouseEvent) : void {
			var color : uint = HeaderRenderer.BASE_COLOR;
			if(_selected){
				color = HeaderRenderer.SELECTED_COLOR;
			}
			renderSelection(true, width, height, color);
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			startSelection(event);	
		}
		
		private function startSelection(event:MouseEvent):void
		{
			var s:Spreadsheet = table.spreadsheet;
			
			if (!event.shiftKey)
			{
				s.startPnt = deltaIndex.clonePnt();
				s.startPnt.normalize(index);
				s.endPnt = s.startPnt.clonePnt();
			}
			else
			{
				s.endPnt = deltaIndex.clonePnt();
				s.endPnt.normalize(index);
			}
			if (deltaIndex.x > 0) s.endPnt.y = s.maxY;
			if (deltaIndex.y > 0) s.endPnt.x = s.maxY;
			if (!event.ctrlKey)
			{
				s.selections.length = 0;
			}
			selectionDeltaIndex = deltaIndex;
			table.selectionLayer.selectionMode = true;
			table.selectionLayer.invalidateDisplayList();
			table.headerLayer.invalidateDisplayList();
			systemManager.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true, 0, true);
			systemManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true, 0, true);
		}
		private function stopSelection():void
		{
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
		}
		private function mouseUpHandler(event:MouseEvent):void
		{
			var s:Spreadsheet = table.spreadsheet;
			var sel:Rect = s.makeCurrentSelectionRect().swap();
			s.selections.push(sel);
			stopSelection();
			table.selectionLayer.selectionMode = false;
			table.selectionLayer.invalidateDisplayList();
			table.headerLayer.invalidateDisplayList();
		}
		private function mouseMoveHandler(event:MouseEvent):void
		{
			var s:Spreadsheet = table.spreadsheet;
			var p:Pnt;
			if (event.target is SelectionLayer)
			{
				p = table.mouseToIndex(event);
			} 
			else if (event.target is HeaderRenderer)
			{
				p = selectionDeltaIndex.clonePnt();
				p.normalize(HeaderRenderer(event.target).index);
			}
			else
			{
				return;
			}
			if (selectionDeltaIndex.x > 0 && s.endPnt.x == p.x) return;
			if (selectionDeltaIndex.y > 0 && s.endPnt.y == p.y) return;
			if (selectionDeltaIndex.x > 0) s.endPnt.x = p.x;
			if (selectionDeltaIndex.y > 0) s.endPnt.y = p.y;
			table.selectionLayer.invalidateDisplayList();
			table.headerLayer.invalidateDisplayList();
		}

		override protected function createChildren():void
		{
			if (!headerTextFormat)
			{
				var tf:ExtTextFormat = table.workbook.defaultTextStyle;
				headerTextFormat = tf.clone();
				headerTextFormat.align = "center";
			}
			textField = new TextField;
			textField.selectable = false;
			
			addChild(textField);
			textField.defaultTextFormat = headerTextFormat;
			textField.setTextFormat(headerTextFormat);
			textField.x = 0;
			textField.y = 0;
		}

		public function set selected(value:Boolean):void
		{
			if (_selected == value) return;
			_selected = value;
			invalidateDisplayList();
		}
		public function get selected():Boolean
		{
			return _selected;
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			textField.width = unscaledWidth;
			textField.height = unscaledHeight;
			textField.y = (unscaledHeight - textField.textHeight)/2;
			renderSelection(_selected, unscaledWidth, unscaledHeight, HeaderRenderer.SELECTED_COLOR);
		}

		public function renderSelection(selected:Boolean, w:int, h:int, color : uint):void
		{
			graphics.clear();
			if (selected)
			{
				var matr:Matrix = new Matrix();
				var rotation : Number; 
				if (deltaIndex.x == 1) rotation = 0;
				if (deltaIndex.y == 1) rotation = Math.PI/2;
				matr.createGradientBox(w, h, rotation, 0, 0);
				var ratios:Array = [0, 255];
				graphics.beginGradientFill(GradientType.LINEAR, [color, 0xFFFFFF], [0, 1], ratios, matr, SpreadMethod.PAD);
				graphics.drawRect(0, 0, w, h);
			}
		}
	}
}