package formula
{
	import mx.events.IndexChangedEvent;
	
	
	
	public class Calculator
	{
		private var _registeredFormulas:Object;
		public var errors:Array;
		public function Calculator()
		{
			_registeredFormulas = FormulaLibrary.registeredFormulas;
		}
		private var values:Array;
		private var parsed:Parsed;
		
		public function calculate(parsedFormula:Parsed, values:Array):String
		{
			errors = [];
			parsed = parsedFormula;
			this.values = values;
			return String(calcNode(parsedFormula.node));
		}
		private function calcNode(node:Node):Object
		{
			var calcChildren:Array = [];
			if (node.children)
			{
				for each (var child:Node in node.children)
				{
					calcChildren.push(calcNode(child));
				}
			}
			if (node.type == Node.FUNC)
			{
				return calcFunc(String(node.value), calcChildren);
			}
			if (node.type == Node.VAR)
			{
				return values[parsed.variables.indexOf(node.value)];
			}
			if (node.type == Node.CONST)
			{
				return node.value;
			}
			errors.push("Invalid type");
			return null;
		}
		private function calcFunc(funcName:String, calcChildren:Array):Object
		{
			if ("+-*/^".indexOf(funcName)!= -1)
			{
				return simpleCalc(calcChildren, funcName);
			}
			var f:IFormula = IFormula(_registeredFormulas[funcName]);
			if (!f)
			{
				errors.push("Function not found: "+funcName);
				return null;				
			}
			return f.eval(calcChildren);
		}
		private function simpleCalc(children:Array, op:String):Object
		{
			var r:Number = Number(children[0]);
			if (children.length == 1 && op=="-")
			{
				return -r;
			}
			for (var i:int = 1; i< children.length; i++)
			{
				switch (op)
				{
					case "+": r+=Number(children[i]); break;
					case "-": r-=Number(children[i]); break;
					case "^": r=Math.pow(r,Number(children[i])); break;
					case "*": r*=Number(children[i]); break;
					case "/": r/=Number(children[i]); break;
				}
			}
			return r;
		}
	}
}