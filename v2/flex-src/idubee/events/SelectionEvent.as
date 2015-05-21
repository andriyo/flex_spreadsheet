package idubee.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import idubee.model.Cell;
	
	import mx.collections.ArrayCollection;

	public class SelectionEvent extends CairngormEvent
	{
		public static const SELECT_CELLS : String = "selectCells";
		
		public var selectCells : ArrayCollection = new ArrayCollection;
		public var highlightAll : Boolean = false;
		public function SelectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}