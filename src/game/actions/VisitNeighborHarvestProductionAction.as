package game.actions
{
   import game.gameElements.PlayerBuildingObject;
   import game.gameElements.Production;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.items.ItemManager;
   import game.missions.MissionManager;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class VisitNeighborHarvestProductionAction extends HarvestProductionAction
   {
       
      
      public function VisitNeighborHarvestProductionAction(param1:PlayerBuildingObject)
      {
         super(param1);
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         var _loc1_:GameState = GameState.mInstance;
         if(_loc1_.mPlayerProfile.mNeighborActionsLeft <= 0)
         {
            (mTarget as PlayerBuildingObject).addTextEffect(TextEffect.TYPE_GAIN,GameState.getText("SOCIAL_ENERGY_ZERO_FLOATING"));
            mSkipped = true;
            return;
         }
         (mTarget as PlayerBuildingObject).startHarvesting();
         mTarget.playSound(ArmySoundManager.SFX_UI_HARVEST);
      }
      
      override protected function execute() : void
      {
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:IsometricScene = _loc1_.mScene;
         var _loc3_:PlayerBuildingObject = mTarget as PlayerBuildingObject;
         var _loc4_:Production = _loc3_.getProduction();
         _loc3_.getCell().mNeighborActionAvailable = false;
         var _loc5_:GamePlayerProfile;
         (_loc5_ = _loc1_.mPlayerProfile).addNeighborActions(-1);
         var _loc6_:Object;
         var _loc7_:int = int((_loc6_ = GameState.mConfig.AllyAction.CollectProduction).RewardSocialXP);
         var _loc8_:int = int(_loc6_.RewardMoney);
         var _loc9_:int = int(_loc6_.RewardSupplies);
         _loc2_.addLootReward(ItemManager.getItem("SocialXP","Resource"),_loc7_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc8_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc9_,_loc3_.getContainer());
         _loc3_.removeProduction();
         _loc3_.handleProductionHarvested();
         MissionManager.increaseCounter("HelpNeighborCollect",_loc3_,1);
         var _loc10_:GridCell = mTarget.getCell();
         var _loc11_:Object = {
            "coord_x":_loc10_.mPosI,
            "coord_y":_loc10_.mPosJ,
            "neighbor_user_id":_loc1_.mVisitingFriend.mUserID,
            "reward_social_xp":_loc7_,
            "reward_money":_loc8_,
            "reward_supplies":_loc9_,
            "neighbor_counter":"Collect",
            "target_type":ItemManager.getTableNameForItem(_loc3_.mItem),
            "target_id":_loc3_.mItem.mId
         };
         if(_loc1_.visitingTutor())
         {
            _loc11_.tutor_map = 2;
         }
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.SCHEDULE_ACTION_AT_NEIGHBOR,_loc11_,false);
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
