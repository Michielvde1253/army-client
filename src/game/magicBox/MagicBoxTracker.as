package game.magicBox
{
   import com.adobe.crypto.MD5;
   import com.dchoc.magicbox.constants.PLATFORM;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import game.net.ErrorObject;
   import game.states.GameState;
   
   public class MagicBoxTracker
   {
      
      private static const DEBUG_TRACKER:Boolean = false;
      
      public static const GROUP_LEVEL:String = "Level";
      
      public static const GROUP_ECONOMY:String = "Economy";
      
      public static const GROUP_GAME:String = "Game";
      
      public static const TYPE_SESSION_STARTED:String = "Session started";
      
      public static const TYPE_LEVEL_REACHED:String = "Level reached";
      
      public static const TYPE_LOADING:String = "Loading";
      
      public static const TYPE_SPEND_CASH:String = "Spend Cash";
      
      public static const TYPE_SPEND_PC:String = "Spend PC";
      
      public static const TYPE_SPEND_ENERGY:String = "Spend Energy";
      
      public static const TYPE_SPEND_SUPPLY:String = "Spend Supply";
      
      public static const TYPE_GAIN_ITEM:String = "Gain Item";
      
      public static const TYPE_GAME_ACTION:String = "Game Action";
      
      public static const TYPE_TRADE_COLLECTION:String = "Trade Collection";
      
      public static const TYPE_FIRE_MISSION:String = "Fire Mission";
      
      public static const TYPE_MISSION_COMPLETED:String = "Mission Completed";
      
      public static const TYPE_MISSION_ACCEPTED:String = "Mission Accepted";
      
      public static const LABEL_LOADING_TIME:String = "LoadingTime_";
      
      public static const LOADING_GROUP_10:int = 10;
      
      public static const LOADING_GROUP_20:int = 20;
      
      public static const LOADING_GROUP_40:int = 40;
      
      public static const LOADING_GROUP_80:int = 80;
      
      public static const LOADING_GROUP_160:int = 160;
      
      public static const LOADING_GROUP_320:int = 320;
      
      public static const LABEL_ON_FLASH:String = "OnAndroid";
      
      public static const LABEL_TOOL_SELL_ITEM:String = "Tool Sell Item";
      
      public static const LABEL_TOOL_MOVE_BUILDING:String = "Tool Move Building";
      
      public static const LABEL_CONSTRUCTION_FINISHED:String = "Construction Finished";
      
      public static const LABEL_CITY_SUPPLY_CONVERSION:String = "Convert Supply To Cash";
      
      public static const LABEL_RESOURCE_PRODUCTION:String = "Set Recource Production";
      
      public static const LABEL_BUY_ITEM:String = "Buy Item";
      
      public static const LABEL_BUY_ITEM_WITH_LOCATION:String = "Buy Item With Location";
      
      public static const LABEL_BUY_EARLY_UNLOCK:String = "Buy Early Unlock";
      
      public static const LABEL_BUY_INGREDIENTS:String = "Buy Ingredients";
      
      public static const LABEL_BUY_UNLOCK_MISSION_OBJECTIVE:String = "Buy Unlock MissionObj";
      
      public static const TYPE_BUY_CASH:String = "Buy Cash";
      
      public static const TYPE_BUY_PC:String = "Buy PC";
      
      public static const LABEL_SUCCESS:String = "Success";
      
      public static const LABEL_FAIL:String = "Failure";
      
      public static const GROUP_GAME_ERROR:String = "Game Error";
      
      public static const TYPE_ERR_GAME_CLIENT:String = "Game Client";
      
      public static const TYPE_ERR_NA:String = "Err Obj NA";
      
      public static const PS_RANDOM_ITEM:String = "RI";
      
      public static const PS_ID:String = "ID";
      
      private static const PROJECT_ID:int = 130;
      
      private static const ENV_ID:int = Config.USE_LIVE_BUILD ? 2 : 1;
      
      private static const P_ID:int = 3;
      
      private static const CRM_KEY:String = "E4CB8DFE1C6E829175C2D6BF0C";
      
      private static var mCRMMetrics:CRMAirMagicBox;
      
      private static const GAME_CURRENCY:String = "GameCurrency";
      
      private static const PREMIUM_CURRENCY:String = "PaidCurrency";
      
      private static const REAL_CURRENCY:String = "RealCurrency";
      
      private static const SUPPLY_RESOURCE:String = "SupplyResource";
       
      
      public function MagicBoxTracker()
      {
         super();
      }
      
      public static function generateEvent(param1:String, param2:String, param3:String, param4:Object = null) : void
      {
         var app_uid:int = 0;
         var level:int = 0;
         var group:String = param1;
         var event:String = param2;
         var label:String = param3;
         var params:Object = param4;
         try
         {
            if(GameState.mInstance.mServer.isServerCommError() || GameState.mInstance.mServer.isConnectionError())
            {
               return;
            }
            if(!Config.USE_MAGIC_BOX_LIB)
            {
               if(params == null)
               {
                  params = paramsObj(null,null,null,null,label);
                  if(event == TYPE_SESSION_STARTED)
                  {
                     params["app_friends"] = 0;
                     params["app_neighbors"] = 0;
                     params["friends"] = 0;
                  }
               }
               else
               {
                  params["app_id"] = PROJECT_ID;
                  params["env"] = ENV_ID;
                  params["app_uid"] = MD5.hash(Config.smUserId);
                  params["p_uid"] = MD5.hash(Config.smUserId);
                  params["p_id"] = P_ID;
                  params["ts"] = Math.round(new Date().time / 1000);
                  params["sig"] = genarateSig(params);
                  if(label)
                  {
                     params["user_action"] = label;
                  }
               }
               if(DEBUG_TRACKER)
               {
                  printObject(params);
               }
               wcrmInternalTrackEvent(group,event,label,params);
            }
            else
            {
               app_uid = parseInt(Config.smUserId);
               level = GameState.mInstance.mPlayerProfile.mLevel;
               if(mCRMMetrics == null)
               {
                  mCRMMetrics = new CRMAirMagicBox();
                  mCRMMetrics.init(PLATFORM.ANDROID,ENV_ID,P_ID,PROJECT_ID,app_uid,null);
               }
               switch(group)
               {
                  case GROUP_LEVEL:
                     if(event == TYPE_SESSION_STARTED)
                     {
                        mCRMMetrics.wcrmTrackSessionStarted();
                     }
                     else if(event == TYPE_LEVEL_REACHED)
                     {
                        mCRMMetrics.wcrmTrackLevelUp(level);
                     }
                     else
                     {
                        mCRMMetrics.wcrmCustomEvent(group,event,label,params);
                     }
                     break;
                  case GROUP_ECONOMY:
                     mCRMMetrics.wcrmTrackEconomy(event,label,params.product,params.product_detail,params.game_currency_delta,params.game_currency_balance,params.paid_currency_delta,params.game_currency_balance,params.real_currency_delta);
                     break;
                  default:
                     mCRMMetrics.wcrmCustomEvent(group,event,label,params);
               }
            }
         }
         catch(err:Error)
         {
         }
      }
      
      private static function wcrmInternalTrackEvent(param1:String, param2:String, param3:String, param4:Object) : void
      {
         var loader:URLLoader = null;
         var data:String = null;
         var key:String = null;
         var request:URLRequest = null;
         var group:String = param1;
         var event:String = param2;
         var label:String = param3;
         var params:Object = param4;
         try
         {
            if(!(GameState.mInstance.mServer.isServerCommError() || GameState.mInstance.mServer.isConnectionError()) && !Config.OFFLINE_MODE)
            {
               loader = new URLLoader();
               data = "";
               if(params == null)
               {
                  return;
               }
               for(key in params)
               {
                  data += "&" + key + "=" + params[key];
               }
               if(data == "")
               {
                  return;
               }
               data = data.slice(1,data.length);
               request = new URLRequest(wcrmGetServer() + "/event/track?" + data + "&group=" + group + "&event=" + event + "&type=" + event + "&level=" + GameState.mInstance.mPlayerProfile.mLevel);
               if(DEBUG_TRACKER)
               {
               }
               try
               {
                  loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
                  loader.load(request);
               }
               catch(error:IOErrorEvent)
               {
               }
            }
         }
         catch(err:Error)
         {
         }
      }
      
      private static function onError(param1:IOErrorEvent) : void
      {
      }
      
      private static function wcrmGetServer() : String
      {
         if(FeatureTuner.USE_LIVE_BUILD_PRODUCTION)
         {
            return "http://crm.digitalchocolate.com";
         }
         return "http://crm-stage.digitalchocolate.com";
      }
      
      public static function generateErrorEvent(param1:ErrorObject) : void
      {
         var o:Object = null;
         var paramsCrm:Object = null;
         var errorObject:ErrorObject = param1;
         try
         {
            if(GameState.mInstance.mServer.isServerCommError() || GameState.mInstance.mServer.isConnectionError())
            {
               return;
            }
            if(!Config.USE_MAGIC_BOX_LIB)
            {
               if(errorObject == null)
               {
                  if(DEBUG_TRACKER)
                  {
                  }
                  errorObject = getErrorObject("",TYPE_ERR_NA);
               }
               o = paramsObj(null,errorObject.getCode(),errorObject.getMessage(),"FV:" + errorObject.getFlashVersion() + "_VMV:" + errorObject.getVMVersion());
               generateEvent(MagicBoxTracker.GROUP_GAME_ERROR,errorObject.getType(),errorObject.getService(),o);
               if(errorObject.getMessage().length > 0)
               {
                  GameState.mInstance.mServer.serverCallReportClientError(errorObject);
               }
               if(DEBUG_TRACKER)
               {
               }
            }
            else
            {
               paramsCrm = paramsObj(null,errorObject.getCode(),errorObject.getMessage(),"FV:" + errorObject.getFlashVersion() + "_VMV:" + errorObject.getVMVersion());
               if(!mCRMMetrics)
               {
                  mCRMMetrics.wcrmCustomEvent(GROUP_GAME_ERROR,errorObject.getType(),errorObject.getService(),paramsCrm);
               }
            }
         }
         catch(err:Error)
         {
         }
      }
      
      public static function getErrorObject(param1:String, param2:String, param3:String = null, param4:String = null) : ErrorObject
      {
         var _loc5_:ErrorObject;
         (_loc5_ = new ErrorObject()).setError(param1,param2,param3,param4);
         return _loc5_;
      }
      
      public static function paramsObj(param1:String = null, param2:String = null, param3:String = null, param4:String = null, param5:String = null) : Object
      {
         var product:String = param1;
         var product_detail:String = param2;
         var p1:String = param3;
         var p2:String = param4;
         var label:String = param5;
         var params:Object = new Object();
         try
         {
            if(GameState.mInstance.mServer.isServerCommError() || GameState.mInstance.mServer.isConnectionError())
            {
               return params;
            }
            if(product)
            {
               params["product"] = product;
            }
            else
            {
               params["product"] = "Default";
            }
            if(product_detail)
            {
               params["product_detail"] = product_detail;
            }
            if(p1)
            {
               params["p1"] = p1;
            }
            if(p2)
            {
               params["p2"] = p2;
            }
            params["app_id"] = PROJECT_ID;
            params["env"] = ENV_ID;
            params["app_uid"] = MD5.hash(Config.smUserId);
            params["p_uid"] = MD5.hash(Config.smUserId);
            params["p_id"] = P_ID;
            params["ts"] = Math.round(new Date().time / 1000);
            if(label)
            {
               params["user_action"] = label;
            }
            params["sig"] = genarateSig(params);
            if(GameState.mInstance)
            {
               if(GameState.mInstance.mPlayerProfile)
               {
                  if(GameState.mInstance.mPlayerProfile.mInventory)
                  {
                     if(GameState.mInstance.mPlayerProfile.mInventory.getAreas())
                     {
                        params["p3"] = "" + GameState.mInstance.mPlayerProfile.mInventory.getAreas().length / 2;
                     }
                  }
               }
            }
            return params;
         }
         catch(err:Error)
         {
         }
         return params;
      }
      
      private static function genarateSig(param1:Object) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = "";
         for(_loc3_ in param1)
         {
            _loc2_ += "" + _loc3_ + param1[_loc3_];
         }
         return MD5.hash(_loc2_ + CRM_KEY);
      }
      
      private static function printObject(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(DEBUG_TRACKER)
         {
            _loc2_ = "";
            for(_loc3_ in param1)
            {
               _loc2_ += "" + _loc3_ + ":" + param1[_loc3_] + ",";
            }
         }
      }
      
      public static function paramsAddRecipientSenderAndPicture(param1:Object, param2:String, param3:String, param4:String) : void
      {
         param1["recipient_uids"] = param2;
         param1["sender"] = param3;
         param1["picture_url"] = param4;
      }
      
      public static function paramsAddGameCurrency(param1:Object, param2:int) : void
      {
         var _loc3_:int = GameState.mInstance.mPlayerProfile.mMoney;
         paramsAdd(GAME_CURRENCY,param1,param2,_loc3_);
      }
      
      public static function paramsAddSupplyResource(param1:Object, param2:int) : void
      {
         var _loc3_:int = GameState.mInstance.mPlayerProfile.mSupplies;
         paramsAdd(SUPPLY_RESOURCE,param1,param2,_loc3_);
      }
      
      public static function paramsTrackPremiumCurrency(param1:Object, param2:int) : void
      {
         var _loc3_:int = GameState.mInstance.mPlayerProfile.mPremium;
         paramsAdd(PREMIUM_CURRENCY,param1,param2,_loc3_);
      }
      
      public static function paramsTrackRealCurrency(param1:Object, param2:int, param3:int) : void
      {
         paramsAdd(PREMIUM_CURRENCY,param1,param3,GameState.mInstance.mPlayerProfile.mPremium);
         paramsAdd(REAL_CURRENCY,param1,param2,0);
      }
      
      private static function paramsAdd(param1:String, param2:Object, param3:int, param4:int) : void
      {
         if(param2 == null)
         {
            param2 = paramsObj();
         }
         switch(param1)
         {
            case REAL_CURRENCY:
               param2["real_currency_delta"] = param3.toString();
               param2["real_currency_balance"] = param4.toString();
               break;
            case PREMIUM_CURRENCY:
               param2["paid_currency_delta"] = param3.toString();
               param2["paid_currency_balance"] = param4.toString();
               break;
            case GAME_CURRENCY:
               param2["game_currency_delta"] = param3.toString();
               param2["game_currency_balance"] = param4.toString();
               param2["premier_currency_delta"] = 0;
               break;
            case SUPPLY_RESOURCE:
               param2["resource_1_delta"] = param3.toString();
               param2["resource_1_balance"] = param4.toString();
         }
      }
   }
}
