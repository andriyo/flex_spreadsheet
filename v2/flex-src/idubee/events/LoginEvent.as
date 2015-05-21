package idubee.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import idubee.view.form.Login;
	
	public class LoginEvent extends CairngormEvent
	{
		public static const LOGIN : String = "login";
		public static const OPEN_LOGIN : String = "open_login";
		public static const CLOSE_LOGIN : String = "close_login";
		
		public var targetForm : Login;
		
		public function LoginEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}