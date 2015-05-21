package controls.tableClasses
{
	public interface IMatrix
	{
		function getValueAt(columnIndex:int, rowIndex:int):Object;
		function setValueAt(columnIndex:int, rowIndex:int,  value:Object):Object;
		function get rowsCount():int;
		function get columnsCount():int;
		function clear():void;
	}
}