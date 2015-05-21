package formula
{
	public class SumFormula implements IFormula
	{
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
			var r:Number = 0;
			for each (var n:Object in values)
			{
				if (n is Array)
				{
					r +=eval(n as Array);
				}
				else
				{
					r += Number(n);	
				}
				
			}
			return r;
		}
		
		public function get formulaName():String
		{
			return "SUM";
		}
		
	}
}