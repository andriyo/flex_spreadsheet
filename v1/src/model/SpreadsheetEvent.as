package model
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import formula.Parsed;

	public class SpreadsheetEvent extends Event
	{
		public static const CHANGED:String = "spreadsheetChanged";
		public static const FORMULA_CHANGED:String = "spreadsheetFormulaChanged";
		public static const SORTED:String = "spreadsheetSorted";
		public static const ERROR:String = "spreadsheetError";
		public static const NO_ERROR:String = "spreadsheetNoError";
		public var cellAddresses:Array; //Array of Points
		public var xi:int;
		public var yi:int;
		public var text:String;
		public function SpreadsheetEvent(type:String, x:int = -1, y:int = -1,
						 text:String = null)
		{
			super(type);
			xi = x;
			yi = y;
			this.text = text;
		}
		public function setRange(x1:int, y1:int, x2:int, y2:int):void
		{
			var xys:Array = new Array;
			for(var x:int = x1; x<=x2; x++)
			{
				for(var y:int = y1; y<=x2; y++)
				{
					xys.push(new Point(x,y));
				}
			}
			cellAddresses = xys;
		}
	}
}