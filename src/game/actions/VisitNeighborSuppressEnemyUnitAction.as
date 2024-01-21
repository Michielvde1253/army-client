package game.actions
{
   import game.characters.EnemyUnit;
   import game.gameElements.FriendSuppressObject;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.SceneLoader;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.TargetItem;
   import game.missions.MissionManager;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class VisitNeighborSuppressEnemyUnitAction extends Action
   {
       
      
      private var mSuppressMortar:FriendSuppressObject;
      
      public function VisitNeighborSuppressEnemyUnitAction(param1:EnemyUnit)
      {
         super("Suppress Enemy Unit");
         mTarget = param1;
         mSkipped = false;
      }
      
      override public function update(param1:int) : void
      {
         if(mSkipped)
         {
            (mTarget as EnemyUnit).skipSuppress();
         }
         else if(Boolean(this.mSuppressMortar) && this.mSuppressMortar.isOver())
         {
            this.mSuppressMortar.destroy();
         }
         else
         {
            this.mSuppressMortar.update();
         }
         if((mTarget as EnemyUnit).isSuppressOver())
         {
            if(this.mSuppressMortar)
            {
               if(this.mSuppressMortar.isOver())
               {
                  if(!mSkipped)
                  {
                     this.execute();
                  }
               }
            }
         }
      }
      
      override public function isOver() : Boolean
      {
         if(!this.mSuppressMortar)
         {
            return true;
         }
         return (mTarget as EnemyUnit).isSuppressOver() && this.mSuppressMortar.isOver() || mSkipped;
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         if(mTarget == null || !mTarget.isAlive() || (mTarget as EnemyUnit).mCurrentAction || (mTarget as EnemyUnit).getHealth() == 0)
         {
            mSkipped = true;
            return;
         }
         var _loc1_:GameState = GameState.mInstance;
         if(_loc1_.mPlayerProfile.mNeighborActionsLeft <= 0)
         {
            (mTarget as EnemyUnit).addTextEffect(TextEffect.TYPE_GAIN,GameState.getText("SOCIAL_ENERGY_ZERO_FLOATING"));
            mSkipped = true;
            return;
         }
         this.mSuppressMortar = new FriendSuppressObject();
         this.mSuppressMortar.start();
         _loc1_.mScene.mSceneHud.addChild(this.mSuppressMortar);
         this.mSuppressMortar.x = mTarget.mX - SceneLoader.GRID_CELL_SIZE / 2;
         this.mSuppressMortar.y = mTarget.mY - SceneLoader.GRID_CELL_SIZE / 2;
         (mTarget as EnemyUnit).startSuppress();
      }
      
      private function execute() : void
      {
         var _loc13_:Item = null;
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:IsometricScene = _loc1_.mScene;
         var _loc3_:GamePlayerProfile = _loc1_.mPlayerProfile;
         var _loc4_:EnemyUnit = mTarget as EnemyUnit;
         var _loc5_:Object;
         var _loc6_:int = int((_loc5_ = GameState.mConfig.AllyAction.SuppressEnemyUnit).Damage);
         var _loc7_:* = _loc4_.getHealth() - _loc6_ <= 0;
         var _loc8_:int = int(_loc5_.RewardSocialXP);
         var _loc9_:int = _loc4_.mHitRewardMoney;
         var _loc10_:int = _loc4_.mHitRewardSupplies;
         var _loc11_:int = _loc4_.mHitRewardEnergy;
         if(_loc7_)
         {
            _loc9_ += _loc4_.mKillRewardMoney;
            _loc10_ += _loc4_.mKillRewardSupplies;
            _loc11_ += _loc4_.mKillRewardEnergy;
         }
         _loc3_.increaseEnergyRewardCounter(_loc11_);
         var _loc12_:int = _loc3_.getBonusEnergy();
         _loc2_.addLootReward(ItemManager.getItem("SocialXP","Resource"),_loc8_,_loc4_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc9_,_loc4_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc10_,_loc4_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc12_,_loc4_.getContainer());
         var _loc14_:int = _loc3_.mRewardDropsCounter;
         if(_loc7_)
         {
            _loc13_ = (_loc4_.mItem as TargetItem).getRandomItemDrop();
            _loc2_.addLootReward(_loc13_,1,mTarget.getContainer());
         }
         _loc4_.getCell().mNeighborActionAvailable = false;
         _loc4_.handleSuppress();
         _loc3_.addNeighborActions(-1);
         MissionManager.increaseCounter("HelpNeighborSuppress",_loc4_,1);
         var _loc15_:GridCell = _loc4_.getCell();
         var _loc16_:Object = {
            "coord_x":_loc15_.mPosI,
            "coord_y":_loc15_.mPosJ,
            "item_hit_points":_loc6_,
            "neighbor_user_id":_loc1_.mVisitingFriend.mUserID,
            "reward_social_xp":_loc8_,
            "reward_money":_loc9_,
            "reward_supplies":_loc10_,
            "reward_energy":_loc11_,
            "neighbor_counter":"Suppress",
            "target_type":ItemManager.getTableNameForItem(_loc4_.mItem),
            "target_id":_loc4_.mItem.mId
         };
         if(_loc7_)
         {
            _loc16_.reward_drop_seed_term = _loc3_.mRewardDropSeedTerm;
            _loc16_.reward_drops_counter = _loc14_;
         }
         if(_loc13_)
         {
            _loc16_.reward_item_type = ItemManager.getTableNameForItem(_loc13_);
            _loc16_.reward_item_id = _loc13_.mId;
         }
         if(_loc1_.visitingTutor())
         {
            _loc16_.tutor_map = 2;
         }
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.SCHEDULE_ACTION_AT_NEIGHBOR,_loc16_,false);
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
