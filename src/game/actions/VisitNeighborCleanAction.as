package game.actions
{
   import game.gameElements.DebrisObject;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.items.DebrisItem;
   import game.items.ItemManager;
   import game.missions.MissionManager;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class VisitNeighborCleanAction extends CleanAction
   {
       
      
      public function VisitNeighborCleanAction(param1:DebrisObject)
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
            (mTarget as DebrisObject).addTextEffect(TextEffect.TYPE_GAIN,GameState.getText("SOCIAL_ENERGY_ZERO_FLOATING"));
            mSkipped = true;
            return;
         }
         mTarget.playSound(ArmySoundManager.SFX_UI_CLEAN);
         startCleaning();
      }
      
      override protected function execute() : void
      {
         var _loc4_:GamePlayerProfile = null;
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:IsometricScene = _loc1_.mScene;
         var _loc3_:DebrisObject = mTarget as DebrisObject;
         _loc4_ = _loc1_.mPlayerProfile;
         var _loc5_:DebrisItem = DebrisItem(_loc3_.mItem);
         var _loc6_:* = _loc3_.getHealth() - 1 <= 0;
         var _loc7_:Object;
         var _loc8_:int = int((_loc7_ = GameState.mConfig.AllyAction.ClearDebris).RewardSocialXP);
         var _loc9_:int = int(_loc7_.RewardMoney);
         var _loc10_:int = int(_loc7_.RewardSupplies);
         _loc2_.addLootReward(ItemManager.getItem("SocialXP","Resource"),_loc8_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc9_,_loc3_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc10_,_loc3_.getContainer());
         _loc3_.reduceHealth(1);
         _loc3_.getCell().mNeighborActionAvailable = false;
         _loc4_.addNeighborActions(-1);
         MissionManager.increaseCounter("HelpNeighborClear",_loc3_,1);
         var _loc11_:GridCell = mTarget.getCell();
         var _loc12_:Object = {
            "coord_x":_loc11_.mPosI,
            "coord_y":_loc11_.mPosJ,
            "neighbor_user_id":_loc1_.mVisitingFriend.mUserID,
            "reward_social_xp":_loc8_,
            "reward_money":_loc9_,
            "reward_supplies":_loc10_,
            "neighbor_counter":"Clear",
            "target_type":ItemManager.getTableNameForItem(_loc3_.mItem),
            "target_id":_loc3_.mItem.mId
         };
         if(_loc1_.visitingTutor())
         {
            _loc12_.tutor_map = 2;
         }
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.SCHEDULE_ACTION_AT_NEIGHBOR,_loc12_,false);
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
