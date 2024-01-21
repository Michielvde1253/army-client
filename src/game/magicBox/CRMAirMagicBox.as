package game.magicBox
{
   import com.dchoc.magicbox.constants.LABEL;
   import com.dchoc.magicbox.constants.PARAMS;
   import com.dchoc.magicbox.constants.TYPE;
   import com.dchoc.magicbox.track.MetricsService;
   import com.dchoc.magicbox.util.ParamsHelper;
   import flash.events.*;
   import flash.net.*;
   
   public class CRMAirMagicBox
   {
       
      
      private var metricsService:MetricsService;
      
      public function CRMAirMagicBox()
      {
         super();
      }
      
      public function init(param1:String, param2:int, param3:int, param4:int, param5:int, param6:String) : void
      {
         this.metricsService = new MetricsService(param1,param2.toString(),param3,param4,param5,param6);
      }
      
      public function wcrmTrackSessionStarted() : void
      {
         this.metricsService.trackLevelEvent(TYPE.SESSION_STARTED,LABEL.ONFLASH,new Array());
      }
      
      public function wcrmTrackEconomy(param1:String, param2:String, param3:String = null, param4:String = null, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0) : void
      {
         var _loc10_:ParamsHelper;
         (_loc10_ = new ParamsHelper()).addParam(PARAMS.PRODUCT,param3);
         _loc10_.addParam(PARAMS.PRODUCT_DETAIL,param4);
         _loc10_.addParam(PARAMS.GAME_CURRENCY_DELTA,param5);
         _loc10_.addParam(PARAMS.GAME_CURRENCY_BALANCE,param6);
         _loc10_.addParam(PARAMS.PAID_CURRENCY_DELTA,param7);
         _loc10_.addParam(PARAMS.PAID_CURRENCY_BALANCE,param8);
         _loc10_.addParam(PARAMS.REAL_CURRENCY_DELTA,param9);
         this.metricsService.trackEconomyEvent(param1,param2,_loc10_.build());
      }
      
      public function wcrmTrackLevelUp(param1:int) : void
      {
         var _loc2_:ParamsHelper = new ParamsHelper();
         _loc2_.addParam(PARAMS.VALUE,param1);
         this.metricsService.trackLevelEvent(TYPE.LEVEL_UP,param1.toString(),_loc2_.build());
      }
      
      public function wcrmSocialSend(param1:String, param2:String = null, param3:String = null) : void
      {
         var _loc4_:ParamsHelper;
         (_loc4_ = new ParamsHelper()).addParam(PARAMS.PRODUCT,param2);
         _loc4_.addParam(PARAMS.PRODUCT_DETAIL,param3);
         this.metricsService.trackSocialEvent(param1,LABEL.SENT,_loc4_.build());
      }
      
      public function wcrmCustomEvent(param1:String, param2:String, param3:String, param4:Object) : void
      {
         var _loc6_:String = null;
         var _loc5_:ParamsHelper = new ParamsHelper();
         for each(_loc6_ in param4)
         {
            _loc5_.addParam(_loc6_,param4[_loc6_]);
         }
         this.metricsService.trackCustomEvent(param1,param2,param3,_loc5_.build());
      }
      
      public function getCRMUserID() : String
      {
         return this.metricsService.retrieveUserID();
      }
   }
}
