package controls.selectionClasses
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SelectionEvent extends Event
	{
		public var x1 : int;
		public var x2 : int;
		public var y1 : int;
		public var y2 : int;
		public static const SELECTION : String = "selection";
		public static const ADDRESS_SELECTION : String = "addressSelection";
		public var mouseEvent:MouseEvent;
		public var address : String;
		
		public function SelectionEvent(type : String, x1 : int, y1 : int, x2 : int, y2 : int, mouseEvent:MouseEvent ):void
		{ 
			super(type, true);
			this.x1 = x1;
			this.y1 = y1;
			this.x2 = x2;
			this.y2 = y2;
			
			this.mouseEvent = mouseEvent; 
		}
	}
}