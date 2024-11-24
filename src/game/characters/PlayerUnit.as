package game.characters
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.actions.AcceptHelpTrainPlayerUnitAction;
   import game.actions.Action;
   import game.actions.VisitNeighborTrainPlayerUnitAction;
   import game.battlefield.MapData;
   import game.gui.TextEffect;
   import game.gui.TooltipHealth;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.boundingElements.BoundingCylinder;
   import game.isometric.characters.IsometricCharacter;
   import game.items.MapItem;
   import game.items.PlayerUnitItem;
   import game.items.ShopItem;
   import game.net.ServiceIDs;
   import game.sound.ArmySoundManager;
   import game.sound.SoundCollection;
   import game.states.GameState;
   import game.utils.TimeUtils;
   
   public class PlayerUnit extends IsometricCharacter
   {
      
      public static const TYPE_INFANTRY:String = "Infantry";
      
      public static const TYPE_SPECIALFORCES:String = "SpecialForces";
      
      public static const TYPE_APC:String = "ArmoredCar";
      
      public static const TYPE_BATTLETANK:String = "MainBattleTank";
      
      public static const TYPE_GUNBATTERY:String = "GunBattery";
      
      public static const TYPE_MOBILEROCKET:String = "MobileRocketBattery";
      
      public static const TYPE_PREMIUM_MOBILEROCKET:String = "PremiumMobileRocketBattery";
      
      public static const TYPE_PREMIUM_COMMANDO:String = "PremiumCommando";
      
      public static const TYPE_ELITE_TANK:String = "EliteMainBattleTank";
      
      public static const TYPE_ELITE_INFANTRY:String = "EliteInfantry";
      
      public static const TYPE_WARFLY:String = "Warfly";
	  
      public static const TYPE_SNIPER:String = "Sniper";
	  
      public static const TYPE_ELITE_LANDKREUZER:String = "EliteLandKreuzer";
      
      public static const UNIT_LEVEL_RECRUIT:int = 0;
      
      public static var smLongestAttackRange:int = 1;
      
      public static var smPlayerSelectionAmbiance:Boolean;
      
      public static var smPlayerSelectionAmbianceCollection:SoundCollection;
       
      
      private var mUnitLevel:int;
      
      private var mUnitSightRadius:int;
      
      private var mUnitMovementRadius:int;
      
      private var mUnitPVPMovementRadius:int;
      
      public var mTurnPlayed:Boolean;
      
      private var mMaxDyingTime:Number;
      
      private var mDyingTimer:Number;
      
      private var mSelectSounds:SoundCollection;
      
      private var mSelectLongSounds:SoundCollection;
      
      protected var mDestroyedPermanently:Boolean = false;
      
      public function PlayerUnit(param1:int, param2:IsometricScene, param3:MapItem)
      {
         var _loc4_:PlayerUnitItem = null;
         var _loc5_:Object = null;
         super(param1,param2,param3,null);
         _loc4_ = param3 as PlayerUnitItem;
         this.mUnitLevel = UNIT_LEVEL_RECRUIT;
         mName = _loc4_.mName;
         mHealth = _loc4_.mHealth;
         mMaxHealth = mHealth;
         mPower = _loc4_.mDamage;
         this.mUnitSightRadius = _loc4_.mSightRange;
         mAttackRange = _loc4_.mAttackRange;
         if(mAttackRange > smLongestAttackRange)
         {
            smLongestAttackRange = mAttackRange;
         }
         this.mUnitMovementRadius = _loc4_.mMovementRange;
         this.mUnitPVPMovementRadius = _loc4_.mPVPMovementRange;
         mMaxHealTimeInMinutes = _loc4_.mMaxHealTime;
         var _loc6_:Array = null;
         var _loc7_:int = int((_loc6_ = (param3 as PlayerUnitItem).mPassableGroups).length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc5_ = _loc6_[_loc8_] as Object;
            mMovementFlags |= 1 << MOVER_TYPE_PASSABILITY_OFFSET + MapData.TILE_PASSABILITY_STRING_TO_ID[_loc5_.ID];
            _loc8_++;
         }
         if((param3 as PlayerUnitItem).mMovementType == MOVEMENT_TYPE_STEALTH)
         {
            mMovementFlags |= MOVER_TYPE_STEALTH_FLAG;
         }
         mMovementFlags |= IsometricCharacter.MOVER_TYPE_FRIENDLY_FLAG;
         mWeaponType = _loc4_.mWeaponType;
         if(mWeaponType == null)
         {
            mWeaponType = IsometricCharacter.WEAPON_TYPE_EXPLOSION;
         }
         mBoundingElement = new BoundingCylinder(0,0,50,100,25);
         this.mTurnPlayed = false;
         mSpeed = 300;
         mContainer.mouseEnabled = false;
         mContainer.mouseChildren = false;
         initAnimations(_loc4_.mGraphicsArray);
         this.mMaxDyingTime = GameState.mConfig.PlayerCorpseMarkerExpiryTime.Default.Time * 60000;
         this.updateMovement(0);
         if(FeatureTuner.USE_SOUNDS)
         {
            this.initSounds();
         }
         updateAnimation(false,true);
      }
      
      override protected function initSounds() : void
      {
         super.initSounds();
         this.mSelectSounds = ArmySoundManager.SC_EMPTY;
         this.mSelectLongSounds = ArmySoundManager.SC_EMPTY;
         mAttackSoundsSecondary = ArmySoundManager.SC_ENM_ATTACK_SECONDARY;
         var _loc1_:String = mItem.mId;
         if(_loc1_ == PlayerUnit.TYPE_INFANTRY || _loc1_ == PlayerUnit.TYPE_ELITE_INFANTRY || _loc1_ == PlayerUnit.TYPE_SNIPER)
         {
            mMoveSounds = ArmySoundManager.SC_GENERAL_INFANTRY_MOVING;
            this.mSelectSounds = ArmySoundManager.SC_FRN_INF_SELECT_SHORT;
            this.mSelectLongSounds = ArmySoundManager.SC_FRN_INF_SELECT_LONG;
            if(GameState.mInstance.mState == GameState.STATE_PVP)
            {
               mDieSounds = ArmySoundManager.SC_ENM_INF_DEATH;
            }
            else
            {
               mDieSounds = ArmySoundManager.SC_FRN_INF_DIE;
            }
            mAttackSounds = ArmySoundManager.SC_FRN_INF_ATTACK;
         }
         else if(_loc1_ == PlayerUnit.TYPE_APC)
         {
            this.mSelectSounds = ArmySoundManager.SC_FRN_APC_SELECT_SHORT;
            this.mSelectLongSounds = ArmySoundManager.SC_FRN_APC_SELECT_LONG;
            mDieSounds = ArmySoundManager.SC_FRN_APC_DEATH;
            mAttackSounds = ArmySoundManager.SC_FRN_APC_ATTACK;
            mMoveSounds = ArmySoundManager.SC_APC_MOVING;
         }
         else if(_loc1_ == PlayerUnit.TYPE_BATTLETANK || _loc1_ == PlayerUnit.TYPE_ELITE_TANK || _loc1_ == PlayerUnit.TYPE_ELITE_LANDKREUZER)
         {
            this.mSelectSounds = ArmySoundManager.SC_FRN_TANK_SELECT_SHORT;
            this.mSelectLongSounds = ArmySoundManager.SC_FRN_TANK_SELECT_LONG;
            mDieSounds = ArmySoundManager.SC_FRN_TANK_DEATH;
            mAttackSounds = ArmySoundManager.SC_FRN_TANK_ATTACK;
            mMoveSounds = ArmySoundManager.SC_TANK_MOVING;
         }
         else if(_loc1_ == PlayerUnit.TYPE_GUNBATTERY)
         {
            this.mSelectSounds = ArmySoundManager.SC_FRN_ARTILLERY_SELECT_SHORT;
            this.mSelectLongSounds = ArmySoundManager.SC_FRN_ARTILLERY_SELECT_LONG;
            mDieSounds = ArmySoundManager.SC_FRN_ARTILLERY_DEATH;
            mAttackSounds = ArmySoundManager.SC_FRN_ARTILLERY_ATTACK;
            mMoveSounds = ArmySoundManager.SC_ARTILLERY_MOVING;
         }
         else if(_loc1_ == PlayerUnit.TYPE_MOBILEROCKET || _loc1_ == PlayerUnit.TYPE_PREMIUM_MOBILEROCKET)
         {
            this.mSelectSounds = ArmySoundManager.SC_ROCKET_SELECT_SHORT;
            this.mSelectLongSounds = ArmySoundManager.SC_ROCKET_SELECT_LONG;
            mDieSounds = ArmySoundManager.SC_ROCKET_DEATH;
            mAttackSounds = ArmySoundManager.SC_ROCKET_ATTACK;
            mMoveSounds = ArmySoundManager.SC_ROCKET_MOVING;
         }
         else
         {
            mMoveSounds = ArmySoundManager.SC_GENERAL_INFANTRY_MOVING;
            this.mSelectSounds = ArmySoundManager.SC_FRN_COMMANDO_SELECT_SHORT;
            this.mSelectLongSounds = ArmySoundManager.SC_FRN_COMMANDO_SELECT_LONG;
            mDieSounds = ArmySoundManager.SC_FRN_COMMANDO_DEATH;
            mAttackSounds = ArmySoundManager.SC_FRN_COMMANDO_ATTACK;
         }
         this.mSelectSounds.load();
         this.mSelectLongSounds.load();
         mDieSounds.load();
         mAttackSounds.load();
         mAttackSoundsSecondary.load();
         mMoveSounds.load();
      }
      
      override public function updateMovement(param1:int) : void
      {
         super.updateMovement(param1);
      }
      
      override public function startAction() : void
      {
         super.startAction();
      }
      
      override public function stopAction() : void
      {
         super.stopAction();
         resetActions();
      }
      
      override public function reduceHealth(param1:int, param2:int = 0) : void
      {
         super.reduceHealth(param1,param2);
      }
      
      override public function addXP(param1:String, param2:int = 0) : void
      {
         var _loc3_:int = param2;
         addTextEffect(TextEffect.TYPE_GAIN,"+" + _loc3_ + " XP");
      }
      
      public function getMovementRadius() : int
      {
         if(GameState.mInstance.mState == GameState.STATE_PVP)
         {
            return this.mUnitPVPMovementRadius;
         }
         return this.mUnitMovementRadius;
      }
      
      public function getSightRadius() : int
      {
         return this.mUnitSightRadius;
      }
      
      override public function setupFromServer(param1:Object) : void
      {
         super.setupFromServer(param1);
         if(mHealth < mMaxHealth)
         {
            if(mMaxHealTimeInMinutes > 0)
            {
               if(param1.healed_secs_ago != null)
               {
                  mHealingTimer = param1.healed_secs_ago;
               }
            }
         }
         if(mHealth == 0)
         {
            this.die();
         }
         if(param1.next_action_at != null)
         {
            this.mDyingTimer = param1.next_action_at * 1000;
         }
      }
      
      override public function die() : void
      {
         super.die();
         if(GameState.mInstance.mState == GameState.STATE_PVP)
         {
            setAnimationAction(AnimationController.CHARACTER_ANIMATION_EXPLOSION,false,true);
            if(GameState.mInstance.mDieSoundsEnabled)
            {
               ArmySoundManager.getInstance().playSound(mDieSounds.getSound());
            }
         }
         this.mDyingTimer = this.mMaxDyingTime;
      }
      
      public function destroyPermanently() : void
      {
         this.mDestroyedPermanently = true;
      }
      
      override public function updateDying(param1:int) : void
      {
         var _loc2_:GridCell = null;
         var _loc3_:Object = null;
         if(GameState.mInstance.mState == GameState.STATE_PVP)
         {
            super.updateDying(param1);
         }
         else if(!GameState.mInstance.visitingFriend() && (mItem as ShopItem).mCostPremium == 0)
         {
            this.mDyingTimer -= param1;
            if(this.mDyingTimer <= 0 || this.mDestroyedPermanently)
            {
               this.mDyingTimer = 0;
               mState = STATE_KILLED;
               _loc2_ = getCell();
               _loc3_ = {
                  "coord_x":_loc2_.mPosI,
                  "coord_y":_loc2_.mPosJ
               };
               GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.REMOVE_EXPIRED_UNIT,_loc3_,false);
               if(Config.DEBUG_MODE)
               {
               }
            }
         }
         if(isLoadingBarVisible())
         {
            if(mActionDelayTimer > 0)
            {
               mActionDelayTimer -= param1;
               setLoadingBarPercent(1 - mActionDelayTimer / GENERIC_ACTION_DELAY_TIME);
               if(mActionDelayTimer <= 0)
               {
                  hideLoadingBar();
               }
            }
         }
      }
      
      override public function updateTooltip(param1:int, param2:TooltipHealth) : void
      {
         var _loc3_:String = null;
         super.updateTooltip(param1,param2);
         if(GameState.mInstance.visitingFriend())
         {
            if(mHealth == mMaxHealth)
            {
               param2.setDetailsText(GameState.getText("MOUSEOVER_PLAYER_UNIT_VISITING"));
            }
            else
            {
               param2.setDetailsText(GameState.getText("MOUSEOVER_PLAYER_UNIT_HEAL_VISITING"));
            }
         }
         else if(mState == STATE_DYING)
         {
            if((mItem as ShopItem).mCostPremium == 0)
            {
               _loc3_ = GameState.getText("MOUSEOVER_CORPSE_MARKER",[TimeUtils.milliSecondsToString(this.mDyingTimer,1)]);
            }
            else
            {
               _loc3_ = GameState.getText("MOUSEOVER_ELITE_CORPSE_MARKER");
            }
            param2.setDetailsText(_loc3_);
         }
      }
      
      public function healToMax() : void
      {
         setHealth(mMaxHealth);
      }
      
      public function getHealCostSupplies() : int
      {
         return PlayerUnitItem(mItem).mHealCostSupplies * (mMaxHealth - mHealth) / mMaxHealth;
      }
      
      override public function update(param1:int) : void
      {
         super.update(param1);
         if(mState == STATE_TRAINING)
         {
            if(mActionDelayTimer <= 0)
            {
               mState = STATE_WALKING;
            }
         }
      }
      
      override public function MousePressed(param1:MouseEvent) : void
      {
         var _loc2_:GameState = GameState.mInstance;
         if(_loc2_.mState == GameState.STATE_VISITING_NEIGHBOUR)
         {
            _loc2_.moveCameraToSeeRenderable(this);
            if(!mInQueueForAction)
            {
               if(mNeighborActionAvailable)
               {
                  if(mState != STATE_TRAINING)
                  {
                     mInQueueForAction = true;
                     _loc2_.queueAction(new VisitNeighborTrainPlayerUnitAction(this));
                  }
               }
            }
         }
      }
      
      override public function neighborClicked(param1:String) : Action
      {
         var _loc2_:Action = null;
         if(!mInQueueForAction)
         {
            if(mState == STATE_WALKING || mState == STATE_DYING || mState == STATE_KILLED)
            {
               mInQueueForAction = true;
               _loc2_ = new AcceptHelpTrainPlayerUnitAction(this,param1);
            }
         }
         return _loc2_;
      }
      
      public function startTraining() : void
      {
         mState = STATE_TRAINING;
         mInQueueForAction = false;
         showLoadingBar();
         spendNeighborAction();
      }
      
      public function skipTraining() : void
      {
         if(Config.DEBUG_MODE)
         {
         }
         if(mHealth <= 0)
         {
            mState = STATE_DYING;
         }
         else
         {
            mState = STATE_WALKING;
         }
         mInQueueForAction = false;
         mActionDelayTimer = 0;
         hideLoadingBar();
      }
      
      public function isTrainingOver() : Boolean
      {
         return mState != STATE_TRAINING;
      }
      
      public function handleTraining() : void
      {
         setHealth(Math.min(mHealth + 1,mMaxHealth));
      }
      
      public function playSelectionSound() : void
      {
         if(!smPlayerSelectionAmbiance)
         {
            smPlayerSelectionAmbiance = true;
            playCollectionSound(this.mSelectLongSounds,this.ambiencePlayed,this.ambiencePlayed);
            smPlayerSelectionAmbianceCollection = this.mSelectLongSounds;
         }
         else
         {
            playCollectionSound(this.mSelectSounds);
         }
      }
      
      private function ambiencePlayed(param1:Event) : void
      {
         param1.target.removeEventListener(Event.SOUND_COMPLETE,this.ambiencePlayed);
         smPlayerSelectionAmbiance = false;
      }
      
      override public function setSelected() : void
      {
         this.playSelectionSound();
      }
      
      override public function setAnimationDirection(param1:int) : void
      {
         if(!mAnimationController)
         {
            return;
         }
         if(mAnimationController.getCurrentAnimationIndex() == AnimationController.CHARACTER_ANIMATION_IDLE || mAnimationController.getCurrentAnimationIndex() == AnimationController.CHARACTER_ANIMATION_AIM)
         {
            mAnimationController.setDirection(param1);
         }
      }
      
      override protected function updateHintHealth() : void
      {
         super.updateHintHealth();
      }
      
      override public function showHealthWarning(param1:Boolean) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         if(!mAnimationController)
         {
            return;
         }
         var _loc2_:MovieClip = mAnimationController.getCurrentAnimation();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.numChildren)
         {
            if(_loc5_ = (_loc4_ = _loc2_.getChildAt(_loc3_) as MovieClip).getChildByName("Hint_Health_Friendly") as MovieClip)
            {
               if(param1 == _loc5_.visible)
               {
                  _loc5_.visible = !param1;
               }
            }
            if(_loc5_ = (_loc4_ = _loc2_.getChildAt(_loc3_) as MovieClip).getChildByName("Hint_Health_Friendly_Attention") as MovieClip)
            {
               if(param1 != _loc5_.visible)
               {
                  _loc5_.visible = param1;
               }
            }
            _loc3_++;
         }
      }
      
      public function getDyingTimer() : Number
      {
         return this.mDyingTimer;
      }
      
      public function getUnitLevel() : int
      {
         return this.mUnitLevel;
      }
      
      public function getUnitId() : String
      {
         return PlayerUnitItem(mItem).mId;
      }
   }
}
