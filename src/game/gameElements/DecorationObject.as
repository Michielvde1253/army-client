package game.gameElements
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import game.gui.TooltipHealth;
   import game.isometric.IsometricScene;
   import game.isometric.ObjectLoader;
   import game.items.DecorationItem;
   import game.items.MapItem;
   import game.states.GameState;
   
   public class DecorationObject extends PlayerBuildingObject
   {
       
      
      public function DecorationObject(param1:int, param2:IsometricScene, param3:MapItem, param4:Point, param5:DisplayObject = null, param6:String = null)
      {
         super(param1,param2,param3,param4,param5,param6);
         mHealth = mMaxHealth;
      }
      
      override public function updateTooltip(param1:int, param2:TooltipHealth) : void
      {
         super.updateTooltip(param1,param2);
         param2.setTitleText(mItem.mName);
         param2.setHealth(mHealth,mMaxHealth);
         param2.setDetailsText(mItem.getDescription());
      }
      
      public function getHealCostSupplies() : int
      {
         return DecorationItem(mItem).mHealCostSupplies * (mMaxHealth - mHealth) / mMaxHealth;
      }
      
      override public function setHealth(param1:int) : void
      {
         var _loc2_:int = mHealth;
         super.setHealth(param1);
         if(DecorationItem(mItem).mLeaveRuins)
         {
            this.updateGraphics();
         }
         else if(mHealth <= 0)
         {
            remove();
         }
         if((mItem as DecorationItem).mSuppliesCapIncrement > 0)
         {
            if(_loc2_ > 0 && mHealth <= 0)
            {
               GameState.mInstance.mPlayerProfile.decreaseSuppliesCap(this);
            }
            else if(_loc2_ <= 0 && mHealth > 0)
            {
               GameState.mInstance.mPlayerProfile.increaseSuppliesCap(this);
            }
         }
      }
      
      override public function graphicsLoaded(param1:Sprite) : void
      {
         super.graphicsLoaded(param1);
         this.updateGraphics();
      }
      
      private function updateGraphics() : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:String = null;
         var _loc4_:DCResourceManager = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(!mGraphicsLoaded)
         {
            return;
         }
         if(!(mItem as DecorationItem).mLeaveRuins)
         {
            return;
         }
         var _loc1_:ObjectLoader = new ObjectLoader();
         if(mHealth <= 0)
         {
            _loc3_ = "swf/buildings_player";
            if((_loc4_ = DCResourceManager.getInstance()).isLoaded(_loc3_))
            {
               removeSprite();
               _loc5_ = "building_destroyed_" + getTileSize().x + "x" + getTileSize().y;
               _loc6_ = "InnerMovieClip";
               _loc2_ = _loc1_[_loc6_]("swf/buildings_player",_loc5_);
               addSprite(_loc2_);
            }
            else
            {
               _loc4_.addEventListener(_loc3_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE,this.ruinsLoadingFinished,false,0,true);
               if(!_loc4_.isAddedToLoadingList(_loc3_))
               {
                  _loc4_.load(Config.DIR_DATA + _loc3_ + ".swf",_loc3_,null,false);
               }
            }
         }
         else
         {
            _loc2_ = _loc1_[mItem.mLoader](mItem.getIconGraphicsFile(),mItem.getIconGraphics());
            removeSprite();
            addSprite(_loc2_);
         }
      }
      
      protected function ruinsLoadingFinished(param1:Event) : void
      {
         DCResourceManager.getInstance().removeEventListener(param1.type,this.ruinsLoadingFinished);
         this.updateGraphics();
      }
   }
}
