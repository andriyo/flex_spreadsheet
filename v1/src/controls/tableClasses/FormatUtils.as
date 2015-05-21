package controls.tableClasses
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import model.Spreadsheet;
	
	import mx.core.UITextField;
	
	public class FormatUtils
	{ 
		public static function applyStyle(s:Spreadsheet, colIndex:int, rowIndex:int, textField:UITextField):void
		{
			var cellStyleId:int = s.getStyleIdAt(colIndex, rowIndex);
			var colStyleId:int = s.getColStyleId(colIndex);
			var rowStyleId:int = s.getRowStyleId(rowIndex);
			applyStyleInt(s, rowStyleId, textField);
			applyStyleInt(s, colStyleId, textField);
			applyStyleInt(s, cellStyleId, textField);
		}
		private static function applyStyleInt(s:Spreadsheet, styleId:int, textField:UITextField):void
		{
			if (!(styleId > 0)) return;
			var styleXML:XML = s.getStyle(styleId);
			if (!styleXML) return;
			if ('@parentStyle' in styleXML) applyStyleInt(s,int(styleXML.@parentStyle), textField);
			var tf:TextFormat;
			if (textField.text.length >0)
			{
				tf = new TextFormat;
			}
			else
			{
				tf = textField.defaultTextFormat;
			}
			for each (var styleElement:XML in styleXML.*)
			{
				
				var selectionBeginIndex:int = -1;
				if ('@startIndex' in styleElement) selectionBeginIndex = int(styleElement.@startIndex);
				var selectionEndIndex:int = -1;
				if ('@endIndex' in styleElement) selectionEndIndex = int(styleElement.@endIndex);
				var type:String = styleElement.@typeName;
				var value:String = styleElement.@value;
				if (type == "bold" || type == "italic" || type == "underline")
				{
					tf[type] = value;
				}
				else if (type == "align" || type == "bullet")
				{
					tf[type] = value;
					textField.defaultTextFormat = tf;
				}
				else if (type == "font")
				{
					tf[type] = value;
				}
				else if (type == "size")
				{
					var fontSize:uint = uint(value);
					if (fontSize > 0)
						tf[type] = fontSize;
				}
				else if (type == "color")
				{
					tf[type] = uint(value);
				}
				else if (type == "url")
				{
					if (value != "http://" && value != "")
					{
						tf[type] = value;
						tf["target"] = "_blank";
					}
					else if (tf[type] != "")
					{
						tf[type] = ""; 
						tf["target"] = ""; 
					}
				}
				var len:int = textField.text.length;
				if (selectionBeginIndex > len - 1) selectionBeginIndex = -1;
				if (selectionEndIndex > len - 1) selectionEndIndex = -1;
				textField.setTextFormat(tf,selectionBeginIndex,selectionEndIndex);
			}
		
			if (!textField.text)
			{
				textField.defaultTextFormat = tf;
			}
	
		}
		public static function detectFormat(text:String):int
		{
			var n:Number = Number(text);
			if (isNaN(n)) return Spreadsheet.FORMAT_TEXT;
			return Spreadsheet.FORMAT_NUMBER;
		}
		public static function formatValue(format:int, textField:UITextField, maxWidth:int, actualWidth:int):int
		{
			var text:String = textField.text;
			if (format == Spreadsheet.FORMAT_NUMBER)
			{
				var tf:TextFormat = new TextFormat;
				tf.align = TextFormatAlign.RIGHT;
				textField.setTextFormat(tf);	
				if (textField.textWidth > maxWidth)
				{
					textField.text = "#WARN#";
					return maxWidth;
				}
			}
			return actualWidth;
		}
	}
}