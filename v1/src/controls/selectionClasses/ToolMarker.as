package controls.selectionClasses
{
	import controls.Table;
	import controls.tableClasses.Utils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.Spreadsheet;
	
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.events.EffectEvent;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;

	public class ToolMarker extends UIComponent
	{
		private var anime : Fade;
		public var posMarkerX : int;
		public var posMarkerY : int;
		private var cursorID:int = CursorManager.NO_CURSOR;
		
		private var selectionTool : SelectTool;
		private var autoFillMode:Boolean;
		public var _startColIndex : int = 0;
		public var _startRowIndex : int = 0;
		public var _endColIndex : int;
		public var _endRowIndex : int;
		private var origin:Rectangle;
		[Embed(source="/assets/cursors/crossHand.png")]
		private var crossHandCursor : Class;
		private var table:Table;
		public function ToolMarker(selectTool:SelectTool):void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMarkerMouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE, onMarkerMouseMove);
			addEventListener(MouseEvent.MOUSE_UP, onMarkerMouseUp);
			addEventListener(MouseEvent.MOUSE_OVER, onMarkerMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMarkerMouseOut);
			selectionTool = selectTool;
			table = selectTool.sLayer.table;
			anime = new Fade(this);
			anime.addEventListener(EffectEvent.EFFECT_END, onAnimeEffectEnd);
			anime.alphaFrom = 0.1;
			anime.alphaTo = 1;
			anime.duration = 1000;
			anime.play();
			
		}
		
		private function onMarkerMouseDown(event : MouseEvent):void
		{
			autoFillMode = true;
			startSelecting();
			invalidateDisplayList();
			anime.pause()
			alpha = 1;
		}
		
		private function onMarkerMouseMove(event : MouseEvent):void
		{
			if (autoFillMode)
			{
				continueSelecting(event.localX, event.localY);
			}
		}
		
		private function onMarkerMouseUp(event : MouseEvent):void
		{
			if (!autoFillMode) return;
			autoFillMode = false;
			endSelecting(event.localX, event.localY);
			anime.play();			
		}
		private function startSelecting():void
		{
			_startColIndex = selectionTool.sLayer._startColIndex;
			_startRowIndex = selectionTool.sLayer._startRowIndex;
			_endColIndex = selectionTool.sLayer._endColIndex;
			_endRowIndex = selectionTool.sLayer._endRowIndex;
			origin = selectionTool.sLayer.makeRectFromIndexes()
		}
		
		private function continueSelecting(x:int, y:int):void
		{
			var p:Point = table.mouseToDataPoint(x, y);
			var colIndex:int = p.x + selectionTool.sLayer.leftColumnIndex;
			var rowIndex:int = p.y + selectionTool.sLayer.topRowIndex;
			
			if (_endColIndex == colIndex && _endRowIndex == rowIndex) return;
			
			var dest:Rectangle = calculateDest(new Point(colIndex, rowIndex));
			_endColIndex = dest.right;
			_endRowIndex = dest.bottom;
			invalidateDisplayList();
		}
		private function findVector(dest:Rectangle):Point
		{
			var p:Point = new Point;
			if (dest.width == origin.width)
			{
				var dy:int = origin.bottom - dest.bottom;
				p.y = dy / Math.abs(dy);	
			}
			else if (dest.height == origin.height)
			{
				var dx:int = origin.right - dest.right;
				p.x = dx / Math.abs(dx);	
			}
			return p;
		}
		private function calculateDest(p:Point):Rectangle
		{
			var current:Rectangle = Utils.makeRect(_startColIndex, _startRowIndex, _endColIndex, _endRowIndex);
			var dest:Rectangle = Utils.makeRect(origin.x, origin.y, p.x, p.y);
			var base:Point = p.subtract(origin.bottomRight);
			trace(base);
			if (base.x > base.y)
			{
				dest.height = origin.height;
			}
			else if (base.x < base.y)
			{
				dest.width = origin.width;
			}
			else
			{
				dest = current;	
			}
			return dest;
		}
		private function endSelecting(x:int, y:int):void
		{
			var p:Point = table.mouseToDataPoint(x, y);
			var colIndex:int = p.x + selectionTool.sLayer.leftColumnIndex;
			var rowIndex:int = p.y + selectionTool.sLayer.topRowIndex;
			var dest:Rectangle = calculateDest(new Point(colIndex, rowIndex));
			selectionTool.sLayer._endColIndex = dest.right;
			selectionTool.sLayer._endRowIndex = dest.bottom;
			selectionTool.sLayer.selected.clear();
			selectionTool.sLayer.selected
				.setValues(dest, true);
			selectionTool.sLayer.invalidateDisplayList();
			invalidateDisplayList();
			trace(findVector(dest));
			autoFill(origin, dest, findVector(dest));
		}
		private function onMarkerMouseOver(event : MouseEvent):void
		{
			if (cursorID == CursorManager.NO_CURSOR)
			{
				cursorID = CursorManager.setCursor(crossHandCursor,
									   CursorManagerPriority.HIGH,
									   -8, -10);	
			}
			
			graphics.clear();
			graphics.lineStyle(2, 0);
			graphics.beginFill(0x0CFF00, 1);
			graphics.drawCircle(posMarkerX, posMarkerY, 3);
			graphics.endFill();
		}
		
		private function onMarkerMouseOut(event : MouseEvent):void
		{
			CursorManager.removeCursor(cursorID);
			cursorID = CursorManager.NO_CURSOR;
			
			graphics.clear();
			graphics.lineStyle(2, 0);
			graphics.beginFill(0xFF0000, 1);
			graphics.drawCircle(posMarkerX, posMarkerY, 3);
			graphics.endFill();
		}
		
		private function onAnimeEffectEnd(event : EffectEvent):void
		{
			if (!autoFillMode)
			{
				anime.play();	
			}
		}
		public function setXY(x:int, y:int):void
		{
			posMarkerX = x;
			posMarkerY = y;
			invalidateDisplayList();
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var ix:int;
	    	var iy:int;
	    	var x:int;
	    	var y:int;
	    	var xiR:int;
	    	var yiR:int;
	    	var actualWidth:int;
	    	var actualHeight:int;
	    	var startXi:int;
	    	var startYi:int;
	    	
			graphics.clear();
			if (autoFillMode)
			{
				graphics.beginFill(0, 0);
				graphics.drawRect(0,0,unscaledWidth, unscaledHeight);
			}
			graphics.lineStyle(2, 0);
			graphics.beginFill(0xFF0000, 1);
			graphics.drawCircle(posMarkerX, posMarkerY, 3);
			graphics.endFill();
			
			if (!autoFillMode)
			{
				return;
			}
			startXi = selectionTool.sLayer.table.leftColumnIndex;
			startYi = selectionTool.sLayer.table.topRowIndex;
			
			xiR = _startColIndex - startXi;
	    	x = (xiR > 0)? table.xPoints[xiR - 1] : 0;
    		actualWidth = table.xPoints[_endColIndex - startXi] - x;
	
	    	yiR = _startRowIndex - startYi;
   			y = (yiR > 0)? table.yPoints[yiR - 1] : 0;
   			actualHeight = table.yPoints[_endRowIndex - startYi] - y;
   			graphics.beginFill(0x00fc00,0.2);
   			graphics.drawRect(x,y, actualWidth, actualHeight);
		}
		private function autoFill(original:Rectangle, dest:Rectangle, v:Point):void
		{
			if (original.equals(dest))
			{
				return;
			}
			for (var xi:int = dest.x; xi <= dest.right; xi ++)
			{
				for (var yi:int = dest.y; yi <= dest.bottom; yi ++)
				{
					if (!Utils.inRect(original, xi, yi))
					{
						fillSerie(xi, yi, v);
					}
				}
			}
			
		}
		private function fillSerie(xi:int, yi:int, v:Point):void
		{
			var p:Point = new Point(xi, yi);
			var s:Spreadsheet = Spreadsheet(selectionTool.sLayer.table.dataProvider);
			var copyMode:Boolean = false;
			p = p.add(v);
			var v1:String = s.getTextValueAt(p.x, p.y);
			if (s.getFormatAt(p.x, p.y) != Spreadsheet.FORMAT_NUMBER)
			{
				copyMode = true;
			}
			else
			{
				p = p.add(v);
				var v2:String = s.getTextValueAt(p.x, p.y);
				if (s.getFormatAt(p.x, p.y) != Spreadsheet.FORMAT_NUMBER)
				{
					copyMode = true
				}
				copyMode = copyMode || !v1 || !v2;
			}
			if (copyMode)
			{
				s.setTextValueAt(xi, yi, v1);
			}
			else
			{
				var n:Number = (Number(v1) - Number (v2)) + Number(v1);
				s.setTextValueAt(xi, yi, n.toString());
			}
		}
	}
}