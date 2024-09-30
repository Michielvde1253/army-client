package game.gui {
	import com.dchoc.GUI.DCButton;
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.FileReference;
	CONFIG::BUILD_FOR_AIR {
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
		import flash.permissions.PermissionStatus
	}
	CONFIG::BUILD_FOR_MOBILE_AIR {
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
		import flash.permissions.PermissionStatus
		import flash.utils.Timer;
	}
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import game.characters.EnemyUnit;
	import game.characters.PlayerUnit;
	import game.characters.PvPEnemyUnit;
	import game.gameElements.ConstructionObject;
	import game.gameElements.DebrisObject;
	import game.gameElements.EnemyInstallationObject;
	import game.gameElements.PlayerBuildingObject;
	import game.gameElements.PlayerInstallationObject;
	import game.gameElements.PowerUpObject;
	import game.gameElements.Production;
	import game.gameElements.ResourceBuildingObject;
	import game.gameElements.SignalObject;
	import game.gui.button.ArmyButton;
	import game.gui.fireMission.FireMissionDialog;
	import game.gui.inventory.InventoryDialog;
	import game.gui.popups.AreaLockedWindow;
	import game.gui.popups.AskReviveWindow;
	import game.gui.popups.BuyGoldWindow;
	import game.gui.popups.BuyMoneyNewWindow;
	import game.gui.popups.CampaignProgressWindow;
	import game.gui.popups.CampaignWindow;
	import game.gui.popups.CharacterDialoqueWindow;
	import game.gui.popups.CollectionTradedWindow;
	import game.gui.popups.ConfirmRedeploymentWindow;
	import game.gui.popups.ConfirmRestartTutorialWindow;
	import game.gui.popups.ConfirmSellingWindow;
	import game.gui.popups.CorpseMarkerWindow;
	import game.gui.popups.DailyRewardWindow;
	import game.gui.popups.EnemyOutOfRangeWindow;
	import game.gui.popups.ErrorWindow;
	import game.gui.popups.ExitConfirmWindow;
	import game.gui.popups.FreeUnitReceivedWindow;
	import game.gui.popups.HiddenErrorWindow;
	import game.gui.popups.ImmediateSuppliesWindow;
	import game.gui.popups.InfantryCapFullWindow;
	import game.gui.popups.ArmorCapFullWindow;
	import game.gui.popups.ArtilleryCapFullWindow;
	import game.gui.popups.IntroWindow;
	import game.gui.popups.InviteFriendsWindow;
	import game.gui.popups.LevelUpWindow;
	import game.gui.popups.MissionCompleteWindow;
	import game.gui.popups.MissionProgressWindow;
	import game.gui.popups.MissionStackWindow;
	import game.gui.popups.OutOfCashWindow;
	import game.gui.popups.OutOfEnergyWindow;
	import game.gui.popups.OutOfIntelWindow;
	import game.gui.popups.OutOfMapResourceWindow;
	import game.gui.popups.OutOfSocialEnergyWindow;
	import game.gui.popups.OutOfSuppliesWindow;
	import game.gui.popups.PopUpManager;
	import game.gui.popups.PopUpWindow;
	import game.gui.popups.RankMissionWindow;
	import game.gui.popups.RateAppWindow;
	import game.gui.popups.RedeployHealWarningWindow;
	import game.gui.popups.SingleAttackWarningWindow;
	import game.gui.popups.SocialLevelUpWindow;
	import game.gui.popups.SocialWindowNew;
	import game.gui.popups.SupplyCapFullWindow;
	import game.gui.popups.TipWindow;
	import game.gui.popups.ToasterWindow;
	import game.gui.popups.TransactionWindow;
	import game.gui.popups.TutorialWindow;
	import game.gui.popups.UnitCapFullWindow;
	import game.gui.popups.UnitDiedWindow;
	import game.gui.popups.UnlockItemByAlliesWindow;
	import game.gui.popups.UnlockItemByBuildingWindow;
	import game.gui.popups.UnlockItemByLevelWindow;
	import game.gui.popups.UnlockItemByMissionWindow;
	import game.gui.popups.VisitingRewardWindow;
	import game.gui.popups.WelcomeBraggsFrontWindow;
	import game.gui.popups.WelcomeWindow;
	import game.gui.popups.WorldMapWindow;
	import game.gui.pvp.PvPCombatSetupDialog;
	import game.gui.pvp.PvPDebriefingDialog;
	import game.gui.pvp.PvPMatchUpDialog;
	import game.isometric.GridCell;
	import game.isometric.characters.IsometricCharacter;
	import game.isometric.elements.Renderable;
	import game.items.AreaItem;
	import game.items.ConstructionItem;
	import game.items.Item;
	import game.items.ItemCollectionItem;
	import game.items.ItemManager;
	import game.items.MapItem;
	import game.items.ShopItem;
	import game.items.SignalItem;
	import game.magicBox.MagicBoxTracker;
	import game.missions.Mission;
	import game.missions.MissionManager;
	import game.net.ErrorObject;
	import game.net.ServiceIDs;
	import game.player.GamePlayerProfile;
	import game.player.Inventory;
	import game.player.RankManager;
	import game.sound.ArmySoundManager;
	import game.states.GameState;
	import game.utils.TimeUtils;
	import game.utils.OfflineSave;

	public class GameHUD extends MovieClip implements HUDInterface {

		private static const DEBUG_HUD: Boolean = false;

		public static var isPauseButtonClicked: Boolean = false;

		private static const TOOLBOX_INDEX_SELL: int = 0;

		private static const TOOLBOX_INDEX_RELOCATE: int = 1;

		private static const TOOLBOX_INDEX_REDEPLOY: int = 2;

		private static const TOOLBOX_BUTTONS_COUNT: int = 2;

		private static var smTooltipTIDLinkage: Array;

		private static const VIR_SRC: String = "vir_friendsBar_button";


		public var newMissionNotificationButton: MovieClip = null;

		public var newMissionNotificationPogressButton: MovieClip = null;

		private var mGame: GameState;

		private var mHudTooltip: TooltipHUD;

		public var mCollectionCard: CollectionCard;

		public var mIngameHUDClip: MovieClip;

		public var mIngameHUDClip_BOTTOM: MovieClip;

		private var mRightPlaceButtonClip: MovieClip;

		private var mCancelPlaceButtonClip: MovieClip;

		public var mCurrentZoomStep: int;

		private var mButtonAddPremium: ArmyButton;

		private var mButtonAddEnergy: ArmyButton;

		private var mButtonFrameCash: MovieClip;

		private var mButtonFramePremium: MovieClip;

		private var mButtonFrameWater: MovieClip;

		private var mButtonTextCash: AutoTextField;

		private var mButtonTextWater: AutoTextField;

		private var mButtonTextPremium: TextField;

		private var mButtonAddCash: ArmyButton;

		private var mButtonAddSupply: ArmyButton;

		private var mHudButtonShop: ArmyButton;

		private var mHudButtonSave: ArmyButton;

		private var mButtonInventory: ArmyButton;

		private var mToolBox: MovieClip;

		private var mButtonToolBoxSell: ArmyButton;

		private var mButtonToolBoxSellEnabled: ArmyButton;

		private var mButtonToolBoxMove: ArmyButton;

		private var mButtonToolBoxMoveEnabled: ArmyButton;

		private var mButtonToolBoxRedeploy: ArmyButton;

		private var mButtonToolBoxRedeployEnabled: ArmyButton;

		public var mPlaceButton: ArmyButton;

		public var mPlaceCancelButton: ArmyButton;

		private var mToolBoxButtonsEnabled: Array;

		private var mToolBoxButtonsDisabled: Array;

		private var mResourceFrame: MovieClip;

		public var mVisitingIcon: MovieClip;

		private var mXpBar: BigHudBar;

		private var mEnergyBar: BigHudBar;

		private var mSuppliersBar: BigHudBar;

		private var mSupplyFrame: MovieClip;

		private var mEnergyFrame: MovieClip;

		private var mEnergyTimerText: AutoTextField;

		private var mXpFrame: MovieClip;

		private var mXpIcon: MovieClip;

		private var mLevelText: AutoTextField;

		private var mRankIcon: String;

		private var mButtonCancel: ArmyButton;

		private var mButtonRepairTool: ArmyButton;

		private var mButtonRepairToolText: TextField;

		private var mButtonToolClose: ArmyButton;

		private var mButtonPowerup: ArmyButton;

		private var mButtonMap: ArmyButton;
		
		private var mButtonPvp: ArmyButton;

		private var mBackHomeY: int;

		private var mBackHomeFrame: MovieClip;

		private var mButtonBackHome: ArmyButton;

		private var mButtonBackHomeText: TextField;

		private var mCurrentPopup: PopUpWindow;

		private var mVisitingNeighbor: Boolean;

		private var mFirstUpdate: Boolean = true;

		public var mBlock: Boolean = false;

		private var mLastShopTab: String;

		private var mTooltipActivationTimer: int;

		private const mTooltipActivationMaxTime: int = 500;

		private var mTooltipActivatedBefore: Boolean;

		private var mFileBeingLoaded: String;

		private var mDialogClass: Class;

		private var mDialogParameters: Array;

		private var mProperty: * ;

		private var mModal: Boolean;

		private var mShowSingleAttackWarning: Boolean = true;

		public var mShowAskReviveWindow: Boolean = true;

		public var mCheckFireCallHint: Boolean = true;

		private var mFireCallClickedDuringHintTimer: Boolean = false;

		private var mFireCallActivatorEnabled: Boolean = true;

		private var mFireCallHintActivateTimer: int;

		private var mPullOutMenuState: String;

		private var mButtonPullOut: ArmyButton;

		private var mPullOutMenuFrame: MovieClip;

		private var mPullOutMenu: MovieClip;

		private var mButtonSocial: ArmyButton;

		private var mButtonHome: ArmyButton;

		private var mButtonSettings: ArmyButton;

		private var mButtonPullOutFrame: MovieClip;

		private const STATE_MENU_OPEN: String = "Open";

		private const STATE_MENU_CLOSED: String = "Closed";

		public var mButtonPullOutMission: ArmyButton;

		public var mPullOutMissionFrame: MovieClip;

		private var mButtonPullOutMissionFrame: MovieClip;

		public const STATE_MISSIONS_MENU_OPEN: String = "Open";

		public const STATE_MISSIONS_MENU_CLOSED: String = "Closed";

		public var mPullOutMissionMenuState: String;

		private const TIME_LEFT_TEXT_NON_EMPTY_ENERGY: String = "";

		private var prevLevel: int;

		private const GAME_HUD_WIDTH: int = 1024;

		private var keyCoordinates: Array;

		private var TOOLBOX_TOP_X: int = 0;

		private var TOOLBOX_BOTTOM_X: int = 0;

		public var mFriendlyTooltip: TooltipHealth;

		public var mDetailsTooltip: TooltipHealth;

		public var mEnemyTooltip: TooltipHealth;

		public var mBuildingTooltip: TooltipHealth;

		public var mAttackTooltip: TooltipHealth;

		public var mEnemyBuildingTooltip: TooltipHealth;

		public var mBuildingWaterPlantTooltip: TooltipHealth;

		public var mInfoTooltip: TooltipHealth;

		private var mTutorialHighlight: MovieClip;

		CONFIG::BUILD_FOR_MOBILE_AIR {
			private var timer: Timer;
		}

		public function GameHUD(param1: GameState) {
			super();
			this.mGame = param1;
			this.createHUD();
			this.initHudTexts();
			this.installTooltip();
			this.mLastShopTab = ShopDialog.TAB_AREAS;
		}

		public function getLastTab(): String {
			return this.mLastShopTab;
		}

		public function setLastTab(param1: String): void {
			this.mLastShopTab = param1;
		}

		public function cloneObj(source: * ): * {
			var myBA: ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return myBA.readObject();
		}

		public function logicUpdate(param1: int): void {
			var _loc3_: TextFormat = null;
			var _loc4_: Number = NaN;
			var _loc5_: Number = NaN;
			var _loc6_: * = 0;
			var _loc7_: * = 0;
			var _loc8_: * = 0;
			var _loc9_: String = null;
			var _loc10_: Number = NaN;
			var _loc11_: Number = NaN;
			var _loc12_: * = 0;
			var _loc13_: * = 0;
			var _loc14_: Boolean = false;
			var _loc15_: Inventory = null;
			var _loc16_: * = null;
			var _loc17_: Item = null;
			var _loc18_: int = 0;
			this.mIngameHUDClip.visible = true;
			this.mIngameHUDClip_BOTTOM.visible = true;
			if (this.mFirstUpdate) {
				this.mGame.mServer.serverCallServiceWithParameters(ServiceIDs.GET_GOLD_AND_CASH, {
					"ver": 1
				}, false);
				if (Config.ENABLE_DAILY_REWARDS) {
					this.mGame.mServer.serverCallService(ServiceIDs.GET_DAILY_REWARD, false);
				}
				this.mFirstUpdate = false;
			}
			var _loc2_: GamePlayerProfile = this.mGame.mPlayerProfile;
			if (this.mButtonTextPremium.text != _loc2_.mPremium.toString()) {
				this.mButtonTextPremium.text = _loc2_.mPremium.toString();
				if (Config.FOR_IPHONE_PLATFORM) {
					_loc3_ = this.mButtonTextPremium.getTextFormat();
					_loc3_.size = 22;
					this.mButtonTextPremium.defaultTextFormat = _loc3_;
				}
			}
			if (this.mButtonTextCash.getText() != _loc2_.mMoney.toString()) {
				this.mButtonTextCash.setText(_loc2_.mMoney.toString());
			}
			if (this.mButtonTextWater.getText() != _loc2_.mWater.toString()) {
				this.mButtonTextWater.setText(_loc2_.mWater.toString());
			}
			if (this.mVisitingNeighbor) {
				_loc4_ = _loc2_.getSocialXpForThisLevel();
				_loc5_ = _loc2_.getSocialXpForNextLevel();
				trace("this.mNeighborActionsBar.setTargetValues(_loc2_.mNeighborActionsLeft,_loc2_.mMaxNeighborActions);")
			} else {
				_loc6_ = _loc2_.mEnergy;
				_loc7_ = _loc2_.mMaxEnergy;
				_loc8_ = _loc2_.mSecondsToRechargeEnergy;
				_loc9_ = null;
				if (_loc6_ == 0) {
					_loc9_ = GameState.getText("HUD_POPUP_ENERGY_READY_IN", [TimeUtils.getEnergyRechargeTimeString(_loc8_)]);
					this.mEnergyBar.setTextAmountVisible(false);
				} else {
					_loc9_ = this.TIME_LEFT_TEXT_NON_EMPTY_ENERGY;
					this.mEnergyBar.setTextAmountVisible(true);
				}
				this.mEnergyBar.setTargetValues(_loc6_, _loc7_);
				if (this.mEnergyTimerText.getText() != _loc9_) {
					this.mEnergyTimerText.setText(_loc9_);
				}
				this.setLevelText(_loc2_.mLevel);
				_loc10_ = _loc2_.getXpForThisLevel();
				_loc11_ = _loc2_.getXpForNextLevel();
				this.mXpBar.setTargetValues(_loc2_.mXp - _loc10_, _loc11_ - _loc10_, _loc10_);
				_loc12_ = _loc2_.mSupplies;
				_loc13_ = _loc2_.mSuppliesCap;
				this.mSuppliersBar.setTargetValues(_loc12_, _loc13_);
				if (this.mFireCallActivatorEnabled) {
					if (this.mCheckFireCallHint) {
						if (this.mButtonPowerup.getVisible()) {
							_loc14_ = false;
							_loc15_ = GameState.mInstance.mPlayerProfile.mInventory;
							for each(_loc16_ in GameState.mConfig.FireMissionItemSets) {
								_loc17_ = ItemManager.getItem(_loc16_.Item1.ID, _loc16_.Item1.Type);
								_loc18_ = int(_loc16_.Amount1);
								if (_loc15_.getNumberOfItems(_loc17_) >= _loc18_) {
									_loc17_ = ItemManager.getItem(_loc16_.Item2.ID, _loc16_.Item2.Type);
									_loc18_ = int(_loc16_.Amount2);
									if (_loc15_.getNumberOfItems(_loc17_) >= _loc18_) {
										_loc17_ = ItemManager.getItem(_loc16_.Item3.ID, _loc16_.Item3.Type);
										_loc18_ = int(_loc16_.Amount3);
										if (_loc15_.getNumberOfItems(_loc17_) >= _loc18_) {
											_loc17_ = ItemManager.getItem(_loc16_.Item4.ID, _loc16_.Item4.Type);
											_loc18_ = int(_loc16_.Amount4);
											if (_loc15_.getNumberOfItems(_loc17_) >= _loc18_) {
												_loc14_ = true;
												break;
											}
										}
									}
								}
							}
							if (_loc14_) {
								this.mButtonPowerup.setVisible(true);
							} else {
								this.mFireCallHintActivateTimer = 0;
							}
							this.mFireCallClickedDuringHintTimer = false;
						}
					}
				}
			}
			if (this.mTooltipActivatedBefore) {
				if (!this.mHudTooltip.mVisible) {
					this.mTooltipActivationTimer += param1;
					if (this.mTooltipActivationTimer >= this.mTooltipActivationMaxTime) {
						this.mTooltipActivatedBefore = false;
						this.mTooltipActivationTimer = 0;
					}
				}
			}
		}

		private function setLevelText(param1: int): void {
			if (param1 != this.prevLevel) {
				this.prevLevel = param1;
				this.mLevelText.setText(param1.toString());
			}
		}

		public function disableFireCallHint(): void {
			this.mFireCallActivatorEnabled = false;
			this.mCheckFireCallHint = false;
			this.mFireCallHintActivateTimer = 0;
			this.mButtonPowerup.setVisible(true);
		}

		private function initHudTexts(): void {
			this.mButtonTextPremium.text = "";
			this.mButtonTextCash.setText("");
			this.mEnergyTimerText.setText("");
			this.mLevelText.setText("");
		}

		private function updateRankIcon(param1: MovieClip): void {
			var _loc2_: IconAdapter = RankManager.getAdapterByIndex(this.mGame.mPlayerProfile.mRankIdx);
			if (_loc2_ != null) {
				if (this.mRankIcon != _loc2_.getIconGraphics()) {
					this.mRankIcon = _loc2_.getIconGraphics();
					IconLoader.addIcon(param1, _loc2_, this.iconLoaded);
				}
			}
		}

		public function iconLoaded(param1: Sprite): void {
			Utils.scaleIcon(param1, 50, 50);
		}

		public function closeDialog(param1: Class): void {
			var _loc3_: Function = null;
			var _loc4_: String = null;
			var _loc2_: DCWindow = PopUpManager.getPopUp(param1);
			if (FeatureTuner.USE_POPUP_CLOSING_TRANSITION_EFFECT) {
				_loc3_ = Object(_loc2_).getCloseAnimation;
				if (_loc2_ is PopUpWindow || _loc3_ != null) {
					if (_loc4_ = String(Object(_loc2_).getCloseAnimation())) {
						new DisplayObjectTransition(_loc4_, _loc2_, DisplayObjectTransition.TYPE_DISAPPEAR);
					}
				}
			}
			_loc2_.close();
			PopUpManager.releasePopUp(param1);
			MissionManager.increaseCounter("Close", _loc2_, 1);
		}

		public function createHUD(): void {
			DCButton.TRIGGER_AT_MOUSE_UP = true;
			CONFIG::BUILD_FOR_MOBILE_AIR {
				var _loc1_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "hud_new_top");
				var _loc2_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "hud_new_bottom");
			}
					CONFIG::BUILD_FOR_AIR {
				var _loc1_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "hud_new_top");
				var _loc2_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "hud_new_bottom");
			}
					CONFIG::NOT_BUILD_FOR_AIR {
				var _loc1_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "hud_new_top");
				var _loc2_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "hud_new_bottom");
			}
			this.mIngameHUDClip = new _loc1_();
			this.mIngameHUDClip_BOTTOM = new _loc2_();
			if (FeatureTuner.USE_COLLECTION_CARD) {
				this.mCollectionCard = new CollectionCard(this.mIngameHUDClip);
			}
			addChild(this.mIngameHUDClip);
			addChild(this.mIngameHUDClip_BOTTOM);
			this.mIngameHUDClip.visible = false;
			this.mIngameHUDClip_BOTTOM.visible = false;
			Utils.CallForAllChildren(this, Utils.disableMouse, null);

			this.mResourceFrame = this.mIngameHUDClip.getChildByName("Resources") as MovieClip;

			this.mHudButtonShop = Utils.createBasicButton(this.mIngameHUDClip_BOTTOM, "Button_shop", this.buttonShopPressed);
			this.mHudButtonSave = Utils.createBasicButton(this.mIngameHUDClip_BOTTOM, "Button_save", this.buttonSavePressed);
			this.mButtonMap = Utils.createBasicButton(this.mIngameHUDClip_BOTTOM, 'Button_Map', this.buttonMapPressed);
		    this.mButtonPvp = Utils.createBasicButton(this.mIngameHUDClip_BOTTOM, 'Button_Pvp', this.buttonPvpPressed);


			this.mRightPlaceButtonClip = this.mIngameHUDClip.getChildByName("right_button") as MovieClip;
			this.mCancelPlaceButtonClip = this.mIngameHUDClip.getChildByName("cancel_button") as MovieClip;
			this.mRightPlaceButtonClip.mouseEnabled = true;
			this.mCancelPlaceButtonClip.mouseEnabled = true;
			this.mPlaceButton = new ArmyButton(this.mIngameHUDClip, this.mRightPlaceButtonClip, DCButton.BUTTON_TYPE_OK, null, null, this.placeButtonPressed, null, null, null);
			this.mPlaceCancelButton = new ArmyButton(this.mIngameHUDClip, this.mCancelPlaceButtonClip, DCButton.BUTTON_TYPE_OK, null, null, this.placeCancelButtonPressed, null, null, null);
			this.mPlaceButton.setVisible(false);
			this.mPlaceCancelButton.setVisible(false);
			this.mEnergyFrame = this.mIngameHUDClip.getChildByName("Energy") as MovieClip;
			this.mEnergyBar = new BigHudBar(this.mEnergyFrame, true);
			this.mSupplyFrame = this.mIngameHUDClip.getChildByName("Supplies") as MovieClip;
			this.mSuppliersBar = new BigHudBar(this.mSupplyFrame, true);
			this.mButtonAddSupply = this.addButton(this.mSupplyFrame, "button_add_supplies", this.suppliesPressed);
			trace("this.mNeighborActionsFrame = this.mIngameHUDClip.getChildByName('Visitor_Energy') as MovieClip;");
			trace("this.mNeighborActionsFrame.visible = false;");
			trace("this.mNeighborActionsBar = new BigHudBar(thi.mNeighborActionsFrame,true);");
			trace("this.mNeighborName = (this.mNeighborActionsFrame.getChildByName('Owners_Card') as MovieClip).getChildByName('Text_Owner') as TextField;");
			trace("LocalizationUtils.replaceFont(this.mNeighborName);");
			this.mEnergyTimerText = new AutoTextField(this.mEnergyFrame.getChildByName("Text_Status") as TextField);
			this.mButtonAddEnergy = this.addButton(this.mEnergyFrame, "button_add_energy", this.ButtonAddEnergyPressed);
			this.mXpFrame = this.mIngameHUDClip.getChildByName("Experience") as MovieClip;
			this.mXpIcon = this.mXpFrame.getChildByName("Counter_Level") as MovieClip;
			this.mXpBar = new BigHudBar(this.mXpFrame, false, BigHudBar.ANIMATE_INCREASE);
			this.mLevelText = new AutoTextField(this.mXpIcon.getChildByName("Text_Amount") as TextField);
			this.mButtonFrameCash = this.mResourceFrame.getChildAt(2) as MovieClip;
			this.mButtonFramePremium = this.mResourceFrame.getChildAt(1) as MovieClip;
			this.mButtonFrameWater = this.mResourceFrame.getChildByName("Button_Water") as MovieClip;
			this.mButtonFrameWater.visible = false;
			this.mButtonTextCash = new AutoTextField(this.mButtonFrameCash.getChildAt(2) as TextField);
			this.mButtonTextPremium = this.mButtonFramePremium.getChildAt(3) as TextField;
			this.mButtonTextWater = new AutoTextField(this.mButtonFrameWater.getChildByName("Text_Amount") as TextField);
			this.mButtonAddCash = Utils.createBasicButton(this.mButtonFrameCash, "button_add_cash", this.cashPressed);
			this.mButtonAddPremium = Utils.createBasicButton(this.mButtonFramePremium, "button_add_gold", this.premiumPressed);


			this.mToolBox = this.mIngameHUDClip_BOTTOM.getChildByName("Toolbox") as MovieClip;
			this.mToolBoxButtonsDisabled = new Array(TOOLBOX_BUTTONS_COUNT, false);
			this.mToolBoxButtonsEnabled = new Array(TOOLBOX_BUTTONS_COUNT, false);
			this.mButtonToolBoxSell = this.addButton(this.mToolBox, "Button_Sell", this.buttonToolboxSellPressed);
			this.mButtonToolBoxSell.setText(GameState.getText("BUTTON_SELL_TOOL"), "Text_Title");
			this.mButtonToolBoxMove = this.addButton(this.mToolBox, "Button_Relocate", this.buttonToolboxRelocatePressed);
			this.mButtonToolBoxMove.setText(GameState.getText("BUTTON_MOVE_TOOL"), "Text_Title");
			this.mButtonToolBoxRedeploy = this.addButton(this.mToolBox, "Button_Redeploy", this.buttonToolboxPickupPressed);
			this.mButtonToolBoxRedeploy.setText(GameState.getText("BUTTON_REDEPLOY_TOOL"), "Text_Title");
			this.mButtonToolBoxSellEnabled = this.addButton(this.mToolBox, "Button_Sell_Enabled", this.buttonToolboxSellCanceled);
			this.mButtonToolBoxSellEnabled.setText(GameState.getText("BUTTON_SELL_TOOL"), "Text_Title");
			this.mButtonToolBoxMoveEnabled = this.addButton(this.mToolBox, "Button_Relocate_Enabled", this.buttonToolboxRelocateCanceled);
			this.mButtonToolBoxMoveEnabled.setText(GameState.getText("BUTTON_MOVE_TOOL"), "Text_Title");
			this.mButtonToolBoxRedeployEnabled = this.addButton(this.mToolBox, "Button_Redeploy_Enabled", this.buttonToolboxPickupCanceled);
			this.mButtonToolBoxRedeployEnabled.setText(GameState.getText("BUTTON_REDEPLOY_TOOL"), "Text_Title");
			this.mButtonToolClose = this.addButton(this.mToolBox, "Button_close", this.toggleToolbox);
			this.mToolBoxButtonsDisabled[TOOLBOX_INDEX_SELL] = this.mButtonToolBoxSell;
			this.mToolBoxButtonsDisabled[TOOLBOX_INDEX_RELOCATE] = this.mButtonToolBoxMove;
			this.mToolBoxButtonsDisabled[TOOLBOX_INDEX_REDEPLOY] = this.mButtonToolBoxRedeploy;
			this.mToolBoxButtonsEnabled[TOOLBOX_INDEX_SELL] = this.mButtonToolBoxSellEnabled;
			this.mToolBoxButtonsEnabled[TOOLBOX_INDEX_RELOCATE] = this.mButtonToolBoxMoveEnabled;
			this.mToolBoxButtonsEnabled[TOOLBOX_INDEX_REDEPLOY] = this.mButtonToolBoxRedeployEnabled;
			this.hideToolboxButtons();
			this.mCurrentZoomStep = 0;
			LocalizationUtils.replaceFont(this.mEnergyTimerText.getTextField());

			this.mButtonPullOutFrame = this.mIngameHUDClip_BOTTOM.getChildByName("Pullout_holder") as MovieClip;
			this.mButtonPullOut = Utils.createBasicButton(this.mButtonPullOutFrame, "button_pullout_tools", this.buttonPullOutMenuPressed);
			this.mPullOutMenuFrame = this.mIngameHUDClip_BOTTOM.getChildByName("pullout_tools_frame") as MovieClip;
			this.mPullOutMenuFrame.gotoAndStop(1);
			this.mPullOutMenuState = this.STATE_MENU_CLOSED;
			this.mPullOutMenu = this.mPullOutMenuFrame.getChildAt(0) as MovieClip;
			this.mButtonSocial = this.addButton(this.mPullOutMenu, "Button_social", this.doAbsolutelyNothingJustLikeDCDevs);
			this.mButtonInventory = this.addButton(this.mPullOutMenu, "Button_inventory", this.buttonInventoryPressed);
			this.mButtonHome = this.addButton(this.mPullOutMenu, "Button_home", this.mainMenuClicked);
			this.mButtonPowerup = this.addButton(this.mPullOutMenu, "Button_airstrike", this.buttonFireMissionActivePressed);
			this.mButtonRepairTool = this.addButton(this.mButtonPullOutFrame, "button_heal", this.buttonRepairPressed);
			this.mButtonCancel = this.addButton(this.mButtonPullOutFrame, "Button_cancel", this.buttonCancelPressed);
			this.mButtonCancel.setVisible(false);
			this.mButtonSettings = this.addButton(this.mPullOutMenu, "Button_settings", this.toggleToolbox);
			this.TOOLBOX_BOTTOM_X = this.mButtonPullOutFrame.x + (this.mToolBox.width << 1);
			this.TOOLBOX_TOP_X = this.mButtonPullOutFrame.x;
			this.mToolBox.x = this.TOOLBOX_BOTTOM_X;
			this.mToolBox.y = this.mButtonPullOutFrame.y - (this.mToolBox.height >> 1);

			this.mButtonPullOutMissionFrame = this.mIngameHUDClip_BOTTOM.getChildByName("pullout_holder_mission") as MovieClip;
			this.mButtonPullOutMission = Utils.createBasicButton(this.mButtonPullOutMissionFrame, "button_pullout_mission", this.buttonPullOutMissionPressed);
			this.newMissionNotificationButton = this.mButtonPullOutMissionFrame.getChildAt(2) as MovieClip;
			this.newMissionNotificationPogressButton = this.mButtonPullOutMissionFrame.getChildAt(3) as MovieClip;
			this.newMissionNotificationButton.buttonMode = true;
			this.newMissionNotificationPogressButton.buttonMode = true;
			this.newMissionNotificationButton.visible = false;
			this.newMissionNotificationPogressButton.visible = false;

			this.mPullOutMissionFrame = this.mIngameHUDClip_BOTTOM.getChildByName("pullout_mission_frame") as MovieClip;
			this.mPullOutMissionFrame.gotoAndStop(1);
			this.mPullOutMissionFrame.visible = false;
			this.mPullOutMissionMenuState = this.STATE_MISSIONS_MENU_CLOSED;
			this.resize(GameState.mInstance.getStageWidth(), GameState.mInstance.getStageHeight());
			CONFIG::BUILD_FOR_MOBILE_AIR {
				startSaveTimer()
			}
		}

		private function buttonPullOutMenuPressed(param1: Event): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
			if (Config.DEBUG_MODE) {}
			if (this.mPullOutMenuState == this.STATE_MENU_CLOSED) {
				this.mPullOutMenuFrame.gotoAndPlay("Open");
				this.mPullOutMenuState = this.STATE_MENU_OPEN;
				MissionManager.increaseCounter("OpenSettings", null, 1);
			} else {
				this.mPullOutMenuFrame.gotoAndPlay("Close");
				this.mPullOutMenuState = this.STATE_MENU_CLOSED;
			}
			this.mPullOutMenuFrame.addEventListener(Event.ENTER_FRAME, this.enterFrame);
		}

		private function enterFrame(param1: Event): void {
			if (this.mPullOutMenuFrame.currentFrameLabel == "Normal") {
				this.mPullOutMenuFrame.stop();
				this.mPullOutMenuFrame.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
			} else if (this.mPullOutMenuFrame.currentFrame == this.mPullOutMenuFrame.totalFrames) {
				this.mPullOutMenuFrame.gotoAndStop(1);
				this.mPullOutMenuFrame.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
			}
		}

		public function buttonPullOutMissionPressed(param1: Event): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
			if (Config.DEBUG_MODE) {}
			if (this.mPullOutMissionMenuState == this.STATE_MISSIONS_MENU_CLOSED) {
				MissionManager.increaseCounter("OpenMission", null, 1);
				this.mPullOutMissionFrame.gotoAndPlay("Open");
				this.mPullOutMissionMenuState = this.STATE_MISSIONS_MENU_OPEN;
				this.mPullOutMissionFrame.visible = true;
			} else {
				this.mPullOutMissionFrame.gotoAndPlay("Close");
				this.mPullOutMissionMenuState = this.STATE_MISSIONS_MENU_CLOSED;
			}
			if (this.newMissionNotificationButton) {
				if (this.mPullOutMissionMenuState == this.STATE_MISSIONS_MENU_OPEN) {
					this.mButtonPullOutMission.setVisible(true);
					this.newMissionNotificationButton.visible = false;
					this.newMissionNotificationButton.removeEventListener(MouseEvent.CLICK, this.buttonPullOutMissionPressed);
				}
				if (this.mPullOutMissionMenuState == this.STATE_MISSIONS_MENU_OPEN) {
					this.mButtonPullOutMission.setVisible(true);
					this.newMissionNotificationPogressButton.visible = false;
					this.newMissionNotificationPogressButton.removeEventListener(MouseEvent.CLICK, this.buttonPullOutMissionPressed);
				}
			}
			this.mPullOutMissionFrame.addEventListener(Event.ENTER_FRAME, this.enterFrameMission);
		}

		private function enterFrameMission(param1: Event): void {
			if (this.mPullOutMissionFrame.currentFrameLabel == "Normal") {
				this.mPullOutMissionFrame.visible = true;
				this.mPullOutMissionFrame.stop();
				this.mPullOutMissionFrame.removeEventListener(Event.ENTER_FRAME, this.enterFrameMission);
			} else if (this.mPullOutMissionFrame.currentFrame == this.mPullOutMissionFrame.totalFrames) {
				this.mPullOutMissionFrame.gotoAndStop(1);
				this.mPullOutMissionFrame.removeEventListener(Event.ENTER_FRAME, this.enterFrameMission);
				this.mPullOutMissionFrame.visible = false;
			}
		}

		public function toggleSocialDialog(param1: Event): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
			if (MissionManager.modalMissionActive() || this.mGame.mState == GameState.STATE_VISITING_NEIGHBOUR || this.mGame.mState == GameState.STATE_INTRO) {
				return;
			}
			this.cancelTools();
			if (Config.DEBUG_MODE) {}
			if (FeatureTuner.USE_FACEBOOK_CONNECT) {
				this.mGame.mAndroidFBConnection.getFriends();
			} else {
				this.openSocialWindow();
			}
		}

		private function toggleSettingsDialog(param1: Event): void {
			if (MissionManager.modalMissionActive() || this.mGame.mState == GameState.STATE_VISITING_NEIGHBOUR || this.mGame.mState == GameState.STATE_INTRO) {
				return;
			}
		}

		private function hideToolboxButtons(): void {
			var _loc1_: ArmyButton = null;
			var _loc4_: ArmyButton = null;
			var _loc2_: * = this.mToolBoxButtonsDisabled.length;
			var _loc3_: int = 0;
			while (_loc3_ < _loc2_) {
				_loc1_ = this.mToolBoxButtonsDisabled[_loc3_] as ArmyButton;
				_loc1_.setVisible(false);
				_loc3_++;
			}
			var _loc5_: * = this.mToolBoxButtonsEnabled.length;
			var _loc6_: int = 0;
			while (_loc6_ < _loc2_) {
				(_loc4_ = this.mToolBoxButtonsEnabled[_loc6_] as ArmyButton).setVisible(false);
				_loc6_++;
			}
		}

		private function disableToolboxButtons(): void {
			var _loc1_: ArmyButton = null;
			var _loc4_: ArmyButton = null;
			var _loc2_: * = this.mToolBoxButtonsDisabled.length;
			var _loc3_: int = 0;
			while (_loc3_ < _loc2_) {
				_loc1_ = this.mToolBoxButtonsDisabled[_loc3_] as ArmyButton;
				_loc1_.setVisible(true);
				_loc3_++;
			}
			var _loc5_: * = this.mToolBoxButtonsEnabled.length;
			var _loc6_: int = 0;
			while (_loc6_ < _loc5_) {
				(_loc4_ = this.mToolBoxButtonsEnabled[_loc6_] as ArmyButton).setVisible(false);
				_loc6_++;
			}
		}

		private function enableToolboxButton(param1: int): void {
			var _loc2_: ArmyButton = null;
			var _loc3_: int = 0;
			while (_loc3_ < this.mToolBoxButtonsDisabled.length) {
				_loc2_ = this.mToolBoxButtonsDisabled[_loc3_];
				_loc2_.setVisible(param1 != _loc3_);
				_loc2_ = this.mToolBoxButtonsEnabled[_loc3_];
				_loc2_.setVisible(param1 == _loc3_);
				_loc3_++;
			}
		}

		private function removeHUDItem(param1: String): void {
			var _loc2_: MovieClip = this.mIngameHUDClip.getChildByName(param1) as MovieClip;
			this.mIngameHUDClip.removeChild(_loc2_);
		}

		/*
      public function resize(param1:int, param2:int) : void
      {
         var _loc7_:PopUpWindow = null;
         var _loc3_:int = Math.max(param1 - this.GAME_HUD_WIDTH,0);
         var _loc4_:int = Math.max(param2 - 750,0);
         var _loc5_:Number = 0;
         var _loc6_:int = this.mResourceFrame.width + 2;
         if(param1 > 1200)
         {
            _loc5_ = _loc6_ >> 3;
         }
         else
         {
            _loc5_ = (_loc6_ >> 4) + 6 * (_loc6_ >> 8);
         }
         this.mIngameHUDClip.x = _loc3_ / 2;
         this.mIngameHUDClip.y = _loc4_;
         this.mPullOutMissionFrame.x -= _loc3_ / 2;
         this.mButtonPullOutMissionFrame.x -= _loc3_ / 2;
         this.mButtonPullOutFrame.x += _loc3_ / 2;
         this.mPullOutMenuFrame.x += _loc3_ / 2;
		 trace("very useful tracking (always):")
		 trace(this.mButtonPullOutMissionFrame.y)
		 trace(this.mPullOutMissionFrame.y)
         if(param2 < 750)
         {
            this.mButtonPullOutMissionFrame.y -= this.mButtonPullOutMissionFrame.height / 2 - (_loc6_ >> 5);
            this.mPullOutMissionFrame.y -= this.mPullOutMissionFrame.height / 16;
            this.mButtonPullOutFrame.y -= this.mButtonPullOutFrame.height / 2 - (_loc6_ >> 5);
            this.mPullOutMenuFrame.y -= this.mPullOutMenuFrame.height / 16;
         }
         if(!this.keyCoordinates)
         {
            this.keyCoordinates = new Array();
            this.keyCoordinates.push(new Point(this.mResourceFrame.x,this.mResourceFrame.y));
            this.keyCoordinates.push(new Point(this.mEnergyFrame.x,this.mEnergyFrame.y));
            this.keyCoordinates.push(new Point(this.mXpFrame.x,this.mXpFrame.y));
            this.keyCoordinates.push(new Point(this.mSupplyFrame.x,this.mSupplyFrame.y));
         }
         this.mResourceFrame.y = -_loc4_ + (this.keyCoordinates[0] as Point).y;
         this.mEnergyFrame.y = -_loc4_ + (this.keyCoordinates[1] as Point).y;
         this.mXpFrame.y = -_loc4_ + (this.keyCoordinates[2] as Point).y;
         this.mSupplyFrame.y = -_loc4_ + (this.keyCoordinates[3] as Point).y;
         trace("this.mNeighborActionsFrame.y = -_loc4_ + (this.keyCoordinates[1] as Point).y;");
         this.TOOLBOX_BOTTOM_X = this.mButtonPullOutFrame.x + (this.mToolBox.width << 1);
         this.TOOLBOX_TOP_X = this.mButtonPullOutFrame.x;
         this.mToolBox.x = this.TOOLBOX_BOTTOM_X;
         this.mToolBox.y = this.mButtonPullOutFrame.y - (this.mToolBox.height >> 1);
         var _loc8_:Array = null;
         var _loc9_:* = (_loc8_ = PopUpManager.getPopups()).length;
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            if(_loc7_ = _loc8_[_loc10_] as PopUpWindow)
            {
               if(_loc7_.parent)
               {
                  _loc7_.alignToScreen();
               }
            }
            _loc10_++;
         }
      }
      */
		public function resize(param1: int, param2: int): void {
			var _loc7_: PopUpWindow = null;
			var _loc3_: int = Math.max(param1 - this.GAME_HUD_WIDTH, 0);
			var _loc4_: int = Math.max(param2 - 750, 0);
			var _loc5_: Number = 0;
			var _loc6_: int = this.mResourceFrame.width + 2;

			_loc5_ = _loc6_ >> 3;

			// Ensure mIngameHUDClip stays within bounds
			this.mIngameHUDClip.x = _loc3_ / 2;
			this.mIngameHUDClip.y = _loc4_;

			// Ensure mPullOutMissionFrame and other frames stay within bounds
			this.mPullOutMissionFrame.x = 0;
			this.mButtonPullOutMissionFrame.x = Math.max(0, Math.min(param1 - this.mButtonPullOutMissionFrame.width, this.mButtonPullOutMissionFrame.x - _loc3_ / 2));
			this.mButtonPullOutFrame.x = Math.max(0, param1 - this.mButtonPullOutFrame.width);
			this.mPullOutMenuFrame.x = param1;

			this.mButtonPullOutMissionFrame.y = Math.max(0, Math.min(param2 - this.mButtonPullOutMissionFrame.height));
			this.mPullOutMissionFrame.y = Math.max(0, Math.min(param2 - this.mPullOutMenuFrame.height / 2 + this.mButtonPullOutMissionFrame.height));
			this.mButtonPullOutFrame.y = Math.max(0, Math.min(param2 - this.mButtonPullOutFrame.height));
			this.mPullOutMenuFrame.y = Math.max(0, Math.min(param2 - this.mPullOutMenuFrame.height));

			this.mHudButtonShop.setY(Math.max(0, Math.min(param2 - this.mHudButtonShop.getHeight())) + 3);
			this.mHudButtonSave.setY(Math.max(0, Math.min(param2 - this.mHudButtonSave.getHeight())) + 3);
			this.mButtonMap.setY(Math.max(0, Math.min(param2 - this.mButtonMap.getHeight())) + 3);
			this.mButtonPvp.setY(Math.max(0, Math.min(param2 - this.mButtonPvp.getHeight())) + 3);


			if (!this.keyCoordinates) {
				this.keyCoordinates = new Array();
				this.keyCoordinates.push(new Point(this.mResourceFrame.x, this.mResourceFrame.y));
				this.keyCoordinates.push(new Point(this.mEnergyFrame.x, this.mEnergyFrame.y));
				this.keyCoordinates.push(new Point(this.mXpFrame.x, this.mXpFrame.y));
				this.keyCoordinates.push(new Point(this.mSupplyFrame.x, this.mSupplyFrame.y));
			}

			// Ensure key frames stay within bounds
			this.mResourceFrame.y = -_loc4_ + (this.keyCoordinates[0] as Point).y;
			this.mEnergyFrame.y = -_loc4_ + (this.keyCoordinates[1] as Point).y;
			this.mXpFrame.y = -_loc4_ + (this.keyCoordinates[2] as Point).y;
			this.mSupplyFrame.y = -_loc4_ + (this.keyCoordinates[3] as Point).y;
			//this.mNeighborActionsFrame.y = -_loc4_ + (this.keyCoordinates[1] as Point).y;

			// Ensure mToolBox stays within bounds
			this.TOOLBOX_BOTTOM_X = this.mButtonPullOutFrame.x + (this.mToolBox.width << 1);
			this.TOOLBOX_TOP_X = this.mButtonPullOutFrame.x;
			this.mToolBox.x = this.TOOLBOX_BOTTOM_X;
			this.mToolBox.y = this.mButtonPullOutFrame.y - (this.mToolBox.height >> 1);

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


		public function showCancelButton(param1: Boolean): void {
			this.mButtonCancel.setVisible(param1);
		}

		private function addButton(param1: MovieClip, param2: String, param3: Function): ArmyButton {
			var _loc4_: MovieClip = null;
			if ((_loc4_ = param1.getChildByName(param2) as MovieClip) != null) {
				_loc4_.mouseEnabled = true;
				return new ArmyButton(param1, _loc4_, DCButton.BUTTON_TYPE_ICON, null, null, null, null, null, param3);
			}
			param3 = null;
			return null;
		}

		public function ButtonPressed(param1: MouseEvent): void {
			this.mGame.executeRefillEnergy();
		}

		private function buttonRepairPressed(param1: MouseEvent): void {
			if (MissionManager.modalMissionActive() && !MissionManager.selectRepairMissionActive() || this.mGame.mState == GameState.STATE_VISITING_NEIGHBOUR || this.mGame.mState == GameState.STATE_INTRO) {
				return;
			}
			this.mGame.cancelTools();
			this.mGame.cancelDecoPurchase();
			CursorManager.getInstance().hideCursorImages();
			this.mGame.changeState(GameState.STATE_REPAIR_ITEM);
			this.showCancelButton(true);
			param1.stopPropagation();
			MissionManager.increaseCounter("ActivateRepair", null, 1);
		}

		private function doAbsolutelyNothingJustLikeDCDevs(param1: MouseEvent): void {
			this.openComingSoonDialog()
		}

		private function buttonToolboxSellPressed(param1: MouseEvent): void {
			this.mGame.cancelTools();
			this.mGame.cancelDecoPurchase();
			CursorManager.getInstance().hideCursorImages();
			this.mGame.cancelAllPlayerActions();
			this.mGame.changeState(GameState.STATE_SELL_ITEM);
			this.enableToolboxButton(TOOLBOX_INDEX_SELL);
			this.showCancelButton(true);
			param1.stopPropagation();
		}

		private function buttonToolboxSellCanceled(param1: MouseEvent): void {
			this.mGame.cancelTools();
			this.mGame.cancelDecoPurchase();
			CursorManager.getInstance().hideCursorImages();
			this.mGame.mScene.mMapGUIEffectsLayer.clearHighlights();
			this.mGame.changeState(GameState.STATE_PLAY);
			this.disableToolboxButtons();
			this.showCancelButton(false);
			param1.stopPropagation();
		}

		private function buttonToolboxPickupPressed(param1: MouseEvent): void {
			this.mGame.cancelTools();
			this.mGame.cancelDecoPurchase();
			CursorManager.getInstance().hideCursorImages();
			this.mGame.cancelAllPlayerActions();
			this.mGame.changeState(GameState.STATE_PICKUP_UNIT);
			this.enableToolboxButton(TOOLBOX_INDEX_REDEPLOY);
			this.showCancelButton(true);
			param1.stopPropagation();
		}

		private function buttonToolboxPickupCanceled(param1: MouseEvent): void {
			this.mGame.cancelTools();
			this.mGame.cancelDecoPurchase();
			CursorManager.getInstance().hideCursorImages();
			this.mGame.mScene.mMapGUIEffectsLayer.clearHighlights();
			this.mGame.changeState(GameState.STATE_PLAY);
			this.disableToolboxButtons();
			this.showCancelButton(false);
			param1.stopPropagation();
		}

		private function buttonToolboxRelocatePressed(param1: MouseEvent): void {
			this.mGame.cancelTools();
			this.mGame.cancelDecoPurchase();
			CursorManager.getInstance().hideCursorImages();
			this.mGame.cancelAllPlayerActions();
			this.mGame.changeState(GameState.STATE_MOVE_ITEM);
			this.enableToolboxButton(TOOLBOX_INDEX_RELOCATE);
			this.showCancelButton(true);
			param1.stopPropagation();
		}

		private function buttonToolboxRelocateCanceled(param1: MouseEvent): void {
			this.mGame.cancelTools();
			this.mGame.cancelDecoPurchase();
			CursorManager.getInstance().hideCursorImages();
			this.mGame.mScene.mMapGUIEffectsLayer.clearHighlights();
			this.mGame.changeState(GameState.STATE_PLAY);
			this.disableToolboxButtons();
			this.showCancelButton(false);
			param1.stopPropagation();
		}

		private function backHomePressed(param1: MouseEvent): void {
			GameState.mInstance.executeReturnHome();
		}

		private function ButtonAddEnergyPressed(param1: MouseEvent): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
			GameState.mInstance.mHUD.triggerShopOpening(ShopDialog.TAB_PACKS);
		}

		private function cashPressed(param1: MouseEvent): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
			GameState.mInstance.mHUD.triggerShopOpening(ShopDialog.TAB_BUYCASH);
		}

		private function suppliesPressed(param1: MouseEvent): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
			GameState.mInstance.mHUD.triggerShopOpening(ShopDialog.TAB_PACKS);
		}

		private function premiumPressed(param1: MouseEvent): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
			GameState.mInstance.mHUD.triggerShopOpening(ShopDialog.TAB_BUYGOLD);
		}

		private function buttonCancelPressed(param1: MouseEvent): void {
			if (MissionManager.modalMissionActive() || this.mGame.mState == GameState.STATE_VISITING_NEIGHBOUR || this.mGame.mState == GameState.STATE_INTRO || this.mGame.mState == GameState.STATE_WAIT_FB_CALLBACK) {
				return;
			}
			this.cancelTools();
			GameState.mInstance.mScene.mTickCrossActive = false;
		}

		public function cancelTools(): void {
			this.mGame.cancelTools();
			this.mGame.cancelDecoPurchase();
			CursorManager.getInstance().hideCursorImages();
			this.mGame.mScene.mMapGUIEffectsLayer.clearHighlights();
			if (this.mToolBox.x == this.TOOLBOX_TOP_X) {
				this.toggleToolbox(null);
			}
			this.hideToolboxButtons();
			this.showCancelButton(false);
		}

		private function toggleToolbox(param1: MouseEvent): void {
			if (MissionManager.modalMissionActive() || this.mGame.mState == GameState.STATE_VISITING_NEIGHBOUR || this.mGame.mState == GameState.STATE_INTRO) {
				return;
			}
			if (this.mToolBox.x == this.TOOLBOX_BOTTOM_X) {
				this.mToolBox.x = this.TOOLBOX_TOP_X;
				if (this.mGame.mState == GameState.STATE_SELL_ITEM) {
					this.enableToolboxButton(TOOLBOX_INDEX_SELL);
				} else if (this.mGame.mState == GameState.STATE_MOVE_ITEM) {
					this.enableToolboxButton(TOOLBOX_INDEX_RELOCATE);
				} else {
					this.disableToolboxButtons();
				}
			} else if (this.mToolBox.x == this.TOOLBOX_TOP_X) {
				this.mToolBox.x = this.TOOLBOX_BOTTOM_X;
				this.hideToolboxButtons();
			}
		}

		public function buttonInventoryPressed(param1: MouseEvent): void {
			MissionManager.increaseCounter("OpenItemTab", null, 1);
			if (MissionManager.mInventoryNeedtoOpen) {
				GameState.mInstance.mIndicateInventoryItem = true;
				this.openInventoryDialog();
				MissionManager.mInventoryNeedtoOpen = false;
			}
			if (MissionManager.modalMissionActive() || this.mGame.mState == GameState.STATE_VISITING_NEIGHBOUR || this.mGame.mState == GameState.STATE_INTRO) {
				return;
			}
			this.openInventoryDialog();
		}


		public function triggerShopOpening(param1: String, param2: String = "normal"): void {
			if (MissionManager.mBuildingNeedtoOpen) {
				GameState.mInstance.mIndicatedShopItem = ItemManager.getItem("HQ", "Building");
				this.openShopDialog(ShopDialog, "FoodShop", ShopDialog.TAB_BUILDINGS, param2);
				MissionManager.mBuildingNeedtoOpen = false;
			}
			if (MissionManager.modalMissionActive() && !MissionManager.openShopMissionActive() || this.mGame.mState == GameState.STATE_VISITING_NEIGHBOUR || this.mGame.mState == GameState.STATE_INTRO) {
				return;
			}
			this.openShopDialog(ShopDialog, "FoodShop", param1, param2);
		}

		public function buttonShopPressed(param1: MouseEvent): void {
			MissionManager.increaseCounter("OpenBuilding", null, 1);
			this.triggerShopOpening(null);
		}

		public function generateSaveJson(): * {
			return OfflineSave.generateSaveJson();
		}

		public function buttonSavePressed(param1: MouseEvent): void {
			CONFIG::BUILD_FOR_AIR {
				var file: File = new File();
				file.addEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
				file.requestPermission();
			}
			CONFIG::NOT_BUILD_FOR_AIR {
				var savedata: * = {};
				savedata = generateSaveJson();
				var fileRef: FileReference = new FileReference();
				fileRef.save(JSON.stringify(savedata));
			}
			CONFIG::BUILD_FOR_MOBILE_AIR {
				// Resolve the file path
				var file: File = File.applicationStorageDirectory.resolvePath("savefile.txt");
				file.addEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
				file.requestPermission();
			}
		}

		CONFIG::BUILD_FOR_MOBILE_AIR {
			public function autoSaveGame(param1: TimerEvent): void {
				// Resolve the file path
				var file: File = File.applicationStorageDirectory.resolvePath("savefile.txt");
				file.addEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
				file.requestPermission();
			}
		}

		CONFIG::BUILD_FOR_AIR {
			public function onPermission(e: PermissionEvent): void {
				var file: File = e.target as File;
				file.removeEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
				if (e.status == PermissionStatus.GRANTED) {
					file.addEventListener(Event.SELECT, onFileSelected);
					file.browseForSave("Select a location");
				}
			}
		}

		CONFIG::BUILD_FOR_MOBILE_AIR {
			public function onPermission(e: PermissionEvent): void {
				var file: File = e.target as File;
				file.removeEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
				if (e.status == PermissionStatus.GRANTED) {

					var savedata: * = {};
					savedata = generateSaveJson();

					// Open a file stream to write content to the file
					var fileStream: FileStream = new FileStream();
					fileStream.open(file, FileMode.WRITE);
					fileStream.writeUTFBytes(savedata);
					fileStream.close();

					var savedata: * = {};
					savedata = generateSaveJson();
					var bytearray: ByteArray = new ByteArray();
					bytearray.writeUTF(savedata);
					var stream: FileStream = new FileStream();
					stream.open(file, FileMode.WRITE);
					stream.writeUTFBytes(JSON.stringify(savedata));
					stream.close()
				}
			}
		}

		CONFIG::BUILD_FOR_AIR {
			public function onFileSelected(evt: Event): void {
				var savedata: * = {};
				savedata = generateSaveJson();
				var bytearray: ByteArray = new ByteArray();
				bytearray.writeUTF(savedata);
				var file: File = evt.target as File;
				var stream: FileStream = new FileStream();
				stream.open(file, FileMode.WRITE);
				stream.writeUTFBytes(JSON.stringify(savedata));
				stream.close()
			}
		}

		private function placeButtonPressed(param1: MouseEvent): void {
			param1.stopImmediatePropagation();
			GameState.mInstance.mScene.mPlacePressed = true;
			if (this.mGame.mState == GameState.STATE_MOVE_ITEM || this.mGame.mState == GameState.STATE_USE_INVENTORY_ITEM || this.mGame.mState == GameState.STATE_PLACE_ITEM) {
				GameState.mInstance.mScene.mouseUp(param1);
			} else if (this.mGame.mState == GameState.STATE_PLACE_FIRE_MISSION) {
				GameState.mInstance.mScene.fireActive(param1);
			}
		}

		private function placeCancelButtonPressed(param1: MouseEvent): void {
			param1.stopImmediatePropagation();
			GameState.mInstance.mScene.cancelPlaceClicked();
		}

		public function setZoomIndicator(param1: int): void {
			if (param1 < 0) {
				param1 = 0;
			} else if (param1 > GameState.mInstance.mZoomLevels.length - 1) {
				param1 = GameState.mInstance.mZoomLevels.length - 1;
			}
			this.mCurrentZoomStep = param1;
		}

		public function buttonZoomInPressed(param1: MouseEvent): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
			if (this.mCurrentZoomStep > 0) {
				this.setZoomIndicator(this.mCurrentZoomStep - 1);
				GameState.mInstance.setZoomIndex(this.mCurrentZoomStep);
			}
		}

		public function buttonZoomOutPressed(param1: MouseEvent): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
			if (this.mCurrentZoomStep < GameState.mInstance.mZoomLevels.length - 1) {
				this.setZoomIndicator(this.mCurrentZoomStep + 1);
				GameState.mInstance.setZoomIndex(this.mCurrentZoomStep);
			}
		}

		public function updateToggleButtonStates(): void {}

		private function mainMenuClicked(param1: MouseEvent): void {
			if (MissionManager.modalMissionActive() || this.mGame.mState == GameState.STATE_VISITING_NEIGHBOUR || this.mGame.mState == GameState.STATE_INTRO) {
				return;
			}
			isPauseButtonClicked = true;
			PauseDialog.mPauseScreenPreviousState = PauseDialog.STATE_IN_GAME;
			this.openPauseScreen();
		}

		public function openPauseScreen(): void {
			PauseDialog.mPauseScreenState = PauseDialog.STATE_CONTINUE;
			if (ArmySoundManager.getInstance().isMusicOn()) {
				if (Config.RESTART_STATUS == -1 && PauseDialog.mPauseScreenPreviousState == PauseDialog.STATE_UNDEFINED) {
					ArmySoundManager.getInstance().playSound(ArmySoundManager.MUSIC_HOME, 1, 0, -1);
				}
			}
			this.openDialogIfResourceLoaded(Config.SWF_MAIN_MENU_NAME, PauseDialog, [this.closeDialog]);
			this.cancelTools();
			this.mFileBeingLoaded = null;
		}
	
		public function openFirstTimeChooseScreen(): void {
			if (ArmySoundManager.getInstance().isMusicOn()) {
				if (Config.RESTART_STATUS == -1 && PauseDialog.mPauseScreenPreviousState == PauseDialog.STATE_UNDEFINED) {
					ArmySoundManager.getInstance().playSound(ArmySoundManager.MUSIC_HOME, 1, 0, -1);
				}
			}
			this.openDialogIfResourceLoaded(Config.SWF_MAIN_MENU_NAME, FirstTimeChooseDialog, [this.closeDialog]);
			this.cancelTools();
			this.mFileBeingLoaded = null;
		}

		public function openHelpScreen(): void {
			PauseDialog.mPauseScreenState = PauseDialog.STATE_HELP_CLICK;
			this.openDialogIfResourceLoaded(Config.SWF_MAIN_MENU_NAME, HelpDialogClass, [this.closeDialog]);
			this.cancelTools();
		}

		public function openSettingsScreen(): void {
			PauseDialog.mPauseScreenState = PauseDialog.STATE_SETTINGS_CLICK;
			this.openDialogIfResourceLoaded(Config.SWF_MAIN_MENU_NAME, SettingsDialogClass, [this.closeDialog]);
			this.cancelTools();
		}

		public function applicationExit(): void {}

		public function openNotificationScreen(): void {
			this.openDialogIfResourceLoaded(Config.SWF_MAIN_MENU_NAME, NotificationDialogClass, [this.closeDialog]);
			this.cancelTools();
		}

		public function openAboutScreen(): void {
			this.openDialogIfResourceLoaded(Config.SWF_MAIN_MENU_NAME, AboutDialogClass, [this.closeDialog]);
			this.cancelTools();
		}

		public function openBuyGoldScreen(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, BuyGoldWindow, [this.closeDialog]);
			this.cancelTools();
		}

		public function openInventoryDialog(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_FULLSCREEN_NAME, InventoryDialog, [this.closeDialog]);
			this.cancelTools();
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
			trace("sure")
			this.openDialogIfResourceLoaded("swf/popups_pvp", PvPCombatSetupDialog, [this.closeDialog, this.openPvPMatchUpDialog, this.mGame.startPvP]);
		}

		private function openShopDialog(param1: Class, param2: String, param3: String, param4: String): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_FULLSCREEN_NAME, ShopDialog, [this.closeDialog, param3, param4]);
			this.cancelTools();
		}

		private function openAreaShop(): void {
			this.openShopDialog(ShopDialog, "FoodShop", ShopDialog.TAB_AREAS, "normal");
		}

		public function openOutOfCashTextBox(param1: Array): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, OutOfCashWindow, [this.closeDialog, this.openBuyMoneyTextBox, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openBuyMoneyTextBox(param1: Array): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, BuyMoneyNewWindow, [this.closeDialog]);
		}

		public function openRedeploymentConfirmationTextBox(param1: PlayerUnit): void {
			this.openDialog(ConfirmRedeploymentWindow, [this.closeDialog, param1], null, true);
			this.mGame.cancelAllPlayerActions();
		}

		public function openRedeployHealWarningTextBox(param1: Array): void {
			this.openDialog(RedeployHealWarningWindow, [this.closeDialog], null, true);
			this.mGame.cancelAllPlayerActions();
		}
	
		public function openRestartTutorialConfirmationTextBox(): void {
			this.openDialog(ConfirmRestartTutorialWindow, [this.closeDialog], null, true);
			this.mGame.cancelAllPlayerActions();
		}

		public function openOutOfSuppliesTextBox(param1: Array): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, OutOfSuppliesWindow, [this.closeDialog, this.triggerShopOpening, this.openAskSuppliesTextBox, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openAskSuppliesTextBox(param1: Array): void {
			this.mGame.cancelAllPlayerActions();
		}

		public function openAskReviveTextBox(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, AskReviveWindow, [this.closeDialog]);
			this.mGame.cancelAllPlayerActions();
			this.mShowAskReviveWindow = false;
		}

		public function openSupplyCapTextBox(param1: Array): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, SupplyCapFullWindow, [this.closeDialog, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openOutOfIntelTextBox(param1: Array): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, OutOfIntelWindow, [this.closeDialog, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openUnlockItemByBuildingTextBox(param1: ShopItem): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, UnlockItemByBuildingWindow, [this.closeDialog, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openUnlockItemByLevelTextBox(param1: ShopItem): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, UnlockItemByLevelWindow, [this.closeDialog, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openImmediateSuppliesTextBox(param1: MapItem, param2: String, param3: int): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, ImmediateSuppliesWindow, [this.closeDialog, param1, param2, param3]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openUnlockItemByAlliesTextBox(param1: ShopItem): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, UnlockItemByAlliesWindow, [this.closeDialog, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openUnlockItemByMissionTextBox(param1: ShopItem): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, UnlockItemByMissionWindow, [this.closeDialog, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openUnitCapTextBox(param1: ShopItem): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, UnitCapFullWindow, [this.closeDialog, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openInfantryCapTextBox(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, InfantryCapFullWindow, [this.closeDialog]);
			this.mGame.cancelAllPlayerActions();
		}
	
		public function openArmorCapTextBox(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, ArmorCapFullWindow, [this.closeDialog]);
			this.mGame.cancelAllPlayerActions();
		}
	
		public function openArtilleryCapTextBox(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, ArtilleryCapFullWindow, [this.closeDialog]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openUnitDiedTextBox(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, UnitDiedWindow, [this.closeDialog, this.triggerShopOpening]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openOutOfRangeTextBox(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, EnemyOutOfRangeWindow, [this.closeDialog]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openCorpseMarkerTextBox(param1: PlayerUnit): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, CorpseMarkerWindow, [this.closeDialog, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openSellConfirmTextBox(param1: Renderable): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, ConfirmSellingWindow, [this.closeDialog, this.mGame.executeSellObject, param1]);
		}

		public function openExitConfirmWindow(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, ExitConfirmWindow, [this.closeDialog]);
		}

		public function openOutOfMapResourceWindow(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, OutOfMapResourceWindow, [this.closeDialog]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openOutOfEnergyWindow(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, OutOfEnergyWindow, [this.closeDialog]);
			this.mGame.cancelAllPlayerActions();
			this.mGame.mPlayerProfile.removeOutOfEnergyTimer();
		}

		public function openOutOfSocialEnergyWindow(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, OutOfSocialEnergyWindow, [this.closeDialog]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openSingleAttackWarningWindow(): Boolean {
			if (this.mShowSingleAttackWarning) {
				this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, SingleAttackWarningWindow, [this.closeDialog]);
				this.mGame.cancelAllPlayerActions();
				this.mShowSingleAttackWarning = false;
				return true;
			}
			return false;
		}

		public function openInviteFriendsWindow(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, InviteFriendsWindow, [this.closeDialog]);
		}

		public function openSocialWindow(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_FULLSCREEN_NAME, SocialWindowNew, [this.closeDialog]);
		}

		public function openComingSoonDialog(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_FULLSCREEN_NAME, ComingSoonDialog, [this.closeDialog]);
		}

		public function openRankWindow(param1: Mission, param2: Boolean = false): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_01_NAME, RankMissionWindow, [this.closeDialog, param1, param2]);
		}

		public function openMissionProgressWindow(param1: Mission): void {
			if (MissionManager.modalMissionActive() || this.mGame.mState == GameState.STATE_VISITING_NEIGHBOUR || this.mGame.mState == GameState.STATE_INTRO) {
				return;
			}
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_01_NAME, MissionProgressWindow, [this.closeDialog, param1]);
		}

		public function openCampaignWindow(param1: Mission, param2: String = null): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_01_NAME, CampaignWindow, [this.closeDialog, param1, param2]);
		}

		public function openCampaignProgressWindow(param1: Mission, param2: Array, param3: Boolean, param4: String = null): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_01_NAME, CampaignProgressWindow, [param1, this.closeDialog, param2, param3, param4]);
		}

		public function openMissionStackWindow(): void {
			if (MissionManager.modalMissionActive() || this.mGame.mState == GameState.STATE_VISITING_NEIGHBOUR || this.mGame.mState == GameState.STATE_INTRO) {
				return;
			}
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_01_NAME, MissionStackWindow, [this.closeDialog]);
		}

		public function openMissionCompleteWindow(param1: Mission): void {
			if (param1.mType == Mission.TYPE_RANK) {
				ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_NEW_RANK);
			} else {
				ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_LEVEL_UP);
			}
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_01_NAME, MissionCompleteWindow, [this.closeDialog, param1]);
			this.cancelTools();
			System.gc();
		}

		public function openLevelUp(): void {
			ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_LEVEL_UP);
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, LevelUpWindow, [this.closeDialog]);
			System.gc();
		}

		public function openVisitingRewardTextBox(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, VisitingRewardWindow, [this.closeDialog]);
		}

		public function openSocialLevelUp(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, SocialLevelUpWindow, [this.closeDialog]);
		}

		public function openTutorialWindow(param1: Mission): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, TutorialWindow, [this.closeDialog, param1], null, false);
		}

		public function openWelcomeWindow(param1: int, param2: int, param3: int, param4: int): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, WelcomeWindow, [this.closeDialog, param1, param2, param3, param4]);
		}

		public function openWelcomeBraggsFrontWindow(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, WelcomeBraggsFrontWindow, [this.closeDialog]);
		}

		public function openCharacterDialogWindow(param1: Mission): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, CharacterDialoqueWindow, [this.closeDialog, param1]);
		}

		public function openTipWindow(param1: Mission): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, TipWindow, [this.closeDialog, param1]);
		}

		public function openAreaLockedWindow(param1: AreaItem): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, AreaLockedWindow, [this.openAreaShop, this.closeDialog, param1]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openAskPartsDialog(param1: ConstructionObject): void {
			this.cancelTools();
			var _loc2_: ConstructionItem = param1.mItem as ConstructionItem;
			var _loc3_: Array = _loc2_.mIngredientRequiredTypes;
			if (_loc3_.length <= 3) {
				this.openDialogIfResourceLoaded(Config.SWF_POPUPS_01_NAME, AskPartsDialogSmall, [param1, this.closeDialog]);
			} else {
				this.openDialogIfResourceLoaded(Config.SWF_POPUPS_01_NAME, AskPartsDialogBig, [param1, this.closeDialog]);
			}
		}

		public function openProductionDialog(param1: PlayerBuildingObject): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_01_NAME, ProductionDialog, [param1, this.closeDialog]);
			this.cancelTools();
		}

		public function openHireFriendsForProductionDialog(param1: PlayerBuildingObject): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_FULLSCREEN_NAME, HireFriendProductionDialog, [param1, this.closeDialog]);
			this.cancelTools();
		}

		public function openErrorMessage(param1: String, param2: String, param3: ErrorObject, param4: Boolean = true): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, ErrorWindow, [this.closeDialog, param1, param2], null, param4);
			MagicBoxTracker.generateErrorEvent(param3);
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

		public function closeExitConfirmWindow(): void {
			GameState.mInstance.isExitWindowOpen = false;
			this.closeDialog(ExitConfirmWindow);
		}

		public function openIntroTextBox(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, IntroWindow, [this.closeDialog]);
		}

		public function openFreeUnitReceivedWindow(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, FreeUnitReceivedWindow, [this.closeDialog, this.buttonInventoryPressed]);
		}

		public function openFlareWindow(param1: SignalItem): void {}

		public function openSpawningBeaconWindow(): void {}

		public function openDailyRewardTextBox(param1: int, param2: Boolean): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, DailyRewardWindow, [this.closeDialog, param1, param2]);
			this.mGame.cancelAllPlayerActions();
		}

		public function openCollectionTradedTextBox(param1: ItemCollectionItem): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_START_NAME, CollectionTradedWindow, [this.closeDialog, param1]);
		}

		public function openTransactionResponseTextBox(param1: String, param2: String): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, TransactionWindow, [this.closeDialog, param1, param2]);
		}

		public function openRateAppWindow(): void {
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_WARNINGS_NAME, RateAppWindow, [this.closeDialog]);
		}

		private function openDialogIfResourceLoaded(param1: String, param2: Class, param3: Array, param4: * = null, param5: Boolean = true): void {
			var _loc6_: DCResourceManager = null;
			var _loc7_: String = null;
			if (this.mFileBeingLoaded != null) {
				Utils.LogError("Trying to open window while waiting for another one to load");
				return;
			}
			this.mPlaceButton.setVisible(false);
			this.mPlaceCancelButton.setVisible(false);
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

		private function openDialog(param1: Class, param2: Array, param3: * , param4: Boolean): DCWindow {
			var _loc6_: Function = null;
			var _loc5_: DCWindow = null;
			if (PopUpManager.isPopUpCreated(param1)) {
				return PopUpManager.getPopUp(param1) as DCWindow;
			}
			(_loc5_ = PopUpManager.getPopUp(param1, param3) as DCWindow).open(this.mGame.getMainClip(), param4);
			(_loc6_ = _loc5_["Activate"]).apply(_loc5_, param2);
			_loc6_ = null;
			return _loc5_;
		}

		public function switchMissionProgress(param1: Mission, param2: int): void {
			var _loc3_: MissionProgressWindow = PopUpManager.getPopUp(MissionProgressWindow) as MissionProgressWindow;
			_loc3_.Activate(this.closeDialog, param1);
		}

		public function itemCollected(): void {}

		public function getXpBarLocation(): Point {
			return new Point(this.mXpFrame.x + this.mXpFrame.width / 3, this.mXpFrame.y + this.mXpFrame.height / 2 - 5);
		}

		public function getResourcesBarLocation(): Point {
			return new Point(this.mResourceFrame.x - this.mResourceFrame.width / 2, this.mResourceFrame.y + this.mResourceFrame.height / 2);
		}

		public function getEnergyBarLocation(): Point {
			return new Point(this.mEnergyFrame.x, this.mEnergyFrame.y + this.mEnergyFrame.height / 3);
		}

		public function mapResourceGained(): void {}

		public function mapResourcePackRecieved(): void {}

		private function showTooltip(param1: MouseEvent): void {
			var _loc2_: GamePlayerProfile = null;
			var _loc3_: String = null;
			var _loc4_: String = null;
			var _loc5_: * = 0;
			var _loc6_: String = null;
			var _loc7_: int = 0;
			if (!this.mVisitingNeighbor) {
				this.mHudTooltip.setTitleText("");
				this.mHudTooltip.x = param1.stageX;
				this.mHudTooltip.y = param1.stageY;
				_loc2_ = GameState.mInstance.mPlayerProfile;
				if (smTooltipTIDLinkage[(param1.target as DisplayObject).name]) {
					_loc3_ = String(smTooltipTIDLinkage[(param1.target as DisplayObject).name]);
				}
				if ((_loc4_ = (param1.target as DisplayObject).name) == "HitBox_Energy") {
					_loc3_ = GameState.getText("TOOLTIP_HUD_ENERGY");
					if (_loc2_.mEnergy < _loc2_.mMaxEnergy) {
						_loc5_ = (_loc2_.mMaxEnergy - _loc2_.mEnergy - 1) * _loc2_.mTimeBetweenEnergyRecharges + _loc2_.mSecondsToRechargeEnergy;
						_loc6_ = TimeUtils.secondsToString(_loc5_);
						_loc3_ = _loc3_ + " " + GameState.getText("TOOLTIP_HUD_ENERGY_POSTFIX", [_loc6_]);
					}
				} else if (_loc4_ == "HitBox_Xp") {
					_loc7_ = _loc2_.getXpForNextLevel() - _loc2_.mXp;
					_loc3_ = GameState.getText("TOOLTIP_HUD_XP", [_loc7_]);
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
				smTooltipTIDLinkage["HitBox_Energy"] = "";
				smTooltipTIDLinkage["HitBox_Xp"] = "";
				smTooltipTIDLinkage["HitBox_Level"] = GameState.getText("TOOLTIP_HUD_LEVEL");
				smTooltipTIDLinkage["HitBox_Honor_Level"] = GameState.getText("TOOLTIP_HUD_HONOR_LEVEL");
				smTooltipTIDLinkage["HitBox_Visitor_Xp"] = GameState.getText("TOOLTIP_HUD_HONOR");
				smTooltipTIDLinkage["Button_Energy"] = GameState.getText("TOOLTIP_HUD_ENERGY_ADD_BUTTON");
				smTooltipTIDLinkage["Supplies"] = GameState.getText("TOOLTIP_HUD_SUPPLIES");
				smTooltipTIDLinkage["Button_Cash"] = GameState.getText("TOOLTIP_HUD_CASH");
				smTooltipTIDLinkage["Button_Premium"] = GameState.getText("TOOLTIP_HUD_PREMIUM");
				smTooltipTIDLinkage["Button_Sell"] = GameState.getText("TOOLTIP_HUD_TOOLBOX_SELL_BUTTON");
				smTooltipTIDLinkage["Button_Relocate"] = GameState.getText("TOOLTIP_HUD_TOOLBOX_MOVE_BUTTON");
				smTooltipTIDLinkage["Button_Sell_Enabled"] = GameState.getText("TOOLTIP_HUD_TOOLBOX_SELL_CANCEL_BUTTON");
				smTooltipTIDLinkage["Button_Relocate_Enabled"] = GameState.getText("TOOLTIP_HUD_TOOLBOX_MOVE_CANCEL_BUTTON");
				smTooltipTIDLinkage["Button_Inventory"] = GameState.getText("TOOLTIP_HUD_TOOLBOX_INVENTORY_BUTTON");
				smTooltipTIDLinkage["Button_Toggle"] = GameState.getText("TOOLTIP_HUD_TOOLBOX_OPEN_CLOSE_BUTTON");
				smTooltipTIDLinkage["Button_Powerup"] = GameState.getText("HUD_FIRECALL_TOOLTIP");
				smTooltipTIDLinkage["Button_Map"] = GameState.getText("HUD_MAP_TOOLTIP");
				smTooltipTIDLinkage["Button_Pvp"] = GameState.getText("TOOLTIP_HUD_PVP");
				smTooltipTIDLinkage["Button_Tool"] = GameState.getText("TOOLTIP_HUD_REPAIR_TOOL_BUTTON");
				smTooltipTIDLinkage["Button_Shop"] = GameState.getText("TOOLTIP_HUD_SHOP_BUTTON");
				smTooltipTIDLinkage["Button_Save"] = GameState.getText("TOOLTIP_HUD_SHOP_BUTTON");
				smTooltipTIDLinkage["Button_Cancel"] = GameState.getText("TOOLTIP_HUD_CANCEL_BUTTON");
				smTooltipTIDLinkage["Zoom"] = GameState.getText("TOOLTIP_HUD_ZOOM_BAR");
				smTooltipTIDLinkage["Button_Invite"] = GameState.getText("HUD_INVITE_TOOLTIP");
				smTooltipTIDLinkage["Button_Quality_Disabled"] = GameState.getText("TOOLTIP_HUD_SETTINGS_QUALITY_BUTTON");
				smTooltipTIDLinkage["Button_Quality"] = GameState.getText("TOOLTIP_HUD_SETTINGS_QUALITY_BUTTON");
				smTooltipTIDLinkage["Button_Fullscreen_Disabled"] = GameState.getText("TOOLTIP_HUD_SETTINGS_FULLSCREEN_BUTTON");
				smTooltipTIDLinkage["Button_Fullscreen"] = GameState.getText("TOOLTIP_HUD_SETTINGS_FULLSCREEN_BUTTON");
				smTooltipTIDLinkage["Button_Music_Disabled"] = GameState.getText("TOOLTIP_HUD_SETTINGS_MUSIC_BUTTON");
				smTooltipTIDLinkage["Button_Music"] = GameState.getText("TOOLTIP_HUD_SETTINGS_MUSIC_BUTTON");
				smTooltipTIDLinkage["Button_Sounds_Disabled"] = GameState.getText("TOOLTIP_HUD_SETTINGS_SOUND_BUTTON");
				smTooltipTIDLinkage["Button_Sounds"] = GameState.getText("TOOLTIP_HUD_SETTINGS_SOUND_BUTTON");
				smTooltipTIDLinkage["Button_home"] = GameState.getText("TOOLTIP_HUD_HOME");
				smTooltipTIDLinkage["Button_airstrike"] = GameState.getText("HUD_FIRECALL_TOOLTIP");
				smTooltipTIDLinkage["Button_shop"] = GameState.getText("TOOLTIP_HUD_SHOP_BUTTON");
				smTooltipTIDLinkage["Button_social"] = GameState.getText("HUD_INVITE_TOOLTIP");
				smTooltipTIDLinkage["Button_settings"] = GameState.getText("TOOLTIP_HUD_SELL_RELOCATE_OPEN_BUTTON");
				smTooltipTIDLinkage["button_heal"] = GameState.getText("TOOLTIP_HUD_REPAIR_TOOL_BUTTON");
				smTooltipTIDLinkage["button_pullout_tools"] = GameState.getText("TOOLTIP_HUD_TOOLBOX_OPEN_CLOSE_BUTTON");
			}
			_loc1_.push(this.mXpFrame.getChildByName("HitBox_Xp"));
			_loc1_.push(this.mXpFrame.getChildByName("HitBox_Level"));
			trace("_loc1_.push(this.mNeighborActionsFrame.getChildByName('HitBox_Visitor_Energy'));");
			_loc1_.push(this.mEnergyFrame.getChildByName("HitBox_Energy"));
			_loc1_.push(this.mIngameHUDClip.getChildByName("Supplies"));
			_loc1_.push(this.mResourceFrame.getChildByName("Button_Cash"));
			_loc1_.push(this.mResourceFrame.getChildByName("Button_Premium"));
			_loc1_.push(this.mToolBox.getChildByName("Button_Sell"));
			_loc1_.push(this.mToolBox.getChildByName("Button_Relocate"));
			_loc1_.push(this.mToolBox.getChildByName("Button_Sell_Enabled"));
			_loc1_.push(this.mToolBox.getChildByName("Button_Relocate_Enabled"));
			_loc1_.push(this.mPullOutMenu.getChildByName("Button_home"));
			_loc1_.push(this.mPullOutMenu.getChildByName("Button_airstrike"));
			_loc1_.push(this.mPullOutMenu.getChildByName("Button_shop"));
			_loc1_.push(this.mPullOutMenu.getChildByName("Button_save"));
			_loc1_.push(this.mPullOutMenu.getChildByName("Button_social"));
			_loc1_.push(this.mPullOutMenu.getChildByName("Button_Map"));
		    _loc1_.push(this.mPullOutMenu.getChildByName("Button_Pvp"));
			_loc1_.push(this.mPullOutMenu.getChildByName("Button_settings"));
			_loc1_.push(this.mButtonPullOutFrame.getChildByName("button_heal"));
			_loc1_.push(this.mButtonPullOutFrame.getChildByName("button_pullout_tools"));
			this.mouseChildren = true;
			this.mouseEnabled = true;
			var _loc3_: * = _loc1_.length;
			var _loc4_: int = 0;
			while (_loc4_ < _loc3_) {
				_loc2_ = _loc1_[_loc4_] as MovieClip;
				if (_loc2_) {
					_loc2_.mouseEnabled = true;
				}
				_loc4_++;
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
				} else if (param1 is SignalObject) {
					this.mInfoTooltip.setRenderable(param1);
					if (!this.mInfoTooltip.visible) {
						this.mIngameHUDClip.addChild(this.mInfoTooltip);
						this.mInfoTooltip.visible = true;
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
			} else if (param1 is SignalObject) {
				this.mInfoTooltip.setRenderable(param1);
				if (!this.mInfoTooltip.visible) {
					this.mIngameHUDClip.addChild(this.mInfoTooltip);
					this.mInfoTooltip.visible = true;
				}
			} else if (param1 is PlayerBuildingObject || param1 is DebrisObject) {
				if (param1 is ResourceBuildingObject) {
					this.mBuildingWaterPlantTooltip.setRenderable(param1);
					if (!this.mBuildingWaterPlantTooltip.visible) {
						this.mIngameHUDClip.addChild(this.mBuildingWaterPlantTooltip);
						this.mBuildingWaterPlantTooltip.visible = true;
					}
				} else {
					this.mBuildingTooltip.setRenderable(param1, param2);
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

		public function setVisitingNeighbor(param1: Boolean): void {
			this.mEnergyFrame.visible = !param1;
			this.mXpFrame.visible = !param1;
			trace("this.mNeighborActionsFrame.visible = param1;");
			this.mRankIcon = null;
			if (param1) {
				this.mButtonBackHome.setVisible(true);
				this.mButtonBackHomeText.visible = true;
				this.mButtonRepairTool.setEnabled(false);
				this.mButtonRepairTool.setVisible(false);
				this.mButtonRepairToolText.visible = false;
				this.mButtonInventory.setEnabled(false);
				this.mHudButtonShop.setEnabled(false);
				this.mHudButtonSave.setEnabled(false);
				this.mButtonMap.setEnabled(false);
				this.mButtonPvp.setEnabled(false);
				this.mButtonPowerup.setEnabled(false);
				// this.mNeighborName.text = this.mGame.mVisitingFriend.getFirstName();
			} else {
				this.mButtonPowerup.setEnabled(true);
			}
			this.mVisitingNeighbor = param1;
		}

		public function changeWaterVisibility(param1: Boolean): void {
			this.mButtonFrameWater.visible = param1;
		}

		public function getHUDClip(): MovieClip {
			return this.mIngameHUDClip;
		}

		public function getHUDClipBottom(): MovieClip {
			return this.mIngameHUDClip_BOTTOM;
		}

		public function setRepairButtonHighlight(): void {
			var _loc1_: Number = this.mButtonRepairTool.getGlobalX();
			var _loc2_: Number = this.mButtonRepairTool.getGlobalY();
			var _loc3_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "tutorial_repair_01");
			this.mTutorialHighlight = new _loc3_();
			this.mTutorialHighlight.mouseEnabled = false;
			this.mTutorialHighlight.mouseChildren = false;
			var _loc4_: Point = this.mButtonPullOutFrame.globalToLocal(new Point(_loc1_, _loc2_));
			this.mTutorialHighlight.x = _loc4_.x;
			this.mTutorialHighlight.y = _loc4_.y;
			this.mButtonPullOutFrame.addChild(this.mTutorialHighlight);
		}

		public function setSettingButtonHighlight(): void {
			var _loc1_: * = this.mButtonPullOut.getGlobalX() + 40;
			var _loc2_: * = this.mButtonPullOut.getGlobalY() + 50;
			var _loc3_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "tutorial_repair_01");
			this.mTutorialHighlight = new _loc3_();
			this.mTutorialHighlight.mouseEnabled = false;
			this.mTutorialHighlight.mouseChildren = false;
			var _loc4_: Point = this.mButtonPullOutFrame.globalToLocal(new Point(_loc1_, _loc2_));
			this.mTutorialHighlight.x = _loc4_.x;
			this.mTutorialHighlight.y = _loc4_.y;
			this.mButtonPullOutFrame.addChild(this.mTutorialHighlight);
		}

		public function setItemButtonHighlight(): void {
			var _loc1_: * = this.mButtonPullOut.getGlobalX() + 40;
			var _loc2_: * = this.mButtonPullOut.getGlobalY() - 270;
			var _loc3_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "tutorial_repair_01");
			this.mTutorialHighlight = new _loc3_();
			this.mTutorialHighlight.mouseEnabled = false;
			this.mTutorialHighlight.mouseChildren = false;
			var _loc4_: Point = this.mButtonPullOutFrame.globalToLocal(new Point(_loc1_, _loc2_));
			this.mTutorialHighlight.x = _loc4_.x;
			this.mTutorialHighlight.y = _loc4_.y;
			this.mButtonPullOutFrame.addChild(this.mTutorialHighlight);
		}

		public function setMapButtonHighlight(): void {
			var _loc1_: * = this.mButtonMap.getGlobalX() - 90;
			var _loc2_: * = this.mButtonMap.getGlobalY() + 30;
			var _loc3_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "tutorial_circle_01");
			this.mTutorialHighlight = new _loc3_();
			this.mTutorialHighlight.mouseEnabled = false;
			this.mTutorialHighlight.mouseChildren = false;
			this.mTutorialHighlight.x = _loc1_;
			this.mTutorialHighlight.y = _loc2_;
			this.mIngameHUDClip.addChild(this.mTutorialHighlight);
		}

		public function setZoomButtonHighlight(): void {}

		public function setShopButtonHighlight(): void {
			var _loc1_: * = this.mHudButtonShop.getGlobalX() - 90;
			var _loc2_: * = this.mHudButtonShop.getGlobalY() + 30;
			var _loc3_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "tutorial_circle_01");
			this.mTutorialHighlight = new _loc3_();
			this.mTutorialHighlight.mouseEnabled = false;
			this.mTutorialHighlight.mouseChildren = false;
			this.mTutorialHighlight.x = _loc1_;
			this.mTutorialHighlight.y = _loc2_;
			this.mIngameHUDClip.addChild(this.mTutorialHighlight);
		}

		public function setMissionButtonHighlight(): void {
			var _loc1_: * = this.mButtonPullOutMission.getGlobalX() - 80;
			var _loc2_: * = this.mButtonPullOutMission.getGlobalY() + 50;
			var _loc3_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME, "tutorial_circle_01");
			this.mTutorialHighlight = new _loc3_();
			this.mTutorialHighlight.mouseEnabled = false;
			this.mTutorialHighlight.mouseChildren = false;
			this.mTutorialHighlight.x = _loc1_;
			this.mTutorialHighlight.y = _loc2_;
			this.mIngameHUDClip.addChild(this.mTutorialHighlight);
		}

		public function removeTutorialHighlight(): void {
			if (this.mTutorialHighlight) {
				this.mButtonPullOutFrame.removeChild(this.mTutorialHighlight);
				this.mTutorialHighlight = null;
			}
		}

		public function removeShopHighlight(): void {
			if (this.mTutorialHighlight) {
				this.mIngameHUDClip.removeChild(this.mTutorialHighlight);
				this.mTutorialHighlight = null;
			}
		}

		private function buttonFireMissionActivePressed(param1: MouseEvent): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
			if (MissionManager.modalMissionActive() && !MissionManager.openShopMissionActive() || this.mGame.mState == GameState.STATE_VISITING_NEIGHBOUR || this.mGame.mState == GameState.STATE_INTRO) {
				return;
			}
			if (Config.DEBUG_MODE) {}
			this.openDialogIfResourceLoaded(Config.SWF_POPUPS_FULLSCREEN_NAME, FireMissionDialog, [this.closeDialog]);
			this.cancelTools();
			if (this.mCheckFireCallHint) {
				this.mFireCallClickedDuringHintTimer = true;
			}
		}

		private function buttonMapPressed(param1: MouseEvent): void {
			this.openDialogIfResourceLoaded("swf/map", WorldMapWindow, [this.closeDialog]);
		}
	
		private function buttonPvpPressed(param1: MouseEvent): void {
			if (!MissionManager.isTutorialCompleted()) {
				return;
			}
		    GameState.mInstance.openPvPMatchUpDialog();
		}

		public function updateMapButtonEnablation(): void {
			var _loc1_: Boolean = MissionManager.isMapButtonEnabled();
			this.mButtonMap.setEnabled(_loc1_);
			smTooltipTIDLinkage['Button_Map'] = _loc1_ ? GameState.getText('HUD_MAP_TOOLTIP') : GameState.getText('HUD_MAP_LOCKED_TOOLTIP');
		}

		public function openMap(): void {
			if (this.mButtonMap.isEnable()) {
				this.buttonMapPressed(null);
			}
		}

		public function addProfilePicture(): void {}

		public function centerImage(param1: MovieClip): void {}

		public function enableMouse(param1: Boolean): void {
			this.mouseChildren = param1;
			this.mouseEnabled = param1;
		}

		CONFIG::BUILD_FOR_MOBILE_AIR {
			protected function startSaveTimer() {
				timer = new Timer(60000);
				timer.addEventListener(TimerEvent.TIMER, autoSaveGame);
				timer.start();
			}
		}
	}
}