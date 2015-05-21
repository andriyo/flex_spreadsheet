package com.adobe.cairngorm.history
{
	import mx.collections.ArrayCollection;
	
	public class HistoryModel
	{
		public static const MODEL_NAME:String = "history";
		private static var _ctx:HistoryModel;
		public function HistoryModel()
		{
			_ctx = this;
		}
		public static function get ctx():HistoryModel
		{
			return _ctx;
		}
		
		[Bindable]
		public var undoHistory:ArrayCollection = new ArrayCollection;
		
		[Bindable]
		public var redoHistory:ArrayCollection = new ArrayCollection;
	}
}