package com.dchoc.graphics
{
   import flash.display.LoaderInfo;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.Timer;
   
   internal class ResourceLoaderObject
   {
      
      private static const POLLING_TIMEOUT:int = 15;
       
      
      internal var mResourceName:String;
      
      internal var mURL:URLRequest;
      
      internal var mRetryCount:int;
      
      internal var mLoaderContext:LoaderContext;
      
      internal var mLoaderInfo:LoaderInfo;
      
      private var mPollingCounter:int;
      
      private var mCallbackWhenPolicyLoaded:Function;
      
      private var mPollingTimer:Timer;
      
      public function ResourceLoaderObject(param1:String, param2:URLRequest, param3:LoaderContext)
      {
         super();
         this.mResourceName = param1;
         this.mURL = param2;
         this.mRetryCount = 0;
         this.mLoaderContext = param3;
      }
      
      internal function startPolling(param1:Function) : void
      {
         this.mCallbackWhenPolicyLoaded = param1;
         param1 = null;
         this.mPollingCounter = 0;
         this.mPollingTimer = new Timer(1000);
         this.mPollingTimer.addEventListener(TimerEvent.TIMER,this.oneSec,false);
         this.mPollingTimer.start();
      }
      
      private function oneSec(param1:TimerEvent) : void
      {
         if(this.mLoaderInfo)
         {
            if(this.mLoaderInfo.childAllowsParent)
            {
               this.mCallbackWhenPolicyLoaded(this.mLoaderInfo);
               this.mPollingTimer.stop();
               this.mPollingTimer.removeEventListener(TimerEvent.TIMER,this.oneSec);
               this.mPollingTimer = null;
               this.mCallbackWhenPolicyLoaded = null;
               return;
            }
         }
         ++this.mPollingCounter;
         if(this.mPollingCounter > POLLING_TIMEOUT)
         {
            this.mPollingTimer.stop();
            this.mPollingTimer.removeEventListener(TimerEvent.TIMER,this.oneSec);
            this.mPollingTimer = null;
         }
      }
   }
}
