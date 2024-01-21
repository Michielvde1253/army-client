package game.actions
{
   import game.battlefield.MapData;
   import game.gameElements.DebrisObject;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.items.DebrisItem;
   import game.items.ItemManager;
   import game.magicBox.MagicBoxTracker;
   import game.missions.MissionManager;
   import game.net.MyServer;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class CleanAction extends Action
   {
       
      
      public function CleanAction(param1:DebrisObject)
      {
         super("Clean");
         mTarget = param1;
         mSkipped = false;
      }
      
      override public function update(param1:int) : void
      {
         var _loc2_:DebrisObject = mTarget as DebrisObject;
         if(_loc2_.isCleaningOver())
         {
            if(!mSkipped)
            {
               this.execute();
            }
         }
         if(mSkipped)
         {
            _loc2_.skipSearch();
         }
      }
      
      override public function isOver() : Boolean
      {
         return (mTarget as DebrisObject).isCleaningOver() || mSkipped;
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         var _loc1_:GameState = GameState.mInstance;
         if(_loc1_.mPlayerProfile.mEnergy <= 0)
         {
            _loc1_.mHUD.openOutOfEnergyWindow();
            this.skip();
            return;
         }
         if(!_loc1_.mPlayerProfile.hasEnoughMapResource(1))
         {
            _loc1_.mHUD.openOutOfMapResourceWindow();
            this.skip();
            return;
         }
         this.startCleaning();
      }
      
      protected function startCleaning() : void
      {
         var _loc1_:IsometricScene = GameState.mInstance.mScene;
         var _loc2_:GridCell = (mTarget as DebrisObject).getCell();
         if(_loc2_.mOwner != MapData.TILE_OWNER_FRIENDLY || Boolean(_loc2_.mCharacter))
         {
            this.skip();
            return;
         }
         mTarget.playSound(ArmySoundManager.SFX_UI_CLEAN);
         (mTarget as DebrisObject).StartSearching();
      }
      
      protected function execute() : void
      {
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:IsometricScene = _loc1_.mScene;
         var _loc3_:DebrisObject = mTarget as DebrisObject;
         var _loc4_:GamePlayerProfile = _loc1_.mPlayerProfile;
         var _loc5_:DebrisItem = DebrisItem(_loc3_.mItem);
         var _loc6_:* = _loc3_.getHealth() - 1 <= 0;
         var _loc7_:int = _loc5_.mHitRewardXP;
         var _loc8_:int = _loc5_.mHitRewardMoney;
         var _loc9_:int = _loc5_.mHitRewardMaterial;
         var _loc10_:int = _loc5_.mHitRewardSupplies;
         var _loc11_:int = _loc5_.mHitRewardEnergy;
         if(_loc6_)
         {
            _loc7_ += _loc5_.mKillRewardXP;
            _loc8_ += _loc5_.mKillRewardMoney;
            _loc9_ += _loc5_.mKillRewardMaterial;
            _loc10_ += _loc5_.mKillRewardSupplies;
            _loc11_ += _loc5_.mKillRewardEnergy;
         }
         _loc4_.increaseEnergyRewardCounter(_loc11_);
         var _loc12_:int = _loc4_.getBonusEnergy();
         _loc3_.addTextEffect(TextEffect.TYPE_LOSS,"-1",ItemManager.getItem("Energy","Resource"));
         _loc2_.addLootReward(ItemManager.getItem("XP","Resource"),_loc7_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc8_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Material","Resource"),_loc9_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc10_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc12_,_loc3_.getContainer());
         _loc1_.reduceEnergy(mName,1,MagicBoxTracker.paramsObj(_loc3_.mItem.mType,_loc3_.mItem.mId));
         _loc1_.reduceMapResource(1);
         _loc3_.reduceHealth(1);
         MissionManager.increaseCounter("Clear",_loc3_,1);
         var _loc13_:GridCell = mTarget.getCell();
         var _loc14_:Object = {
            "coord_x":_loc13_.mPosI,
            "coord_y":_loc13_.mPosJ,
            "item_hit_points":1,
            "cost_energy":1,
            "reward_xp":_loc7_,
            "reward_money":_loc8_,
            "reward_material":_loc9_,
            "reward_supplies":_loc10_,
            "reward_energy":_loc11_
         };
         if(_loc1_.mMapData.mMapSetupData.Resource)
         {
            _loc14_[MyServer.MAP_RESOURCE_COST_NAMES[_loc1_.mMapData.mMapSetupData.Resource]] = 1;
         }
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.CLEAN_DEBRIS,_loc14_,false);
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      override public function skip() : void
      {
         super.skip();
         (mTarget as DebrisObject).skipSearch();
      }
   }
}
