package idubee.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class AdvEventDispatcher extends EventDispatcher
	{
		public function AdvEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		private var listeners:Array = [];
    
    [Bindable("eventListenersUpdated")]
    public function get eventListeners():Array {
        return listeners;
    }
    
    override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
        var listenerDictionary:Dictionary = new Dictionary();
        var tracker:ListenerTracker = new ListenerTracker(type, listener, useCapture, priority, useWeakReference);
        
        var stackTrace:String = new Error().getStackTrace();
    
        var secondLine:String = stackTrace.split("\n")[2];
        
        var lineNumber:String = secondLine.substring(secondLine.lastIndexOf(":") + 1, secondLine.length-1);
        var classAndMethod:String = secondLine.substring(3, secondLine.indexOf("["));
        
        var classMethodSplit:Array = classAndMethod.split("/");
        
        var className:String = classMethodSplit[0];
        className = className.substr(1);
        
        var methodName:String = classMethodSplit[1];
        
        if(methodName == null) {
            methodName = "constructor";
            className = className.substr(0, className.length - 2);
        }
        else {
            methodName = methodName.substr(0, methodName.length-2);
        }
        
        tracker.callingClass = className;
        tracker.callingLineNumber = Number(lineNumber);
        tracker.callingMethod = methodName;

        
        listeners.push(tracker);
        
        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
        
        dispatchEvent(new Event("eventListenersUpdated"));
    }
    
   		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
        
        for each(var tracker:ListenerTracker in listeners) {
            if(tracker.listener == listener && tracker.type == type && tracker.useCapture == useCapture) {
                listeners.splice(listeners.indexOf(tracker), 1);
            }
        }
        
        super.removeEventListener(type, listener, useCapture);
        
        dispatchEvent(new Event("eventListenersUpdated"));
	    }
	    
	    public function getEventListeners(type:String):Array {
	        var returnArray:Array = new Array();
	        
	        for each(var tracker:ListenerTracker in listeners) {
	            if(tracker.type == type) {
	                returnArray.push(tracker);
	            }
	        }
	        
	        return returnArray;
	    }
	    
	    public function getAllEventListeners():Array {
	        return listeners;
	    }
	    
	    public function removeAllEventListeners():void {
	        for(var i:int=listeners.length-1; i>=0; i--) {
	            var tracker:ListenerTracker = listeners[i];    
	            
	            if(tracker)
	                removeEventListener(tracker.type, tracker.listener, tracker.useCapture);
	        }
	    }
	    
	    public function removeEventListeners(type:String):void {
	        for(var i:int=listeners.length-1; i>=0; i--) {
	            var tracker:ListenerTracker = listeners[i];    
	            if(tracker.type == type) {
	                removeEventListener(tracker.type, tracker.listener, tracker.useCapture);
	            }
	        }
	    }
	}
}