package controls.tableClasses
{
	import flash.events.TextEvent;
	import flash.text.TextFieldType;
	
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.managers.IFocusManagerComponent;
	use namespace mx_internal;
	public class TableItemEditor extends UITextField implements IFocusManagerComponent,  IDropInTableRenderer
	{

		public function get focusEnabled():Boolean
		{
			return true;
		}
		public function set focusEnabled(value:Boolean):void
		{
		}
		public function get mouseFocusEnabled():Boolean
		{
			return true;
		}
		override public function get tabEnabled():Boolean
		{
			return true;
		}
		override public function get tabIndex():int
		{
			return -1;
		} 
		public function drawFocus(isFocused:Boolean):void
		{
			
		} 
	
		
		public function TableItemEditor()
		{
			selectable = true;
			alwaysShowSelection = true;
			enabled = true;
			type = TextFieldType.DYNAMIC;
//			addEventListener(TextEvent.TEXT_INPUT, textChangedHandler);
			background = true; 
//			setStyle("borderStyle",null);
//			super.
		}
		private function textChangedHandler(event:TextEvent):void
		{
			validateNow();
			invalidateDisplayList();
		}
		private var _tableData:TableData;
	
//		[Bindable("dataChange")]
		
		public function get tableData():TableData
		{
			return _tableData;
		}
	
		/**
		 *  @private
		 */
		public function set tableData(value:TableData):void
		{
			_tableData = value;
		}
		
//		override protected function createChildren():void
//		{
//			super.createChildren();
////			textField.autoSize = TextFieldAutoSize.LEFT;
//			mx_internal::getTextField().alwaysShowSelection = true;
//		}
//		public function moveCaretToEnd():void
//		{
//			if (text.length > 0)
//			textField.setSelection(text.length - 1, text.length - 1);
//		}
		
	}
}