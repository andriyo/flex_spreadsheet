package docManager
{
	
	
	public class ObjectUtils
	{
		public static function equal(obj1:Object, obj2:Object):Boolean
		{
			return obj1.id == obj2.id;
		}
		
		public static function getIndexOf(obj:Object, array:Array):int
		{
			for(var i:int = 0; i < array.length; i++)
			{
				if (array[i].id == obj.id) return i;
			}
			
			return -1;
		}
		
	}
}