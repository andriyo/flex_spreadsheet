package controls.selectionClasses
{
	import controls.Table;
	import controls.tableClasses.FormatUtils;
	import controls.tableClasses.Utils;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	import model.Spreadsheet;
	
	import mx.controls.TextInput;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	use namespace mx_internal;
	public class EditLayer extends SelectionLayer
	{
		public var editor:UITextField;
		private var colIndex:int;
		private var rowIndex:int;
		private var inEdit:Boolean;
		private var minItemWidth:int;
		public var addressTextInput : String;
		public var addressEditor : TextInput;
		public function EditLayer(table:Table)
		{
			
			super(table);
			doubleClickEnabled = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
		}
		
		private function doubleClickHandler(event:MouseEvent):void
		{
			if (editor) hideEditor();
			showEditor();
		}
		private function textAreaFocusOut(event:FocusEvent):void
		{
			if (addressSelectionMode)
			{
				event.preventDefault();
				editor.setFocus();
			}
			else
			{
				hideEditor();
			}
			
		}
		override protected function createChildren():void
		{
			super.createChildren();
//			editor = new TableItemEditor;
//			editor.visible = false;
//			addChild(editor);
		}
		override protected function processKeyPressed(event:KeyboardEvent):void
		{
			
			showEditor();
			if (event.charCode > 0)
			{
				var s:Spreadsheet = Spreadsheet(table.dataProvider);
				editor.text = "";
				if (String.fromCharCode(event.charCode) == "=")
				{
					startAddressSelection();
				}
				FormatUtils.applyStyle(s, _startColIndex, _startRowIndex, editor);
				editor.validateNow();
				invalidateDisplayList();
			}
		}
		private function convertToEditor(tf:UITextField):void
		{
			editor.type = TextFieldType.INPUT;
			addChild(editor);
		}
		private function convertToRenderer(tf:UITextField):void
		{
			editor.type = TextFieldType.DYNAMIC;
			table.contentHolder.addChild(editor);
		}
		private function showEditor():void
		{
			showTool = false;
			tool.visible = false;
			minItemWidth = 0;
//			editor.visible = true;
			editor = UITextField(table.getRenderer(_startRowIndex - topRowIndex, _startColIndex - leftColumnIndex));
			editor.border = true;
			convertToEditor(editor);						 						 
			colIndex = _startColIndex;
			rowIndex = _startRowIndex;
			var s:Spreadsheet = Spreadsheet(table.dataProvider);
			var formula:String = s.getFormulaAt(colIndex, rowIndex);
			if (formula)
			{
				editor.text = "="+formula;
			}
			editor.text =  s.getTextValueAt(colIndex, rowIndex);
			editor.validateNow();
			unregisterKeyboardListeners();
			table.addEventListener(KeyboardEvent.KEY_DOWN, editorKeyDownHandler);
			editor.addEventListener(FocusEvent.FOCUS_OUT, textAreaFocusOut);
			editor.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, textAreaFocusOut);
			editor.setFocus();
			FormatUtils.applyStyle(s, colIndex, rowIndex, editor);
			editor.validateNow();
			invalidateDisplayList();
			
		}
		
		private function hideEditor(saveContent:Boolean = true):void
		{
			editor.removeEventListener(FocusEvent.FOCUS_OUT, textAreaFocusOut);
			editor.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, textAreaFocusOut);
//			editor.visible = false;
			editor.border = false;
			showTool = true;
			var s:Spreadsheet = Spreadsheet(table.dataProvider);
			if (saveContent) s.setTextValueAt(colIndex, rowIndex, editor.text);
			//_startColIndex = _endColIndex = colIndex; // DENIS: bug with typing and selecting another cell 
			//_startRowIndex = _endRowIndex = rowIndex;
			convertToRenderer(editor);
			editor.validateNow();
			editor = null;
			dispatchEvent(new TableEvent(TableEvent.ITEM_EDIT_END));
			table.removeEventListener(KeyboardEvent.KEY_DOWN, editorKeyDownHandler);
			registerKeyboardListeners();
			table.setFocus();
			endAddressSelection();
			invalidateDisplayList();
		}
		override protected function addAddress(range:Rectangle):void
		{
			super.addAddress(range);
			var address : String = Utils.rectToString(range);
			editor.appendText(address);
			editor.setSelection(editor.text.length,editor.text.length);
		}
		private function editorKeyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode != Keyboard.ENTER && event.keyCode != Keyboard.TAB && 
				event.keyCode != Keyboard.ESCAPE)
			{
				if (editor.text == "=") startAddressSelection();
				if (addressEditor)
				{
					addressEditor.text = editor.text;
				}
				invalidateDisplayList();
				return;
			}
			hideEditor(event.keyCode != Keyboard.ESCAPE);
			moveByKey(event);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (!editor) return;
			var r:Rectangle = getEditorRect();
			editor.move(r.x+1, r.y+1);
			if (r.width > minItemWidth) minItemWidth = r.width;
			else r.width = minItemWidth;
			editor.setActualSize(r.width - 1, r.height - 1);
		}
		private function getEditorRect():Rectangle
		{
			var r:Rectangle = new Rectangle;
			var xi:int = colIndex - leftColumnIndex;
			var yi:int = rowIndex - topRowIndex;
			r.x = xi > 0?table.xPoints[xi -1]:0;
			r.y = yi > 0?table.yPoints[yi -1]:0;
			r.height = table.yPoints[yi] - r.y;
			r.width = table.getTextFieldWidth(r.x,editor, Spreadsheet.FORMAT_TEXT);

			return r;
		}
		
	}
}