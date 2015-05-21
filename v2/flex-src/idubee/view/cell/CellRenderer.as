package idubee.view.cell
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import idubee.model.Cell;
	import idubee.view.table.Table;
	
	import mx.core.IUIComponent;
	import mx.managers.ISystemManager;

	public class CellRenderer extends TextField
	{
		public static const TEXT_HEIGHT_PADDING:int = 6;
		private var _cell:Cell;
		public var table:Table;
		
		public function CellRenderer()
		{
			super();
			background = true;
			mouseEnabled = false;
		}
		
		public function set cell(value:Cell):void
		{
			if (_cell && _cell.v == value.v) return;
			if (_cell)
			{
				_cell.currentCellRenderer = null;
			}
			_cell = value;
			_cell.currentCellRenderer = this;
			updateRenderer();
		}
		public function updateRenderer():void
		{
			defaultTextFormat = table.workbook.defaultTextStyle;
			setTextFormat(table.workbook.defaultTextStyle);
			if (cell)
			{
				htmlText = _cell.v.toString();
			}
			else
			{
				htmlText = "";
			}
			
		}
		
		public function get cell():Cell
		{
			return _cell;
		}
		
		public function setFocus():void
		{
			systemManager.stage.focus = this;
		}

		public function get systemManager():ISystemManager
	    {
	        var o:DisplayObject = parent;
	        while (o)
	        {
	            var ui:IUIComponent = o as IUIComponent;
	            if (ui)
	                return ui.systemManager;
	
	            o = o.parent;
	        }
	
	        return null;
   		}
   		public function enterEditMode():void
   		{
   			type = TextFieldType.INPUT;
			mouseEnabled = true;
			autoSize = TextFieldAutoSize.LEFT;
			alwaysShowSelection = true;
			setFocus();
   		}
   		public function exitEditMode():void
   		{
   			type = TextFieldType.DYNAMIC;
			autoSize = TextFieldAutoSize.NONE;
			mouseEnabled = false;
			alwaysShowSelection = false;
   		}
	}
}