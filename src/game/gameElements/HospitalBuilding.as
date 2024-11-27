package game.gameElements {
	import com.adobe.utils.StringUtil;
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import game.gui.TooltipHealth;
	import game.isometric.GridCell;
	import game.isometric.IsometricScene;
	import game.isometric.ObjectLoader;
	import game.items.MapItem;
	import game.items.HospitalItem;
	import game.states.GameState;
	import game.characters.PlayerUnit;
	import game.utils.TimeUtils

	public class HospitalBuilding extends PlayerBuildingObject {


		private var mReadyToHeal: Boolean;

		private var mTimeUntilRefill: int;

		private var mCooldown: int;

		private var mHealPower: int;
		
		public var mAttackRange:int;
		
		public var mPower:int;
		
	    public var mReadyText:String;
	   
	    public var mNotReadyText:String;

		public function HospitalBuilding(param1: int, param2: IsometricScene, param3: MapItem, param4: Point, param5: DisplayObject = null, param6: String = null) {
			super(param1, param2, param3, param4, param5, param6);
			mWalkable = false;
			mState = STATE_READY;
			this.mReadyToHeal = false;
			var itemStats: HospitalItem = param3 as HospitalItem
			this.mCooldown = itemStats.mCooldown;
			this.mHealPower = itemStats.mHealPower;
			this.mAttackRange = itemStats.mAttackRange;
			this.mPower = itemStats.mPower;
			this.mReadyText = itemStats.mReadyText;
			this.mNotReadyText = itemStats.mNotReadyText;
		}

		public function readyToHeal(): Boolean {
			if (mHealth < mMaxHealth) {
				return false;
			}
			return this.mReadyToHeal;
		}

		public function checkNeighbours() {
			var neighbours: Array = GameState.mInstance.searchNearbyUnits(getCell(), 1, 2, 2, false);
			var neighbour: PlayerUnit = null;
			var i;
			for (i in neighbours) {
				neighbour = neighbours[i] as PlayerUnit;
				if (neighbour.getHealth() < neighbour.mMaxHealth) {
					neighbour.setHealth(Math.min(neighbour.mMaxHealth, neighbour.getHealth() + this.mHealPower));
					this.mReadyToHeal = false;
					this.mTimeUntilRefill = this.mCooldown * 1000;
					this.updateGraphics(mHealth);
				}
			}
		}

		override public function setHealth(param1: int): void {
			super.setHealth(param1);
			this.updateGraphics(mHealth);
		}

		override public function graphicsLoaded(param1: Sprite): void {
			super.graphicsLoaded(param1);
			this.updateGraphics(mHealth);
		}

		override public function logicUpdate(param1: int): Boolean {
			super.logicUpdate(param1);
			if (mHealth < mMaxHealth) { // Building damaged, reset timer
				// to-do: don't reset it every frame
				this.mReadyToHeal = false;
				this.mTimeUntilRefill = this.mCooldown * 1000;
			}
			if (!this.mReadyToHeal) {
				this.mTimeUntilRefill -= param1
				if (this.mTimeUntilRefill <= 0) {
					this.mReadyToHeal = true;
					this.mTimeUntilRefill = 0;
					this.updateGraphics(mHealth);
				}
			}
			return false;
		}

		private function updateGraphics(param1: int): void {
			var _loc3_: Sprite = null;
			var _loc4_: String = null;
			var _loc5_: DCResourceManager = null;
			var _loc6_: String = null;
			var _loc7_: String = null;
			var _loc8_: Object = null;
			if (!mGraphicsLoaded) {
				return;
			}
			var _loc2_: ObjectLoader = new ObjectLoader();
			if (mHealth <= 0) {
				_loc4_ = "swf/buildings_player";
				if ((_loc5_ = DCResourceManager.getInstance()).isLoaded(_loc4_)) {
					removeSprite();
					_loc6_ = "building_destroyed_" + getTileSize().x + "x" + getTileSize().y;
					_loc7_ = "InnerMovieClip";
					_loc3_ = _loc2_[_loc7_]("swf/buildings_player", _loc6_);
					addSprite(_loc3_);
				} else {
					_loc5_.addEventListener(_loc4_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE, this.ruinsLoadingFinished, false, 0, true);
					if (!_loc5_.isAddedToLoadingList(_loc4_)) {
						_loc5_.load(Config.DIR_DATA + _loc4_ + ".swf", _loc4_, null, false);
					}
				}
			} else {
				_loc8_ = mContainer.getChildAt(0);
				if (param1 == 0) { // Ruined building *congratulations!*
					_loc3_ = _loc2_[mItem.mLoader](mItem.getIconGraphicsFile(), mItem.getIconGraphics());
					removeSprite();
					addSprite(_loc3_);
				} else if (mHealth < mMaxHealth) {
					_loc8_.gotoAndStop(3); // damaged building
				} else if (this.mReadyToHeal) {
					_loc8_.gotoAndStop(2); // Ready to heal
				} else {
					_loc8_.gotoAndStop(1); // Idle
				}
			}
		}

		override public function updateTooltip(param1: int, param2: TooltipHealth): void {
			param2.setTitleText(mItem.mName);
			param2.setHealth(this.mHealth, this.mMaxHealth);
			if (!isFullHealth()) {
				if (mState == STATE_RUINS) {
					param2.setDetailsText(GameState.getText("BUILDING_STATUS_RUINS"));
				} else {
					param2.setDetailsText(GameState.getText("BUILDING_STATUS_DAMAGED"));
				}
			} else if (this.mReadyToHeal) {
				param2.setDetailsText(this.mReadyText);
			} else {
				param2.setDetailsText(GameState.replaceParameters(this.mNotReadyText, [TimeUtils.getCountDownTime(this.mTimeUntilRefill)]));
			}
		}

		override public function isMovable(): Boolean {
			if (mState == STATE_RUINS) {
				return false;
			}
			return mMovable;
		}

		override public function setupFromServer(param1: Object): void {
			super.setupFromServer(param1);
			if (param1.next_action_at != null) {
				this.mTimeUntilRefill = param1.next_action_at * 1000
			} else {
				this.mTimeUntilRefill = this.mCooldown * 1000;
			}
		}

		public function getHealCostSupplies(): int {
			return (mItem as HospitalItem).mHealCostSupplies * (mMaxHealth - mHealth) / mMaxHealth;
		}

		public function getRefillTimer(): int {
			return this.mTimeUntilRefill;
		}

		protected function ruinsLoadingFinished(param1: Event): void {
			DCResourceManager.getInstance().removeEventListener(param1.type, this.ruinsLoadingFinished);
			this.updateGraphics(mHealth);
		}
	}
}