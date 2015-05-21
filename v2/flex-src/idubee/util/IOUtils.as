package idubee.util
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	import mx.collections.ArrayCollection;
	
	public class IOUtils
	{
		public function IOUtils()
		{
		}
		public static function readMap(input:IDataInput, toObj:Object, keyMapFunc:Function = null):void
		{
			var keys:ArrayCollection = ArrayCollection(input.readObject());
			var values:ArrayCollection = ArrayCollection(input.readObject());
			var key:Object;
			var value:Object;
			for (var i:int = 0; i < keys.length; i++)
			{
				key = keys.getItemAt(i);
				if (keyMapFunc != null)
				{
					key = keyMapFunc(key);
				}
				value = values.getItemAt(i);
				toObj[key] = value;
			}
		}
		public static function writeMap(output:IDataOutput, obj:Object, keyMapFunc:Function = null):void
		{
			var keys:ArrayCollection = new ArrayCollection;
			var values:ArrayCollection = new ArrayCollection;
			for (var key:Object in obj)
			{
				if (keyMapFunc != null)
				{
					key = keyMapFunc(key);
					if (!key)
					{
						continue;
					}
				}
				keys.addItem(key);
				values.addItem(obj[key]);
			}
			output.writeObject(keys);
			output.writeObject(values);
		}

	}
}