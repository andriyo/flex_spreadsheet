package idubee.view.table
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.effects.Fade;
	import mx.events.EffectEvent;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;

	public class ToolMarker extends Sprite
	{
		private var anime : Fade;
		private var cursorID:int = CursorManager.NO_CURSOR;
		private var selectionTool : SelectionTool;
				
		[Embed(source="/assets/img/crossHand.png")]
		private var crossHandCursor : Class;
		private var table:Table;
		
		public function ToolMarker(selectionTool : SelectionTool):void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMarkerMouseDown);
			addEventListener(MouseEvent.MOUSE_OVER, onMarkerMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMarkerMouseOut);
			
			selectionTool = selectionTool;
			table = selectionTool.selectionLayer.table;
			anime = new Fade(this);
			anime.addEventListener(EffectEvent.EFFECT_END, onAnimeEffectEnd);
			anime.alphaFrom = 0.1;
			anime.alphaTo = 1;
			anime.duration = 1000;
			anime.play();
		}
		
		private function onMarkerMouseDown(event : MouseEvent):void
		{
			trace("onMarkerMouseDown")
			addEventListener(MouseEvent.MOUSE_UP, onMarkerMouseUp);
		}
		
		private function onMarkerMouseUp(event : MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_UP, onMarkerMouseUp);
			trace("onMarkerMouseUp")
		}
		
		
		private function onMarkerMouseOver(event : MouseEvent):void
		{
			if (cursorID == CursorManager.NO_CURSOR)
			{
				cursorID = CursorManager.setCursor(crossHandCursor,
									   CursorManagerPriority.HIGH,
									   -8, -10);	
			}
			draw(0x0CFF00);
		}
		
		private function onMarkerMouseOut(event : MouseEvent):void
		{
			CursorManager.removeCursor(cursorID);
			cursorID = CursorManager.NO_CURSOR;
			draw();
		}
		
		private function onAnimeEffectEnd(event : EffectEvent):void
		{
			anime.play();	
		}
		public function draw(color:int = 0xFF0000):void
		{
			graphics.clear();
			graphics.lineStyle(2, 0);
			graphics.beginFill(color, 1);
			graphics.drawCircle(0, 0, 3);
			graphics.endFill();
		}
	}
}
