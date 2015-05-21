package controls.selectionClasses
{
	import controls.Table;
	
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;

	public class SelectTool extends UIComponent
	{
		public var sLayer:SelectionLayer;
		private var _startColIndex : int = 0;
		private var _startRowIndex : int = 0;
		private var _endColIndex : int;
		private var _endRowIndex : int;
		private var marker : ToolMarker;
		private var menuMarker :MenuMarker;
		
		
		public function SelectTool(selectionLayer:SelectionLayer)
		{
			sLayer = selectionLayer;
		}
		override protected function createChildren():void
		{
			marker = new ToolMarker(this);
			marker.addEventListener(MouseEvent.MOUSE_DOWN, toolMarkerMouseDown);
			addChild(marker);
			menuMarker = new MenuMarker();
			addChild(menuMarker);
			menuMarker.table = sLayer.table;	
		}
		private function toolMarkerMouseDown(event:MouseEvent):void
		{
			sLayer.fillSelectionMode = true;
		}
		private function toolMarkerMouseMove(event:MouseEvent):void
		{
			
		}
		private function toolMarkerMouseUp(event:MouseEvent):void
		{
			sLayer.fillSelectionMode = false;
		}
		private function onMarkerMouseOver(event : MouseEvent):void
		{
			
		}
		
		public function setCoordinates(leftColumnIndex:int, topRowIndex:int,  startColIndex:int, startRowIndex:int, endColIndex:int, endRowIndex:int):void
		{
			_startColIndex = startColIndex - leftColumnIndex;
			_startRowIndex = startRowIndex - topRowIndex;
			_endColIndex = endColIndex - leftColumnIndex;
			_endRowIndex = endRowIndex - topRowIndex;
			invalidateDisplayList();
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			swapStartEnd();
			var t:Table = sLayer.table;
			var x1:int;
			var y1:int;
			var x2:int;
			var y2:int;
			var skip:Boolean;
			if (_startColIndex == 0) 
			{
				x1 = 0;			
			}
			else if (_startColIndex < 0)
			{
				x1 = -3;
			} 
			else
			{
				x1 = (_startColIndex - 1 < t.xPoints.length)? t.xPoints[_startColIndex - 1]
				 												:t.xPoints[t.xPoints.length -1] + 3;
			}
			if (_startRowIndex == 0)
			{
				y1 = 0;				
			}
			else if (_startRowIndex < 0)
			{
				y1 = -3;
			} 
			else
			{
				y1 = (_startRowIndex - 1 < t.yPoints.length)? t.yPoints[_startRowIndex - 1]
				 												:t.yPoints[t.yPoints.length -1] + 3;
			}
			if (_endColIndex < 0)
			{
				skip = true;
			}
			else
			{
				x2 = (_endColIndex< t.xPoints.length)? t.xPoints[_endColIndex]
				 												:t.xPoints[t.xPoints.length -1] + 3;	
			}
			if (_endRowIndex < 0)
			{
				skip = true;
			}
			else
			{
				y2 = (_endRowIndex< t.yPoints.length)? t.yPoints[_endRowIndex]
				 												:t.yPoints[t.yPoints.length -1] + 3;	
			}
			graphics.clear();
			if (skip)
			{
				marker.visible = false;
				return;
			}
			else
			{
				marker.visible = true;
			}
			
			graphics.lineStyle(3,0);
			
			//var gradientBoxMatrix:Matrix = new Matrix();
			//gradientBoxMatrix.createGradientBox(200, 40, 0, 0, 0);
			//graphics.lineGradientStyle(GradientType.LINEAR, [0xFF0000, 0x00FF00, 0x0000FF], [1, 1, 1], [0, 128, 255], gradientBoxMatrix);
			
			graphics.moveTo(x1,y1);
			graphics.lineTo(x2,y1);
			graphics.lineTo(x2,y2);
			graphics.lineTo(x1,y2);
			graphics.lineTo(x1,y1);
			
			marker.setXY(x2, y2);
			marker.setActualSize(unscaledWidth, unscaledHeight);
			menuMarker.drawMenuMarker(x2, y2);
		}
		
		private function swapStartEnd():void
		{
			if (_endColIndex < _startColIndex)
			{
				_startColIndex = _startColIndex + _endColIndex;
				_endColIndex = _startColIndex-_endColIndex;
				_startColIndex = _startColIndex-_endColIndex;				
			}
			if (_endRowIndex < _startRowIndex)
			{
				_startRowIndex = _startRowIndex + _endRowIndex;
				_endRowIndex = _startRowIndex-_endRowIndex;
				_startRowIndex = _startRowIndex-_endRowIndex;
			}
		}
	}
}