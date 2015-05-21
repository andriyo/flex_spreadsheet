package formula
{
	public interface IFormula
	{
		function get argsNumVariable():Boolean;
		
		function get argsCount():int;
		
		function eval(values:Array):Number;
		
		function get formulaName():String;
	}
}