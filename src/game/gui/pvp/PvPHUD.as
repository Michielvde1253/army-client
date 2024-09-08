package game.gui.pvp {
	import com.dchoc.GUI.DCButton;
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import game.characters.EnemyUnit;
	import game.characters.PlayerUnit;
	import game.characters.PvPEnemyUnit;
	import game.gameElements.DebrisObject;
	import game.gameElements.EnemyInstallationObject;
	import game.gameElements.PlayerBuildingObject;
	import game.gameElements.PlayerInstallationObject;
	import game.gameElements.PowerUpObject;
	import game.gameElements.ResourceBuildingObject;
	import game.gui.AutoTextField;
	import game.gui.CursorManager;
	import game.gui.DCWindow;
	import game.gui.DisplayObjectTransition;
	import game.gui.HUDInterface;
	import game.gui.ShopDialog;
	import game.gui.TooltipHUD;
	import game.gui.TooltipHealth;
	import game.gui.button.ArmyButton;
	import game.gui.inventory.InventoryDialog;
	import game.gui.popups.BuyMoneyWindow;
	import game.gui.popups.CollectionTradedWindow;
	import game.gui.popups.EnemyOutOfRangeWindow;
	import game.gui.popups.ErrorWindow;
	import game.gui.popups.HiddenErrorWindow;
	import game.gui.popups.OutOfCashWindow;
	import game.gui.popups.OutOfEnergyWindow;
	import game.gui.popups.OutOfSuppliesWindow;
	import game.gui.popups.PopUpManager;
	import game.gui.popups.PopUpWindow;
	import game.gui.popups.SupplyCapFullWindow;
	import game.gui.popups.TipWindow;
	import game.gui.popups.ToasterWindow;
	import game.gui.popups.TutorialWindow;
	import game.isometric.characters.IsometricCharacter;
	import game.isometric.elements.Renderable;
	import game.items.ItemCollectionItem;
	import game.missions.Mission;
	import game.missions.MissionManager;
	import game.net.ErrorObject;
	import game.net.FriendsCollection;
	import game.player.GamePlayerProfile;
	import game.sound.ArmySoundManager;
	import game.states.GameState;

	public class PvPHUD extends Sprite implements HUDInterface {

		private static const DEBUG_HUD: Boolean = false;

		private static var smTooltipTIDLinkage: Array;


		private var mGame: GameState;

		private var mHudTooltip: TooltipHUD;

		private var mIngameHUDClip: MovieClip;

		private var mSettingsButtonsBar: MovieClip;

		private var mButtonToggleSound: ArmyButton;

		private var mButtonToggleSoundDisabled: ArmyButton;

		private var mButtonToggleMusic: ArmyButton;

		private var mButtonToggleMusicDisabled: ArmyButton;

		private var mButtonToggleQuality: ArmyButton;

		private var mButtonToggleQualityDisabled: ArmyButton;

		private var mButtonToggleFullScreen: ArmyButton;

		private var mButtonToggleFullScreenDisabled: ArmyButton;

		private var mZoomFrame: MovieClip;

		private var mButtonZoomIn: ArmyButton;

		private var mButtonZoomOut: ArmyButton;

		private var mZoomScale: MovieClip;

		public var mCurrentZoomStep: int;

		private var mTurnChangeClip: Sprite;

		private var mTurnChangeText: TextField;

		private var keyCoordinates: Array;

		private var mBottomFrame: MovieClip;

		private var mStatusFrame: MovieClip;

		private var mButtonRetreat: ArmyButton;

		private var mButtonRetreatText: TextField;

		private var mTurnNumberText: AutoTextField;

		private var mActionsLeftText: AutoTextField;

		public var mBoosterBar: PvPBoosterBar;

		public var mPlayerPanel: PvPFighterPanel;

		public var mEnemyPanel: PvPFighterPanel;

		private var mCurrentPopup: PopUpWindow;

		private var mFirstUpdate: Boolean = true;

		public var mBlock: Boolean = false;

		private var mTooltipActivationTimer: int;

		private const mTooltipActivationMaxTime: int = 500;

		private var mTooltipActivatedBefore: Boolean;

		private var mFileBeingLoaded: String;

		private var mDialogClass: Class;

		private var mDialogParameters: Array;

		private var mProperty: Object;

		private var mModal: Boolean;

		public var mTextUpdateRequired: Boolean = true;

		private const TOOLBOX_TOP_Y: int = 330;

		private const TOOLBOX_BOTTOM_Y: int = 470;

		public var mFriendlyTooltip: TooltipHealth;

		public var mDetailsTooltip: TooltipHealth;

		public var mEnemyTooltip: TooltipHealth;

		public var mBuildingTooltip: TooltipHealth;

		public var mAttackTooltip: TooltipHealth;

		public var mEnemyBuildingTooltip: TooltipHealth;

		public var mBuildingWaterPlantTooltip: TooltipHealth;

		public var mInfoTooltip: TooltipHealth;

		public function PvPHUD(param1: GameState) {
			super();
			this.mGame = param1;
			this.createHUD();
			this.initHudTexts();
			this.installTooltip();
		}

		public function logicUpdate(param1: int): void {
			if (this.mFirstUpdate) {}
			if (this.mTextUpdateRequired) {
				this.updateStatusTexts();
				this.mTextUpdateRequired = false;
			}
			var _loc2_: GamePlayerProfile = this.mGame.mPlayerProfile;
			if (this.mTooltipActivatedBefore && !this.mHudTooltip.mVisible) {
				this.mTooltipActivationTimer += param1;
				if (this.mTooltipActivationTimer >= this.mTooltipActivationMaxTime) {
					this.mTooltipActivatedBefore = false;
					this.mTooltipActivationTimer = 0;
				}
			}
		}

		private function initHudTexts(): void {}

		public function iconLoaded(param1: Sprite): void {
			Utils.scaleIcon(param1, 50, 50);
		}

		public function closeDialog(param1: Class): void {
			var _loc4_: String = null;
			var _loc2_: DCWindow = PopUpManager.getPopUp(param1);
			var _loc3_: Function = Object(_loc2_).getCloseAnimation;
			if (_loc2_ is PopUpWindow || _loc3_ != null) {
				if (_loc4_ = String(Object(_loc2_).getCloseAnimation())) {
					new DisplayObjectTransition(_loc4_, _loc2_, DisplayObjectTransition.TYPE_DISAPPEAR);
				}
			}
			_loc2_.close();
			PopUpManager.releasePopUp(param1);
			MissionManager.increaseCounter("Close", _loc2_, 1);
		}

		public function triggerShopOpening(param1: String, param2: String = "pvp"): void {
			this.openShopDialog(ShopDialog, "FoodShop", param1, param2);
		}

		private function openShopDialog(param1: Class, param2: String, param3: String, param4: String): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_FULLSCREEN_NAME, ShopDialog, [this.closeDialog, param3, param4]);
			this.cancelTools();
		}

		public function createHUD(): void {
			DCButton.TRIGGER_AT_MOUSE_UP = true;
			var _loc1_: Class = DCResourceManager.getInstance().getSWFClass("swf/pvp_interface", "hud_pvp");
			this.mIngameHUDClip = new _loc1_();
			this.mIngameHUDClip.x = Config.SCREEN_WIDTH >> 1;
			addChild(this.mIngameHUDClip);
			Utils.CallForAllChildren(this, Utils.disableMouse, null);
			this.mBottomFrame = this.mIngameHUDClip.getChildByName("Powerups") as MovieClip;
			this.mStatusFrame = this.mIngameHUDClip.getChildByName("Status") as MovieClip;
			this.mSettingsButtonsBar = this.mIngameHUDClip.getChildByName("Settings") as MovieClip;
			this.mZoomFrame = this.mIngameHUDClip.getChildByName("Zoom_Panel") as MovieClip;
			var _loc2_: AutoTextField = new AutoTextField(this.mStatusFrame.getChildByName("Text_Actions_Left") as TextField);
			_loc2_.setText(GameState.getText("PVP_ACTIONS_LEFT"));
			var _loc3_: AutoTextField = new AutoTextField(this.mStatusFrame.getChildByName("Text_Turn") as TextField);
			_loc3_.setText(GameState.getText("PVP_TURN"));
			this.mTurnNumberText = new AutoTextField(this.mStatusFrame.getChildByName("Text_Turn_Value") as TextField);
			this.mActionsLeftText = new AutoTextField(this.mStatusFrame.getChildByName("Text_Actions_Value") as TextField);
			this.mButtonRetreat = this.addButton(this.mStatusFrame, "Button_Quit", this.buttonRetreatPressed);
			this.updateStatusTexts();
			this.mBoosterBar = new PvPBoosterBar(this.mBottomFrame);
			this.mPlayerPanel = new PvPFighterPanel(this.mIngameHUDClip.getChildByName("Player_Card") as Sprite, FriendsCollection.smFriends.GetThePlayer(), GameState.getText("PVP_PLAYER_TURN"));
			this.mEnemyPanel = new PvPFighterPanel(this.mIngameHUDClip.getChildByName("Opponent_Card") as Sprite, FriendsCollection.smFriends.GetThePlayer(), GameState.getText("PVPV_ENEMY_TURN"));
			this.mButtonToggleMusic = this.addButton(this.mSettingsButtonsBar, "Button_Music", this.ToggleMusicClicked);
			this.mButtonToggleMusicDisabled = this.addButton(this.mSettingsButtonsBar, "Button_Music_Disabled", this.ToggleMusicClicked);
			this.mButtonToggleSound = this.addButton(this.mSettingsButtonsBar, "Button_Sounds", this.ToggleSndFxClicked);
			this.mButtonToggleSoundDisabled = this.addButton(this.mSettingsButtonsBar, "Button_Sounds_Disabled", this.ToggleSndFxClicked);
			this.mButtonToggleQuality = this.addButton(this.mSettingsButtonsBar, "Button_Quality", this.ToggleQualityClicked);
			this.mButtonToggleQualityDisabled = this.addButton(this.mSettingsButtonsBar, "Button_Quality_Disabled", this.ToggleQualityClicked);
			this.mButtonToggleFullScreen = this.addButton(this.mSettingsButtonsBar, "Button_Fullscreen", this.ToggleFullscreenClicked);
			this.mButtonToggleFullScreenDisabled = this.addButton(this.mSettingsButtonsBar, "Button_Fullscreen_Disabled", this.ToggleFullscreenClicked);
			this.updateToggleButtonStates();
			this.mCurrentZoomStep = 0;
			this.mButtonZoomIn = this.addButton(this.mZoomFrame, "Button_Zoom_In", this.buttonZoomInPressed);
			this.mButtonZoomOut = this.addButton(this.mZoomFrame, "Button_Zoom_Out", this.buttonZoomOutPressed);
			this.resize(GameState.mInstance.getStageWidth(), GameState.mInstance.getStageHeight());
		}

		private function updateStatusTexts(): void {
			this.mTurnNumberText.setText("" + (this.mGame.mPvPMatch.mTurnCounter + 1));
			this.mActionsLeftText.setText("" + this.mGame.mPvPMatch.mActionsLeft);
		}

		private function removeHUDItem(param1: String): void {
			var _loc2_: MovieClip = this.mIngameHUDClip.getChildByName(param1) as MovieClip;
			this.mIngameHUDClip.removeChild(_loc2_);
		}

		public function turnChanged(param1: Boolean): void {
			var _loc2_: Class = null;
			if (!this.mTurnChangeClip) {
				_loc2_ = DCResourceManager.getInstance().getSWFClass("swf/pvp_interface", "hud_pvp_turn_shift");
				this.mTurnChangeClip = new _loc2_();
				this.mTurnChangeText = this.mTurnChangeClip["Text_Turn_Shift"] as TextField;
				this.mTurnChangeText.autoSize = TextFieldAutoSize.CENTER;
				this.mTurnChangeText.wordWrap = false;
				this.mTurnChangeText.multiline = false;
			}
			if (param1) {
				this.mEnemyPanel.setVisible(false);
				this.mPlayerPanel.setVisible(true);
				this.mPlayerPanel.playYourTurnAnimation();
				this.mTurnChangeText.text = GameState.getText("PVP_PLAYER_TURN");
			} else {
				this.mEnemyPanel.setVisible(true);
				this.mPlayerPanel.setVisible(false);
				this.mEnemyPanel.playYourTurnAnimation();
				this.mTurnChangeText.text = GameState.getText("PVPV_ENEMY_TURN");
			}
			this.mIngameHUDClip.addChild(this.mTurnChangeClip);
			this.mTurnChangeClip.y = this.mIngameHUDClip.height / 2;
			new DisplayObjectTransition(DisplayObjectTransition.ATTENTION_UP, this.mTurnChangeClip, DisplayObjectTransition.TYPE_DISAPPEAR);
			this.mTextUpdateRequired = true;
		}

		/*
      public function resize(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc5_:PopUpWindow = null;
         _loc3_ = Math.max(param1 - Config.SCREEN_WIDTH,0);
         var _loc4_:int = Math.max(param2 - Config.SCREEN_HEIGHT,0);
         this.mIngameHUDClip.x = Math.max(param1,Config.SCREEN_WIDTH) >> 1;
         if(!this.keyCoordinates)
         {
            this.keyCoordinates = new Array();
            this.keyCoordinates.push(new Point(this.mSettingsButtonsBar.x,this.mSettingsButtonsBar.y));
            this.keyCoordinates.push(new Point(this.mZoomFrame.x,this.mZoomFrame.y));
            this.keyCoordinates.push(new Point(this.mBottomFrame.x,this.mBottomFrame.y));
         }
         this.mSettingsButtonsBar.x = _loc3_ / 2 + (this.keyCoordinates[0] as Point).x;
         this.mZoomFrame.x = _loc3_ / 2 + (this.keyCoordinates[1] as Point).x;
         this.mBottomFrame.y = _loc4_ + (this.keyCoordinates[2] as Point).y;
         for each(_loc5_ in PopUpManager.getPopups())
         {
            if(_loc5_ && Boolean(_loc5_.parent))
            {
               _loc5_.alignToScreen();
            }
         }
      }
	  */

		public function resize(param1: int, param2: int): void {
			var _loc7_: PopUpWindow = null;
			var _loc3_: int = Math.max(param1, 0);
			var _loc4_: int = Math.max(param2 - 750, 0);
			var _loc5_: Number = 0;
			var _loc6_: int = this.mBottomFrame.width + 2;

			_loc5_ = _loc6_ >> 3;

			// Ensure mIngameHUDClip stays within bounds
			this.mIngameHUDClip.x = _loc3_ / 2;

			this.mBottomFrame.y = Math.max(0, Math.min(param2 - this.mBottomFrame.height));


			if (!this.keyCoordinates) {
				this.keyCoordinates = new Array();
				this.keyCoordinates.push(new Point(this.mBottomFrame.x, this.mBottomFrame.y));
			}

			var _loc8_: Array = null;
			var _loc9_: * = (_loc8_ = PopUpManager.getPopups()).length;
			var _loc10_: int = 0;

			while (_loc10_ < _loc9_) {
				if (_loc7_ = _loc8_[_loc10_] as PopUpWindow) {
					if (_loc7_.parent) {
						_loc7_.alignToScreen();
					}
				}
				_loc10_++;
			}
		}

		public function showCancelButton(param1: Boolean): void {}

		private function addButton(param1: MovieClip, param2: String, param3: Function): ArmyButton {
			var _loc4_: MovieClip;
			if ((_loc4_ = param1.getChildByName(param2) as MovieClip) != null) {
				_loc4_.mouseEnabled = true;
				return new ArmyButton(param1, _loc4_, DCButton.BUTTON_TYPE_ICON, null, null, null, null, null, param3);
			}
			return null;
		}

		private function buttonRetreatPressed(param1: MouseEvent): void {
			GameState.mInstance.openPvPDebriefing(false);
		}

		public function cancelTools(): void {
			this.mGame.cancelTools();
			this.mGame.cancelDecoPurchase();
			CursorManager.getInstance().hideCursorImages();
			this.mGame.mScene.mMapGUIEffectsLayer.clearHighlights();
			this.showCancelButton(false);
		}

		public function setZoomIndicator(param1: int): void {
			if (param1 < 0) {
				param1 = 0;
			} else if (param1 > GameState.mInstance.mZoomLevels.length - 1) {
				param1 = int(GameState.mInstance.mZoomLevels.length - 1);
			}
			this.mCurrentZoomStep = param1;
		}

		public function buttonZoomInPressed(param1: MouseEvent): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
			if (this.mCurrentZoomStep > 0) {
				MissionManager.increaseCounter("Zoom", null, 1);
				this.setZoomIndicator(this.mCurrentZoomStep - 1);
				GameState.mInstance.setZoomIndex(this.mCurrentZoomStep);
			}
		}

		public function buttonZoomOutPressed(param1: MouseEvent): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
			if (this.mCurrentZoomStep < GameState.mInstance.mZoomLevels.length - 1) {
				MissionManager.increaseCounter("Zoom", null, 1);
				this.setZoomIndicator(this.mCurrentZoomStep + 1);
				GameState.mInstance.setZoomIndex(this.mCurrentZoomStep);
			}
		}

		public function updateToggleButtonStates(): void {
			var _loc1_: ArmySoundManager = ArmySoundManager.getInstance();
			this.mButtonToggleMusic.setVisible(_loc1_.isMusicOn());
			this.mButtonToggleMusicDisabled.setVisible(!_loc1_.isMusicOn());
			this.mButtonToggleSound.setVisible(_loc1_.isSfxOn());
			this.mButtonToggleSoundDisabled.setVisible(!_loc1_.isSfxOn());
		}

		private function ToggleFullscreenClicked(param1: MouseEvent): void {
			MissionManager.increaseCounter("FullScreen", null, 1);
			GameState.mInstance.toggleFullScreen();
			param1.stopPropagation();
		}

		private function ToggleQualityClicked(param1: MouseEvent): void {
			this.updateToggleButtonStates();
			param1.stopPropagation();
		}

		private function ToggleSndFxClicked(param1: MouseEvent): void {
			var _loc2_: ArmySoundManager = ArmySoundManager.getInstance();
			_loc2_.setSfxOn(!_loc2_.isSfxOn());
			this.updateToggleButtonStates();
			param1.stopPropagation();
		}

		private function ToggleMusicClicked(param1: MouseEvent): void {
			var _loc2_: ArmySoundManager = ArmySoundManager.getInstance();
			_loc2_.setMusicOn(!_loc2_.isMusicOn());
			if (_loc2_.isMusicOn()) {
				this.mGame.startMusic();
			} else {
				this.mGame.mCurrentMusic = null;
			}
			this.updateToggleButtonStates();
			param1.stopPropagation();
		}

		public function openInventoryDialog(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_FULLSCREEN_NAME, InventoryDialog, [this.closeDialog]);
			this.cancelTools();
		}

		public function openOutOfCashTextBox(param1: Array): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, OutOfCashWindow, [this.closeDialog, this.openBuyMoneyTextBox, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openBuyMoneyTextBox(param1: Array): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, BuyMoneyWindow, [this.closeDialog, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openSupplyCapTextBox(param1: Array): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, SupplyCapFullWindow, [this.closeDialog, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openOutOfRangeTextBox(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, EnemyOutOfRangeWindow, [this.closeDialog]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openTutorialWindow(param1: Mission): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, TutorialWindow, [this.closeDialog, param1], null, false);
		}

		public function openTipWindow(param1: Mission): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, TipWindow, [this.closeDialog, param1]);
		}

		public function openErrorMessage(param1: String, param2: String, param3: ErrorObject, param4: Boolean = true): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, ErrorWindow, [this.closeDialog, param1, param2], null, param4);
		}

		public function openHiddenErrorMessage(param1: String, param2: String, param3: Boolean = true): void {
			var _loc4_: HiddenErrorWindow = null;
			if (PopUpManager.isPopUpCreated(HiddenErrorWindow)) {
				(_loc4_ = PopUpManager.getPopUp(HiddenErrorWindow) as HiddenErrorWindow).open(this.mGame.getMainClip(), param3);
				_loc4_.Activate(this.closeDialog, param1, param2);
			} else {
				this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, HiddenErrorWindow, [this.closeDialog, param1, param2], null, param3);
			}
		}

		public function openToasterTip(param1: Mission): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, ToasterWindow, [this.closeDialog, param1], null, false);
		}

		public function closeToasterTip(): void {
			this.closeDialog(ToasterWindow);
		}

		public function openCollectionTradedTextBox(param1: ItemCollectionItem): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, CollectionTradedWindow, [this.closeDialog, param1]);
		}

		private function openDialogIfResourceLoaded(param1: String, param2: Class, param3: Array, param4: Object = null, param5: Boolean = true): void {
			var _loc7_: String = null;
			if (this.mFileBeingLoaded != null) {
				Utils.LogError("Trying to open window while waiting for another one to load");
				return;
			}
			var _loc6_: DCResourceManager;
			if (!(_loc6_ = DCResourceManager.getInstance()).isLoaded(param1)) {
				this.mGame.getMainClip().mouseChildren = false;
				_loc7_ = param1 + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
				_loc6_.addEventListener(_loc7_, this.LoadingFinished);
				if (!_loc6_.isAddedToLoadingList(param1)) {
					_loc6_.load(Config.DIR_DATA + param1 + ".swf", param1, null, false);
				}
				this.mFileBeingLoaded = param1;
				this.mDialogClass = param2;
				this.mDialogParameters = param3;
				this.mProperty = param4;
				this.mModal = param5;
			} else {
				this.openDialog(param2, param3, param4, param5);
			}
		}

		protected function LoadingFinished(param1: Event): void {
			DCResourceManager.getInstance().removeEventListener(param1.type, this.LoadingFinished);
			this.openDialog(this.mDialogClass, this.mDialogParameters, this.mProperty, this.mModal);
			this.mFileBeingLoaded = null;
			this.mDialogClass = null;
			this.mDialogParameters = null;
			this.mProperty = null;
			this.mGame.getMainClip().mouseChildren = true;
		}

		private function openDialog(param1: Class, param2: Array, param3: Object, param4: Boolean): DCWindow {
			var _loc5_: DCWindow = null;
			if (PopUpManager.isPopUpCreated(param1)) {
				Utils.LogError("Trying to create an already created dialog");
				return PopUpManager.getPopUp(param1) as DCWindow;
			}
			(_loc5_ = PopUpManager.getPopUp(param1, param3) as DCWindow).open(this.mGame.getMainClip(), param4);
			var _loc6_: Function;
			(_loc6_ = _loc5_["Activate"]).apply(_loc5_, param2);
			return _loc5_;
		}

		public function getLastTab(): String {
			return ShopDialog.TAB_BOOSTERS;
		}

		public function setLastTab(param1: String): void {}

		public function itemCollected(): void {}

		private function showTooltip(param1: MouseEvent): void {
			var _loc3_: String = null;
			this.mHudTooltip.setTitleText("");
			this.mHudTooltip.x = param1.stageX;
			this.mHudTooltip.y = param1.stageY;
			var _loc2_: GamePlayerProfile = GameState.mInstance.mPlayerProfile;
			if (smTooltipTIDLinkage[(param1.target as DisplayObject).name]) {
				_loc3_ = String(smTooltipTIDLinkage[(param1.target as DisplayObject).name]);
			}
			if (!_loc3_) {
				if (DEBUG_HUD) {
					_loc3_ = (param1.target as DisplayObject).name;
					this.mHudTooltip.visible = true;
				}
			} else {
				if (this.mTooltipActivatedBefore) {
					this.mHudTooltip.setAppearDelayMs(0);
				} else {
					this.mHudTooltip.setAppearDelayMs(this.mHudTooltip.mMaxAppearDelayMs);
					this.mTooltipActivatedBefore = true;
				}
				this.mTooltipActivationTimer = 0;
				this.mHudTooltip.setDescriptionText(_loc3_);
				this.mHudTooltip.visible = true;
			}
			param1.stopPropagation();
			this.mBlock = true;
		}

		private function hideToolTip(param1: MouseEvent): void {
			this.mHudTooltip.visible = false;
			param1.stopPropagation();
			this.mBlock = false;
		}

		private function installTooltip(): void {
			var _loc2_: MovieClip = null;
			var _loc1_: Array = new Array();
			if (!smTooltipTIDLinkage) {
				smTooltipTIDLinkage = new Array();
				smTooltipTIDLinkage["Button_Cancel"] = GameState.getText("TOOLTIP_HUD_CANCEL_BUTTON");
			}
			_loc1_.push(this.mStatusFrame.getChildByName("Button_Quit"));
			this.mouseEnabled = true;
			this.mouseChildren = true;
			for each(_loc2_ in _loc1_) {
				_loc2_.mouseChildren = true;
			}
			this.mHudTooltip = new TooltipHUD(100, 500, true);
			this.mIngameHUDClip.addChild(this.mHudTooltip);
			this.mFriendlyTooltip = new TooltipHealth(TooltipHealth.TYPE_DEFAULT, 120, 200, true);
			this.mDetailsTooltip = new TooltipHealth(TooltipHealth.TYPE_DETAILS, 120, 200, true);
			this.mEnemyTooltip = new TooltipHealth(TooltipHealth.TYPE_ENEMY, 120, 200, true);
			this.mBuildingTooltip = new TooltipHealth(TooltipHealth.TYPE_BUILDING, 120, 200, true);
			this.mAttackTooltip = new TooltipHealth(TooltipHealth.TYPE_ATTACK, 120, 200, true);
			this.mEnemyBuildingTooltip = new TooltipHealth(TooltipHealth.TYPE_ENEMY_BUILDING, 120, 200, true);
			this.mBuildingWaterPlantTooltip = new TooltipHealth(TooltipHealth.TYPE_BUILDING_WATERPLANT, 120, 200, true);
			this.mInfoTooltip = new TooltipHealth(TooltipHealth.TYPE_INFO, 120, 200, true);
		}

		public function showObjectTooltip(param1: Renderable, param2: int = 0): void {
			var _loc3_: PowerUpObject = null;
			if (this.mGame.visitingFriend()) {
				if (param1 is EnemyUnit || param1 is EnemyInstallationObject) {
					this.mEnemyBuildingTooltip.setRenderable(param1);
					if (!this.mEnemyBuildingTooltip.visible) {
						this.mIngameHUDClip.addChild(this.mEnemyBuildingTooltip);
						this.mEnemyBuildingTooltip.visible = true;
					}
				} else if (param1 is ResourceBuildingObject) {
					this.mBuildingWaterPlantTooltip.setRenderable(param1);
					if (!this.mBuildingWaterPlantTooltip.visible) {
						this.mIngameHUDClip.addChild(this.mBuildingWaterPlantTooltip);
						this.mBuildingWaterPlantTooltip.visible = true;
					}
				} else {
					this.mBuildingTooltip.setRenderable(param1);
					if (!this.mBuildingTooltip.visible) {
						this.mIngameHUDClip.addChild(this.mBuildingTooltip);
						this.mBuildingTooltip.visible = true;
					}
				}
			} else if (param1 is PlayerUnit) {
				if ((param1 as PlayerUnit).mState == IsometricCharacter.STATE_DYING) {
					this.mDetailsTooltip.setRenderable(param1);
					if (!this.mDetailsTooltip.visible) {
						this.mIngameHUDClip.addChild(this.mDetailsTooltip);
						this.mDetailsTooltip.visible = true;
					}
				} else {
					this.mFriendlyTooltip.setRenderable(param1);
					if (!this.mFriendlyTooltip.visible) {
						this.mIngameHUDClip.addChild(this.mFriendlyTooltip);
						this.mFriendlyTooltip.visible = true;
					}
				}
			} else if (param1 is PlayerInstallationObject) {
				this.mFriendlyTooltip.setRenderable(param1);
				if (!this.mFriendlyTooltip.visible) {
					this.mIngameHUDClip.addChild(this.mFriendlyTooltip);
					this.mFriendlyTooltip.visible = true;
				}
			} else if (param1 is EnemyUnit || param1 is EnemyInstallationObject || param1 is PvPEnemyUnit) {
				if (param2 > 0) {
					this.mAttackTooltip.setRenderable(param1);
					this.mAttackTooltip.setAttackValues(param2);
					if (!this.mAttackTooltip.visible) {
						this.mIngameHUDClip.addChild(this.mAttackTooltip);
						this.mAttackTooltip.visible = true;
					}
				} else if (param1 is EnemyInstallationObject && !(param1 as EnemyInstallationObject).canAttack()) {
					this.mEnemyBuildingTooltip.setRenderable(param1);
					if (!this.mEnemyBuildingTooltip.visible) {
						this.mIngameHUDClip.addChild(this.mEnemyBuildingTooltip);
						this.mEnemyBuildingTooltip.visible = true;
					}
				} else {
					this.mEnemyTooltip.setRenderable(param1);
					if (!this.mEnemyTooltip.visible) {
						this.mIngameHUDClip.addChild(this.mEnemyTooltip);
						this.mEnemyTooltip.visible = true;
					}
				}
			} else if (param1 is PlayerBuildingObject || param1 is DebrisObject) {
				if (param1 is ResourceBuildingObject) {
					this.mBuildingWaterPlantTooltip.setRenderable(param1);
					if (!this.mBuildingWaterPlantTooltip.visible) {
						this.mIngameHUDClip.addChild(this.mBuildingWaterPlantTooltip);
						this.mBuildingWaterPlantTooltip.visible = true;
					}
				} else {
					this.mBuildingTooltip.setRenderable(param1);
					if (!this.mBuildingTooltip.visible) {
						this.mIngameHUDClip.addChild(this.mBuildingTooltip);
						this.mBuildingTooltip.visible = true;
					}
				}
			} else if (param1 is PowerUpObject) {
				_loc3_ = param1 as PowerUpObject;
				this.mInfoTooltip.setRenderable(param1);
				if (!this.mInfoTooltip.visible) {
					this.mIngameHUDClip.addChild(this.mInfoTooltip);
					this.mInfoTooltip.visible = true;
				}
			}
		}

		public function hideObjectTooltip(): void {
			this.mFriendlyTooltip.visible = false;
			if (this.mFriendlyTooltip.parent) {
				this.mIngameHUDClip.removeChild(this.mFriendlyTooltip);
			}
			this.mDetailsTooltip.visible = false;
			if (this.mDetailsTooltip.parent) {
				this.mIngameHUDClip.removeChild(this.mDetailsTooltip);
			}
			this.mEnemyTooltip.visible = false;
			if (this.mEnemyTooltip.parent) {
				this.mIngameHUDClip.removeChild(this.mEnemyTooltip);
			}
			this.mBuildingTooltip.visible = false;
			if (this.mBuildingTooltip.parent) {
				this.mIngameHUDClip.removeChild(this.mBuildingTooltip);
			}
			this.mAttackTooltip.visible = false;
			if (this.mAttackTooltip.parent) {
				this.mIngameHUDClip.removeChild(this.mAttackTooltip);
			}
			this.mEnemyBuildingTooltip.visible = false;
			if (this.mEnemyBuildingTooltip.parent) {
				this.mIngameHUDClip.removeChild(this.mEnemyBuildingTooltip);
			}
			this.mBuildingWaterPlantTooltip.visible = false;
			if (this.mBuildingWaterPlantTooltip.parent) {
				this.mIngameHUDClip.removeChild(this.mBuildingWaterPlantTooltip);
			}
			this.mInfoTooltip.visible = false;
			if (this.mInfoTooltip.parent) {
				this.mIngameHUDClip.removeChild(this.mInfoTooltip);
			}
		}

		public function getHUDClip(): MovieClip {
			return this.mIngameHUDClip;
		}

		public function enableMouse(param1: Boolean): void {
			this.mouseChildren = param1;
			this.mouseEnabled = param1;
		}

		public function refreshBoosters(): void {
			this.mBoosterBar.addToScreen();
		}

		public function openPvPMatchUpDialog(): void {
			this.openDialogIfResourceLoaded("swf/popups_pvp", PvPMatchUpDialog, [this.closeDialog, this.mGame.openPvPCombatSetupDialog]);
			this.cancelTools();
		}

		public function openPvPDebriefingDialog(): void {
			this.openDialogIfResourceLoaded("swf/popups_pvp", PvPDebriefingDialog, [this.closeDialog, this.mGame.openPvPMatchUpDialog]);
			this.cancelTools();
		}

		public function openPvPCombatSetupDialog(): void {
			this.openDialogIfResourceLoaded("swf/popups_pvp", PvPCombatSetupDialog, [this.closeDialog, this.openPvPMatchUpDialog, this.mGame.startPvP]);
		}

		public function openOutOfEnergyWindow(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, OutOfEnergyWindow, [this.closeDialog]);
			this.mGame.cancelAllPlayerActions();
			this.mGame.mPlayerProfile.removeOutOfEnergyTimer();
		}

		public function openOutOfSuppliesTextBox(param1: Array): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, OutOfSuppliesWindow, [this.closeDialog, null, null, param1]);
			this.mGame.cancelAllPlayerActions();
		}
	}
}