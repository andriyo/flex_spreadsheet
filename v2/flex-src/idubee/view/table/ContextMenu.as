package idubee.view.table
{
	import flash.display.DisplayObjectContainer;
	
	import idubee.events.EditorEvent;
	import idubee.model.EditorCtx;
	
	import mx.controls.Menu;
	import mx.core.Application;
	import mx.events.MenuEvent;

	public class ContextMenu extends Menu
	{
		public static function createMenu(parent:DisplayObjectContainer, showRoot:Boolean=true):ContextMenu
	    {
	    	var ctx:EditorCtx = EditorCtx.ctx;
	        var menu : ContextMenu = new ContextMenu();
	        menu.addEventListener(MenuEvent.ITEM_CLICK, menu.menuItemClickHandler);
	        menu.owner = DisplayObjectContainer(Application.application);
	        popUpMenu(menu, parent, ctx.editorMenu);
	        return menu;
	    }
	    private function menuItemClickHandler(event:MenuEvent):void
	    {
	    	new EditorEvent(event.item.eventType).dispatch();
	    }
	}
}