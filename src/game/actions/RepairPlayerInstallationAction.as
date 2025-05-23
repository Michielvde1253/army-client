package game.actions
{
   import game.gameElements.PlayerInstallationObject;
   import game.gui.GameHUD;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.elements.Renderable;
   import game.items.ItemManager;
   import game.items.PlayerInstallationItem;
   import game.items.RepairableItem;
   import game.magicBox.MagicBoxTracker;
   import game.missions.MissionManager;
   import game.net.MyServer;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class RepairPlayerInstallationAction extends Action
   {
      
      private static const STATE_REPAIRING:int = 0;
      
      private static const STATE_OVER:int = 1;
       
      
      private var mTimer:int;
      
      private var mState:int;
      
      private var mNewState:int;
      
      public function RepairPlayerInstallationAction(param1:PlayerInstallationObject)
      {
         super("RepairPlayerInstallationAction");
         mTarget = param1;
         this.mTimer = 0;
         this.mState = -1;
         this.mNewState = -1;
      }
      
      override public function update(param1:int) : void
      {
         if(this.mState == STATE_OVER || mSkipped)
         {
            return;
         }
         if(this.mNewState != this.mState)
         {
            this.changeState(this.mNewState);
         }
         this.mTimer += param1;
         switch(this.mState)
         {
            case STATE_REPAIRING:
               if(this.mTimer >= Renderable.GENERIC_ACTION_DELAY_TIME)
               {
                  this.execute();
               }
         }
      }
      
      private function changeState(param1:int) : void
      {
         this.mTimer = 0;
         this.mState = param1;
         this.mNewState = param1;
         switch(this.mState)
         {
            case STATE_REPAIRING:
               mTarget.showLoadingBar();
         }
      }
      
      override public function isOver() : Boolean
      {
         return this.mState == STATE_OVER || mSkipped;
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         var _loc1_:GameHUD = GameState.mInstance.mHUD;
         var _loc2_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         var _loc3_:PlayerInstallationObject = mTarget as PlayerInstallationObject;
         if((_loc3_.mItem as RepairableItem).mHealCostEnergy > 0 && _loc2_.mEnergy < (_loc3_.mItem as RepairableItem).mHealCostEnergy)
         {
            _loc1_.openOutOfEnergyWindow();
            skip();
         }
         else if(!_loc2_.hasEnoughMapResource((_loc3_.mItem as RepairableItem).mHealCostEnergy))
         {
            _loc1_.openOutOfMapResourceWindow();
            skip();
         }
         else if(_loc3_.getHealCostSupplies() > _loc2_.mSupplies)
         {
            _loc1_.openOutOfSuppliesTextBox([_loc3_.getHealCostSupplies(),_loc2_.mSupplies]);
            skip();
         }
         else if(!this.isLegal())
         {
            skip();
         }
         if(mSkipped)
         {
            this.mNewState = STATE_OVER;
            return;
         }
         this.mNewState = STATE_REPAIRING;
         _loc3_.playSound(ArmySoundManager.SFX_UI_REPAIR);
      }
      
      private function isLegal() : Boolean
      {
         return Boolean(mTarget) && !(mTarget as PlayerInstallationObject).isFullHealth();
      }
      
      private function execute() : void
      {
         if(!mTarget)
         {
            Utils.LogError("RepairPlayerInstallation: Installation not found");
            this.mNewState = STATE_OVER;
            return;
         }
         if(this.mState != STATE_REPAIRING)
         {
            Utils.LogError("RepairPlayerInstallation: Illegal state");
            this.mNewState = STATE_OVER;
            return;
         }
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:IsometricScene = _loc1_.mScene;
         var _loc3_:GamePlayerProfile = _loc1_.mPlayerProfile;
         var _loc5_:PlayerInstallationItem;
         var _loc4_:PlayerInstallationObject;
         var _loc6_:int = (_loc5_ = (_loc4_ = mTarget as PlayerInstallationObject).mItem as PlayerInstallationItem).mHealRewardXP;
         var _loc7_:int = _loc5_.mHealRewardMoney;
         var _loc8_:int = _loc5_.mHealRewardEnergy;
         _loc3_.increaseEnergyRewardCounter(_loc8_);
         var _loc9_:int = _loc3_.getBonusEnergy();
         _loc1_.reduceEnergy(mName,_loc5_.mHealCostEnergy,MagicBoxTracker.paramsObj(_loc4_.mItem.mType,_loc4_.mItem.mId));
         _loc1_.reduceMapResource(_loc5_.mHealCostEnergy);
         var _loc10_:int = _loc4_.getHealCostSupplies();
         _loc3_.addSupplies(-_loc10_,mName,MagicBoxTracker.paramsObj(_loc4_.mItem.mType,_loc4_.mItem.mId));
         _loc2_.addLootReward(ItemManager.getItem("XP","Resource"),_loc6_,_loc4_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc7_,_loc4_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc9_,_loc4_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Supplies","Resource"),-_loc10_,_loc4_.getContainer());
         if(_loc5_.mHealCostEnergy > 0)
         {
            _loc4_.addTextEffect(TextEffect.TYPE_LOSS,String(_loc5_.mHealCostEnergy),ItemManager.getItem("Energy","Resource"));
         }
         _loc4_.addTextEffect(TextEffect.TYPE_LOSS,String(-_loc10_),ItemManager.getItem("Supplies","Resource"));
         _loc4_.healToMax();
         MissionManager.increaseCounter("Repair",mTarget,1);
         this.mNewState = STATE_OVER;
         var _loc11_:GridCell = mTarget.getCell();
         var _loc12_:Object = {
            "coord_x":_loc11_.mPosI,
            "coord_y":_loc11_.mPosJ,
            "cost_energy":_loc5_.mHealCostEnergy,
            "cost_supplies":_loc10_,
            "reward_xp":_loc6_,
            "reward_money":_loc7_,
            "reward_energy":_loc8_
         };
         if(_loc1_.mMapData.mMapSetupData.Resource)
         {
            _loc12_[MyServer.MAP_RESOURCE_COST_NAMES[_loc1_.mMapData.mMapSetupData.Resource]] = _loc5_.mHealCostEnergy;
         }
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.REPAIR_PLAYER_INSTALLATION,_loc12_,false);
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
