package formula.math
{
	public final class MathUtils
	{

		public static function arrayElementsSum(n : Array) : Number 
		{
			var r : Number = 0;
			for(var i : int; i < n.length; i++)
			{
				r+=Number(n[i]);
			}
			return r;
		}

	}
}