package game.actions
{
   import game.characters.EnemyUnit;
   import game.gameElements.EnemyInstallationObject;
   import game.gameElements.FriendSuppressObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.SceneLoader;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.TargetItem;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class AcceptHelpSuppressEnemyUnitAction extends Action
   {
       
      
      private var mNeighborActionID:String;
      
      private var mSuppressMortar:FriendSuppressObject;
      
      public function AcceptHelpSuppressEnemyUnitAction(param1:EnemyUnit, param2:String)
      {
         super("Suppress Enemy Unit");
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
         this.mSuppressMortar.x = _loc1_.mX - SceneLoader.GRID_CELL_SIZE / 2;
         this.mSuppressMortar.y = _loc1_.mY - SceneLoader.GRID_CELL_SIZE / 2;
      }
      
      private function execute() : void
      {
         var _loc12_:Item = null;
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:IsometricScene = _loc1_.mScene;
         var _loc3_:GamePlayerProfile = _loc1_.mPlayerProfile;
         var _loc4_:EnemyUnit = mTarget as EnemyUnit;
         var _loc5_:int = int(GameState.mConfig.AllyAction.SuppressEnemyUnit.Damage);
         var _loc6_:* = _loc4_.getHealth() - _loc5_ <= 0;
         var _loc7_:int = _loc4_.mHitRewardXP;
         var _loc8_:int = _loc4_.mHitRewardMoney;
         var _loc9_:int = _loc4_.mHitRewardSupplies;
         var _loc10_:int = _loc4_.mHitRewardEnergy;
         if(_loc6_)
         {
            _loc7_ += _loc4_.mKillRewardXP;
            _loc8_ += _loc4_.mKillRewardMoney;
            _loc9_ += _loc4_.mKillRewardSupplies;
            _loc10_ += _loc4_.mKillRewardEnergy;
         }
         _loc3_.increaseEnergyRewardCounter(_loc10_);
         var _loc11_:int = _loc3_.getBonusEnergy();
         _loc2_.addLootReward(ItemManager.getItem("XP","Resource"),_loc7_,_loc4_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc8_,_loc4_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc9_,_loc4_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc11_,_loc4_.getContainer());
         var _loc13_:int = _loc3_.mRewardDropsCounter;
         if(_loc6_)
         {
            _loc12_ = (_loc4_.mItem as TargetItem).getRandomItemDrop();
            _loc2_.addLootReward(_loc12_,1,mTarget.getContainer());
         }
         _loc4_.handleSuppress();
         var _loc14_:GridCell;
         if(!(_loc14_ = _loc4_.getCell()))
         {
            skip();
            return;
         }
         var _loc15_:Object = {
            "neighbor_action_id":this.mNeighborActionID,
            "coord_x":_loc14_.mPosI,
            "coord_y":_loc14_.mPosJ,
            "item_hit_points":_loc5_,
            "reward_xp":_loc7_,
            "reward_money":_loc8_,
            "reward_supplies":_loc9_,
            "reward_energy":_loc10_
         };
         if(_loc6_)
         {
            _loc15_.reward_drop_seed_term = _loc3_.mRewardDropSeedTerm;
            _loc15_.reward_drops_counter = _loc13_;
         }
         if(_loc12_)
         {
            _loc15_.reward_item_type = ItemManager.getTableNameForItem(_loc12_);
            _loc15_.reward_item_id = _loc12_.mId;
         }
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.ACCEPT_HELP_SUPPRESS_ENEMY,_loc15_,false);
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
