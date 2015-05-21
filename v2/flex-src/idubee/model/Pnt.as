package idubee.model
{
	import flash.geom.Point;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import mx.utils.StringUtil;
	[RemoteClass(alias="com.idubee.model.Pnt")]
	public class Pnt extends Point implements IExternalizable
	{
		static private const digits:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		static private const len:int = 26;
		
		public function Pnt(x:Number=0, y:Number=0)
		{
			super(x, y);
		}
		public function clonePnt():Pnt
		{
			var p:Pnt = new Pnt(x,y);
			return p;
		}
		public static function num2abc(n:int):String
		{
			var rem:int = 0;
			var r:String = "";
			do
			{
				rem  = n % len;
				r = digits.charAt(rem) + r;
				n   = n / len;
				n = n / len * len - 1;	
			} while (n != -1)
				
			return r;
		}
		public static function abc2num(abc:String):uint
		{
			var r:int = 0;
			var p:int = 0;
			abc = abc.toUpperCase();
			for (var i:int = abc.length-1; i >= 0; i--)
			{
				 r += (digits.indexOf(abc.charAt(i))+1)*(Math.pow(len,p++));
			}
			return r;
		}
		static private const addressPattern:RegExp = /([a-z]+)(\d+)/i;
		static public function parse(p:String):Pnt
		{
			p = StringUtil.trim(p);
			addressPattern.lastIndex = 0;
			var abcArray:Array = addressPattern.exec(p);
			if (abcArray.length != 3) throw new Error("Invalid address: "+p);
			return new Pnt(abc2num(abcArray[1]) - 1, 
			int(abcArray[2]) -1);
		}

		public function invert():Pnt
		{
			return new Pnt(y, x);
		}
		public function readExternal(input:IDataInput):void
		{
			x = input.readInt();
			y = input.readInt();
		}
		
		public function writeExternal(output:IDataOutput):void
		{
			output.writeInt(x);
			output.writeInt(y);
		}
	}
}