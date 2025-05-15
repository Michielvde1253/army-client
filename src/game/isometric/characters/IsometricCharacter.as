package game.isometric.characters {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.geom.Point;
	import game.battlefield.MapData;
	import game.characters.AnimationController;
	import game.characters.EnemyUnit;
	import game.characters.PlayerUnit;
	import game.gameElements.ArtilleryRound;
	import game.gameElements.Missile;
	import game.gameElements.Projectile;
	import game.gui.TextEffect;
	import game.gui.TooltipHealth;
	import game.isometric.GridCell;
	import game.isometric.IsometricScene;
	import game.isometric.SceneLoader;
	import game.isometric.elements.DynamicObject;
	import game.isometric.elements.Element;
	import game.isometric.pathfinding.AStarPathfinder;
	import game.items.BoosterItem;
	import game.items.EnemyUnitItem;
	import game.items.Item;
	import game.items.MapItem;
	import game.items.PlayerUnitItem;
	import game.missions.MissionManager;
	import game.states.GameState;
	import game.utils.EffectController;

	public class IsometricCharacter extends DynamicObject {

		public static const STATE_WALKING: int = 0;

		public static const STATE_DYING: int = 1;

		public static const STATE_KILLED: int = 2;

		public static const STATE_SUPPRESS: int = 3;

		public static const STATE_TRAINING: int = 4;

		public static const STATE_AIR_DROP: int = 5;

		public static const HIT_BY_WEAPON: int = 0;

		public static const HIT_BY_EXPLOSION: int = 1;

		public static const MOVER_TYPE_FRIENDLY_FLAG: Number = 1 << 0;

		public static const MOVER_TYPE_STEALTH_FLAG: Number = 1 << 1;

		public static const MOVER_TYPE_PASSABILITY_OFFSET: Number = 2;

		public static const MOVEMENT_TYPE_STEALTH: String = "stealth";

		public static const WEAPON_TYPE_BULLET: String = "bullet";

		public static const WEAPON_TYPE_EXPLOSION: String = "explosion";


		protected var mWalkingPath: Array;

		protected var mSpeed: Number;

		protected var mDirX: Number;

		protected var mDirY: Number;

		public var mPower: int;

		public var mHealth: Number;

		protected var mMaxHealTimeInMinutes: int;

		protected var mHealingTimer: int;

		public var mState: int;

		public var mAttackRange: int;

		public var mHitRewardXP: int;

		public var mHitRewardMoney: int;

		public var mHitRewardMaterial: int;

		public var mHitRewardSupplies: int;

		public var mHitRewardEnergy: int;

		public var mKillRewardXP: int;

		public var mKillRewardMoney: int;

		public var mKillRewardMaterial: int;

		public var mKillRewardSupplies: int;

		public var mKillRewardEnergy: int;

		public var mMaxHealth: Number;

		private var mAnimationTimer: Number;

		public var mDestinationCell: GridCell;

		protected var mAllowMovement: Boolean;

		protected var mProjectile: Projectile;

		public var mInQueueForAction: Boolean;

		private var mComingFromUnderClouds: Boolean;

		private var mUpdateHintHealth: Boolean;

		private var mSafetyTimer: int;

		private var mBooster: BoosterItem;

		public var mPreviousTile: GridCell;

		public var mMovementFlags: int = 0;

		public var mWeaponType: String;

		private var mTextFXTimer: int;

		private var mTextFXQueue: Array;

		private var hint_health_child: int = -1;

		public function IsometricCharacter(param1: int, param2: IsometricScene, param3: MapItem, param4: String = null) {
			this.mWalkingPath = new Array();
			super(param1, param2, param3, param4);
			this.mState = STATE_WALKING;
			this.mTextFXQueue = new Array();
			this.mTextFXTimer = 0;
			this.mAnimationTimer = 0;
			this.mAllowMovement = true;
			this.mHealingTimer = 0;
			this.mMaxHealTimeInMinutes = 0;
			this.mAttackRange = 1;
			mRotatable = true;
			this.mInQueueForAction = false;
		}

		public function isStealth(): Boolean {
			return (this.mMovementFlags & MOVER_TYPE_STEALTH_FLAG) > 0;
		}

		public function allowMovement(param1: Boolean): void {
			this.mAllowMovement = param1;
		}

		public function moveTo(param1: Number, param2: Number): void {
			if (!this.isAlive()) {
				return;
			}
			AStarPathfinder.mOptimizeStraightPaths = false;
			AStarPathfinder.findPathAStar(this.mWalkingPath, mScene, new Point(mX, mY), new Point(param1, param2), this.mMovementFlags);
			AStarPathfinder.mOptimizeStraightPaths = true;
			if (this.mWalkingPath.length > 0) {
				if (param2 < mY) {
					this.setAnimationAction(AnimationController.CHARACTER_ANIMATION_MOVE_UP, false, true);
				} else {
					this.setAnimationAction(AnimationController.CHARACTER_ANIMATION_MOVE, false, true);
				}
				if (param1 < mX) {
					mAnimationController.setDirection(AnimationController.DIR_LEFT);
				} else {
					mAnimationController.setDirection(AnimationController.DIR_RIGHT);
				}
			}
		}

		public function shootTo(param1: Number, param2: Number): void {
			if (!this.isAlive()) {
				return;
			}
			if (isRotatable() && param2 < mY) {
				this.setAnimationAction(AnimationController.CHARACTER_ANIMATION_SHOOT_UP, false, true);
			} else {
				this.setAnimationAction(AnimationController.CHARACTER_ANIMATION_SHOOT, false, true);
			}
			this.addProjectile(param1, param2);
		}

		protected function addProjectile(param1: Number, param2: Number): void {
			var _loc3_: Class = null;
			if (mItem is PlayerUnitItem && PlayerUnitItem(mItem).mProjectileClassStr || mItem is EnemyUnitItem && EnemyUnitItem(mItem).mProjectileClassStr) {
				_loc3_ = this.getProjectileClass(Object(mItem).mProjectileClassStr);
				if (_loc3_) {
					if (this.mProjectile) {
						if (this.mProjectile.parent) {
							this.mProjectile.parent.removeChild(this.mProjectile);
							this.mProjectile = null;
						}
					}
					this.mProjectile = new _loc3_(this, param1, param2);
				}
			}
		}

		private function getProjectileClass(param1: String): Class {
			if (param1 == "ArtilleryRound") {
				return ArtilleryRound;
			}
			if (param1 == "Missile") {
				return Missile;
			}
			return null;
		}

		public function aimTo(param1: Number, param2: Number): void {
			if (!this.isAlive()) {
				return;
			}
			if (getCurrentAnimationIndex() == AnimationController.CHARACTER_ANIMATION_IDLE) {
				if (isRotatable() && param2 < mY) {
					this.setAnimationAction(AnimationController.CHARACTER_ANIMATION_AIM_UP, false, true);
				} else {
					this.setAnimationAction(AnimationController.CHARACTER_ANIMATION_AIM, false, true);
				}
				if (param1 < mX) {
					mAnimationController.setDirection(AnimationController.DIR_LEFT);
				} else {
					mAnimationController.setDirection(AnimationController.DIR_RIGHT);
				}
			}
		}

		public function isShooting(): Boolean {
			if (getCurrentAnimationIndex() == AnimationController.CHARACTER_ANIMATION_SHOOT || getCurrentAnimationIndex() == AnimationController.CHARACTER_ANIMATION_SHOOT_UP) {
				return true;
			}
			return false;
		}

		override public function updateMovement(param1: int): void {
			var _loc10_: GridCell = null;
			super.updateMovement(param1);
			if (this.mWalkingPath == null || this.mWalkingPath.length == 0 || !this.mAllowMovement) {
				if (mHealthWarningVisible) {
					mLowHealthIcon.visible = true;
				}
				if (this.mComingFromUnderClouds) {
					mScene.mFog.mUpdateRequired = true;
					this.mComingFromUnderClouds = false;
				}
				return;
			}
			if (mLowHealthIcon) {
				mLowHealthIcon.visible = false;
			}
			var _loc2_: Number = Number(this.mWalkingPath[this.mWalkingPath.length - 1]);
			var _loc3_: Number = Number(this.mWalkingPath[this.mWalkingPath.length - 2]);
			var _loc4_: Number = _loc3_ - mX;
			var _loc5_: Number = _loc2_ - mY;
			var _loc6_: Number;
			if ((_loc6_ = 1 / Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_)) > 1000) {
				this.mDirX = 0;
				this.mDirY = 0;
			} else {
				this.mDirX = _loc4_ * _loc6_;
				this.mDirY = _loc5_ * _loc6_;
			}
			var _loc7_: Number = this.mSpeed * Math.min(param1, 200) / 1000;
			setPos(mX + _loc7_ * this.mDirX, mY + _loc7_ * this.mDirY, mZ);
			var _loc8_: Number = _loc3_ - mX;
			var _loc9_: Number = _loc2_ - mY;
			if (_loc4_ * _loc8_ + _loc5_ * _loc9_ <= 0 || _loc6_ > 1000) {
				if (this.mWalkingPath.length == 2) {
					setPos(this.mWalkingPath[0], this.mWalkingPath[1], mZ);
				}
				this.mWalkingPath.length -= 2;
			}
			if (this is EnemyUnit) {
				_loc10_ = mScene.getCellAtLocation(mX, mY);
				if (!this.mComingFromUnderClouds) {
					if (!mScene.isInsideVisibleArea(_loc10_)) {
						this.mComingFromUnderClouds = true;
					}
				}
				if (!mVisible && !_loc10_.hasFog()) {
					getContainer().visible = true;
					mVisible = true;
				} else if (mVisible && _loc10_.hasFog()) {
					getContainer().visible = false;
					mVisible = false;
				}
			}
		}

		public function setVisibility(param1: Boolean): void {
			if (mVisible != param1) {
				mVisible = param1;
				getContainer().visible = param1;
			}
		}

		public function getMovementTargetCell(): GridCell {
			if (this.mWalkingPath == null || this.mWalkingPath.length == 0 || !this.mAllowMovement) {
				return null;
			}
			return mScene.getCellAtLocation(this.mWalkingPath[0], this.mWalkingPath[1]);
		}

		public function skipWalkingTask(param1: GridCell): void {
			this.mWalkingPath.length = 0;
			var _loc2_: int = mScene.getCenterPointXAtIJ(param1.mPosI, param1.mPosJ);
			var _loc3_: int = mScene.getCenterPointYAtIJ(param1.mPosI, param1.mPosJ);
			setPos(_loc2_, _loc3_, 0);
			this.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE);
		}

		public function isStill(): Boolean {
			return this.mWalkingPath.length == 0;
		}

		override public function setAnimationAction(param1: int, param2: Boolean = true, param3: Boolean = false): Boolean {
			if (param1 != AnimationController.CHARACTER_ANIMATION_MOVE) {
				if (param1 != AnimationController.CHARACTER_ANIMATION_MOVE_UP) {
					if (!this.isStill()) {
						return false;
					}
				}
			}
			return super.setAnimationAction(param1, param2, param3);
		}

		public function setSpeed(param1: Number): void {
			this.mSpeed = param1;
		}

		public function setHealth(param1: int): void {
			var _loc2_: int = this.mHealth;
			this.mHealth = param1;
			if (_loc2_ != this.mHealth) {
				if (_loc2_ == 0) {
					if (this.mHealth > 0) {
						this.revive();
					}
				}
			} else if (_loc2_ == 0) {
				if (this.mHealth == 0) {
					this.mState = STATE_KILLED;
				}
			}
			this.mUpdateHintHealth = true;
		}

		override protected function updateAnimation(param1: Boolean, param2: Boolean): void {
			super.updateAnimation(param1, param2);
			this.mUpdateHintHealth = true;
		}

		protected function updateHintHealth(): void {
			if (!FeatureTuner.USE_HINT_HEALTH) {
				var _loc2_: MovieClip = mAnimationController.getCurrentAnimation();
				var _loc3_: int = 0;
				var _loc4_: MovieClip = null;
				var _loc5_: MovieClip = null;
				while (_loc3_ < _loc2_.numChildren) {
					_loc4_ = _loc2_.getChildAt(_loc3_) as MovieClip;
					if (_loc5_ = _loc4_.getChildByName("Hint_Health_Friendly") as MovieClip) {
						_loc4_.removeChild(_loc5_);
						break;
					}
					_loc3_++;
				}
				return;
			}


			var _loc4_: MovieClip = null;
			var _loc5_: MovieClip = null;
			var _loc6_: MovieClip = null;
			var _loc7_: MovieClip = null;
			if (!mAnimationController) {
				return;
			}
			this.mUpdateHintHealth = false;
			var _loc2_: MovieClip = mAnimationController.getCurrentAnimation();

			if (this.hint_health_child != -1) {
				_loc4_ = _loc2_.getChildAt(_loc3_) as MovieClip;
				if (_loc5_ = _loc4_.getChildByName("Hint_Health_Friendly") as MovieClip) {

				} else {
					this.hint_health_child = -1;
				}
			}
			if (this.hint_health_child == -1) {
				var _loc3_: int = 0;
				while (_loc3_ < _loc2_.numChildren) {
					_loc4_ = _loc2_.getChildAt(_loc3_) as MovieClip;
					if (_loc5_ = _loc4_.getChildByName("Hint_Health_Friendly") as MovieClip) {
						this.hint_health_child = _loc3_;
						break
					}
					_loc3_++;
				}
			}
			// Hint_Health_Friendly
			// health
			_loc6_ = _loc5_.getChildByName("Hint_Health_Friendly") as MovieClip;
			var textfield_health: TextField = _loc6_.getChildByName("Text_Value") as TextField;
			textfield_health.text = String(this.getHealth()) + "/" + String(this.mMaxHealth)

			// power
			_loc6_ = _loc5_.getChildByName("Badge_Fire_Power") as MovieClip;
			_loc6_.gotoAndStop(this.getPower())
			var textfield_power: TextField = _loc5_.getChildByName("Text_Power_Value") as TextField;
			textfield_power.text = "x" + String(this.getPower());

			// Hint_Health_Friendly_Attention
			if (_loc5_ = _loc4_.getChildByName("Hint_Health_Friendly_Attention") as MovieClip) {
				if (_loc6_ = _loc5_.getChildByName("Hint_Friendly") as MovieClip) {
					// health
					_loc7_ = _loc6_.getChildByName("Hint_Health_Friendly") as MovieClip;
					var textfield_health: TextField = _loc7_.getChildByName("Text_Value") as TextField;
					textfield_health.text = String(this.getHealth()) + "/" + String(this.mMaxHealth)

					// power
					_loc7_ = _loc6_.getChildByName("Badge_Fire_Power") as MovieClip;
					_loc7_.gotoAndStop(this.getPower())
					var textfield_power: TextField = _loc6_.getChildByName("Text_Power_Value") as TextField;
					textfield_power.text = "x" + String(this.getPower());
				}
			}
		}

		public function getHealth(): int {
			return this.mHealth;
		}

		public function getPower(): int {
			return this.mPower;
		}

		public function getAttackRange(): int {
			return this.mAttackRange;
		}

		override public function setupFromServer(param1: Object): void {
			super.setupFromServer(param1);
			this.mHealth = 0;
			this.setHealth(param1.item_hit_points);
		}

		public function reduceHealth(param1: int, param2: int = 0): void {
			if (!this.isAlive()) {
				return;
			}
			this.setHealth(Math.max(0, this.mHealth - param1));
			if (param1 > 0) {
				this.mAnimationTimer = 200;
				this.addTextEffect(TextEffect.TYPE_LOSS, "-" + param1);
			}
			if (this.mHealth <= 0) {
				this.die();
			}
		}

		public function addXP(param1: String, param2: int = 0): void {}

		public function addTextEffect(param1: int, param2: String, param3: Item = null): void {
			if (this.mTextFXQueue.length < 2) {
				this.mTextFXQueue.push(new TextEffect(param1, param2, param3));
			}
		}

		public function die(): void {
			this.setAnimationAction(AnimationController.CHARACTER_ANIMATION_DYING, false, true);
			this.mState = STATE_DYING;
			this.resetActions();
			if (GameState.mInstance.mDieSoundsEnabled) {
				playCollectionSound(mDieSounds);
			}
			this.mSafetyTimer = 0;
			hideLoadingBar();
			if (this is EnemyUnit) {
				if (GameState.mInstance.mState != GameState.STATE_VISITING_NEIGHBOUR) {
					if (GameState.mInstance.mState != GameState.STATE_PVP) {
						MissionManager.increaseCounter("Destroy", this, 1);
						MissionManager.increaseCounter("DestroyTarget", this, 1);
					}
				}
			}
			showHealthWarning(false);
			hideActingHealthBar();
		}

		private function revive(): void {
			this.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE, false, true);
			this.mState = STATE_WALKING;
			this.resetActions();
			mScene.hideObjectTooltip();
		}

		override public function isAlive(): Boolean {
			return this.mState != STATE_KILLED && this.mState != STATE_DYING;
		}

		public function isReadyToBeRemoved(): Boolean {
			return this.mState == STATE_KILLED;
		}

		public function getState(): int {
			return this.mState;
		}

		public function update(param1: int): void {
			var _loc2_: TextEffect = null;
			var _loc3_: MovieClip = null;
			if (this.mUpdateHintHealth) {
				this.updateHintHealth();
			}
			if (this.mState == STATE_DYING) {
				this.updateDying(param1);
				return;
			}
			if (this.mState != STATE_TRAINING) {
				if (this.mHealth == 0) {
					this.mState = STATE_KILLED;
					return;
				}
			}
			if (this.mProjectile) {
				if (this.mProjectile.update(param1)) {
					this.mProjectile = null;
				}
			}
			this.mAnimationTimer -= param1;
			this.mTextFXTimer -= param1;
			if (this.mTextFXQueue.length > 0) {
				if (this.mTextFXTimer <= 0) {
					_loc2_ = this.mTextFXQueue[0] as TextEffect;
					_loc3_ = _loc2_.getClip();
					_loc3_.scaleX /= mScene.mContainer.scaleX;
					_loc3_.scaleX = _loc3_.scaleY;
					_loc3_.x = mContainer.x;
					_loc3_.y = mContainer.y + 50;
					GameState.mInstance.mScene.mSceneHud.addChild(_loc3_);
					_loc2_.start();
					this.mTextFXQueue.splice(0, 1);
					this.mTextFXTimer = 350;
				}
			}
			if (this.mHealth < this.mMaxHealth) {
				if (this.mMaxHealTimeInMinutes > 0) {
					this.mHealingTimer += param1;
					if (this.mHealingTimer >= this.mMaxHealTimeInMinutes * 60000) {
						this.mHealingTimer = 0;
						this.setHealth(Math.min(this.mHealth + 1, this.mMaxHealth));
					}
				}
			}
			if (mActionDelayTimer > 0) {
				mActionDelayTimer -= param1;
				setLoadingBarPercent(1 - mActionDelayTimer / GENERIC_ACTION_DELAY_TIME);
				if (mActionDelayTimer <= 0) {
					hideLoadingBar();
				}
			}
			if (!isLoadingBarVisible()) {
				if (this is PlayerUnit) {
					if (GameState.mInstance.visitingFriend()) {
						if (this.mHealth < this.mMaxHealth) {
							showHealthWarning(true);
						} else {
							showHealthWarning(false);
						}
					} else if (this.mHealth <= this.mMaxHealth >> 1 && this.isAlive()) {
						showHealthWarning(true);
					} else {
						showHealthWarning(false);
					}
				}
			}
		}

		public function updateActions(param1: int): void {}

		public function resetActions(): void {}

		public function updateDying(param1: int): void {
			this.mSafetyTimer += param1;
			var _loc2_: String = getCurrentAnimationFrameLabel();
			if (_loc2_ == "end" || this.mSafetyTimer >= GameState.mConfig.GraphicSetup.Explosion.Length) {
				this.mState = STATE_KILLED;
				this.mSafetyTimer = 0;
			}
		}

		public function isInOpponentsTile(): Boolean {
			if (this is PlayerUnit) {
				return getCell().mOwner == MapData.TILE_OWNER_ENEMY;
			}
			if (this is EnemyUnit) {
				return getCell().mOwner == MapData.TILE_OWNER_FRIENDLY;
			}
			return false;
		}

		public function getShootingEffect(): int {
			if (this.mWeaponType == "explosion") {
				return EffectController.EFFECT_TYPE_HIT_EXPLOSION;
			}
			if (this.mWeaponType == "lightning") {
				return EffectController.EFFECT_TYPE_HIT_LIGHTNING;
			}
			if (this.mWeaponType == "big_explosion") {
				return EffectController.EFFECT_TYPE_BIG_EXPLOSION;
			}
			return EffectController.EFFECT_TYPE_HIT_BULLET;
		}

		override public function updateTooltip(param1: int, param2: TooltipHealth): void {
			super.updateTooltip(param1, param2);
			param2.setTitleText(mName);
			param2.setDetailsText("");
			param2.setHealth(this.mHealth, this.mMaxHealth);
		}

		public function useBooster(param1: BoosterItem): Boolean {
			if (Boolean(this.mBooster) || !param1) {
				return false;
			}
			this.mBooster = param1;
			this.mAttackRange += param1.mRangeBoost;
			this.mPower += param1.mPowerBoost;
			this.mHealth += param1.mHealthBoost;
			this.mMaxHealth += param1.mHealthBoost;
			return true;
		}

		public function disableBooster(): void {
			if (this.mBooster) {
				this.mAttackRange -= this.mBooster.mRangeBoost;
				this.mPower -= this.mBooster.mPowerBoost;
				this.mMaxHealth -= this.mBooster.mHealthBoost;
				this.mHealth = Math.min(this.mMaxHealth, this.mHealth);
			}
		}

		public function isFullHealth(): Boolean {
			return this.mHealth == this.mMaxHealth;
		}

		public function getClosestPlayerUnit(): PlayerUnit {
			var _loc4_: PlayerUnit = null;
			var _loc7_: int = 0;
			var _loc1_: Array = mScene.getPlayerAliveUnits();
			var _loc2_: int = int.MAX_VALUE;
			var _loc3_: Array = null;
			var _loc5_: int = int(_loc1_.length);
			var _loc6_: int = 0;
			while (_loc6_ < _loc5_) {
				if ((_loc4_ = _loc1_[_loc6_] as PlayerUnit) != this) {
					if ((_loc7_ = this.distanceToElement(_loc4_)) < _loc2_) {
						_loc3_ = new Array();
						_loc3_.push(_loc4_);
						_loc2_ = _loc7_;
					} else if (_loc7_ == _loc2_) {
						_loc3_.push(_loc4_);
					}
				}
				_loc6_++;
			}
			if (Boolean(_loc3_) && _loc3_.length > 0) {
				return _loc3_[Math.floor(Math.random() * _loc3_.length)];
			}
			return null;
		}

		public function distanceToElement(param1: Element): Number {
			return Math.sqrt(Math.pow(param1.mX - mX, 2) + Math.pow(param1.mY - mY, 2));
		}

		public function distanceToCell(param1: GridCell): Number {
			return Math.sqrt(Math.pow(mScene.getCenterPointXOfCell(param1) - mX, 2) + Math.pow(mScene.getCenterPointYOfCell(param1) - mY, 2));
		}

		public function getTargetPriority(): Number {
			var _loc2_: PlayerUnit = null;
			if (this.getHealth() == 0) {
				return 0;
			}
			var _loc1_: Number = this.getPower() * (this.getAttackRange() + 1) / this.getHealth() * 0.3;
			if (this is PlayerUnit) {
				_loc2_ = (this as PlayerUnit).getClosestPlayerUnit();
				if (_loc2_) {
					if (this.distanceToElement(_loc2_) / SceneLoader.GRID_CELL_SIZE <= _loc2_.getAttackRange()) {
						_loc1_ *= 0.5;
					}
				}
			}
			return Math.min(1, _loc1_);
		}

		public function getActorPriority(): Number {
			var _loc1_: Number = this.getPower() * 3 + this.getAttackRange() + this.getHealth() * 0.5;
			_loc1_ /= 20;
			return Math.min(1, _loc1_);
		}
	}
}