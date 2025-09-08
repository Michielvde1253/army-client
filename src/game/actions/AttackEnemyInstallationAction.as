package game.actions
{
   import game.characters.AnimationController;
   import game.gameElements.EnemyInstallationObject;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.Renderable;
   import game.items.EnemyInstallationItem;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.PlayerUnitItem;
   import game.magicBox.MagicBoxTracker;
   import game.missions.MissionManager;
   import game.net.MyServer;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class AttackEnemyInstallationAction extends Action
   {
      
      private static const STATE_BEFORE_ATTACK:int = 0;
      
      private static const STATE_ATTACKING:int = 1;
      
      private static const STATE_ATTACKING_TO_SHIELD:int = 2;
      
      private static const STATE_OVER:int = 3;
       
      
      private var mTimer:int;
      
      private var mState:int;
      
      private var mNewState:int;
      
      public function AttackEnemyInstallationAction(param1:Array, param2:EnemyInstallationObject)
      {
         super("AttackEnemyInstallationAction");
         mCharacterActors = param1;
         mTarget = param2;
         this.mState = -1;
         this.mNewState = -1;
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
         switch(this.mState)
         {
            case STATE_BEFORE_ATTACK:
               this.mTimer += param1;
               if(this.mTimer >= Renderable.GENERIC_ACTION_DELAY_TIME)
               {
                  this.mNewState = STATE_ATTACKING;
               }
               break;
            case STATE_ATTACKING:
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
               break;
            case STATE_ATTACKING_TO_SHIELD:
               this.mTimer += param1;
               if(this.mTimer >= GameState.mConfig.GraphicSetup.Forcefield_hit.Length)
               {
                  this.mNewState = STATE_OVER;
               }
         }
      }
      
      private function changeState(param1:int) : void
      {
         var _loc3_:IsometricCharacter = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:IsometricCharacter = null;
         this.mTimer = 0;
         this.mState = param1;
         this.mNewState = param1;
         var _loc2_:IsometricScene = GameState.mInstance.mScene;
         switch(this.mState)
         {
            case STATE_BEFORE_ATTACK:
               this.mNewState = STATE_ATTACKING;
               break;
            case STATE_ATTACKING:
               for each(_loc3_ in mCharacterActors)
               {
                  _loc3_.shootTo(mTarget.mX,mTarget.mY + ((mTarget.getTileSize().y - 1) * _loc2_.mGridDimX >> 1));
                  _loc4_ = mTarget.mX;
                  _loc5_ = mTarget.mY;
                  if(mTarget.getTileSize().x > 1)
                  {
                     _loc4_ += Math.random() * ((mTarget.getTileSize().x - 1) * _loc2_.mGridDimX);
                  }
                  if(mTarget.getTileSize().y > 1)
                  {
                     _loc5_ += Math.random() * ((mTarget.getTileSize().y - 1) * _loc2_.mGridDimY);
                  }
                  _loc2_.addEffect(null,_loc3_.getShootingEffect(),_loc4_,_loc5_);
               }
               mTarget.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_HIT,false,true);
               if((mTarget as EnemyInstallationObject).isForceFieldActivated())
               {
                  this.mNewState = STATE_ATTACKING_TO_SHIELD;
               }
               else
               {
                  mTarget.showActingHealthBar();
               }
               break;
            case STATE_OVER:
               if(mTarget)
               {
                  if(mTarget.isAlive())
                  {
                     if(!(mTarget as EnemyInstallationObject).mCurrentAction)
                     {
                        mTarget.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_IDLE,false,true);
                     }
                  }
               }
               for each(_loc6_ in mCharacterActors)
               {
                  if(_loc6_.isAlive())
                  {
                     _loc6_.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                  }
               }
         }
         if(this.mState == STATE_ATTACKING)
         {
            playAttackSoundsForAttackers();
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
         if(mTarget == null || !mTarget.isAlive() || Boolean((mTarget as EnemyInstallationObject).mCurrentAction))
         {
            skip();
            return;
         }
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
         mCharacterActors = GameState.mInstance.searchAttackablePlayerUnits(mTarget as EnemyInstallationObject);
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
         if(mCharacterActors.length == 1 && this.getCombinedDamage() < (mTarget as EnemyInstallationObject).getHealth())
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
         this.mNewState = STATE_BEFORE_ATTACK;
         setDirection(mTarget.mX,mTarget.getTileSize().x);
      }
      
      private function getCombinedDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:IsometricCharacter = null;
         var _loc3_:int = int(mCharacterActors.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = mCharacterActors[_loc4_] as IsometricCharacter;
            _loc1_ += _loc2_.getPower();
            _loc4_++;
         }
         return _loc1_;
      }
      
      private function execute() : void
      {
         var _loc13_:Item = null;
         var _loc17_:Renderable = null;
         var _loc18_:Action = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
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
         var _loc4_:int = this.getCombinedDamage();
         var _loc5_:EnemyInstallationObject;
         //var _loc6_:Boolean = (_loc5_ = mTarget as EnemyInstallationObject).getHealth() > 0 && _loc5_.getHealth() - _loc4_ <= 0;
		 // Why checking if initial health > 0?
		 var _loc6_:Boolean = (_loc5_ = mTarget as EnemyInstallationObject).getHealth() - _loc4_ <= 0;
         var _loc7_:EnemyInstallationItem;
         var _loc8_:int = (_loc7_ = _loc5_.mItem as EnemyInstallationItem).mHitRewardXP;
         var _loc9_:int = _loc7_.mHitRewardMoney;
         var _loc10_:int = _loc7_.mHitRewardSupplies;
         var _loc11_:int = _loc7_.mHitRewardEnergy;
         if(_loc6_)
         {
            _loc8_ += _loc7_.mKillRewardXP;
            _loc9_ += _loc7_.mKillRewardMoney;
            _loc10_ += _loc7_.mKillRewardSupplies;
            _loc11_ += _loc7_.mKillRewardEnergy;
			trace("Destroyed")
			trace(_loc7_.mKillRewardUnit);
            if(_loc7_.mKillRewardUnit)
            {
               _loc2_.addRewardedPlayerUnit(ItemManager.getItem(_loc7_.mKillRewardUnit.ID,_loc7_.mKillRewardUnit.Type) as PlayerUnitItem,_loc5_.getCell());
            }
            for each(_loc17_ in mCharacterActors)
            {
               MissionManager.increaseCounter("KillWith",_loc17_,1);
            }
            if(mCharacterActors)
            {
               if(mCharacterActors.length > 1)
               {
                  MissionManager.increaseCounter("DestroyWithMultiple",_loc5_,mCharacterActors.length);
               }
            }
         }
         (mCharacterActors[0] as IsometricCharacter).addTextEffect(TextEffect.TYPE_LOSS,"-1",ItemManager.getItem("Energy","Resource"));
         _loc3_.increaseEnergyRewardCounter(_loc11_);
         var _loc12_:int = _loc3_.getBonusEnergy();
         _loc2_.addLootReward(ItemManager.getItem("XP","Resource"),_loc8_,_loc5_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc9_,_loc5_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc10_,_loc5_.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc12_,_loc5_.getContainer());
         var _loc14_:int = _loc3_.mRewardDropsCounter;
         if(_loc6_)
         {
            _loc13_ = _loc7_.getRandomItemDrop();
            _loc2_.addLootReward(_loc13_,1,_loc5_.getContainer());
         }
         _loc1_.reduceEnergy(mName,1,MagicBoxTracker.paramsObj(_loc5_.mItem.mType,_loc5_.mItem.mId,_loc4_.toString()));
         _loc1_.reduceMapResource(1);
         _loc5_.reduceHealth(_loc4_);
         _loc5_.resetReactionTimer();
         this.mNewState = STATE_OVER;
         var _loc15_:GridCell = _loc5_.getCell();
         var _loc16_:Object = {
            "coord_x":_loc15_.mPosI,
            "coord_y":_loc15_.mPosJ,
            "item_hit_points":_loc4_,
            "cost_energy":1,
            "reward_xp":_loc8_,
            "reward_money":_loc9_,
            "reward_supplies":_loc10_,
            "reward_energy":_loc11_
         };
         if(_loc1_.mMapData.mMapSetupData.Resource)
         {
            _loc16_[MyServer.MAP_RESOURCE_COST_NAMES[_loc1_.mMapData.mMapSetupData.Resource]] = 1;
         }
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
         if(_loc6_ && _loc5_.mLastAttackDamage > 0)
         {
            GameState.mInstance.queueAction(new LastAttackAction(_loc5_,ServiceIDs.ATTACK_ENEMY_INSTALLATION,_loc16_),true);
            if(Config.DEBUG_MODE)
            {
            }
         }
         else
         {
            GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.ATTACK_ENEMY_INSTALLATION,_loc16_,false);
            if(Config.DEBUG_MODE)
            {
            }
         }
         if(mCounterAction)
         {
            _loc1_.queueAction(mCounterAction,true);
         }
         if(mSupportActions)
         {
            _loc19_ = int(mSupportActions.length);
            _loc20_ = 0;
            while(_loc20_ < _loc19_)
            {
               _loc18_ = mSupportActions[_loc20_] as Action;
               _loc1_.queueAction(_loc18_,true);
               _loc20_++;
            }
         }
         _loc1_.playerMoveMade();
      }
   }
}
