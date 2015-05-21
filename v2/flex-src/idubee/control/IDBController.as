package idubee.control
{
	import com.adobe.cairngorm.control.FrontController;
	
	import idubee.commands.AddressBarCommand;
	import idubee.commands.EditorCommand;
	import idubee.commands.FileCommand;
	import idubee.commands.FindCommand;
	import idubee.commands.KeyEditorCommand;
	import idubee.commands.LoginCommand;
	import idubee.commands.MenuCommand;
	import idubee.commands.OptionsCommand;
	import idubee.commands.SelectCommand;
	import idubee.commands.TextFormatCommand;
	import idubee.commands.TypeInCommand;
	import idubee.commands.WorkbookCommand;
	import idubee.events.AddressBarEvent;
	import idubee.events.EditorEvent;
	import idubee.events.FileEvent;
	import idubee.events.FindEvent;
	import idubee.events.IdubeeMenuEvent;
	import idubee.events.KeyEditorEvent;
	import idubee.events.LoginEvent;
	import idubee.events.OptionsEvent;
	import idubee.events.SelectionEvent;
	import idubee.events.TextFormatEvent;
	import idubee.events.TypeInEvent;
	import idubee.events.WorkbookEvent;
	import idubee.model.EditorCtx;
	import idubee.model.ServerCtx;
	import idubee.model.TextFormatCtx;
	
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class IDBController extends FrontController
	{
		public function IDBController()
		{
			init();
			Application.application.addEventListener(FlexEvent.APPLICATION_COMPLETE, initServer);
		}
		private function init():void
		{
			addModel(EditorCtx.MODEL_NAME, EditorCtx);
			addModel(TextFormatCtx.MODEL_NAME, TextFormatCtx);
			addCommand(FileEvent.OPEN_NEW, FileCommand);
			addCommand(FileEvent.OPEN_FILE, FileCommand);
			addCommand(FileEvent.OPEN_URL, FileCommand);
			addCommand(FileEvent.SAVE_LOCAL, FileCommand);
			addCommand(OptionsEvent.OPEN_OPTIONS, OptionsCommand);
			addCommand(OptionsEvent.CLOSE_OPTIONS, OptionsCommand);
			addCommand(FileEvent.CLOSE_FILE, FileCommand);
			addCommand(LoginEvent.LOGIN, LoginCommand);
			addCommand(LoginEvent.OPEN_LOGIN, LoginCommand);
			addCommand(LoginEvent.CLOSE_LOGIN, LoginCommand);
			addCommand(KeyEditorEvent.HOTKEY_PRESSED, KeyEditorCommand);
			addCommand(EditorEvent.COPY, EditorCommand);
			addCommand(EditorEvent.PASTE, EditorCommand);
			addCommand(EditorEvent.AUTOSIZE, EditorCommand);
			addCommand(EditorEvent.CUT, EditorCommand);
			addCommand(EditorEvent.DELETE, EditorCommand);
			addCommand(EditorEvent.CELL_PROPERTIES, EditorCommand);
			addCommand(TextFormatEvent.FORMAT_CHANGED, TextFormatCommand);
			addCommand(TextFormatEvent.TEXTFIELD_CHANGED, TextFormatCommand);
			addCommand(TextFormatEvent.CARET_POSITION_CHANGED, TextFormatCommand);
			addCommand(IdubeeMenuEvent.MENU_CLICK, MenuCommand);
			addCommand(EditorEvent.INSERT_ROW, EditorCommand);
			addCommand(EditorEvent.REMOVE_ROW, EditorCommand);
			addCommand(EditorEvent.INSERT_COLUMN, EditorCommand);
			addCommand(EditorEvent.REMOVE_COLUMN, EditorCommand);
			addCommand(WorkbookEvent.ADD_SHEET, WorkbookCommand);
			addCommand(WorkbookEvent.REMOVE_SHEET, WorkbookCommand);
			addCommand(WorkbookEvent.SELECT_SHEET, WorkbookCommand);
			addCommand(WorkbookEvent.SWAP_SHEETS, WorkbookCommand);
			addCommand(FindEvent.SHOW_FIND, FindCommand);
			addCommand(FindEvent.FIND, FindCommand);
			addCommand(FindEvent.SHOW_FIND_ALL, FindCommand);
			addCommand(FindEvent.CLOSE_FIND_ALL, FindCommand);
			addCommand(FindEvent.NEXT, FindCommand);
			addCommand(FindEvent.PREVIOUS, FindCommand);
			addCommand(FindEvent.REPLACE, FindCommand);
			addCommand(FindEvent.REPLACE_ALL, FindCommand);
			addCommand(FindEvent.OPEN_SEARCH_ENGINE, FindCommand);
			addCommand(FindEvent.CLOSE_SEARCH_ENGINE, FindCommand);
			addCommand(FindEvent.FIND_ADVANCED, FindCommand);
			addCommand(SelectionEvent.SELECT_CELLS, SelectCommand);
			addCommand(AddressBarEvent.SHOW_HIDE_BAR, AddressBarCommand);
			addCommand(TypeInEvent.TYPE_IN, TypeInCommand);
		}
		private function initServer(event:FlexEvent):void
		{
			addModel(ServerCtx.MODEL_NAME, ServerCtx);
		}
		
	}
}