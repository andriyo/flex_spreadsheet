package idubee.model
{
	import flash.text.TextFormat;

	public class ExtTextFormat extends TextFormat
	{
		public function ExtTextFormat(font:String=null, size:Object=null, color:Object=null, bold:Object=null, italic:Object=null, underline:Object=null, url:String=null, target:String=null, align:String=null, leftMargin:Object=null, rightMargin:Object=null, indent:Object=null, leading:Object=null)
		{
			super(font, size, color, bold, italic, underline, url, target, align, leftMargin, rightMargin, indent, leading);
		}
		public function clone():ExtTextFormat
		{
			var r:ExtTextFormat = new ExtTextFormat;
			r.font = font;
			r.size = size;
			r.color = color;
			r.bold = bold;
			r.italic = italic;
			r.underline = underline;
			r.url = url;
			r.target = target;
			r.align = align;
			r.leftMargin = leftMargin;
			r.rightMargin = rightMargin;
			r.indent = indent;
			r.leading = leading;
			return r;
		}
	}
}