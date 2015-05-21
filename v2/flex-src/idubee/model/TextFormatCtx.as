package idubee.model
{
	import flash.text.TextFormat;
	
	[Bindable]
	public class TextFormatCtx
	{
		public static const MODEL_NAME:String = "formatCtx";
		private static var _ctx:TextFormatCtx;	
		public function TextFormatCtx()
		{
			_ctx = this;
		}
		public static function get ctx():TextFormatCtx
		{
			return _ctx;
		}
		public var fontFamilyArray:Array = "Arial,Courier,Courier New,Geneva,Georgia,Helvetica,Times New Roman,Times,Verdana,_sans,_serif,_typewriter".split(",");
		public var fontSizeArray:Array = "8,9,10,11,12,14,16,18,20,22,24,26,28,36,48,72".split(",");
		public var font:Number = 0;
		public var size:String;
		public var bold:Boolean;
		public var italic:Boolean;
		public var underline:Boolean;
		public var color:uint;
		public var align:Number = -1;
	}
}