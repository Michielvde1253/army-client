package game.gui.popups
{
   import game.gui.DCWindow;
   import game.states.GameState;
   
   public class PopUpManager
   {
      
      private static var mPopups:Array = new Array();
      
      public static var mTotalOpenCount:int = 0;
      
      public static var mModalOpenCount:int = 0;
       
      
      public function PopUpManager()
      {
         super();
      }
      
      public static function resetAllPopup() : void
      {
         mPopups.splice(0,mPopups.length);
         mPopups = null;
         mPopups = new Array();
         mTotalOpenCount = 0;
         mModalOpenCount = 0;
      }
      
      public static function getPopUp(param1:Class, param2:Object = null) : DCWindow
      {
         var _loc4_:PopUpWindow = null;
         var _loc5_:PopUpWindow = null;
         GameState.mInstance.mScene.hideObjectTooltip();
         var _loc3_:Class = getBaseType(param1);
         if(mPopups[_loc3_] == null)
         {
            if(param2 == null)
            {
               (_loc4_ = new param1()).alignToScreen();
               _loc4_.scaleToScreen();
               mPopups[_loc3_] = _loc4_;
            }
            else
            {
               (_loc5_ = new param1(param2)).alignToScreen();
               _loc5_.scaleToScreen();
               mPopups[_loc3_] = _loc5_;
            }
         }
         return mPopups[_loc3_];
      }
      
      public static function isPopUpCreated(param1:Class) : Boolean
      {
         var _loc2_:Class = getBaseType(param1);
         return mPopups[_loc2_] != null;
      }
      
      public static function releasePopUp(param1:Class) : void
      {
         var _loc2_:Class = getBaseType(param1);
         mPopups[_loc2_] = null;
      }
      
      private static function getBaseType(param1:Class) : Class
      {
         return param1;
      }
      
      public static function getPopups() : Array
      {
         return mPopups;
      }
      
      public static function isModalPopupActive() : Boolean
      {
         return mModalOpenCount > 0;
      }
      
      public static function isAnyPopupActive() : Boolean
      {
         return mTotalOpenCount > 0;
      }
   }
}
