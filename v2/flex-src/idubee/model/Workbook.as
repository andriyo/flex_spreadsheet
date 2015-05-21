package idubee.model
{
	import flash.events.EventDispatcher;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import idubee.view.cell.CellRenderer;
	
	import mx.collections.ArrayCollection;

	[Event(name="added", type="idubee.model.WorkbookEvent")]
	[Event(name="removed", type="idubee.model.WorkbookEvent")]
	[RemoteClass(alias="com.idubee.model.Workbook")]
	public class Workbook extends EventDispatcher implements IExternalizable
	{
		public static const MAJOR_VERSION:uint = 1;
		public static const MINOR_VERSION:uint = 0;
		[Bindable]
		public var spreadsheets:ArrayCollection;
		private var _defaultTextStyle:ExtTextFormat;
		private var _defaultCellRenderer:CellRenderer;
		[Bindable]
		public var currentSpreadsheet:uint;
		public var baseColor:int = 0xFFFFFF;
		public var work1Color:int = 0x5C832F;
		public var work2Color:int = 0x284907;
		public var mainColor:int = 0x382513;
		public var neutralColor:int = 0x9BA3BD;
		[Bindable]
		public var name:String;
		private static var nameCounter:int;
		public var modified:Boolean;
		private var sheetNameCounter:int = 1;
		[Bindable] public var searchResults : ArrayCollection;
		[Bindable] public var replaceResults : ArrayCollection;
		public var currentSearchPosition : int = 0;
		public var currentReplacePosition : int = 0;
		[Bindable] public var currentAddress:String;
		public function get defaultTextStyle():ExtTextFormat
		{
			return _defaultTextStyle;
		}
		public function set defaultTextStyle(value:ExtTextFormat):void
		{
			_defaultTextStyle = value;
			_defaultCellRenderer = new CellRenderer;
			_defaultCellRenderer.htmlText = "";
			_defaultCellRenderer.defaultTextFormat = _defaultTextStyle;			
		}
		public function get defaultCellRenderer():CellRenderer
		{
			return _defaultCellRenderer;
		}
		public function Workbook()
		{
			name = "Workbook " + (++nameCounter);
			spreadsheets = new ArrayCollection;
			spreadsheets.addItem(new Spreadsheet("Sheet 1"));
			currentSpreadsheet = 0;
			defaultTextStyle = createDefaultTextFormat();
			currentAddress = Pnt.num2abc(selectedSpreadsheet.startPnt.x) + ":" + selectedSpreadsheet.startPnt.y + 1;
		}
		public function addSheet():void
		{
			var s:Spreadsheet = new Spreadsheet("Sheet "+(++sheetNameCounter));
			spreadsheets.addItem(s);
			currentSpreadsheet = spreadsheets.getItemIndex(s);
		}
		private function createDefaultTextFormat():ExtTextFormat
		{
			var etf:ExtTextFormat = new ExtTextFormat;
			etf.align = "left"; 
			etf.blockIndent = 0; 
			etf.bold = false; 
			etf.bullet = false; 
			etf.color = 0x000000;
			etf.font = "Verdana"; 
			etf.indent = 0; 
			etf.italic = false; 
			etf.kerning = false; 
			etf.leading = 0;
			etf.leftMargin = 0; 
			etf.letterSpacing = 0;
			etf.rightMargin = 0;
			etf.size = 12;
			etf.tabStops = []; 
			etf.target = ""; 
			etf.underline = false; 
			etf.url = ""; 
			return etf;
		}
		public function get selectedSpreadsheet():Spreadsheet
		{
			return Spreadsheet(spreadsheets[currentSpreadsheet]);
		}
		public function readExternal(input:IDataInput):void
		{
			var major:int = input.readByte();
			var minor:int = input.readByte();
			if (major != MAJOR_VERSION)
			{
				throw new Error("Invalid major version: "+major+", "+MAJOR_VERSION+" needed");
			}
			if (minor > MINOR_VERSION)
			{
				throw new Error("Invalid minor version: "+minor+", "+minor+" or lower needed");
			}
			name = input.readObject() as String;
			currentSpreadsheet = input.readUnsignedInt();
			baseColor = input.readInt();
			work1Color = input.readInt();
			work2Color = input.readInt();
			mainColor = input.readInt();
			neutralColor = input.readInt();
			spreadsheets = ArrayCollection(input.readObject());
			//TODO implement reading default style
		}
		public function writeExternal(output:IDataOutput):void
		{
			output.writeByte(MAJOR_VERSION);
			output.writeByte(MINOR_VERSION);
			output.writeObject(name);
			output.writeUnsignedInt(currentSpreadsheet);
			output.writeInt(baseColor);
			output.writeInt(work1Color);
			output.writeInt(work2Color);
			output.writeInt(mainColor);
			output.writeInt(neutralColor);
			output.writeObject(spreadsheets);
		}
	}
}