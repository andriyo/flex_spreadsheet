package idubee.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.utils.getDefinitionByName;
	
	import idubee.events.IdubeeMenuEvent;

	public class MenuCommand implements ICommand
	{
		public function MenuCommand()
			{
			super();
		}

		public function execute(event:CairngormEvent):void
		{
			var e:IdubeeMenuEvent = IdubeeMenuEvent(event);
			var mi:XML = XML(e.item);
			var action:String = mi.@action;
			while (!mi.@eventClass.toString())
			{
				mi = mi.parent();		
			}
			var clazz:Class;
			if (String(mi.@eventClass).indexOf(".") == -1)
			{
				clazz = Class(getDefinitionByName("idubee.events."+mi.@eventClass));
			} 
			else
			{
				clazz = Class(getDefinitionByName(mi.@eventClass));
			}
			
			var actionEvent:CairngormEvent = CairngormEvent(new clazz(action));
			actionEvent.dispatch();
		}
		
	}
}