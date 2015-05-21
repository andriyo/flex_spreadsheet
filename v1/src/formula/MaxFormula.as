package formula
{
	public class MaxFormula implements IFormula
	{
		private static const MAX_FORMULA_NAME : String = "MAX";
		
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
			var r : Number = Number.MIN_VALUE;
			 
			for each (var n:Object in values)
			{
				if (n is Array)
				{
					r = eval(n as Array);
				}
				else
				{
					if(Number(n) > r){
						r = Number(n);
					}
				}
			}
			return r;
		}
		
		public function get formulaName():String
		{
			return MAX_FORMULA_NAME;
		}
		
	}
}