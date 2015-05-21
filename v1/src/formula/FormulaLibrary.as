package formula
{
	public class FormulaLibrary
	{
		private static var _registeredFormulas:Object;
		public static function get registeredFormulas():Object
		{
			if (!_registeredFormulas)
			{
				_registeredFormulas = new Object;
				registerFormula(new SumFormula);		
				registerFormula(new CountFormula);		
				registerFormula(new AverageFormula);		
				registerFormula(new MinFormula);		
				registerFormula(new MaxFormula);		
				registerFormula(new ProductFormula);		
			}
			return _registeredFormulas;	
		}
		private static function registerFormula(form:IFormula):void
		{
			_registeredFormulas[form.formulaName] = form;
		}
	}
}