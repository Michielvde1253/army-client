package game.gameElements
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import game.actions.Action;
   import game.actions.ActionQueue;
   import game.actions.AttackEnemyAction;
   import game.characters.AnimationController;
   import game.gui.TextEffect;
   import game.gui.TooltipHealth;
   import game.isometric.IsometricScene;
   import game.isometric.elements.StaticObject;
   import game.items.Item;
   import game.items.MapItem;
   import game.items.PlayerInstallationItem;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   import game.utils.EffectController;
   
   public class PlayerInstallationObject extends StaticObject
   {
      
      public static const STATE_IDLE:int = 0;
      
      public static const STATE_BEING_HIT:int = 1;
      
      public static const STATE_WRECKING:int = 2;
      
      public static const STATE_DESTROYED:int = 3;
      
      public static const TYPE_MORTAR_PIT:String = "MortarPit";
       
      
      protected var mState:int;
      
      private var mNewState:int;
      
      public var mAttackRange:int;
      
      public var mPower:int;
      
      protected var mHealth:int;
      
      protected var mMaxHealth:int;
      
      protected var mSightRange:int;
      
      protected var mDestroyedPermanently:Boolean = false;
      
      private var mTextFXTimer:int;
      
      private var mTextFXQueue:Array;
      
      private var mEffectController:EffectController;
      
      public var mCurrentAction:Action;
      
      public var mActionQueue:ActionQueue;
      
      private var mRemainingTimeToNextAction:int;
      
      public function PlayerInstallationObject(param1:int, param2:IsometricScene, param3:MapItem)
      {
         var _loc4_:PlayerInstallationItem = null;
         super(param1,param2,param3);
         _loc4_ = param3 as PlayerInstallationItem;
         this.mActionQueue = new ActionQueue();
         mMovable = true;
         setWalkable(false);
         this.mState = -1;
         this.mNewState = STATE_IDLE;
         this.mTextFXQueue = new Array();
         this.mTextFXTimer = 0;
         mContainer.mouseChildren = false;
         mContainer.mouseEnabled = false;
         mName = _loc4_.mName;
         this.mMaxHealth = _loc4_.mHealth;
         this.mHealth = this.mMaxHealth;
         this.mPower = _loc4_.mDamage;
         this.mSightRange = _loc4_.mSightRange;
         this.mAttackRange = _loc4_.mAttackRange;
         initAnimations(_loc4_.getGraphicAssets());
         mAnimationController.setAnimation(AnimationController.INSTALLATION_ANIMATION_IDLE);
         updateAnimation(true,false);
         this.mEffectController = new EffectController();
         mVisible = true;
         mContainer.visible = true;
      }
      
      override public function setupFromServer(param1:Object) : void
      {
         super.setupFromServer(param1);
         this.mHealth = 0;
         this.setHealth(param1.item_hit_points);
         if(param1.next_action_at != null)
         {
            this.mRemainingTimeToNextAction = param1.next_action_at * 1000;
         }
      }
      
      override public function logicUpdate(param1:int) : Boolean
      {
         var _loc2_:TextEffect = null;
         var _loc3_:MovieClip = null;
         if(this.mState != this.mNewState)
         {
            this.changeState(this.mNewState);
         }
         this.mTextFXTimer -= param1;
         if(this.mTextFXQueue.length > 0)
         {
            if(this.mTextFXTimer <= 0)
            {
               _loc2_ = this.mTextFXQueue[0];
               _loc3_ = _loc2_.getClip();
               _loc3_.scaleX = 1 / mScene.mContainer.scaleX;
               _loc3_.scaleY = _loc3_.scaleX;
               _loc3_.y = 50;
               mContainer.addChild(_loc3_);
               _loc2_.start();
               this.mTextFXQueue.splice(0,1);
               this.mTextFXTimer = 350;
            }
         }
         if(mActionDelayTimer > 0)
         {
            mActionDelayTimer -= param1;
            setLoadingBarPercent(1 - mActionDelayTimer / GENERIC_ACTION_DELAY_TIME);
            if(mActionDelayTimer <= 0)
            {
               hideLoadingBar();
            }
         }
         switch(this.mState)
         {
            case STATE_IDLE:
               if(!getCell().hasFog() && this.mHealth <= this.mMaxHealth >> 1)
               {
                  if(!isLoadingBarVisible())
                  {
                     showHealthWarning(true);
                  }
               }
               else
               {
                  showHealthWarning(false);
               }
               break;
            case STATE_BEING_HIT:
               break;
            case STATE_WRECKING:
               showHealthWarning(true);
               if(this.mEffectController.update(param1))
               {
                  this.mNewState = STATE_DESTROYED;
                  if(this.mDestroyedPermanently)
                  {
                     this.destroy();
                  }
               }
               break;
            case STATE_DESTROYED:
               showHealthWarning(true);
         }
         return false;
      }
      
      private function changeState(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         switch(param1)
         {
            case STATE_IDLE:
               setAnimationAction(AnimationController.INSTALLATION_ANIMATION_IDLE,true,false);
               break;
            case STATE_BEING_HIT:
               break;
            case STATE_WRECKING:
               setAnimationAction(AnimationController.INSTALLATION_ANIMATION_WRECKING,false,true);
               hideActingHealthBar();
               hideLoadingBar();
               _loc2_ = (mTileSize.x - 1) * (mScene.mGridDimX >> 1);
               _loc3_ = (mTileSize.y - 1) * (mScene.mGridDimY >> 1);
               this.mEffectController.startEffect(mScene,mAnimationController.getAnimation(),EffectController.EFFECT_TYPE_BIG_EXPLOSION,mX + _loc2_,mY + _loc3_);
               break;
            case STATE_DESTROYED:
               setAnimationAction(AnimationController.INSTALLATION_ANIMATION_WRECKING,false,true);
               this.resetActions();
         }
         this.mState = param1;
         this.mNewState = this.mState;
         if(FeatureTuner.USE_SOUNDS)
         {
            this.initSounds();
         }
      }
      
      override protected function initSounds() : void
      {
         super.initSounds();
         if(mItem.mId == TYPE_MORTAR_PIT)
         {
            mAttackSounds = ArmySoundManager.SC_FIRE_MISSION_MORTAR;
            mAttackSoundsSecondary = ArmySoundManager.SC_FRN_ATTACK_SECONDARY;
            mDieSounds = ArmySoundManager.SC_ENM_BUILDING_EXPLOSION;
         }
         else
         {
            mAttackSounds = ArmySoundManager.SC_FRN_INF_ATTACK;
            mAttackSoundsSecondary = ArmySoundManager.SC_FRN_ATTACK_SECONDARY;
            mDieSounds = ArmySoundManager.SC_ENM_BUILDING_EXPLOSION;
         }
         mDieSounds.load();
         mAttackSounds.load();
         mAttackSoundsSecondary.load();
      }
      
      public function reduceHealth(param1:int) : void
      {
         if(!this.isAlive())
         {
            return;
         }
         this.setHealth(this.mHealth - param1);
         if(param1 > 0)
         {
            this.addTextEffect(TextEffect.TYPE_LOSS,"-" + param1);
         }
      }
      
      public function getHealth() : int
      {
         return this.mHealth;
      }
      
      public function addHealth(param1:int) : void
      {
         this.setHealth(this.mHealth + param1);
      }
      
      public function setHealth(param1:int) : void
      {
         var _loc4_:IsometricScene = null;
         var _loc2_:int = this.mHealth;
         var _loc3_:int = Math.max(0,Math.min(this.mMaxHealth,param1));
         if(_loc2_ != _loc3_)
         {
            (_loc4_ = GameState.mInstance.mScene).decrementViewersForInstallation(this,this.getSightRangeAccordingToCondition());
            if(_loc3_ > 0)
            {
               if(this.mHealth == 0)
               {
                  this.mNewState = STATE_IDLE;
               }
            }
            else if(this.mHealth == 0)
            {
               this.mNewState = STATE_DESTROYED;
            }
            else
            {
               this.remove();
            }
            this.mHealth = _loc3_;
            _loc4_.incrementViewersForInstallation(this,this.getSightRangeAccordingToCondition());
         }
         else if(_loc2_ == 0)
         {
            if(_loc3_ == 0)
            {
               this.mNewState = STATE_DESTROYED;
            }
         }
      }
      
      public function isFullHealth() : Boolean
      {
         return this.mHealth == this.mMaxHealth;
      }
      
      public function getHealthPercentage() : int
      {
         return 100 * (this.mHealth / this.mMaxHealth);
      }
      
      public function getMaxHealth() : int
      {
         return this.mMaxHealth;
      }
      
      override public function isAlive() : Boolean
      {
         return this.mState != STATE_DESTROYED && this.mState != STATE_WRECKING;
      }
      
      public function canAttack() : Boolean
      {
         return this.mPower > 0 && this.mHealth > 0 && this.mState != STATE_DESTROYED;
      }
      
      public function updateActions(param1:int) : void
      {
         if(this.mCurrentAction != null)
         {
            this.mCurrentAction.update(param1);
            if(this.mCurrentAction)
            {
               if(this.mCurrentAction.isOver())
               {
                  this.mCurrentAction = null;
               }
            }
         }
         if(this.mCurrentAction == null)
         {
            if(this.mActionQueue.mActions.length > 0)
            {
               this.mCurrentAction = this.mActionQueue.mActions.shift();
               this.mCurrentAction.start();
            }
         }
      }
      
      public function resetActions() : void
      {
         this.mActionQueue.mActions.length = 0;
         this.mCurrentAction = null;
      }
      
      public function hasAttackActionInQueue() : Boolean
      {
         var _loc1_:Action = null;
         if(this.mCurrentAction is AttackEnemyAction)
         {
            return true;
         }
         var _loc2_:int = int(this.mActionQueue.mActions.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mActionQueue.mActions[_loc3_] as Action;
            if(_loc1_ is AttackEnemyAction)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function addTextEffect(param1:int, param2:String, param3:Item = null) : void
      {
         this.mTextFXQueue.push(new TextEffect(param1,param2,param3));
      }
      
      public function remove() : void
      {
         this.mNewState = STATE_WRECKING;
      }
      
      override public function updateTooltip(param1:int, param2:TooltipHealth) : void
      {
         super.updateTooltip(param1,param2);
         param2.setTitleText(mItem.mName);
         param2.setHealth(this.mHealth,this.mMaxHealth);
         if(!this.isFullHealth() && !GameState.mInstance.visitingFriend())
         {
            param2.setDetailsText(GameState.getText("INSTALLATION_STATUS_DAMAGED"));
         }
         else
         {
            param2.setDetailsText(GameState.getText("BUILDING_STATUS_IDLE_BUILDING"));
         }
      }
      
      public function getPower() : int
      {
         return this.mPower;
      }
      
      public function getSightRangeAccordingToCondition() : int
      {
         return this.mHealth == 0 ? 0 : this.mSightRange;
      }
      
      public function getSightRange() : int
      {
         return this.mSightRange;
      }
      
      override public function MousePressed(param1:MouseEvent) : void
      {
         GameState.mInstance.moveCameraToSeeRenderable(this);
      }
      
      override public function MouseOut(param1:MouseEvent) : void
      {
      }
      
      override public function MouseOver(param1:MouseEvent) : void
      {
      }
      
      public function healToMax() : void
      {
         this.setHealth(this.mMaxHealth);
      }
      
      public function getHealCostSupplies() : int
      {
         return PlayerInstallationItem(mItem).mHealCostSupplies * (this.mMaxHealth - this.mHealth) / this.mMaxHealth;
      }
      
      override public function getMoveCostSupplies() : int
      {
         return (mTileSize.x + 2 * this.mAttackRange) * (mTileSize.y + 2 * this.mAttackRange) * GameState.mConfig.PlayerStartValues.Default.RelocateSupplyCost;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         showHealthWarning(false);
      }
      
      public function destroyPermanently() : void
      {
         this.mState = STATE_DESTROYED;
         this.mDestroyedPermanently = true;
      }
      
      public function getState() : int
      {
         return this.mState;
      }
      
      public function getRemainingTimeToNextAction() : int
      {
         return this.mRemainingTimeToNextAction;
      }
   }
}
