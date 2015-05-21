package idubee.commands
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.history.HistoryToken;
	import com.adobe.cairngorm.history.IUndoableCommand;
	
	import flash.geom.Point;
	
	import idubee.events.EditorEvent;
	import idubee.model.Cell;
	import idubee.model.EditorCtx;
	import idubee.model.Pnt;
	import idubee.model.Rect;
	import idubee.model.Spreadsheet;
	import idubee.view.cell.CellRenderer;

	public class EditorCommand implements IUndoableCommand
	{
		public var ctx:EditorCtx;
		
		public function EditorCommand()
		{
			super();
		}
		
		public function startTransaction(event:CairngormEvent):HistoryToken
		{
			var t:HistoryToken = new HistoryToken;
			t.command = this;
			t.commandEvent = event;
			var e:EditorEvent = EditorEvent(event);
			if (event.type != EditorEvent.CUT && event.type != EditorEvent.DELETE
				&& event.type != EditorEvent.PASTE)
			{
				return t;
			}
			var s:Spreadsheet = ctx.s;
			
			if (event.type == EditorEvent.PASTE)
			{
				var c:Clipboard = ctx.clipboard;
				var rFirst:Rect = Rect(c.selections[0]);
				var startX:uint = rFirst.x;
				var startY:uint = rFirst.y;
				var nselections:Array  = [];
				var p:Pnt = s.startPnt;
				for (var i:int = 0; i < c.selections.length; i++)
				{
					var r:Rect = c.selections[i];
					r.x =p.x + (r.x  - startX);
					r.y = p.y + (r.y - startY);
					nselections.push(r);
				}
				t.originalState = s.getAbsoluteCopy(nselections);
			}
			else
			{
			t.originalState = s.getAbsoluteCopy(s.selections);
			}
			
			return t;
		}
		
		public function rollback(ht:HistoryToken):void
		{
			if (ht.commandEvent.type != EditorEvent.CUT && ht.commandEvent.type != EditorEvent.DELETE
					&& ht.commandEvent.type != EditorEvent.PASTE)
			{
				throw new Error("Unsupported undo action");
			}
//			pasteFromClipboard(ht.originalState.clipboard, ht.originalState.startPnt);
			var s:Spreadsheet = ctx.s;
			s.applyAbsoluteCopy(ht.originalState as Array);
		}

		public function execute(event:CairngormEvent):void
		{
			var e:EditorEvent = EditorEvent(event);
			if (!ctx.editor || !ctx.workbook) return;
			switch (event.type)
			{
				case EditorEvent.COPY: copy(); break;
				case EditorEvent.PASTE: paste(); break;
				case EditorEvent.DELETE: clear(); break;
				case EditorEvent.CUT: cut(); break;
				case EditorEvent.AUTOSIZE: autosize(e);break;
				case EditorEvent.INSERT_ROW: insertRow(); break;
				case EditorEvent.REMOVE_ROW: removeRow(); break;
				case EditorEvent.INSERT_COLUMN: insertColumn(); break;
				case EditorEvent.REMOVE_COLUMN: removeColumn(); break;
				case EditorEvent.CELL_PROPERTIES: cellProperties(); break;
			}
		}
		private function copy():void
		{
			var c:Clipboard = ctx.clipboard;
			var selections:Array = ctx.s.selections;
			copyToClipboard(selections,c);
		}
		private function copyToClipboard(selections:Array, c:Clipboard):void
		{
			var s:Spreadsheet = ctx.s;
			c.clearAndInit();
			var cursorRect:Rect = new Rect(s.startPnt.x, s.startPnt.y);
			cursorRect.bottomRight = s.endPnt;
			cursorRect = cursorRect.swap();			
			for each (var r:Rect in selections)
			{
				if (r.equals(cursorRect)) continue; 
				c.selections.push(r);
				c.values.push(s.getCellsInRect(r, true));
			}
			c.selections.push(cursorRect);
			c.values.push(s.getCellsInRect(cursorRect, true));
		}
		private function paste():void
		{
			var s:Spreadsheet = ctx.s;
			var p:Pnt = s.startPnt;
			var c:Clipboard = ctx.clipboard;
			pasteFromClipboard(c, p);
		}
		private function pasteFromClipboard(c:Clipboard, p:Pnt):void
		{
			var s:Spreadsheet = ctx.s;
			if (!c.selections.length) return;
			var rFirst:Rect = Rect(c.selections[0]);
			var startX:uint = rFirst.x;
			var startY:uint = rFirst.y;
			for (var i:int = 0; i < c.selections.length; i++)
			{
				var r:Rect = c.selections[i];
				r.x =p.x + (r.x  - startX);
				r.y = p.y + (r.y - startY);
				s.setCellsInRect(r, c.values[i]);
			}	
		}
		private function clear():void
		{
			var s:Spreadsheet = ctx.workbook.selectedSpreadsheet;
			var selections:Array = s.selections;
			var cursorRect:Rect = new Rect(s.startPnt.x, s.startPnt.y);
			cursorRect.bottomRight = s.endPnt;
			cursorRect = cursorRect.swap();
			for each (var r:Rect in selections)
			{
				s.clear(r);
			}
			s.clear(cursorRect);
		}
		private function cut():void
		{
			copy();
			clear();
		}
		private function autosize(event:EditorEvent):void
		{
			var vec:Pnt;
			if (event.autoSizeType == EditorEvent.AUTOSIZE_TYPE_COLUMN || 
				event.autoSizeType == EditorEvent.AUTOSIZE_TYPE_BOTH )
			{
				autoSizeVector(new Pnt(0,1), new Pnt(event.autoSizeIndex,0));
			}
			if (event.autoSizeType == EditorEvent.AUTOSIZE_TYPE_ROW ||
				event.autoSizeType == EditorEvent.AUTOSIZE_TYPE_BOTH)
			{
				autoSizeVector(new Pnt(1,0), new Pnt(0, event.autoSizeIndex));
			}	
		}
		private function autoSizeVector(vec:Pnt, start:Pnt):void
		{
			var s:Spreadsheet = ctx.workbook.selectedSpreadsheet;
			var cell:Cell;
			var maxSize:int = 0;
			var cr:CellRenderer = new CellRenderer;
			if (!ctx.table) return;
			cr.table = ctx.table;
			var p:Point = start;
			while ((p = s.findNextNotEmptyCell(vec,p)) != null)
			{
				cell = s.getCellAt(p.x, p.y);
				var size:int;
				cr.cell = cell;
				cr.updateRenderer();
				if (vec.x) size = cr.textHeight + CellRenderer.TEXT_HEIGHT_PADDING;
				if (vec.y) size = cr.textWidth + 5;
				maxSize = Math.max(maxSize, size);
			}
			if (vec.x) s.setRowHeight(start.y, maxSize);
			if (vec.y) s.setColumnWidth(start.x, maxSize);
		}
		private function insertRow():void
		{
			var start:Pnt = ctx.s.startPnt;
			ctx.s.insertRow(start.y, 1);
		}
		private function removeRow():void
		{
			ctx.s.removeRow(ctx.s.startPnt.y,1);
		}
		private function insertColumn():void
		{
			ctx.s.insertCol(ctx.s.startPnt.x, 1);
		}
		private function removeColumn():void
		{
			ctx.s.removeCol(ctx.s.startPnt.x, 1);
		}
		private function cellProperties():void
		{
			
		}
	}
}