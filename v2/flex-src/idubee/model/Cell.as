package idubee.model
{
	
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import idubee.util.IOUtils;
	import idubee.view.cell.CellRenderer;
	[RemoteClass(alias="com.idubee.model.Cell")]
	public class Cell implements IExternalizable
	{
		private var _v:Object;
		private static var _cachedTextValues:Dictionary = new Dictionary(true);
		private static var _currentCellRenderers:Dictionary = new Dictionary(true);
		private static var _colSpanCache:Dictionary = new Dictionary(true);
		private static var _rowSpanCache:Dictionary = new Dictionary(true);
		
		public function readExternal(input:IDataInput):void
		{
			_v = input.readObject();
		}
		
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(_v);
		}
		public function Cell(value:Object = null)
		{
			_v = value;
			if (!_v) _v = "";
		}
		
		public function set v(value:Object):void
		{
			_v = value;
			delete _cachedTextValues[this];
			if (currentCellRenderer)
			{
				currentCellRenderer.updateRenderer();
			}
		}
		public function get v():Object
		{
			return _v;
		}
		public function get colSpan():int
		{
			if (_colSpanCache[this])
			{
				return int(_colSpanCache[this]);
			}
			return 1;
		}
		public function get rowSpan():int
		{
			if (_rowSpanCache[this])
			{
				return int(_rowSpanCache[this]);
			}
			return 1;
		}
		public  function set colSpan(value:int):void
		{
			if (value == 1) return;
			_colSpanCache[this] = value;
			if (currentCellRenderer)
			{
				currentCellRenderer.updateRenderer();
			}
		}
		public  function set rowSpan(value:int):void
		{
			if (value == 1) return;
			_rowSpanCache[this] = value;
			if (currentCellRenderer)
			{
				currentCellRenderer.updateRenderer();
			}
		}
		public function clone():Cell
		{
			var r:Cell = new Cell(_v);
			r.colSpan = colSpan;
			r.rowSpan = rowSpan;
			return r;
		}
		public function get t():String
		{
			if (_cachedTextValues[this])
			{
				return String(_cachedTextValues[this]); 
			}
			var clean:RegExp = new RegExp("<[^>]*>", "gi");
			var t:String = v.toString().replace(clean, "");
			_cachedTextValues[this] = t;
			return t;
		}
		public function set currentCellRenderer(value:CellRenderer):void
		{
			if (value)
			{
				_currentCellRenderers[this] = value;
			}
			else
			{
				delete _currentCellRenderers[this];
			}
			
		}
		public function get currentCellRenderer():CellRenderer
		{
			return _currentCellRenderers[this] as CellRenderer;
		}
		public function currentAddress():Pnt
		{
			return EditorCtx.ctx.s.findAddress(this);
		}
		public static function writeDictionaries(output:IDataOutput, s:Spreadsheet):void
		{
			writeDictionary(_colSpanCache,s,output);
			writeDictionary(_rowSpanCache,s,output);
		}
		private static function writeDictionary(dic:Dictionary, s:Spreadsheet, output:IDataOutput):void
		{
			IOUtils.writeMap(output, dic, s.findAddress);
		}
		public static function readDictionaries(input:IDataInput, s:Spreadsheet):void
		{
			readDictionary(_colSpanCache, input, s);
			readDictionary(_rowSpanCache, input, s);
		}
		public static function readDictionary(dic:Dictionary, input:IDataInput, s:Spreadsheet):void
		{
			IOUtils.readMap(input, dic, s.findCellByAddress);
		}
	}
}