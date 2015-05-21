// ActionScript file
import flash.net.URLRequestMethod;

import idubee.events.FileEvent;
import idubee.events.IdubeeMenuEvent;
import idubee.model.EditorCtx;
import idubee.model.Workspace;

import mx.events.MenuEvent;
[Bindable]
private var workspace:Workspace;

[Bindable]
private var editorCtx:EditorCtx;
private function creationHandler():void
{
	editorCtx = EditorCtx.ctx;
	workspace = editorCtx.workspace;
	editorCtx.editor = editorCanvas;
//	editorCtx.table = table;
	mainMenu.addEventListener(MenuEvent.ITEM_CLICK, menuItemClick);
	mainMenu.dataProvider = workspace.mainMenu;
	mainMenu.labelField = "@label";
	mainMenu.showRoot = false;
	new FileEvent(FileEvent.OPEN_NEW).dispatch();
}
private function menuItemClick(event:MenuEvent):void
{
	new IdubeeMenuEvent(IdubeeMenuEvent.MENU_CLICK, event.item).dispatch();
}