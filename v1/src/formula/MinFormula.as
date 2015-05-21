package formula
{
	public class MinFormula implements IFormula
	{
		private static const MIN_FORMULA_NAME : String = "MIN";
		
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
			var r : Number = Number.MAX_VALUE;

			for each (var n : Object in values)
			{
				if (n is Array)
				{
					r = eval(n as Array);
				}
				else
				{
					if(Number(n) < r){
						r = Number(n);
					}
				}
			}
			return r;
		}
		
		public function get formulaName():String
		{
			return MIN_FORMULA_NAME;
		}

	}
}