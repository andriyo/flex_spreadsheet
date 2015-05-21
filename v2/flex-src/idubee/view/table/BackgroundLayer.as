package idubee.view.table
{
	import flash.geom.Point;
	
	public class BackgroundLayer extends BaseLayer
	{
		public function BackgroundLayer(table:Table)
		{
			super(table);
		}
		override protected function updateDisplayList(width:Number, height:Number):void
		{
			super.updateDisplayList(width, height);
			if (!table) return;
			if (!table.workbook) return;
			graphics.clear();
			graphics.beginFill(table.workbook.baseColor, 1);
	        graphics.lineStyle(1,table.workbook.mainColor);
	        graphics.drawRect(0, 0, width, height);
	        graphics.endFill();
	        
	        graphics.lineStyle(1, table.workbook.neutralColor);
	        for (var xi:int = 0; xi < table.visibleColumnsCount; xi++)
	        {
	        	var x:int = table.xPos[xi];
	        	graphics.moveTo(x,0);
	        	graphics.lineTo(x, height);
	        }
    	    for (var yi:int = 0; yi < table.visibleRowsCount; yi++)
	        {
	        	var y:int = table.yPos[yi];
	        	graphics.moveTo(0, y);
	        	graphics.lineTo(width, y);
	        }	
		}
	}
}