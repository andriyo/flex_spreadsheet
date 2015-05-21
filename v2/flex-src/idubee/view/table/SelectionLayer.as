package idubee.view.table
{
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import idubee.events.EditorEvent;
	import idubee.events.KeyEditorEvent;
	import idubee.events.TextFormatEvent;
	import idubee.events.TypeInEvent;
	import idubee.model.Cell;
	import idubee.model.EditorCtx;
	import idubee.model.HotKey;
	import idubee.model.Pnt;
	import idubee.model.Rect;
	import idubee.model.Spreadsheet;
	import idubee.model.SpreadsheetEvent;
	import idubee.view.cell.CellRenderer;
	
	public class SelectionLayer extends BaseLayer
	{
		private var selectionTool:SelectionTool;
		public var selectionMode:Boolean;
		public var shiftSelectionMode:Boolean;
		private var editCellRenderer:CellRenderer;
		public var editMode:Boolean;
		private var newCellEditing:Boolean;
		private var cursor:Pnt;
		private var ctx:EditorCtx = EditorCtx.ctx;
		public function SelectionLayer(table:Table)
		{
			super(table);
			doubleClickEnabled = true;
			mouseEnabled = true;
			mouseChildren = true;
			tabEnabled = false;
			table.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClickHandler);
			table.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, selectionKeyFocusOut);
		}
		private function selectionKeyFocusOut(event:FocusEvent):void
		{
			event.preventDefault();
		}
		private function mouseDoubleClickHandler(event:MouseEvent):void
		{
			startEdit();
		}
		private function startEdit():void
		{
			if (editMode) exitEdit();
			var s:Spreadsheet = table.spreadsheet;
			cursor = s.startPnt.clonePnt();
			editMode = true;
			editCellRenderer = table.getCursorRenderer();
			if (!editCellRenderer)
			{
				newCellEditing = true;
				editCellRenderer = table.workbook.defaultCellRenderer;
				editCellRenderer.table = table;
				editCellRenderer.cell = new Cell;
				editCellRenderer.updateRenderer();
				
				table.layoutRenderer(editCellRenderer,cursor.x, cursor.y);
			}
			else
			{
				newCellEditing = false;
			}
			selectionTool.visible = false;
			addChild(editCellRenderer);
			addListeners();
			editCellRenderer.enterEditMode();
			invalidateDisplayList();
			doubleClickEnabled = false;
			ctx.cellEditor = editCellRenderer;
		}
		public function exitEdit():void
		{
			if (!editMode) return;
			editMode = false;
			removeListeners();
			if (newCellEditing)
			{
				removeChild(editCellRenderer);
			}
			else
			{
				editCellRenderer.exitEditMode();
				table.dataLayer.addChild(editCellRenderer);
			}
			table.setFocus();
			table.invalidateAll();
			doubleClickEnabled = true;
			ctx.cellEditor = null;
			selectionTool.visible = true;
		}
		public function commitEdit():void
		{
			var s:Spreadsheet = table.spreadsheet;
			var cell:Cell;
			if (editCellRenderer.text || !newCellEditing)
			{
				var e:TypeInEvent = new TypeInEvent(TypeInEvent.TYPE_IN);
				e.range = new Rect(cursor.x, cursor.y);
				e.value = editCellRenderer.htmlText;
				e.dispatch();
			}
			exitEdit();
		}
		private function cancelEdit():void
		{
			var s:Spreadsheet = table.spreadsheet;
			var cell:Cell = s.getCellAt(cursor.x, cursor.y);
			if (cell)
			{
				editCellRenderer.updateRenderer(); 				
			}
			exitEdit();
		}
		private function addListeners():void
		{
			editCellRenderer.addEventListener(KeyboardEvent.KEY_DOWN, editKeyDownHandler);
			editCellRenderer.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, editFocusOutHandler);
			editCellRenderer.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, editFocusOutHandler);
			editCellRenderer.addEventListener(MouseEvent.MOUSE_UP, editMouseUpHandler);
		}
		private function removeListeners():void
		{
			editCellRenderer.removeEventListener(KeyboardEvent.KEY_DOWN, editKeyDownHandler);
			editCellRenderer.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, editFocusOutHandler);
			editCellRenderer.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, editFocusOutHandler);
			editCellRenderer.removeEventListener(MouseEvent.MOUSE_UP, editMouseUpHandler);
		}
		private function editMouseUpHandler(event:MouseEvent):void
		{
			//for text format updates
			new TextFormatEvent(TextFormatEvent.TEXTFIELD_CHANGED).dispatch();	
		}
		protected function editFocusOutHandler(event:FocusEvent):void
		{
			if (event.relatedObject is SelectionLayer)
				commitEdit(); 
		}
		private function editKeyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ESCAPE)
			{
				cancelEdit();
			}
			if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.RIGHT)
			{
				//for text format updates
				var e:TextFormatEvent = new TextFormatEvent(TextFormatEvent.TEXTFIELD_CHANGED);
				callLater(e.dispatch);
			}
			if (event.keyCode == Keyboard.TAB || event.keyCode == Keyboard.ENTER)
			{
				commitEdit();
				navigate(event);
			}
			event.stopImmediatePropagation();
		}
		public function navigate(event:KeyboardEvent):void
		{
			var dX:int = 0;
			var dY:int = 0;
			var keyCode:int = event.keyCode;
			var s:Spreadsheet = table.spreadsheet;
			if (keyCode == Keyboard.DELETE) 
			{
				new EditorEvent(EditorEvent.DELETE).dispatch();
				return;
			}
			var m:Pnt;
			if (keyCode == Keyboard.TAB || keyCode == Keyboard.ENTER)
			{
				switch (keyCode)
				{
					case Keyboard.TAB: dX = event.shiftKey? -1 : 1; break; 
					case Keyboard.ENTER: dY = event.shiftKey? -1 : 1; break;
				}
				m = s.startPnt;
				if (moved(dX,dY)) s.selections.length = 0;
				if (isConstrained(m.x, dX, s.maxX)) m.x += dX;
				if (isConstrained(m.y, dY, s.maxY)) m.y += dY;
				s.endPnt = s.startPnt.clonePnt();
			}
			else
			{
				switch (keyCode)
				{
					case Keyboard.LEFT: dX = -1; break;
					case Keyboard.RIGHT: dX = 1; break;
					case Keyboard.UP: dY = -1; break;
					case Keyboard.DOWN: dY = 1; break;
					case Keyboard.TAB: dX = event.shiftKey? -1 : 1; break; 
					case Keyboard.ENTER: dY = event.shiftKey? -1 : 1; break;
					default: new KeyEditorEvent(event, HotKey.CONTEXT_SHEET).dispatch(); return;
				}
				m = event.shiftKey ? s.endPnt : s.startPnt;
				
				if (event.ctrlKey)
				{
					var nextP:Point = s.findNextNotEmptyCell(new Point(dX, dY), m);
					if (nextP)
					{
						s.startPnt = new Pnt(nextP.x, nextP.y);
					}
					else
					{
						return;
					}
				}
				else
				{
					if (moved(dX,dY)) s.selections.length = 0;
					if (isConstrained(m.x, dX, s.maxX)) m.x += dX;
					if (isConstrained(m.y, dY, s.maxY)) m.y += dY;
				}
				if (!event.shiftKey) s.endPnt = s.startPnt.clonePnt();
				shiftSelectionMode = event.shiftKey;
			}
			moveVisibleRect(s.endPnt.x, s.endPnt.y);
			//for text format updates
			new TextFormatEvent(TextFormatEvent.TEXTFIELD_CHANGED).dispatch();
			selectionChanged(s.makeCurrentSelectionRect().swap());
			invalidateDisplayList();
			table.headerLayer.invalidateDisplayList();
		}
		private function moveVisibleRect(x:int, y:int):void
		{
			var v:Rect = table.visibleIndexRect;
			var dX:int = Math.max((x - v.right),0) - Math.max((v.x - x), 0);
			var dY:int = Math.max((y - v.bottom),0) - Math.max((v.y - y), 0);
			if (!moved(dX, dY)) return;
			if (isConstrained(table.startXIndex, dX, table.spreadsheet.maxX)) 
			{
				table.startXIndex += dX;
			}
			if (isConstrained(table.startYIndex, dY, table.spreadsheet.maxY)) 
			{
				table.startYIndex += dY;
			} 
		}
		private function isConstrained(z:uint, dZ:int, maxZ:uint):Boolean
		{
			return !(dZ < 0 && (int(z) + dZ) < 0) || (dZ > 0 && z > maxZ);
		}
		private function moved(dX:uint, dY:uint):Boolean
		{
			return dX * dX + dY * dY > 0;
		}
		private function mouseDownHandler(event:MouseEvent):void
		{
			if (event.target != this) return;
			var s:Spreadsheet = table.spreadsheet;
			var p:Pnt = table.mouseToIndex(event);
			shiftSelectionMode = event.shiftKey;
			selectionMode = true;
			if (!shiftSelectionMode)
			{
				s.startPnt = p;
				s.endPnt = s.startPnt.clonePnt();
			}
			else
			{
				s.endPnt = p;
			}
			if (!event.ctrlKey)
			{
				
				s.selections.length = 0;
			}
			//for text format updates
			new TextFormatEvent(TextFormatEvent.TEXTFIELD_CHANGED).dispatch();
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			invalidateDisplayList();
			table.headerLayer.invalidateDisplayList();
		} 
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			if (event.target != this) return;
			var s:Spreadsheet = table.spreadsheet;
			var p:Pnt = table.mouseToIndex(event);
			if (p.equals(s.endPnt)) return;
			s.endPnt = p;
			invalidateDisplayList();
			table.headerLayer.invalidateDisplayList();
		}
		private function mouseUpHandler(event:MouseEvent):void
		{
			if (event.target != this) return;
			var s:Spreadsheet = table.spreadsheet;
			selectionMode = false;
			shiftSelectionMode = false;
			var cs:Rect = s.makeCurrentSelectionRect().swap();
			s.selections.push(cs);
			selectionChanged(cs);
			invalidateDisplayList();
			table.headerLayer.invalidateDisplayList();
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		private function selectionChanged(newSelection:Rect):void
		{
			var s:Spreadsheet = table.spreadsheet;
			var e:SpreadsheetEvent = new SpreadsheetEvent(SpreadsheetEvent.SELECTION_CHANGED);
			e.newSelection = newSelection;
			e.cell = s.getCellAt(s.startPnt.x,s.startPnt.y); 
			table.dispatchEvent(e);	
		}
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			if ((event.charCode > 31 || event.keyCode == Keyboard.F2) 
				&& !event.ctrlKey && event.keyCode != Keyboard.DELETE)
			{
				startEdit();
			}
			else
			{
				navigate(event);
			}
		}
		
		override protected function createChildren():void
		{
			selectionTool = new SelectionTool(this);
			addChild(selectionTool);	
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (!table) return;
			if (!table.workbook) return;
			var s:Spreadsheet = table.spreadsheet;
			graphics.clear();
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
			graphics.endFill();
			graphics.beginFill(table.workbook.work1Color,0.2);
			for each (var rect:Rect in s.selections)
			{
				drawRect(rect);
			} 
			graphics.endFill();
			
			var cs:Rect = new Rect;
				cs.topLeft = s.startPnt;
				cs.bottomRight = s.endPnt;
				cs = cs.swap();
			if (selectionMode || shiftSelectionMode)
			{
				graphics.beginFill(table.workbook.work1Color,0.2);
				drawRect(cs);
				graphics.endFill()
			}
			cs.width = cs.width  + 1;
			cs.height = cs.height + 1;
			
			var r:Rect = table.buildCellRect(cs.x,cs.y,
				cs.width, cs.height);
			selectionTool.move(r.x,r.y);
			selectionTool.setActualSize(r.width,r.height);
		}
		private function drawRect(rect:Rect):void
		{
			var s:Spreadsheet = table.spreadsheet;
			var vr:Rect = table.visibleIndexRect;
			var x1:int = Math.max(vr.x, rect.x);
			var x2:int = Math.min(vr.right, rect.right);
			var y1:int = Math.max(vr.y, rect.y);
			var y2:int = Math.min(vr.bottom, rect.bottom);
			var r:Rect = table.buildCellRect(x1,y1,x2 - x1 +1,y2 - y1+1);
			graphics.drawRect(r.x,r.y,r.width,r.height);
			if (rect.overlaps(s.startPnt.x, s.startPnt.y))
			{
				r = table.buildCellRect(s.startPnt.x,s.startPnt.y,1,1);
				graphics.drawRect(r.x,r.y,r.width,r.height);
			}
		}
		
		
	}
}