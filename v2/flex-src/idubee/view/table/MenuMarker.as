package idubee.view.table
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import mx.core.Application;

	public class MenuMarker extends Sprite
	{
		private var editorContextMenu : ContextMenu;
		
		public function MenuMarker():void
		{
			var shadow : DropShadowFilter = new DropShadowFilter();
			shadow.alpha = .5;
			shadow.distance = 3;
			shadow.angle = 25;
			
			filters = [shadow];
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverMenuMarker);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutMenuMarker);
			addEventListener(MouseEvent.CLICK, mouseClickMenuMarker);
		}
		
		public function drawMenuMarker(color : int = 0x5E8FB2):void
		{
			graphics.clear();
			graphics.lineStyle(1, 0xB7BABC, 1, true);
			graphics.beginFill(color, .9); 
			graphics.drawRoundRectComplex(5, 5, 10, 10, 0, 2, 2, 0);
			graphics.endFill();
		}
		
		private function mouseOverMenuMarker(event : MouseEvent):void
		{
			drawMenuMarker(0x1C73B0);
		}
		
		private function mouseOutMenuMarker(event : MouseEvent):void
		{
			drawMenuMarker();
		}
		
		private function mouseClickMenuMarker(event : MouseEvent):void
		{
			if (!editorContextMenu)
			{
				editorContextMenu = ContextMenu.createMenu(DisplayObjectContainer(Application.application), false);
			}
			
			editorContextMenu.show(event.stageX, event.stageY);
		}
		
		
		
	}
}