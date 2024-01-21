package com.dchoc.magicbox.track
{
   import com.dchoc.magicbox.constants.ENVIRONMENTS;
   import com.dchoc.magicbox.constants.GROUP;
   import com.dchoc.magicbox.constants.PLATFORM;
   import com.dchoc.magicbox.util.AndroidMacAddressLocater;
   import com.dchoc.magicbox.util.IOSMacAddressLocater;
   import com.dchoc.magicbox.util.MD5;
   import com.dchoc.magicbox.util.MacLocator;
   
   public class MetricsService
   {
       
      
      private var sendingService:SendingService;
      
      private var p_uid:String;
      
      private var crm_key:String;
      
      private var env:String;
      
      private var p_id:int;
      
      private var app_id:int;
      
      private var locale:String;
      
      private var serverUrl:String;
      
      private var platform:String;
      
      public function MetricsService(param1:String, param2:String, param3:int, param4:int, param5:int, param6:String)
      {
         super();
         PLATFORM.isValid(param1);
         ENVIRONMENTS.isValid(param2);
         this.env = param2;
         this.platform = param1;
         this.generateServerUrl(this.env);
         this.p_id = param3;
         this.app_id = param4;
         this.locale = param6;
         this.calculatePlayerID();
         this.sendingService = new SendingService(param1,this.p_id,this.p_uid,this.serverUrl);
      }
      
      private function generateServerUrl(param1:String) : void
      {
         this.serverUrl = "https://";
         if(param1 + "" == "0")
         {
            this.serverUrl += "crm-dev.digitalchocolate.com";
         }
         else if(param1 + "" == "1")
         {
            this.serverUrl += "crm-stage.digitalchocolate.com";
         }
         else if(param1 + "" == "2")
         {
            this.serverUrl += "crm.digitalchocolate.com";
         }
      }
      
      public function retrieveUserID() : String
      {
         return this.p_uid;
      }
      
      private function calculatePlayerID() : void
      {
         var _loc1_:MacLocator = null;
         if(this.platform == PLATFORM.ANDROID)
         {
            _loc1_ = new AndroidMacAddressLocater();
         }
         else if(this.platform == PLATFORM.IPHONE)
         {
            _loc1_ = new IOSMacAddressLocater();
         }
         this.p_uid = MD5.hash(_loc1_.findMacAddress());
      }
      
      public function trackLevelEvent(param1:String, param2:String, param3:Array) : void
      {
         var _loc4_:Tracking;
         (_loc4_ = this.setUpDefaultTrackingValues()).setGroup(GROUP.LEVEL);
         _loc4_.setType(param1);
         _loc4_.setLabel(param2);
         _loc4_.setAdditionalParams(param3);
         this.sendingService.queueMessage(_loc4_);
      }
      
      public function trackEconomyEvent(param1:String, param2:String, param3:Array) : void
      {
         var _loc4_:Tracking;
         (_loc4_ = this.setUpDefaultTrackingValues()).setGroup(GROUP.ECONOMY);
         _loc4_.setType(param1);
         _loc4_.setLabel(param2);
         _loc4_.setAdditionalParams(param3);
         this.sendingService.queueMessage(_loc4_);
      }
      
      public function trackGameEvent(param1:String, param2:String, param3:Array) : void
      {
         var _loc4_:Tracking;
         (_loc4_ = this.setUpDefaultTrackingValues()).setGroup(GROUP.GAME);
         _loc4_.setType(param1);
         _loc4_.setLabel(param2);
         _loc4_.setAdditionalParams(param3);
         this.sendingService.queueMessage(_loc4_);
      }
      
      public function trackSocialEvent(param1:String, param2:String, param3:Array) : void
      {
         var _loc4_:Tracking;
         (_loc4_ = this.setUpDefaultTrackingValues()).setGroup(GROUP.SOCIAL);
         _loc4_.setType(param1);
         _loc4_.setLabel(param2);
         _loc4_.setAdditionalParams(param3);
         this.sendingService.queueMessage(_loc4_);
      }
      
      public function trackCustomEvent(param1:String, param2:String, param3:String, param4:Array) : void
      {
         var _loc5_:Tracking;
         (_loc5_ = this.setUpDefaultTrackingValues()).setGroup(param1);
         _loc5_.setType(param2);
         _loc5_.setLabel(param3);
         _loc5_.setAdditionalParams(param4);
         this.sendingService.queueMessage(_loc5_);
      }
      
      private function setUpDefaultTrackingValues() : Tracking
      {
         return new Tracking(this.crm_key,this.env,this.p_id,this.app_id,this.app_id,this.locale,this.p_uid,this.serverUrl);
      }
   }
}
