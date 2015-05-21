package idubee.engine
{
	public class Parser
	{
		public static function parse(tokens:Array):Node
		{
			Parser.tokens = tokens;
			ti = 0; 
		} 
		private static var ti:int;
		private static var tokens:Array;
		private static var accepted:Token;
		private static function get token():Token
		{
			return Token(tokens[ti]);
		}
		private static function accept(type:String):Boolean
		{
			if (token.type == type)
			{
				accepted = token;
				ti++;
				return true;
			}
			return false; 
		}
		private static function expect(type:String):void
		{
			if (token.type != type)
			{
				throw new Error(type + " expected, "+token.type +" found");
			}
		}
		private static function expression():void
		{
			formula();
		}
		private static function formula():void
		{
			if (accept(Token.NUMERIC))
			{
				if (accept(Token.OPERATOR))
				{
					
				}
			}
			else if (accept(Token.OPERATOR)) //for "-"
			{
				
			}
			else if (accept(Token.STRING))
			{
				//string const
			}
			else if (accept(Token.VAR))
			{
				if (accept(Token.LBRACE)) //function
				{
					func();
					expect(Token.RBRACE);
				}
				else
				{
					//variable
				}
			}
			else if (accept(Token.LBRACE))
			{
				formula();
				expect(Token.RBRACE);
			}
		}
		private static function expression():void
		{
			
		}
		private static function expression():void
		{
			
		}
		
		
	}
}