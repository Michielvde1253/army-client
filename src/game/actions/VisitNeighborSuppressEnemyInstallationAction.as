package game.actions
{
   import game.gameElements.EnemyInstallationObject;
   import game.gameElements.FriendSuppressObject;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.SceneLoader;
   import game.items.EnemyInstallationItem;
   import game.items.Item;
   import game.items.ItemManager;
   import game.missions.MissionManager;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class VisitNeighborSuppressEnemyInstallationAction extends Action
   {
       
      
      private var mSuppressMortar:FriendSuppressObject;
      
      public function VisitNeighborSuppressEnemyInstallationAction(param1:EnemyInstallationObject)
      {
         super("Suppress Enemy Installation");
         mTarget = param1;
         mSkipped = false;
      }
      
      override public function update(param1:int) : void
      {
         if(mSkipped)
         {
            (mTarget as EnemyInstallationObject).skipSuppress();
         }
         else if(Boolean(this.mSuppressMortar) && this.mSuppressMortar.isOver())
         {
            this.mSuppressMortar.destroy();
         }
         else
         {
            this.mSuppressMortar.update();
         }
         if((mTarget as EnemyInstallationObject).isSuppressOver())
         {
            if(this.mSuppressMortar && this.mSuppressMortar.isOver() && !mSkipped)
            {
               this.execute();
            }
         }
      }
      
      override public function isOver() : Boolean
      {
         if(!this.mSuppressMortar)
         {
            return true;
         }
         return (mTarget as EnemyInstallationObject).isSuppressOver() && this.mSuppressMortar.isOver() || mSkipped;
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         if(mTarget == null || !mTarget.isAlive() || (mTarget as EnemyInstallationObject).mCurrentAction || (mTarget as EnemyInstallationObject).getHealth() == 0)
         {
            mSkipped = true;
            return;
         }
         var _loc1_:GameState = GameState.mInstance;
         if(_loc1_.mPlayerProfile.mNeighborActionsLeft <= 0)
         {
            (mTarget as EnemyInstallationObject).addTextEffect(TextEffect.TYPE_GAIN,GameState.getText("SOCIAL_ENERGY_ZERO_FLOATING"));
            mSkipped = true;
            return;
         }
         this.mSuppressMortar = new FriendSuppressObject();
         this.mSuppressMortar.start();
         _loc1_.mScene.mSceneHud.addChild(this.mSuppressMortar);
         this.mSuppressMortar.x = mTarget.mX + (mTarget.getTileSize().x - 2) * SceneLoader.GRID_CELL_SIZE / 2;
         this.mSuppressMortar.y = mTarget.mY + (mTarget.getTileSize().y - 2) * SceneLoader.GRID_CELL_SIZE / 2;
         (mTarget as EnemyInstallationObject).startSuppress();
      }
      
      private function execute() : void
      {
         var _loc14_:Item = null;
         var _loc1_:EnemyInstallationObject = mTarget as EnemyInstallationObject;
         if(_loc1_.hasForceField())
         {
            return;
         }
         var _loc2_:GameState = GameState.mInstance;
         var _loc3_:IsometricScene = _loc2_.mScene;
         var _loc4_:GamePlayerProfile = _loc2_.mPlayerProfile;
         var _loc5_:Object;
         var _loc6_:int = int((_loc5_ = GameState.mConfig.AllyAction.SabotageEnemyInstallation).Damage);
         var _loc7_:* = _loc1_.getHealth() - _loc6_ <= 0;
         var _loc8_:EnemyInstallationItem = _loc1_.mItem as EnemyInstallationItem;
         var _loc9_:int = int(_loc5_.RewardSocialXP);
         var _loc10_:int = _loc8_.mHitRewardMoney;
         var _loc11_:int = _loc8_.mHitRewardSupplies;
         var _loc12_:int = _loc8_.mHitRewardEnergy;
         if(_loc7_)
         {
            _loc10_ += _loc8_.mKillRewardMoney;
            _loc11_ += _loc8_.mKillRewardSupplies;
            _loc12_ += _loc8_.mKillRewardEnergy;
         }
         _loc4_.increaseEnergyRewardCounter(_loc12_);
         var _loc13_:int = _loc4_.getBonusEnergy();
         _loc3_.addLootReward(ItemManager.getItem("SocialXP","Resource"),_loc9_,_loc1_.getContainer());
         _loc3_.addLootReward(ItemManager.getItem("Money","Resource"),_loc10_,_loc1_.getContainer());
         _loc3_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc11_,_loc1_.getContainer());
         _loc3_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc13_,_loc1_.getContainer());
         var _loc15_:int = _loc4_.mRewardDropsCounter;
         if(_loc7_)
         {
            _loc14_ = _loc8_.getRandomItemDrop();
            _loc3_.addLootReward(_loc14_,1,_loc1_.getContainer());
         }
         _loc1_.getCell().mNeighborActionAvailable = false;
         _loc1_.handleSuppress();
         _loc4_.addNeighborActions(-1);
         MissionManager.increaseCounter("HelpNeighborSuppress",_loc1_,1);
         var _loc16_:GridCell = mTarget.getCell();
         var _loc17_:Object = {
            "coord_x":_loc16_.mPosI,
            "coord_y":_loc16_.mPosJ,
            "item_hit_points":_loc6_,
            "neighbor_user_id":_loc2_.mVisitingFriend.mUserID,
            "reward_social_xp":_loc9_,
            "reward_money":_loc10_,
            "reward_supplies":_loc11_,
            "reward_energy":_loc12_,
            "neighbor_counter":"Suppress",
            "target_type":ItemManager.getTableNameForItem(_loc1_.mItem),
            "target_id":_loc1_.mItem.mId
         };
         if(_loc7_)
         {
            _loc17_.reward_drop_seed_term = _loc4_.mRewardDropSeedTerm;
            _loc17_.reward_drops_counter = _loc15_;
         }
         if(_loc14_)
         {
            _loc17_.reward_item_type = ItemManager.getTableNameForItem(_loc14_);
            _loc17_.reward_item_id = _loc14_.mId;
         }
         if(_loc2_.visitingTutor())
         {
            _loc17_.tutor_map = 2;
         }
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.SCHEDULE_ACTION_AT_NEIGHBOR,_loc17_,false);
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
