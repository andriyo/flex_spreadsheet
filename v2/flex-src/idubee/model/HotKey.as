package idubee.model
{
	public class HotKey
	{
		public static const CONTEXT_SHEET:String = "sheet";
		public static const CONTEXT_EDITOR:String = "editor";
		public function HotKey()
		{
			super();
		}
		
		public var charCode:Number;
		public var ctrl:Boolean;
		public var shift:Boolean;
		public var operation:Function;
		public var context:String;
		public var active:Boolean;
		public var label:String;
		public var valueFunction:String;
		public var throwEvent:Boolean;
		public var eventClass:Class;
		public var eventType:String;
	}
}