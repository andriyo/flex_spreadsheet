package idubee.events
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class IdubeeMenuEvent extends CairngormEvent
	{
		public static const MENU_CLICK:String = "menuClick";
		public var item:Object;
		public function IdubeeMenuEvent(type:String, item:Object,
		 bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.item = item;
		}
		
	}
}