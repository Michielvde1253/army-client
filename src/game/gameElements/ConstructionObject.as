package game.gameElements {
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.actions.Action;
	import game.actions.WorkOnBuildingAction;
	import game.gui.TooltipHealth;
	import game.isometric.GridCell;
	import game.isometric.IsometricScene;
	import game.isometric.ObjectLoader;
	import game.items.ConstructionItem;
	import game.items.Item;
	import game.items.ItemManager;
	import game.items.MapItem;
	import game.magicBox.MagicBoxTracker;
	import game.missions.MissionManager;
	import game.net.ServiceIDs;
	import game.player.GamePlayerProfile;
	import game.player.Inventory;
	import game.states.GameState;

	public class ConstructionObject extends PlayerBuildingObject {


		private var mItemCnt: Array;

		private var mBuildingStepsDone: int;

		private var mBuildingStepsInQue: int;

		private var mBuildingStepsRequired: int;

		private var mTimeSinceBonusCollected: int;

		public var mHasBeenCompleted: Boolean;

		private var mConstructionAnimation: MovieClip;

		private var mReadyAnimation: Sprite;

		public function ConstructionObject(param1: int, param2: IsometricScene, param3: MapItem, param4: Point, param5: DisplayObject = null, param6: String = null) {
			super(param1, param2, param3, param4, param5, param6);
			this.mItemCnt = new Array();
			mState = STATE_BUILD_CLICKS_NEEDED;
			this.mBuildingStepsRequired = ConstructionItem(param3).mBuildSteps;
			this.checkConstructionState();
			if (mBuildingStepsRequired == 0) { // Gold factory: finish building immediately
				mState = STATE_READY;
				this.setCompleted(true);
				this.setFrame();
				GameState.mInstance.mPlayerProfile.updateUnitCaps();
				this.setupProduction();
			}
		}

		override public function graphicsLoaded(param1: Sprite): void {
			super.graphicsLoaded(param1);
			this.mReadyAnimation = param1;
			var _loc2_: String = ConstructionItem(mItem).mConstructionAsset;
			var _loc3_: ObjectLoader = mScene.getObjectLoader();
			this.mConstructionAnimation = _loc3_[mItem.mLoader](mItem.getIconGraphicsFile(), _loc2_);
			this.updateGraphics(mHealth);
			this.setFrame();
		}

		private function setCompleted(param1: Boolean): void {
			var _loc2_: int = 0;
			var _loc3_: int = 0;
			if (this.mHasBeenCompleted != param1) {
				_loc2_ = this.getSightRangeAccordingToCondition();
				this.mHasBeenCompleted = param1;
				_loc3_ = this.getSightRangeAccordingToCondition();
				if (_loc3_ != _loc2_) {
					mScene.decrementViewersForBuilding(this, _loc2_);
					mScene.incrementViewersForBuilding(this, _loc3_);
				}
			}
		}

		override public function logicUpdate(param1: int): Boolean {
			super.logicUpdate(param1);
			switch (mState) {
				case STATE_WORKING_ON_BUILDING:
					if (mActionDelayTimer <= 0) {
						++this.mBuildingStepsDone;
						--this.mBuildingStepsInQue;
						this.checkConstructionState();
					}
			}
			return false;
		}

		override public function setPos(param1: int, param2: int, param3: int): void {
			super.setPos(param1, param2, param3);
			this.setFrame();
		}

		override public function setupFromServer(param1: Object): void {
			super.setupFromServer(param1);
			this.mBuildingStepsDone = param1.clicks;
			if (param1.status == "SETUP") {
				this.checkConstructionState();
			} else {
				this.mHasBeenCompleted = true;
				mState = STATE_READY;
				this.setupProduction();
				mProduction.setRemainingProductionTime(param1.next_action_at);
				if (mHealth <= 0) {
					mState = STATE_RUINS;
				}
			}
			this.setFrame();
		}

		override public function handleProductionHarvested(): void {
			this.setupProduction();
		}

		private function setupProduction(): void {
			setProduction(mItem.mId);
			mState = STATE_PRODUCING;
		}

		public function startWorkingTask(): void {
			showLoadingBar();
			mState = STATE_WORKING_ON_BUILDING;
			this.updateClickQueCount();
		}

		public function isWorkingTaskFinished(): Boolean {
			this.updateClickQueCount();
			if (mState == STATE_BUILD_CLICKS_NEEDED || mState == STATE_PARTS_NEEDED || mState == STATE_PARTS_READY) {
				--this.mBuildingStepsInQue;
				hideLoadingBar();
				this.setFrame();
				return true;
			}
			return false;
		}

		public function skipWorkingTask(): void {
			this.updateClickQueCount();
			hideLoadingBar();
			mState = STATE_BUILD_CLICKS_NEEDED;
		}

		private function setFrame(): void {
			var _loc1_: int = 0;
			if (!mGraphicsLoaded || mContainer.numChildren == 0 || mState == STATE_RUINS) {
				return;
			}
			if (!this.mHasBeenCompleted) {
				addSprite(this.mConstructionAnimation);
				_loc1_ = 1 + this.mBuildingStepsDone / 2;
				if (_loc1_ != this.mConstructionAnimation.currentFrame) {
					this.mConstructionAnimation.gotoAndStop(_loc1_);
				} else {
					this.mConstructionAnimation.stop();
				}
			} else {
				addSprite(this.mReadyAnimation);
			}
		}

		public function getItemCount(): Array {
			return this.mItemCnt;
		}

		private function getConstructionWhackPercentage(): int {
			return 100 * (this.mBuildingStepsDone / this.mBuildingStepsRequired);
		}

		public function checkConstructionState(param1: Event = null): void {
			var _loc3_: Array = null;
			var _loc4_: Array = null;
			var _loc6_: Object = null;
			var _loc7_: Item = null;
			if (mState == STATE_READY || this.mHasBeenCompleted) {
				return;
			}
			if (this.mBuildingStepsDone < this.mBuildingStepsRequired) {
				mState = STATE_BUILD_CLICKS_NEEDED;
				return;
			}
			var _loc2_: Inventory = GameState.mInstance.mPlayerProfile.mInventory;
			_loc3_ = (mItem as ConstructionItem).mIngredientRequiredTypes;
			_loc4_ = (mItem as ConstructionItem).mIngredientRequiredAmounts;
			mState = STATE_PARTS_READY;
			var _loc5_: int = 0;
			while (_loc5_ < _loc3_.length) {
				_loc6_ = _loc3_[_loc5_] as Object;
				_loc7_ = ItemManager.getItem(_loc6_.ID, _loc6_.Type);
				this.mItemCnt[_loc5_] = _loc2_.getNumberOfItems(_loc7_);
				if (this.mItemCnt[_loc5_] >= _loc4_[_loc5_]) {
					this.mItemCnt[_loc5_] = _loc4_[_loc5_];
				} else {
					mState = STATE_PARTS_NEEDED;
				}
				_loc5_++;
			}
		}

		public function finishConstruction(): void {
			var _loc8_: Object = null;
			var _loc9_: Item = null;
			if (mState != STATE_PARTS_READY) {
				Utils.LogError("Trying to finish a building without ready parts");
				return;
			}
			var _loc1_: GamePlayerProfile = GameState.mInstance.mPlayerProfile;
			var _loc2_: Inventory = _loc1_.mInventory;
			var _loc3_: Array = ConstructionItem(mItem).mIngredientRequiredTypes;
			var _loc4_: Array = ConstructionItem(mItem).mIngredientRequiredAmounts;
			var _loc5_: int = 0;
			while (_loc5_ < _loc3_.length) {
				_loc8_ = _loc3_[_loc5_] as Object;
				_loc9_ = ItemManager.getItem(_loc8_.ID, _loc8_.Type);
				_loc2_.addItems(_loc9_, -_loc4_[_loc5_]);
				_loc5_++;
			}
			hideLoadingBar();
			mState = STATE_READY;
			this.setCompleted(true);
			this.setFrame();
			_loc1_.updateUnitCaps();
			this.setupProduction();
			MissionManager.increaseCounter("CompleteBuilding", this, 1);
			var _loc6_: GridCell = getCell();
			var _loc7_: Object = {
				"coord_x": _loc6_.mPosI,
				"coord_y": _loc6_.mPosJ
			};
			GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.COMPLETE_BUILDING, _loc7_, false);
			MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_ECONOMY, MagicBoxTracker.TYPE_GAME_ACTION, MagicBoxTracker.LABEL_CONSTRUCTION_FINISHED, MagicBoxTracker.paramsObj(mItem.mType, mItem.mId));
			if (Config.DEBUG_MODE) {}
		}

		override protected function getStateText(): String {
			if (GameState.mInstance.visitingFriend()) {
				return mItem.getDescription();
			}
			switch (mState) {
				case STATE_PRODUCING:
					return GameState.getText("BUILDING_STATUS_PRODUCING_BUILDING", [getTimeLeftString()]);
				case STATE_IDLE:
					return GameState.getText("BUILDING_STATUS_IDLE_BUILDING");
				case STATE_PRODUCTION_READY:
					return GameState.getText("BUILDING_STATUS_PRODUCTION_READY_BUILDING");
				case STATE_BEING_HARVESTED:
					return GameState.getText("BUILDING_STATUS_BEING_HARVESTED_BUILDING");
				case STATE_BUILD_CLICKS_NEEDED:
				case STATE_WORKING_ON_BUILDING:
					return GameState.getText("BUILDING_STATUS_CLICKS_NEEDED", [this.mBuildingStepsDone + this.mBuildingStepsInQue, this.mBuildingStepsRequired]);
				case STATE_PARTS_NEEDED:
					return GameState.getText("BUILDING_STATUS_PARTS_NEEDED");
				case STATE_PARTS_READY:
					return GameState.getText("BUILDING_STATUS_PARTS_READY");
				case STATE_READY:
					return GameState.getText("BUILDING_STATUS_READY");
				default:
					return super.getStateText();
			}
		}

		override public function isReadyForHarvesting(): Boolean {
			return mState == STATE_PRODUCTION_READY && this.isFullHealth() && !GameState.mInstance.visitingFriend();
		}

		override public function MousePressed(param1: MouseEvent): void {
			if (!GameState.mInstance.visitingFriend()) {
				super.MousePressed(param1);
				if (!(mState == STATE_READY || mState == STATE_PRODUCING)) {
					if (mState == STATE_BUILD_CLICKS_NEEDED || mState == STATE_WORKING_ON_BUILDING) {
						this.updateClickQueCount();
						if (this.mBuildingStepsDone + this.mBuildingStepsInQue < this.mBuildingStepsRequired) {
							GameState.mInstance.queueAction(new WorkOnBuildingAction(this));
						}
						this.updateClickQueCount();
					} else if (mState == STATE_PARTS_NEEDED || mState == STATE_PARTS_READY) {
						GameState.mInstance.mHUD.openAskPartsDialog(this);
					}
				}
			}
		}

		override public function getSightRangeAccordingToCondition(): int {
			if (this.mHasBeenCompleted) {
				return super.getSightRangeAccordingToCondition();
			}
			return 0;
		}

		public function updateClickQueCount(): void {
			var _loc3_: Action = null;
			var _loc1_: Array = GameState.mInstance.mMainActionQueue.mActions;
			var _loc2_: Action = GameState.mInstance.mCurrentAction;
			this.mBuildingStepsInQue = 0;
			var _loc4_: int = int(_loc1_.length);
			var _loc5_: int = 0;
			while (_loc5_ < _loc4_) {
				_loc3_ = _loc1_[_loc5_] as Action;
				if (_loc3_ is WorkOnBuildingAction && _loc3_.mTarget == this) {
					++this.mBuildingStepsInQue;
				}
				_loc5_++;
			}
			if (_loc2_ && _loc2_ is WorkOnBuildingAction && _loc2_.mTarget == this) {
				++this.mBuildingStepsInQue;
			}
		}

		override public function isHarvestingOver(): Boolean {
			return super.isHarvestingOver() || mState == STATE_READY;
		}

		public function getHealCostSupplies(): int {
			return ConstructionItem(mItem).mHealCostSupplies * (mMaxHealth - mHealth) / mMaxHealth;
		}

		override public function setHealth(param1: int): void {
			var _loc2_: int = mHealth;
			super.setHealth(param1);
			if (mHealth <= 0) {
				mState = STATE_RUINS;
			} else if (mProduction) {
				mState = STATE_PRODUCING;
			} else {
				this.checkConstructionState();
			}
			this.updateGraphics(_loc2_);
		}

		private function updateGraphics(param1: int): void {
			var _loc3_: Sprite = null;
			var _loc4_: String = null;
			var _loc5_: DCResourceManager = null;
			var _loc6_: int = 0;
			var _loc7_: int = 0;
			var _loc8_: String = null;
			var _loc9_: String = null;
			if (!mGraphicsLoaded) {
				return;
			}
			var _loc2_: ObjectLoader = new ObjectLoader();
			if (mHealth <= 0) {
				_loc4_ = "swf/buildings_player";
				if ((_loc5_ = DCResourceManager.getInstance()).isLoaded(_loc4_)) {
					removeSprite();
					_loc6_ = getTileSize().x;
					_loc7_ = getTileSize().y;
					_loc8_ = "building_destroyed_" + _loc6_ + "x" + _loc7_;
					_loc9_ = "InnerMovieClip";
					_loc3_ = _loc2_[_loc9_]("swf/buildings_player", _loc8_);
					addSprite(_loc3_);
				} else {
					_loc5_.addEventListener(_loc4_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE, this.ruinsLoadingFinished, false, 0, true);
					if (!_loc5_.isAddedToLoadingList(_loc4_)) {
						_loc5_.load(Config.DIR_DATA + _loc4_ + ".swf", _loc4_, null, false);
					}
				}
			} else if (param1 == 0) {
				_loc3_ = _loc2_[mItem.mLoader](mItem.getIconGraphicsFile(), mItem.getIconGraphics());
				removeSprite();
				addSprite(_loc3_);
			}
		}

		override public function updateTooltip(param1: int, param2: TooltipHealth): void {
			param2.setTitleText(mItem.mName);
			param2.setHealth(mHealth, mMaxHealth);
			if (!this.isFullHealth()) {
				if (mState == STATE_RUINS) {
					param2.setDetailsText(GameState.getText("BUILDING_STATUS_RUINS"));
				} else if (mState == STATE_PRODUCTION_READY) {
					param2.setDetailsText(GameState.getText("BUILDING_STATUS_DAMAGED_PRODUCTION_READY"));
				} else {
					param2.setDetailsText(GameState.getText("BUILDING_STATUS_DAMAGED"));
				}
			} else {
				param2.setDetailsText(this.getStateText());
			}
		}

		override public function isFullHealth(): Boolean {
			return mHealth == mMaxHealth;
		}

		override public function isMovable(): Boolean {
			if (mState == STATE_RUINS) {
				return false;
			}
			return mMovable;
		}

		protected function ruinsLoadingFinished(param1: Event): void {
			DCResourceManager.getInstance().removeEventListener(param1.type, this.ruinsLoadingFinished);
			this.updateGraphics(mHealth);
		}

		public function getBuildingStepsDone(): int {
			return this.mBuildingStepsDone;
		}
	}
}