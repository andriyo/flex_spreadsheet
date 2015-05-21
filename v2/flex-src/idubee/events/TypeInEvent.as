package idubee.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import idubee.model.Rect;

	public class TypeInEvent extends CairngormEvent
	{
		public static const TYPE_IN:String = "typeIn";
		
		public var range:Rect;
		public var value:String;
		
		public function TypeInEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}