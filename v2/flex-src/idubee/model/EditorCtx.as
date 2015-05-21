package idubee.model
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import flexlib.mdi.effects.effectsLib.MDIVistaEffects;
	import flexlib.mdi.events.MDIManagerEvent;
	import flexlib.mdi.managers.MDIManager;
	
	import idubee.commands.Clipboard;
	import idubee.events.EditorEvent;
	import idubee.events.FileEvent;
	import idubee.view.cell.CellRenderer;
	import idubee.view.editor.TableWindow;
	import idubee.view.form.AdvancedSearchForm;
	import idubee.view.form.SearchResults;
	import idubee.view.table.Table;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	[Bindable]
	public class EditorCtx
	{
		public static const MODEL_NAME:String = "ctx";
		private static var _ctx:EditorCtx;
		public function EditorCtx()
		{
			initVariables();
			_ctx = this;
		}
		public static function get ctx():EditorCtx
		{
			return _ctx;
		}
		public function initVariables():void
		{
			initEditorMenu();
			clipboard = new Clipboard;
		}	
		private function initEditorMenu():void
		{
			editorMenu = new ArrayCollection;
			editorMenu.addItem({label:"Copy", eventType:EditorEvent.COPY});
			editorMenu.addItem({label:"Paste", eventType:EditorEvent.PASTE});
			editorMenu.addItem({label:"Cut", eventType:EditorEvent.CUT});
			editorMenu.addItem({label:"Delete", eventType:EditorEvent.DELETE});
			editorMenu.addItem({label:"Cell properties", eventType:EditorEvent.CELL_PROPERTIES});
		}	
		public var documents:ArrayCollection = new ArrayCollection;
		public var _editor:Container;
		public var editorMenu:ArrayCollection;
		public var workbook:Workbook;
		public var workspace:Workspace = new Workspace;
		public var workbookEditorMap:Dictionary = new Dictionary(true);
		public var windowManager:MDIManager;
		public var clipboard:Clipboard;
		public var table:Table;
		public var cellEditor:CellRenderer;
		public var searchResultsWindow : IFlexDisplayObject;
		public var advancedSearchWindow : IFlexDisplayObject;
		public var currentTableWindow:TableWindow;
		public function set editor(value:Container):void
		{
			_editor = value;
			windowManager = new MDIManager(_editor);
			windowManager.effects = new MDIVistaEffects();
			windowManager.tilePadding = 5;
			windowManager.addEventListener(MDIManagerEvent.WINDOW_CLOSE, mdiWindowCloseHandler);
			windowManager.addEventListener(MDIManagerEvent.WINDOW_FOCUS_START, windowFocusStartHandler);
		}
		public function get editor():Container
		{
			return _editor;
		}
		private function windowFocusStartHandler(event:MDIManagerEvent):void
		{
			var table:Table = TableWindow(event.window).table; 
			workbook = table.workbook;
			this.table = table;
			currentTableWindow = TableWindow(event.window);
		}
		private var queuedEvent:MDIManagerEvent;
		private function mdiWindowCloseHandler(event:MDIManagerEvent):void
		{
			if (!workbook)
			{
				workbook = TableWindow(event.window).table.workbook;
			}
			queuedEvent = event;
			if (workbook.modified)
			{
				event.stopImmediatePropagation();
		     	Alert.show("Close document?", "Workbook not saved", 3, null, handleAlertResponse);	
			} 
			else
			{
				fireCloseEvent();
			}
		}
		private function handleAlertResponse(event:CloseEvent):void
		{
		    if(event.detail == mx.controls.Alert.YES)
		    {
		    	fireCloseEvent();
		        windowManager.executeDefaultBehavior(queuedEvent);
		    }
		}
		private function fireCloseEvent():void
		{
			TableWindow(queuedEvent.window).table.workbook = null;
			var e:FileEvent = new FileEvent(FileEvent.CLOSE_FILE);
	    	e.data = workbook;
	    	e.dispatch();
		}
		public function get s():Spreadsheet
		{
			if (workbook) return workbook.selectedSpreadsheet;
			return null;
		}
//		public function get currentTableWindow():TableWindow
//		{
//			if (windowManager.windowList.length == 0) return null;
//			return TableWindow(windowManager.windowList[windowManager.windowList.length - 1]);
//		}
		public function openSearchResultsWindow():void
		{
			if (!searchResultsWindow)
			{
				searchResultsWindow = PopUpManager.createPopUp(DisplayObject(Application.application), SearchResults);
				var x : int = (Application.application.screen.width - searchResultsWindow.width) * 0.85;
				var y : int = (Application.application.screen.height - searchResultsWindow.height)/2;
				searchResultsWindow.move(x, y);
				
			} else {
				
				PopUpManager.bringToFront(searchResultsWindow);
			}	
		}
		
		public function closeSearchResultsWindow():void
		{
			if (searchResultsWindow)
			{
				PopUpManager.removePopUp(searchResultsWindow);
				searchResultsWindow = null;
			}
		}
		
		public function openAdvancedSearchWindow():void
		{
			if (!advancedSearchWindow)
			{
				advancedSearchWindow = PopUpManager.createPopUp(DisplayObject(Application.application), AdvancedSearchForm);
				PopUpManager.centerPopUp(advancedSearchWindow);
				
			} else {
				
				PopUpManager.bringToFront(advancedSearchWindow);
			}
		}
		
		public function closeAdvancedSearchWindow():void
		{
			if (advancedSearchWindow)
			{
				PopUpManager.removePopUp(advancedSearchWindow);
				advancedSearchWindow = null;
			}
		}
		
	}
}