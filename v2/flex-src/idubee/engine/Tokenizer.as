package idubee.engine
{
	public class Tokenizer
	{
		private static const tokenizer:RegExp = 
  		/(?P<STRING>(?:".*?")+)|(?P<NUMERIC>(?:\d+\.?\d*)+)|(?P<SYMBOL>(?:[_a-z]+[:0-9]*)+)|(?P<OPERATOR>[+\-\/*^])|(?P<LBRACE>[(])|(?P<RBRACE>[)])|(?P<COMMA>[,])/gi;
  		
  		public static function tokenize(s:String):Array
  		{
  			var tokens:Array  = [];
			var captures:Array;
			tokenizer.lastIndex = 0;
			while((captures = tokenizer.exec(s)) != null)
			{
				var type:String;
				
				if (captures[Token.STRING])
				{
					type = Token.STRING;
				} 
				else if (captures[Token.SYMBOL])
				{
					type = Token.SYMBOL;				
				}
				else if (captures[Token.OPERATOR])
				{
					type = Token.OPERATOR;
				}
				else if (captures[Token.NUMERIC])
				{
					type = Token.NUMERIC;
				}
				else if (captures[Token.LBRACE])
				{
					type = Token.LBRACE;
				}
				else if (captures[Token.RBRACE])
				{
					type = Token.RBRACE;
				}
				else if (captures[Token.COMMA])
				{
					type = Token.COMMA;
				}
				else
				{
					throw new Error("Not parseble expression: " + s);
				}
				tokens.push(new Token(type, captures[0], captures.index));
			}
			return tokens;
  		}
	}
}