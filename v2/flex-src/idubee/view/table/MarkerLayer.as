package idubee.view.table
{
	import idubee.model.Cell;
	
	public class MarkerLayer extends BaseLayer
	{
		private var markerRenderers:Array = [];
		public function MarkerLayer(table:Table)
		{
			super(table);
			var mr:MarkerRenderer = new CommentMarkerRenderer;
			mr.table = table;
			markerRenderers.push(mr);
		}
		private function mapRects(item:*, index:int, array:Array):Rect
		{
			
			
		}
		override protected function updateDisplayList(width:Number, height:Number):void
		{
			super.updateDisplayList(width, height);
			var cells:Array = table.spreadsheet.getCellsInRect(table.visibleIndexRect);
			var rects:Array = cells.map();
			
			for each (var mr:MarkerRenderer in markerRenderers)
			{
				for each (var c:Cell in cells)
				{
					
					mr.render(c);
				}
				
			}
		}
	}
}