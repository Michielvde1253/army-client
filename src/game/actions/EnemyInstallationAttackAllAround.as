package game.actions
{
   import game.characters.AnimationController;
   import game.characters.PlayerUnit;
   import game.gameElements.EnemyInstallationObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.characters.IsometricCharacter;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.TargetItem;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   import game.utils.EffectController;
   
   public class EnemyInstallationAttackAllAround extends Action
   {
      
      private static const STATE_BEFORE_ATTACK:int = 0;
      
      private static const STATE_ATTACKING:int = 1;
      
      private static const STATE_OVER:int = 2;
       
      
      private var mDurationAttack:int;
      
      private var mTargets:Array;
      
      private var mTimer:int;
      
      private var mState:int;
      
      private var mNewState:int;
      
      public function EnemyInstallationAttackAllAround(param1:EnemyInstallationObject)
      {
         super("EnemyInstallationAttackAllAround");
         mActor = param1;
         this.mTimer = 0;
         this.mState = -1;
         this.mNewState = -1;
      }
      
      override public function update(param1:int) : void
      {
         if(mSkipped)
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
            case STATE_BEFORE_ATTACK:
               break;
            case STATE_ATTACKING:
               if(this.mTimer > this.mDurationAttack)
               {
                  this.mNewState = STATE_OVER;
               }
         }
      }
      
      private function changeState(param1:int) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:IsometricCharacter = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:IsometricCharacter = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         this.mTimer = 0;
         this.mState = param1;
         this.mNewState = param1;
         switch(this.mState)
         {
            case STATE_BEFORE_ATTACK:
               _loc2_ = false;
               this.mTargets = GameState.mInstance.searchNearbyUnits(mActor.getCell(),(mActor as EnemyInstallationObject).mAttackRange,mActor.getTileSize().x,mActor.getTileSize().y,false);
               this.mNewState = STATE_ATTACKING;
               break;
            case STATE_ATTACKING:
               mActor.playCollectionSound(mActor.mAttackSounds);
               mActor.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_SHOOT,false,true);
               _loc3_ = (mActor as EnemyInstallationObject).getShootingEffect();
               this.mDurationAttack = EffectController.getEffectLength(_loc3_);
               if(this.mTargets)
               {
                  _loc5_ = int(this.mTargets.length);
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_)
                  {
                     (_loc4_ = this.mTargets[_loc6_] as IsometricCharacter).setAnimationAction(AnimationController.CHARACTER_ANIMATION_HIT,false,true);
                     _loc4_.showActingHealthBar();
                     GameState.mInstance.mScene.addEffect(null,_loc3_,_loc4_.mX,_loc4_.mY);
                     _loc6_++;
                  }
               }
               else
               {
                  this.mDurationAttack = 0;
               }
               this.execute();
               break;
            case STATE_OVER:
               if(this.mTargets)
               {
                  _loc8_ = int(this.mTargets.length);
                  _loc9_ = 0;
                  while(_loc9_ < _loc8_)
                  {
                     if((_loc7_ = this.mTargets[_loc9_] as IsometricCharacter).isAlive())
                     {
                        _loc7_.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                     }
                     _loc9_++;
                  }
               }
               this.mTargets = null;
               if(mActor.isAlive())
               {
                  mActor.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_IDLE,false,true);
               }
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
         if(GameState.mInstance.mState == GameState.STATE_VISITING_NEIGHBOUR)
         {
            skip();
            return;
         }
         if(Boolean(mActor) && mActor.isAlive())
         {
            this.mNewState = STATE_BEFORE_ATTACK;
         }
         else
         {
            skip();
         }
      }
      
      private function execute() : void
      {
         var _loc4_:GridCell = null;
         var _loc5_:Object = null;
         var _loc13_:IsometricCharacter = null;
         var _loc14_:Boolean = false;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:GamePlayerProfile = null;
         var _loc20_:int = 0;
         var _loc21_:IsometricScene = null;
         var _loc22_:Item = null;
         if(GameState.mInstance.mState == GameState.STATE_VISITING_NEIGHBOUR)
         {
            this.mNewState = STATE_OVER;
            return;
         }
         var _loc1_:int = (mActor as EnemyInstallationObject).getPower();
         if(Config.DEBUG_MODE)
         {
         }
         if(this.mState != STATE_ATTACKING)
         {
            Utils.LogError("EnemyInstallationAttackAllAroundAction: Illegal state");
            this.mNewState = STATE_OVER;
            return;
         }
         var _loc2_:GameState = GameState.mInstance;
         var _loc3_:GridCell = mActor.getCell();
         var _loc6_:* = "";
         var _loc7_:* = "";
         var _loc8_:int = _loc2_.mPlayerProfile.mRewardDropsCounter;
         var _loc9_:int = 0;
         var _loc10_:Array = [0,0,0,0];
         var _loc11_:* = "";
         var _loc12_:* = "";
         if(this.mTargets)
         {
            for each(_loc13_ in this.mTargets)
            {
               _loc4_ = _loc13_.getCell();
               if(_loc13_ is PlayerUnit)
               {
                  if(_loc6_.length > 0)
                  {
                     _loc6_ += ";";
                  }
                  _loc6_ = _loc6_ + _loc4_.mPosI + "," + _loc4_.mPosJ;
               }
               else
               {
                  _loc14_ = _loc13_.getHealth() > 0 && _loc13_.getHealth() - _loc1_ <= 0;
                  _loc15_ = _loc13_.mHitRewardXP;
                  _loc16_ = _loc13_.mHitRewardMoney;
                  _loc17_ = _loc13_.mHitRewardSupplies;
                  _loc18_ = _loc13_.mHitRewardEnergy;
                  if(_loc14_)
                  {
                     _loc15_ += _loc13_.mKillRewardXP;
                     _loc16_ += _loc13_.mKillRewardMoney;
                     _loc17_ += _loc13_.mKillRewardSupplies;
                     _loc18_ += _loc13_.mKillRewardEnergy;
                  }
                  (_loc19_ = _loc2_.mPlayerProfile).increaseEnergyRewardCounter(_loc18_);
                  _loc20_ = _loc19_.getBonusEnergy();
                  (_loc21_ = _loc2_.mScene).addLootReward(ItemManager.getItem("XP","Resource"),_loc15_,_loc13_.getContainer());
                  _loc21_.addLootReward(ItemManager.getItem("Money","Resource"),_loc16_,_loc13_.getContainer());
                  _loc21_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc17_,_loc13_.getContainer());
                  _loc21_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc20_,_loc13_.getContainer());
                  if(_loc14_)
                  {
                     _loc22_ = (_loc13_.mItem as TargetItem).getRandomItemDrop();
                     _loc21_.addLootReward(_loc22_,1,_loc13_.getContainer());
                     _loc9_++;
                  }
                  if(_loc22_)
                  {
                     if(_loc11_.length > 0)
                     {
                        _loc11_ += ",";
                     }
                     _loc11_ += ItemManager.getTableNameForItem(_loc22_);
                     if(_loc12_.length > 0)
                     {
                        _loc12_ += ",";
                     }
                     _loc12_ += _loc22_.mId;
                  }
                  if(_loc7_.length > 0)
                  {
                     _loc7_ += ";";
                  }
                  _loc7_ = _loc7_ + _loc4_.mPosI + "," + _loc4_.mPosJ;
                  _loc10_[0] += _loc15_;
                  _loc10_[1] += _loc16_;
                  _loc10_[2] += _loc17_;
                  _loc10_[3] += _loc18_;
               }
               _loc13_.reduceHealth(_loc1_);
            }
         }
         _loc5_ = {
            "enemy_coord_x":_loc3_.mPosI,
            "enemy_coord_y":_loc3_.mPosJ,
            "item_hit_points":_loc1_,
            "reward_xp":_loc10_[0],
            "reward_money":_loc10_[1],
            "reward_supplies":_loc10_[2],
            "reward_energy":_loc10_[3]
         };
         if(_loc6_.length > 0)
         {
            _loc5_.player_coords = _loc6_;
         }
         if(_loc7_.length > 0)
         {
            _loc5_.enemy_coords = _loc7_;
         }
         if(_loc11_.length > 0)
         {
            _loc5_.reward_item_type = _loc11_;
            _loc5_.reward_item_id = _loc12_;
         }
         if(_loc9_ > 0)
         {
            _loc5_.reward_drop_seed_term = _loc2_.mPlayerProfile.mRewardDropSeedTerm;
            _loc5_.reward_drops_counter = _loc8_;
            _loc5_.reward_drops_counter_delta = _loc9_;
         }
         _loc2_.mServer.serverCallServiceWithParameters(ServiceIDs.ACTIVATE_TURN_BASED_ENEMY,_loc5_,false);
         (mActor as EnemyInstallationObject).changeReactionState(EnemyInstallationObject.REACT_STATE_ACTION_COMPLETED);
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
