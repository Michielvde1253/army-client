package com.dchoc.magicbox.constants
{
   public final class ENVIRONMENTS
   {
      
      public static const DEV:String = "0";
      
      public static const STAGE:String = "1";
      
      public static const PRODUCTION:String = "2";
       
      
      public function ENVIRONMENTS()
      {
         super();
      }
      
      public static function isValid(param1:String) : void
      {
         if(param1 == DEV || param1 == STAGE || param1 == PRODUCTION)
         {
            return;
         }
         throw new Error(param1 + " is not a valid environment value: DEV == 0, STAGE == 1, PRODUCTION == 2");
      }
   }
}
