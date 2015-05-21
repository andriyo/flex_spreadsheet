package idubee.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import idubee.view.form.OptionsForm;

	public class OptionsEvent extends CairngormEvent
	{
		public static const OPEN_OPTIONS:String = "open_options";
		public static const CLOSE_OPTIONS:String = "close_options";
		
		public var targetForm : OptionsForm;
		
		public function OptionsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}