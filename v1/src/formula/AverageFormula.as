package formula
{
	import formula.math.MathUtils;
		
	public class AverageFormula implements IFormula
	{
		private static const AVERAGE_FORMULA_NAME : String = "AVERAGE";

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
			var count : Number = 0;
			
			for each (var n : Object in values)
			{
				if (n is Array)
				{
					r += MathUtils.arrayElementsSum(n as Array);
					count += (n as Array).length;
				}
				else
				{
					r += Number(n);	
					count++;
				}
				
			}
			
			return r/count;
		}
		
		public function get formulaName():String
		{
			return AVERAGE_FORMULA_NAME;
		}
		
	}
}