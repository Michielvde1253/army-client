package com.dchoc.magicbox.track
{
   import air.net.URLMonitor;
   import flash.events.Event;
   import flash.events.StatusEvent;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.http.HTTPService;
   
   public class SendingService
   {
      
      private static const TIME_OUT:int = 3;
       
      
      private var attempts:int = 0;
      
      private var monitor:URLMonitor;
      
      private var hasInternet:Boolean = true;
      
      private var httpService:HTTPService;
      
      private var date:Date;
      
      private var offsetTime:int;
      
      private var deviceTime:int;
      
      private var timingHTTPService:HTTPService;
      
      private var queue:Queue;
      
      private var platform:String;
      
      private var secretKey:String;
      
      private var secretKeyHTTPService:HTTPService;
      
      private var serverUrl:String;
      
      private var timeReady:Boolean = false;
      
      private var lastRequest:Tracking;
      
      private var messageCounter:int = 0;
      
      private var callbackFunction:Function;
      
      public function SendingService(param1:String, param2:int, param3:String, param4:String)
      {
         super();
         this.platform = param1;
         this.serverUrl = param4;
         this.date = new Date();
         this.addNetworkListener();
         this.queue = new Queue();
         this.timingHTTPService = new HTTPService();
         this.secretKeyHTTPService = new HTTPService();
         this.setUpHTTPSecondaryService(this.secretKeyHTTPService,TIME_OUT);
         this.setUpHTTPSecondaryService(this.timingHTTPService,TIME_OUT);
         this.getTimeOffset();
         this.getSecretAPIKey(param2,param3);
         this.httpService = new HTTPService();
         this.setUpHTTPService(this.httpService,TIME_OUT);
      }
      
      private function setUpHTTPSecondaryService(param1:HTTPService, param2:int) : void
      {
         param1.addEventListener(ResultEvent.RESULT,this.httpResultHandler);
         param1.addEventListener(FaultEvent.FAULT,this.httpFaultHandlerSecondary);
         param1.requestTimeout = param2;
         param1.contentType = "application/text";
         param1.method = URLRequestMethod.GET;
      }
      
      private function setUpHTTPService(param1:HTTPService, param2:int) : void
      {
         param1.addEventListener(FaultEvent.FAULT,this.httpFaultHandler);
         param1.addEventListener(ResultEvent.RESULT,this.httpResultHandler);
         param1.requestTimeout = param2;
         param1.contentType = "application/text";
         param1.method = URLRequestMethod.GET;
      }
      
      private function addNetworkListener() : void
      {
      }
      
      public function queueMessage(param1:Tracking) : void
      {
         this.queue.addMessage(param1);
         if(this.hasInternet && this.secretKey != null && this.timeReady == true)
         {
            this.sendRequest(this.queue.pop());
         }
      }
      
      private function sendRequest(param1:Tracking) : void
      {
         param1.setTime(this.getDeviceTime() + this.offsetTime);
         var _loc2_:String = param1.getServerUrl(this.secretKey);
         this.httpService.url = _loc2_;
         trace(this.httpService.url);
         this.httpService.send();
         if(this.queue.getSize() > 0)
         {
            if(!this.queue.isEqualToOldestElement(this.lastRequest))
            {
               this.sendRequest(this.queue.pop());
            }
         }
      }
      
      private function checkSuccess(param1:Tracking) : Function
      {
         var tracking:Tracking = param1;
         return function(param1:ResultEvent):void
         {
            var _loc2_:* = undefined;
            var _loc3_:* = undefined;
            var _loc4_:* = undefined;
            if(!param1.statusCode == 200)
            {
               queue.addMessage(tracking);
            }
            else if(param1.statusCode == 200)
            {
               trace("Tracking object here is " + tracking.getId());
               trace("HTTP Service has listener " + httpService.hasEventListener(ResultEvent.RESULT));
               httpService.removeEventListener(ResultEvent.RESULT,callbackFunction);
               trace("Removed event listener is " + httpService.hasEventListener(ResultEvent.RESULT));
               trace(param1.result.toString());
               _loc2_ = param1.result.toString();
               _loc3_ = _loc2_.slice(10,_loc2_.length - 1);
               if((_loc4_ = JSON.parse(_loc3_)).status != 200)
               {
                  trace("Message failed due with an error of " + _loc4_);
               }
            }
         };
      }
      
      private function getSecretAPIKey(param1:int, param2:String) : void
      {
         var _loc3_:String = this.serverUrl + "/user/renew?" + "p_id=" + param1 + "&p_uid=" + param2;
         trace(_loc3_);
         this.secretKeyHTTPService.addEventListener(ResultEvent.RESULT,this.getSecretKey);
         this.secretKeyHTTPService.url = _loc3_;
         this.secretKeyHTTPService.send();
      }
      
      protected function getSecretKey(param1:ResultEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         if(param1.statusCode == 200)
         {
            _loc2_ = String(param1.result.toString());
            _loc3_ = JSON.parse(_loc2_);
            this.secretKey = _loc3_.key;
            this.secretKeyHTTPService = null;
         }
      }
      
      private function getDeviceTime() : int
      {
         return this.date.time / 1000;
      }
      
      public function getTimeOffset() : void
      {
         this.timingHTTPService.url = "http://federal.digitalchocolate.com/time/current";
         this.timingHTTPService.addEventListener(ResultEvent.RESULT,this.calculateDeviceOffsetTime);
         trace(this.timingHTTPService.url);
         this.timingHTTPService.send();
      }
      
      protected function calculateDeviceOffsetTime(param1:ResultEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1.statusCode == 200)
         {
            _loc2_ = this.getDeviceTime();
            _loc3_ = int(param1.result.toString());
            this.offsetTime = _loc2_ - _loc3_;
            trace("Offset is: " + this.offsetTime);
            this.timeReady = true;
            this.timingHTTPService = null;
         }
      }
      
      protected function onNetworkChange(param1:Event) : void
      {
         this.monitor = new URLMonitor(new URLRequest("http://crm.digitalchocolate.com"));
         this.monitor.addEventListener(StatusEvent.STATUS,this.netConnectivity);
         this.monitor.start();
      }
      
      protected function netConnectivity(param1:StatusEvent) : void
      {
         if(this.monitor.available)
         {
            trace("Status change. You are connected to the internet","INFO");
         }
         else
         {
            this.hasInternet = false;
            trace("Status change. You are not connected to the internet","INFO");
         }
         this.monitor.stop();
      }
      
      protected function httpFaultHandlerSecondary(param1:FaultEvent) : void
      {
         trace("Http Request had an error: " + param1.message);
      }
      
      protected function httpResultHandler(param1:ResultEvent) : void
      {
         trace(param1.result.toString());
      }
      
      protected function httpFaultHandler(param1:FaultEvent) : void
      {
         trace("Http Request had an error: " + param1.message);
      }
   }
}
