package formula
{
	public class ProductFormula implements IFormula
	{
		private static const PRODUCT_FORMULA_NAME : String = "PRODUCT";

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
			var r:Number = 1;
			for each (var n:Object in values)
			{
				if (n is Array)
				{
					r *=eval(n as Array);
				}
				else
				{
					r *= Number(n);	
				}
				
			}
			return r;
		}
		
		public function get formulaName():String
		{
			return PRODUCT_FORMULA_NAME;
		}

	}
}