package idubee.view.table
{
	import idubee.model.Cell;
	
	public interface MarkerRenderer
	{
		public function set table(table:Table);
		public function render(cell:Cell);
	}
}