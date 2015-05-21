package controls.tableClasses
{
	import controls.Table;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import mx.core.IDataRenderer;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.core.UIComponentGlobals;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.managers.ILayoutManagerClient;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleClient;
	import mx.styles.StyleManager;
	import mx.styles.StyleProtoChain;
	
	use namespace mx_internal;
	public class TableDataRenderer extends UITextField implements IDataRenderer, IDropInTableRenderer
	
	{
		public function TableDataRenderer()
		{
			super();
	
			tabEnabled = false;
			mouseWheelEnabled = false;
			background = true;
			ignorePadding = false;
		}
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
	
	    /**
	     *  @private
	     */
		private var invalidatePropertiesFlag:Boolean = false;
		
	    /**
	     *  @private
	     */
		private var invalidateSizeFlag:Boolean = false;
	

	
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
	
	    //----------------------------------
	    //  data
	    //----------------------------------
	
	    /**
	     *  @private
	     */
	    private var _data:Object;
	
//		[Bindable("dataChange")]
	
	    /**
		 *  The implementation of the <code>data</code> property as 
		 *  defined by the IDataRenderer interface.
		 *
		 *  The value is ignored.  Only the listData property is used.
		 *  @see mx.core.IDataRenderer
	     */
	    public function get data():Object
	    {
	        return text;
	    }
	    
		/**
		 *  @private
		 */
		public function set data(value:Object):void
		{
			text = String(value);
//			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
	
	    //----------------------------------
	    //  tableData
	    //----------------------------------
	
		/**
		 *  @private
		 */
		private var _tableData:TableData;
	
//		[Bindable("dataChange")]
		
		public function get tableData():TableData
		{
			return _tableData;
		}
	
		/**
		 *  @private
		 */
		public function set tableData(value:TableData):void
		{
			_tableData = value;
			invalidatePropertiesFlag = true;
			invalidateSizeFlag = true;
		}

	
	}
}