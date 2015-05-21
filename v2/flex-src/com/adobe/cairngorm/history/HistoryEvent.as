package com.adobe.cairngorm.history
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class HistoryEvent extends CairngormEvent
	{
		public static const UNDO:String = "undo";
		public static const REDO:String = "redo";
		
		public function HistoryEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}