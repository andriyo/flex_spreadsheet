package controls.selectionClasses
{
	import flash.display.Graphics;
	
	import mx.containers.Canvas;
	
	public class Selection extends Canvas
	{
		public function Selection(x : int, y : int, selectionWidth : Number, selectionHeight : Number):void
		{
			super();
			this.x = x;
			this.y = y;
			this.width = selectionWidth;
			this.height = selectionHeight;
			
			var g : Graphics = this.graphics;
	    	g.clear();
	    	g.lineStyle(2, 0x000000);
	        g.beginFill(0xFFFFFF, 0);
	        g.drawRect(0, 0, selectionWidth, selectionHeight);
	        g.endFill();
	        	
	        g.beginFill(0x2C66F9,1)
	        g.drawCircle(selectionWidth, selectionHeight, 3);
	        g.endFill();
		}
	}
}