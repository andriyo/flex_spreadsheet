package idubee.engine
{
	public class Node
	{
		public static const ATOM_NODE:String = "ATOM_NODE";
		public static const FUNC_NODE:String = "FUNC_NODE";
		public var token:Token;
		public var type:String;
		public function Node(token:Token, type:String)
		{
			this.token = token;
		}

	}
}