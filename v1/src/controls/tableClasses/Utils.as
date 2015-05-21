package controls.tableClasses
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Utils
	{
		static private const digits:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		static private const len:int = 26;
		/**
		 *  A = 1, AA = 27
		 * */
		static public function convertABCtoNumber(abc:String):int
		{
			var r:int = 0;
			var p:int = 0;
			for (var i:int = abc.length-1; i >= 0; i--)
			{
				 r += (digits.indexOf(abc.charAt(i).toUpperCase())+1)*(Math.pow(len,p++));
			}
			return r;
		}
		/**
		 * 1 = A, 27 = AA
		 * */
		 
		static public function convertNumberToABC(num:int):String
		{
			var rem:int = 0;
			var r:String = "";
			num -=1;
			do
			{
				rem  = num % len;
				r = digits.charAt(rem) + r;
				num   = num / len;
				num = num / len * len - 1;	
			} while (num != -1)
				
			return r;
		}
		/**
		 * A2:B4 = (0,1,1,3);
		 * */
		static public function toRectangle(range:String):Rectangle
		{
			var start:Point;
			var end:Point;
			if (range.indexOf(":") == -1)
			{
				start = end = convertABCAddressToPoint(range);
			}
			else
			{
				var twoPoints:Array = range.split(":");
				start = convertABCAddressToPoint(twoPoints[0]);
				end = convertABCAddressToPoint(twoPoints[1]);
			}
			return new Rectangle(start.x, start.y, end.x - start.x, end.y - start.y);
		}
		
		static private const addressPattern:RegExp = /([a-z]+)(\d+)/i;
		static public function convertABCAddressToPoint(abc:String):Point
		{
			addressPattern.lastIndex = 0;
			var abcArray:Array = addressPattern.exec(abc);
			if (abcArray.length != 3) throw new Error("Invalid ABC Address: "+abc);
			return new Point(convertABCtoNumber(abcArray[1]) - 1, 
			int(abcArray[2]) -1);
		}
		static public function inLine(a:int, b:int, x:int):Boolean
		{
			return Math.abs(x - a) + Math.abs(b - x) == Math.abs(b - a);
		}
		static public function inRect(r:Rectangle, x:int, y:int):Boolean
		{
			return inLine(r.x, r.x +r.width, x) && inLine(r.y, r.y +r.height, y); 
		}
		static public function makeRect(x1:int, y1:int, x2:int, y2:int):Rectangle
		{
			if (x2 < x1)
			{
				x1 = x1 + x2;
				x2 = x1 - x2;
				x1 = x1 - x2;				
			}
			if (y2 < y1)
			{
				y1 = y1 + y2;
				y2 = y1 - y2;
				y1 = y1 - y2;
			}
			return new Rectangle(x1, y1, x2 - x1, y2 - y1);

		}
		static public function rectToString(rect:Rectangle):String
		{
			var p1:String = convertNumberToABC(rect.x + 1)+(rect.y + 1);
			var p2:String = convertNumberToABC(rect.x + rect.width + 1)+(rect.y + rect.height + 1);
			if (p1 == p2) return p1;
			return p1+":"+p2;
		}
		
		
	}
}