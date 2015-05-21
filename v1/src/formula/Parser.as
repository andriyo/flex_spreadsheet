package formula
{
	
	
	
	
	public class Parser
	{
		private var registeredFormulas:Object = new Object;
  		private static const incorrectFormulaExpr:RegExp =/[^0-9a-z.,^*+:"'\-\/()]/i;
  		private static const stripSpacesExpr:RegExp = /\s*/g;
  		private static const CONSTANT:int = 11;
  		private static const VARIABLE:int = 12;
  		private static const OPERATOR:int = 13;
  		private static const FUNCTION:int = 14;
  		private static const tokenizer:RegExp = 
  		/(?P<string>(?:".*?")+)|(?P<const>(?:\d+\.?\d*)+)|(?P<var>(?:[_a-z]+[:0-9]*)+)|(?P<oper>[+\-\/*^(),])/gi;
		private var errors:Array;
		private var variables:Array;
		public function Parser()
		{
			registeredFormulas = FormulaLibrary.registeredFormulas;				
		}
		
		public function parse(expr:String):Parsed
		{
			var parsed:Parsed = new Parsed;
			errors = [];
			expr = expr.replace(stripSpacesExpr,"");
			if (!expr)
			{
				parsed.hasError = true;
				parsed.errorMessage = "Empty formula";
				return parsed;
			}
			if (incorrectFormulaExpr.test(expr))
			{
				parsed.hasError = true;
				parsed.errorMessage = "Invalid characters";
				return parsed;
			}
			tokenizer.lastIndex = 0;
			var tokens:Array  = [];
			var captures:Array;
			while((captures = tokenizer.exec(expr)) != null)
			{
				var type:int;
				if (captures['const'] || captures['string'])
				{
					type = CONSTANT; 
				} 
				else if (captures['var'])
				{
					type = VARIABLE;					
				}
				else if (captures['oper'])
				{
					type = OPERATOR;
				}
				else
				{
					throw new Error("Incorrect behaviour");
				}
				tokens.push({type:type, value:captures[0]});
			}
			variables = [];
			var node:Node = buildTree(tokens);
			parsed.variables = variables;
			parsed.node = node;
			trace("-----------------------------");
			printTree(node, 0);
			if (errors.length > 0)
			{
				parsed.hasError = true;
				parsed.errorMessage = errors.join(",");
			}
			return parsed;
		}
		private var level:int =0;
		private function printTree(node:Node, level:int):void
		{
			var s:String= "";
					for (var i:int = 0 ; i< level; i++)
					{
						s+="-"
					}
					s+="> ";
			trace(s+node.type+" "+node.value);
			for each (var child:Node in node.children)
			{
				printTree(child, level+1);
			}
				
		}
		
		private function buildTree(tokens:Array):Node
		{
			var r:Array = buildChildren(tokens);
			if (r.length > 1) addError("Invalid comma");
			return Node(r[0]); 
		}
		private function buildChildren(tokens:Array):Array
		{
			findFormulas(tokens);
			findBraces(tokens);
			findOperators(tokens, "*/^", false);
			findOperators(tokens, "+-", true);
			findConstVar(tokens);
			return tokens;
		}
		private function findConstVar(tokens:Array):Array
		{
			for(var i:int = 0; i < tokens.length; i++)
			{
				var type:int = int(tokens[i].type);
				if (tokens[i] is Node) continue;
				if (type == CONSTANT || type == VARIABLE)
				{
					var cNode:Node = new Node;
					cNode.type = type==CONSTANT?Node.CONST:Node.VAR;
					cNode.value = tokens[i].value;
					tokens[i] = cNode;
					if (type == VARIABLE)
					{
						variables.push(tokens[i].value);	
					}	
				}
				else if (type == OPERATOR && tokens[i].value == ",")
				{
					tokens.splice(i,1);
					i--;
				}
				else
				{
					addError("Unexpected symbol: "+tokens[i].value);
				}
			}
			return tokens;
		}
		private function findOperators(tokens:Array, operators:String, unary:Boolean):Array
		{
			for (var i:int = 0; i < tokens.length; i++)
			{
				var value:String = tokens[i].value;
				if (tokens[i] is Node) continue;
				if (tokens[i].type == OPERATOR && (operators.indexOf(value) != -1))
				{
					var isUnary:Boolean = false;
					if (i == 0)
					{
						if (unary)
						{
							isUnary = true;
						}
						else
						{
							addError("No symbol before "+value);
						}
					}
					if (!isUnary && tokens[i - 1].type==OPERATOR)
					{
						addError("Invalid symbol before" + value);
					}
					if (i == tokens.length -1 || tokens[i + 1].type == OPERATOR)
					{
						addError("Invalid symbol or no symbol after "+value);
					}
					
						var ntokens:Array = [];
						if (!isUnary) ntokens.push(buildTree([tokens[i - 1]]));
						ntokens.push(buildTree([tokens[i + 1]]));
						var fNode:Node = new Node;
						fNode.type = Node.FUNC;
						fNode.value = value;
						fNode.children = ntokens;
						tokens[i] = fNode;
						if (isUnary)
						{
							tokens.splice(i +1, 1);
						}
						else
						{
							tokens.splice(i - 1, 1);
							tokens.splice(i, 1);
							i--;	
						}
						
				}
			
			}
			return tokens;
			
		}
		private function findBraces(tokens:Array):Array
		{
			for (var i:int = 0; i < tokens.length; i++)
			{
				if (tokens[i] is Node) continue;
				var value:String = tokens[i].value;
				if (tokens[i].type == OPERATOR && value == "(")
				{
					var endIndex:int = findRightBrace( i + 1, tokens);
					if (endIndex == -1)
					{
						addError("Not found )");
						return tokens;
					}
					tokens[i] = buildTree(tokens.slice( i + 1, endIndex));
					tokens.splice(i + 1,endIndex - i);
				}
			}
			return tokens;
		}
		private function findFormulas(tokens:Array):Array
		{
			for (var i:int = 0; i < tokens.length; i++)
			{
				var value:String = String(tokens[i].value).toUpperCase();
				
				if (tokens[i].type == VARIABLE && registeredFormulas[value])
				{
					if (tokens[i+1].type == OPERATOR && tokens[i+1].value == "(")
					{
						var endIndex:int = findRightBrace(i+2, tokens);
						if (endIndex == -1)
						{
							addError("Not found ) for "+value);
							return tokens;
						}
						tokens[i] = buildFormula(value, tokens, i+2, endIndex);
						tokens.splice(i+1, endIndex - i);
					}
					else
					{
						addError("Can't find expected ( after "+value);
						return tokens;
					}
				}
			}
			return tokens;
		}
		private function buildFormula(value:String, tokens:Array, startIndex:int, endIndex:int):Node
		{
			var ntokens:Array, subExpr:Array = tokens.slice(startIndex, endIndex);
			ntokens = buildChildren(subExpr);
			var form:IFormula = IFormula(registeredFormulas[value]);
			var paramCounter:int = ntokens.length;
			if (!form.argsNumVariable && paramCounter != form.argsCount)
			{
				addError("Invalid number of arguments for function "+value+" expected "+
				form.argsCount+" but got "+paramCounter);
			}
			var fNode:Node = new Node;
			fNode.type = Node.FUNC;
			fNode.value = form.formulaName;
			fNode.children = ntokens;
			return fNode;
		}
		private function findRightBrace(startIndex:int, tokens:Array):int
		{
			var otherBraces:int = 0;
			for (var i:int = startIndex; i < tokens.length; i++)
			{
				var value:String = tokens[i].value;
				if (tokens[i].type != OPERATOR) continue;
				if (value == "(") 
				{
					otherBraces ++;
				}
				else if (value == ")")
				{
					if (otherBraces) otherBraces--
					else return i;
				}
			}
			addError("Can't find matching )");
			return -1;
		}
		private function addError(errorMessage:String):void
		{
			errors.push(errorMessage);	
		}

	}
}