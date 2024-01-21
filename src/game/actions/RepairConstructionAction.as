package game.actions
{
   import game.gameElements.ConstructionObject;
   import game.gameElements.PlayerBuildingObject;
   import game.gameElements.ResourceBuildingObject;
   import game.gui.GameHUD;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.elements.Renderable;
   import game.items.ConstructionItem;
   import game.items.ItemManager;
   import game.items.RepairableItem;
   import game.magicBox.MagicBoxTracker;
   import game.missions.MissionManager;
   import game.net.MyServer;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class RepairConstructionAction extends Action
   {
      
      private static const STATE_REPAIRING:int = 0;
      
      private static const STATE_OVER:int = 1;
       
      
      private var mTimer:Number;
      
      private var mState:int;
      
      private var mNewState:int;
      
      public function RepairConstructionAction(param1:ConstructionObject)
      {
         super("RepairConstructionAction");
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
         switch(this.mState)
         {
            case STATE_REPAIRING:
               this.mTimer += param1;
               mTarget.setLoadingBarPercent(this.mTimer / Renderable.GENERIC_ACTION_DELAY_TIME);
               if(this.mTimer >= Renderable.GENERIC_ACTION_DELAY_TIME)
               {
                  this.execute();
                  this.mNewState = STATE_OVER;
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
               (mTarget as ConstructionObject).startRepairing();
               break;
            case STATE_OVER:
               (mTarget as ConstructionObject).hideLoadingBar();
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
         var _loc3_:ConstructionObject = mTarget as ConstructionObject;
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
         if((mTarget as ConstructionObject).getState() == PlayerBuildingObject.STATE_RUINS)
         {
            return (mTarget as ConstructionObject).isRepairable();
         }
         if(!(mTarget as ConstructionObject).isFullHealth())
         {
            return true;
         }
         return false;
      }
      
      private function execute() : void
      {
         if(!mTarget)
         {
            Utils.LogError("RepairConstruction: Construction not found");
            this.mNewState = STATE_OVER;
            return;
         }
         if(this.mState != STATE_REPAIRING)
         {
            Utils.LogError("RepairConstruction: Illegal state");
            this.mNewState = STATE_OVER;
            return;
         }
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:IsometricScene = _loc1_.mScene;
         var _loc3_:GamePlayerProfile = _loc1_.mPlayerProfile;
         var _loc4_:ConstructionItem;
         var _loc5_:int = (_loc4_ = mTarget.mItem as ConstructionItem).mHealRewardXP;
         var _loc6_:int = _loc4_.mHealRewardMoney;
         var _loc7_:int = _loc4_.mHealRewardEnergy;
         _loc3_.increaseEnergyRewardCounter(_loc7_);
         var _loc8_:int = _loc3_.getBonusEnergy();
         _loc1_.reduceEnergy(mName,_loc4_.mHealCostEnergy,MagicBoxTracker.paramsObj((mTarget as ConstructionObject).mItem.mType,(mTarget as ConstructionObject).mItem.mId));
         _loc1_.reduceMapResource(_loc4_.mHealCostEnergy);
         var _loc9_:int = (mTarget as ConstructionObject).getHealCostSupplies();
         _loc3_.addSupplies(-_loc9_,mName,MagicBoxTracker.paramsObj((mTarget as ConstructionObject).mItem.mType,(mTarget as ConstructionObject).mItem.mId));
         _loc2_.addLootReward(ItemManager.getItem("XP","Resource"),_loc5_,mTarget.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc6_,mTarget.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc8_,mTarget.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Supplies","Resource"),-_loc9_,mTarget.getContainer());
         if(_loc4_.mHealCostEnergy > 0)
         {
            (mTarget as ConstructionObject).addTextEffect(TextEffect.TYPE_LOSS,String(-_loc4_.mHealCostEnergy),ItemManager.getItem("Energy","Resource"));
         }
         (mTarget as ConstructionObject).addTextEffect(TextEffect.TYPE_LOSS,String(-_loc9_),ItemManager.getItem("Supplies","Resource"));
         (mTarget as ConstructionObject).healToMax();
         MissionManager.increaseCounter("Repair",mTarget,1);
         var _loc10_:String = mTarget is ResourceBuildingObject ? "ResourceBuilding" : "Building";
         var _loc11_:GridCell = mTarget.getCell();
         var _loc12_:Object = {
            "coord_x":_loc11_.mPosI,
            "coord_y":_loc11_.mPosJ,
            "cost_energy":_loc4_.mHealCostEnergy,
            "cost_supplies":_loc9_,
            "reward_xp":_loc5_,
            "reward_money":_loc6_,
            "reward_energy":_loc7_,
            "item_type":_loc10_
         };
         if(_loc1_.mMapData.mMapSetupData.Resource)
         {
            _loc12_[MyServer.MAP_RESOURCE_COST_NAMES[_loc1_.mMapData.mMapSetupData.Resource]] = _loc4_.mHealCostEnergy;
         }
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.REPAIR_PLAYER_BUILDING,_loc12_,false);
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
