package game.gui.fireMission {
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import game.gui.IconLoader;
	import game.gui.StylizedHeaderClip;
	import game.gui.button.ArmyButton;
	import game.gui.button.ResizingIconButton;
	import game.gui.popups.PopUpWindow;
	import game.items.FireMissionItem;
	import game.items.Item;
	import game.items.ItemManager;
	import game.items.MapItem;
	import game.net.ServiceIDs;
	import game.player.GamePlayerProfile;
	import game.states.GameState;

	public class FireMissionDialog extends PopUpWindow {

		private static const PANEL_COUNT: int = 6;


		private var mPlayer: GamePlayerProfile;

		private var mGame: GameState;

		protected var mSlotContainner: MovieClip;

		private var mButtonClose: ArmyButton;

		private var mHeader: StylizedHeaderClip;

		private var mPanels: Array;

		private var mPage: int = 0;

		private var mCurrentStatFrame: FireMissionStatsFrame;

		private var mStatsDisabled: FireMissionStatsFrame;

		private var mStats: FireMissionStatsFrame;

		private var mButtonLaunch: ArmyButton;

		private var mButtonLaunchDisabled: ArmyButton;

		private var mButtonBuy: ResizingIconButton;

		private var mIconClip: MovieClip;

		private var launchable: Array;

		private var mCurrentMissionIndex: int;

		private var mSlotbounds: Rectangle;

		private var mSlotDragging: Boolean;

		private var mFireMissionItems: Array;

		private var mSlotHeight: int;

		private var mSlotStartY: int;

		public function FireMissionDialog() {
			var _loc3_: MovieClip = null;
			this.mSlotHeight = Config.FOR_IPHONE_PLATFORM ? 115 : 200;
			this.mSlotStartY = Config.FOR_IPHONE_PLATFORM ? -46 : -48;
			var _loc1_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_FULLSCREEN_NAME, "popup_newpowerup");
			super(new _loc1_(), false);
			this.mSlotContainner = mClip.getChildAt(2) as MovieClip;
			this.mGame = GameState.mInstance;
			this.mPlayer = this.mGame.mPlayerProfile;
			this.mHeader = new StylizedHeaderClip(mClip.getChildAt(13) as MovieClip, GameState.getText("FIRE_MISSION_HEADER"));
			this.mButtonClose = Utils.createBasicButton(mClip, "Button_Cancel", this.closedPressed);
			mouseEnabled = true;
			this.launchable = new Array();
			this.mPanels = new Array();
			var _loc2_: int = 0;
			while (_loc2_ < PANEL_COUNT) {
				_loc3_ = this.mSlotContainner.getChildAt(5 + (_loc2_ + 1)) as MovieClip;
				this.mPanels[_loc2_] = new FireMissionPanel(_loc3_, this.closedPressed);
				this.launchable[_loc2_] = true;
				_loc2_++;
			}
			this.initFireSlot();
			x = this.mGame.getStageWidth() >> 1;
			y = this.mGame.getStageHeight() >> 1;
			this.mSlotbounds = new Rectangle(this.mSlotContainner.x, this.mSlotContainner.y - this.mSlotContainner.height, 0, this.mSlotContainner.height);
			this.mSlotContainner.addEventListener(MouseEvent.MOUSE_DOWN, this.scrollHandler, false);
		}

		public function Activate(param1: Function): void {
			mDoneCallback = param1;
			this.refresh();
			this.mSlotContainner.y = this.mSlotStartY;
			this.setFireTab(0);
			doOpeningTransition();
		}

		/*
		CONFIG::BUILD_FOR_MOBILE_AIR {
			override public function scaleToScreen(): void {
				// Get the current stage width and height
				var stageWidth: Number = GameState.mInstance.getStageWidth();
				var stageHeight: Number = GameState.mInstance.getStageHeight();

				// Define the target size relative to the provided percentages
				var targetWidth: Number = stageWidth * 2;
				var targetHeight: Number = stageHeight * 2;

				// Calculate the scaling factors based on the clip's dimensions
				var scaleXFactor: Number = targetWidth / mClip.width;
				var scaleYFactor: Number = targetHeight / mClip.height;

				// Apply the smaller scaling factor to maintain aspect ratio
				var scaleFactor: Number = Math.min(scaleXFactor, scaleYFactor);
				mClip.scaleX = scaleFactor;
				mClip.scaleY = scaleFactor;
			}
		}
		*/

		public function initFireSlot(): void {
			this.mButtonLaunch = Utils.createBasicButton(mClip as DisplayObjectContainer, "button_launch_enabled", this.launchPressed);
			this.mButtonLaunchDisabled = Utils.createBasicButton(mClip as DisplayObjectContainer, "button_launch_disabled", null);
			this.mButtonLaunchDisabled.setEnabled(false);
			this.mStatsDisabled = new FireMissionStatsFrame(mClip.getChildByName("Powerup_Stats_Disabled") as DisplayObjectContainer, mClip);
			this.mStatsDisabled.hide();
			this.mStats = new FireMissionStatsFrame(mClip.getChildByName("Powerup_Stats_Enabled") as DisplayObjectContainer, mClip);
			this.mStats.hide();
			this.mIconClip = mClip.getChildByName("Item_Container") as MovieClip;
			this.mButtonBuy = Utils.createResizingIconButton(mClip as DisplayObjectContainer, "Button_Buy", this.buyPressed);
			this.mButtonBuy.setEnabled(false);
			this.mButtonBuy.setVisible(false);
		}

		private function showFireSlot(): void {
			if (!this.mButtonLaunchDisabled.getMovieClip().parent) {
				mClip.addChild(this.mButtonLaunchDisabled.getMovieClip());
			}
			if (!this.mButtonLaunch.getMovieClip().parent) {
				mClip.addChild(this.mButtonLaunch.getMovieClip());
			}
			this.mStats.show();
			this.mStatsDisabled.show();
		}

		private function hideFireSlot(): void {
			if (this.mButtonLaunchDisabled.getMovieClip().parent) {
				this.mButtonLaunchDisabled.getMovieClip().parent.removeChild(this.mButtonLaunchDisabled.getMovieClip());
			}
			if (this.mButtonLaunch.getMovieClip().parent) {
				this.mButtonLaunch.getMovieClip().parent.removeChild(this.mButtonLaunch.getMovieClip());
			}
			this.mStats.hide();
			this.mStatsDisabled.hide();
		}

		public function setupLaunchableIcon(param1: Sprite): void {
			param1.alpha = 1;
			param1.mouseEnabled = false;
			param1.mouseChildren = false;
		}

		public function setupIcon(param1: Sprite): void {
			param1.alpha = 0.5;
			param1.mouseEnabled = false;
			param1.mouseChildren = false;
		}

		private function setScreen(): void {
			var _loc3_: FireMissionPanel = null;
			this.mFireMissionItems.sort(this.sorter);
			var _loc1_: int = this.mPage * PANEL_COUNT;
			var _loc2_: int = 0;
			while (_loc2_ < PANEL_COUNT) {
				_loc3_ = this.mPanels[_loc2_];
				if (_loc2_ + _loc1_ < this.mFireMissionItems.length) {
					_loc3_.show();
					this.launchable[_loc2_ + _loc1_] = _loc3_.setData(this.mFireMissionItems[_loc2_ + _loc1_]);
				} else {
					_loc3_.hide();
				}
				_loc2_++;
			}
			if (this.mFireMissionItems.length > 0) {
				this.showFireSlot();
			} else {
				this.hideFireSlot();
			}
		}

		public function hasLaunchableFireMissions(): Boolean {
			var _loc2_: FireMissionPanel = null;
			this.refresh();
			var _loc1_: int = 0;
			while (_loc1_ < this.mPanels.length) {
				_loc2_ = this.mPanels[_loc1_];
				if (_loc1_ < this.mFireMissionItems.length) {
					if (_loc2_.setData(this.mFireMissionItems[_loc1_])) {
						return true;
					}
				}
				_loc1_++;
			}
			return false;
		}

		public function sorter(param1: FireMissionItem, param2: FireMissionItem): int {
			if (param1.mOrder > param2.mOrder) {
				return 1;
			}
			return -1;
		}

		public function setPageNum(): void {}

		public function refresh(param1: Boolean = true): void {
			var _loc2_: Object = null;
			this.mFireMissionItems = new Array();
			for each(_loc2_ in GameState.mConfig.FireMission) {
				if(_loc2_.Type == "FireMission"){ // Ignore pvp firemissions
					this.mFireMissionItems.push(ItemManager.getItem(_loc2_.ID, _loc2_.Type));
				}
			}
			if (param1) {
				this.mPage = 0;
			}
			this.setScreen();
			this.setPageNum();
		}

		public function useItem(param1: Item): void {
			var _loc2_: Object = null;
			if (Config.DEBUG_MODE) {}
			if (param1 is MapItem) {
				this.mGame.setFromInventory(param1 as MapItem);
				this.closeDialog();
			} else {
				this.mPlayer.mInventory.addItems(param1, -1);
				this.mPlayer.useItem(param1);
				_loc2_ = {
					"item_id": param1.mId,
					"item_type": ItemManager.getTableNameForItem(param1)
				};
				this.mGame.mServer.serverCallServiceWithParameters(ServiceIDs.USE_POWER_UP_FROM_INVENTORY, _loc2_, false);
				this.refresh();
			}
		}

		public function sellItem(param1: Item): void {
			this.mPlayer.mInventory.addItems(param1, -1);
			this.refresh();
		}

		private function addMoneyPressed(param1: MouseEvent): void {}

		private function closedPressed(param1: MouseEvent): void {
			this.closeDialog();
		}

		private function upPressed(param1: MouseEvent): void {
			this.setScreen();
			this.setPageNum();
			if (Config.DEBUG_MODE) {}
		}

		private function downPressed(param1: MouseEvent): void {
			this.setScreen();
			this.setPageNum();
			if (Config.DEBUG_MODE) {}
		}

		override public function close(): void {
			super.close();
			this.mPlayer = null;
			this.mGame = null;
		}

		protected function closeDialog(): void {
			this.mSlotContainner.removeEventListener(MouseEvent.MOUSE_DOWN, this.scrollHandler);
			this.mSlotContainner.removeEventListener(MouseEvent.MOUSE_UP, this.scrollHandler);
			this.mSlotContainner.removeEventListener(MouseEvent.ROLL_OUT, this.scrollHandler);
			if (mDoneCallback != null) {
				mDoneCallback((this as Object).constructor);
			}
		}

		public function mSlotAdjustment(): void {
			if (this.mSlotContainner.y < this.mSlotStartY - 5 * this.mSlotHeight + this.mSlotHeight / 2) {
				this.mSlotContainner.y = this.mSlotStartY - 5 * this.mSlotHeight;
				this.setFireTab(5);
			} else if (this.mSlotContainner.y < this.mSlotStartY - 4 * this.mSlotHeight + this.mSlotHeight / 2) {
				this.mSlotContainner.y = this.mSlotStartY - 4 * this.mSlotHeight;
				this.setFireTab(4);
			} else if (this.mSlotContainner.y < this.mSlotStartY - 3 * this.mSlotHeight + this.mSlotHeight / 2) {
				this.mSlotContainner.y = this.mSlotStartY - 3 * this.mSlotHeight;
				this.setFireTab(3);
			} else if (this.mSlotContainner.y < this.mSlotStartY - 2 * this.mSlotHeight + this.mSlotHeight / 2) {
				this.mSlotContainner.y = this.mSlotStartY - 2 * this.mSlotHeight;
				this.setFireTab(2);
			} else if (this.mSlotContainner.y < this.mSlotStartY - 1 * this.mSlotHeight + this.mSlotHeight / 2) {
				this.mSlotContainner.y = this.mSlotStartY - 1 * this.mSlotHeight;
				this.setFireTab(1);
			} else {
				this.mSlotContainner.y = this.mSlotStartY;
				this.setFireTab(0);
			}
		}

		private function setFireTab(param1: int): void {
			this.mCurrentMissionIndex = param1;
			var _loc2_: FireMissionItem = this.mFireMissionItems[param1] as FireMissionItem;
			if (this.launchable[param1]) {
				this.mStatsDisabled.hide();
				this.mStats.show();
				this.mButtonLaunch.setVisible(true);
				this.mButtonLaunchDisabled.setVisible(false);
				this.mButtonBuy.setEnabled(false);
				this.mButtonBuy.setVisible(false);
				this.mCurrentStatFrame = this.mStats;
				if (_loc2_.mFireMissionIcon) {
					IconLoader.addIconPicture(this.mIconClip, Config.DIR_DATA + _loc2_.mFireMissionIcon, this.setupLaunchableIcon);
				}
			} else {
				this.mStatsDisabled.show();
				this.mStats.hide();
				this.mButtonLaunch.setVisible(false);
				this.mButtonLaunchDisabled.setVisible(true);
				this.mButtonBuy.setEnabled(true);
				this.mButtonBuy.setDefaultWidth(true);
				this.mButtonBuy.setText("" + _loc2_.mUnlockCost);
				this.mButtonBuy.setIcon(ItemManager.getItem("Premium", "Resource"));
				this.mButtonBuy.setVisible(true);
				this.mCurrentStatFrame = this.mStatsDisabled;
				if (_loc2_.mFireMissionIcon) {
					IconLoader.addIconPicture(this.mIconClip, Config.DIR_DATA + _loc2_.mFireMissionIcon, this.setupIcon);
				}
			}
			this.mButtonLaunch.setText(GameState.getText("FIRE_MISSION_LAUNCH"));
			this.mButtonLaunchDisabled.setText(GameState.getText("FIRE_MISSION_LAUNCH"));
			this.mCurrentStatFrame.setItem(this.mFireMissionItems[param1]);
		}

		protected function scrollHandler(param1: MouseEvent): void {
			param1.updateAfterEvent();
			if (param1.type == MouseEvent.MOUSE_DOWN) {
				this.mSlotContainner.startDrag(false, this.mSlotbounds);
				this.mSlotDragging = true;
				this.mSlotContainner.addEventListener(MouseEvent.MOUSE_UP, this.scrollHandler);
				this.mSlotContainner.addEventListener(MouseEvent.ROLL_OUT, this.scrollHandler);
			} else if (param1.type == MouseEvent.MOUSE_UP) {
				this.mSlotContainner.removeEventListener(MouseEvent.MOUSE_UP, this.scrollHandler);
				this.mSlotContainner.removeEventListener(MouseEvent.ROLL_OUT, this.scrollHandler);
				this.mSlotContainner.stopDrag();
				this.mSlotDragging = false;
				this.mSlotAdjustment();
			} else if (param1.type == MouseEvent.ROLL_OUT) {
				this.mSlotContainner.removeEventListener(MouseEvent.MOUSE_UP, this.scrollHandler);
				this.mSlotContainner.removeEventListener(MouseEvent.ROLL_OUT, this.scrollHandler);
				this.mSlotContainner.stopDrag();
				this.mSlotDragging = false;
				this.mSlotAdjustment();
			}
		}

		public function launchPressed(param1: MouseEvent): void {
			if (GameState.mInstance.mPlayerProfile.mEnergy <= 0) {
				GameState.mInstance.mHUD.openOutOfEnergyWindow();
				this.closeDialog();
			} else {
				GameState.mInstance.changeState(GameState.STATE_PLACE_FIRE_MISSION);
				GameState.mInstance.mFireMisssionToBePlaced = this.mFireMissionItems[this.mCurrentMissionIndex];
				this.closeDialog();
			}
		}

		public function buyPressed(param1: MouseEvent): void {
			var _loc2_: FireMissionItem = null;
			if (GameState.mInstance.mPlayerProfile.mEnergy <= 0) {
				GameState.mInstance.mHUD.openOutOfEnergyWindow();
				this.closeDialog();
			} else {
				_loc2_ = this.mFireMissionItems[this.mCurrentMissionIndex] as FireMissionItem;
				if (GameState.mInstance.mPlayerProfile.getPremium() >= _loc2_.mUnlockCost) {
					_loc2_.mlaunchWithGold = true;
					GameState.mInstance.changeState(GameState.STATE_PLACE_FIRE_MISSION);
					GameState.mInstance.mFireMisssionToBePlaced = _loc2_;
					this.closeDialog();
				} else {
					GameState.mInstance.mHUD.openBuyGoldScreen();
					this.closeDialog();
				}
			}
		}
	}
}