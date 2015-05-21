package idubee.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.display.DisplayObject;
	
	import idubee.events.LoginEvent;
	import idubee.view.form.Login;
	
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.effects.Move;
	import mx.effects.easing.Quintic;
	import mx.events.EffectEvent;
	import mx.managers.PopUpManager;
	
	public class LoginCommand implements ICommand
	{
		private var login : Login;
		private var closeOpenEffect : Move;
		
		public function LoginCommand():void
		{
			super();
		}
		
		public function execute(event:CairngormEvent):void
		{
			switch (event.type)
			{
				case LoginEvent.OPEN_LOGIN: onOpenLoginEvent(); break;
				case LoginEvent.CLOSE_LOGIN: onCloseLoginEvent(event as LoginEvent); break; 
			}
		}
		
		private function onOpenLoginEvent():void
		{
			if (!login)
			{
				login = new Login();
			}
			
			login.x = Application.application.width/2 - login.width/2;
			login.y = -Application.application.height - login.height;
			PopUpManager.addPopUp(login, DisplayObject(Application.application), true);
			
			playEffect(login, Application.application.height/2 - login.height/2)
		}
		
		private function onCloseLoginEvent(event : LoginEvent):void
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