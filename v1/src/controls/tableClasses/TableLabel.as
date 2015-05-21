package controls.tableClasses
{
	import mx.controls.Label;
	
	
	
	public class TableLabel extends Label implements IDropInTableRenderer
	{
		public function get tableData():TableData
		{
			return null;
		}
		
		public function set tableData(value:TableData):void
		{
		}
		
	}
}