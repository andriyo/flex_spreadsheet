package idubee.view.table
{
	import mx.core.UIComponent;

	public class BaseLayer extends UIComponent
	{
		public var table:Table;
		public function BaseLayer(table:Table)
		{
			this.table = table;
			mouseEnabled = false;
			mouseChildren = false;
		}
		
	}
}