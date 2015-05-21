package idubee.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class TextFormatEvent extends CairngormEvent
	{
		public var styleName:String;
		public var styleValue:Object;
		public static const FORMAT_CHANGED:String = "formatChanged";
		public static const TEXTFIELD_CHANGED:String = "textFieldChanged";
		public static const CARET_POSITION_CHANGED:String = "caretPositionChanged";
		public function TextFormatEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}