package game.gameElements {
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import game.actions.AcceptHelpHarvestProductionAction;
	import game.actions.AcceptHelpSpeedUpProductionAction;
	import game.actions.AcceptHelpUnwitherProductionAction;
	import game.actions.Action;
	import game.actions.HarvestProductionAction;
	import game.actions.VisitNeighborHarvestProductionAction;
	import game.actions.VisitNeighborSpeedUpProductionAction;
	import game.actions.VisitNeighborUnwitherProductionAction;
	import game.battlefield.MapData;
	import game.gui.HUDInterface;
	import game.gui.TextEffect;
	import game.gui.TooltipHealth;
	import game.isometric.GridCell;
	import game.isometric.ImportedObject;
	import game.isometric.IsometricScene;
	import game.items.Item;
	import game.items.MapItem;
	import game.player.GamePlayerProfile;
	import game.sound.ArmySoundManager;
	import game.states.GameState;
	import game.utils.EffectController;
	import game.utils.TimeUtils;

	public class PlayerBuildingObject extends ImportedObject {

		public static const STATE_PLACING_ON_MAP: int = 0;

		public static const STATE_IDLE: int = 2;

		public static const STATE_PRODUCING: int = 3;

		public static const STATE_PRODUCTION_READY: int = 4;

		public static const STATE_WITHERED: int = 5;

		public static const STATE_BEING_HARVESTED: int = 6;

		public static const STATE_BEING_UNWITHERED: int = 7;

		public static const STATE_BEING_SPEED_UP: int = 8;

		public static const STATE_BUILD_CLICKS_NEEDED: int = 9;

		public static const STATE_WORKING_ON_BUILDING: int = 10;

		public static const STATE_PARTS_NEEDED: int = 11;

		public static const STATE_PARTS_READY: int = 12;

		public static const STATE_READY: int = 13;

		public static const STATE_RUINS: int = 14;

		public static const STATE_PLAY_HARVEST_ANIMATION: int = 15;

		public static const STATE_REMOVE: int = 99;

		public static var gc: GridCell;


		public var mState: int;

		private var mOldState: int;

		protected var mUnderAttack: Boolean;

		private var mInfoText: TextField;

		protected var mProduction: Production;

		protected var mHealth: int;

		protected var mMaxHealth: int;

		protected var mDestroyedPermanently: Boolean;

		private var mSightRange: int;

		private var mProgressIconSet: Boolean;

		protected var mProgressCompletedIcon: MovieClip;

		protected var mInQueueForAction: Boolean;

		private var mEffectController: EffectController;

		private var mTextFXTimer: int;

		private var mTextFXQueue: Array;

		private var scene: IsometricScene;

		public function PlayerBuildingObject(param1: int, param2: IsometricScene, param3: MapItem, param4: Point, param5: DisplayObject = null, param6: String = null) {
			var _loc8_: Class = null;
			var _loc9_: Class = null;
			this.scene = GameState.mInstance.mScene;
			this.mMaxHealth = MapItem(param3).mHealth;
			this.mHealth = this.mMaxHealth;
			super(param1, param2, param3, param4, param5, param6);
			this.mTextFXQueue = new Array();
			this.mSightRange = MapItem(mItem).mSightRange;
			//this.mState = STATE_PLACING_ON_MAP;
			this.mState = STATE_READY;
			mMovable = true;
			var _loc7_: TextFormat;
			(_loc7_ = new TextFormat()).size = 12;
			_loc7_.color = 16777215;
			this.mInfoText = new TextField();
			this.mInfoText.defaultTextFormat = _loc7_;
			mContainer.mouseChildren = false;
			mContainer.mouseEnabled = false;
			this.mProgressIconSet = false;
			if (FeatureTuner.USE_HARVEST_READY_ICON_EFFECT) {
				_loc8_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "icon_status_finished");
				this.mProgressCompletedIcon = new _loc8_();
			} else {
				_loc9_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "icon_status_finished1");
				this.mProgressCompletedIcon = new _loc9_();
			}
			this.mProgressCompletedIcon.mouseEnabled = false;
			this.mProgressCompletedIcon.mouseChildren = false;
			this.mEffectController = new EffectController();
			this.mDestroyedPermanently = false;
		}

		override public function addSprite(param1: DisplayObject): void {
			super.addSprite(param1);
		}

		public function setHealth(param1: int): void {
			var _loc4_: int = 0;
			var _loc5_: int = 0;
			var _loc6_: int = 0;
			var _loc7_: int = 0;
			var _loc2_: int = this.mHealth;
			var _loc3_: int = Math.max(0, Math.min(this.mMaxHealth, param1));
			if (_loc2_ != _loc3_ || _loc3_ == this.mMaxHealth) {
				_loc4_ = this.getSightRangeAccordingToCondition();
				this.mHealth = _loc3_;
				_loc5_ = this.getSightRangeAccordingToCondition();
				if (_loc4_ != _loc5_) {
					mScene.decrementViewersForBuilding(this, _loc4_);
					mScene.incrementViewersForBuilding(this, _loc5_);
				}
				if (this.mHealth == 0) {
					_loc6_ = (mTileSize.x - 1) * (mScene.mGridDimX >> 1);
					_loc7_ = (mTileSize.y - 1) * (mScene.mGridDimY >> 1);
					this.mEffectController.startEffect(mScene, null, EffectController.EFFECT_TYPE_BIG_EXPLOSION, mX + _loc6_, mY + _loc7_);
				}
				this.checkProductionState();
			}
		}

		public function addTextEffect(param1: int, param2: String, param3: Item = null): void {
			this.mTextFXQueue.push(new TextEffect(param1, param2, param3));
		}

		public function getHealth(): int {
			return this.mHealth;
		}

		public function getMaxHealth(): int {
			return this.mMaxHealth;
		}

		public function isFullHealth(): Boolean {
			return this.mHealth == this.mMaxHealth;
		}

		public function getHealthPercentage(): int {
			return 100 * (this.mHealth / this.mMaxHealth);
		}

		public function addHealth(param1: int): void {
			this.setHealth(this.mHealth + param1);
		}

		public function isReadyForHarvesting(): Boolean {
			return this.mState == STATE_PRODUCTION_READY && this.isFullHealth();
		}

		public function isRepairable(): Boolean {
			var _loc1_: Array = null;
			var _loc2_: GridCell = null;
			var _loc3_: int = 0;
			var _loc4_: int = 0;
			if (!this.isFullHealth() && !(this is PermanentHFEObject) && !(this is SignalObject)) {
				_loc1_ = GameState.mInstance.mScene.getTilesUnderObject(this);
				_loc3_ = int(_loc1_.length);
				_loc4_ = 0;
				while (_loc4_ < _loc3_) {
					_loc2_ = _loc1_[_loc4_] as GridCell;
					if (_loc2_.mOwner != MapData.TILE_OWNER_FRIENDLY || Boolean(_loc2_.mCharacter)) {
						return false;
					}
					_loc4_++;
				}
				return true;
			}
			return false;
		}

		public function checkProductionState(): void {}

		public function handlePlacedOnMap(): void {}

		protected function getCurrentPoductionName(): String {
			if (this.mProduction) {
				return this.mProduction.getProductionName();
			}
			return null;
		}

		protected function getStateText(): String {
			switch (this.mState) {
				case STATE_PLACING_ON_MAP:
					return GameState.getText("BUILDING_STATUS_PLACING_ON_MAP");
				case STATE_BEING_UNWITHERED:
					return GameState.getText("BUILDING_STATUS_BEING_UNWITHERED");
				case STATE_BEING_SPEED_UP:
					return GameState.getText("BUILDING_STATUS_BEING_SPEED_UP");
				case STATE_RUINS:
					if (this.isRepairable()) {
						return GameState.getText("BUILDING_STATUS_RUINS");
					}
					return GameState.getText("BUILDING_STATUS_RUINS");
					break;
				default:
					return "Error state\n" + this.mState;
			}
		}

		protected function getTimeLeftString(): String {
			if (this.mState == STATE_PRODUCING) {
				return TimeUtils.milliSecondsToString(this.mProduction.getProducingTimeLeft());
			}
			if (this.mState == STATE_PRODUCTION_READY) {
				return TimeUtils.milliSecondsToString(this.mProduction.getTimeToWither());
			}
			return "";
		}

		public function getTimeLeftCountdown(): String {
			if (this.mState == STATE_PRODUCING) {
				return TimeUtils.getCountDownTime(this.mProduction.getProducingTimeLeft());
			}
			if (this.mState == STATE_PRODUCTION_READY) {
				return TimeUtils.getCountDownTime(this.mProduction.getTimeToWither());
			}
			return "";
		}

		public function handleProductionComplete(): void {
			this.mState = STATE_PRODUCTION_READY;
		}

		public function handleProductionHarvested(): void {}

		override public function setPos(param1: int, param2: int, param3: int): void {
			super.setPos(param1, param2, param3);
			if (this.mProgressCompletedIcon) {
				if (getCell()) {
					this.mProgressCompletedIcon.x = mScene.getLeftUpperXOfCell(getCell()) + getTileSize().x * (mScene.mGridDimX >> 1);
					this.mProgressCompletedIcon.y = mScene.getLeftUpperYOfCell(getCell()) + mScene.mGridDimY - this.mProgressCompletedIcon.height / 2;
				}
			}
		}

		override public function logicUpdate(param1: int): Boolean {
			var _loc4_: TextEffect = null;
			var _loc5_: MovieClip = null;
			if (this.mOldState != this.mState) {
				this.mProgressIconSet = false;
				this.mOldState = this.mState;
			}
			if (this.mUnderAttack) {
				return false;
			}
			this.mTextFXTimer -= param1;
			if (this.mTextFXQueue.length > 0) {
				if (this.mTextFXTimer <= 0) {
					_loc5_ = (_loc4_ = this.mTextFXQueue[0]).getClip();
					if (Config.FOR_IPHONE_PLATFORM) {
						_loc5_.scaleX = 2;
						_loc5_.scaleY = 2;
					}
					_loc5_.y = 50;
					GameState.mInstance.mScene.mSceneHud.addChild(_loc5_);
					_loc5_.x = getContainer().x;
					_loc5_.y = getContainer().y;
					_loc4_.start();
					this.mTextFXQueue.splice(0, 1);
					this.mTextFXTimer = 350;
				}
			}
			this.updateProductionIcon();
			var _loc2_: Boolean = this.mEffectController.update(param1);
			if (_loc2_) {
				if (this.mDestroyedPermanently) {
					this.destroy();
				}
			}
			var _loc3_: Boolean = false;
			if (mActionDelayTimer > 0) {
				mActionDelayTimer -= param1;
				setLoadingBarPercent(1 - mActionDelayTimer / GENERIC_ACTION_DELAY_TIME);
				if (mActionDelayTimer <= 0) {
					_loc3_ = true;
					hideLoadingBar();
				}
			}
			switch (this.mState) {
				case STATE_PLACING_ON_MAP:
					this.mState = STATE_IDLE;
				case STATE_IDLE:
					if (!getCell().hasFog() && this.mHealth <= this.mMaxHealth >> 1) {
						if (!isLoadingBarVisible()) {
							showHealthWarning(true);
						}
					} else {
						showHealthWarning(false);
					}

					setProduction(mItem.mId);
					mState = STATE_PRODUCING;
					break;
				case STATE_READY:
				case STATE_PRODUCING:
				case STATE_PRODUCTION_READY:
					if (!getCell().hasFog() && this.mHealth < this.mMaxHealth) {
						if (!isLoadingBarVisible()) {
							showHealthWarning(true);
						}
					} else {
						showHealthWarning(false);
					}
					if (this.mState == STATE_PRODUCING) {
						if (this.mProduction.isReady()) {
							this.handleProductionComplete();
						}
					}
					break;
				case STATE_BEING_HARVESTED:
					if (_loc3_) {
						this.mState = STATE_IDLE;
					}
					break;
				case STATE_BEING_UNWITHERED:
					if (_loc3_) {
						this.mState = STATE_PRODUCTION_READY;
					}
					break;
				case STATE_BEING_SPEED_UP:
					if (_loc3_) {
						this.mState = STATE_PRODUCING;
					}
					break;
				case STATE_REMOVE:
					showHealthWarning(false);
					hideLoadingBar();
					this.mInfoText = null;
					return true;
			}
			return false;
		}

		public function remove(): void {
			this.mState = STATE_REMOVE;
		}

		public function skipHarvest(): void {
			if (Config.DEBUG_MODE) {}
			if (this.mState != STATE_REMOVE) {
				this.mState = STATE_PRODUCTION_READY;
			}
			this.mInQueueForAction = false;
			hideLoadingBar();
		}

		public function setReady(): void {
			this.mState = STATE_PRODUCTION_READY;
		}

		public function isHarvestingOver(): Boolean {
			return this.mState != STATE_BEING_HARVESTED;
		}

		public function isProducing(): Boolean {
			return this.mState == STATE_PRODUCING;
		}

		public function setProductionReady(): Boolean {
			if (this.mState == STATE_PRODUCING) {
				this.mProduction.setRemainingProductionTime(0);
				return true;
			}
			return false;
		}

		public function getState(): int {
			return this.mState;
		}

		public function startHarvesting(): void {
			this.mState = STATE_BEING_HARVESTED;
			this.mInQueueForAction = false;
			showLoadingBar();
			spendNeighborAction();
		}

		public function startRepairing(): void {
			showLoadingBar();
		}

		public function getSightRangeAccordingToCondition(): int {
			return this.mHealth == 0 ? 0 : this.mSightRange;
		}

		public function getSightRange(): int {
			return this.mSightRange;
		}

		override public function MousePressed(param1: MouseEvent): void {
			var _loc3_: GamePlayerProfile = null;
			ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_CLICK);
			var _loc2_: GameState = GameState.mInstance;
			_loc2_.moveCameraToSeeRenderable(this);
			if (!this.mInQueueForAction) {
				if (this.isFullHealth()) {
					trace("object id:")
					trace(this.mItem)
					trace(this.mItem.mType)
					if (_loc2_.mState == GameState.STATE_VISITING_NEIGHBOUR) {
						if (mNeighborActionAvailable && this is HFEObject) {
							if (this.mState == STATE_PRODUCING) {
								this.mInQueueForAction = true;
								_loc2_.queueAction(new VisitNeighborSpeedUpProductionAction(this));
							} else if (this.isReadyForHarvesting()) {
								this.mInQueueForAction = true;
								_loc2_.queueAction(new VisitNeighborHarvestProductionAction(this));
							} else if (this.mState == STATE_WITHERED) {
								this.mInQueueForAction = true;
								_loc2_.queueAction(new VisitNeighborUnwitherProductionAction(this));
							}
						}
					} else if (this.mState == STATE_PRODUCTION_READY || this.mState == STATE_WITHERED || (this.mState == STATE_PRODUCING && this.mItem.mType == "HomeFrontEffort")) {
						_loc3_ = _loc2_.mPlayerProfile;
						if (this.mProduction.getRewardSupplies() > 0 && this.mProduction.getRewardSupplies() + _loc3_.mSupplies > _loc3_.mSuppliesCap) {
							_loc2_.mHUD.openSupplyCapTextBox(null);
						} else if (this.mState == STATE_WITHERED && _loc2_.mHUD.mShowAskReviveWindow) {
							_loc2_.mHUD.openAskReviveTextBox();
						} else if (this.mState == STATE_PRODUCING) {
							gc = this.scene.getTileUnderMouse();
							GameState.mInstance.mHUD.openImmediateSuppliesTextBox(mItem, this.getStateText(), this.mProduction.getProducingTimeLeft());
							var _loc4_: HUDInterface = null;
							_loc4_ = GameState.mInstance.getHud();
							if (_loc4_ != null) {
								_loc4_.hideObjectTooltip();
							}
						} else {
							this.mInQueueForAction = true;
							_loc2_.queueAction(new HarvestProductionAction(this));
						}
					}
				}
			}
		}

		override public function neighborClicked(param1: String): Action {
			var _loc2_: Action = null;
			if (!this.mInQueueForAction) {
				if (this.mState == STATE_PRODUCING) {
					this.mInQueueForAction = true;
					_loc2_ = new AcceptHelpSpeedUpProductionAction(this, param1);
				} else if (this.mState == STATE_PRODUCTION_READY) {
					this.mInQueueForAction = true;
					_loc2_ = new AcceptHelpHarvestProductionAction(this, param1);
				} else if (this.mState == STATE_WITHERED) {
					this.mInQueueForAction = true;
					_loc2_ = new AcceptHelpUnwitherProductionAction(this, param1);
				}
			}
			return _loc2_;
		}

		public function getProduction(): Production {
			return this.mProduction;
		}

		public function setProduction(param1: String): void {
			this.mProduction = new Production(MapItem(mItem), param1, Production.TIME_DEFAULT, Production.TIME_DEFAULT, this);
		}

		public function setProductionWithTime(param1: String, param2: int): void {
			this.mProduction = new Production(MapItem(mItem), param1, param2, Production.TIME_DEFAULT, this);
		}

		override public function setupFromServer(param1: Object): void {
			super.setupFromServer(param1);
			this.mHealth = 0;
			this.setHealth(param1.item_hit_points);
		}

		public function removeProduction(): void {
			this.mProduction = null;
		}

		public function pauseProduction(): void {
			this.mProduction = null;
		}

		public function continueProduction(): void {
			this.mProduction = null;
		}

		override public function updateTooltip(param1: int, param2: TooltipHealth): void {
			var _loc3_: HUDInterface = null;
			super.updateTooltip(param1, param2);
			param2.setTitleText(mItem.mName);
			param2.setHealth(this.mHealth, this.mMaxHealth);
			if (!this.isFullHealth()) {
				if (this is PermanentHFEObject) {
					if (GameState.mInstance.visitingFriend()) {
						param2.setDetailsText(GameState.getText("BUILDING_STATUS_IDLE_BUILDING"));
					} else {
						param2.setDetailsText(GameState.getText("BUILDING_STATUS_CONQUER"));
					}
				} else if (GameState.mInstance.mVisitingFriend) {
					param2.setDetailsText(GameState.getText("BUILDING_STATUS_IDLE_BUILDING"));
				} else {
					param2.setDetailsText(GameState.getText("BUILDING_STATUS_DAMAGED"));
				}
			} else if (this.mState == STATE_PRODUCING && param2.getOpenAsPopup() == 1 && (mItem.mName == "Ammo Crates" || mItem.mName == "M.R.E Containers" || mItem.mName == "Gasoline Drop" || mItem.mName == "Oil Containers" || mItem.mName == "Military Crate" || mItem.mName == "Big Container" || mItem.mName == "Premium Container")) {
				//gc = this.scene.getTileUnderMouse();
				//if(Config.DEBUG_MODE)
				//{
				//}
				//GameState.mInstance.mHUD.openImmediateSuppliesTextBox(mItem,this.getStateText(),this.mProduction.getProducingTimeLeft());
				//_loc3_ = GameState.mInstance.getHud();
				//if(_loc3_ != null)
				//{
				//   _loc3_.hideObjectTooltip();
				//}
			} else {
				param2.setDetailsText(this.getStateText());
			}
		}

		public function updateProductionIcon(): void {
			if (FeatureTuner.USE_HARVEST_READY_ICON_EFFECT) {
				if (this.mProgressCompletedIcon) {
					if (this.mProgressCompletedIcon.visible) {
						if (Math.abs(this.mProgressCompletedIcon.scaleX - 1 / mScene.mContainer.scaleX) > 0.01) {
							this.mProgressCompletedIcon.scaleX = 1 / mScene.mContainer.scaleX;
							this.mProgressCompletedIcon.scaleY = this.mProgressCompletedIcon.scaleX;
						}
					}
				}
			}
			switch (this.mState) {
				case STATE_PRODUCING:
					break;
				case STATE_PRODUCTION_READY:
					if (!this.mProgressIconSet && this.mHealth == this.mMaxHealth) {
						this.setProgressIconVisibility(this is HFEObject || !GameState.mInstance.visitingFriend());
					}
					break;
				case STATE_WITHERED:
					if (!this.mProgressIconSet) {
						this.setProgressIconVisibility(true);
					}
					break;
				default:
					if (!this.mProgressIconSet) {
						this.mProgressCompletedIcon.visible = false;
						if (this.mProgressCompletedIcon.parent) {
							this.mProgressCompletedIcon.parent.removeChild(this.mProgressCompletedIcon);
						}
						this.mProgressIconSet = true;
					}
			}
		}

		public function setProgressIconVisibility(param1: Boolean): void {
			var _loc2_: Point = getIconPosition();
			this.mProgressCompletedIcon.x = _loc2_.x;
			this.mProgressCompletedIcon.y = _loc2_.y;
			if (param1) {
				this.mProgressCompletedIcon.visible = true;
				mScene.mSceneHud.addChild(this.mProgressCompletedIcon);
			} else {
				this.mProgressCompletedIcon.visible = false;
				if (this.mProgressCompletedIcon.parent) {
					this.mProgressCompletedIcon.parent.removeChild(this.mProgressCompletedIcon);
				}
			}
			this.mProgressIconSet = true;
		}

		public function healToMax(): void {
			this.setHealth(this.mMaxHealth);
		}

		override public function destroy(): void {
			super.destroy();
			if (this.mProgressCompletedIcon.parent) {
				this.mProgressCompletedIcon.parent.removeChild(this.mProgressCompletedIcon);
			}
			this.mProgressCompletedIcon = null;
		}

		public function destroyPermanently(): void {
			this.mState = STATE_RUINS;
			this.mDestroyedPermanently = true;
		}

		public function startUnwithering(): void {
			this.mState = STATE_BEING_UNWITHERED;
			this.mInQueueForAction = false;
			showLoadingBar();
			spendNeighborAction();
		}

		public function skipUnwithering(): void {
			if (Config.DEBUG_MODE) {}
			this.mState = STATE_WITHERED;
			this.mInQueueForAction = false;
			hideActingHealthBar();
		}

		public function isUnwitheringOver(): Boolean {
			return this.mState != STATE_BEING_UNWITHERED;
		}

		public function handleProductionUnwithered(): void {
			this.mProduction.setRemainingProductionTime(0);
			this.mState = STATE_PRODUCTION_READY;
		}

		public function startSpeedUp(): void {
			this.mState = STATE_BEING_SPEED_UP;
			this.mInQueueForAction = false;
			showLoadingBar();
			spendNeighborAction();
		}

		public function skipSpeedUp(): void {
			if (Config.DEBUG_MODE) {}
			this.mState = STATE_PRODUCING;
			this.mInQueueForAction = false;
			hideLoadingBar();
		}

		public function isSpeedUpOver(): Boolean {
			return this.mState != STATE_BEING_SPEED_UP;
		}

		public function handleProductionSpeedUp(): void {
			this.mProduction.speedUp();
		}

		override public function getMoveCostSupplies(): int {
			return mTileSize.x * mTileSize.y * GameState.mConfig.PlayerStartValues.Default.RelocateSupplyCost;
		}

		override public function isAlive(): Boolean {
			return this.mHealth > 0;
		}
	}
}