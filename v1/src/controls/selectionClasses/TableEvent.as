package controls.selectionClasses
{
	import flash.events.Event;

	public class TableEvent extends Event
	{
		public static const ITEM_EDIT_BEGIN:String = "itemEditBegin";
		public static const ITEM_EDIT_BEGGINING:String = "itemEditBeginning";
		public static const ITEM_EDIT_END:String = "itemEditEnd";
		public static const ITEM_FOCUS_IN:String = "itemFocusIn";
		public static const ITEM_FOCUS_OUT:String = "itemFocusOut";
		
		public function TableEvent(type:String)
		{
			super(type);
		}
		
	}
}