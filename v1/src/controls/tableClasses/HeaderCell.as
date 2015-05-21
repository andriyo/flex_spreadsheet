package controls.tableClasses
{
	import controls.BorderedTable;
	import controls.Table;
	import controls.selectionClasses.SelectionLayer;
	
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import mx.controls.Label;

	public class HeaderCell extends Label
	{
		public var orientation:int;
		public static const ORIENTATION_VERTICAL:int = 1;
		public static const ORIENTATION_HORIZONTAL:int = 2;
		private var table:Table;
		private var borderedTable:BorderedTable;
		public var index:int;
		private var mouseOver:Boolean;
		
		public function HeaderCell(orientation:int, borderedTable:BorderedTable)
		{
			mouseChildren = false;
			this.setStyle("textAlign","center");
			this.orientation = orientation;
			this.table = borderedTable.table;
			this.borderedTable = borderedTable;
			this.index = index;
			addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler)
			addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler)
			addEventListener(MouseEvent.CLICK, headerClickHandler);	
		}
		
		private function onRollOutHandler(event : MouseEvent):void
		{
			mouseOver = false;
			refreshHeader();
		}
		
		public function refreshHeader():void
		{
			if (!isSelected()) 
			{
				graphics.clear();
			}
			else
			{
				paintSelection();
			}
			
		}
		
		private function isSelected():Boolean
		{
			if (orientation == ORIENTATION_HORIZONTAL)
			{
				return borderedTable.horizontalSelectedHeaders[index];
			} else {
				return borderedTable.verticalSelectedHeaders[index]
			}
		}
		
		private function onRollOverHandler(event : MouseEvent):void
		{
			if (isSelected()) return;
			if (mouseOver) return;
			mouseOver = true;
			var matr:Matrix = new Matrix();
			var rotation : Number = (orientation == 2)? Math.PI/2 : Math.PI*(-2);
			matr.createGradientBox(width, height, rotation, 0, 0);
			var ratios:Array = [0x00, 0xFF];
					
			graphics.beginGradientFill(GradientType.LINEAR, [0xB7BABC, 0xFFFFFF], [0, 1], [0, 255], matr, SpreadMethod.PAD);
			graphics.drawRect(0, 0, width, height);
		}
		
		private function headerClickHandler(event:MouseEvent):void
		{
			var selectionLayer:SelectionLayer = table.selectionLayer;
			if (!event.ctrlKey)
			{
				borderedTable.verticalSelectedHeaders.length = 0;
				borderedTable.horizontalSelectedHeaders.length = 0;
				selectionLayer.clearSelection();
			}
			if (orientation == ORIENTATION_HORIZONTAL)
			{
				borderedTable.horizontalSelectedHeaders[index] = !borderedTable.horizontalSelectedHeaders[index]; 
				selectionLayer.selectColumn(index);
			}
			else
			{
				borderedTable.verticalSelectedHeaders[index] = !borderedTable.verticalSelectedHeaders[index];
				selectionLayer.selectRow(index);
			}
			
			paintSelection();
		}
		
		private function paintSelection():void
		{
			if (isSelected())
			{
				graphics.clear();
				var matr:Matrix = new Matrix();
				var rotation : Number = (orientation == ORIENTATION_HORIZONTAL)? Math.PI/2 : Math.PI*(-2);
				matr.createGradientBox(width, height, rotation, 0, 0);
				var ratios:Array = [0x00, 0xFF];
						
				graphics.beginGradientFill(GradientType.LINEAR, [0xB7BABC, 0xFFFF00], [0, 1], [0, 255], matr, SpreadMethod.PAD);
				graphics.drawRect(0, 0, width, height);
			}
		}
	}
}