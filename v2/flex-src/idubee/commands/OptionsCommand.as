package idubee.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.display.DisplayObject;
	
	import idubee.events.OptionsEvent;
	import idubee.view.form.OptionsForm;
	
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.effects.Move;
	import mx.effects.easing.Quintic;
	import mx.events.EffectEvent;
	import mx.managers.PopUpManager;
	
	public class OptionsCommand implements ICommand
	{
		private var closeOpenEffect : Move;
		
		public function OptionsCommand()
		{
			super();
		}
		
		public function execute(event : CairngormEvent):void
		{
			switch (event.type)
			{
				case OptionsEvent.OPEN_OPTIONS : onOpenOptionsEvent(); break;
				case OptionsEvent.CLOSE_OPTIONS : onCloseOptionsEvent(event as OptionsEvent); break;
			}
		}
		
		private function onOpenOptionsEvent():void
		{
			var options : OptionsForm = new OptionsForm();
			options.x = Application.application.width/2 - options.width/2;
			options.y = -Application.application.height - options.height;
			PopUpManager.addPopUp(options, DisplayObject(Application.application), true);
			
			playEffect(options, Application.application.height/2 - options.height/2);
		}
		
		private function onCloseOptionsEvent(event : OptionsEvent):void
		{
			playEffect(event.targetForm, -Application.application.height - event.targetForm.height, onEffectEnd);
		}
		
		private function playEffect(target : IFlexDisplayObject, yTo : Number, effectEndFunction : Function = null):void
		{
			if (!closeOpenEffect)
			{
				closeOpenEffect = new Move();
			}
			
			closeOpenEffect.target = target;
			closeOpenEffect.yTo = yTo;
			closeOpenEffect.easingFunction = Quintic.easeInOut;
			closeOpenEffect.duration = 500;
			if (effectEndFunction != null)
			{
				closeOpenEffect.addEventListener(EffectEvent.EFFECT_END, effectEndFunction);
			}
			closeOpenEffect.play()
		}
		
		private function onEffectEnd(event : EffectEvent):void
		{
			closeOpenEffect.removeEventListener(EffectEvent.EFFECT_END, onEffectEnd)
			PopUpManager.removePopUp(event.effectInstance.target as IFlexDisplayObject);
		}

	}
}