package game.utils
{
   import game.states.GameState;
   
   public class TimeUtils
   {
      
      private static var textDays:String = GameState.getText("TIMEFORMAT_DAYS");
      
      private static var textHours:String = GameState.getText("TIMEFORMAT_HOURS");
      
      private static var textMinutes:String = GameState.getText("TIMEFORMAT_MINUTES");
      
      private static var textSeconds:String = GameState.getText("TIMEFORMAT_SECONDS");
       
      
      public function TimeUtils()
      {
         super();
      }
      
      public static function getEnergyRechargeTimeString(param1:int) : String
      {
         var _loc5_:String = null;
         var _loc2_:int = param1 % 60;
         param1 /= 60;
         var _loc3_:int = param1;
         var _loc4_:String = _loc2_ < 10 ? "0" + _loc2_ : _loc2_.toString();
         return _loc3_.toString() + ":" + _loc4_;
      }
      
      public static function secondsToString(param1:int, param2:int = 2, param3:Boolean = false) : String
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc4_:String = "";
         _loc8_ = param1 % 60;
         param1 /= 60;
         _loc7_ = param1 % 60;
         param1 /= 60;
         _loc6_ = param1 % 24;
         param1 /= 24;
         _loc5_ = param1;
         var _loc9_:String = String(_loc5_) + textDays;
         var _loc10_:String = String(_loc6_) + textHours;
         var _loc11_:String = _loc7_ < 10 && _loc6_ > 0 ? "0" + _loc7_ + textMinutes : String(_loc7_) + textMinutes;
         var _loc12_:String = _loc8_ < 10 && _loc7_ > 0 ? "0" + _loc8_ + textSeconds : String(_loc8_) + textSeconds;
         if(_loc5_ > 0)
         {
            _loc4_ += _loc9_;
            if(param2 > 1)
            {
               if(!param3 || _loc6_ != 0)
               {
                  _loc4_ += " " + _loc10_;
                  if(param2 > 2)
                  {
                     if(!param3 || _loc7_ != 0)
                     {
                        _loc4_ += " " + _loc11_;
                     }
                  }
               }
            }
         }
         else if(_loc6_ > 0)
         {
            _loc4_ += _loc10_;
            if(param2 > 1)
            {
               if(!param3 || _loc7_ != 0)
               {
                  _loc4_ += " " + _loc11_;
                  if(param2 > 2)
                  {
                     if(!param3 || _loc8_ != 0)
                     {
                        _loc4_ += " " + _loc12_;
                     }
                  }
               }
            }
         }
         else if(_loc7_ > 0)
         {
            _loc4_ += _loc11_;
            if(param2 > 1)
            {
               if(!param3 || _loc8_ != 0)
               {
                  _loc4_ += " " + _loc12_;
               }
            }
         }
         else
         {
            _loc4_ += " " + _loc12_;
         }
         return _loc4_;
      }
      
      public static function milliSecondsToString(param1:Number, param2:int = 2) : String
      {
         param1 /= 1000;
         return secondsToString(param1,param2);
      }
      
      public static function getCountDownTime(param1:Number) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 < 0)
         {
            param1 = 0;
         }
         var _loc2_:int = param1 / 1000;
         _loc5_ = _loc2_ % 60;
         _loc2_ /= 60;
         _loc4_ = _loc2_ % 60;
         _loc2_ /= 60;
         _loc3_ = _loc2_ % 24;
         _loc2_ /= 24;
         var _loc6_:String = _loc3_ < 10 ? "0" + _loc3_ : String(_loc3_);
         var _loc7_:String = _loc4_ < 10 ? "0" + _loc4_ : String(_loc4_);
         var _loc8_:String = _loc5_ < 10 ? "0" + _loc5_ : String(_loc5_);
         return _loc6_ + ":" + _loc7_ + ":" + _loc8_;
      }
   }
}
