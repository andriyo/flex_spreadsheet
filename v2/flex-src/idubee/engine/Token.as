package idubee.engine
{
	public class Token
	{
		public static const NUMERIC:String = "NUMERIC";
		public static const STRING:String = "STRING";
		public static const SYMBOL:String = "SYMBOL";
		public static const OPERATOR:String = "OPERATOR";
		public static const LBRACE:String = "LBRACE";
		public static const RBRACE:String = "RBRACE";
		public static const COMMA:String = "COMMA";
		public var type:String;
		public var value:String;
		public var index:int;
		public function Token(type:String, value:String, index:int)
		{
			this.type = type;
			this.value = value;
			this.index = index;
		}
		public function toString():String
		{
			return type+" "+value;
		}

	}
}