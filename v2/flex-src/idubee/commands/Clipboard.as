package idubee.commands
{
	public class Clipboard
	{
		public var selections:Array = [];
		public var values:Array = [];
		public function clearAndInit():void
		{
			selections = new Array;
			values = new Array;
		}

	}
}