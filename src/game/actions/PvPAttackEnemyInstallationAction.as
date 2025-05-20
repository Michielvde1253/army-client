package game.actions
{
   import game.characters.AnimationController;
   import game.gameElements.EnemyInstallationObject;
   import game.gui.TextEffect;
   import game.isometric.IsometricScene;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.Renderable;
   import game.items.EnemyInstallationItem;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.PlayerUnitItem;
   import game.missions.MissionManager;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class PvPAttackEnemyInstallationAction extends Action
   {
      
      private static const STATE_BEFORE_ATTACK:int = 0;
      
      private static const STATE_ATTACKING:int = 1;
      
      private static const STATE_ATTACKING_TO_SHIELD:int = 2;
      
      private static const STATE_OVER:int = 3;
       
      
      private var mTimer:int;
      
      private var mState:int;
      
      private var mNewState:int;
      
      public function PvPAttackEnemyInstallationAction(param1:Array, param2:EnemyInstallationObject)
      {
         super("PvPAttackEnemyInstallationAction");
         mCharacterActors = param1;
         mTarget = param2;
         this.mState = -1;
         this.mNewState = -1;
      }
      
      override public function update(param1:int) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:IsometricCharacter = null;
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
               for each(_loc3_ in mCharacterActors)
               {
                  if(_loc3_.getCurrentAnimationFrameLabel() == "end")
                  {
                     _loc2_ = false;
                     break;
                  }
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
         if(mTarget == null || !mTarget.isAlive() || Boolean((mTarget as EnemyInstallationObject).mCurrentAction) || GameState.mInstance.mPvPMatch.mActionsLeft == 0 || !GameState.mInstance.mPvPMatch.mPlayerTurn) // Ducktape fix, player turn shouldn't be checked here.
         {
            skip();
            return;
         }
		 /*
		 Energy and map resources in pvp mode??? Guessing this is not needed.
	 
	 
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
		 */
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
         this.mNewState = STATE_BEFORE_ATTACK;
         setDirection(mTarget.mX,mTarget.getTileSize().x);
      }
      
      private function getCombinedDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:IsometricCharacter = null;
         for each(_loc2_ in mCharacterActors)
         {
            _loc1_ += _loc2_.getPower();
         }
         return _loc1_;
      }
      
      private function execute() : void
      {
         var _loc12_:Item = null;
         var _loc14_:Renderable = null;
         var _loc15_:Action = null;
         var _loc16_:int = 0;
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
         var _loc5_:Boolean = (mTarget as EnemyInstallationObject).getHealth() > 0 && (mTarget as EnemyInstallationObject).getHealth() - _loc4_ <= 0;
         var _loc6_:EnemyInstallationItem;
         var _loc7_:int = (_loc6_ = mTarget.mItem as EnemyInstallationItem).mHitRewardXP;
         var _loc8_:int = _loc6_.mHitRewardMoney;
         var _loc9_:int = _loc6_.mHitRewardSupplies;
         var _loc10_:int = _loc6_.mHitRewardEnergy;
         if(_loc5_)
         {
            _loc7_ += _loc6_.mKillRewardXP;
            _loc8_ += _loc6_.mKillRewardMoney;
            _loc9_ += _loc6_.mKillRewardSupplies;
            _loc10_ += _loc6_.mKillRewardEnergy;
            if(_loc6_.mKillRewardUnit)
            {
               _loc2_.addRewardedPlayerUnit(ItemManager.getItem(_loc6_.mKillRewardUnit.ID,_loc6_.mKillRewardUnit.Type) as PlayerUnitItem,mTarget.getCell());
            }
            for each(_loc14_ in mCharacterActors)
            {
               MissionManager.increaseCounter("KillWith",_loc14_,1);
            }
            if(mCharacterActors)
            {
               if(mCharacterActors.length > 1)
               {
                  MissionManager.increaseCounter("DestroyWithMultiple",mTarget,mCharacterActors.length);
               }
            }
         }
         (mCharacterActors[0] as IsometricCharacter).addTextEffect(TextEffect.TYPE_LOSS,"-1",ItemManager.getItem("Energy","Resource"));
         _loc3_.increaseEnergyRewardCounter(_loc10_);
         var _loc11_:int = _loc3_.getBonusEnergy();
         _loc2_.addLootReward(ItemManager.getItem("XP","Resource"),_loc7_,mTarget.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Money","Resource"),_loc8_,mTarget.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc9_,mTarget.getContainer());
         _loc2_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc11_,mTarget.getContainer());
         var _loc13_:int = _loc3_.mRewardDropsCounter;
         if(_loc5_)
         {
            _loc12_ = _loc6_.getRandomItemDrop();
            _loc2_.addLootReward(_loc12_,1,mTarget.getContainer());
         }
         (mTarget as EnemyInstallationObject).reduceHealth(_loc4_);
         (mTarget as EnemyInstallationObject).resetReactionTimer();
         this.mNewState = STATE_OVER;
         if(mCounterAction)
         {
            _loc1_.queueAction(mCounterAction,true);
         }
         if(mSupportActions)
         {
            _loc16_ = 0;
            while(_loc16_ < mSupportActions.length)
            {
               _loc1_.queueAction(_loc15_,true);
               _loc16_++;
            }
         }
         _loc1_.playerMoveMade();
      }
   }
}
