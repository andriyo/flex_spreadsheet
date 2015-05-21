package idubee.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.text.TextFormat;
	
	import idubee.events.TextFormatEvent;
	import idubee.model.Cell;
	import idubee.model.EditorCtx;
	import idubee.model.Rect;
	import idubee.model.Spreadsheet;
	import idubee.model.TextFormatCtx;
	import idubee.view.cell.CellRenderer;

	public class TextFormatCommand implements ICommand
	{
		public var ctx:EditorCtx;
		public var formatCtx:TextFormatCtx;
		
		public function TextFormatCommand()
		{
			super();
		}

		public function execute(event:CairngormEvent):void
		{
			var e:TextFormatEvent = TextFormatEvent(event);
			if (!ctx.workbook || !ctx.workbook.selectedSpreadsheet) return;
			var s:Spreadsheet = ctx.workbook.selectedSpreadsheet;
			var cellEditor:CellRenderer = ctx.cellEditor;
			if (e.type == TextFormatEvent.FORMAT_CHANGED)
			{
				if (cellEditor)
				{
					applyStyleForOneCell(cellEditor, e);
					cellEditor.setFocus();
				}
				else
				{
					applyStyleForSelection(e);
				}
			}
			if (e.type == TextFormatEvent.TEXTFIELD_CHANGED)
			{
				getTextStyles(ctx.table.getCursorRenderer());
			}
			
			
		}
		
		private function applyStyleForOneCell(cr:CellRenderer, event:TextFormatEvent, selectionMode:Boolean = false):void
		{
			var tf:TextFormat;
			var type:String = event.styleName;
			var value:Object = event.styleValue;
			
			var beginIndex:int = cr.selectionBeginIndex;
			var endIndex:int = cr.selectionEndIndex;
			
			tf = new TextFormat();
			if (type == "bold" || type == "italic" || type == "underline")
			{
				tf[type] = value;
			}
			else if (type == "align")
			{
				if (beginIndex == endIndex)
				{
					tf = new TextFormat();
				}
	
				beginIndex = cr.getFirstCharInParagraph(beginIndex) - 1;
				beginIndex = Math.max(0, beginIndex);
				endIndex = cr.getFirstCharInParagraph(endIndex) +
					cr.getParagraphLength(endIndex) - 1;
				
				var sValue:String;
				switch (value)
				{
					case 0: sValue = "left"; break;
					case 1: sValue = "center"; break;
					case 2: sValue = "right"; break;
					case 3: sValue = "justify"; break;
				}
				tf[type] = sValue;
				if (!endIndex)
					cr.defaultTextFormat = tf;
			}
			else if (type == "font")
			{
				tf[type] = formatCtx.fontFamilyArray[value];
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
					
			if (beginIndex == endIndex)
			{
				cr.defaultTextFormat = tf;
				if (selectionMode) cr.setTextFormat(tf);
			}
			else
			{
				cr.setTextFormat(tf,beginIndex,endIndex);
			}
			
	
			var caretIndex:int = cr.caretIndex;
			var lineIndex:int =	cr.getLineIndexOfChar(caretIndex);
	
			while (lineIndex >= cr.bottomScrollV)
			{
				cr.scrollV++;;
			}
			formatCtx[type] = value;
		}
		private function applyStyleForSelection(event:TextFormatEvent):void
		{
			var s:Spreadsheet = ctx.workbook.selectedSpreadsheet;
			var cr:CellRenderer = new CellRenderer;
			cr.table = ctx.table;
			var cursorRect:Rect = new Rect(s.startPnt.x, s.startPnt.y);
			for each (var rect:Rect in s.selections.concat(cursorRect))
			{
				var cells:Array = s.getCellsInRect(rect);
				for each (var c:Cell in cells)
				{
					if (!c) continue;
					cr.htmlText = c.v.toString();
					applyStyleForOneCell(cr,event, true);
					c.v = cr.htmlText;
				}
			}
			
			ctx.table.invalidateAll();
		}
		private function getTextStyles(cr:CellRenderer):void
		{
			if (cr == null)
			{
				cr = ctx.workbook.defaultCellRenderer;
			}
			var tf:TextFormat;
			var beginIndex:int = cr.selectionBeginIndex;
			var endIndex:int = cr.selectionEndIndex;
			if (!endIndex)
			{
				tf = cr.defaultTextFormat;
			}
			else
			{
				if (beginIndex == endIndex && endIndex == cr.length)
				{
					beginIndex--;
				}
				tf = cr.getTextFormat(beginIndex,endIndex);
			}
			if (tf.font !=null)
			formatCtx.font = formatCtx.fontFamilyArray.indexOf(tf.font);
			if (tf.size !=null)
			formatCtx.size = tf.size.toString();
			if (tf.color !=null)
			formatCtx.color = Number(tf.color);
			if (tf.bold !=null)
			formatCtx.bold = tf.bold;
			if (tf.italic !=null)
			formatCtx.italic = tf.italic;
			if (tf.underline !=null)
			formatCtx.underline = tf.underline;
			if (tf.align !=null)
			if (tf.align == "left")
				formatCtx.align = 0;
			else if (tf.align == "center")
				formatCtx.align = 1;
			else if (tf.align == "right")
				formatCtx.align = 2;
			else if (tf.align == "justify")
				formatCtx.align = 3;
		}
		
		
	}
}