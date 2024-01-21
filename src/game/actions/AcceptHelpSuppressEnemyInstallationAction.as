package game.actions
{
   import game.gameElements.EnemyInstallationObject;
   import game.gameElements.FriendSuppressObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.SceneLoader;
   import game.items.EnemyInstallationItem;
   import game.items.Item;
   import game.items.ItemManager;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class AcceptHelpSuppressEnemyInstallationAction extends Action
   {
       
      
      private var mNeighborActionID:String;
      
      private var mSuppressMortar:FriendSuppressObject;
      
      public function AcceptHelpSuppressEnemyInstallationAction(param1:EnemyInstallationObject, param2:String)
      {
         super("Suppress Enemy Installation");
         mTarget = param1;
         mSkipped = false;
         this.mNeighborActionID = param2;
      }
      
      override public function update(param1:int) : void
      {
         if(mSkipped)
         {
            return;
         }
         var _loc2_:EnemyInstallationObject = mTarget as EnemyInstallationObject;
         if(this.mSuppressMortar.isOver() || mSkipped)
         {
            this.mSuppressMortar.destroy();
            if(mSkipped)
            {
               _loc2_.skipSuppress();
            }
         }
         else
         {
            this.mSuppressMortar.update();
         }
         if(_loc2_.isSuppressOver())
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
      
      override public function isOver() : Boolean
      {
         return mSkipped || (mTarget as EnemyInstallationObject).isSuppressOver() && this.mSuppressMortar.isOver();
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         var _loc1_:EnemyInstallationObject = mTarget as EnemyInstallationObject;
         if(_loc1_ == null || !_loc1_.isAlive() || _loc1_.mCurrentAction || _loc1_.getHealth() == 0)
         {
            mSkipped = true;
            return;
         }
         _loc1_.startSuppress();
         var _loc2_:GameState = GameState.mInstance;
         this.mSuppressMortar = new FriendSuppressObject();
         this.mSuppressMortar.start();
         _loc2_.mScene.mSceneHud.addChild(this.mSuppressMortar);
         this.mSuppressMortar.x = _loc1_.mX - SceneLoader.GRID_CELL_SIZE / 2 + (_loc1_.getTileSize().x - 1) * (SceneLoader.GRID_CELL_SIZE / 2);
         this.mSuppressMortar.y = _loc1_.mY - SceneLoader.GRID_CELL_SIZE / 2 + (_loc1_.getTileSize().y - 1) * (SceneLoader.GRID_CELL_SIZE / 2);
      }
      
      private function execute() : void
      {
         var _loc13_:Item = null;
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:IsometricScene = _loc1_.mScene;
         var _loc3_:GamePlayerProfile = _loc1_.mPlayerProfile;
         var _loc4_:EnemyInstallationObject = mTarget as EnemyInstallationObject;
         var _loc5_:int = int(GameState.mConfig.AllyAction.SabotageEnemyInstallation.Damage);
         var _loc6_:* = _loc4_.getHealth() - _loc5_ <= 0;
         var _loc7_:EnemyInstallationItem;
         var _loc8_:int = (_loc7_ = _loc4_.mItem as EnemyInstallationItem).mHitRewardXP;
         var _loc9_:int = _loc7_.mHitRewardMoney;
         var _loc10_:int = _loc7_.mHitRewardSupplies;
         var _loc11_:int = _loc7_.mHitRewardEnergy;
         if(_loc6_)
         {
            _loc8_ += _loc7_.mKillRewardXP;
            _loc9_ += _loc7_.mKillRewardMoney;
            _loc10_ += _loc7_.mKillRewardSupplies;
            _loc11_ += _loc7_.mKillRewardEnergy;
         }
         _loc3_.increaseEnergyRewardCounter(_loc11_);
         var _loc12_:int = _loc3_.getBonusEnergy();
         _loc2_.addLootReward(ItemManager.getItem("XP","Resource"),_loc8_,_loc4_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc9_,_loc4_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc10_,_loc4_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc12_,_loc4_.getContainer());
         var _loc14_:int = _loc3_.mRewardDropsCounter;
         if(_loc6_)
         {
            _loc13_ = _loc7_.getRandomItemDrop();
            _loc2_.addLootReward(_loc13_,1,_loc4_.getContainer());
         }
         _loc4_.handleSuppress();
         var _loc15_:GridCell;
         if(!(_loc15_ = mTarget.getCell()))
         {
            skip();
            return;
         }
         var _loc16_:Object = {
            "neighbor_action_id":this.mNeighborActionID,
            "coord_x":_loc15_.mPosI,
            "coord_y":_loc15_.mPosJ,
            "item_hit_points":_loc5_,
            "reward_xp":_loc8_,
            "reward_money":_loc9_,
            "reward_supplies":_loc10_,
            "reward_energy":_loc11_
         };
         if(_loc6_)
         {
            _loc16_.reward_drop_seed_term = _loc3_.mRewardDropSeedTerm;
            _loc16_.reward_drops_counter = _loc14_;
         }
         if(_loc13_)
         {
            _loc16_.reward_item_type = ItemManager.getTableNameForItem(_loc13_);
            _loc16_.reward_item_id = _loc13_.mId;
         }
         if(_loc6_ && (mTarget as EnemyInstallationObject).mLastAttackDamage > 0)
         {
            GameState.mInstance.queueAction(new LastAttackAction(mTarget as EnemyInstallationObject,ServiceIDs.ACCEPT_HELP_SUPPRESS_ENEMY_INSTALLATION,_loc16_),true);
            if(Config.DEBUG_MODE)
            {
            }
         }
         else
         {
            GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.ACCEPT_HELP_SUPPRESS_ENEMY_INSTALLATION,_loc16_,false);
            if(Config.DEBUG_MODE)
            {
            }
         }
      }
   }
}
