package controls.tableClasses
{
	import controls.BorderedTable;
	
	import flash.events.MouseEvent;
	
	import model.Spreadsheet;
	
	import mx.core.UIComponent;
	import mx.core.UITextField;

	public class HeaderSlider extends UIComponent
	{
		private var borderedTable:BorderedTable;
		public var index:int;
		public var stickSize:int = 20;
		public var orientation:int;
		
		public function HeaderSlider(orientation:int, borderedTable:BorderedTable)
		{
			this.borderedTable = borderedTable;
			this.orientation = orientation;
			doubleClickEnabled = true;
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClickHandler)
			
			
		}
		private var isMouseOver:Boolean;
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			borderedTable.changeCursor(this);
			borderedTable.startDividerDrag(this, event);
			systemManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
		}
		private function mouseUpHandler(event:MouseEvent):void
		{
			if (!isMouseOver)
				borderedTable.restoreCursor();
			borderedTable.stopDividerDrag(this, event);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
		}
		private function mouseOverHandler(event:MouseEvent):void
		{
			isMouseOver = true;
			if (!borderedTable.activeDivider)
			{
				borderedTable.changeCursor(this);
			}
		}
		private function mouseOutHandler(event:MouseEvent):void
		{
			isMouseOver = false;
			if (!borderedTable.activeDivider)
			{
				if (parent)
					borderedTable.restoreCursor();
			}
		}
		
		private function mouseDoubleClickHandler(evenjt : MouseEvent):void
		{
			var maxWidth : int = 0;
			var maxHeight : int = 0;
			var s:Spreadsheet = Spreadsheet(borderedTable.dataProvider);
			var tempTextField : UITextField = new UITextField();
			
			if (orientation == HeaderCell.ORIENTATION_HORIZONTAL)
			{
				for(var i : int = 0; i < s.rowsCount; i++)
				{
					//var tempTextField : UITextField = new UITextField();
					
					if (s.getTextValueAt(index, i))
					{
						
						if (borderedTable.table.isRendererInPosition(i, index))
						{
							tempTextField = UITextField(borderedTable.table.getRenderer(i, index));
							maxWidth = Math.max(maxWidth, tempTextField.getExplicitOrMeasuredWidth() + 8);	
						}
					}
				}
				if (maxWidth > 0) s.setColumntWidth(index, maxWidth);
				
								
			} else { //HeaderCell.ORIENTATION_VERTICAL
				
				for(i  = 0; i < s.columnsCount; i++)
				{
					if (s.getTextValueAt(i, index))
					{
						if (borderedTable.table.isRendererInPosition(index, i))
						{
							tempTextField = UITextField(borderedTable.table.getRenderer(index, i));
							maxHeight = Math.max(maxHeight, tempTextField.textHeight + 5);	
						}
					}
				}
				if (maxHeight > 0) s.setRowHeigth(index, maxHeight);
			}
			
			borderedTable.invalidateDisplayList();
			
		}
		
		public function paint():void
		{
			
			
			if (orientation == HeaderCell.ORIENTATION_HORIZONTAL)
			{
				graphics.beginFill(0,0);
				graphics.drawRect(-4,0,8,stickSize);
				graphics.endFill();
				graphics.lineStyle(1,0xAAAAAA);
				graphics.moveTo(0,0);
				graphics.lineTo(0, stickSize);
			} else
			{
				graphics.beginFill(0,0);
				graphics.drawRect(0,-4,stickSize,8);
				graphics.endFill();
				graphics.lineStyle(1,0xAAAAAA);
				graphics.moveTo(0,0);
				graphics.lineTo(stickSize, 0);			}
		}
		
	}
}