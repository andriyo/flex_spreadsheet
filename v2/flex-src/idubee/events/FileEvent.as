package idubee.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class FileEvent extends CairngormEvent
	{
		public static const OPEN_FILE:String = "openFile";
		public static const OPEN_URL:String = "openURL";
		public static const OPEN_NEW:String = "openNew";
		public static const CLOSE_FILE:String = "closeFile";
		public static const SAVE_LOCAL:String = "saveLocal";
		public static const SAVE_ONLINE:String = "saveOnline";
		public function FileEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}