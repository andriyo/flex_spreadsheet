package idubee.model
{
	import flash.events.Event;

	public class CellEvent extends Event
	{
		public static const VALUE_CHANGED:String = "valueChanged";
		public static const STYLE_CHANGED:String = "styleChanged";
		
		public function CellEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}