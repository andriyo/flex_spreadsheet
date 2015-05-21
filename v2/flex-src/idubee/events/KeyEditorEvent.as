package idubee.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.KeyboardEvent;

	public class KeyEditorEvent extends CairngormEvent
	{
		public var event:KeyboardEvent;
		public var context:String;
		public static const HOTKEY_PRESSED:String = "hotkeyPressed";
		
		public function KeyEditorEvent(event:KeyboardEvent, context:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(HOTKEY_PRESSED, bubbles, cancelable);
			this.event = event;
			this.context = context;
		}
		
	}
}