package idubee.model
{
	import flash.events.Event;

	public class SpreadsheetEvent extends Event
	{
		public static const CELL_ADDED:String = "cellAdded";
		public static const CELL_REMOVED:String = "cellRemoved";
		public static const ROW_INSERTED:String = "rowInserted";
		public static const ROW_REMOVED:String = "rowRemoved";
		public static const COLUMN_INSERTED:String = "columnInserted";
		public static const COLUMN_REMOVED:String = "columnRemoved";
		public static const COLUMN_WIDTH_CHANGED:String  = "columnWidthChanged";
		public static const ROW_HEIGHT_CHANGED:String  = "rowHeightChanged";
		public static const CELL_FOUND:String  = "cellFound";
		public static const SEARCH_STARTED:String  = "searchStarted";
		public static const SEARCH_ENDED:String  = "searchEnded";
		public static const LOADED:String  = "spreadsheetLoaded";
		public static const SELECTION_CHANGED:String  = "selectionChanged";
		
		public var cell:Cell;
		public var rowIndex:int;
		public var columnIndex:int;
		public var oldValue:int;
		public var newValue:int;
		public var newSelection:Rect;
		public function SpreadsheetEvent(type:String, cell:Cell = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.cell = cell;
		}
		
	}
}