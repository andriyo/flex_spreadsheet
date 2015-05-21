package idubee.view.table
{
	import flash.display.CapsStyle;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import idubee.events.EditorEvent;
	import idubee.model.Pnt;
	
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;

	public class HeaderSlider extends Sprite
	{
		private var table:Table;
		public var index:uint;
		public var deltaIndex:Pnt;
		private var cursorID:int = CursorManager.NO_CURSOR;
		
		[Embed(source="/assets/img/splith.png")]
		private var splitVerticalCursor : Class;
		
		[Embed(source="/assets/img/splitv.png")]
		private var splitHorizontalCursor : Class;
		
		public function HeaderSlider(table:Table)
		{
			super();
			this.table = table;
			buttonMode = true;
			useHandCursor = true;
			doubleClickEnabled = true;
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClickHandler);
		}
		private function mouseDoubleClickHandler(event:MouseEvent):void
		{
			var e:EditorEvent = new EditorEvent(EditorEvent.AUTOSIZE);
			if (deltaIndex.x)
			{
				e.autoSizeType = EditorEvent.AUTOSIZE_TYPE_COLUMN;
			}	
			else
			{
				e.autoSizeType = EditorEvent.AUTOSIZE_TYPE_ROW;
			}
			e.autoSizeIndex = index;
			e.dispatch();
		}
		private function mouseDownHandler(event:MouseEvent):void
		{
			table.headerLayer.startSliderDrag(this, event);
		}
		private function mouseOverHandler(event:MouseEvent):void
		{
			var cursorClass:Class;
			if (deltaIndex.x == 1)
			{
				if (cursorID == CursorManager.NO_CURSOR)
				{
					cursorClass = splitVerticalCursor;
					cursorID = CursorManager.setCursor(cursorClass, CursorManagerPriority.HIGH, -8, -10);
				}
			}
			if (deltaIndex.y == 1)
			{
				if (cursorID == CursorManager.NO_CURSOR)
				{
					cursorClass = splitHorizontalCursor;
					cursorID = CursorManager.setCursor(cursorClass, CursorManagerPriority.HIGH, -8, -10);
				}
			}
		}
		private function mouseOutHandler(event:MouseEvent):void
		{
			if (cursorID != CursorManager.NO_CURSOR)
			{
				CursorManager.removeCursor(cursorID);
				cursorID = CursorManager.NO_CURSOR;
			}
		}
		
		public function draw(deltaIndex:Pnt, size:int):void
		{
			graphics.clear();
			var p:Point = new Point(deltaIndex.y, deltaIndex.x);
			p.normalize(size);
			graphics.moveTo(0,0);
			graphics.lineStyle(7,0, 0, true, "normal", CapsStyle.NONE);
			graphics.lineTo(p.x,p.y);
			graphics.moveTo(0,0);
			graphics.lineStyle(1, table.workbook.neutralColor);
			graphics.lineTo(p.x,p.y);
			this.deltaIndex = deltaIndex;
		}
	}
}