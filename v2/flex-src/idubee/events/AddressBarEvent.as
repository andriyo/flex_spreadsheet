package idubee.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class AddressBarEvent extends CairngormEvent
	{
		public static const SHOW_HIDE_BAR:String = "showHideBar";
		
		public function AddressBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}