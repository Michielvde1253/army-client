package game.gameElements {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import game.actions.AcceptHelpSuppressEnemyInstallationAction;
	import game.actions.Action;
	import game.actions.ActionQueue;
	import game.actions.EnemyInstallationAttackAllAround;
	import game.actions.EnemyInstallationAttackingAction;
	import game.actions.EnemySpawningAction;
	import game.actions.VisitNeighborSuppressEnemyInstallationAction;
	import game.characters.AnimationController;
	import game.characters.PlayerUnit;
	import game.gui.TextEffect;
	import game.gui.TooltipHealth;
	import game.isometric.IsometricScene;
	import game.isometric.elements.StaticObject;
	import game.items.EnemyInstallationItem;
	import game.items.Item;
	import game.items.MapItem;
	import game.missions.MissionManager;
	import game.sound.ArmySoundManager;
	import game.states.GameState;
	import game.utils.EffectController;

	public class EnemyInstallationObject extends StaticObject {

		public static const TYPE_SNIPER: String = "Sniper";

		public static const STATE_IDLE: int = 0;

		public static const STATE_BEING_HIT: int = 1;

		public static const STATE_WRECKING: int = 2;

		public static const STATE_DESTROYED: int = 3;

		public static const STATE_SUPPRESS: int = 4;

		public static const REACT_STATE_NONE: int = 0;

		public static const REACT_STATE_WAIT_FOR_TURNS: int = 1;

		public static const REACT_STATE_WAIT_FOR_TIMER: int = 2;

		public static const REACT_STATE_ACTION: int = 3;

		public static const REACT_STATE_ACTION_COMPLETED: int = 4;

		public static const ACTION_TYPE_DO_NOTHING: int = 0;

		public static const ACTION_TYPE_SPAWN_ENEMY: int = 1;

		public static const ACTION_TYPE_ATTACK_PLAYER: int = 2;

		public static const ACTION_TYPE_ATTACK_PLAYER_SPAWN_ENEMY: int = 4;


		protected var mState: int;

		protected var mNewState: int;

		private var mReactionState: int;

		private var mNewReactionState: int;

		public var mReactionStateCounter: int;

		protected var mActionTimer: Number;

		public var mPower: int;

		public var mFiringType: String;

		public var mWeaponType: String;

		protected var mHealth: int;

		protected var mMaxHealth: int;

		public var mAttackRange: int;

		public var mSpawnEnemy: String;

		public var mSpawnTileNumber: int;

		public var mLastAttackDamage: int;

		public var mProtectorMission: Object;

		public var mCurrentAction: Action;

		public var mActionQueue: ActionQueue;

		public var mActionType: int;

		protected var mTextFXTimer: int;

		protected var mTextFXQueue: Array;

		protected var mInQueueForAction: Boolean;

		public var mPermanentDestroyArray: Array;

		public function EnemyInstallationObject(param1: int, param2: IsometricScene, param3: MapItem) {
			var _loc4_: EnemyInstallationItem = null;
			super(param1, param2, param3);
			_loc4_ = param3 as EnemyInstallationItem;
			this.mActionQueue = new ActionQueue();
			mMovable = false;
			setWalkable(false);
			this.mState = -1;
			this.mNewState = STATE_IDLE;
			this.mActionTimer = 0;
			this.mTextFXQueue = new Array();
			this.mTextFXTimer = 0;
			mContainer.mouseEnabled = false;
			mContainer.mouseChildren = false;
			mName = _loc4_.mName;
			this.mMaxHealth = _loc4_.mHealth;
			this.mHealth = this.mMaxHealth;
			this.mPower = _loc4_.mDamage;
			this.mFiringType = _loc4_.mFiringType;
			this.mWeaponType = _loc4_.mWeaponType;
			initAnimations(_loc4_.getGraphicAssets());
			this.mAttackRange = _loc4_.mAttackRange;
			this.mSpawnEnemy = _loc4_.mSpawnItem;
			this.mSpawnTileNumber = _loc4_.mSpawnTile;
			this.mLastAttackDamage = _loc4_.mLastAttackDamage;
			this.mProtectorMission = _loc4_.mProtectorMission;
			this.mPermanentDestroyArray = _loc4_.mPermanentDestroyArray;
			mAnimationController.setAnimation(AnimationController.INSTALLATION_ANIMATION_IDLE);
			if (this.hasAnimatedSecondFrame()) {
				this.updateAnimation(true, false);
			} else {
				this.updateAnimation(false, true);
			}
			this.mNewReactionState = REACT_STATE_NONE;
			if (Boolean(this.mSpawnEnemy) && this.mPower > 0) {
				this.mActionType = ACTION_TYPE_ATTACK_PLAYER_SPAWN_ENEMY;
				if (_loc4_.mReactionTurns > 0) {
					this.mNewReactionState = REACT_STATE_WAIT_FOR_TURNS;
				} else if (_loc4_.mReactionTime > 0) {
					this.mNewReactionState = REACT_STATE_WAIT_FOR_TIMER;
				}
			} else if (this.mPower > 0) {
				this.mActionType = ACTION_TYPE_ATTACK_PLAYER;
				if (_loc4_.mReactionTurns > 0) {
					this.mNewReactionState = REACT_STATE_WAIT_FOR_TURNS;
				} else if (_loc4_.mReactionTime > 0) {
					this.mNewReactionState = REACT_STATE_WAIT_FOR_TIMER;
				}
			} else if (this.mSpawnEnemy) {
				this.mActionType = ACTION_TYPE_SPAWN_ENEMY;
				if (_loc4_.mReactionTurns > 0) {
					this.mNewReactionState = REACT_STATE_WAIT_FOR_TURNS;
				} else if (_loc4_.mReactionTime > 0) {
					this.mNewReactionState = REACT_STATE_WAIT_FOR_TIMER;
				}
			}
			this.updateReactionState(0);
			this.mInQueueForAction = false;
			mVisible = false;
			mContainer.visible = false;
			if (FeatureTuner.USE_SOUNDS) {
				this.initSounds();
			}
		}

		override protected function updateAnimation(param1: Boolean, param2: Boolean): void {
			super.updateAnimation(param1, param2);
		}

		protected function hasAnimatedSecondFrame(): Boolean {
			return mItem.mId == "Sniper" || mItem.mId == "DdayDef4" || mItem.mId == "DdayDef6" || mItem.mId == "BaseSE" || mItem.mId == "BaseS" || mItem.mId == "BaseW" || mItem.mId == "BaseD1" || mItem.mId == "Mines" && !FeatureTuner.USE_MINE_EFFECTS;
		}

		override protected function initSounds(): void {
			super.initSounds();
			mDieSounds = ArmySoundManager.SC_ENM_BUILDING_EXPLOSION;
			if (mItem.mId == TYPE_SNIPER) {
				mAttackSounds = ArmySoundManager.SC_ENM_SNIPER_SHOOT;
			} else {
				mAttackSounds = ArmySoundManager.SC_ENM_INF_ATTACK;
			}
			mDieSounds.load();
			mAttackSounds.load();
		}

		override public function setupFromServer(param1: Object): void {
			super.setupFromServer(param1);
			this.mHealth = 0;
			this.setHealth(param1.item_hit_points);
			if (this.isTurnBased()) {
				this.setReactionStateCounter(param1.turn_counter);
			} else if (EnemyInstallationItem(mItem).mReactionTime > 0) {
				if (param1.next_action_at != null) {
					this.setReactionStateCounter(param1.next_action_at * 1000);
				}
			}
		}

		override public function logicUpdate(param1: int): Boolean {
			var _loc2_: TextEffect = null;
			var _loc3_: MovieClip = null;
			if (this.mState != this.mNewState) {
				this.changeState(this.mNewState);
			}
			this.mTextFXTimer -= param1;
			if (this.mTextFXQueue.length > 0) {
				if (this.mTextFXTimer <= 0) {
					_loc2_ = this.mTextFXQueue[0];
					_loc3_ = _loc2_.getClip();
					_loc3_.scaleX /= mScene.mContainer.scaleX;
					_loc3_.scaleY = _loc3_.scaleX;
					_loc3_.x = mContainer.x;
					_loc3_.y = mContainer.y + 50;
					GameState.mInstance.mScene.mSceneHud.addChild(_loc3_);
					_loc2_.start();
					this.mTextFXQueue.splice(0, 1);
					this.mTextFXTimer = 350;
				}
			}
			switch (this.mState) {
				case STATE_IDLE:
					this.updateReactionState(param1);
					break;
				case STATE_BEING_HIT:
					break;
				case STATE_WRECKING:
					if (getCurrentAnimationFrameLabel() == "end") {
						this.mNewState = STATE_DESTROYED;
					}
					break;
				case STATE_DESTROYED:
					return true;
				case STATE_SUPPRESS:
					mActionDelayTimer -= param1;
					setLoadingBarPercent(1 - mActionDelayTimer / GENERIC_ACTION_DELAY_TIME);
					if (mActionDelayTimer <= 0) {
						mActionDelayTimer = 0;
						this.mNewState = STATE_IDLE;
						hideLoadingBar();
					}
			}
			return false;
		}

		public function destroysPermanently(param1: MapItem): Boolean {
			var _loc2_: Object = null;
			var _loc3_: int = 0;
			var _loc4_: int = 0;
			if (this.mPermanentDestroyArray) {
				_loc3_ = int(this.mPermanentDestroyArray.length);
				_loc4_ = 0;
				while (_loc4_ < _loc3_) {
					_loc2_ = this.mPermanentDestroyArray[_loc4_] as Object;
					if (param1.mId == _loc2_.ID) {
						if (param1.mType == _loc2_.Type) {
							return true;
						}
					}
					_loc4_++;
				}
			}
			return false;
		}

		protected function changeState(param1: int): void {
			var _loc2_: * = false;
			switch (param1) {
				case STATE_IDLE:
					this.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_IDLE, false, true);
					break;
				case STATE_BEING_HIT:
					break;
				case STATE_WRECKING:
					if (getTileSize().z == 0) {
						GameState.mInstance.mScene.addEffect(null, EffectController.EFFECT_TYPE_BIG_EXPLOSION, mX + mScene.mGridDimX * getTileSize().x / 2, mY + mScene.mGridDimY * getTileSize().y / 2);
						this.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_WRECKING, false, true);
						mAnimationController.getAnimation().visible = false;
					} else {
						this.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_WRECKING, false, true);
						if (getTileSize().x > 1) {
							mAnimationController.getCurrentAnimation().x = mAnimationController.getCurrentAnimation().x + (mScene.mGridDimX * getTileSize().x / 2 - mScene.mGridDimX / 2);
						}
						if (getTileSize().y > 1) {
							mAnimationController.getCurrentAnimation().y = mAnimationController.getCurrentAnimation().y + (mScene.mGridDimY * getTileSize().y / 2 - mScene.mGridDimY / 2);
						}
					}
					playCollectionSound(mDieSounds);
					this.resetActions();
					hideActingHealthBar();
					_loc2_ = Math.random() * 100 < GameState.mConfig.DebrisSetup.SpawnAfterEnemy.Probability;
					if (_loc2_) {
						if (!mKilledByFireMission) {
							GameState.mInstance.spawnNewDebris(GameState.mConfig.DebrisSetup.SpawnAfterEnemy.DebrisObject.ID, GameState.mConfig.DebrisSetup.SpawnAfterEnemy.DebrisObject.Type, mX, mY);
						}
					}
					break;
				case STATE_SUPPRESS:
					this.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_HIT, false, true);
					break;
				case STATE_DESTROYED:
			}
			this.mState = param1;
			this.mNewState = this.mState;
		}

		private function updateReactionState(param1: int): void {
			if (this.mNewReactionState > -1) {
				this.mReactionState = this.mNewReactionState;
				this.mNewReactionState = -1;
				switch (this.mReactionState) {
					case REACT_STATE_WAIT_FOR_TURNS:
						this.setReactionStateCounter(0);
						break;
					case REACT_STATE_WAIT_FOR_TIMER:
						this.setReactionStateCounter(EnemyInstallationItem(mItem).mReactionTime * 60000);
						break;
					case REACT_STATE_ACTION:
						this.setReactionStateCounter(EnemyInstallationItem(mItem).mReactionTurns);
						if (this.mActionType == ACTION_TYPE_SPAWN_ENEMY) {
							this.spawnNewEnemy();
						} else if (this.mActionType == ACTION_TYPE_ATTACK_PLAYER) {
							this.attackPlayerUnit();
						} else if (this.mActionType == ACTION_TYPE_ATTACK_PLAYER_SPAWN_ENEMY) {
							this.attackPlayerUnit();
							this.spawnNewEnemy();
						}
				}
			}
			switch (this.mReactionState) {
				case REACT_STATE_WAIT_FOR_TURNS:
					if (this.mReactionStateCounter >= EnemyInstallationItem(mItem).mReactionTurns) {
						this.mNewReactionState = REACT_STATE_ACTION;
						return;
					}
					if (this.mReactionStateCounter == EnemyInstallationItem(mItem).mReactionTurns - 1) {
						if (getCurrentAnimationIndex() != AnimationController.INSTALLATION_ANIMATION_READY_FOR_ACTION) {
							this.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_READY_FOR_ACTION, false, true);
						}
					}
					break;
				case REACT_STATE_WAIT_FOR_TIMER:
					this.setReactionStateCounter(this.mReactionStateCounter - param1);
					if (this.mReactionStateCounter <= 0) {
						this.mNewReactionState = REACT_STATE_ACTION;
						return;
					}
					if (this.mReactionStateCounter <= 3000) {
						if (getCurrentAnimationIndex() != AnimationController.INSTALLATION_ANIMATION_READY_FOR_ACTION) {
							this.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_READY_FOR_ACTION, false, true);
						}
					}
					break;
				case REACT_STATE_ACTION:
					break;
				case REACT_STATE_ACTION_COMPLETED:
					if (this.isTurnBased()) {
						this.mNewReactionState = REACT_STATE_WAIT_FOR_TURNS;
					} else if (EnemyInstallationItem(mItem).mReactionTime > 0) {
						this.mNewReactionState = REACT_STATE_WAIT_FOR_TIMER;
					} else {
						this.mNewReactionState = REACT_STATE_NONE;
					}
					return;
			}
		}

		public function updateActions(param1: int): void {
			if (this.mCurrentAction != null) {
				this.mCurrentAction.update(param1);
				if (this.mCurrentAction) {
					if (this.mCurrentAction.isOver()) {
						this.mCurrentAction = null;
					}
				}
			}
			if (this.mCurrentAction == null) {
				if (this.mActionQueue.mActions.length > 0) {
					this.mCurrentAction = this.mActionQueue.mActions.shift();
					this.mCurrentAction.start();
				}
			}
		}

		override public function setAnimationAction(param1: int, param2: Boolean = true, param3: Boolean = false): Boolean {
			if (param1 == AnimationController.INSTALLATION_ANIMATION_HIT) {
				if (!this.isForceFieldActivated()) {
					return false;
				}
			}
			if (param1 == AnimationController.INSTALLATION_ANIMATION_IDLE) {
				if (this.hasAnimatedSecondFrame()) {
					param2 = true;
					param3 = false;
				}
			}
			return super.setAnimationAction(param1, param2, param3);
		}

		public function isForceFieldActivated(): Boolean {
			if (this.mProtectorMission) {
				if (!MissionManager.isMissionCompleted(this.mProtectorMission.ID)) {
					return true;
				}
			}
			return false;
		}

		public function hasForceField(): Boolean {
			if (this.mProtectorMission) {
				return true;
			}
			return false;
		}

		public function playerMoveMade(): Boolean {
			if (this.mReactionState == REACT_STATE_WAIT_FOR_TURNS) {
				this.setReactionStateCounter(this.mReactionStateCounter + 1);
				return true;
			}
			return false;
		}

		private function setReactionStateCounter(param1: int): void {
			if (param1 < 0) {
				param1 = 0;
			}
			var _loc2_: int = this.mReactionStateCounter;
			this.mReactionStateCounter = param1;
		}

		public function queueAction(param1: Action, param2: Boolean = false): void {
			if (param2) {
				this.mActionQueue.mActions.length = 0;
				this.mCurrentAction = null;
			}
			GameState.mInstance.queueAction(param1);
		}

		public function resetActions(): void {
			this.mActionQueue.mActions.length = 0;
			this.mCurrentAction = null;
		}

		public function addTextEffect(param1: int, param2: String, param3: Item = null): void {
			if (this.mTextFXQueue.length < 2) {
				this.mTextFXQueue.push(new TextEffect(param1, param2, param3));
			}
		}

		public function remove(): void {
			this.mNewState = STATE_WRECKING;
			hideLoadingBar();
			if (GameState.mInstance.mState != GameState.STATE_VISITING_NEIGHBOUR) {
				MissionManager.increaseCounter("Destroy", this, 1);
				MissionManager.increaseCounter("DestroyTarget", this, 1);
			}
		}

		override public function updateTooltip(param1: int, param2: TooltipHealth): void {
			if (!this.isAlive()) {
				return;
			}
			super.updateTooltip(param1, param2);
			param2.setHealth(this.mHealth, this.mMaxHealth);
			param2.setTitleText(mName);
			if (GameState.mInstance.mState == GameState.STATE_VISITING_NEIGHBOUR && this.hasForceField()) {
				param2.setDetailsText(GameState.getText("ALLY_BOMB_BOSS"));
			} else if (this.isForceFieldActivated()) {
				param2.setDetailsText(GameState.getText("BOSS_FORCEFIELD_TOOLTIP"));
			} else {
				param2.setDetailsText(GameState.getText("MOUSEOVER_ENEMY_IDLE"));
			}
		}

		public function reduceHealth(param1: int): void {
			if (!this.isAlive()) {
				return;
			}
			if (param1 > 0) {
				this.addTextEffect(TextEffect.TYPE_LOSS, "-" + param1);
			}
			this.setHealth(this.mHealth - param1);
		}

		override public function isAlive(): Boolean {
			return this.mState != STATE_DESTROYED && this.mState != STATE_WRECKING;
		}

		public function canAttack(): Boolean {
			return this.mActionType == ACTION_TYPE_ATTACK_PLAYER_SPAWN_ENEMY || this.mActionType == ACTION_TYPE_ATTACK_PLAYER;
		}

		public function canCounterAttack(): Boolean {
			return this.canAttack() && !this.isTurnBased();
		}

		public function getHealth(): int {
			return this.mHealth;
		}

		public function setHealth(param1: int): void {
			var _loc2_: int = this.mHealth;
			this.mHealth = Math.max(0, param1);
			// Fix defences staying at 0 HP
			// Not sure what this check was meant for, so it might break something
			//if(this.mHealth != _loc2_)
			//{
			if (this.mHealth == 0) {
				this.remove();
			}
			//}
		}

		public function getPower(): int {
			return this.mPower;
		}

		public function getShootingEffect(): int {
			if (this.mWeaponType == "lightning") {
				return EffectController.EFFECT_TYPE_HIT_LIGHTNING;
			}
			if (this.mWeaponType == "explosion") {
				return EffectController.EFFECT_TYPE_HIT_EXPLOSION;
			}
			if (this.mWeaponType == "big_explosion") {
				return EffectController.EFFECT_TYPE_BIG_EXPLOSION;
			}
			return EffectController.EFFECT_TYPE_HIT_BULLET;
		}

		override public function MousePressed(param1: MouseEvent): void {
			var _loc2_: GameState = GameState.mInstance;
			if (mContainer.visible) {
				GameState.mInstance.moveCameraToSeeRenderable(this);
				if (_loc2_.mState == GameState.STATE_VISITING_NEIGHBOUR) {
					_loc2_.moveCameraToSeeRenderable(this);
					if (!this.mInQueueForAction) {
						if (mNeighborActionAvailable) {
							if (this.mState != STATE_SUPPRESS) {
								this.mInQueueForAction = true;
								_loc2_.queueAction(new VisitNeighborSuppressEnemyInstallationAction(this));
							}
						}
					}
				} else {
					GameState.mInstance.attackEnemy(this);
				}
			}
		}

		override public function MouseOut(param1: MouseEvent): void {}

		override public function MouseOver(param1: MouseEvent): void {}

		public function changeReactionState(param1: int): void {
			if (param1 != this.mReactionState) {
				this.mNewReactionState = param1;
			}
		}

		public function getReactionState(): int {
			return this.mReactionState;
		}

		public function resetReactionTimer(): void {
			if (this.mActionType == ACTION_TYPE_DO_NOTHING) {
				this.mNewReactionState = REACT_STATE_NONE;
			} else if (EnemyInstallationItem(mItem).mReactionTime > 0) {
				this.mNewReactionState = REACT_STATE_WAIT_FOR_TIMER;
			}
		}

		public function attackPlayerUnit(param1: PlayerUnit = null): void {
			if (!this.isAlive()) {
				return;
			}
			if (this.hasAttackActionInQueue()) {
				return;
			}
			if (this.mFiringType == "allaround") {
				GameState.mInstance.queueAction(new EnemyInstallationAttackAllAround(this), true);
			} else {
				GameState.mInstance.queueAction(new EnemyInstallationAttackingAction(this, param1), true);
			}
		}

		private function spawnNewEnemy(): void {
			if (!this.mSpawnEnemy) {
				return;
			}
			if (!this.isAlive()) {
				return;
			}
			GameState.mInstance.queueAction(new EnemySpawningAction(this), true);
		}

		private function hasAttackActionInQueue(): Boolean {
			var _loc1_: Action = null;
			if (this.mCurrentAction is EnemyInstallationAttackingAction) {
				return true;
			}
			var _loc2_: int = int(this.mActionQueue.mActions.length);
			var _loc3_: int = 0;
			while (_loc3_ < _loc2_) {
				_loc1_ = this.mActionQueue.mActions[_loc3_] as Action;
				if (_loc1_ is EnemyInstallationAttackingAction) {
					return true;
				}
				_loc3_++;
			}
			return false;
		}

		override public function neighborClicked(param1: String): Action {
			var _loc2_: Action = null;
			if (!this.mInQueueForAction) {
				this.mInQueueForAction = true;
				_loc2_ = new AcceptHelpSuppressEnemyInstallationAction(this, param1);
			}
			return _loc2_;
		}

		public function startSuppress(): void {
			this.mNewState = STATE_SUPPRESS;
			this.mInQueueForAction = false;
			showLoadingBar();
		}

		public function skipSuppress(): void {
			if (Config.DEBUG_MODE) {}
			if (this.mState == STATE_SUPPRESS) {
				this.mNewState = STATE_IDLE;
			}
			this.mInQueueForAction = false;
			mActionDelayTimer = 0;
			hideLoadingBar();
		}

		public function isSuppressOver(): Boolean {
			return this.mState != STATE_SUPPRESS;
		}

		public function handleSuppress(): void {
			this.resetReactionTimer();
			this.reduceHealth(GameState.mConfig.AllyAction.SabotageEnemyInstallation.Damage);
			hideLoadingBar();
		}

		public function isTurnBased(): Boolean {
			return EnemyInstallationItem(mItem).mReactionTurns > 0;
		}

		public function getActionTimer(): Number {
			return this.mActionTimer;
		}
	}
}