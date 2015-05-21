package formula
{
	public class CountFormula implements IFormula
	{
		private static const COUNT_FORMULA_NAME : String = "COUNT";
		
		public function get argsNumVariable():Boolean
		{
			return true;
		}
		
		public function get argsCount():int
		{
			return 0;
		}
		
		public function eval(values:Array):Number
		{
			var r : Number = 0;
			for each (var n : Object in values)
			{
				if (n is Array)
				{
					r +=eval(n as Array);
				}
				else
				{
					r += 1;	
				}
				
			}
			return r;
		}
		
		public function get formulaName():String
		{
			return COUNT_FORMULA_NAME;
		}
		
	}
}