package idubee.model
{
	import flash.geom.Rectangle;
	
	public class Rect extends Rectangle
	{
		public function Rect(x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			super(x, y, width, height);
		}
		public static function createRect(x1:uint, y1:uint, x2:uint, y2:uint):Rect
		{
			var r:Rect = new Rect(x1,y1);
			r.width = x2 - x1;
			r.height = y2 - y1;
			return r;
		}
		public function overlaps(xi:uint, yi:uint):Boolean
		{
			return x <=xi && xi <= right && y <= yi && yi <= bottom;
		}
		public function swap():Rect
		{
			var r:Rect = this;
			if (x > right || y > bottom)
			{
				r = new Rect(x,y, width,height);
				if (x > right)
				{
					r.x = right;
					r.right = x;
					
				}
				if (y > bottom)
				{
					r.y = bottom;
					r.bottom = y;
						
				}
			}
			return r;
		}
		override public function toString():String
		{
			if (x==right && y==bottom)
			{
				return Pnt.num2abc(x)+(y+1);
			}
			return Pnt.num2abc(x) + (y+1) + ":" + Pnt.num2abc(right) + (bottom + 1);
		}
		
		public static function parse(range:String):Rect //return null if not parsable
		{
			try {
				var p:Array = range.split(":");
				var p1:Pnt = Pnt.parse(p[0]); 
				var r:Rect = new Rect(p1.x, p1.y);
				if (p.length > 1)
				{
					r.bottomRight = Pnt.parse(p[1]);
				}
				return r.swap();	
			}
			catch (e:Error)
			{
				trace(e);
			}
			return null;
		}
		
	}
}