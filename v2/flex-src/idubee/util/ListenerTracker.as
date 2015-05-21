package idubee.util
{
	import flash.utils.Dictionary;
    import flash.utils.getTimer;
    
    public class ListenerTracker
    {
        private var listenerDictionary:Dictionary;
        
        public var timeCreated:int;
        
        public function ListenerTracker(type:String, listener:Function, useCapture:Boolean, priority:int, useWeakReference:Boolean)
        {
            listenerDictionary = new Dictionary(true);
            
            this.type = type;
            this.listener = listener;
            this.useCapture = useCapture;
            this.priority = priority;
            this.useWeakReference = useWeakReference;
            
            timeCreated = getTimer();
            
            super();
        }
        
        public var type:String;
        public var priority:int;
        public var useCapture:Boolean;
        public var useWeakReference:Boolean;
        
        public var callingClass:String;
        public var callingLineNumber:Number;
        public var callingMethod:String;

        public function set listener(value:Function):void {
            listenerDictionary["listener"] = value;
        }
        
        public function get listener():Function {
            return listenerDictionary["listener"];
        }
        
        public function toString():String {
            return "{ listener [type: " + type + ", priority: " + priority + ", useCapture: " + useCapture + ", useWeakReference: " + useWeakReference + ", timeCreated: " + timeCreated + "] }";
        }
    }
}