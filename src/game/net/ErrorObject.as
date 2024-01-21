package game.net
{
   import flash.system.Capabilities;
   import flash.system.System;
   
   public class ErrorObject
   {
      
      private static const DEBUG_ERROR_OBJECT:Boolean = Config.DEBUG_MODE;
      
      public static const ERROR_TYPE_STREAM:String = "2032";
       
      
      private var mConnectionError:Boolean = false;
      
      private var mType:String;
      
      private var mCode:String;
      
      private var mService:String;
      
      private var mMessage:String;
      
      public function ErrorObject()
      {
         super();
         this.mType = "ERROR";
         this.mCode = "ERROR";
         this.mService = "ERROR";
         this.mMessage = "ERROR";
         this.mConnectionError = false;
      }
      
      public function setError(param1:String, param2:String, param3:String = null, param4:String = null) : void
      {
         if(DEBUG_ERROR_OBJECT)
         {
            if(param1 == null || param1.length <= 0)
            {
            }
            if(param2 == null || param2.length <= 0)
            {
            }
         }
         this.mConnectionError = true;
         if(param2 != null)
         {
            if(param2.length > 0)
            {
               this.mType = param2;
            }
         }
         if(param3 != null)
         {
            if(param3.length > 0)
            {
               this.mCode = param3;
            }
         }
         if(param4 != null)
         {
            if(param4.length > 0)
            {
               this.mService = encodeURIComponent(param4);
            }
         }
         if(param1 != null)
         {
         }
      }
      
      public function getType() : String
      {
         return this.mType;
      }
      
      public function getCode() : String
      {
         return this.mCode;
      }
      
      public function getService() : String
      {
         return this.mService;
      }
      
      public function getMessage() : String
      {
         return this.mMessage;
      }
      
      public function isConnectionError() : Boolean
      {
         return this.mConnectionError && this.mCode.indexOf(ERROR_TYPE_STREAM) >= 0;
      }
      
      public function isServerCommError() : Boolean
      {
         return this.mConnectionError;
      }
      
      public function getFlashVersion() : String
      {
         return Capabilities.version;
      }
      
      public function getVMVersion() : String
      {
         return System.vmVersion;
      }
   }
}
