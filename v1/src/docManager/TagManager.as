package docManager
{
	import idubee.ejb.cmp.Tag;
	
	import mx.collections.ArrayCollection;
	
	public class TagManager
	{
		private static var _tm:TagManager;
		
		[Bindable]
		public var tagList:ArrayCollection;
		public function TagManager()
		{
			if (_tm)
			{
				throw new Error("use TagManager.getTagManager()")
			} 
			_tm =this;
			tagList = new ArrayCollection;
		}
		public static function getTagManager():TagManager
		{
			if (!_tm) 
			{
				new TagManager;
			}
			return _tm;
		}
		
		public function addTag(tag:Object):void
		{
			//TODO Fix this
			tagList.addItem(tag);
		}
		
		public function deleteTag(tag:Object):void
		{
			//TODO Fix this
			tagList.removeItemAt(tagList.getItemIndex(tag));
		}
		
		public function editTag(tag:Object):void
		{
			//TODO Fix this			
		}
	}
}