package controls.selectionClasses
{
	import flash.display.Graphics;
	import flash.display.Shape;

	public class SelectionRenderer extends Shape implements ISelectionRenderer 
	{
		public var editable:Boolean;
		public var explicitHeight : int;
		public var explicitWidth : int;
		
		public function paint(color:int = 0x5290BC):void
		{
			var g:Graphics = this.graphics;
	    	g.clear();
	        g.beginFill(color, 0.3);
	        g.drawRect(0, 0, explicitWidth, explicitHeight);
	        g.endFill();
		}
	}
	
}