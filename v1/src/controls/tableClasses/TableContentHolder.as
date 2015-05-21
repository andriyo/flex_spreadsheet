package controls.tableClasses
{
	import controls.Table;
	
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;

	public class TableContentHolder extends UIComponent
	{
		public function TableContentHolder(parentTable:Table)
		{
			this.parentTable = parentTable;
			var visibleContentRect:Rectangle = new Rectangle();
			scrollRect = visibleContentRect;
			mouseEnabled = false;
		}
		private var parentTable:Table;
	}
}