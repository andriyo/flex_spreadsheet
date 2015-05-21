package idubee.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class FindEvent extends CairngormEvent
	{
		public static const SHOW_FIND:String = "showFind";
		public static const FIND:String = "find";
		public static const NEXT:String = "next";
		public static const PREVIOUS:String = "previous";
		public static const REPLACE:String = "replace";
		public static const REPLACE_ALL:String = "replace_all";
		public static const SHOW_FIND_ALL:String = "showFindAll";
		public static const CLOSE_FIND_ALL:String = "closeFindAll";
		public static const OPEN_SEARCH_ENGINE:String = "openSearchEngine";
		public static const CLOSE_SEARCH_ENGINE:String = "closeSearchEngine";
		public static const FIND_ADVANCED:String = "findAdvanced";
		
		public var what:String;
		public var replaceTo:String;
		public var highlightAll : Boolean = false;
		public var matchCase : Boolean = false;
		public var searchIn : String;
		public var where : String;
		
		public function FindEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}