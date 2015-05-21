package idubee.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import idubee.events.AddressBarEvent;
	import idubee.model.EditorCtx;
	
	public class AddressBarCommand implements ICommand
	{
		public var ctx:EditorCtx;
		
		public function AddressBarCommand()
			{
			super();
		}

		public function execute(event:CairngormEvent):void
		{
			switch(event.type)
			{
				case AddressBarEvent.SHOW_HIDE_BAR: showHideAddressBar();  break;
			}
		}
		
		private function showHideAddressBar():void
		{
			ctx.currentTableWindow.showAddressBar.play(null, ctx.currentTableWindow.isAddressBarShown);
		}
	}
}