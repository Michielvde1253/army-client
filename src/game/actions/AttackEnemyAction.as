package game.actions
{
   import game.characters.AnimationController;
   import game.characters.EnemyUnit;
   import game.gameElements.PlayerInstallationObject;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.Renderable;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.TargetItem;
   import game.magicBox.MagicBoxTracker;
   import game.missions.MissionManager;
   import game.net.MyServer;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   import game.utils.EffectController;
   
   public class AttackEnemyAction extends Action
   {
      
      protected static const STATE_BEFORE_ATTACK:int = 0;
      
      protected static const STATE_ATTACKING:int = 1;
      
      protected static const STATE_OVER:int = 2;
       
      
      private var mAttackDuration:int;
      
      private var mTimer:int;
      
      protected var mState:int;
      
      protected var mNewState:int;
      
      private var mEnableSupportsForEnemy:Boolean;
      
      public function AttackEnemyAction(param1:Array, param2:PlayerInstallationObject, param3:IsometricCharacter, param4:Boolean = true)
      {
         super("AttackEnemy");
         mCharacterActors = param1;
         mActor = param2;
         mTarget = param3;
         this.mState = -1;
         this.mNewState = -1;
         this.mEnableSupportsForEnemy = param4;
      }
      
      override public function update(param1:int) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:IsometricCharacter = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
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
            case STATE_BEFORE_ATTACK:
               if(this.mTimer >= Renderable.GENERIC_ACTION_DELAY_TIME)
               {
                  this.mNewState = STATE_ATTACKING;
               }
               break;
            case STATE_ATTACKING:
               if(mCharacterActors)
               {
                  _loc2_ = true;
                  _loc4_ = int(mCharacterActors.length);
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_)
                  {
                     _loc3_ = mCharacterActors[_loc5_] as IsometricCharacter;
                     if(_loc3_.getCurrentAnimationFrameLabel() == "end")
                     {
                        _loc2_ = false;
                        break;
                     }
                     _loc5_++;
                  }
                  if(!_loc2_)
                  {
                     this.execute();
                  }
               }
               if(mActor)
               {
                  if(this.mTimer > this.mAttackDuration)
                  {
                     this.execute();
                  }
               }
         }
      }
      
      private function changeState(param1:int) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:IsometricCharacter = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         this.mTimer = 0;
         this.mState = param1;
         this.mNewState = param1;
         var _loc2_:int = 0;
         if(mCharacterActors)
         {
            _loc3_ = false;
            _loc4_ = false;
            _loc6_ = int(mCharacterActors.length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc5_ = mCharacterActors[_loc7_] as IsometricCharacter;
               switch(this.mState)
               {
                  case STATE_BEFORE_ATTACK:
                     this.mNewState = STATE_ATTACKING;
                     break;
                  case STATE_ATTACKING:
                     _loc2_++;
                     _loc5_.shootTo(mTarget.mX,mTarget.mY);
                     mTarget.setAnimationAction(AnimationController.CHARACTER_ANIMATION_HIT,false,true);
                     mTarget.showActingHealthBar();
                     _loc8_ = _loc5_.getShootingEffect();
                     if(!_loc4_ && _loc8_ == EffectController.EFFECT_TYPE_HIT_BULLET)
                     {
                        _loc4_ = true;
                        GameState.mInstance.mScene.addEffect(null,_loc8_,mTarget.mX,mTarget.mY);
                     }
                     else if(!_loc3_ && _loc8_ == EffectController.EFFECT_TYPE_HIT_EXPLOSION)
                     {
                        _loc3_ = true;
                        GameState.mInstance.mScene.addEffect(null,_loc8_,mTarget.mX,mTarget.mY);
                     }
                     break;
                  case STATE_OVER:
                     if(mTarget)
                     {
                        if(mTarget.isAlive())
                        {
                           if(!(mTarget as EnemyUnit).mCurrentAction)
                           {
                              mTarget.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                           }
                        }
                     }
                     if(_loc5_.isAlive())
                     {
                        _loc5_.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                     }
                     break;
               }
               _loc7_++;
            }
            if(this.mState == STATE_ATTACKING)
            {
               playAttackSoundsForAttackers();
            }
         }
         if(mActor)
         {
            switch(this.mState)
            {
               case STATE_BEFORE_ATTACK:
                  this.mNewState = STATE_ATTACKING;
                  break;
               case STATE_ATTACKING:
                  _loc2_++;
                  mActor.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_SHOOT,false,true);
                  mTarget.setAnimationAction(AnimationController.CHARACTER_ANIMATION_HIT,false,true);
                  mTarget.showActingHealthBar();
                  if(mActor.mName == "Sniper Nest" || mActor.mName == "Watch Tower")
                  {
                     GameState.mInstance.mScene.addEffect(null,EffectController.EFFECT_TYPE_HIT_BULLET,mTarget.mX,mTarget.mY);
                  }
                  else
                  {
                     GameState.mInstance.mScene.addEffect(null,EffectController.EFFECT_TYPE_HIT_EXPLOSION,mTarget.mX,mTarget.mY);
                  }
                  Renderable(mActor).playCollectionSound(Renderable(mActor).mAttackSounds);
                  this.mAttackDuration = GameState.mConfig.GraphicSetup.Shooting.Length;
                  break;
               case STATE_OVER:
                  if(mTarget)
                  {
                     if(mTarget.isAlive())
                     {
                        if(!(mTarget as EnemyUnit).mCurrentAction)
                        {
                           mTarget.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                        }
                     }
                  }
                  if(mActor.isAlive())
                  {
                     mActor.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_IDLE,true,false);
                  }
            }
         }
      }
      
      override public function isOver() : Boolean
      {
         return this.mState == STATE_OVER || mSkipped;
      }
      
      override public function start() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         if(mSkipped)
         {
            return;
         }
         if(mTarget == null || !mTarget.isAlive() || Boolean((mTarget as EnemyUnit).mCurrentAction))
         {
            skip();
            return;
         }
         if(mActor)
         {
            if(!mActor.isAlive() || !(mActor as PlayerInstallationObject).canAttack())
            {
               skip();
               return;
            }
         }
         else if(mCharacterActors)
         {
            mCharacterActors = GameState.mInstance.searchAttackablePlayerUnits(mTarget as EnemyUnit);
            if(GameState.mInstance.mPlayerProfile.mEnergy <= 0)
            {
               GameState.mInstance.mHUD.openOutOfEnergyWindow();
               skip();
               return;
            }
            if(!GameState.mInstance.mPlayerProfile.hasEnoughMapResource(1))
            {
               GameState.mInstance.mHUD.openOutOfMapResourceWindow();
               skip();
               return;
            }
            _loc1_ = false;
            _loc2_ = 0;
            while(_loc2_ < mCharacterActors.length)
            {
               if((mCharacterActors[_loc2_] as IsometricCharacter).isAlive())
               {
                  _loc1_ = true;
               }
               else
               {
                  mCharacterActors.splice(_loc2_,1);
                  _loc2_--;
               }
               _loc2_++;
            }
            if(!_loc1_ || mCharacterActors.length == 0)
            {
               skip();
               return;
            }
            if(mCharacterActors.length == 1 && this.getCombinedDamage() < (mTarget as EnemyUnit).getHealth())
            {
               ++smSingleAttacksCount;
               if(smSingleAttacksCount >= 3)
               {
                  if(GameState.mInstance.mHUD.openSingleAttackWarningWindow())
                  {
                     skip();
                     return;
                  }
               }
            }
            else
            {
               smSingleAttacksCount = 0;
            }
         }
         setDirection(mTarget.mX);
         this.mNewState = STATE_BEFORE_ATTACK;
      }
      
      protected function getCombinedDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:IsometricCharacter = null;
         for each(_loc2_ in mCharacterActors)
         {
            _loc1_ += _loc2_.getPower();
         }
         if(mActor)
         {
            _loc1_ += (mActor as PlayerInstallationObject).getPower();
         }
         return _loc1_;
      }
      
      protected function execute() : void
      {
         var _loc11_:Item = null;
         var _loc15_:Boolean = false;
         var _loc18_:Renderable = null;
         var _loc19_:Action = null;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         if(!mTarget || !mTarget.isAlive())
         {
            Utils.LogError("AttackEnemyAction: Enemy not found");
            this.mNewState = STATE_OVER;
            return;
         }
         if(this.mState != STATE_ATTACKING)
         {
            Utils.LogError("AttackEnemyAction: Illegal state");
            this.mNewState = STATE_OVER;
            return;
         }
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:IsometricScene = _loc1_.mScene;
         var _loc3_:GamePlayerProfile = _loc1_.mPlayerProfile;
         var _loc4_:IsometricCharacter;
         var _loc5_:Boolean = (_loc4_ = mTarget as IsometricCharacter).getHealth() > 0 && _loc4_.getHealth() - this.getCombinedDamage() <= 0;
         var _loc6_:int = _loc4_.mHitRewardXP;
         var _loc7_:int = _loc4_.mHitRewardMoney;
         var _loc8_:int = _loc4_.mHitRewardSupplies;
         var _loc9_:int = _loc4_.mHitRewardEnergy;
         if(_loc5_)
         {
            _loc6_ += _loc4_.mKillRewardXP;
            _loc7_ += _loc4_.mKillRewardMoney;
            _loc8_ += _loc4_.mKillRewardSupplies;
            _loc9_ += _loc4_.mKillRewardEnergy;
            for each(_loc18_ in mCharacterActors)
            {
               MissionManager.increaseCounter("KillWith",_loc18_,1);
            }
            if(mActor)
            {
               MissionManager.increaseCounter("KillWith",mActor,1);
            }
            if(mCharacterActors)
            {
               if(mCharacterActors.length > 1)
               {
                  MissionManager.increaseCounter("DestroyWithMultiple",mTarget,mCharacterActors.length);
               }
            }
         }
         if(mCharacterActors)
         {
            (mCharacterActors[0] as IsometricCharacter).addTextEffect(TextEffect.TYPE_LOSS,"-1",ItemManager.getItem("Energy","Resource"));
         }
         _loc3_.increaseEnergyRewardCounter(_loc9_);
         var _loc10_:int = _loc3_.getBonusEnergy();
         _loc2_.addLootReward(ItemManager.getItem("XP","Resource"),_loc6_,mTarget.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc7_,mTarget.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc8_,mTarget.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc10_,mTarget.getContainer());
         var _loc12_:int = _loc3_.mRewardDropsCounter;
         if(_loc5_)
         {
            _loc11_ = (_loc4_.mItem as TargetItem).getRandomItemDrop();
            _loc2_.addLootReward(_loc11_,1,mTarget.getContainer());
         }
         var _loc13_:int = this.getCombinedDamage();
         var _loc14_:int = 1;
         if(!mActor && Boolean(mCharacterActors))
         {
            _loc15_ = false;
            _loc1_.reduceEnergy(mName,_loc14_,MagicBoxTracker.paramsObj((_loc4_ as EnemyUnit).mItem.mType,(_loc4_ as EnemyUnit).mItem.mId,_loc13_.toString()));
            _loc1_.reduceMapResource(_loc14_);
         }
         else
         {
            _loc15_ = true;
            _loc14_ = 0;
         }
         _loc4_.reduceHealth(_loc13_);
         (_loc4_ as EnemyUnit).changeReactionState(EnemyUnit.REACT_STATE_WAIT_FOR_TIMER);
         this.mNewState = STATE_OVER;
         var _loc16_:GridCell = mTarget.getCell();
         var _loc17_:Object = {
            "coord_x":_loc16_.mPosI,
            "coord_y":_loc16_.mPosJ,
            "item_hit_points":_loc13_,
            "cost_energy":_loc14_,
            "reward_xp":_loc6_,
            "reward_money":_loc7_,
            "reward_supplies":_loc8_,
            "reward_energy":_loc9_,
            "attacker_is_building":_loc15_
         };
         if(_loc1_.mMapData.mMapSetupData.Resource)
         {
            _loc17_[MyServer.MAP_RESOURCE_COST_NAMES[_loc1_.mMapData.mMapSetupData.Resource]] = _loc14_;
         }
         if(_loc5_)
         {
            _loc17_.reward_drop_seed_term = _loc3_.mRewardDropSeedTerm;
            _loc17_.reward_drops_counter = _loc12_;
         }
         if(_loc11_)
         {
            _loc17_.reward_item_type = ItemManager.getTableNameForItem(_loc11_);
            _loc17_.reward_item_id = _loc11_.mId;
         }
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.ATTACK_ENEMY_UNIT,_loc17_,false);
         if(Config.DEBUG_MODE)
         {
         }
         if(mCounterAction)
         {
            _loc1_.queueAction(mCounterAction,true);
         }
         if(mSupportActions)
         {
            _loc20_ = int(mSupportActions.length);
            _loc21_ = 0;
            while(_loc21_ < _loc20_)
            {
               _loc19_ = mSupportActions[_loc21_] as Action;
               _loc1_.queueAction(_loc19_,true);
               _loc21_++;
            }
         }
         if(mCharacterActors)
         {
            _loc1_.playerMoveMade();
         }
      }
   }
}
