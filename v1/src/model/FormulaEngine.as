package model
{
	import controls.tableClasses.SparseMatrix;
	import controls.tableClasses.Utils;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import formula.Calculator;
	import formula.Parsed;
	import formula.Parser;
	
	
	
	public class FormulaEngine
	{
		private var s:Spreadsheet;
		private var parsedFormulas:SparseMatrix;
		private var parser:Parser;
		private var calculator:Calculator;
		public function FormulaEngine(s:Spreadsheet)
		{
			this.s = s;
			parsedFormulas = new SparseMatrix(s.rowsCount, s.columnsCount);
			parser = new Parser;
			calculator = new Calculator;
			s.addEventListener(SpreadsheetEvent.CHANGED, modelDataChanged);
			s.addEventListener(SpreadsheetEvent.FORMULA_CHANGED, modelFormulaChanged);
		}
		private function modelDataChanged(event:SpreadsheetEvent):void
		{
			if (parsedFormulas.getValueAt(event.xi, event.yi))
			{
				parsedFormulas.removeAt(event.xi, event.yi);
			}
			for each (var parsed:Parsed in parsedFormulas.getArray())
			{
				recalculate(parsed, event.xi, event.yi);
			}
		}
		private function recalculate(parsed:Parsed, x:int, y:int, forced:Boolean = false):void
		{
			var rects:Array = new Array;
			var needsRecalulation:Boolean = forced;
			var varsValues:Array;
			for each (var range:String in parsed.variables)
			{
				var rect:Rectangle = Utils.toRectangle(range);
				rects.push(rect);
				if (!forced && Utils.inRect(rect, x, y))
				{
					needsRecalulation = true;
				}
			}
			if (needsRecalulation)
			{
				varsValues = new Array;
				for each (var area:Rectangle in rects)
				{
					varsValues.push(s.getValues(area));
				}
				var r:String = calculator.calculate(parsed, varsValues);
				var index:Point = parsedFormulas.getIndexOf(parsed);
				s.setRawTextValue(index.x, index.y, r);
			}
		}
		private function modelFormulaChanged(event:SpreadsheetEvent):void
		{
			var parsed:Parsed =parser.parse(event.text);
			if (parsed.hasError)
			{
				s.setErrorAt(event.xi, event.yi, parsed.errorMessage);
				return;
			}
			else
			{
				s.clearErrorAt(event.xi, event.yi);
			}
			parsedFormulas.setValueAt(event.xi, event.yi, parsed);
			recalculate(parsed, event.xi,event.yi, true);
			for each (var parsedObj:Parsed in parsedFormulas.getArray())
			{
				recalculate(parsedObj, event.xi, event.yi);
			}
		}
	}
}