package air.net
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.StatusEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public dynamic class ServiceMonitor extends EventDispatcher
   {
      
      private static const kDelayRangeError:uint = 2066;
      
      private static const kInvalidParamError:uint = 2004;
       
      
      private var _running:Boolean = false;
      
      private var _delay:Number = 0;
      
      private var _timer:Timer;
      
      private var _available:Boolean = false;
      
      private var _specializer:Object = null;
      
      private var _notifyRegardless:Boolean = false;
      
      private var _statusTime:Date;
      
      public function ServiceMonitor()
      {
         this._timer = new Timer(this._delay);
         this._statusTime = new Date();
         super();
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private static function makeForwarder(param1:String) : Function
      {
         var name:String = param1;
         return function forwarder(... rest):*
         {
            return this.__monitor__[name].apply(this.__monitor__,rest);
         };
      }
      
      public static function makeJavascriptSubclass(param1:Object) : void
      {
         var name:String = null;
         var constructorFunction:Object = param1;
         var proto:Object = constructorFunction.prototype;
         var names:Array = ["start","stop","willTrigger","removeEventListener","addEventListener","dispatchEvent","hasEventListener"];
         for each(name in names)
         {
            proto[name] = makeForwarder(name);
         }
         proto.setAvailable = function(param1:Boolean):void
         {
            this.__monitor__.available = param1;
         };
         proto.getAvailable = function():Boolean
         {
            return this.__monitor__.available;
         };
         proto.toString = makeForwarder("_toString");
         proto.initServiceMonitor = function():*
         {
            return _initServiceMonitor(this);
         };
      }
      
      private static function _initServiceMonitor(param1:Object) : ServiceMonitor
      {
         var _loc2_:ServiceMonitor = new ServiceMonitor();
         param1.__monitor__ = _loc2_;
         _loc2_._specializer = param1;
         return _loc2_;
      }
      
      public function stop() : void
      {
         if(!this._running)
         {
            return;
         }
         this._running = false;
         this._timer.stop();
      }
      
      public function set pollInterval(param1:Number) : void
      {
         if(param1 < 0 || !isFinite(param1))
         {
            Error.throwError(RangeError,kDelayRangeError);
         }
         this._delay = param1;
         this._timer.stop();
         if(this._delay > 0)
         {
            this._timer.delay = this._delay;
            if(this._running)
            {
               this._timer.start();
            }
         }
      }
      
      public function get available() : Boolean
      {
         return this._available;
      }
      
      private function _toString() : String
      {
         return "[ServiceMonitor available=\"" + this.available + "\"]";
      }
      
      public function get lastStatusUpdate() : Date
      {
         return new Date(this._statusTime.time);
      }
      
      public function set available(param1:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:Boolean = this._available;
         this._available = param1;
         this._statusTime = new Date();
         if(_loc2_ != this._available || this._notifyRegardless)
         {
            _loc3_ = this._available ? "Service.available" : "Service.unavailable";
            _loc4_ = "status";
            dispatchEvent(new StatusEvent(StatusEvent.STATUS,false,false,_loc3_,_loc4_));
         }
         this._notifyRegardless = false;
      }
      
      protected function checkStatus() : void
      {
         if(Boolean(this._specializer) && Boolean(this._specializer.checkStatus))
         {
            this._specializer.checkStatus();
         }
      }
      
      private function onNetworkChange(param1:Event) : void
      {
         if(!this._running)
         {
            return;
         }
         if(this._delay > 0)
         {
            this._timer.stop();
            this._timer.start();
         }
         this.checkStatus();
      }
      
      public function start() : void
      {
         if(this._running)
         {
            return;
         }
         this._running = true;
         this._notifyRegardless = true;
         if(this._delay > 0)
         {
            this._timer.start();
         }
         this.checkStatus();
      }
      
      public function get pollInterval() : Number
      {
         return this._delay;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this.checkStatus();
      }
      
      override public function toString() : String
      {
         if(Boolean(this._specializer) && Boolean(this._specializer.toString))
         {
            return this._specializer.toString();
         }
         return this._toString();
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
   }
}
