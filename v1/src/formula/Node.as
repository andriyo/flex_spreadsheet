package formula
{
	public class Node
	{
		static public const CONST:int = 1;
		static public const VAR:int = 2;
		static public const FUNC:int = 3;
		public var type:int;
		public var value:Object;
		public var children:Array;
	}
}