package com.dchoc.utils
{
   import flash.net.SharedObject;
   
   public class Cookie
   {
       
      
      private var mCookie:SharedObject;
      
      public function Cookie(param1:String, param2:String = null)
      {
         var name:String = param1;
         var localPath:String = param2;
         super();
         try
         {
            this.mCookie = SharedObject.getLocal(name,localPath);
         }
         catch(e:Error)
         {
            if(Config.DEBUG_MODE)
            {
            }
         }
      }
      
      public static function saveCookieVariable(param1:String, param2:String, param3:*) : void
      {
         var cookie:Cookie = null;
         var cookieName:String = param1;
         var variable:String = param2;
         var value:* = param3;
         try
         {
            cookie = new Cookie(cookieName);
            cookie.write(variable,value);
         }
         catch(e:Error)
         {
            if(Config.DEBUG_MODE)
            {
            }
         }
      }
      
      public static function readCookieVariable(param1:String, param2:String) : *
      {
         var cookie:Cookie = null;
         var cookieName:String = param1;
         var variable:String = param2;
         try
         {
            cookie = new Cookie(cookieName);
            return cookie.read(variable);
         }
         catch(e:Error)
         {
            if(Config.DEBUG_MODE)
            {
            }
            return "";
         }
      }
      
      public function get data() : Object
      {
         return this.mCookie.data;
      }
      
      public function get size() : uint
      {
         return this.mCookie.size;
      }
      
      public function read(param1:String) : *
      {
         if(this.mCookie.data[param1] != null)
         {
            return this.mCookie.data[param1];
         }
         return null;
      }
      
      public function write(param1:String, param2:*) : void
      {
         this.mCookie.data[param1] = param2;
         this.mCookie.flush();
      }
   }
}
