package controls
{
    import flash.display.Loader;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    
    import mx.controls.Button;
    
    public class SplashScreen extends Loader
    {
        [ Embed(source="../assets/logo/idubee_logo_max.gif", mimeType="application/octet-stream") ]
        public var IdubeeLogo:Class;
        public var timer:Timer;
        private var fadeInRate:Number  = .01;
        private var fadeOutRate:Number = .02;
        private var timeAutoClose:int = 500;
        public var ready:Boolean = false; 
        
        public function SplashScreen()
        {
            this.visible = false;
            this.alpha = 0;
            timer = new Timer( 1 );
            timer.addEventListener( TimerEvent.TIMER, updateView );
            timer.start();

            this.loadBytes( new IdubeeLogo() as ByteArray );
            //this.addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );             
        }
        
        public function updateView( event:TimerEvent ):void
        {
            if( this.alpha < 1)    this.alpha = this.alpha + this.fadeInRate;
            this.stage.addChild(this);
            this.x = this.stage.stageWidth/2 - this.width/2
            this.y = this.stage.stageHeight/2 - this.height/2
            this.visible=true;
            //if( this.ready && timer.currentCount > this.timeAutoClose ) closeScreen()
            if( this.ready ) closeScreen()    
        }
        
        public function closeScreen():void
        {
            timer.removeEventListener( TimerEvent.TIMER, updateView );
            timer.removeEventListener( MouseEvent.MOUSE_DOWN, mouseDown);
            timer.addEventListener( TimerEvent.TIMER, closeScreenFade );                    
        }
        
        public function closeScreenFade( event:TimerEvent ):void
        {
            if( this.alpha > 0){
                this.alpha = this.alpha - fadeOutRate;
            } else {
                timer.stop()
                this.parent.removeChild(this);
            }        
        }        
        
        public function mouseDown( event:MouseEvent ):void
        {
            closeScreen();        
        }
                
    }
}