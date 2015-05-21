package model
{
	import controls.tableClasses.*;
	
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import formula.Parsed;
	
	import mx.utils.ObjectUtil;
	
	[Event(name="spreadsheetChanged", type="model.SpreadsheetEvent")]
	[Event(name="spreadsheetFormulaChanged", type="model.SpreadsheetEvent")]
	[Event(name="spreadsheetError", type="model.SpreadsheetEvent")]
	[Event(name="spreadsheetNoError", type="model.SpreadsheetEvent")]
	public class Spreadsheet extends EventDispatcher
	{
		public static const FORMAT_TEXT : int = 1;
		public static const FORMAT_CURRENCY : int = 2;
		public static const FORMAT_DATE : int = 3;
		public static const FORMAT_NUMBER : int = 4;
		
		private var values : SparseMatrix;
		private var formulas:SparseMatrix;
		private var cellStyleIds:SparseMatrix;
		private var errors:SparseMatrix;
		private var formats:SparseMatrix;
		
		private var colStyleIds:Array;
		private var columnWidth : Array;
		private var rowHeigth : Array;
		private var rowStyleIds:Array;
		private var styles:Array;
		private var _changed:Boolean;
		
		public function Spreadsheet(rowsCount:int, columnsCount:int):void
		{
			rowHeigth = new Array;
			columnWidth = new Array;
			values = new SparseMatrix(rowsCount, columnsCount);
			rowStyleIds = new Array;
			colStyleIds = new Array;
			cellStyleIds = new SparseMatrix(rowsCount, columnsCount);
			errors = new SparseMatrix(rowsCount, columnsCount);
			formulas = new SparseMatrix(rowsCount, columnsCount);
			formats = new SparseMatrix(rowsCount, columnsCount);
			styles = ["dummy"];
		}
		public function get changed():Boolean
		{
			return _changed;
		}
		public function get columnsCount():int
		{
			return values.columnsCount;
		}
		public function get rowsCount():int
		{
			return values.rowsCount;			
		}
		public function getTextValueAt(colIndex:int, rowIndex:int):String
		{
			if (values.getValueAt(colIndex, rowIndex) == null) return "";
			return String(values.getValueAt(colIndex, rowIndex));
		}
		public function getRawTextValueAt(colIndex:int, rowIndex:int):String
		{
			return String(values.getValueAt(colIndex, rowIndex));
		}
		public function getFormulaAt(colIndex:int, rowIndex:int):String
		{
			return formulas.getValueAt(colIndex, rowIndex) as String;
		}
		public function setRawTextValue(colIndex:int, rowIndex:int, text:String):void
		{
			_changed = true;
			formats.setValueAt(colIndex, rowIndex, FormatUtils.detectFormat(text));
			values.setValueAt(colIndex, rowIndex, text);
		}
		public function getValues(area:Rectangle):Array
		{
			return values.getValues(area);
		}
		public function setTextValueAt(colIndex:int, rowIndex:int, text:String):void
		{
			var hasError:Boolean;
			var parsed:Parsed;
			if (isFormula(text))
			{
				var formulaText:String = text.substring(1,text.length);
				formulas.setValueAt(colIndex, rowIndex, formulaText);
				dispatchEvent(new SpreadsheetEvent(
			SpreadsheetEvent.FORMULA_CHANGED, colIndex, rowIndex,formulaText));
			} 
			else
			{
				if (text=="")
				{
					values.removeAt(colIndex, rowIndex);
					formulas.removeAt(colIndex, rowIndex);
					cellStyleIds.removeAt(colIndex, rowIndex);
					errors.removeAt(colIndex, rowIndex);
					formats.removeAt(colIndex, rowIndex);
				}
				else
				{
					formats.setValueAt(colIndex, rowIndex, FormatUtils.detectFormat(text));
					values.setValueAt(colIndex, rowIndex, text);					
				}
				dispatchEvent(new SpreadsheetEvent(
			SpreadsheetEvent.CHANGED, colIndex, rowIndex,text));	
			}
			_changed = true;
		}
		
		private function isFormula(text:String):Boolean
		{
			if (text.indexOf("=") == 0) return true;
			return false;
		}
		
		public function getColumnWidth(colIndex:int):int
		{
			if (columnWidth[colIndex] == undefined) return -1;
			return columnWidth[colIndex];
		}
		public function getRowHeigth(rowIndex:int):int
		{
			if (rowHeigth[rowIndex] == undefined) return -1;
			return rowHeigth[rowIndex];
		}
		public function setColumntWidth(colIndex:int, width:int):void
		{
			columnWidth[colIndex] = width;
			_changed = true;
		}
		public function setRowHeigth(rowIndex:int, heigth:int):void
		{
			rowHeigth[rowIndex] = heigth;
			_changed = true;
		}
		public function getStyleIdAt(colIndex:int, rowIndex:int):int
		{
			var id:int = int(cellStyleIds.getValueAt(colIndex, rowIndex));
			if (id >0)
			{
				return id;
			}
			else
			{
				return -1;
			}
		}
		public function getStyle(styleId:int):XML
		{
			return styles[styleId];
		}
		public function addStyle(style:XML):int
		{
			_changed = true;
			return styles.push(style);
		}
		public function setStyle(styleId:int, style:XML):void
		{
			_changed = true;
			styles[styleId] = style;
		}
		public function setStyleIdAt(colIndex:int, rowIndex:int, styleId:int):void
		{
			_changed = true;
			cellStyleIds.setValueAt(colIndex, rowIndex, styleId);
		}
		public function setColStyleId(colIndex:int, styleId:int):void
		{
			_changed = true;
			colStyleIds[colIndex] = styleId;	
		}
		public function setRowStyleId(rowIndex:int, styleId:int):void
		{
			_changed = true;
			rowStyleIds[rowIndex] = styleId;	
		}
		public function getColStyleId(colIndex:int):int
		{
			return colStyleIds[colIndex];
		}
		public function getRowStyleId(rowIndex:int):int
		{
			return rowStyleIds[rowIndex];
		}
		public function setFormatAt(colIndex:int, rowIndex:int, format:int):void
		{
			formats.setValueAt(colIndex, rowIndex, format);
			_changed = true;
		}
		public function getFormatAt(colIndex:int, rowIndex:int):int
		{
			return int(formats.getValueAt(colIndex, rowIndex));
		}
		public function renderToXML():XML
		{
			_changed = false;
			var d:XML = <workbook>
							<fileversion />
							<styles />
								
							<sheets>
								<sheet id='1' name='sheet1' rowsCount='100' columnsCount='100'>
									<selection activeCell='A0'/>
									<cols/>
									<sheetData/>
								</sheet>
							</sheets>	
						</workbook>;
			for each (var style:XML in styles)
			{
				style.@id = styles.indexOf(style);
				XML(d.styles).appendChild(style);	
			}
			for (var ix:int = 0; ix < columnsCount; ix++)
			{
				if (getColumnWidth(ix) > 0 || getColStyleId(ix))
				{
					var col:XML = <col/>;
					col.@min = col.@max = ix;
					if (getColumnWidth(ix) > 0)
					{
						col.@width = getColumnWidth(ix);
					}
					if (getColStyleId(ix) > 0)
					{
						col.@styleId = getColStyleId(ix);
					}
				}
			}
			var row:XML = <row/>;
			for (var iy:int = 0; iy < rowsCount; iy++)
			{
				var dirty:Boolean = false;
				if (getRowHeigth(iy) > 0)
				{
					dirty = true;
					row.@ht = getRowHeigth(iy);
				}
				if (getRowStyleId(iy) > 0)
				{
					dirty = true;
					row.@styleId = getRowStyleId(iy);
				}
				for (ix = 0; ix < columnsCount; ix++)
				{
					if (getTextValueAt(ix, iy) || getStyleIdAt(ix, iy) >0)
					{
						var c:XML = <c/>;
						dirty = true;
						row.appendChild(c);
						c.@r = ix;
						if (getTextValueAt(ix, iy))
						{
							c.v = getTextValueAt(ix, iy);
						}
						if (getStyleIdAt(ix, iy) >0)
						{
							c.@styleId = getStyleIdAt(ix, iy);
						}
						if (getFormulaAt(ix, iy))
						{
							c.f = getFormulaAt(ix, iy);
						}
					}
				}
				if (dirty)
				{
					row.@r = iy;
					XML(d.sheets.sheet.sheetData).appendChild(row);
					row = <row/>;
				}
			}
			return d;
		}
		
		static public function loadFromXML(book : XML):Spreadsheet
		{
			
			var sheet : XML = book.sheets.children()[0];
			var s : Spreadsheet = new Spreadsheet(sheet.@rowsCount, sheet.@columnsCount);
			var styleId:int;
			var dummyTextField:TableDataRenderer = new TableDataRenderer;
			for each (var style:XML in book.styles.*)
			{
				s.setStyle(int(style.@id), style);
			}
			for each (var col : XML in sheet.cols.*)
			{
				var w : int = col.@width;
				styleId = col.@styleId;
				for(var i : int = col.@min; i <= col.@max; i++ )
				{
					if (w > 0) s.setColumntWidth(i - 1, w);
					if (styleId > 0) s.setColStyleId(i - 1, styleId);	
				}
			}
			
			for each (var row : XML in sheet.sheetData.*)
			{
				var r : int = row.@r - 1;
				var ownHt:Boolean = false;
				if ("@ht" in row) 
				{ 
					s.setRowHeigth(r, row.@ht);
					ownHt = true
				}
				styleId = row.@styleId;
				if (styleId > 0) s.setRowStyleId(r, styleId);	
				
				for each (var c : XML in row.*)
				{
					var cr:int =c.@r - 1; 
					var text:String = XML(c.v).toString();
					s.setTextValueAt(cr, r, text);
					styleId = c.@styleId;
					s.setStyleIdAt(cr, r, styleId);
					if (ownHt) continue;
					dummyTextField.text = text;
					FormatUtils.applyStyle(s,cr, r, dummyTextField); 
			   		s.setRowHeigth(r, dummyTextField.textHeight + 4);	    			
				}
			}
			
			return s;
		}
		public function getErrorAt(colIndex:int, rowIndex:int):String
		{
			return String(errors.getValueAt(colIndex, rowIndex));	
		}
		public function setErrorAt(colIndex:int, rowIndex:int, errorMessage:String):void
		{
			errors.setValueAt(colIndex, rowIndex, errorMessage);
			dispatchEvent(new SpreadsheetEvent(
			SpreadsheetEvent.ERROR, colIndex, rowIndex,errorMessage));
			_changed = true;
		}
		public function clearErrorAt(colIndex:int, rowIndex:int):void
		{
			if (getErrorAt(colIndex, rowIndex))
			{
				errors.removeAt(colIndex, rowIndex);
				dispatchEvent(new SpreadsheetEvent(
				SpreadsheetEvent.NO_ERROR, colIndex, rowIndex,""));
				_changed = true;	
			}
			
		}
		
		public function getSubSpreadSheet(rect : Rectangle):Spreadsheet
		{
			var subSpreadSheet : Spreadsheet = new Spreadsheet(rect.height +1, rect.width +1);
			subSpreadSheet.values = values.getSubSparseMatrix(rect);
			subSpreadSheet.formulas = formulas.getSubSparseMatrix(rect);
			subSpreadSheet.cellStyleIds = cellStyleIds.getSubSparseMatrix(rect);
			subSpreadSheet.errors = errors.getSubSparseMatrix(rect);
			subSpreadSheet.formats = formats.getSubSparseMatrix(rect);
			subSpreadSheet.styles = ObjectUtil.copy(styles) as Array;
			
			return subSpreadSheet;
		}
		
		public function setSubSpreadSheet(startX :int, startY : int, subSpreadSheet : Spreadsheet):void
		{
			values.setSubSparseMatrix(startX, startY, subSpreadSheet.values);
			formulas.setSubSparseMatrix(startX, startY, subSpreadSheet.formulas);
			cellStyleIds.setSubSparseMatrix(startX, startY, subSpreadSheet.cellStyleIds);
			errors.setSubSparseMatrix(startX, startY, subSpreadSheet.errors);
			formats.setSubSparseMatrix(startX, startY, subSpreadSheet.formats);
			styles = subSpreadSheet.styles;
			_changed = true;
		}
		
		public function remove(rect : Rectangle):void
		{
			values.remove(rect);
			formulas.remove(rect);
			cellStyleIds.remove(rect);
			errors.remove(rect);
			_changed = true;
		}
		public function sort(rect:Rectangle, options:int):void
		{
			var subSpreadsheet:Spreadsheet = getSubSpreadSheet(rect);
			if (subSpreadsheet.getFormatAt(0,0) == FORMAT_NUMBER) options |= Array.NUMERIC;
			try
			{
				var indexes:Array = subSpreadsheet.values.sort(options);
				subSpreadsheet.formulas.sortByIndexes(indexes);
				subSpreadsheet.cellStyleIds.sortByIndexes(indexes);
				subSpreadsheet.errors.sortByIndexes(indexes);
				subSpreadsheet.formats.sortByIndexes(indexes);
				
				setSubSpreadSheet(rect.x,rect.y,subSpreadsheet);
			}
			catch(e:Error)
			{
				
			}
			dispatchEvent(new SpreadsheetEvent(
			SpreadsheetEvent.SORTED, rect.x, rect.y,null));
		}
	}
}