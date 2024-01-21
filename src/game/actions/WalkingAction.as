package game.actions
{
   import flash.display.DisplayObject;
   import game.battlefield.MapData;
   import game.characters.AnimationController;
   import game.characters.PlayerUnit;
   import game.gui.GameHUD;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.Renderable;
   import game.items.ItemManager;
   import game.items.PlayerUnitItem;
   import game.magicBox.MagicBoxTracker;
   import game.net.MyServer;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class WalkingAction extends Action
   {
       
      
      protected var mOriginCell:GridCell;
      
      protected var mTargetX:int;
      
      protected var mTargetY:int;
      
      protected var mConquering:Boolean;
      
      public function WalkingAction(param1:PlayerUnit, param2:int, param3:int, param4:String = "Walk")
      {
         super(param4);
         mActor = param1;
         this.mTargetX = param2;
         this.mTargetY = param3;
      }
      
      public function getTargetX() : int
      {
         return this.mTargetX;
      }
      
      public function getTargetY() : int
      {
         return this.mTargetY;
      }
      
      override public function update(param1:int) : void
      {
         if((mActor as IsometricCharacter).isStill())
         {
            if(!mSkipped)
            {
               this.execute();
            }
         }
         if(mSkipped)
         {
            (mActor as IsometricCharacter).skipWalkingTask(this.mOriginCell);
         }
      }
      
      override public function isOver() : Boolean
      {
         return (mActor as IsometricCharacter).isStill() || mSkipped;
      }
      
      override public function start() : void
      {
         var _loc2_:GameHUD = null;
         var _loc3_:GridCell = null;
         if(mSkipped)
         {
            return;
         }
         if(mActor == null || !mActor.isAlive())
         {
            skip();
            return;
         }
         var _loc1_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         this.mOriginCell = mActor.getCell();
         if(_loc1_.mEnergy <= 0)
         {
            _loc2_ = GameState.mInstance.mHUD;
            _loc2_.openOutOfEnergyWindow();
            skip();
         }
         else if(!_loc1_.hasEnoughMapResource(1))
         {
            _loc2_ = GameState.mInstance.mHUD;
            _loc2_.openOutOfMapResourceWindow();
            skip();
         }
         else
         {
            (mActor as IsometricCharacter).moveTo(this.mTargetX,this.mTargetY);
            mActor.playCollectionSound(mActor.mMoveSounds);
            _loc3_ = GameState.mInstance.mScene.getCellAtLocation(this.mTargetX,this.mTargetY);
            this.mConquering = _loc3_.mOwner == MapData.TILE_OWNER_ENEMY;
         }
      }
      
      protected function execute() : void
      {
         var _loc1_:GameState = null;
         var _loc2_:GamePlayerProfile = null;
         var _loc3_:PlayerUnitItem = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:DisplayObject = null;
         var _loc8_:GridCell = null;
         var _loc9_:Object = null;
         var _loc10_:* = false;
         if(!mSkipped)
         {
            mActor.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
            if(this.mConquering)
            {
               (mActor as PlayerUnit).addTextEffect(TextEffect.TYPE_GAIN,GameState.getText("FLOATING_TEXT_CONQUERING"));
            }
            else
            {
               (mActor as PlayerUnit).addTextEffect(TextEffect.TYPE_LOSS,"-1",ItemManager.getItem("Energy","Resource"));
            }
            _loc1_ = GameState.mInstance;
            _loc2_ = _loc1_.mPlayerProfile;
            _loc1_.reduceEnergy(mName,1,MagicBoxTracker.paramsObj((mActor as PlayerUnit).mItem.mType,(mActor as PlayerUnit).mItem.mId));
            _loc1_.reduceMapResource(1);
            _loc3_ = (mActor as PlayerUnit).mItem as PlayerUnitItem;
            _loc4_ = _loc3_.mMovementRewardXP;
            _loc5_ = _loc3_.mMovementRewardEnergy;
            _loc2_.increaseEnergyRewardCounter(_loc5_);
            _loc6_ = _loc2_.getBonusEnergy();
            _loc7_ = mActor.getContainer().getChildAt(0);
            _loc1_.mScene.addLootReward(ItemManager.getItem("XP","Resource"),_loc4_,_loc7_);
            _loc1_.mScene.addLootReward(ItemManager.getItem("Energy","Resource"),_loc6_,_loc7_);
            _loc8_ = mActor.getCell();
            _loc9_ = {
               "coord_x":this.mOriginCell.mPosI,
               "coord_y":this.mOriginCell.mPosJ,
               "new_coord_x":_loc8_.mPosI,
               "new_coord_y":_loc8_.mPosJ,
               "cost_energy":1,
               "reward_xp":_loc4_,
               "reward_energy":_loc5_
            };
            if(_loc1_.mMapData.mMapSetupData.Resource)
            {
               _loc9_[MyServer.MAP_RESOURCE_COST_NAMES[_loc1_.mMapData.mMapSetupData.Resource]] = 1;
            }
            _loc1_.mServer.serverCallServiceWithParameters(ServiceIDs.MOVE_UNIT,_loc9_,false);
            if(Config.DEBUG_MODE)
            {
            }
            _loc10_ = _loc8_.mOwner == MapData.TILE_OWNER_ENEMY;
            _loc1_.mScene.mFog.incrementUnitSightArea(mActor as PlayerUnit,_loc10_);
            _loc1_.mScene.mFog.decrementUnitSightArea(mActor as PlayerUnit,this.mOriginCell);
            (mActor as Renderable).mScene.characterArrivedInCell(mActor as PlayerUnit,_loc8_);
            _loc1_.playerMoveMade();
         }
      }
   }
}
