package com.dchoc.magicbox.constants
{
   public final class PLATFORM
   {
      
      public static const IPHONE:String = "Iphone";
      
      public static const ANDROID:String = "Android";
       
      
      public function PLATFORM()
      {
         super();
      }
      
      public static function isValid(param1:String) : void
      {
         if(param1 == IPHONE || param1 == ANDROID)
         {
            return;
         }
         throw new Error(param1 + " is not a valid platform value");
      }
   }
}
