package controls
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import mx.controls.Button;
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;

	public class IdubeePreloader extends DownloadProgressBar
	{
		public var splash : SplashScreen;
		
		public function IdubeePreloader():void
		{
			super();
			splash = new SplashScreen();
			this.addChild(splash);
		}
		
		override public function set preloader(preloader : Sprite):void
		{
			preloader.addEventListener( ProgressEvent.PROGRESS , SWFDownloadProgress );    
            preloader.addEventListener( Event.COMPLETE , SWFDownloadComplete );
            preloader.addEventListener( FlexEvent.INIT_PROGRESS , FlexInitProgress );
            preloader.addEventListener( FlexEvent.INIT_COMPLETE , FlexInitComplete );
		} 
		
		private function SWFDownloadProgress( event:ProgressEvent ):void 
		{
			trace(event.bytesLoaded)
		}
    
        private function SWFDownloadComplete( event:Event ):void {}
    
        private function FlexInitProgress( event:Event ):void {}
    
        private function FlexInitComplete( event:Event ):void 
        {      
            splash.ready = true;      
            dispatchEvent( new Event( Event.COMPLETE ) );
        }
	}
}