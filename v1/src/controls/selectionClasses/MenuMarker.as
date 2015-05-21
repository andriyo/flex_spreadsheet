package controls.selectionClasses
{
	import controls.Table;
	import controls.forms.MenuContext;
	
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import mx.core.Application;
	import mx.core.FlexSprite;
	import mx.managers.PopUpManager;

	public class MenuMarker extends FlexSprite
	{
		private var menuPosX : int;
		private var menuPosY : int;
		private var menuContextPopUp : MenuContext;
		public var table : Table;
		
		public function MenuMarker():void
		{
			var shadow:DropShadowFilter = new DropShadowFilter();
			shadow.alpha = .5;
			shadow.distance = 3;
			shadow.angle = 25;
			
			filters = [shadow];
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverMenuMarker);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutMenuMarker);
			addEventListener(MouseEvent.CLICK, mouseClickMenuMarker);
		}	
		
		public function drawMenuMarker(x : int, y : int):void
		{
			menuPosX = x + 5;
			menuPosY = y + 5;
			
			graphics.clear();
			graphics.lineStyle(1, 0xB7BABC, 1, true);
			graphics.beginFill(0x5E8FB2, .9); 
			graphics.drawRoundRectComplex(menuPosX, menuPosY, 10, 10, 0, 2, 2, 0);
			graphics.endFill();
		}
		
		private function mouseOverMenuMarker(event : MouseEvent):void
		{
			graphics.clear();
			graphics.lineStyle(1, 0xB7BABC, 1, true);
			graphics.beginFill(0x1C73B0, 1);
			graphics.drawRoundRectComplex(menuPosX, menuPosY, 10, 10, 0, 2, 2, 0);
			graphics.endFill();
		}
		
		private function mouseOutMenuMarker(event : MouseEvent):void
		{
			graphics.clear();
			graphics.lineStyle(1, 0xB7BABC, 1, true);
			graphics.beginFill(0x5E8FB2, .9);
			graphics.drawRoundRectComplex(menuPosX, menuPosY, 10, 10, 0, 2, 2, 0);
			graphics.endFill();
		}
		
		private function mouseClickMenuMarker(event : MouseEvent):void
		{
			menuContextPopUp = new MenuContext();
			menuContextPopUp.table = table;
			menuContextPopUp.addEventListener("mouseDownOutside", mouseDownOutSideMenuPopUp);
			PopUpManager.addPopUp(menuContextPopUp, Application.application.parentDocument, false);
			positionateMenuContext(event.stageX, event.stageY);
			menuContextPopUp.visible = true;
		}
		
		private function mouseDownOutSideMenuPopUp(event : MouseEvent):void
		{
			menuContextPopUp.visible = false;
		}
		
		private function positionateMenuContext(x : int, y : int):void
		{
			if (y + menuContextPopUp.height >= table.y + table.height) y -= menuContextPopUp.height;
	    	
	    	if (x + menuContextPopUp.width >= table.x + table.width)
	    	{
	    		menuContextPopUp.move(x - menuContextPopUp.width - 10, y);
	    		
	    	} else {
	    		
	    		menuContextPopUp.move(x + 10, y);
	    	}	
		}	
	}
}