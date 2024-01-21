package game.utils
{
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import flash.external.ExternalInterface;
   import game.states.GameState;
   
   public class WebUtils
   {
       
      
      public function WebUtils()
      {
         super();
      }
      
      public static function getExternalInterfaceAvailable() : Boolean
      {
         return ExternalInterface.available;
      }
      
      public static function externalInterfaceAddCallback(param1:String, param2:Function) : void
      {
         ExternalInterface.addCallback(param1,param2);
      }
      
      public static function externalInterfaceCallWrapper(param1:String, ... rest) : void
      {
         var _loc3_:Stage = GameState.mInstance.getMainClip().stage;
         if(_loc3_.displayState == StageDisplayState.FULL_SCREEN)
         {
            GameState.mInstance.toggleFullScreen();
         }
         if(Config.DEBUG_MODE)
         {
         }
         if(ExternalInterface.available)
         {
            if(!rest || rest.length == 0)
            {
               ExternalInterface.call(param1);
            }
            else if(rest.length == 1)
            {
               ExternalInterface.call(param1,rest[0]);
            }
            else if(rest.length == 2)
            {
               ExternalInterface.call(param1,rest[0],rest[1]);
            }
            else if(rest.length == 3)
            {
               ExternalInterface.call(param1,rest[0],rest[1],rest[2]);
            }
            else if(rest.length == 4)
            {
               ExternalInterface.call(param1,rest[0],rest[1],rest[2],rest[3]);
            }
            else if(rest.length == 5)
            {
               ExternalInterface.call(param1,rest[0],rest[1],rest[2],rest[3],rest[4]);
            }
            else if(rest.length == 6)
            {
               ExternalInterface.call(param1,rest[0],rest[1],rest[2],rest[3],rest[4],rest[5]);
            }
            else
            {
               if(rest.length != 7)
               {
                  throw new Error("WebUtils::ExternalInterFaceCallWrapper() only supports up to 7 optional parameters, received " + rest.length + " instead");
               }
               ExternalInterface.call(param1,rest[0],rest[1],rest[2],rest[3],rest[4],rest[5],rest[6]);
            }
         }
      }
   }
}
