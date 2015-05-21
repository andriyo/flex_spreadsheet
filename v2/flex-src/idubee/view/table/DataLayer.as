package idubee.view.table
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import idubee.model.Cell;
	import idubee.model.Pnt;
	import idubee.model.Rect;
	import idubee.model.Spreadsheet;
	import idubee.view.cell.CellRenderer;
	
	public class DataLayer extends BaseLayer
	{
		private var available:Array;
		private var used:Array;
		private var renderers:Dictionary;
		public function DataLayer(table:Table)
		{
			super(table);
			available = [];
			used = [];
			renderers = new Dictionary(true);
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (!table) return;
			if (!table.workbook) return;
			if (table.selectionLayer.editMode)
			{
				table.selectionLayer.commitEdit();
			}
			available = available.concat(used);
			hideAll();
			used = [];
			var vr:Rect = table.visibleIndexRect;
			var s:Spreadsheet = table.spreadsheet;
			var needToDrawAgain:Boolean;
			for (var yi:uint = vr.y; yi <= vr.bottom; yi++)
			{
				var maxRowHeight:int = 0;
				for (var xi:uint = vr.x; xi <= vr.right; xi++)
				{
					var c:Cell = s.getCellAt(xi, yi);
					if (!c) continue;
					var cr:CellRenderer = fetchRenderer(c);
					table.layoutRenderer(cr, xi, yi);
					setChildIndex(cr,numChildren - 1);
					used.push(cr);
					maxRowHeight = Math.max(cr.textHeight,maxRowHeight);
				}
				
				if (s.getRowHeight(yi) < maxRowHeight)
				{
//					trace("maxRowHeight", maxRowHeight);
					s.setAutoRowHeight(yi,maxRowHeight + CellRenderer.TEXT_HEIGHT_PADDING);
					needToDrawAgain = true;
				}
//				else if (s.rowAutoHeight[yi] > maxRowHeight + CellRenderer.TEXT_HEIGHT_PADDING)
//				{
//					trace("delete");
//					delete s.rowAutoHeight[yi];
//					callLater(table.invalidateAll);
//					return;
//				}
			}
//			trace("available after "+available.length);
			if (needToDrawAgain)
			{
				callLater(table.invalidateAll);
			}
		}

		private function fetchRenderer(cell:Cell):CellRenderer
		{
			var cr:CellRenderer;
			if (renderers[cell])
			{
				var crIndex:int = available.indexOf(renderers[cell]);
				if (crIndex == -1)
				{
					delete renderers[cell];
				}
				else
				{
					cr = CellRenderer(available[crIndex]);
					prepareRenderer(cr,cell);
					available.splice(crIndex,1);
					return cr;
				}
			}
			if (available.length)
			{
				cr = CellRenderer(available.pop());
			}
			else
			{
				cr = new CellRenderer();
				cr.table = table;
				addChild(cr);
			}
			prepareRenderer(cr,cell);
			renderers[cell] = cr;
			return cr;
		}
		public function getRendererAt(p:Pnt):CellRenderer
		{
			var s:Spreadsheet = table.spreadsheet;
			var cell:Cell = s.getCellAt(p.x,p.y);
			var cr:CellRenderer = renderers[cell];
			return cr;
		}
		private function prepareRenderer(cr:CellRenderer, cell:Cell):void
		{
			cr.cell = cell;
			cr.visible = true;
		}
		
		private function hideAll():void
		{
			for each (var rend:DisplayObject in available)
			{
				rend.visible = false;
			}
			
		}
	}
}