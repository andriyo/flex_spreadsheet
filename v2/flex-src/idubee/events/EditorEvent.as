package idubee.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class EditorEvent extends CairngormEvent
	{
		public static const COPY:String = "copy";
		public static const PASTE:String = "paste";
		public static const CUT:String = "cut";
		public static const DELETE:String = "delete";
		public static const CELL_PROPERTIES:String = "cellProperties";
		public static const AUTOSIZE:String = "autosize";
		public static const AUTOSIZE_TYPE_ROW:int = 0;
		public static const AUTOSIZE_TYPE_COLUMN:int = 1;
		public static const AUTOSIZE_TYPE_BOTH:int = 2;
		
		public static const INSERT_ROW:String = "insertRow";
		public static const REMOVE_ROW:String = "removeRow";
		public static const INSERT_COLUMN:String = "insertColumn";
		public static const REMOVE_COLUMN:String = "removeColumn";
		
		
		public var autoSizeIndex:uint;
		public var autoSizeType:int;
		public var selections:Array;
		public var addSelection:Boolean;
		public var count:int;
		
		public function EditorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}