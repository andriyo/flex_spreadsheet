package idubee.view.table
{
	import flash.filters.DropShadowFilter;
	
	import mx.core.UIComponent;
	
	public class SelectionTool extends UIComponent
	{
		public var selectionLayer:SelectionLayer;
		private var marker : ToolMarker;
		private var menuMarker :MenuMarker;
		
		public function SelectionTool(selectionLayer:SelectionLayer)
		{
			this.selectionLayer = selectionLayer;
			super();
			var shadow : DropShadowFilter = new DropShadowFilter();
			shadow.alpha = .5;
			shadow.distance = 3;
			shadow.angle = 25;
			
			filters = [shadow];
			//mouseEnabled = false;
		}
		
		override protected function createChildren():void
		{
			marker = new ToolMarker(this);
			addChild(marker);
			menuMarker = new MenuMarker();
			addChild(menuMarker);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			graphics.clear();
			if (unscaledHeight > 0 && unscaledWidth > 0)
			{
				graphics.lineStyle(3, selectionLayer.table.workbook.mainColor, 1, true);
				graphics.drawRoundRect(-4, -4, unscaledWidth + 7, unscaledHeight + 7, 6, 6);
				marker.visible = true;
				menuMarker.visible = true;
				marker.x = unscaledWidth + 2,
				marker.y = unscaledHeight + 2;
				marker.draw();
				menuMarker.x = unscaledWidth + 2;
				menuMarker.y = unscaledHeight + 2;
				menuMarker.drawMenuMarker();
			}
			else
			{
				marker.visible = false;
				menuMarker.visible = false;
			}
			
			
		}

	}
}