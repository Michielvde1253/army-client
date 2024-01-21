package game.actions
{
   import game.gameElements.DebrisObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.items.DebrisItem;
   import game.items.ItemManager;
   import game.missions.MissionManager;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class AcceptHelpCleanAction extends CleanAction
   {
       
      
      private var mNeighborActionID:String;
      
      public function AcceptHelpCleanAction(param1:DebrisObject, param2:String)
      {
         super(param1);
         this.mNeighborActionID = param2;
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         this.startCleaning();
      }
      
      override protected function startCleaning() : void
      {
         var _loc1_:IsometricScene = GameState.mInstance.mScene;
         var _loc2_:GridCell = (mTarget as DebrisObject).getCell();
         mTarget.playSound(ArmySoundManager.SFX_UI_CLEAN);
         (mTarget as DebrisObject).StartSearching();
      }
      
      override protected function execute() : void
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
         _loc2_.addLootReward(ItemManager.getItem("XP","Resource"),_loc7_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc8_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Material","Resource"),_loc9_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc10_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc12_,_loc3_.getContainer());
         _loc3_.reduceHealth(1);
         MissionManager.increaseCounter("Clear",_loc3_,1);
         var _loc13_:GridCell;
         if(!(_loc13_ = mTarget.getCell()))
         {
            skip();
            return;
         }
         var _loc14_:Object = {
            "neighbor_action_id":this.mNeighborActionID,
            "item_hit_points":1,
            "reward_xp":_loc7_,
            "reward_money":_loc8_,
            "reward_material":_loc9_,
            "reward_supplies":_loc10_,
            "reward_energy":_loc11_
         };
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.ACCEPT_HELP_CLEAR_DEBRIS,_loc14_,false);
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
