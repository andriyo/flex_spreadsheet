package idubee.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class WorkbookEvent extends CairngormEvent
	{
		public static const ADD_SHEET:String = "addSheet";
		public static const REMOVE_SHEET:String = "removeSheet";
		public static const SELECT_SHEET:String = "selectSheet";
		public static const SWAP_SHEETS:String = "swapSheets";
		public var index:int;
		public var relatedIndex:int;
		public function WorkbookEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}