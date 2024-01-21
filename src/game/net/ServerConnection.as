package game.net
{
   import com.adobe.crypto.MD5;
   import com.dchoc.charlie.ServerDataListener;
   import game.magicBox.MagicBoxTracker;
   import game.states.GameState;
   import mx.rpc.events.*;
   
   public class ServerConnection
   {
      
      public static const RESPONSE_CODE_OK:int = 0;
       
      
      
      private var observers:Object;
      
      private var counter:int;
      
      private var responseCount:int;
      
      private var tokenName:String;
      
      private var uId:String;
      
      private var platformId:String;
      
      private var mDate:Date;
      
      private var mErrorObject:ErrorObject;
      
      private var session_id:String;
      
      public function ServerConnection(param1:String)
      {
         super();
         this.observers = new Object();
         this.uId = param1;
         if(Config.DEBUG_SERVER_DATA)
         {
            this.platformId = "4";
         }
         if(Config.CREATE_NEW_SESSION_IN_CLIENT)
         {
            this.platformId = "4";
         }
         this.mDate = new Date();
         this.mErrorObject = new ErrorObject();
      }
      
      public function resetErrorObject() : void
      {
         this.mErrorObject = new ErrorObject();
      }
      
      public function callService(param1:ServerCall) : void
      {

      }
      
      public function resultHandler(param1:ResultEvent) : void
      {
         var result:Object = null;
         var service:String = null;
         var message:String = null;
         var state:GameState = null;
         var event:ResultEvent = param1;
         if(this.isConnectionError())
         {
            this.resetErrorObject();
         }
         try
         {
            result = JSONWrapper.decode(event.result as String);
         }
         catch(e:Error)
         {
            if(event.result)
            {
               service = parseServiceNameFromResult(event.result as String);
            }
            message = null;
            state = GameState.mInstance;
            if(Boolean(state) && Boolean(state.getHud()))
            {
               if(FeatureTuner.USE_LIVE_BUILD_PRODUCTION)
               {
                  state.getHud().openErrorMessage(GameState.getText("MENU_HEADER_SERVER_ERROR"),GameState.getText("MENU_DESC_SERVER_ERROR"),mErrorObject);
               }
               else
               {
                  state.getHud().openErrorMessage(GameState.getText("MENU_HEADER_SERVER_ERROR"),mErrorObject.getMessage(),mErrorObject);
               }
            }
         }
         if(result)
         {
            this.notifyObserver(result.response_service,result.call_id,result.response_code,result.data,result.error_msg,null);
            ++this.responseCount;
            if(Config.CREATE_NEW_SESSION_IN_CLIENT && result.response_service == ServiceIDs.CREATE_NEW_SESSION)
            {
               this.session_id = result.data.sessionId;
            }
            if(result.error_msg)
            {
               if(FeatureTuner.USE_LIVE_BUILD_PRODUCTION)
               {
                  GameState.mInstance.mHUD.openErrorMessage(GameState.getText("MENU_HEADER_SERVER_ERROR"),GameState.getText("MENU_DESC_SERVER_ERROR"),this.mErrorObject);
               }
               else
               {
                  GameState.mInstance.mHUD.openErrorMessage(GameState.getText("MENU_HEADER_SERVER_ERROR"),result.error_msg,this.mErrorObject);
               }
            }
         }
      }
      
      private function parseServiceNameFromResult(param1:String) : String
      {
         var _loc3_:int = 0;
         var _loc2_:int = param1.indexOf("response_service");
         if(_loc2_ < 0)
         {
            param1 = null;
         }
         else
         {
            _loc2_ = param1.indexOf(":",_loc2_) + 2;
            if(_loc2_ < 0)
            {
               param1 = null;
            }
            else
            {
               _loc3_ = param1.indexOf(",",_loc2_) - 1;
               if(_loc3_ > 0 && _loc3_ > _loc2_)
               {
                  param1 = param1.substring(_loc2_,_loc3_);
               }
               else
               {
                  param1 = null;
               }
            }
         }
         return param1;
      }
      
      private function addObserver(param1:String, param2:ServerDataListener) : void
      {
         this.observers[param1] = param2;
         ++this.responseCount;
      }
      
      private function notifyObserver(param1:String, param2:String, param3:int, param4:Object, param5:Object, param6:Object = null) : void
      {
         var _loc7_:String = param1 + ":" + param2;
         var _loc8_:ServerDataListener = this.observers[_loc7_];
         this.observers[_loc7_] = null;
         if(_loc8_ != null)
         {
            _loc8_.dataReceived(param3,param1,param4,param5,param6);
         }
      }
      
      private function createSignature(param1:Object, param2:Boolean) : String
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc3_:* = "";
         var _loc4_:Array = new Array();
         for(_loc5_ in param1)
         {
            _loc4_.push({
               "key":_loc5_,
               "value":param1[_loc5_]
            });
         }
         _loc4_.sortOn("key",Array.CASEINSENSITIVE);
         _loc6_ = 0;
         _loc8_ = int(_loc4_.length);
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc7_ = _loc4_[_loc9_] as Object;
            _loc3_ = _loc3_ + _loc7_.key + "=" + _loc7_.value;
            if(_loc6_ < _loc4_.length - 1)
            {
               _loc3_ += "&";
            }
            _loc6_++;
            _loc9_++;
         }
         if(param2)
         {
            _loc3_ += this.session_id;
         }
         _loc3_ += Config.APP_SECRET_KEY;
         return MD5.hash(_loc3_);
      }
      
      public function faultHandler(param1:FaultEvent) : void
      {
         var _loc2_:int = param1.fault.faultDetail.indexOf("text=\"");
         var _loc3_:int = param1.fault.faultDetail.indexOf("URL:",_loc2_);
         var _loc4_:String = "HTTP";
         if(_loc2_ >= 0 && _loc3_ >= 0)
         {
            _loc4_ = param1.fault.faultDetail.substring(_loc2_ + 6,_loc3_);
         }
         this.mErrorObject.setError("",MagicBoxTracker.TYPE_ERR_GAME_CLIENT,_loc4_,"");
      }
      
      public function getCallCount() : int
      {
         return this.counter;
      }
      
      public function getResponseCount() : int
      {
         return this.responseCount;
      }
      
      public function isConnectionError() : Boolean
      {
         return this.mErrorObject.isConnectionError();
      }
      
      public function getErrorObject() : ErrorObject
      {
         return this.mErrorObject;
      }
   }
}
