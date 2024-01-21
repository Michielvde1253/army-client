package game.net
{
   import com.dchoc.charlie.ServerDataListener;
   import flash.utils.getTimer;
   import game.states.GameState;
   
   public class MyServer implements ServerDataListener
   {
      
      private static const MAXIMUM_CONCURRENT_CALLS:int = 1;
      
      private static const TIMEOUT:int = 60000;
      
      private static const RETRY_TIMEOUT:int = 10000;
      
      public static const MAP_RESOURCE_COST_NAMES:Object = {"Water":"cost_water"};
       
      
      private var mGame:GameState;
      
      private var serverConnection:ServerConnection;
      
      private var mUserId:String;
      
      private var mToken:String;
      
      private var mUnsentCallBuffer:Vector.<ServerCall>;
      
      private var mActiveCallBuffer:Vector.<ServerCall>;
      
      private var mCompletedCallBuffer:Vector.<ServerCall>;
      
      private var mActiveCallTime:int;
      
      private var mRetryCallTime:int;
      
      private var mBlockingCallCount:int = 0;
      
      private var mErrorObject:ErrorObject;
      
      private var mRetryState:Boolean = false;
      
      private var mRetried:Boolean = false;
      
      public function MyServer(param1:GameState)
      {
         this.mUnsentCallBuffer = new Vector.<ServerCall>();
         this.mActiveCallBuffer = new Vector.<ServerCall>();
         this.mCompletedCallBuffer = new Vector.<ServerCall>();
         super();
         this.mGame = param1;
         this.mErrorObject = new ErrorObject();
         this.initServerConnection();
      }
      
      public function getUid() : String
      {
         return this.mUserId;
      }
      
      public function resetMyServerOnReload() : void
      {
         this.mUnsentCallBuffer.splice(0,this.mUnsentCallBuffer.length);
         this.mActiveCallBuffer.splice(0,this.mActiveCallBuffer.length);
         this.mCompletedCallBuffer.splice(0,this.mCompletedCallBuffer.length);
         this.serverConnection.resetErrorObject();
         this.mErrorObject = this.serverConnection.getErrorObject();
         this.mRetryState = false;
         this.mRetried = false;
         this.mBlockingCallCount = 0;
      }
      
      private function initServerConnection() : void
      {
         this.mUserId = Config.smUserId;
         this.serverConnection = new ServerConnection(this.mUserId);
      }
      
      public function serverCallService(param1:String, param2:Boolean) : void
      {
         this.serverCallServiceWithParameters(param1,{},param2);
      }
      
      public function serverCallServiceWithParameters(param1:String, param2:Object, param3:Boolean) : void
      {
         if(!param2.map_id)
         {
            param2.map_id = GameState.mInstance.mCurrentMapId;
         }
         if(!Config.OFFLINE_MODE)
         {
            if(param3)
            {
               ++this.mBlockingCallCount;
            }
            this.mUnsentCallBuffer.push(new ServerCall(param1,param2,this,param3));
         }
      }
      
      public function serverCallReportClientError(param1:ErrorObject) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Object = {
            "user_id":this.getUid(),
            "type":param1.getType(),
            "message":param1.getMessage() + " service:" + param1.getService()
         };
         var _loc3_:ServerCall = new ServerCall(ServiceIDs.REPORT_CLIENT_ERROR,_loc2_,this,false);
         if(!this.serverConnection)
         {
         }
      }
      
      public function update() : void
      {
         var _loc1_:ServerCall = null;
         if(this.isServerCommError())
         {
            return;
         }
         if(this.mRetryState && !this.mRetried && this.mActiveCallBuffer.length == 1 && RETRY_TIMEOUT > 0 && getTimer() - this.mRetryCallTime > RETRY_TIMEOUT)
         {
            this.serverConnection.callService(this.mActiveCallBuffer[0]);
            this.serverConnection.resetErrorObject();
            this.mRetried = true;
            if(Config.DEBUG_MODE)
            {
            }
         }
         if(this.mRetryState && !this.mRetried || this.isConnectionError())
         {
            return;
         }
         if(this.mUnsentCallBuffer.length > 0 && this.mActiveCallBuffer.length < MAXIMUM_CONCURRENT_CALLS)
         {
            _loc1_ = this.mUnsentCallBuffer.shift();
            this.mActiveCallBuffer.push(_loc1_);
            this.serverConnection.callService(_loc1_);
            this.mActiveCallTime = getTimer();
            if(Config.DEBUG_MODE)
            {
            }
         }
         if(TIMEOUT > 0 && this.mActiveCallBuffer.length > 0 && getTimer() - this.mActiveCallTime > TIMEOUT)
         {
            this.mRetryState = false;
            if(Config.DEBUG_MODE)
            {
            }
         }
         if(this.serverConnection.isConnectionError())
         {
            if(!this.mRetryState)
            {
               this.mRetryState = true;
               this.mRetried = false;
               this.mRetryCallTime = getTimer();
               if(Config.DEBUG_MODE)
               {
               }
            }
            else
            {
               this.mErrorObject = this.serverConnection.getErrorObject();
               if(Config.DEBUG_MODE)
               {
               }
            }
         }
      }
      
      public function dataReceived(param1:int, param2:String, param3:Object, param4:Object, param5:Object = null) : void
      {
         if(Config.DEBUG_MODE)
         {
         }
         if(param1 != ServerConnection.RESPONSE_CODE_OK)
         {
            if(param2 == ServiceIDs.GET_WCRM_DATA)
            {
               if(Config.DEBUG_MODE)
               {
               }
               param1 = ServerConnection.RESPONSE_CODE_OK;
            }
            else if(param2 == ServiceIDs.REPORT_CLIENT_ERROR)
            {
               param1 = ServerConnection.RESPONSE_CODE_OK;
            }
         }
         var _loc6_:ServerCall;
         if((_loc6_ = this.fetchCallFromBuffer(param2,this.mActiveCallBuffer)) != null)
         {
            if(_loc6_.mIsBlocking)
            {
               --this.mBlockingCallCount;
            }
            _loc6_.mData = param3;
            this.mCompletedCallBuffer.push(_loc6_);
         }
         else if(Config.DEBUG_MODE)
         {
         }
         if(param1 == ServerConnection.RESPONSE_CODE_OK)
         {
            this.mRetryState = false;
            this.mRetried = false;
         }
         else if(Config.DEBUG_MODE)
         {
         }
      }
      
      private function getAvatars(param1:Array) : void
      {
      }
      
      private function handleGetAvatarsResponse(param1:Object) : void
      {
      }
      
      private function fetchCallFromBuffer(param1:String, param2:Vector.<ServerCall>) : ServerCall
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param1 == null || (param2[_loc3_] as ServerCall).mServiceId == param1)
            {
               return param2.splice(_loc3_,1)[0];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function fetchResponseFromBuffer(param1:String = null) : ServerCall
      {
         return this.fetchCallFromBuffer(param1,this.mCompletedCallBuffer);
      }
      
      public function getNumberOfBlockingCalls() : int
      {
         return this.mBlockingCallCount;
      }
      
      public function isConnectionError() : Boolean
      {
         return this.mRetried && this.mErrorObject.isConnectionError();
      }
      
      public function isServerCommError() : Boolean
      {
         return this.mErrorObject.isServerCommError();
      }
      
      public function getErrorObject() : ErrorObject
      {
         return this.mErrorObject;
      }
   }
}
