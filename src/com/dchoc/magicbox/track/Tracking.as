package com.dchoc.magicbox.track
{
   import com.dchoc.magicbox.util.MD5;
   import com.dchoc.magicbox.util.Pair;
   import com.dchoc.magicbox.util.ParamsHelper;
   
   public class Tracking
   {
       
      
      private var additionalParameters:Array;
      
      private var crm_key:String;
      
      private var env:String;
      
      private var p_id:int;
      
      private var p_uid:String;
      
      private var app_id:int;
      
      private var app_uid:int;
      
      private var locale:String;
      
      private var serverUrl:String;
      
      private var label:String;
      
      private var group:String;
      
      private var type:String;
      
      private var ts:String;
      
      private var sig:String;
      
      private var time:int = 0;
      
      private var sendingAttempts:int = 0;
      
      private var id:int;
      
      public function Tracking(param1:String, param2:String, param3:int, param4:int, param5:int, param6:String, param7:String, param8:String)
      {
         this.additionalParameters = new Array();
         super();
         this.crm_key = param1;
         this.env = param2;
         this.p_id = param3;
         this.app_id = param4;
         this.app_uid = param5;
         this.locale = param6;
         this.serverUrl = param8;
         this.p_uid = param7;
      }
      
      public function getSendingAttempts() : int
      {
         return this.sendingAttempts;
      }
      
      public function setId(param1:int) : void
      {
         this.id = param1;
      }
      
      public function getId() : int
      {
         return this.id;
      }
      
      public function incrementSendingAttempts() : void
      {
         ++this.sendingAttempts;
      }
      
      public function setAdditionalParams(param1:Array) : void
      {
         this.additionalParameters = param1;
      }
      
      public function getBaseUrl() : String
      {
         return this.serverUrl;
      }
      
      public function setGroup(param1:String) : void
      {
         this.group = param1;
      }
      
      public function setLabel(param1:String) : void
      {
         this.label = param1;
      }
      
      public function setType(param1:String) : void
      {
         this.type = param1;
      }
      
      public function setTime(param1:int) : void
      {
         this.time = param1;
      }
      
      public function getServerUrl(param1:String) : String
      {
         var _loc3_:Pair = null;
         var _loc2_:String = this.serverUrl + "/event/track/?app_id=" + this.app_id + "&app_uid=" + this.app_uid + "&env=" + this.env + "&p_id=" + this.p_id + "&p_uid=" + this.p_uid + "&group=" + this.group + "&type=" + this.type + "&user_action=" + this.label + "&ts=" + this.time + "&sig=" + this.sig + "&callback=reqwest_" + this.id;
         for each(_loc3_ in this.additionalParameters)
         {
            _loc2_ += "&" + _loc3_.getKey() + "=" + _loc3_.getValue();
         }
         return encodeURI(_loc2_);
      }
      
      private function generateSignature(param1:String) : void
      {
         var _loc3_:Pair = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:ParamsHelper = new ParamsHelper();
         _loc2_.addParam("app_id",this.app_id);
         _loc2_.addParam("app_uid",this.app_uid);
         _loc2_.addParam("env",this.env);
         _loc2_.addParam("p_id",this.p_id);
         _loc2_.addParam("p_uid",this.p_uid);
         _loc2_.addParam("group",this.group);
         _loc2_.addParam("type",this.type);
         _loc2_.addParam("user_action",this.label);
         _loc2_.addParam("ts",this.time);
         _loc2_.addParam("callback","reqwest_0");
         for each(_loc3_ in this.additionalParameters)
         {
            _loc2_.addParam(_loc3_.getKey(),_loc3_.getValue());
         }
         (_loc4_ = _loc2_.returnKeys()).sort(Array.CASEINSENSITIVE);
         _loc5_ = "";
         for each(_loc6_ in _loc4_)
         {
            _loc5_ += _loc2_.getValue(_loc6_);
         }
         this.sig = MD5.hash(_loc5_ + param1);
      }
   }
}
