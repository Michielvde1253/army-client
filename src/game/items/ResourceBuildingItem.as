package game.items
{
   import flash.display.MovieClip;
   import game.states.GameState;
   
   public class ResourceBuildingItem extends RepairableItem
   {
       
      
      //public var mAvailableInMaps:Array;
      
      public function ResourceBuildingItem(param1:Object)
      {
         super(param1);
         mCrafting = param1.Crafting;
		 /*
		 Unused, now checked in ShopItem so that it also works for other buildings.
		  
         var _loc2_:String = String(param1.AvailableInMaps);
         if(_loc2_)
         {
            if(_loc2_.indexOf(",") >= 0)
            {
               this.mAvailableInMaps = _loc2_.split(",");
            }
            else
            {
               this.mAvailableInMaps = [_loc2_];
            }
         }
         else
         {
            this.mAvailableInMaps = null;
         }
		 */
      }
      
	  /*
	  Unused, now checked in ShopItem so that it also works for other buildings.
  
      override public function canBeBuiltOnThisMap() : Boolean
      {
         var _loc1_:String = GameState.mInstance.mCurrentMapId;
         return Boolean(this.mAvailableInMaps) && this.mAvailableInMaps.indexOf(_loc1_) >= 0;
      }
      
      override public function isUnlocked() : Boolean
      {
         return super.isUnlocked() && this.canBeBuiltOnThisMap();
      }
  
	  */
      
      override public function getIconMovieClip() : MovieClip
      {
         var _loc1_:MovieClip = super.getIconMovieClip();
         if(_loc1_)
         {
            _loc1_.gotoAndStop(_loc1_.totalFrames);
         }
         return _loc1_;
      }
      
	  /*
	  Unused, is now checked in ShopItem with the MaxAmount parameter.
	  
      override public function isAlreadyAdded() : Boolean
      {
         var _loc1_:GameState = GameState.mInstance;
         return _loc1_.mScene.buildingExists(mId);
      }
	  */
   }
}
