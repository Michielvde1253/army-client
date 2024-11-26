package game.states {
	import com.dchoc.graphics.DCResourceManager;
	import com.dchoc.utils.Cookie;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import game.actions.Action;
	import game.actions.ActionQueue;
	import game.actions.AttackEnemyAction;
	import game.actions.AttackEnemyInstallationAction;
	import game.actions.EnemyAttackingAction;
	import game.actions.EnemyInstallationAttackingAction;
	import game.actions.EnemyMovingAction;
	import game.actions.FireMissionAction;
	import game.actions.HarvestProductionAction;
	import game.actions.NeighborActionQueue;
	import game.actions.PvPAttackEnemyAction;
	import game.actions.PvPAttackEnemyInstallationAction;
	import game.actions.PvPWalkingAction;
	import game.actions.RepairPlayerUnitAction;
	import game.actions.WalkingAction;
	import game.battlefield.MapArea;
	import game.battlefield.MapData;
	import game.battlefield.TileMapGraphic;
	import game.characters.*;
	import game.environment.EnvEffectManager;
	import game.gameElements.ConstructionObject;
	import game.gameElements.DebrisObject;
	import game.gameElements.DecorationObject;
	import game.gameElements.EnemyInstallationObject;
	import game.gameElements.HFEObject;
	import game.gameElements.HFEPlotObject;
	import game.gameElements.PermanentHFEObject;
	import game.gameElements.PlayerBuildingObject;
	import game.gameElements.PlayerInstallationObject;
	import game.gameElements.HospitalBuilding;
	import game.gameElements.Production;
	import game.gameElements.ResourceBuildingObject;
	import game.gameElements.SignalObject;
	import game.gui.AskPartsDialogBig;
	import game.gui.AskPartsDialogSmall;
	import game.gui.GameHUD;
	import game.gui.HUDInterface;
	import game.gui.PauseDialog;
	import game.gui.ProductionDialog;
	import game.gui.SettingsDialogClass;
	import game.gui.ShopDialog;
	import game.gui.TextEffect;
	import game.gui.fireMission.FireMissionDialog;
	import game.gui.inventory.InventoryDialog;
	import game.gui.missions.MissionIconsManager;
	import game.gui.popups.MissionProgressWindow;
	import game.gui.popups.MissionStackWindow;
	import game.gui.popups.PopUpManager;
	import game.gui.pvp.PvPCombatSetupDialog;
	import game.gui.pvp.PvPHUD;
	import game.isometric.GridCell;
	import game.isometric.IsometricScene;
	import game.isometric.SceneLoader;
	import game.isometric.characters.IsometricCharacter;
	import game.isometric.elements.Element;
	import game.isometric.elements.Renderable;
	import game.isometric.elements.WorldObject;
	import game.isometric.pathfinding.AStarPathfinder;
	import game.items.*;
	import game.magicBox.FlurryEvents;
	import game.magicBox.MagicBoxTracker;
	import game.missions.Mission;
	import game.missions.MissionManager;
	import game.missions.Objective;
	import game.net.ErrorObject;
	import game.net.Friend;
	import game.net.FriendsCollection;
	import game.net.MyServer;
	import game.net.PvPMatch;
	import game.net.ServerCall;
	import game.net.ServiceIDs;
	import game.player.GamePlayerProfile;
	import game.player.Inventory;
	import game.player.RankManager;
	import game.player.Wishlist;
	import game.sound.ArmySoundManager;
	import game.utils.TimeUtils;
	import game.utils.WebUtils;
	import game.utils.OfflineSave;
	CONFIG::BUILD_FOR_MOBILE_AIR {
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
		import flash.permissions.PermissionStatus
	}

	public class GameState extends FSMState {

		public static var mObjectCounter: int = 0;

		public static var mOnlineSaving: Boolean = false;

		private static const CHEAT_CODE: String = "HAXXOR";

		private static var smCheatCodeString: String = "";

		public static var smCheatCodeTyped: Boolean;

		public static var smUnlockCheat: Boolean;

		private static var smHiddenErrorMessageCodeString: String = "";

		private static var smDebugCodeString: String = "";

		public static var mConfig: Object;

		public static var mPvPOpponentsConfig: Object;

		public static var mFreezeFrameOn: Boolean;

		public static var mFreezeFrame: Bitmap;

		public static var mFreezeFrameRoot: DisplayObjectContainer;

		public static const STATE_PLAY: int = 0;

		public static const STATE_MOVE_ITEM: int = 1;

		public static const STATE_ROTATE_ITEM: int = 2;

		public static const STATE_PLACE_ITEM: int = 3;

		public static const STATE_PLACE_FIRE_MISSION: int = 4;

		public static const STATE_USE_INVENTORY_ITEM: int = 5;

		public static const STATE_REPAIR_ITEM: int = 6;

		public static const STATE_SELL_ITEM: int = 7;

		public static const STATE_LOADING_NEIGHBOUR: int = 8;

		public static const STATE_VISITING_NEIGHBOUR: int = 9;

		public static const STATE_WAIT_FB_CALLBACK: int = 10;

		public static const STATE_INTRO: int = 11;

		public static const STATE_PICKUP_UNIT: int = 12;

		public static const STATE_PVP: int = 13;

		public static const GRAPHICS_MAP_ID_LIST: Array = ["Home", "Desert"];

		public static var mInstance: GameState;

		private static const GENERAL_BRAGG_ID: String = "1";

		public static var disableMapPanning: Boolean = false;

		private static var appExited: Boolean = false;

		public static var updateUserDataFlag: Boolean = false;

		public static var needToUpdatePermanentHFE: Boolean;

		private static var smLastRealTime: int;

		private static var smCurrentGameTime: int;

		private static var smRealTime: int;

		public static var smTimeFactor: Number = 1;

		private static var smGlobalDeltaTime: int;

		private static var smLastGameTime: int;

		private static const FB_ERROR_CODE_USER_CANCELED: int = 1383010;

		private static const TYPE_BUY_CASH: String = "buy_cash";

		private static const TYPE_BUY_ITEM: String = "buy_item";

		private static const TYPE_UNLOCK_ITEM: String = "unlock_item";

		private static const TYPE_UNLOCK_OBJECTIVE: String = "unlock_objective";


		public var mInitialized: Boolean;

		public var mLoadingStatesOver: Boolean;

		public var mRootNode: Sprite;

		public var mTime: Number;

		public var mCtrlPressed: Boolean;

		private var mFrames: int = 0;

		private var mFrameRate: int = 0;

		private var mTimer: Timer;

		private var mText: TextField;

		private var mErrorDialogOpen: Boolean = false;

		public var mScene: IsometricScene;

		public var mMapData: MapData;

		private var mSpawnEnemyTimer: int;

		public var mActivatedPlayerUnit: PlayerUnit;

		public var mActiveCharacteWalkableCells: Array;

		public var mActiveCharacteNonWalkableCells: Array;

		public var mEnemyWalkableCells: Array;

		public var mMainActionQueue: ActionQueue;

		public var mCurrentAction: Action;

		public var mActionWaitingConfirmation: Action;

		private var mCounterAttackAction: Action;

		public var mCurrentMusic: String;

		public var mNeighborActionQueues: Array;

		public var mDieSoundsEnabled: Boolean = true;

		public var mActivatedEnemyUnit: EnemyUnit;

		public var mCurrentMapId: String = "";

		public var mCurrentMapGraphicsId: int = 0;

		public var mCurrentPlayerMapId: String;

		public var mServer: MyServer;

		private var mItemToBePlaced: MapItem;

		public var mFireMisssionToBePlaced: FireMissionItem;

		public var mObjectToBePlaced: Renderable;

		private var mInventoryItemToBePlaced: MapItem;

		public var mPlayerProfile: GamePlayerProfile;

		public var mVisitingFriend: Friend = null;

		public var mHUD: GameHUD;

		public var mPvPHUD: PvPHUD;

		public var mState: int;

		public var mStateTimer: int;

		public var mOldScreenW: Number;

		public var mOldScreenH: Number;

		public var mMouseX: int = 0;

		public var mMouseY: int = 0;

		public var mZoomLevels: Array;

		private var mZoomIndex: int;

		public var mSavedResponses: Object;

		public var mUpdateMissionButtonsPending: Boolean;

		public var mCityLiberationPlaying: Boolean;

		private var mLoadingClip: MovieClip;

		public var mMissionIconsManager: MissionIconsManager;

		private var mIntroStep: int;

		private var mIntroEnemy: EnemyUnit;

		private var mIntroScrollTime: int;

		private var mClientVersion: String;

		private var mFirstUpdate: Boolean = true;

		public var mShowWelcome: Boolean;

		private var mGrantDailyReward: Boolean = false;

		private var mGrantDailyRewardSpecial: Boolean;

		private var mDailyRewardDay: int;

		private var mEnemiesSpawned: int;

		private var mKilledPlayerUnits: int;

		private var mProductionsReadyToHarvest: int;

		public var mShowFreeUnitsReceived: Boolean = false;

		private var mShowBraggsFrontWelcome: Boolean = true;

		public var mTimers: Array;

		public var mPvPMatch: PvPMatch;

		private var totalMemory: Number;

		public var mAndroidPaymentManager: AndroidPaymentManager;

		public var mAndroidFBConnection: AndroidFacebookConnection;

		public var resumeMusicOnMouseEvent: Boolean = false;

		public var mIndicatedShopItem: Item;

		public var mIndicateInventoryItem: Boolean;

		public var isExitWindowOpen: Boolean;

		private var mNotificationOn: Boolean;

		private var mFogOfWarOn: Boolean = true;

		private var mAnimationsOn: Boolean = true;

		private const TOTAL_NOTIFICATIONS: int = 2;

		private var setReadyNotificationID: int = -1;

		private var setReadyNotificationTime: int = 0;

		private var setWitherNotificationID: int = -1;

		private var setWitherNotificationTime: int = 0;

		private var setCityReadyNotificationID: int = -1;

		private var setCityReadyNotificationTime: int = 0;

		private const LAUNCHES_UNTIL_RATEAPP_PROMPT: int = 4;

		private const DAYS_UNTIL_RATEAPP_PROMPT: int = 1;

		private const DAYS_BEFORE_REMINDING_RATEAPP_PROMPT: int = 2;

		public const MAX_NUMBER_OF_REMINDING_RATEAPP_PROMPT: int = 4;

		private var mInboxCheckerTimer: Timer;

		private var mPricePoint: Object;

		private var mPremiumItem: ShopItem;

		private var mConstruction: ConstructionObject;

		private var mObjective: Objective;

		private var mWishlistItem: Item;

		private var mFrictionlessFriend: Friend;

		private var mFrictionlessGiftID: String;

		public function GameState(param1: StateMachine) {
			this.mRootNode = new Sprite();
			this.mSavedResponses = new Object();
			this.mRootNode.visible = false;
			super(param1);
			mInstance = this;
			this.mOldScreenW = Config.SCREEN_WIDTH;
			this.mOldScreenH = Config.SCREEN_HEIGHT;
			this.handleNative();
		}

		public static function getText(param1: Object, param2: Array = null): String {
			if (!mConfig[JsonParser.TEXTS_TABLE][param1]) {
				return "#" + param1;
			}
			if (!param2) {
				return mConfig[JsonParser.TEXTS_TABLE][param1][Config.smLanguageCode];
			}
			return replaceParameters(mConfig[JsonParser.TEXTS_TABLE][param1][Config.smLanguageCode], param2);
		}

		public static function replaceParameters(param1: String, param2: Array): String {
			if (param2.length == 1) {
				return param1.replace("%U", param2[0]);
			}
			var _loc3_: int = 0;
			while (_loc3_ < param2.length) {
				param1 = param1.replace("%" + _loc3_ + "U", param2[_loc3_]);
				_loc3_++;
			}
			return param1;
		}

		public static function updateGlobalTimer(): void {
			smRealTime = getActualTimer();
			smCurrentGameTime += (smRealTime - smLastRealTime) * smTimeFactor;
			smLastRealTime = smRealTime;
			smGlobalDeltaTime = smCurrentGameTime - smLastGameTime;
			smLastGameTime = smCurrentGameTime;
		}

		public static function getActualTimer(): int {
			if (smCheatCodeTyped) {
				return smCurrentGameTime;
			}
			return getTimer();
		}

		public static function getUserSaveData(): String {
			return "bruh";
		}

		public function unFreezeFrame(): void {
			if (mFreezeFrame) {
				if (mFreezeFrame.parent) {
					mFreezeFrame.parent.removeChild(mFreezeFrame);
				}
				mFreezeFrameRoot.addChildAt(this.mRootNode, 0);
				mFreezeFrame.bitmapData.dispose();
				mFreezeFrame = null;
				mFreezeFrameRoot = null;
				mFreezeFrameOn = false;
			}
		}

		public function freezeFrame(param1: Boolean): void {
			this.unFreezeFrame();
			mFreezeFrame = new Bitmap(new BitmapData(Math.max(1, this.getStageWidth()), Math.max(1, this.getStageHeight()), true, 0));
			if (this.mRootNode.parent) {
				mFreezeFrameRoot = this.mRootNode.parent;
				this.mRootNode.parent.removeChild(this.mRootNode);
			}
			mFreezeFrame.bitmapData.draw(this.mRootNode, null, null, null, mFreezeFrame.bitmapData.rect, false);
			mFreezeFrameRoot.addChildAt(mFreezeFrame, 0);
			mFreezeFrameOn = true;
		}

		override public function enter(): void {
			this.mRootNode.visible = true;
		}

		override public function exit(): void {
			this.mRootNode.visible = false;
		}

		public function changeState(param1: int): void {
			var _loc2_: Element = null;
			var _loc3_: int = 0;
			var _loc4_: int = 0;
			var _loc5_: HFEObject = null;
			var _loc6_: GridCell = null;
			var _loc7_: int = 0;
			switch (param1) {
				case STATE_PLAY:
					if (FeatureTuner.USE_PVP_MATCH) {
						if (this.mPvPHUD) {
							this.changeFromPvPHUD();
						}
					}
					if (this.mState == STATE_MOVE_ITEM) {
						this.mScene.exitMoveMode();
					}
					this.mHUD.setVisitingNeighbor(false);
					disableMapPanning = false;
					break;
				case STATE_PLACE_ITEM:
				case STATE_USE_INVENTORY_ITEM:
					this.mScene.stopCharacterAnimations();
					disableMapPanning = true;
					break;
				case STATE_MOVE_ITEM:
					this.mScene.stopCharacterAnimations();
					this.mScene.mMapGUIEffectsLayer.highlightMovableObjects();
					disableMapPanning = true;
					break;
				case STATE_SELL_ITEM:
					this.mScene.mMapGUIEffectsLayer.highlightSellableObjects();
					break;
				case STATE_PICKUP_UNIT:
					this.mScene.mMapGUIEffectsLayer.highlightPickupableUnitCells();
					break;
				case STATE_REPAIR_ITEM:
					this.mScene.mMapGUIEffectsLayer.highlightRepairEnabledCells();
					break;
				case STATE_PLACE_FIRE_MISSION:
					this.mHUD.showCancelButton(true);
					this.mScene.mMapGUIEffectsLayer.highlightFireMission();
					disableMapPanning = true;
					break;
				case STATE_VISITING_NEIGHBOUR:
					this.mHUD.setVisitingNeighbor(true);
					break;
				case STATE_INTRO:
					_loc3_ = int(GameState.mInstance.mScene.mAllElements.length);
					_loc4_ = 0;
					while (_loc4_ < _loc3_) {
						_loc2_ = GameState.mInstance.mScene.mAllElements[_loc4_] as Element;
						if (_loc2_ is HFEObject) {
							_loc6_ = (_loc5_ = _loc2_ as HFEObject).getCell();
							_loc7_ = 0;
							if (_loc6_.mPosI == 51) {
								_loc7_ = 1;
							}
							_loc5_.getProduction().setRemainingProductionTime(_loc7_);
						}
						_loc4_++;
					}
					break;
				case STATE_PVP:
					if (FeatureTuner.USE_PVP_MATCH) {
						if (this.mState == STATE_MOVE_ITEM) {
							this.mScene.exitMoveMode();
						}
						if (this.mHUD) {
							this.mHUD.setVisitingNeighbor(false);
						}
						if (this.mState != param1) {
							this.changeToPvPHUD();
						}
					}
			}
			this.mState = param1;
			this.mStateTimer = 0;
		}

		public function changeToPvPHUD(): void {
			if (FeatureTuner.USE_PVP_MATCH) {
				if (this.mPvPHUD) {
					return;
				}
				if (this.mHUD) {
					this.mMissionIconsManager = null;
					this.mRootNode.removeChild(this.mHUD);
				}
				this.mHUD = null;
				this.mPvPHUD = new PvPHUD(this);
				this.mPvPHUD.setZoomIndicator(this.mZoomIndex);
				this.mRootNode.addChild(this.mPvPHUD);
			}
		}

		public function changeFromPvPHUD(): void {
			if (FeatureTuner.USE_PVP_MATCH) {
				if (this.mHUD) {
					return;
				}
				if (this.mPvPHUD) {
					this.mRootNode.removeChild(this.mPvPHUD);
				}
				this.mPvPHUD = null;
				if (!this.mHUD) {
					this.mHUD = new GameHUD(this);
				}
				this.mRootNode.addChild(this.mHUD);
				this.mMissionIconsManager = new MissionIconsManager(this.mHUD);
				this.mMissionIconsManager.resize(this.getStageWidth(), this.getStageHeight());
			}
		}

		public function updateGrid(): void {
			this.mScene.updateGridInformation();
			this.mScene.updateGridCharacterInfo();
			this.mScene.startCharacterAnimations();
		}

		public function reactToFullscreen(param1: Event = null): void {
			this.windowSizeChanged();
			try {
				this.mMapData.mUpdateRequired = true;
				this.mScene.mFog.mUpdateRequired = true;
			} catch (error: Error) {}
		}

		public function windowSizeChanged(param1: Event = null): void {
			//this.mScene.mTilemapGraphic.generateLayers();
			//var _loc2_:int = Math.max(Config.SCREEN_HEIGHT,this.getStageHeight());
			//var _loc3_:int = Math.max(Config.SCREEN_WIDTH,this.getStageWidth());

			try {
				var _loc2_: int = this.getStageHeight();
				var _loc3_: int = this.getStageWidth();
				trace(_loc2_);
				trace(_loc3_)
				this.getHud().resize(_loc3_, _loc2_);
				if (this.mMissionIconsManager) {
					this.mMissionIconsManager.resize(_loc3_, _loc2_);
				}
				this.mScene.reCalculateCameraMargins();
				this.mScene.mAbsoluteVisibleArea.graphics.clear();
				this.mScene.mAbsoluteVisibleArea.graphics.drawRect(0, 0, _loc3_, _loc2_);
				this.mScene.mRelativeVisibleArea.graphics.clear();
				this.mScene.mRelativeVisibleArea.graphics.drawRect(-_loc3_ / this.mScene.mContainer.scaleX / 2, -_loc2_ / this.mScene.mContainer.scaleX / 2, _loc3_ / this.mScene.mContainer.scaleX, _loc2_ / this.mScene.mContainer.scaleX);
				this.mText.x = _loc3_ - this.mText.width;
				this.mOldScreenH = _loc2_;
				this.mOldScreenW = _loc3_;
				this.getHud().updateToggleButtonStates();
				if (mFreezeFrameOn) {
					this.mScene.updateCamera(0);
				}
				this.mScene.mTilemapGraphic.updateTilemap();
			} catch (error: Error) {}
		}

		public function checkMissionProgress(): void {
			if (this.mMissionIconsManager) {
				this.mMissionIconsManager.checkMissionProgress();
			}
		}

		public function toggleUnlockCheat(): void {
			smUnlockCheat = !smUnlockCheat && smCheatCodeTyped;
		}

		public function toggleFullScreen(): void {
			var _loc1_: Stage = getMainClip().stage;
			if (getMainClip().stage.displayState == StageDisplayState.NORMAL) {
				_loc1_.scaleMode = StageScaleMode.NO_SCALE;
				getMainClip().stage.displayState = StageDisplayState.FULL_SCREEN;
			} else {
				getMainClip().stage.displayState = StageDisplayState.NORMAL;
				_loc1_.scaleMode = StageScaleMode.SHOW_ALL;
			}
			this.getHud().updateToggleButtonStates();
		}

		public function setZoomIndex(param1: int): void {
			this.mZoomIndex = Math.min(Math.max(0, param1), this.mZoomLevels.length - 1);
			var _loc2_: Number = this.mZoomLevels[this.mZoomLevels.length - 1 - this.mZoomIndex] / 100;
			this.mScene.setScale(_loc2_);
			this.getHud().setZoomIndicator(this.mZoomIndex);
			Cookie.saveCookieVariable(Config.COOKIE_SESSION_NAME, Config.COOKIE_SESSION_NAME_ZOOM_INDEX, param1);
		}

		public function isEditMode(): Boolean {
			return this.mState == STATE_MOVE_ITEM || this.mState == STATE_PLACE_ITEM || this.mState == STATE_USE_INVENTORY_ITEM;
		}

		private function updateTime(): void {
			this.mTime = new Date().time;
		}

		override public function logicUpdate(param1: int): void {
			var _loc3_: int = 0;
			var _loc4_: int = 0;
			var _loc5_: Number = NaN;
			var _loc6_: Number = NaN;
			var _loc7_: Number = NaN;
			var _loc8_: Number = NaN;
			var _loc9_: int = 0;
			var _loc10_: int = 0;
			var _loc11_: Number = NaN;
			var _loc12_: Number = NaN;
			var _loc13_: GridCell = null;
			var _loc14_: GridCell = null;
			var _loc15_: PlayerUnit = null;
			var _loc16_: Array = null;
			var _loc17_: Mission = null;
			var _loc18_: Objective = null;
			var _loc19_: Boolean = false;
			var _loc20_: Object = null;
			var _loc21_: Object = null;
			var _loc22_: Object = null;
			var _loc23_: Mission = null;
			var _loc24_: int = 0;
			var _loc2_: Boolean = true;
			if (smCheatCodeTyped) {
				updateGlobalTimer();
			} else {
				smGlobalDeltaTime = param1;
			}
			if (Config.DEBUG_FPS) {
				this.totalMemory = Number(System.totalMemory / 1024 / 1024);
				this.updateDebugText();
			}
			if (!this.mInitialized || !this.mScene || mFreezeFrameOn && !this.mServer.isConnectionError() && !this.mServer.isServerCommError()) {
				return;
			}
			if (!this.updateLoading()) {
				return;
			}
			if (!this.processServerResponses()) {
				return;
			}
			param1 = Math.min(param1, 40);
			MissionManager.update();
			switch (this.mState) {
				case STATE_PLAY:
					this.updateSpawnLevelsTimer(smGlobalDeltaTime);
					break;
				case STATE_INTRO:
					if (this.mIntroStep == 0) {
						_loc3_ = int(this.mMapData.mMapSetupData.DefaultCellX);
						_loc4_ = (_loc4_ = int(this.mMapData.mMapSetupData.DefaultCellY)) + 1;
						_loc5_ = this.mScene.getCenterPointXAtIJ(_loc3_, _loc4_);
						_loc6_ = this.mScene.getCenterPointYAtIJ(_loc3_, _loc4_);
						_loc7_ = this.mScene.getCenterPointYAtIJ(_loc3_, _loc4_ + 7);
						this.mIntroScrollTime += param1;
						_loc8_ = _loc6_;
						this.mScene.mCamera.moveTo(_loc5_, _loc7_);
						trace("just here")
						++this.mIntroStep;
					} else if (this.mIntroStep == 1) {
						_loc9_ = int(mConfig.Tutorial.PlayerUnit.Unit.AreaX);
						_loc10_ = int(mConfig.Tutorial.PlayerUnit.Unit.AreaY);
						_loc11_ = this.mScene.getCenterPointXAtIJ(_loc9_, _loc10_);
						_loc12_ = this.mScene.getCenterPointYAtIJ(_loc9_, _loc10_);
						_loc13_ = this.mScene.getCellAt(mConfig.Tutorial.EnemyUnit.Unit.AreaX, mConfig.Tutorial.EnemyUnit.Unit.AreaY);
						this.mIntroEnemy = _loc13_.mCharacter as EnemyUnit;
						_loc14_ = this.mScene.getCellAt(mConfig.Tutorial.EnemyMoveTarget.TileX, mConfig.Tutorial.EnemyMoveTarget.TileY);
						this.mIntroEnemy.queueAction(new EnemyMovingAction(this.mIntroEnemy, _loc14_));
						++this.mIntroStep;
					} else if (this.mIntroStep == 2) {
						if (this.mMainActionQueue.mActions.length == 0) {
							if (this.mCurrentAction == null) {
								_loc15_ = (_loc14_ = this.mScene.getCellAt(mConfig.Tutorial.PlayerUnit.Unit.AreaX, mConfig.Tutorial.PlayerUnit.Unit.AreaY)).mCharacter as PlayerUnit;
								this.mIntroEnemy.queueAction(new EnemyAttackingAction(this.mIntroEnemy, _loc15_));
								++this.mIntroStep;
							}
						}
					} else if (this.mIntroStep == 3) {
						if (this.mMainActionQueue.mActions.length == 0) {
							if (this.mCurrentAction == null) {
								MissionManager.increaseCounter("Intro", null, 1);
								this.changeState(STATE_PLAY);
							}
						}
					}
			}
			this.getHud().logicUpdate(param1);
			if (PopUpManager.isModalPopupActive()) {
				return;
			}
			if (param1 > 0) {
				this.mStateTimer += param1;
			}
			if (this.mState != STATE_PVP) {
				if (!this.mCityLiberationPlaying) {
					if (!PopUpManager.isModalPopupActive()) {
						if (_loc16_ = MissionManager.getNextCompleteCampaignObjective()) {
							_loc17_ = _loc16_[0];
							_loc18_ = _loc16_[1];
							_loc19_ = false;
							_loc20_ = GameState.mConfig.CampaignObjectiveAdd;
							for (_loc21_ in _loc20_) {
								if (_loc21_ == _loc18_.mId) {
									if ((_loc22_ = _loc20_[_loc21_] as Object).CompletionText.length > 0) {
										this.mHUD.openCampaignProgressWindow(_loc17_, _loc22_.CompletionText, false, _loc18_.mId);
										_loc2_ = false;
									}
									_loc19_ = true;
									break;
								}
							}
							if (!_loc19_) {
								this.mHUD.openCampaignWindow(_loc17_, _loc18_.mId);
								_loc2_ = false;
							}
						}
					}
					if (!PopUpManager.isModalPopupActive()) {
						if (_loc23_ = MissionManager.getNextCompletedMission()) {
							_loc23_.collectRewards();
							if (_loc23_.mType == Mission.TYPE_NORMAL) {
								this.mHUD.openMissionCompleteWindow(_loc23_);
								_loc2_ = false;
							} else if (_loc23_.mType == Mission.TYPE_RANK) {
								this.mHUD.openRankWindow(_loc23_, true);
								_loc2_ = false;
							}
							this.mUpdateMissionButtonsPending = true;
							MissionManager.smFindNewMissionsPending = true;
							if (Config.USE_WORLD_MAP) {
								this.mHUD.updateMapButtonEnablation();
							}
						}
					}
					if (!PopUpManager.isModalPopupActive()) {
						if (this.mPlayerProfile.wasLevelGained()) {
							this.mHUD.openLevelUp();
							_loc2_ = false;
						} else if (this.mPlayerProfile.wasSocialLevelGained()) {
							this.mHUD.openSocialLevelUp();
							_loc2_ = false;
						} else if (MissionManager.smFindNewMissionsPending) {
							MissionManager.findNewActiveMissions();
						}
					}
					if (!PopUpManager.isModalPopupActive()) {
						if (MissionManager.getNumCompletedMissions() == 0) {
							if (this.mUpdateMissionButtonsPending) {
								this.mMissionIconsManager.updateMissionButtons();
								this.mUpdateMissionButtonsPending = false;
							}
						}
						this.mMissionIconsManager.logicUpdate();
					}
				}
			}
			if (_loc2_) {
				this.updateActions(smGlobalDeltaTime);
				if (this.mState == STATE_PVP) {
					if (FeatureTuner.USE_PVP_MATCH) {
						if (this.mCurrentAction == null) {
							if (this.mMainActionQueue.mActions.length == 0) {
								this.mPvPMatch.updateTurn(param1);
							}
						}
					}
				}
			}
			this.mScene.update(smGlobalDeltaTime);
			if (this.mFirstUpdate) {
				// MOBILE: load save file
				CONFIG::BUILD_FOR_MOBILE_AIR {
					this.startSelectingFile();
				}
			}
			if (!this.mFirstUpdate) {
				if (this.mLoadingStatesOver) {
					if (this.mState != STATE_PVP) {
						if (!PopUpManager.isAnyPopupActive()) {
							if (this.mShowWelcome) {
								_loc24_ = this.mScene.getNumberOfEnemiesReadyToAct();
								if (this.mEnemiesSpawned > 0 || _loc24_ > 0 || this.mKilledPlayerUnits > 0 || this.mProductionsReadyToHarvest > 0) {
									this.mHUD.openWelcomeWindow(this.mEnemiesSpawned, _loc24_, this.mKilledPlayerUnits, this.mProductionsReadyToHarvest);
								}
								this.mShowWelcome = false;
							} else if (this.mGrantDailyReward && MissionManager.isTutorialCompleted()) {
								this.mHUD.openDailyRewardTextBox(this.mDailyRewardDay, this.mGrantDailyRewardSpecial);
								this.mGrantDailyReward = false;
							} else if (this.mShowFreeUnitsReceived && MissionManager.isTutorialCompleted()) {
								this.mHUD.openFreeUnitReceivedWindow();
								this.mShowFreeUnitsReceived = false;
							}
						}
					}
				}
			}
			this.mFirstUpdate = false;
		}

		CONFIG::BUILD_FOR_MOBILE_AIR {
			public function startSelectingFile(): void {
				trace("saved the game")
				var file: File = File.documentsDirectory.resolvePath("ArmyAttack/savefile.txt");
				if (!file.exists || Cookie.readCookieVariable(Config.COOKIE_SETTINGS_NAME, Config.COOKIE_SETTINGS_NAME_SAVELOCATION) == "legacy" || Cookie.readCookieVariable(Config.COOKIE_SETTINGS_NAME, Config.COOKIE_SETTINGS_NAME_SAVELOCATION) == "") {
					// Check if a legacy save file (from v21) exists, use if yes
					file = File.applicationStorageDirectory.resolvePath("savefile.txt");
					if (!file.exists) {
						return
					}
				}
				file.addEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
				file.requestPermission();
			}
		}

		CONFIG::BUILD_FOR_MOBILE_AIR {
			public function onPermission(e: PermissionEvent): void {
				var file: File = e.target as File;
				file.removeEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
				if (e.status == PermissionStatus.GRANTED) {
					var fs: FileStream = new FileStream();
					fs.open(file, FileMode.READ);
					var savedata: * = JSON.parse(fs.readUTFBytes(fs.bytesAvailable));
					fs.close();
					OfflineSave.loadProgress(savedata);
				}
			}
		}

		public function initializeFlurry(): void {}

		private function enterFrameMissionInitial(param1: Event): void {
			if (Boolean(this.mHUD) && Boolean(this.mHUD.mPullOutMissionFrame)) {
				if (this.mHUD.mPullOutMissionFrame.currentFrameLabel == "Normal") {
					this.mHUD.mPullOutMissionFrame.visible = true;
					this.mHUD.mPullOutMissionFrame.stop();
					this.mHUD.mPullOutMissionFrame.removeEventListener(Event.ENTER_FRAME, this.enterFrameMissionInitial);
				} else if (GameState.mInstance.mHUD.mPullOutMissionFrame.currentFrame == GameState.mInstance.mHUD.mPullOutMissionFrame.totalFrames) {
					this.mHUD.mPullOutMissionFrame.gotoAndStop(1);
					this.mHUD.mPullOutMissionFrame.removeEventListener(Event.ENTER_FRAME, this.enterFrameMissionInitial);
					this.mHUD.mPullOutMissionFrame.visible = false;
				}
			}
		}

		private function handleNative(): void {}

		public function removeNative(): void {}

		private function handleActivate(param1: Event): void {
			var _loc2_: Object = null;
			if (this.mInitialized) {
				if (this.mHUD && this.mHUD.mPullOutMissionFrame && MissionManager.isTutorialCompleted() && this.mHUD.mPullOutMissionMenuState == this.mHUD.STATE_MISSIONS_MENU_CLOSED && MissionManager.isShowMissionButtonCompleted()) {
					this.mHUD.mPullOutMissionFrame.visible = true;
					this.mHUD.mPullOutMissionFrame.gotoAndPlay("Open");
					this.mHUD.mPullOutMissionMenuState = this.mHUD.STATE_MISSIONS_MENU_OPEN;
					this.mHUD.mPullOutMissionFrame.addEventListener(Event.ENTER_FRAME, this.enterFrameMissionInitial);
				}
				this.resumeMusicOnMouseEvent = true;
				if (FeatureTuner.USE_LOCAL_NOTIFICATION) {
					this.restoreNotificationSettings();
					this.clearNotification();
				}
				if (Config.RESTART_STATUS == -1 && MissionManager.isTutorialCompleted() && Boolean(this.mServer)) {
					_loc2_ = {
						"map_id": "Home"
					};
					updateUserDataFlag = true;
					this.mServer.serverCallServiceWithParameters(ServiceIDs.GET_USER_DATA, _loc2_, true);
				}
				if (appExited == true) {
					appExited = false;
				}
			}
		}

		private function handleDeactivate(param1: Event): void {
			if (this.mInitialized) {
				ArmySoundManager.getInstance().stopAll();
				if (FeatureTuner.USE_LOCAL_NOTIFICATION) {
					this.createNotification();
				}
				if (appExited == false) {
					appExited = true;
				}
			}
		}

		private function handleKeys(param1: KeyboardEvent): void {
			if (param1.keyCode == Keyboard.BACK) {
				if (this.mScene != null && this.mScene.mCamera != null) {
					this.mScene.mCamera.update(0);
				}
				param1.preventDefault();
				if (this.mHUD != null) {
					if (!this.isExitWindowOpen) {
						this.mHUD.openExitConfirmWindow();
					} else {
						this.mHUD.closeExitConfirmWindow();
					}
				}
			}
		}

		public function isNotificationOn(): Boolean {
			return this.mNotificationOn;
		}

		public function setNotificationOn(param1: Boolean): void {
			this.mNotificationOn = param1;
			Cookie.saveCookieVariable(Config.COOKIE_SETTINGS_NAME, Config.COOKIE_SETTINGS_NAME_NOTIFICATION, this.mNotificationOn);
		}

		private function restoreNotificationSettings(): void {
			trace("DISABLED AS NOTIFICATIONS HAVE BEEN REPLACED WITH FOG OF WAR IN SETTINGS");
			var _loc1_: String = Cookie.readCookieVariable(Config.COOKIE_SETTINGS_NAME, Config.COOKIE_SETTINGS_NAME_NOTIFICATION);
			if (_loc1_ == "false") {
				this.setNotificationOn(false);
			} else {
				this.setNotificationOn(false);
			}
		}

		private function createNotification(): void {
			var _loc1_: int = 0;
			var _loc2_: int = 0;
			var _loc3_: Element = null;
			var _loc4_: int = 0;
			var _loc5_: int = 0;
			var _loc6_: int = 0;
			var _loc7_: int = 0;
			var _loc8_: Production = null;
			var _loc9_: int = 0;
			if (this.isNotificationOn()) {
				if (!MissionManager.isTutorialCompleted()) {}
				_loc1_ = this.mPlayerProfile.mMaxEnergy - this.mPlayerProfile.mEnergy;
				_loc2_ = (_loc1_ - 1) * this.mPlayerProfile.mTimeBetweenEnergyRecharges * 1000 + this.mPlayerProfile.mSecondsToRechargeEnergy * 1000;
				if (_loc2_ > 0) {}
				if (GameState.mInstance.mScene == null) {
					return;
				}
				_loc4_ = int(GameState.mInstance.mScene.mAllElements.length);
				_loc5_ = 0;
				while (_loc5_ < _loc4_) {
					_loc3_ = GameState.mInstance.mScene.mAllElements[_loc5_] as Element;
					if (_loc3_ is HFEObject) {
						if ((_loc3_ as HFEObject).getProduction()) {
							if ((_loc3_ as HFEObject).mState == PlayerBuildingObject.STATE_PRODUCING) {
								_loc6_ = (_loc6_ = (_loc3_ as HFEObject).getProduction().getProducingTimeLeft()) + 15 * 60000;
							}
							if ((_loc3_ as HFEObject).mState == PlayerBuildingObject.STATE_PRODUCTION_READY) {
								_loc7_ = (_loc7_ = (_loc3_ as HFEObject).getProduction().getTimeToWither()) - 30 * 60000;
							}
						}
					}
					if (_loc3_ is PermanentHFEObject) {
						if (_loc8_ = (_loc3_ as PermanentHFEObject).getProduction()) {
							if (!_loc8_.isReady()) {
								_loc9_ = _loc8_.getProducingTimeLeft();
							}
						}
					}
					_loc5_++;
				}
			}
		}

		private function isSupplyReadyTriggereable(param1: int, param2: int, param3: int): Boolean {
			if (param2 < 0) {
				return false;
			}
			if (this.setReadyNotificationID == param1 && Math.abs(this.setReadyNotificationTime - param2) < param3) {
				return false;
			}
			return true;
		}

		private function isSupplyWitheredTriggereable(param1: int, param2: int, param3: int): Boolean {
			if (param2 < 0) {
				return false;
			}
			if (this.setWitherNotificationID == param1 && Math.abs(this.setWitherNotificationTime - param2) < param3) {
				return false;
			}
			return true;
		}

		private function isCityReadyTriggereable(param1: int, param2: int, param3: int): Boolean {
			if (param2 < 0) {
				return false;
			}
			if (this.setCityReadyNotificationID == param1 && Math.abs(this.setCityReadyNotificationTime - param2) < param3) {
				return false;
			}
			return true;
		}

		private function clearNotification(): void {}

		public function checkRateApp(): void {
			var _loc2_: int = 0;
			var _loc3_: Number = NaN;
			var _loc5_: Number = NaN;
			var _loc9_: Date = null;
			var _loc10_: Number = NaN;
			var _loc11_: Date = null;
			var _loc12_: Number = NaN;
			var _loc13_: Date = null;
			if (FeatureTuner.USE_DEBUG_RATEAPP_POPUP) {
				this.mHUD.openRateAppWindow();
				return;
			}
			var _loc1_: Boolean = true;
			var _loc4_: Boolean = false;
			var _loc6_: Boolean = false;
			var _loc7_: Boolean = false;
			if ((_loc6_ = Cookie.readCookieVariable(Config.COOKIE_APPRATER_NAME, Config.COOKIE_APPRATER_NAME_RATE_CLICKED)) != true) {
				_loc6_ = false;
			}
			if ((_loc7_ = Cookie.readCookieVariable(Config.COOKIE_APPRATER_NAME, Config.COOKIE_APPRATER_NAME_DONT_SHOW)) != true) {
				_loc7_ = false;
			}
			if (_loc6_ == true || _loc7_ == true) {
				return;
			}
			_loc1_ = Cookie.readCookieVariable(Config.COOKIE_APPRATER_NAME, Config.COOKIE_APPRATER_NAME_FIRST_LAUNCHED);
			if (_loc1_ == false) {
				_loc2_ = Cookie.readCookieVariable(Config.COOKIE_APPRATER_NAME, Config.COOKIE_APPRATER_NAME_LAUNCH_COUNT);
				_loc3_ = Cookie.readCookieVariable(Config.COOKIE_APPRATER_NAME, Config.COOKIE_APPRATER_NAME_DATE_FIRST_LAUNCHED);
			} else {
				_loc2_ = 0;
				_loc3_ = 0;
				Cookie.saveCookieVariable(Config.COOKIE_APPRATER_NAME, Config.COOKIE_APPRATER_NAME_FIRST_LAUNCHED, false);
			}
			if ((_loc4_ = Cookie.readCookieVariable(Config.COOKIE_APPRATER_NAME, Config.COOKIE_APPRATER_NAME_REMINDER_PRESSED)) == true) {
				_loc5_ = Cookie.readCookieVariable(Config.COOKIE_APPRATER_NAME, Config.COOKIE_APPRATER_NAME_DATE_REMINDER_PRESSED);
			} else {
				_loc5_ = 0;
			}
			var _loc8_: String = Config.getAppVersion();
			if (Cookie.readCookieVariable(Config.COOKIE_APPRATER_NAME, Config.COOKIE_APPRATER_NAME_APP_VERSION_CODE) != _loc8_) {
				_loc2_ = 0;
			}
			Cookie.saveCookieVariable(Config.COOKIE_APPRATER_NAME, Config.COOKIE_APPRATER_NAME_APP_VERSION_CODE, _loc8_);
			_loc2_++;
			Cookie.saveCookieVariable(Config.COOKIE_APPRATER_NAME, Config.COOKIE_APPRATER_NAME_LAUNCH_COUNT, _loc2_);
			if (_loc3_ == 0) {
				_loc3_ = (_loc9_ = new Date()).time;
				Cookie.saveCookieVariable(Config.COOKIE_APPRATER_NAME, Config.COOKIE_APPRATER_NAME_DATE_FIRST_LAUNCHED, _loc3_);
			}
			if (_loc2_ >= this.LAUNCHES_UNTIL_RATEAPP_PROMPT) {
				_loc10_ = this.DAYS_UNTIL_RATEAPP_PROMPT * 24 * 60 * 60 * 1000;
				if ((_loc11_ = new Date()).time >= _loc3_ + _loc10_) {
					if (_loc5_ == 0) {
						this.mHUD.openRateAppWindow();
					} else {
						_loc12_ = this.DAYS_BEFORE_REMINDING_RATEAPP_PROMPT * 24 * 60 * 60 * 1000;
						if ((_loc13_ = new Date()).time >= _loc12_ + _loc5_) {
							this.mHUD.openRateAppWindow();
						}
					}
				}
			}
		}

		public function cancelAllPlayerActions(): Boolean {
			var _loc2_: int = 0;
			var _loc3_: Action = null;
			var _loc1_: * = this.mCurrentAction != null;
			if (_loc1_) {
				if (!this.mCurrentAction.isEnemyAction()) {
					if (!this.mCurrentAction.isPlayerInstallationAction()) {
						this.mCurrentAction.skip();
					}
				}
			}
			if (this.mMainActionQueue) {
				if (this.mMainActionQueue.mActions) {
					_loc2_ = 0;
					while (_loc2_ < this.mMainActionQueue.mActions.length) {
						_loc3_ = this.mMainActionQueue.mActions[_loc2_];
						if (_loc3_) {
							if (!_loc3_.isEnemyAction()) {
								if (!_loc3_.isPlayerInstallationAction()) {
									_loc3_.skip();
								}
							}
						}
						_loc2_++;
					}
				}
			}
			return _loc1_;
		}

		public function cancelAllActions(): Boolean {
			var _loc2_: int = 0;
			var _loc3_: Action = null;
			var _loc1_: * = this.mCurrentAction != null;
			if (_loc1_) {
				this.mCurrentAction.skip();
			}
			if (this.mMainActionQueue) {
				if (this.mMainActionQueue.mActions) {
					_loc2_ = 0;
					while (_loc2_ < this.mMainActionQueue.mActions.length) {
						_loc3_ = this.mMainActionQueue.mActions[_loc2_];
						if (_loc3_) {
							_loc3_.skip();
						}
						_loc2_++;
					}
				}
			}
			return _loc1_;
		}

		public function playerMoveMade(): void {
			var _loc2_: Object = null;
			var _loc3_: GridCell = null;
			var _loc4_: Boolean = false;
			var _loc5_: Object = null;
			if (this.mState == STATE_VISITING_NEIGHBOUR) {
				return;
			}
			if (FeatureTuner.USE_PVP_MATCH) {
				if (this.mState == STATE_PVP && Boolean(this.mPvPHUD)) {
					--this.mPvPMatch.mActionsLeft;
					this.mPvPHUD.mTextUpdateRequired = true;
				}
			}
			var _loc1_: * = "";
			for each(_loc2_ in this.mScene.mAllElements) {
				if (_loc2_ is EnemyInstallationObject) {
					if (EnemyInstallationObject(_loc2_).isTurnBased()) {
						if (EnemyInstallationObject(_loc2_).getHealth() > 0) {
							_loc3_ = EnemyInstallationObject(_loc2_).getCell();
							if (_loc3_) {
								if (_loc4_ = EnemyInstallationObject(_loc2_).playerMoveMade()) {
									if (_loc1_.length > 0) {
										_loc1_ += ";";
									}
									_loc1_ += _loc3_.mPosI + "," + _loc3_.mPosJ;
								}
							}
						}
					}
				} else if(_loc2_ is HospitalBuilding){
					if (HospitalBuilding(_loc2_).readyToHeal()) {
						HospitalBuilding(_loc2_).checkNeighbours();
					}
				}
			}
			if (this.mState != STATE_PVP) {
				if (_loc1_.length > 0) {
					_loc5_ = {
						"enemy_coords": _loc1_
					};
					this.mServer.serverCallServiceWithParameters(ServiceIDs.INCREMENT_TURN_COUNTERS, _loc5_, false);
				}
			}
		}

		public function enemyMoveMade(): void {
			if (FeatureTuner.USE_PVP_MATCH) {
				if (this.mState == STATE_PVP) {
					if (this.mPvPHUD) {
						--this.mPvPMatch.mActionsLeft;
						this.mPvPHUD.mTextUpdateRequired = true;
					}
				}
			}
		}

		public function openPvPMatchUpDialog(): void {
			if (FeatureTuner.USE_PVP_MATCH) {
				if (this.mPlayerProfile.mGlobalUnitCounts == null) {
					this.startLoading();
					//this.mServer.serverCallService(ServiceIDs.GET_PVP_DATA, true);
					/*
					var fakedata:* = {};
				
					var pvp_data:* = {};
					pvp_data["score"] = 0;
					pvp_data["wins"] = 0;
					fakedata["pvp_data"] = pvp_data;

					fakedata["allies"] = new Array();
				
				
					var possible_opponents:Array = [];
				    var test_opponent:* = {};
					test_opponent["facebook_id"] = "1";
				    test_opponent["player_name"] = "Scary Chris";
					test_opponent["score"] = 0;
					test_opponent["level"] = 1;
					test_opponent["wins"] = 0;
				    test_opponent["avatar"] = "scary_chris.png"; // Loads from the data/avatars folder, empty string = default avatar
					possible_opponents.push(test_opponent)
					fakedata["possible_opponents"] = possible_opponents
				
					fakedata["recent_attacks"] = new Array();
				
					var player_unit_count:Array = [];
				    var player_unit:* = {};
					player_unit["item_id"] = "Infantry";
					player_unit["item_count"] = 4;
					player_unit_count.push(player_unit)
					fakedata["player_unit_count"] = player_unit_count;
					*/

					//this.mPlayerProfile.setupPvPData(fakedata);
					//this.mPlayerProfile.setupGlobalUnitCounts(fakedata);

					this.openPvPMatchUpDialog();
				} else if (this.getHud()) {
					if (this.mPvPMatch.mOpponent) {
						this.openPvPCombatSetupDialog();
					} else {
						this.getHud().openPvPMatchUpDialog();
					}
				}
			}
		}

		public function openPvPDebriefing(param1: Boolean): void {
			var _loc2_: String = null;
			var _loc3_: Object = null;
			if (FeatureTuner.USE_PVP_MATCH) {
				this.mPvPMatch.setResult(param1);
				this.mPlayerProfile.addBaddassXp(this.mPvPMatch.mWinRewardBadassXp);
				this.mPlayerProfile.addMoney(this.mPvPMatch.mWinRewardMoney);
				_loc2_ = this.mPvPMatch.getIngameCollectiblesString();
				_loc3_ = {
					"token": 0,
					"win": param1,
					"badass_points": this.mPvPMatch.mIngameBadassXp,
					"pvp_reward_items": _loc2_
				};
				this.mServer.serverCallServiceWithParameters(ServiceIDs.END_PVP_MATCH, _loc3_, false);
				if (Config.DEBUG_MODE) {}
				if (this.getHud()) {
					this.getHud().openPvPDebriefingDialog();
				} else {
					this.endPvP();
				}
			}
		}

		public function openPvPCombatSetupDialog(): void {
			if (FeatureTuner.USE_PVP_MATCH) {
				this.mPvPMatch.randomizeOpponentUnits();
				if (this.getHud()) {
					this.getHud().openPvPCombatSetupDialog();
				}
			}
		}

		public function cancelTools(): void {
			var _loc1_: int = this.mState;
			if (this.mState == STATE_MOVE_ITEM) {
				this.mScene.exitMoveMode(true);
				_loc1_ = STATE_PLAY;
			} else if (this.mState == STATE_PLACE_ITEM || this.mState == STATE_USE_INVENTORY_ITEM || this.mState == STATE_PLACE_FIRE_MISSION || this.mState == STATE_WAIT_FB_CALLBACK || this.mState == STATE_PICKUP_UNIT) {
				if (this.mScene.mObjectBeingMoved != null) {
					this.mScene.removeObject(this.mScene.mObjectBeingMoved);
				}
				this.mScene.cancelEditMode();
				_loc1_ = STATE_PLAY;
				this.mObjectToBePlaced = null;
				this.mFireMisssionToBePlaced = null;
				this.mItemToBePlaced = null;
				this.mInventoryItemToBePlaced = null;
			} else if (this.mState == STATE_REPAIR_ITEM || this.mState == STATE_PICKUP_UNIT) {
				this.mScene.mMapGUIEffectsLayer.clearHighlights();
				_loc1_ = STATE_PLAY;
			} else if (this.mState == STATE_SELL_ITEM) {
				_loc1_ = STATE_PLAY;
			}
			if (this.mVisitingFriend == null) {
				this.changeState(_loc1_);
			}
			if (!this.mScene.mPlacePressed) {
				this.mScene.setVisiblePlacementButton(false);
			}
		}

		public function updateActions(param1: int): void {
			if (this.mCurrentAction != null) {
				this.mCurrentAction.update(param1);
				if (this.mCurrentAction.isOver()) {
					if (this.mActionWaitingConfirmation) {
						if (this.mActionWaitingConfirmation == this.mCurrentAction) {
							this.mActionWaitingConfirmation = null;
						}
					}
					this.mCurrentAction = null;
					this.mScene.updateCursors(param1, true);
				}
			}
			if (this.mCurrentAction == null) {
				if (this.mMainActionQueue.mActions.length > 0) {
					this.mCurrentAction = this.mMainActionQueue.mActions.shift();
					if (Boolean(this.mCurrentAction.mTarget) && this.mCurrentAction.mTarget is Renderable) {
						this.mCurrentAction.mTarget.removedFromActionQueue();
					}
					this.mCurrentAction.start();
				} else if (this.mState == STATE_PLAY || this.mState == STATE_VISITING_NEIGHBOUR) {}
			}
		}

		public function queueAction(param1: Action, param2: Boolean = false): void {
			if (param2) {
				this.mMainActionQueue.mActions.unshift(param1);
			} else {
				this.mMainActionQueue.mActions.push(param1);
			}
			if (Boolean(param1.mTarget) && param1.mTarget is Renderable) {
				Renderable(param1.mTarget).addedToActionQueue();
			}
			if (!MissionManager.isTutorialCompleted() && (param1 is WalkingAction || param1 is AttackEnemyAction || param1 is HarvestProductionAction || param1 is RepairPlayerUnitAction)) {
				this.mScene.removeTutorialHighlight();
			}
		}

		public function resetActions(): void {
			this.mMainActionQueue.mActions.length = 0;
			this.mCurrentAction = null;
		}

		public function chooseCorrectGraphicFromArray(param1: Object): String {
			var _loc2_: int = 0;
			if (param1 is Array) {
				_loc2_ = GRAPHICS_MAP_ID_LIST.indexOf(this.mCurrentMapId);
				if (_loc2_ < 0 || _loc2_ >= (param1 as Array).length) {
					return param1[0] as String;
				}
				return param1[_loc2_] as String;
			}
			return param1 as String;
		}

		private function setCameraToStartingPosition(param1: Boolean = false): void {
			var _loc2_: int = int(this.mMapData.mMapSetupData.DefaultCellX);
			var _loc3_: int = int(this.mMapData.mMapSetupData.DefaultCellY);
			var _loc4_: Number = this.mScene.getCenterPointXAtIJ(_loc2_, _loc3_);
			var _loc5_: Number = this.mScene.getCenterPointYAtIJ(_loc2_, _loc3_);
			var _loc6_: Object = Cookie.readCookieVariable(Config.COOKIE_SESSION_NAME, Config.COOKIE_SESSION_NAME_CAM_POS + "_" + this.mCurrentMapId);
			if (!this.visitingFriend() && !MissionManager.modalMissionActive() && _loc6_ && Boolean(_loc6_.x) && Boolean(_loc6_.y)) {
				this.mScene.mCamera.moveTo(_loc6_.x, _loc6_.y);
			} else if (param1) {
				this.mScene.mCamera.moveTo(_loc4_, _loc5_);
			} else if (FeatureTuner.USE_CAMERA_TRANSITION) {
				this.mScene.mCamera.setTargetTo(_loc4_, _loc5_);
			}
		}

		private function setCameraToActivatedCharacter(param1: Boolean = false): void {
			trace("no here")
			if (!this.mActivatedPlayerUnit) {
				return;
			}
			if (param1) {
				this.mScene.mCamera.moveTo(this.mActivatedPlayerUnit.getContainer().x, this.mActivatedPlayerUnit.getContainer().y);
			} else if (FeatureTuner.USE_CAMERA_TRANSITION) {
				this.mScene.mCamera.setTargetTo(this.mActivatedPlayerUnit.getContainer().x, this.mActivatedPlayerUnit.getContainer().y);
			}
		}

		public function doPlayerWalkAction(param1: Number, param2: Number): Boolean {
			var _loc5_: WalkingAction = null;
			var _loc3_: PlayerUnit = this.mActivatedPlayerUnit;
			if (!_loc3_) {
				Utils.LogError("Trying to walk without activated character");
				return false;
			}
			if (this.mState == STATE_PVP && this.mMainActionQueue.mActions.length != 0) {
				return false;
			}
			var _loc4_: GridCell;
			if (!(_loc4_ = this.mScene.getCellAtLocation(param1, param2))) {
				Utils.LogError("Trying to walk to a null tile");
				return false;
			}
			if (!_loc4_.mCharacter && _loc4_.mWalkable && this.isInWalkingDistance(_loc4_) && !this.mCurrentAction) {
				if (this.mState == STATE_PVP && FeatureTuner.USE_PVP_MATCH) {
					_loc5_ = new PvPWalkingAction(_loc3_, param1, param2);
				} else {
					_loc5_ = new WalkingAction(_loc3_, param1, param2);
				}
				this.queueAction(_loc5_);
				return true;
			}
			return false;
		}

		private function getLastWalkingActionLoc(param1: PlayerUnit): Point {
			if (this.mCurrentAction != null && this.mCurrentAction is WalkingAction) {
				return new Point(WalkingAction(this.mCurrentAction).getTargetX(), WalkingAction(this.mCurrentAction).getTargetY());
			}
			return new Point(param1.mX, param1.mY);
		}

		private function getPathToObject(param1: WorldObject, param2: PlayerUnit): GridCell {
			var _loc9_: GridCell = null;
			var _loc12_: Number = NaN;
			var _loc13_: Number = NaN;
			var _loc14_: Number = NaN;
			var _loc3_: GridCell = this.mScene.getCellAtLocation(param1.mX, param1.mY);
			var _loc4_: Array = new Array();
			var _loc5_: Array = new Array();
			AStarPathfinder.getAllSurroundingCells(this.mScene, _loc3_, 1, _loc5_);
			var _loc6_: GridCell = null;
			var _loc7_: Number = 100000;
			var _loc8_: Point = this.getLastWalkingActionLoc(param2);
			var _loc10_: int = int(_loc5_.length);
			var _loc11_: int = 0;
			while (_loc11_ < _loc10_) {
				if (_loc9_ = _loc5_[_loc11_] as GridCell) {
					if (_loc9_.mWalkable) {
						if (!_loc9_.mCharacter || _loc9_.mCharacter == param2) {
							_loc12_ = this.mScene.getCenterPointXOfCell(_loc9_);
							_loc13_ = this.mScene.getCenterPointYOfCell(_loc9_);
							AStarPathfinder.mOptimizeStraightPaths = false;
							AStarPathfinder.findPathAStar(_loc4_, this.mScene, _loc8_, new Point(_loc12_, _loc13_), param2.mMovementFlags);
							AStarPathfinder.mOptimizeStraightPaths = true;
							if (_loc4_.length > 0) {
								if ((_loc14_ = _loc9_.mCharacter == param2 ? 0 : _loc4_.length) < _loc7_) {
									_loc7_ = _loc14_;
									_loc6_ = _loc9_;
								}
							}
						}
					}
				}
				_loc11_++;
			}
			return _loc6_;
		}

		public function isInWalkingDistance(param1: GridCell): Boolean {
			return this.mActiveCharacteWalkableCells.indexOf(param1) != -1;
		}

		private function resetActiveCharacterWalkableCells(): void {
			this.mScene.mMapGUIEffectsLayer.clearHighlights();
			this.mScene.mMapGUIEffectsLayer.clearMoveDisabledArea();
			this.mActiveCharacteWalkableCells = new Array();
			this.mActiveCharacteNonWalkableCells = new Array();
		}

		public function updateWalkableCellsForActiveCharacter(param1: int = -1, param2: int = -1): void {
			var _loc3_: GridCell = null;
			var _loc4_: int = 0;
			var _loc5_: int = 0;
			var _loc6_: GridCell = null;
			var _loc7_: Array = null;
			var _loc8_: GridCell = null;
			var _loc9_: int = 0;
			var _loc10_: int = 0;
			var _loc11_: Array = null;
			var _loc12_: GridCell = null;
			var _loc13_: int = 0;
			var _loc14_: int = 0;
			var _loc15_: GridCell = null;
			var _loc16_: Array = null;
			var _loc17_: GridCell = null;
			var _loc18_: int = 0;
			var _loc19_: int = 0;
			this.mActiveCharacteWalkableCells = new Array();
			this.mActiveCharacteNonWalkableCells = new Array();
			if (this.mActivatedPlayerUnit) {
				if (MissionManager.modalMissionActive()) {
					if (param1 >= 0) {
						_loc3_ = this.mScene.getCellAt(param1, param2);
						this.mActiveCharacteWalkableCells.push(_loc3_);
					}
				} else {
					_loc4_ = this.mActivatedPlayerUnit.mMovementFlags;
					_loc5_ = this.mActivatedPlayerUnit.getMovementRadius();
					_loc6_ = this.mScene.getCellAtLocation(this.mActivatedPlayerUnit.mX, this.mActivatedPlayerUnit.mY);
					_loc7_ = new Array();
					AStarPathfinder.getAllSurroundingCells(this.mScene, _loc6_, _loc5_ + 1, _loc7_);
					_loc9_ = int(_loc7_.length);
					_loc10_ = 0;
					while (_loc10_ < _loc9_) {
						if (_loc8_ = _loc7_[_loc10_] as GridCell) {
							_loc8_.mParent = null;
							_loc8_.mG = 99999999;
						}
						_loc10_++;
					}
					(_loc11_ = new Array()).push(_loc6_);
					_loc6_.mParent = _loc6_;
					_loc6_.mG = 0;
					while (_loc11_.length > 0) {
						_loc15_ = _loc11_.shift();
						_loc16_ = new Array();
						AStarPathfinder.getAccesibleSurroundingCells(this.mScene, _loc15_, _loc16_, _loc4_);
						_loc18_ = int(_loc16_.length);
						_loc19_ = 0;
						while (_loc19_ < _loc18_) {
							_loc17_ = _loc16_[_loc19_] as GridCell;
							if (_loc15_.mG <= _loc5_ - 0.5) {
								if (_loc17_.mG > _loc15_.mG + _loc17_.mPathCost) {
									if (_loc11_.indexOf(_loc17_) == -1) {
										if (_loc7_.indexOf(_loc17_) != -1) {
											_loc11_.push(_loc17_);
											_loc17_.mG = _loc15_.mG + _loc17_.mPathCost;
											_loc17_.mParent = _loc15_;
										}
									}
								}
							}
							_loc19_++;
						}
					}
					_loc13_ = int(_loc7_.length);
					_loc14_ = 0;
					while (_loc14_ < _loc13_) {
						if (_loc12_ = _loc7_[_loc14_] as GridCell) {
							if (_loc12_.mWalkable) {
								if (this.mScene.isInsideOpenArea(_loc12_)) {
									if (_loc12_ != _loc6_ && !_loc12_.mCharacter && (!_loc12_.mObject || _loc12_.mObject is DebrisObject)) {
										if (_loc12_.mG < _loc5_ + 0.5) {
											this.mActiveCharacteWalkableCells.push(_loc12_);
										}
									} else if (_loc12_.mG < _loc5_ + 0.5) {
										this.mActiveCharacteNonWalkableCells.push(_loc12_);
									}
								}
							}
						}
						_loc14_++;
					}
				}
			}
			this.mScene.mMapGUIEffectsLayer.highlightMoveArea();
			this.mScene.mMapGUIEffectsLayer.highlightMovementDisabledArea();
		}

		public function updateWalkableCellsForPvPEnemy(param1: PvPEnemyUnit): void {
			var _loc6_: GridCell = null;
			var _loc10_: GridCell = null;
			var _loc13_: GridCell = null;
			var _loc14_: Array = null;
			var _loc15_: GridCell = null;
			var _loc16_: int = 0;
			var _loc17_: int = 0;
			this.mEnemyWalkableCells = new Array();
			var _loc2_: int = param1.mMovementFlags;
			var _loc3_: int = param1.mMovementRange;
			var _loc4_: GridCell = this.mScene.getCellAtLocation(param1.mX, param1.mY);
			var _loc5_: Array = new Array();
			AStarPathfinder.getAllSurroundingCells(this.mScene, _loc4_, _loc3_ + 1, _loc5_);
			var _loc7_: int = int(_loc5_.length);
			var _loc8_: int = 0;
			while (_loc8_ < _loc7_) {
				if (_loc6_ = _loc5_[_loc8_] as GridCell) {
					_loc6_.mParent = null;
					_loc6_.mG = 99999999;
				}
				_loc8_++;
			}
			var _loc9_: Array;
			(_loc9_ = new Array()).push(_loc4_);
			_loc4_.mParent = _loc4_;
			_loc4_.mG = 0;
			while (_loc9_.length > 0) {
				_loc13_ = _loc9_.shift();
				_loc14_ = new Array();
				AStarPathfinder.getAccesibleSurroundingCells(this.mScene, _loc13_, _loc14_, _loc2_);
				_loc16_ = int(_loc14_.length);
				_loc17_ = 0;
				while (_loc17_ < _loc16_) {
					_loc15_ = _loc14_[_loc17_] as GridCell;
					if (_loc13_.mG <= _loc3_ - 0.5) {
						if (_loc15_.mG > _loc13_.mG + _loc15_.mPathCost) {
							if (_loc9_.indexOf(_loc15_) == -1) {
								if (_loc5_.indexOf(_loc15_) != -1) {
									_loc9_.push(_loc15_);
									_loc15_.mG = _loc13_.mG + _loc15_.mPathCost;
									_loc15_.mParent = _loc13_;
								}
							}
						}
					}
					_loc17_++;
				}
			}
			var _loc11_: int = int(_loc5_.length);
			var _loc12_: int = 0;
			while (_loc12_ < _loc11_) {
				if (_loc10_ = _loc5_[_loc12_] as GridCell) {
					if (_loc10_.mWalkable) {
						if (this.mScene.isInsideOpenArea(_loc10_)) {
							if (_loc10_ != _loc4_ && !_loc10_.mCharacter && (!_loc10_.mObject || _loc10_.mObject is DebrisObject)) {
								if (_loc10_.mG < _loc3_ + 0.5) {
									this.mEnemyWalkableCells.push(_loc10_);
								}
							}
						}
					}
				}
				_loc12_++;
			}
			this.mScene.mMapGUIEffectsLayer.highlightMoveArea(true);
		}

		public function spawnNewDebris(param1: String, param2: String, param3: int, param4: int): void {
			if (this.mState == STATE_VISITING_NEIGHBOUR) {
				return;
			}
			var _loc5_: GridCell;
			if (!(_loc5_ = this.mScene.getCellAtLocation(param3, param4)) || !MapData.isTilePassable(_loc5_.mType)) {
				return;
			}
			if (_loc5_.mObject) {
				return;
			}
			var _loc6_: MapItem = ItemManager.getItem(param1, param2) as MapItem;
			var _loc7_: Renderable;
			(_loc7_ = this.mScene.createObject(_loc6_, new Point())).setPos(param3, param4, 0);
			if (!_loc5_.hasFog()) {
				_loc7_.getContainer().visible = true;
				_loc7_.mVisible = true;
			}
			this.mMapData.mUpdateRequired = true;
			var _loc8_: Object = {
				"item_id": param1,
				"coord_x": _loc5_.mPosI,
				"coord_y": _loc5_.mPosJ
			};
			this.mServer.serverCallServiceWithParameters(ServiceIDs.PLACE_DEBRIS, _loc8_, false);
			if (Config.DEBUG_MODE) {}
		}

		public function searchNearbyPlayerUnits(param1: Renderable): Array {
			var _loc2_: Array = null;
			var _loc6_: int = 0;
			var _loc7_: GridCell = null;
			var _loc8_: PlayerUnit = null;
			var _loc9_: int = 0;
			var _loc3_: int = param1.getTileSize().x - 1;
			var _loc4_: int = param1.getTileSize().y - 1;
			var _loc5_: int = -PlayerUnit.smLongestAttackRange;
			while (_loc5_ <= PlayerUnit.smLongestAttackRange + _loc3_) {
				_loc6_ = -PlayerUnit.smLongestAttackRange;
				while (_loc6_ <= PlayerUnit.smLongestAttackRange + _loc4_) {
					if (Boolean(_loc7_ = this.mScene.getCellAtLocation(param1.mX + _loc5_ * this.mScene.mGridDimX, param1.mY + _loc6_ * this.mScene.mGridDimY)) && _loc7_.mCharacter is PlayerUnit) {
						if ((_loc8_ = _loc7_.mCharacter as PlayerUnit).isAlive()) {
							_loc9_ = _loc8_.getAttackRange();
							if (Math.abs(_loc5_) <= _loc9_ || _loc5_ > 0 && _loc5_ - _loc3_ <= _loc9_ && Math.abs(_loc6_) <= _loc9_ || _loc6_ > 0 && _loc6_ - _loc4_ <= _loc9_) {
								if (!_loc2_) {
									_loc2_ = new Array();
								}
								_loc2_.push(_loc8_);
							}
						}
					}
					_loc6_++;
				}
				_loc5_++;
			}
			return _loc2_;
		}

		public function searchAttackablePlayerUnits(param1: Renderable): Array {
			var _loc3_: int = 0;
			var _loc4_: int = 0;
			var _loc5_: int = 0;
			var _loc6_: int = 0;
			var _loc8_: PlayerUnit = null;
			var _loc11_: GridCell = null;
			var _loc2_: Array = new Array();
			var _loc7_: Array;
			var _loc9_: int = int((_loc7_ = this.mScene.getPlayerAliveUnits()).length);
			var _loc10_: int = 0;
			while (_loc10_ < _loc9_) {
				_loc8_ = _loc7_[_loc10_] as PlayerUnit;
				_loc3_ = param1.getCell().mPosI - _loc8_.getAttackRange();
				_loc4_ = param1.getCell().mPosI + (param1.getTileSize().x - 1) + _loc8_.getAttackRange();
				_loc5_ = param1.getCell().mPosJ - _loc8_.getAttackRange();
				_loc6_ = param1.getCell().mPosJ + (param1.getTileSize().y - 1) + _loc8_.getAttackRange();
				if (_loc8_.isStill() && _loc8_.getCell().mPosI >= _loc3_ && _loc8_.getCell().mPosI <= _loc4_ && _loc8_.getCell().mPosJ >= _loc5_ && _loc8_.getCell().mPosJ <= _loc6_) {
					_loc2_.push(_loc8_);
				} else if (_loc11_ = _loc8_.getMovementTargetCell()) {
					if (_loc11_.mPosI >= _loc3_) {
						if (_loc11_.mPosI <= _loc4_) {
							if (_loc11_.mPosJ >= _loc5_) {
								if (_loc11_.mPosJ <= _loc6_) {
									_loc2_.push(_loc8_);
								}
							}
						}
					}
				}
				_loc10_++;
			}
			return _loc2_;
		}
	
	/*
	thanks chatgpt!
	
	
	public function searchNearbyUnits(
    centerCell: GridCell,
    range: int,
    heightExtension: int = 1,
    widthExtension: int = 1,
    includeEnemies: Boolean = true
	): Array
	*/

		public function searchNearbyUnits(param1: GridCell, param2: int, param3: int = 1, param4: int = 1, param5: Boolean = true): Array {
			var _loc8_: int = 0;
			var _loc9_: GridCell = null;
			var _loc10_: PlayerUnit = null;
			var _loc11_: EnemyUnit = null;
			var _loc6_: Array = new Array();
			var _loc7_: int = -param2;
			while (_loc7_ < param2 + param3) {
				_loc8_ = -param2;
				for (; _loc8_ < param2 + param4; _loc8_++) {
					if (_loc7_ >= 0) {
						if (_loc7_ < param3) {
							if (_loc8_ >= 0) {
								if (_loc8_ < param4) {
									continue;
								}
							}
						}
					}
					if ((_loc9_ = this.mScene.getCellAt(param1.mPosI + _loc7_, param1.mPosJ + _loc8_)) && _loc9_.mCharacter is PlayerUnit && (_loc9_.mCharacter as PlayerUnit).isStill() && (_loc9_.mCharacter as PlayerUnit).isAlive()) {
						_loc10_ = _loc9_.mCharacter as PlayerUnit;
						_loc6_.push(_loc10_);
					} else if (!param5 && _loc9_ && _loc9_.mCharacter is EnemyUnit && (_loc9_.mCharacter as EnemyUnit).isStill() && (_loc9_.mCharacter as EnemyUnit).isAlive()) {
						_loc11_ = _loc9_.mCharacter as EnemyUnit;
						_loc6_.push(_loc11_);
					}
				}
				_loc7_++;
			}
			return _loc6_;
		}

		public function searchUnitsInRange(param1: Renderable): Array {
			var _loc10_: GridCell = null;
			var _loc11_: int = 0;
			var _loc12_: int = 0;
			var _loc13_: int = 0;
			var _loc14_: int = 0;
			var _loc2_: Array = new Array();
			var _loc3_: int = param1.getTileSize().x;
			var _loc4_: int = param1.getTileSize().y;
			var _loc5_: GridCell = this.mScene.getCellAtLocation(param1.mX, param1.mY);
			var _loc6_: Array = MapArea.getArea(this.mScene, _loc5_.mPosI - PlayerUnit.smLongestAttackRange, _loc5_.mPosJ - PlayerUnit.smLongestAttackRange, PlayerUnit.smLongestAttackRange * 2 + _loc3_, PlayerUnit.smLongestAttackRange * 2 + _loc4_).getCells();
			var _loc7_: int = 0;
			while (_loc7_ < _loc6_.length) {
				if (!_loc6_[_loc7_] || !(_loc6_[_loc7_] as GridCell).mCharacter || !(_loc6_[_loc7_].mCharacter is PlayerUnit) || !((_loc6_[_loc7_] as GridCell).mCharacter as PlayerUnit).isAlive()) {
					_loc6_.splice(_loc7_, 1);
					_loc7_--;
				}
				_loc7_++;
			}
			if (_loc6_.length == 0) {
				return _loc2_;
			}
			var _loc8_: Array = this.mScene.getTilesUnderObject(param1);
			var _loc9_: int = 0;
			while (_loc9_ < _loc6_.length) {
				_loc11_ = (_loc10_ = _loc6_[_loc9_]).mCharacter.mAttackRange;
				_loc12_ = 0;
				while (_loc12_ < _loc8_.length) {
					_loc13_ = _loc10_.mPosI - (_loc8_[_loc12_] as GridCell).mPosI;
					_loc14_ = _loc10_.mPosJ - (_loc8_[_loc12_] as GridCell).mPosJ;
					if (Math.abs(_loc13_) <= _loc11_) {
						if (Math.abs(_loc14_) <= _loc11_) {
							if (_loc2_.indexOf(_loc10_.mCharacter) < 0) {
								_loc2_.push(_loc10_.mCharacter);
							}
						}
					}
					_loc12_++;
				}
				_loc9_++;
			}
			return _loc2_;
		}

		public function searchForSupportEnemyUnits(param1: GridCell): Array {
			var _loc8_: GridCell = null;
			var _loc2_: Array = new Array();
			var _loc3_: int = 1;
			var _loc4_: int = 1;
			var _loc5_: int = 1;
			if (param1.mObject) {
				_loc4_ = param1.mObject.getTileSize().x;
				_loc5_ = param1.mObject.getTileSize().y;
			}
			var _loc6_: Array = MapArea.getArea(this.mScene, param1.mPosI - _loc3_, param1.mPosJ - _loc3_, _loc3_ * 2 + _loc4_, _loc3_ * 2 + _loc5_).getCells();
			var _loc7_: int = 0;
			while (_loc7_ < _loc6_.length) {
				if (_loc8_ = _loc6_[_loc7_]) {
					if (_loc8_ != param1) {
						if (_loc8_.mCharacter) {
							if (_loc8_.mCharacter is EnemyUnit) {
								if ((_loc8_.mCharacter as EnemyUnit).isAlive()) {
									if ((_loc8_.mCharacter as EnemyUnit).mAttackRange > 1) {
										_loc2_.push(_loc8_.mCharacter);
									}
								}
							}
						}
					}
				}
				_loc7_++;
			}
			return _loc2_;
		}

		public function activateNearbyEnemies(param1: GridCell, param2: Array = null): void {
			var _loc9_: Renderable = null;
			var _loc12_: GridCell = null;
			var _loc13_: Boolean = false;
			var _loc14_: EnemyUnit = null;
			var _loc15_: int = 0;
			var _loc16_: int = 0;
			var _loc3_: Array = new Array();
			var _loc4_: int = 2;
			var _loc5_: int = 1;
			var _loc6_: int = 1;
			if (param1.mObject) {
				_loc5_ = param1.mObject.getTileSize().x;
				_loc6_ = param1.mObject.getTileSize().y;
			}
			var _loc7_: Array = MapArea.getArea(this.mScene, param1.mPosI - _loc4_, param1.mPosJ - _loc4_, _loc4_ * 2 + _loc5_, _loc4_ * 2 + _loc6_).getCells();
			var _loc8_: int = 0;
			while (_loc8_ < _loc7_.length) {
				if (_loc12_ = _loc7_[_loc8_]) {
					if (_loc12_ != param1) {
						if (_loc12_.mCharacter && _loc12_.mCharacter is EnemyUnit && (_loc12_.mCharacter as EnemyUnit).isAlive() && (_loc12_.mCharacter as EnemyUnit).mReactionStateCounter > 1) {
							_loc13_ = true;
							_loc15_ = int(param2.length);
							_loc16_ = 0;
							while (_loc16_ < _loc15_) {
								if ((_loc14_ = param2[_loc16_] as EnemyUnit) == _loc12_.mCharacter) {
									_loc13_ = false;
									break;
								}
								_loc16_++;
							}
							if (_loc13_) {
								_loc3_.push(_loc12_.mCharacter);
							}
						} else if (_loc12_.mObject && _loc12_.mObject is EnemyInstallationObject && (_loc12_.mObject as EnemyInstallationObject).canAttack() && (_loc12_.mObject as EnemyInstallationObject).isAlive() && (_loc12_.mObject as EnemyInstallationObject).mReactionStateCounter > 1) {
							_loc3_.push(_loc12_.mObject);
						}
					}
				}
				_loc8_++;
			}
			var _loc10_: int = int(_loc3_.length);
			var _loc11_: int = 0;
			while (_loc11_ < _loc10_) {
				if ((_loc9_ = _loc3_[_loc11_] as Renderable) is EnemyUnit) {
					(_loc9_ as EnemyUnit).changeReactionState(EnemyUnit.REACT_STATE_WAIT_FOR_ORDERS_PREMIUM);
				}
				_loc11_++;
			}
		}

		public function setEnemyInstallationsToAttack(param1: PlayerUnit): void {
			var _loc4_: EnemyInstallationObject = null;
			var _loc7_: int = 0;
			var _loc8_: int = 0;
			var _loc9_: int = 0;
			var _loc10_: int = 0;
			var _loc11_: int = 0;
			var _loc2_: GridCell = param1.getCell();
			var _loc3_: Array = this.mScene.getEnemyInstallations();
			var _loc5_: int = int(_loc3_.length);
			var _loc6_: int = 0;
			while (_loc6_ < _loc5_) {
				_loc4_ = _loc3_[_loc6_] as EnemyInstallationObject;
				if (!(EnemyInstallationItem(_loc4_.mItem).mFiringType != "normal" || !_loc4_.canCounterAttack())) {
					_loc7_ = _loc4_.mAttackRange;
					_loc8_ = _loc4_.getCell().mPosI;
					_loc9_ = _loc4_.getTileSize().x;
					if (_loc2_.mPosI >= _loc8_ - _loc7_) {
						if (_loc2_.mPosI < _loc8_ + _loc9_ + _loc7_) {
							_loc10_ = _loc4_.getCell().mPosJ;
							_loc11_ = _loc4_.getTileSize().y;
							if (_loc2_.mPosJ >= _loc10_ - _loc7_) {
								if (_loc2_.mPosJ < _loc10_ + _loc11_ + _loc7_) {
									_loc4_.attackPlayerUnit(param1);
								}
							}
						}
					}
				}
				_loc6_++;
			}
		}

		private function isThreatenedByEnemy(param1: GridCell): Boolean {
			var _loc4_: EnemyUnit = null;
			var _loc7_: int = 0;
			var _loc8_: int = 0;
			var _loc9_: GridCell = null;
			var _loc2_: int = 2;
			var _loc3_: Array = this.mScene.getEnemyUnits();
			var _loc5_: int = int(_loc3_.length);
			var _loc6_: int = 0;
			while (_loc6_ < _loc5_) {
				_loc4_ = _loc3_[_loc6_] as EnemyUnit;
				_loc7_ = -_loc2_;
				while (_loc7_ <= _loc2_) {
					_loc8_ = -_loc2_;
					while (_loc8_ <= _loc2_) {
						if ((_loc9_ = this.mScene.getCellAtLocation(_loc4_.mX + _loc7_ * this.mScene.mGridDimX, _loc4_.mY + _loc8_ * this.mScene.mGridDimY)) == param1) {
							return true;
						}
						_loc8_++;
					}
					_loc7_++;
				}
				_loc6_++;
			}
			return false;
		}

		public function setPlayerInstallationsToAttack(param1: EnemyUnit): void {
			var _loc4_: PlayerInstallationObject = null;
			var _loc7_: int = 0;
			var _loc8_: int = 0;
			var _loc9_: int = 0;
			var _loc10_: int = 0;
			var _loc11_: int = 0;
			var _loc2_: GridCell = param1.getCell();
			var _loc3_: Array = this.mScene.getPlayerInstallations();
			var _loc5_: int = int(_loc3_.length);
			var _loc6_: int = 0;
			while (_loc6_ < _loc5_) {
				if (!(!(_loc4_ = _loc3_[_loc6_] as PlayerInstallationObject).canAttack() || _loc4_.hasAttackActionInQueue())) {
					_loc7_ = _loc4_.mAttackRange;
					_loc8_ = _loc4_.getCell().mPosI;
					_loc9_ = _loc4_.getTileSize().x;
					if (_loc2_.mPosI >= _loc8_ - _loc7_) {
						if (_loc2_.mPosI < _loc8_ + _loc9_ + _loc7_) {
							_loc10_ = _loc4_.getCell().mPosJ;
							_loc11_ = _loc4_.getTileSize().y;
							if (_loc2_.mPosJ >= _loc10_ - _loc7_) {
								if (_loc2_.mPosJ < _loc10_ + _loc11_ + _loc7_) {
									this.queueAction(new AttackEnemyAction(null, _loc4_, param1, false), true);
								}
							}
						}
					}
				}
				_loc6_++;
			}
		}

		public function setAttacksToExtraAttackStyleEnemyInstallations(param1: IsometricCharacter): void {}

		public function attackEnemy(param1: Renderable): void {
			var _loc3_: Action = null;
			var _loc4_: Action = null;
			var _loc5_: Action = null;
			var _loc6_: Boolean = false;
			var _loc7_: int = 0;
			var _loc8_: int = 0;
			var _loc9_: Array = null;
			var _loc10_: EnemyUnit = null;
			var _loc11_: int = 0;
			var _loc12_: int = 0;
			var _loc13_: int = 0;
			var _loc14_: Action = null;
			var _loc2_: Array = this.searchAttackablePlayerUnits(param1);
			this.mCounterAttackAction = null;
			if (!_loc2_ || _loc2_.length == 0) {
				if (param1 is IsometricCharacter) {
					(param1 as IsometricCharacter).addTextEffect(TextEffect.TYPE_LOSS, GameState.getText("CANNOT_ATTACK_TEXT"));
				} else if (param1 is EnemyInstallationObject) {
					(param1 as EnemyInstallationObject).addTextEffect(TextEffect.TYPE_LOSS, GameState.getText("CANNOT_ATTACK_TEXT"));
				}
			} else if (this.mState == STATE_PVP && FeatureTuner.USE_PVP_MATCH) {
				if (this.mMainActionQueue.mActions.length == 0) {
					if (this.mCurrentAction == null) {
						if (param1 is PvPEnemyUnit) {
							_loc3_ = new PvPAttackEnemyAction(_loc2_, null, param1 as PvPEnemyUnit);
							this.queueAction(_loc3_);
						} else if (param1 is EnemyInstallationObject) {
							_loc3_ = new PvPAttackEnemyInstallationAction(_loc2_, param1 as EnemyInstallationObject);
							this.queueAction(_loc3_);
						}
					}
				}
			} else {
				_loc6_ = true;
				_loc7_ = 1;
				_loc8_ = 1;
				if (param1 is EnemyUnit) {
					_loc4_ = new AttackEnemyAction(_loc2_, null, param1 as EnemyUnit);
					if ((param1 as EnemyUnit).getHealth() <= _loc2_.length) {
						_loc6_ = false;
						_loc7_ = (param1 as EnemyUnit).getPower();
						_loc8_ = (param1 as EnemyUnit).getAttackRange();
					} else {
						_loc5_ = new EnemyAttackingAction(param1 as EnemyUnit, null);
						_loc4_.mCounterAction = _loc5_;
					}
				} else {
					_loc4_ = new AttackEnemyInstallationAction(_loc2_, param1 as EnemyInstallationObject);
					if ((param1 as EnemyInstallationObject).getHealth() <= _loc2_.length || !(param1 as EnemyInstallationObject).canCounterAttack()) {
						_loc6_ = false;
						_loc7_ = (param1 as EnemyInstallationObject).getPower();
						_loc8_ = (param1 as EnemyInstallationObject).mAttackRange;
					} else {
						_loc5_ = new EnemyInstallationAttackingAction(param1 as EnemyInstallationObject, null);
						_loc4_.mCounterAction = _loc5_;
					}
				}
				_loc11_ = int((_loc9_ = this.searchForSupportEnemyUnits(param1.getCell())).length);
				_loc12_ = 0;
				while (_loc12_ < _loc11_) {
					_loc10_ = _loc9_[_loc12_] as EnemyUnit;
					_loc13_ = Math.random() * _loc2_.length;
					_loc14_ = new EnemyAttackingAction(_loc10_, _loc2_[_loc13_] as PlayerUnit);
					_loc4_.addSupportAction(_loc14_);
					_loc12_++;
				}
				this.queueAction(_loc4_);
				this.activateNearbyEnemies(param1.getCell(), _loc9_);
			}
		}

		private function updateSpawnLevelsTimer(param1: int): void {
			var _loc3_: int = 0;
			var _loc4_: int = 0;
			var _loc5_: Array = null;
			var _loc6_: Object = null;
			var _loc7_: int = 0;
			var _loc8_: int = 0;
			if (this.mSpawnEnemyTimer < 0) {
				this.mSpawnEnemyTimer = 0;
			}
			this.mSpawnEnemyTimer += param1;
			var _loc2_: Object = mConfig.SpawnLevels[this.mPlayerProfile.mSpawnEnemyLevel] as Object;
			if (this.mSpawnEnemyTimer >= _loc2_.ActivationTime * 60 * 1000) {
				_loc3_ = this.mPlayerProfile.mInventory.getAreas(true).length / 2 * _loc2_.SpawnAmountPerArea;
				if ((_loc4_ = int(this.mScene.getEnemyUnits().length)) < _loc3_) {
					_loc5_ = new Array();
					_loc7_ = int(_loc2_.EnemyUnits.length);
					_loc8_ = 0;
					while (_loc8_ < _loc7_) {
						_loc6_ = _loc2_.EnemyUnits[_loc8_] as Object;
						_loc5_.push(_loc6_.ID);
						_loc8_++;
					}
					this.spawnNewEnemies(_loc5_, _loc2_.EnemyAmount, _loc2_.EnemyUnitsP);
				}
				this.mSpawnEnemyTimer -= _loc2_.ActivationTime * 60 * 1000;
			}
		}

		public function spawnNewEnemies(param1: Array, param2: int, param3: Array = null): void {
			var _loc7_: int = 0;
			var _loc11_: int = 0;
			var _loc12_: GridCell = null;
			var _loc13_: int = 0;
			var _loc14_: MapItem = null;
			var _loc15_: int = 0;
			var _loc16_: int = 0;
			var _loc17_: int = 0;
			var _loc4_: Array = this.mMapData.mGrid;
			var _loc5_: Array = new Array();
			var _loc6_: int = 0;
			var _loc8_: int = 0;
			while (_loc8_ < this.mMapData.mGridHeight) {
				_loc11_ = 0;
				while (_loc11_ < this.mMapData.mGridWidth) {
					_loc6_ = _loc8_ * this.mMapData.mGridWidth + _loc11_;
					if (this.isTileSuitableForEnemySpawning(_loc4_[_loc6_], true)) {
						_loc5_.push(_loc4_[_loc6_]);
						_loc7_ = _loc6_ - this.mMapData.mGridWidth;
						_loc12_ = _loc4_[_loc7_];
						if (_loc7_ > 0) {
							if (_loc12_.mWalkable) {
								if (!_loc12_.mCharacterComingToThisTile) {
									if (!_loc12_.mCharacter) {
										if (!_loc12_.mObject || _loc12_.mObject is DebrisObject) {
											_loc5_.push(_loc4_[_loc7_]);
										}
									}
								}
							}
						}
					}
					_loc11_++;
				}
				_loc8_++;
			}
			if (_loc5_.length == 0) {
				return;
			}
			if (_loc5_.length < param2) {
				param2 = int(_loc5_.length);
			}
			var _loc9_: int = Math.random() * _loc5_.length;
			var _loc10_: int = 0;
			while (_loc10_ < param2) {
				_loc13_ = _loc10_;
				if (param3) {
					_loc15_ = 0;
					_loc16_ = Math.random() * 100;
					_loc17_ = 0;
					while (_loc17_ < param1.length) {
						_loc15_ += param3[_loc17_] as int;
						if (_loc16_ < _loc15_) {
							_loc13_ = _loc17_;
							break;
						}
						_loc17_++;
					}
				}
				_loc14_ = ItemManager.getItem(param1[_loc13_], "EnemyUnit") as MapItem;
				this.spawnEnemy(_loc14_, _loc5_[_loc9_]);
				_loc10_++;
				_loc9_++;
				if (_loc9_ >= _loc5_.length) {
					_loc9_ = 0;
				}
			}
		}

		public function spawnEnemy(param1: MapItem, param2: GridCell, param3: Boolean = true): EnemyUnit {
			if (this.mState == STATE_VISITING_NEIGHBOUR || this.mState == STATE_LOADING_NEIGHBOUR) {
				return null;
			}
			var _loc4_: Renderable = this.mScene.createObject(param1, new Point(0, 0));
			var _loc5_: Number = this.mScene.getCenterPointXAtIJ(param2.mPosI, param2.mPosJ);
			var _loc6_: Number = this.mScene.getCenterPointYAtIJ(param2.mPosI, param2.mPosJ);
			var _loc7_: * = param2.mOwner == MapData.TILE_OWNER_FRIENDLY;
			_loc4_.setPos(_loc5_, _loc6_, 0);
			this.mScene.characterArrivedInCell(_loc4_ as IsometricCharacter, param2, false);
			if (!param2.hasFog()) {
				_loc4_.getContainer().visible = true;
				_loc4_.mVisible = true;
			} else {
				_loc4_.getContainer().visible = false;
				_loc4_.mVisible = false;
			}
			var _loc8_: Object = {
				"coord_x": param2.mPosI,
				"coord_y": param2.mPosJ,
				"item_id": param1.mId,
				"claim_player_tile": _loc7_
			};
			this.mServer.serverCallServiceWithParameters(ServiceIDs.PLACE_ENEMY_UNIT, _loc8_, false);
			var _loc9_: int = 5;
			var _loc10_: int = 1;
			(_loc4_ as EnemyUnit).setActivationTime(_loc10_ + Math.random() * (_loc9_ - _loc10_));
			if (Config.DEBUG_MODE) {}
			return _loc4_ as EnemyUnit;
		}

		private function addEnemiesFromSpawning(param1: Array, param2: int, param3: int, param4: Boolean, param5: Array): void {
			var _loc9_: Array = null;
			var _loc10_: GridCell = null;
			var _loc11_: int = 0;
			var _loc12_: int = 0;
			var _loc13_: int = 0;
			var _loc14_: GridCell = null;
			var _loc15_: int = 0;
			var _loc16_: MapItem = null;
			var _loc17_: Renderable = null;
			var _loc18_: Number = NaN;
			var _loc19_: Number = NaN;
			var _loc20_: Object = null;
			var _loc21_: int = 0;
			var _loc22_: int = 0;
			var _loc23_: int = 0;
			var _loc24_: int = 0;
			var _loc25_: int = 0;
			var _loc6_: Array = this.mMapData.mGrid;
			var _loc7_: int = 0;
			var _loc8_: int = 0;
			while (_loc7_ < param2) {
				_loc9_ = new Array();
				if (param4) {
					_loc9_.push(_loc6_[param3 + _loc8_]);
					_loc13_ = param3 + _loc8_ - this.mMapData.mGridWidth;
					_loc14_ = _loc6_[_loc13_];
					if (_loc13_ > 0) {
						if (_loc14_.mWalkable) {
							if (!_loc14_.mCharacterComingToThisTile) {
								if (!_loc14_.mCharacter) {
									if (!_loc14_.mObject) {
										_loc9_.push(_loc6_[_loc13_]);
									}
								}
							}
						}
					}
				} else {
					_loc9_.push(_loc6_[param3 + _loc8_ * this.mMapData.mGridWidth]);
				}
				_loc11_ = int(_loc9_.length);
				_loc12_ = 0;
				while (_loc12_ < _loc11_) {
					_loc10_ = _loc9_[_loc12_] as GridCell;
					if (_loc7_ >= param2) {
						break;
					}
					_loc15_ = _loc7_;
					if (param5) {
						_loc23_ = 0;
						_loc24_ = Math.random() * 100;
						_loc25_ = 0;
						while (_loc25_ < param1.length) {
							_loc23_ += param5[_loc25_] as int;
							if (_loc24_ < _loc23_) {
								_loc15_ = _loc25_;
								break;
							}
							_loc25_++;
						}
					}
					_loc16_ = ItemManager.getItem(param1[_loc15_], "EnemyUnit") as MapItem;
					_loc17_ = this.mScene.createObject(_loc16_, new Point(0, 0));
					_loc18_ = this.mScene.getCenterPointXAtIJ(_loc10_.mPosI, _loc10_.mPosJ);
					_loc19_ = this.mScene.getCenterPointYAtIJ(_loc10_.mPosI, _loc10_.mPosJ);
					_loc17_.setPos(_loc18_, _loc19_, 0);
					_loc10_.mOwner = MapData.TILE_OWNER_ENEMY;
					if (!_loc10_.hasFog()) {
						_loc17_.getContainer().visible = true;
						_loc17_.mVisible = true;
					} else {
						_loc17_.getContainer().visible = false;
						_loc17_.mVisible = false;
					}
					_loc20_ = {
						"coord_x": _loc10_.mPosI,
						"coord_y": _loc10_.mPosJ,
						"item_id": _loc16_.mId
					};
					this.mServer.serverCallServiceWithParameters(ServiceIDs.PLACE_ENEMY_UNIT, _loc20_, false);
					_loc21_ = 5;
					_loc22_ = 1;
					(_loc17_ as EnemyUnit).setActivationTime(_loc22_ + Math.random() * (_loc21_ - _loc22_));
					this.setPlayerInstallationsToAttack(_loc17_ as EnemyUnit);
					if (Config.DEBUG_MODE) {}
					_loc7_++;
					_loc12_++;
				}
				_loc8_++;
			}
			this.mEnemiesSpawned = param2;
		}

		private function isTileSuitableForEnemySpawning(param1: GridCell, param2: Boolean): Boolean {
			if (param1) {
				if (param1.mWalkable) {
					if (!param1.mCharacterComingToThisTile) {
						if (!param1.mCharacter) {
							if (!param1.mObject || param1.mObject is DebrisObject) {
								if (param1.mCloudBits != TileMapGraphic.CLOUD_BIT_NONE) {
									if (param1.mCloudBits != TileMapGraphic.CLOUD_INDEX_FULL) {
										if (param2) {
											if (param1.mCloudBits == TileMapGraphic.CLOUD_BIT_BOTTOM || param1.mCloudBits == TileMapGraphic.CLOUD_BIT_CONVEX_BL || param1.mCloudBits == TileMapGraphic.CLOUD_BIT_CONVEX_BR) {
												return true;
											}
										} else if (param1.mCloudBits == TileMapGraphic.CLOUD_BIT_LEFT || param1.mCloudBits == TileMapGraphic.CLOUD_BIT_RIGHT) {
											return true;
										}
									}
								}
							}
						}
					}
				}
			}
			return false;
		}

		public function confirmWaitingAction(): void {
			this.queueAction(this.mActionWaitingConfirmation);
			if (this.mCounterAttackAction) {
				this.queueAction(this.mCounterAttackAction);
			}
		}

		private function updateDebugText(): void {
			++this.mFrames;
			this.mText.text = this.mFrameRate + " FPS \n" + this.totalMemory.toFixed(2) + "Mb\n" + "Mac Address:" + Config.smUserId + "\nObj cnt: " + this.mScene.mVisibleObjectCnt + "\nTime " + smTimeFactor + "X" + "\n" + TimeUtils.milliSecondsToString(smCurrentGameTime) + "\n V. " + this.mClientVersion + "\nUnlcok cheat? " + smUnlockCheat + "\nMap: " + this.mCurrentMapId;
			var _loc1_: GridCell = this.mScene.getTileUnderMouse();
			if (_loc1_) {
				this.mText.appendText("\nTileX: " + _loc1_.mPosI + " TileY: " + _loc1_.mPosJ);
			}
		}

		public function getStageWidth(): int {
			return mMainClip.stage.stageWidth;
		}

		public function getStageHeight(): int {
			return mMainClip.stage.stageHeight;
		}

		public function loadingFirstFinished(): void {
			this.parseJsonFiles();
			ItemManager.initialize();
			MissionManager.initialize();
			this.mClientVersion = (mConfig.ClientRevision[0] as Object).Revision;
			this.updateTime();
		}

		private function parseJsonFiles(): void {
			var _loc2_: String = null;
			var _loc1_: DCResourceManager = DCResourceManager.getInstance();
			mConfig = new Object();
			mPvPOpponentsConfig = new Object();
			var _loc3_: int = int(AssetManager.JSON_FILES_TO_LOAD.length);
			var _loc4_: int = 0;
			while (_loc4_ < _loc3_) {
				_loc2_ = AssetManager.JSON_FILES_TO_LOAD[_loc4_] as String;
				JsonParser.parseFile(mConfig, _loc1_.get(_loc2_));
				_loc4_++;
			}
			var _loc5_: String = "army_config_" + Config.smLanguageCode;
			JsonParser.parseFile(mConfig, _loc1_.get(_loc5_));
			mPvPOpponentsConfig = JSON.parse(_loc1_.get("army_config_pvp_opponents"));
			JsonParser.link(mConfig, Config.smLanguageCode);
		}

		public function createNewScene(param1: MapData): void {
			if (this.mScene != null) {
				this.mScene.destroy();
			}
			this.mScene = SceneLoader.loadFromLevelFactor(this, param1);
			CONFIG::BUILD_FOR_MOBILE_AIR {
				this.mZoomLevels = this.mMapData.mMapSetupData.ZoomLevels;
			}
			CONFIG::BUILD_FOR_AIR {
				this.mZoomLevels = this.mMapData.mMapSetupData.ZoomLevels;
			}
			CONFIG::NOT_BUILD_FOR_AIR {
				this.mZoomLevels = this.mMapData.mMapSetupData.ZoomLevels;
			}
			this.adjustZoomSteps();
			this.mZoomIndex = 0;
			this.mRootNode.addChildAt(this.mScene.mContainer, 0);
		}

		private function adjustZoomSteps(): void {
			var _loc2_: int = 0;
			var _loc1_: Number = this.mScene.mGridDimX;
			while (_loc2_ < this.mZoomLevels.length) {
				this.mZoomLevels[_loc2_] = Math.ceil(this.mZoomLevels[_loc2_] * _loc1_ / 100) / _loc1_ * 100;
				_loc2_++;
			}
		}

		private function UpdateMousePosition(param1: MouseEvent): void {
			this.mMouseX = MouseEvent(param1).stageX;
			this.mMouseY = MouseEvent(param1).stageY;
		}

		private function mouseWheelFlash(param1: MouseEvent): void {
			this.mouseWheel(param1.delta);
		}

		private function mouseWheel(param1: int): void {
			if (!PopUpManager.isModalPopupActive()) {
				if (param1 < 0) {
					this.getHud().buttonZoomOutPressed(null);
				} else if (param1 > 0) {
					this.getHud().buttonZoomInPressed(null);
				}
			}
		}

		private function occupied(param1: Number, param2: Number): Boolean {
			var _loc3_: GridCell = this.mScene.getCellAt(param1, param2);
			if (!_loc3_) {
				return true;
			}
			return !_loc3_.mWalkable;
		}

		private function fixPosition(param1: Number, param2: Number): Point {
			var _loc3_: int = 0;
			var _loc4_: int = param1;
			var _loc5_: int = param2;
			while (this.occupied(_loc4_, _loc5_)) {
				if (++_loc3_ > 10) {
					_loc4_ = int(Math.floor(this.mScene.mSizeX * Math.random()));
					_loc5_ = int(Math.floor(this.mScene.mSizeY * Math.random()));
				} else {
					_loc4_ = param1 + int(Math.floor(_loc3_ * Math.random()));
					_loc5_ = param2 + int(Math.floor(_loc3_ * Math.random()));
				}
			}
			return new Point(_loc4_, _loc5_);
		}

		private function callCheckInbox(param1: Event): void {}

		public function initInboxChecker(): void {}

		public function initialize(): void {
			var split: Array = null;
			var split2: Array = null;
			var splits: Array = null;
			var i: int = 0;
			var id: String = null;
			var item1: Object = null;
			var item2: Object = null;
			var item3: Object = null;
			var item4: Object = null;
			var item5: Object = null;
			var wishListO: Array = null;
			try {
				if (Config.SERVER_URL != null && !Config.OFFLINE_MODE) {
					split = Config.SERVER_URL.split("/");
					if (split.length >= 3) {
						split2 = split[2].split(":");
						if (Config.DEBUG_MODE) {}
					}
				}
				if (Config.DIR_DATA != null) {
					splits = Config.DIR_DATA.split("/");
					if (splits.length >= 3) {
						if (Config.DEBUG_MODE) {}
					}
				}
			} catch (e: Error) {
				Utils.LogError("Error in initializing GameState");
			}
			mMainClip.addChild(this.mRootNode);
			getMainClip().addEventListener(MouseEvent.MOUSE_MOVE, this.UpdateMousePosition, false);
			if (FeatureTuner.USE_PVP_MATCH) {
				this.mPvPMatch = new PvPMatch();
			}
			if (FeatureTuner.USE_GOOGLE_IN_APP_BILLING && !Config.IS_PAYMENT_INITIALLIZED) {
				this.mAndroidPaymentManager = new AndroidPaymentManager();
				Config.IS_PAYMENT_INITIALLIZED = true;
			}
			if (FeatureTuner.USE_FACEBOOK_CONNECT && !Config.IS_FB_INITIALLIZED) {
				this.mAndroidFBConnection = new AndroidFacebookConnection();
				this.mAndroidFBConnection.init();
				Config.IS_FB_INITIALLIZED = true;
			}
			this.restoreNotificationSettings();
			if (FeatureTuner.USE_LOCAL_NOTIFICATION) {
				this.clearNotification();
			}
			this.mText = new TextField();
			this.addDebugText();
			this.mTimer = new Timer(1000);
			this.mTimer.addEventListener(TimerEvent.TIMER, this.oneSec);
			this.mTimer.start();
			this.initHUD();
			this.mVisitingFriend = null;
			this.mMainActionQueue = new ActionQueue();
			if (Config.EDITING_MODE) {
				this.changeState(STATE_MOVE_ITEM);
			} else {
				this.mInitialized = true;
				PauseDialog.mPauseScreenPreviousState = PauseDialog.STATE_UNDEFINED;
				if (!this.mServer.isServerCommError()) {
					if (this.mHUD && this.mHUD.mPullOutMissionFrame && MissionManager.isTutorialCompleted() && this.mHUD.mPullOutMissionMenuState == this.mHUD.STATE_MISSIONS_MENU_CLOSED && MissionManager.isShowMissionButtonCompleted()) {
						this.mHUD.mPullOutMissionFrame.visible = true;
						this.mHUD.mPullOutMissionFrame.gotoAndPlay("Open");
						this.mHUD.mPullOutMissionMenuState = this.mHUD.STATE_MISSIONS_MENU_OPEN;
						this.mHUD.mPullOutMissionFrame.addEventListener(Event.ENTER_FRAME, this.enterFrameMissionInitial);
					}
					CONFIG::BUILD_FOR_MOBILE_AIR {
						var first_time_since_v22: String = Cookie.readCookieVariable(Config.COOKIE_SETTINGS_NAME, Config.COOKIE_SETTINGS_NAME_APPLAUNCH_V22);
						if (first_time_since_v22 != "false") {
							// First time opening the game since v22, show permission window
							Cookie.saveCookieVariable(Config.COOKIE_SETTINGS_NAME, Config.COOKIE_SETTINGS_NAME_SAVELOCATION, "legacy");
							this.mHUD.openGiveFilePermissionScreen();
							Cookie.saveCookieVariable(Config.COOKIE_SETTINGS_NAME, Config.COOKIE_SETTINGS_NAME_APPLAUNCH_V22, false);
						} else {
							this.mHUD.openPauseScreen();
						}
					}
					CONFIG::BUILD_FOR_AIR {
						this.mHUD.openPauseScreen();
					}
					CONFIG::NOT_BUILD_FOR_AIR {
						this.mHUD.openPauseScreen();
					}
				}
			}
			// Restore animation settings
			var animationsOn: String = Cookie.readCookieVariable(Config.COOKIE_SETTINGS_NAME, Config.COOKIE_SETTINGS_NAME_ANIMATION);
			if (animationsOn == "false") {
				this.mAnimationsOn = false;
			} else {
				this.mAnimationsOn = true;
			}
			if (Config.OFFLINE_MODE) {
				i = 0;
				while (i < 13) {
					id = "" + (10 + i);
					item1 = {
						"item_id": "Rebars",
						"item_type": "Ingredient"
					};
					item2 = {
						"item_id": "SteelPlates",
						"item_type": "Ingredient"
					};
					item3 = {
						"item_id": "BlackBox",
						"item_type": "Ingredient"
					};
					item4 = {
						"item_id": "Intel",
						"item_type": "Intel"
					};
					item5 = {
						"item_id": "AllyReport",
						"item_type": "Intel"
					};
					wishListO = [item1, item2, item3, item4, item5];
					FriendsCollection.smFriends.AddFriend(id, id, this.mPlayerProfile.getXpForLevel(i + 2), i + 1, i + 1, i + 1, false, wishListO, "Home");
					FriendsCollection.smFriends.GetFriend(id).mName = "heebo" + i;
					if (i == 3) {
						FriendsCollection.smFriends.GetFriend(id).mPicID = null;
					} else {
						FriendsCollection.smFriends.GetFriend(id).mPicID = "http://profile.ak.fbcdn.net/hprofile-ak-snc4/hs478.snc4/50097_688157980_9857_q.jpg";
					}
					i++;
				}
				FriendsCollection.smFriends.AddFriend(this.mServer.getUid(), this.mServer.getUid(), this.mPlayerProfile.mXp, this.mPlayerProfile.mLevel, this.mPlayerProfile.mRankIdx, this.mPlayerProfile.mSocialLevel, true, null, "Home");
				FriendsCollection.smFriends.GetFriend(this.mServer.getUid()).mName = "Me";
				FriendsCollection.smFriends.GetFriend(this.mServer.getUid()).mPicID = "http://profile.ak.fbcdn.net/hprofile-ak-snc4/hs475.snc4/49862_708382760_1095_q.jpg";
				this.addGeneralBragg();
				FriendsCollection.smFriends.AddToScreen();


				OfflineSave.startEmptyPvPProgress();
			}
			this.logicUpdate(0);
			this.getHud().setZoomIndicator(this.mZoomIndex);
			this.mScene.reCalculateCameraMargins();
			this.mInitialized = true;
			this.mUpdateMissionButtonsPending = true;
			if (this.mMissionIconsManager) {
				this.mMissionIconsManager.resize(this.getStageWidth(), this.getStageHeight());
			}
		}

		private function addDebugText(): void {
			var _loc1_: TextFormat = null;
			if (this.mText.parent == null) {
				this.mText.autoSize = TextFieldAutoSize.RIGHT;
				this.mText.mouseEnabled = false;
				this.mText.y = 300;
				this.mText.x = this.getStageWidth();
				this.mText.defaultTextFormat = Config.TEXT_FORMAT;
				_loc1_ = new TextFormat();
				_loc1_.align = TextFormatAlign.RIGHT;
				this.mText.defaultTextFormat = _loc1_;
				this.mRootNode.addChild(this.mText);
			}
		}

		public function setSpawnTimer(): void {
			this.mSpawnEnemyTimer = this.mPlayerProfile.mSecsSinceLastEnemySpawn * 1000;
		}

		public function initPlayerProfile(param1: ServerCall): void {
			this.mPlayerProfile = new GamePlayerProfile();
			this.mPlayerProfile.setInitialValues(param1);
			this.setSpawnTimer();
		}

		public function initTimers(param1: ServerCall): void {
			var _loc2_: String = null;
			this.mTimers = new Array();
			if (param1) {
				if (param1.mData) {
					if (param1.mData.timers) {
						for (_loc2_ in param1.mData.timers) {
							this.mTimers[_loc2_] = param1.mData.timers[_loc2_];
						}
					}
				}
			}
		}

		public function initMap(param1: ServerCall, param2: String = "Home"): void {
			var _loc3_: int = 0;
			var _loc4_: Object = null;
			var _loc5_: Item = null;
			if (this.mMapData) {
				_loc3_ = this.mMapData.mNumberOfFriendlyTiles;
				this.mMapData.destroy();
			}
			this.mMapData = new MapData();
			if (param1) {
				this.mMapData.initFromServer(param1);
			} else {
				this.mMapData.initOfflineMap(param2, param2 != "Home");
			}
			this.createNewScene(this.mMapData);
			if (this.visitingFriend()) {
				if (!this.visitingTutor()) {
					this.mPlayerProfile.mInventory.initFriendAreas();
				}
				this.mMapData.mNumberOfFriendlyTiles = _loc3_;
			} else if (_loc4_ = GameState.mInstance.mMapData.mMapSetupData.DefaultArea) {
				_loc5_ = ItemManager.getItem(_loc4_.ID, _loc4_.Type);
				if (this.mPlayerProfile.mInventory.getNumberOfItems(_loc5_) <= 0) {
					this.mPlayerProfile.mInventory.addItems(_loc5_, 1);
				}
				(ItemManager.getItem(_loc4_.ID, _loc4_.Type) as AreaItem).mAreaLockedIcon = null;
			}
			this.mScene.initTileMap();
			this.mScene.updateBorderTiles();
			this.mScene.initializeAfterLoading();
			this.mScene.initCursors();
			this.mScene.reCheckCameraLimits();
			this.mScene.reCalculateCameraMargins();
			this.setCameraToStartingPosition(true);
		}

		public function initObjects(param1: ServerCall): void {
			var _loc5_: Renderable = null;
			var _loc8_: HFEPlotObject = null;
			var _loc11_: Array = null;
			var _loc12_: Object = null;
			var _loc13_: int = 0;
			var _loc14_: int = 0;
			var _loc15_: MapItem = null;
			var _loc16_: Renderable = null;
			var _loc17_: PlayerUnit = null;
			var _loc18_: PlayerBuildingObject = null;
			var _loc19_: Renderable = null;
			var _loc20_: int = 0;
			var _loc21_: int = 0;
			var _loc2_: int = this.mPlayerProfile.mSuppliesCap;
			this.mPlayerProfile.mInventory.mInventoryChangedForGetAreas = true;
			if (param1) {
				_loc11_ = param1.mData.gamefield_items;
				this.mKilledPlayerUnits = 0;
				this.mProductionsReadyToHarvest = 0;
				if (_loc11_) {
					this.mDieSoundsEnabled = false;
					_loc13_ = int(_loc11_.length);
					_loc14_ = 0;
					while (_loc14_ < _loc13_) {
						if (!((_loc12_ = _loc11_[_loc14_] as Object).coord_x > this.mScene.mSizeX || _loc12_.coord_y > this.mScene.mSizeY)) {
							_loc15_ = ItemManager.getItemByTableName(_loc12_.item_id, _loc12_.item_type) as MapItem;
							(_loc16_ = this.mScene.createObject(_loc15_, new Point(0, 0))).setupFromServer(_loc12_);
							if (_loc16_ is PlayerUnit) {
								if ((_loc17_ = _loc16_ as PlayerUnit).getHealth() == 0) {
									++this.mKilledPlayerUnits;
								}
							} else if (_loc16_ is PlayerBuildingObject) {
								if ((_loc18_ = _loc16_ as PlayerBuildingObject).getState() == PlayerBuildingObject.STATE_PRODUCTION_READY) {
									++this.mProductionsReadyToHarvest;
								}
								if (_loc18_ is PermanentHFEObject) {
									_loc18_.checkProductionState();
								}
							}
						}
						_loc14_++;
					}
					this.mDieSoundsEnabled = true;
				}
			}
			var _loc3_: Array = this.mScene.mAllElements;
			var _loc4_: Array = new Array();
			var _loc6_: int = int(_loc3_.length);
			var _loc7_: int = 0;
			while (_loc7_ < _loc6_) {
				if ((_loc5_ = _loc3_[_loc7_] as Renderable) is HFEPlotObject) {
					_loc20_ = int(_loc3_.length);
					_loc21_ = 0;
					while (_loc21_ < _loc20_) {
						if ((_loc19_ = _loc3_[_loc21_] as Renderable) is HFEObject) {
							if (_loc5_.mX == _loc19_.mX) {
								if (_loc5_.mY == _loc19_.mY) {
									_loc4_.push(_loc5_);
									break;
								}
							}
						}
						_loc21_++;
					}
				}
				_loc7_++;
			}
			var _loc9_: int = int(_loc4_.length);
			var _loc10_: int = 0;
			while (_loc10_ < _loc9_) {
				_loc8_ = _loc4_[_loc10_] as HFEPlotObject;
				this.mScene.removeObject(_loc8_, false, false);
				_loc10_++;
			}
			this.updateGrid();
			this.mPlayerProfile.updateUnitCaps();
			this.mPlayerProfile.mSuppliesCap = _loc2_;
			this.mScene.findSpawningBeacon();
		}

		private function fakeNeighborActions(): void {
			var _loc1_: Array = new Array();
			var _loc2_: Array = new Array();
			var _loc3_: Array = new Array();
			var _loc4_: Array = new Array();
			var _loc5_: Array = new Array();
			var _loc6_: Array = new Array();
			this.mNeighborActionQueues = new Array();
			_loc1_["neighbor_user_id"] = 1;
			_loc1_["coord_x"] = 50;
			_loc1_["coord_y"] = 63;
			_loc2_["neighbor_user_id"] = 1;
			_loc2_["coord_x"] = 51;
			_loc2_["coord_y"] = 63;
			_loc3_["neighbor_user_id"] = 1;
			_loc3_["coord_x"] = 51;
			_loc3_["coord_y"] = 68;
			var _loc7_: NeighborActionQueue = new NeighborActionQueue([_loc1_, _loc2_, _loc3_]);
			this.mNeighborActionQueues.push(_loc7_);
			_loc4_["neighbor_user_id"] = 11;
			_loc4_["coord_x"] = 54;
			_loc4_["coord_y"] = 63;
			_loc5_["neighbor_user_id"] = 11;
			_loc5_["coord_x"] = 53;
			_loc5_["coord_y"] = 63;
			_loc6_["neighbor_user_id"] = 11;
			_loc6_["coord_x"] = 51;
			_loc6_["coord_y"] = 68;
			var _loc8_: NeighborActionQueue = new NeighborActionQueue([_loc4_, _loc5_, _loc6_]);
			this.mNeighborActionQueues.push(_loc8_);
		}

		private function handleNeighborActions(param1: ServerCall): void {
			var _loc2_: Array = null;
			var _loc3_: NeighborActionQueue = null;
			this.mNeighborActionQueues = new Array();
			if (MissionManager.isTutorialCompleted()) {
				for each(_loc2_ in param1.mData.neighbor_actions) {
					_loc3_ = new NeighborActionQueue(_loc2_);
					this.mNeighborActionQueues.push(_loc3_);
				}
			}
		}

		private function handleBuyIngredientsData(param1: ServerCall): void {
			var _loc4_: AskPartsDialogSmall = null;
			var _loc5_: AskPartsDialogBig = null;
			var _loc2_: ConstructionItem = this.mConstruction.mItem as ConstructionItem;
			var _loc3_: Array = _loc2_.mIngredientRequiredTypes;
			if (_loc3_.length <= 3) {
				if (PopUpManager.isPopUpCreated(AskPartsDialogSmall)) {
					(_loc4_ = PopUpManager.getPopUp(AskPartsDialogSmall) as AskPartsDialogSmall).refresh();
				}
			} else if (PopUpManager.isPopUpCreated(AskPartsDialogBig)) {
				(_loc5_ = PopUpManager.getPopUp(AskPartsDialogBig) as AskPartsDialogBig).refresh();
			}
		}

		private function handleFBCreditsData(param1: ServerCall): void {
			var _loc2_: int = int(param1.mData.gold);
			this.mPlayerProfile.addPremium(_loc2_ - this.mPlayerProfile.mPremium);
		}

		private function handleDailyRewardData(param1: ServerCall): void {
			this.mGrantDailyReward = param1.mData.grant_daily_bonus == "true";
			this.mGrantDailyRewardSpecial = param1.mData.grant_daily_bonus_special == "true";
			this.mDailyRewardDay = param1.mData.consecutive_day_playing;
		}

		public function startPvP(): void {
			var _loc1_: String = null;
			var _loc2_: String = null;
			var _loc3_: String = null;
			var _loc4_: Object = null;
			if (FeatureTuner.USE_PVP_MATCH) {
				_loc1_ = this.mPvPMatch.randomizeMap();
				this.executeSwitchMap(_loc1_, null, true);
				this.startLoading();
				_loc2_ = this.mPvPMatch.getAttackUnitsString();
				_loc3_ = this.mPvPMatch.getDefensiveUnitsString();
				if (_loc2_ != null) {
					_loc4_ = {
						"opponent_user_id": this.mPvPMatch.mOpponent.mFacebookID,
						"attack_units": _loc2_,
						"defensive_units": _loc3_
					};
					// Modified for offline game
					//this.mServer.serverCallServiceWithParameters(ServiceIDs.START_PVP_MATCH, _loc4_, true);
					var fakeservercall: * = new ServerCall(ServiceIDs.START_PVP_MATCH, null, null, null);
					fakeservercall["mData"] = {
						"timestamp": 0
					}
					as Object;
					this.mPlayerProfile.addEnergy(-this.mPvPMatch.mEnergyCost, false);
					this.mPlayerProfile.addSupplies(-this.mPvPMatch.mSupplyCost);
					this.handleStartPvPMatch(fakeservercall);
				}
			}
		}

		public function endPvP(): void {
			var _loc1_: int = 0;
			if (FeatureTuner.USE_PVP_MATCH) {
				if (this.mPvPHUD) {
					this.changeFromPvPHUD();
				}
				_loc1_ = this.mZoomIndex;
				this.executeSwitchMap("Home");
				this.setZoomIndex(_loc1_);
				this.mPvPMatch.mAI = null;
			}
		}

		private function handleStartPvPMatch(param1: ServerCall): void {
			var _loc2_: int = 0;
			if (FeatureTuner.USE_PVP_MATCH) {
				this.changeState(GameState.STATE_PVP);
				_loc2_ = this.mZoomIndex;
				this.mScene.reCalculateCameraMargins();
				this.initMap(null, this.mCurrentMapId);
				this.mScene.updateGridInformation();
				this.mPvPMatch.initMatch(param1.mData);
				this.updateGrid();
				this.mScene.mFog.init(false);
				this.stopLoading();
				this.setZoomIndex(_loc2_);
			}
		}

		public function addNeighborAvatars(): void {
			var _loc1_: NeighborActionQueue = null;
			if (this.mNeighborActionQueues) {
				while (this.mNeighborActionQueues.length > 0) {
					_loc1_ = this.mNeighborActionQueues.shift();
					_loc1_.mapObjects();
					if (FriendsCollection.smFriends.GetFriend(_loc1_.mUserID) != null) {
						if (_loc1_.mTargetObjects.length > 0) {
							this.mScene.addNeighborAvatar(_loc1_);
						} else if (Config.DEBUG_MODE) {}
					} else if (Config.DEBUG_MODE) {}
				}
			}
		}

		public function getMapMusic(): String {
			var _loc1_: Object = mConfig.MapSetup[this.mCurrentMapId];
			if (_loc1_.MusicFile) {
				return _loc1_.MusicFile;
			}
			return ArmySoundManager.MUSIC_HOME;
		}

		public function getMapParatroopers(): EnemyAppearanceSetupItem {
			var _loc1_: Object = null;
			if (MissionManager.isParatroopersMissionCompleted()) {
				_loc1_ = this.mMapData.mMapSetupData.Paratrooper;
				return ItemManager.getItemByTableName(_loc1_.ID, "EnemyAppearanceSetup") as EnemyAppearanceSetupItem;
			}
			return null;
		}

		public function getHud(): HUDInterface {
			return !!this.mHUD ? this.mHUD : this.mPvPHUD;
		}

		public function startMusic(): void {
			ArmySoundManager.getInstance().stopAll();
			ArmySoundManager.getInstance().playSound(this.mCurrentMusic, 1, 0, -1);
		}

		public function keyDown(param1: KeyboardEvent): void {
			if (!this.mScene) {
				return;
			}
			if (Config.CHEAT_ALLOWED) {
				smCheatCodeString += String.fromCharCode(param1.keyCode).charAt(0);
				if (smCheatCodeString.length >= CHEAT_CODE.length) {
					smCheatCodeString = smCheatCodeString.substr(smCheatCodeString.length - CHEAT_CODE.length);
					if (smCheatCodeString.toLocaleUpperCase().localeCompare(CHEAT_CODE) == 0) {
						smCheatCodeTyped = true;
					}
				}
			}
			if (Config.DEBUG_ALLOWED) {
				smDebugCodeString += String.fromCharCode(param1.keyCode).charAt(0);
				if (smDebugCodeString.length >= Config.DEBUG_CODE.length) {
					smDebugCodeString = smDebugCodeString.substr(smDebugCodeString.length - Config.DEBUG_CODE.length);
					if (smDebugCodeString.toLocaleUpperCase().localeCompare(Config.DEBUG_CODE) == 0) {
						Config.DEBUG_MODE = true;
						this.addDebugText();
					}
				}
			}
			if (Config.DETAILED_ERROR_MSG_ENABLED) {
				if (this.mErrorDialogOpen) {
					smHiddenErrorMessageCodeString += String.fromCharCode(param1.keyCode).charAt(0);
					if (smHiddenErrorMessageCodeString.length >= Config.DETAILED_ERROR_MSG_CODE.length) {
						smHiddenErrorMessageCodeString = smHiddenErrorMessageCodeString.substr(smHiddenErrorMessageCodeString.length - Config.DETAILED_ERROR_MSG_CODE.length);
						if (smHiddenErrorMessageCodeString.localeCompare(Config.DETAILED_ERROR_MSG_CODE) == 0) {
							if (this.mServer != null && this.mServer.getErrorObject() != null && this.mServer.getErrorObject().getMessage() != null) {
								this.getHud().openHiddenErrorMessage("Details", this.mServer.getErrorObject().getMessage());
							} else {
								this.getHud().openHiddenErrorMessage("Details", "Details no accessible !!!");
							}
						}
					}
				}
			}
			if (Config.DEBUG_VIEWERS) {
				if (param1.keyCode == 68) {
					this.mScene.mFog.init();
				}
			}
			if (Config.DEBUG_MODE) {}
			if (smCheatCodeTyped) {
				if (param1.keyCode >= 48 && param1.keyCode <= 57) {
					if (param1.keyCode == 49) {
						smTimeFactor = 1;
					} else if (param1.keyCode == 48) {
						smTimeFactor = 3600;
					} else {
						smTimeFactor = (param1.keyCode - 48) * (param1.keyCode - 48) * (param1.keyCode - 48);
					}
					this.mTimer.delay = 1000 / smTimeFactor;
					return;
				}
			}
			if (param1.keyCode == 17) {
				this.mCtrlPressed = true;
			}
			switch (param1.keyCode) {
				case 38:
					this.mScene.mUpPressed = true;
					break;
				case 40:
					this.mScene.mDownPressed = true;
					break;
				case 37:
					this.mScene.mLeftPressed = true;
					break;
				case 39:
					this.mScene.mRightPressed = true;
					break;
				case 70:
					this.toggleFullScreen();
					break;
				case 85:
					if (smCheatCodeTyped) {
						this.toggleUnlockCheat();
					}
					break;
				case 69:
					if (smCheatCodeTyped) {}
					break;
				case 87:
					if (smCheatCodeTyped) {}
					break;
				case 81:
					if (smCheatCodeTyped) {}
					break;
				case 90:
					this.freezeFrame(true);
					break;
				case 88:
					this.unFreezeFrame();
					break;
				case 35:
					if (Config.CHEAT_ALLOWED) {
						//this.startPvP();
						// don't forget to disable cheat lol
						this.openPvPMatchUpDialog();
					}
					break;
				case 33:
					this.setZoomIndex(0);
					break;
				case 34:
					this.setZoomIndex(1);
					break;
			}
		}

		public function useFireMission(param1: GridCell, param2: int, param3: int, param4: FireMissionItem): void {
			var _loc6_: GridCell = null;
			param1.mPosI = param2;
			param1.mPosJ = param3;
			var _loc5_: Array;
			var _loc7_: int = int((_loc5_ = MapArea.getArea(this.mScene, param1.mPosI, param1.mPosJ, param4.mSize.x, param4.mSize.y).getCells()).length);
			var _loc8_: int = 0;
			while (_loc8_ < _loc7_) {
				if (Boolean((_loc6_ = _loc5_[_loc8_] as GridCell).mObject) && _loc6_.mObject is PermanentHFEObject) {
					ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ERROR);
					return;
				}
				_loc8_++;
			}
			this.queueAction(new FireMissionAction(param1, param4));
			if (param4.mlaunchWithGold) {
				GameState.mInstance.mPlayerProfile.addPremium(-param4.mUnlockCost);
			}
			this.cancelTools();
			if (this.mHUD) {
				this.mHUD.cancelTools();
				this.mHUD.disableFireCallHint();
			}
		}

		public function keyUp(param1: KeyboardEvent): void {
			if (param1.keyCode == 17) {
				this.mCtrlPressed = false;
			}
			switch (param1.keyCode) {
				case 38:
					this.mScene.mUpPressed = false;
					break;
				case 40:
					this.mScene.mDownPressed = false;
					break;
				case 37:
					this.mScene.mLeftPressed = false;
					break;
				case 39:
					this.mScene.mRightPressed = false;
			}
		}

		private function oneSec(param1: Event): void {
			this.mFrameRate = this.mFrames;
			this.mFrames = 0;
			this.mPlayerProfile.rechargeTimerTick();
		}

		private function initHUD(): void {
			this.mHUD = new GameHUD(this);
			this.mRootNode.addChild(this.mHUD);
			this.mMissionIconsManager = new MissionIconsManager(this.mHUD);
		}

		public function objectPlaced(param1: Renderable, param2: Number, param3: Number): void {
			var _loc4_: int = 0;
			this.mScene.mPlacePressed = false;
			if (this.mState == STATE_PLACE_ITEM || this.mState == STATE_WAIT_FB_CALLBACK) {
				if ((_loc4_ = this.mPlayerProfile.mMoney - this.mItemToBePlaced.getCostMoney()) < this.mItemToBePlaced.getCostMoney() || !(this.mItemToBePlaced is HFEItem || this.mItemToBePlaced is HFEPlotItem)) {
					this.changeState(STATE_PLAY);
					if (this.mItemToBePlaced is SignalItem && this.mObjectToBePlaced && this.mObjectToBePlaced is SignalObject) {
						SignalObject(this.mObjectToBePlaced).openFlarePopup();
					}
				}
				this.executeBuyItemWithLoc(this.mItemToBePlaced);
			} else if (this.mState == STATE_USE_INVENTORY_ITEM) {
				this.changeState(STATE_PLAY);
				this.executeUseInventoryItem();
			} else {
				this.executeObjectMoved(param1, param2, param3);
			}
			this.mMapData.mUpdateRequired = true;
			this.updateGrid();
		}

		public function inventoryItemUsed(): void {
			this.mPlayerProfile.mInventory.addItems(this.mInventoryItemToBePlaced, -1);
			this.cancelTools();
			if (this.mHUD) {
				this.mHUD.showCancelButton(false);
			}
		}

		public function pickupUnit(param1: PlayerUnit): void {
			var _loc2_: PlayerUnitItem = null;
			var _loc3_: Object = null;
			if (this.checkIfUnitIsPickable(param1)) {
				_loc2_ = param1.mItem as PlayerUnitItem;
				this.mPlayerProfile.mInventory.addItems(param1.mItem, 1);
				_loc3_ = {
					"map_id": this.mCurrentMapId,
					"coord_x": param1.getCell().mPosI,
					"coord_y": param1.getCell().mPosJ
				};
				this.mServer.serverCallServiceWithParameters(ServiceIDs.PICK_UP_UNIT, _loc3_, false);
				this.mScene.removeObject(param1, true, true);
				this.mPlayerProfile.addSupplies(-_loc2_.mPickupCostSupplies, ServiceIDs.PICK_UP_UNIT);
				this.mPlayerProfile.updateUnitCaps();
				this.changeState(STATE_PICKUP_UNIT);
			}
		}

		public function checkIfUnitIsPickable(param1: PlayerUnit): Boolean {
			if (this.mState == STATE_PVP) {
				return false;
			}
			var _loc2_: PlayerUnitItem = param1.mItem as PlayerUnitItem;
			if (param1.isFullHealth() && this.mPlayerProfile.mSupplies >= _loc2_.mPickupCostSupplies) {
				return true;
			}
			ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ERROR);
			if (!param1.isFullHealth()) {
				this.mHUD.openRedeployHealWarningTextBox(null);
			} else {
				this.mHUD.openOutOfSuppliesTextBox(null);
			}
			return false;
		}

		public function initServer(): void {
			this.mServer = new MyServer(this);
		}

		public function executeSwitchMap(param1: String, param2: Friend = null, param3: Boolean = false): void {
			OfflineSave.saveOldMap();
			trace("volgende lijn")
			var _loc4_: Object = null;
			if ((this.mVisitingFriend == param2 || this.mVisitingFriend == null && param2 == null) && param1 == this.mCurrentMapId) {
				return;
			}
			if (param2) {
				if (this.mVisitingFriend == null) {
					this.mCurrentPlayerMapId = this.mCurrentMapId;
				}
			}
			this.mCurrentMapId = param1;
			this.mCurrentMapGraphicsId = Math.max(GRAPHICS_MAP_ID_LIST.indexOf(param1), 0);

			if (Boolean(param2) && !param3) {
				this.mPlayerProfile.setNeighborActions(0);
			}
			if (!param3) {
				if (Config.OFFLINE_MODE) {
					if (param2) {
						this.mVisitingFriend = param2;
						this.mPlayerProfile.setNeighborActions(5);
						this.changeState(STATE_VISITING_NEIGHBOUR);
						MissionManager.increaseCounter("VisitNeighbor", null, 1);
						this.mHUD.openVisitingRewardTextBox();
						this.addVisitNeighborRewards();
					} else {
						this.startLoading();
						this.mScene.reCalculateCameraMargins();
						this.initMap(null, param1);
						this.initObjects(null);
						this.updateGrid();
						this.addNeighborAvatars();
						this.mScene.mFog.init();
						EnvEffectManager.init();
						this.changeState(STATE_PLAY);
						this.stopLoading();
					}
				} else {
					this.startLoading();
					this.changeState(STATE_LOADING_NEIGHBOUR);
					if (param2) {
						if (param2.mIsTutor) {
							this.mServer.serverCallService(ServiceIDs.GET_TUTOR_DATA, true);
							if (Config.DEBUG_MODE) {}
						} else {
							_loc4_ = {
								"neighbor_user_id": param2.mUserID
							};
							this.mServer.serverCallServiceWithParameters(ServiceIDs.GET_NEIGHBOR_DATA, _loc4_, true);
						}
					} else {
						this.mNeighborActionQueues = null;
						_loc4_ = {
							"map_id": param1
						};
						this.mServer.serverCallServiceWithParameters(ServiceIDs.GET_MAP_DATA, _loc4_, true);
					}
				}
			}
			this.mVisitingFriend = param2;
			OfflineSave.switchMap();
		}

		public function executeReturnHome(): void {
			this.executeSwitchMap(this.mCurrentPlayerMapId, null);
		}

		public function executeVisitFriend(param1: Friend): void {
			this.executeSwitchMap(param1.mActiveMapID, param1);
		}

		private function startLoading(): void {
			var _loc3_: String = null;
			getMainClip().mouseChildren = false;
			this.cancelAllActions();
			this.cancelTools();
			this.getHud().cancelTools();
			this.updateActions(0);
			var _loc1_: DCResourceManager = DCResourceManager.getInstance();
			var _loc2_: String = Config.SWF_POPUPS_START_NAME;
			if (_loc1_.isLoaded(_loc2_)) {
				this.addLoadingClip();
			} else {
				_loc3_ = _loc2_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
				_loc1_.addEventListener(_loc3_, this.LoadingFinished, false, 0, true);
				if (!_loc1_.isAddedToLoadingList(_loc2_)) {
					_loc1_.load(Config.DIR_DATA + _loc2_ + ".swf", _loc2_, null, false);
				}
			}
		}

		protected function LoadingFinished(param1: Event): void {
			DCResourceManager.getInstance().removeEventListener(param1.type, this.LoadingFinished);
			this.addLoadingClip();
		}

		private function addLoadingClip(): void {
			var _loc2_: Array = null;
			var _loc3_: Class = null;
			var _loc4_: TextField = null;
			if (this.mLoadingClip == null) {
				_loc3_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME, "popup_loading");
				this.mLoadingClip = new _loc3_();
				(this.mLoadingClip.getChildByName("Header") as MovieClip).visible = false;
				(_loc4_ = this.mLoadingClip.getChildByName("Text_Description") as TextField).text = getText("LOADING_INGAME_DESCRIPTION");
			}
			this.mLoadingClip.x = this.getStageWidth() / 2;
			this.mLoadingClip.y = this.getStageHeight() / 2;
			this.mRootNode.addChild(this.mLoadingClip);
			this.mCurrentMusic = this.getMapMusic()
			ArmySoundManager.loadMusic(this.mCurrentMusic);
			this.startMusic();
			var _loc1_: Object = (mConfig.MapSetup[this.mCurrentMapId] as Object).SWFFile;
			if (_loc1_ is Array) {
				_loc2_ = _loc1_ as Array;
			} else {
				_loc2_ = [_loc1_];
			}
			Utils.addSwfToResourceManager(_loc2_);
		}

		private function stopLoading(): void {
			if (Boolean(this.mLoadingClip) && this.mRootNode.contains(this.mLoadingClip)) {
				this.mRootNode.removeChild(this.mLoadingClip);
			}
			getMainClip().mouseChildren = true;
		}

		public function addToWorld(param1: MapItem): void {
			this.mItemToBePlaced = param1;
			this.changeState(STATE_PLACE_ITEM);
			this.mObjectToBePlaced = this.mScene.createObject(param1, new Point(0, 0));
			this.mScene.setSelectedObject(this.mObjectToBePlaced);
			this.mHUD.showCancelButton(true);
		}

		public function setFromInventory(param1: MapItem): void {
			this.mInventoryItemToBePlaced = param1;
			this.changeState(STATE_USE_INVENTORY_ITEM);
			if (param1.mType != "PowerUp") {
				this.mItemToBePlaced = param1;
				this.mObjectToBePlaced = this.mScene.createObject(param1, new Point(0, 0));
				this.mScene.setSelectedObject(this.mObjectToBePlaced);
			}
			this.mHUD.showCancelButton(true);
		}

		public function cancelDecoPurchase(): void {
			if (this.mState == STATE_PLACE_ITEM || this.mState == STATE_WAIT_FB_CALLBACK) {
				if (this.mObjectToBePlaced != null) {
					this.mScene.removeObject(this.mObjectToBePlaced, true);
				}
				this.mScene.cancelEditMode();
				this.changeState(Config.EDITING_MODE ? STATE_MOVE_ITEM : STATE_PLAY);
				this.mObjectToBePlaced = null;
				this.mItemToBePlaced = null;
			}
		}

		public function executeBuyItemWithLoc(param1: ShopItem): void {
			var _loc9_: Object = null;
			ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_BUY_ITEM);
			ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_PLACE_ITEM);
			var _loc2_: int = param1.getCostMoney();
			var _loc3_: int = param1.getCostSupplies();
			var _loc4_: int = param1.getCostMaterial();
			var _loc5_: int = param1.getCostPremium();
			this.mPlayerProfile.addMoney(-_loc2_, MagicBoxTracker.LABEL_BUY_ITEM_WITH_LOCATION, MagicBoxTracker.paramsObj(param1.mType, param1.mId));
			this.mPlayerProfile.addSupplies(-_loc3_, MagicBoxTracker.LABEL_BUY_ITEM_WITH_LOCATION, MagicBoxTracker.paramsObj(param1.mType, param1.mId));
			this.mPlayerProfile.addMaterial(-_loc4_);
			this.mPlayerProfile.addPremium(-_loc5_, MagicBoxTracker.LABEL_BUY_ITEM_WITH_LOCATION, MagicBoxTracker.paramsObj(param1.mType, param1.mId));
			if (this.mObjectToBePlaced is PlayerBuildingObject) {
				PlayerBuildingObject(this.mObjectToBePlaced).handlePlacedOnMap();
			}
			if (this.mObjectToBePlaced is PlayerUnit) {
				this.mPlayerProfile.updateUnitCaps();
				this.mPlayerProfile.addUnit(this.mObjectToBePlaced.mItem as PlayerUnitItem);
			} else if (this.mObjectToBePlaced is DecorationObject) {
				this.mPlayerProfile.increaseSuppliesCap(this.mObjectToBePlaced);
			}
			MissionManager.increaseCounter("Buy", param1.mId, 1);
			var _loc6_: GridCell = this.mObjectToBePlaced.getCell();
			var _loc7_: String = null;
			var _loc8_: String = "";
			if (this.mObjectToBePlaced is HFEObject || this.mObjectToBePlaced is HFEPlotObject) {
				_loc7_ = ServiceIDs.BUY_AND_PLACE_HFE;
			} else if (this.mObjectToBePlaced is ConstructionObject) {
				_loc7_ = ServiceIDs.BUY_AND_PLACE_BUILDING;
				_loc8_ = "Building";
			} else if (this.mObjectToBePlaced is ResourceBuildingObject) {
				_loc7_ = ServiceIDs.BUY_AND_PLACE_BUILDING;
				_loc8_ = "ResourceBuilding";
			} else if (this.mObjectToBePlaced is PlayerUnit) {
				_loc7_ = ServiceIDs.BUY_AND_PLACE_UNIT;
			} else if (this.mObjectToBePlaced is DecorationObject) {
				_loc7_ = ServiceIDs.BUY_AND_PLACE_DECO;
				_loc8_ = this.mObjectToBePlaced.mItem.mType;
			} else if (this.mObjectToBePlaced is PlayerInstallationObject) {
				_loc7_ = ServiceIDs.BUY_AND_PLACE_INSTALLATION;
			}
			if (_loc7_) {
				_loc9_ = {
					"coord_x": _loc6_.mPosI,
					"coord_y": _loc6_.mPosJ,
					"item_id": param1.mId,
					"cost_money": _loc2_,
					"cost_supplies": _loc3_,
					"cost_material": _loc4_,
					"cost_premium": _loc5_,
					"item_type": _loc8_
				};
				this.mServer.serverCallServiceWithParameters(_loc7_, _loc9_, false);
				if (Config.DEBUG_MODE) {}
			}
			this.mObjectToBePlaced = null;
			if ((param1 is HFEPlotItem || param1 is HFEItem) && param1.canAffordItemWithResources()) {
				this.addToWorld(MapItem(param1));
			} else {
				this.mItemToBePlaced = null;
				this.mHUD.showCancelButton(false);
			}
		}

		public function executeBuyItem(param1: ShopItem): void {
			var _loc7_: int = 0;
			var _loc8_: Object = null;
			var _loc9_: PvPCombatSetupDialog = null;
			var _loc10_: int = 0;
			var _loc11_: ProductionDialog = null;
			var _loc12_: Object = null;
			var _loc13_: AreaItem = null;
			var _loc14_: int = 0;
			var _loc15_: Item = null;
			var _loc2_: int = param1.getCostMoney();
			var _loc3_: int = param1.getCostSupplies();
			var _loc4_: int = param1.getCostMaterial();
			var _loc5_: int = param1.getCostPremium();
			this.mPlayerProfile.addMoney(-_loc2_, MagicBoxTracker.LABEL_BUY_ITEM, MagicBoxTracker.paramsObj(param1.mType, param1.mId));
			this.mPlayerProfile.addSupplies(-_loc3_, MagicBoxTracker.LABEL_BUY_ITEM, MagicBoxTracker.paramsObj(param1.mType, param1.mId));
			this.mPlayerProfile.addMaterial(-_loc4_);
			this.mPlayerProfile.addPremium(-_loc5_, MagicBoxTracker.LABEL_BUY_ITEM, MagicBoxTracker.paramsObj(param1.mType, param1.mId));
			MissionManager.increaseCounter("Buy", param1.mId, 1);
			var _loc6_: Inventory = this.mPlayerProfile.mInventory;
			if (param1 is EnergyRefillItem) {
				_loc7_ = EnergyRefillItem(param1).mEnergyGain;
				this.mPlayerProfile.addEnergy(_loc7_);
				if (PopUpManager.isPopUpCreated(PvPCombatSetupDialog)) {
					(_loc9_ = PopUpManager.getPopUp(PvPCombatSetupDialog) as PvPCombatSetupDialog).refresh();
				}
				_loc8_ = {
					"energy_refill_type": param1.mId,
					"cost_premium": _loc5_
				};
				this.mServer.serverCallServiceWithParameters(ServiceIDs.BUY_ENERGY, _loc8_, false);
				if (Config.DEBUG_MODE) {}
				ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ENERGY_BOOST);
			} else if (param1 is SupplyPackItem) {
				_loc10_ = SupplyPackItem(param1).mSuppliesGain;
				this.mPlayerProfile.addSupplies(_loc10_);
				_loc8_ = {
					"supply_pack_id": param1.mId,
					"cost_premium": _loc5_
				};
				this.mServer.serverCallServiceWithParameters(ServiceIDs.BUY_SUPPLIES, _loc8_, false);
				if (PopUpManager.isPopUpCreated(ProductionDialog)) {
					(_loc11_ = PopUpManager.getPopUp(ProductionDialog) as ProductionDialog).setScreen();
				}
				if (Config.DEBUG_MODE) {}
				ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ENERGY_BOOST);
			} else if (param1 is WaterPackItem) {
				_loc7_ = WaterPackItem(param1).mWaterGain;
				this.mPlayerProfile.addWater(_loc7_);


				// To be fixed
				/*
            if(PopUpManager.isPopUpCreated(PvPCombatSetupDialog))
            {
               (_loc9_ = PopUpManager.getPopUp(PvPCombatSetupDialog) as PvPCombatSetupDialog).refresh();
            }
            _loc8_ = {
               "energy_refill_type":param1.mId,
               "cost_premium":_loc5_
            };
            this.mServer.serverCallServiceWithParameters(ServiceIDs.BUY_ENERGY,_loc8_,false);
            if(Config.DEBUG_MODE)
            {
            }
			*/

				ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ENERGY_BOOST);
			} else if (param1 is AreaItem) {
				needToUpdatePermanentHFE = true;
				_loc6_.addItems(param1, 1);
				ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_AREA_UNLOCK);
				if (!param1.mEarlyUnlockBought) {
					_loc14_ = param1.mCostIntel;
					_loc15_ = ItemManager.getItem("Intel", "Intel");
					_loc6_.addItems(_loc15_, -_loc14_);
				}
				_loc12_ = {
					"item_id": param1.mId,
					"cost_money": _loc2_
				};
				this.mServer.serverCallServiceWithParameters(ServiceIDs.BUY_MAP_AREA, _loc12_, false);
				if (Config.DEBUG_MODE) {}
				this.mScene.updateBorderTiles();
				this.mMapData.mUpdateRequired = true;
				if ((_loc13_ = param1 as AreaItem).mAreaLockedIcon) {
					_loc13_.mAreaLockedIcon.visible = false;
					if (_loc13_.mAreaLockedIcon.parent) {
						_loc13_.mAreaLockedIcon.parent.removeChild(_loc13_.mAreaLockedIcon);
					}
					_loc13_.mAreaLockedIcon = null;
				}
				this.mScene.mFog.init();
			} else {
				_loc6_.addItems(param1, 1);
				ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_BUY_ITEM);
			}
		}

		public function executeBuyEarlyUnlock(param1: ShopItem): void {
			var _loc5_: ShopDialog = null;
			param1.mEarlyUnlockBought = true;
			var _loc2_: int = param1.getUnlockCost();
			this.mPlayerProfile.addPremium(-_loc2_, MagicBoxTracker.LABEL_BUY_EARLY_UNLOCK, MagicBoxTracker.paramsObj(param1.mType, param1.mId));
			if (PopUpManager.isPopUpCreated(ShopDialog)) {
				(_loc5_ = PopUpManager.getPopUp(ShopDialog) as ShopDialog).setScreen();
			}
			var _loc3_: String = ItemManager.getTableNameForItem(param1);
			var _loc4_: Object = {
				"item_type": _loc3_,
				"item_id": param1.mId
			};
			this.mServer.serverCallServiceWithParameters(ServiceIDs.UNLOCK_ITEM, _loc4_, false);
			if (Config.DEBUG_MODE) {}
		}

		private function executeObjectMoved(param1: Renderable, param2: Number, param3: Number): void {
			var _loc7_: int = 0;
			var _loc8_: Object = null;
			var _loc4_: int = this.mScene.findGridLocationX(param2);
			var _loc5_: int = this.mScene.findGridLocationY(param3);
			var _loc6_: GridCell = param1.getCell();
			if (_loc4_ != _loc6_.mPosI || _loc5_ != _loc6_.mPosJ) {
				_loc7_ = param1.getMoveCostSupplies();
				this.mPlayerProfile.addSupplies(-_loc7_, MagicBoxTracker.LABEL_TOOL_MOVE_BUILDING, MagicBoxTracker.paramsObj(param1.mItem.mType, param1.mItem.mId));
				_loc8_ = {
					"coord_x": _loc4_,
					"coord_y": _loc5_,
					"new_coord_x": _loc6_.mPosI,
					"new_coord_y": _loc6_.mPosJ
				};
				this.mServer.serverCallServiceWithParameters(ServiceIDs.MOVE_STRUCTURE, _loc8_, false);
				MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_ECONOMY, MagicBoxTracker.TYPE_GAME_ACTION, MagicBoxTracker.LABEL_TOOL_MOVE_BUILDING, MagicBoxTracker.paramsObj(param1.mItem.mType, param1.mItem.mId));
				if (Config.DEBUG_MODE) {}
			}
		}

		private function executeUseInventoryItem(): void {
			if (!this.mObjectToBePlaced) {
				return;
			}
			var _loc1_: ShopItem = this.mInventoryItemToBePlaced as ShopItem;
			if (this.mObjectToBePlaced is PlayerBuildingObject) {
				PlayerBuildingObject(this.mObjectToBePlaced).handlePlacedOnMap();
			}
			if (this.mObjectToBePlaced is PlayerUnit) {
				this.mPlayerProfile.updateUnitCaps();
			} else if (this.mObjectToBePlaced is DecorationObject) {
				this.mPlayerProfile.increaseSuppliesCap(this.mObjectToBePlaced);
			}
			MissionManager.increaseCounter("Place", _loc1_.mId, 1);
			var _loc2_: GridCell = this.mObjectToBePlaced.getCell();
			var _loc3_: Object = {
				"coord_x": _loc2_.mPosI,
				"coord_y": _loc2_.mPosJ,
				"item_id": _loc1_.mId
			};
			var _loc4_: String = null;
			if (!(this.mObjectToBePlaced is HFEObject || this.mObjectToBePlaced is HFEPlotObject)) {
				if (!(this.mObjectToBePlaced is ConstructionObject || this.mObjectToBePlaced is ResourceBuildingObject)) {
					if (this.mObjectToBePlaced is PlayerUnit) {
						_loc4_ = ServiceIDs.PLACE_UNIT_FROM_INVENTORY;
					} else if (this.mObjectToBePlaced is DecorationObject) {
						_loc4_ = ServiceIDs.PLACE_DECO;
					} else if (this.mObjectToBePlaced is PlayerInstallationObject) {}
				}
			}
			this.mScene.incrementViewersForPlacedObject();
			if (_loc4_) {
				this.mServer.serverCallServiceWithParameters(_loc4_, _loc3_, false);
				if (Config.DEBUG_MODE) {}
			}
			this.mObjectToBePlaced = null;
			this.mItemToBePlaced = null;
			this.mHUD.showCancelButton(false);
		}

		public function executeTradeInCollection(param1: ItemCollectionItem): void {
			var _loc2_: Item = null;
			var _loc7_: Item = null;
			var _loc3_: int = int(param1.mItems.length);
			var _loc4_: int = 0;
			while (_loc4_ < _loc3_) {
				_loc2_ = param1.mItems[_loc4_] as Item;
				this.mPlayerProfile.addItem(_loc2_, -1);
				_loc4_++;
			}
			this.mPlayerProfile.addMoney(param1.mRewardMoney);
			this.mPlayerProfile.addXp(param1.mRewardXP);
			this.mPlayerProfile.addSupplies(param1.mRewardSupplies);
			this.mPlayerProfile.addEnergy(param1.mRewardEnergy);
			var _loc5_: Array = new Array();
			var _loc6_: Array = new Array();
			var _loc8_: int = int(param1.mRewardItems.length);
			var _loc9_: int = 0;
			while (_loc9_ < _loc8_) {
				_loc7_ = param1.mRewardItems[_loc9_] as Item;
				this.mPlayerProfile.addItem(_loc7_, 1);
				_loc5_.push(ItemManager.getTableNameForItem(_loc7_));
				_loc6_.push(_loc7_.mId);
				_loc9_++;
			}
			var _loc10_: Object = {
				"collection_id": param1.mId,
				"reward_xp": param1.mRewardXP,
				"reward_money": param1.mRewardMoney,
				"reward_supplies": param1.mRewardSupplies,
				"reward_energy": param1.mRewardEnergy * 100
			};
			if (_loc5_.length > 0) {
				_loc10_.reward_item_type = _loc5_.toString();
				_loc10_.reward_item_id = _loc6_.toString();
			}
			this.mServer.serverCallServiceWithParameters(ServiceIDs.TRADE_IN_COLLECTION, _loc10_, false);
			if (Config.DEBUG_MODE) {}
			MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_ECONOMY, MagicBoxTracker.TYPE_TRADE_COLLECTION, MagicBoxTracker.PS_ID + " " + param1.mId.toString(), MagicBoxTracker.paramsObj(param1.mId.toString()));
			this.mHUD.openCollectionTradedTextBox(param1);
		}

		private function updateLoading(): Boolean {
			var _loc1_: DCResourceManager = DCResourceManager.getInstance();
			var _loc2_: int = _loc1_.getFileCountToLoad();
			if (_loc2_ > 0) {
				return false;
			}
			return true;
		}

		private function processServerResponses(): Boolean {
			var _loc2_: String = null;
			var _loc3_: ErrorObject = null;
			var _loc4_: String = null;
			var _loc5_: Array = null;
			var _loc1_: ServerCall = this.mServer.fetchResponseFromBuffer();
			if (this.mServer.isServerCommError()) {
				if (!this.mErrorDialogOpen) {
					_loc2_ = getText("MENU_DESC_SERVER_ERROR");
					_loc3_ = null;
					if (Config.DEBUG_MODE) {
						_loc3_ = this.mServer.getErrorObject();
						_loc2_ += "\n" + _loc3_.getMessage();
					}
					if (_loc3_ == null) {
						if (this.mServer.isConnectionError() || this.mServer.isServerCommError()) {
							_loc3_ = this.mServer.getErrorObject();
						} else {
							_loc3_ = MagicBoxTracker.getErrorObject("NEVER HAPPEN", MagicBoxTracker.TYPE_ERR_NA + "_2", "", "Client GameState");
						}
					}
					this.getHud().openErrorMessage(getText("MENU_HEADER_SERVER_ERROR"), _loc2_, _loc3_);
					this.mErrorDialogOpen = true;
					return false;
				}
			}
			if (_loc1_ != null) {
				if ((_loc4_ = _loc1_.mServiceId) != ServiceIDs.GET_WCRM_DATA) {
					if (_loc4_ == ServiceIDs.GET_NEIGHBOR_DATA) {
						this.handleNeighborData(_loc1_);
					} else if (_loc4_ == ServiceIDs.GET_TUTOR_DATA) {
						this.handleTutorData(_loc1_);
					} else if (_loc4_ == ServiceIDs.GET_MAP_DATA) {
						this.handleMapData(_loc1_);
					} else if (_loc4_ == ServiceIDs.GET_GOLD_AND_CASH) {
						this.handleFBCreditsData(_loc1_);
					} else if (_loc4_ == ServiceIDs.GET_DAILY_REWARD) {
						this.handleDailyRewardData(_loc1_);
					} else if (_loc4_ == ServiceIDs.GET_INVENTORY) {
						this.mPlayerProfile.mInventory.initializeFromServer(_loc1_.mData);
					} else if (_loc4_ == ServiceIDs.GET_USER_DATA) {
						_loc5_ = _loc1_.mData.gained_free_units as Array;
						this.mShowFreeUnitsReceived = _loc5_ != null && _loc5_.length > 0;
						if (MissionManager.isTutorialCompleted() && this.mServer && updateUserDataFlag) {
							this.initProcessPlayerProfile(_loc1_);
							updateUserDataFlag = false;
						}
						this.mPlayerProfile.mInventory.initializeFromServer(_loc1_.mData);
						this.initTimers(_loc1_);
					} else if (_loc4_ == ServiceIDs.GET_PVP_DATA) {
						if (FeatureTuner.USE_PVP_MATCH) {
							this.mPlayerProfile.setupPvPData(_loc1_.mData);
							this.mPlayerProfile.setupGlobalUnitCounts(_loc1_.mData);
							this.stopLoading();
							this.openPvPMatchUpDialog();
						}
					} else if (_loc4_ == ServiceIDs.START_PVP_MATCH) {
						if (FeatureTuner.USE_PVP_MATCH) {
							this.handleStartPvPMatch(_loc1_);
						}
					} else if (_loc4_ == ServiceIDs.BUY_INGREDIENTS) {
						this.handleBuyIngredientsData(_loc1_);
					}
				}
			}
			return this.mServer.getNumberOfBlockingCalls() == 0;
		}

		public function initProcessPlayerProfile(param1: ServerCall): void {
			this.mPlayerProfile.setProcessInitialValues(param1);
		}

		private function updateFriendlyHelpers(): void {
			var _loc1_: Renderable = null;
			var _loc2_: int = int(this.mScene.mAllElements.length);
			var _loc3_: int = 0;
			while (_loc3_ < _loc2_) {
				_loc1_ = this.mScene.mAllElements[_loc3_] as Renderable;
				if (_loc1_ is ResourceBuildingObject) {
					ResourceBuildingObject(_loc1_).refreshHelpingFriends();
				}
				_loc3_++;
			}
		}

		private function handleGetFriendsResponse(param1: ServerCall): void {
			var _loc4_: Object = null;
			var _loc7_: int = 0;
			var _loc8_: FriendsCollection = null;
			var _loc2_: Array = new Array();
			var _loc3_: Array = param1.mData.neighbors;
			FriendsCollection.smFriends.reset();
			var _loc5_: int = int(_loc3_.length);
			var _loc6_: int = 0;
			while (_loc6_ < _loc5_) {
				_loc4_ = _loc3_[_loc6_] as Object;
				_loc7_ = this.mPlayerProfile.getSocialLevelForExperience(_loc4_.socialXp);
				FriendsCollection.smFriends.AddFriend(_loc4_.neighbor_user_id, _loc4_.neighbor_user_id, _loc4_.xp, _loc4_.level, _loc4_.rank_id, _loc7_, _loc4_.neighbor_user_id == this.mServer.getUid(), _loc4_.wishlist, _loc4_.active_map_id, _loc4_.help_needed_signal);
				_loc2_.push(_loc4_.neighbor_user_id);
				_loc6_++;
			}
			this.addGeneralBragg();
			if (Config.OUTSIDE_FACEBOOK_MODE) {
				(_loc8_ = FriendsCollection.smFriends).AddToScreen();
			}
			MissionManager.increaseCounter("Neighbors", null, 1);
		}

		private function addGeneralBragg(): void {
			var _loc1_: int = RankManager.getRankCount() - 2;
			var _loc2_: int = 20;
			var _loc3_: int = int((mConfig.Levels[_loc2_] as Object).XPLimit);
			FriendsCollection.smFriends.AddFriend(GENERAL_BRAGG_ID, GENERAL_BRAGG_ID, _loc3_, _loc2_, _loc1_, 50, false, null, "Home", false, true, true);
			var _loc4_: Friend;
			(_loc4_ = FriendsCollection.smFriends.GetFriend(GENERAL_BRAGG_ID)).mName = getText("CHAR_MUTTON");
			_loc4_.mPicID = Config.DIR_DATA + "icons/braggs_avatar.png";
		}

		private function centerToNewestFlare(): void {
			var _loc1_: SignalObject = null;
			var _loc3_: Renderable = null;
			var _loc2_: int = 0;
			var _loc4_: int = int(this.mScene.mAllElements.length);
			var _loc5_: int = 0;
			while (_loc5_ < _loc4_) {
				_loc3_ = this.mScene.mAllElements[_loc5_] as Renderable;
				if (_loc3_) {
					if (_loc3_ is SignalObject) {
						if (SignalObject(_loc3_).mTimer > _loc2_) {
							_loc2_ = SignalObject(_loc3_).mTimer;
							_loc1_ = SignalObject(_loc3_);
						}
					}
				}
				_loc5_++;
			}
			if (_loc1_) {
				this.moveCameraToSeeRenderable(_loc1_, true, true);
			}
		}

		private function handleNeighborData(param1: ServerCall): void {
			this.changeState(STATE_VISITING_NEIGHBOUR);
			this.mScene.reCalculateCameraMargins();
			this.initMap(param1);
			this.initObjects(param1);
			if (Config.USE_WORLD_MAP) {
				this.mHUD.updateMapButtonEnablation();
			}
			this.mPlayerProfile.setNeighborActions(param1.mData.neighbor_actions_left);
			this.updateGrid();
			this.mScene.mFog.init();
			if (param1.mData.neighbor_visits_increased > 0) {
				MissionManager.increaseCounter("Visit", null, 1);
			}
			this.stopLoading();
			if (param1.mData.neighbor_actions_left > 0) {
				this.mScene.mMapGUIEffectsLayer.highlightNeighbourClickables();
			}
			if (param1.mData.grant_daily_bonus == "true") {
				this.mHUD.openVisitingRewardTextBox();
				this.addVisitNeighborRewards();
			}
			this.centerToNewestFlare();
		}

		private function handleTutorData(param1: ServerCall): void {
			this.changeState(STATE_VISITING_NEIGHBOUR);
			this.mScene.reCalculateCameraMargins();
			this.initMap(param1);
			this.initObjects(param1);
			if (Config.USE_WORLD_MAP) {
				this.mHUD.updateMapButtonEnablation();
			}
			this.mPlayerProfile.setNeighborActions(param1.mData.neighbor_actions_left);
			this.updateGrid();
			this.mScene.mFog.init();
			EnvEffectManager.init();
			if (param1.mData.neighbor_visits_increased > 0) {
				MissionManager.increaseCounter("Visit", null, 1);
			}
			this.stopLoading();
			if (param1.mData.neighbor_actions_left > 0) {
				this.mScene.mMapGUIEffectsLayer.highlightNeighbourClickables();
			}
			if (param1.mData.grant_daily_bonus == "true") {
				this.mHUD.openVisitingRewardTextBox();
				this.addVisitNeighborRewards();
			}
			if (this.mShowBraggsFrontWelcome) {
				this.mHUD.openWelcomeBraggsFrontWindow();
				this.mShowBraggsFrontWelcome = false;
			}
		}

		private function addVisitNeighborRewards(): void {
			var _loc1_: Object = GameState.mConfig.VisitAllyReward["0"];
			var _loc2_: Item = ItemManager.getItem("Energy", "Resource");
			this.mPlayerProfile.addItem(_loc2_, _loc1_.AmountEnergy);
			_loc2_ = ItemManager.getItem("SocialXP", "Resource");
			this.mPlayerProfile.addItem(_loc2_, _loc1_.AmountSocialXP);
			_loc2_ = ItemManager.getItem(_loc1_.Item.ID, _loc1_.Item.Type);
			this.mPlayerProfile.addItem(_loc2_, _loc1_.ItemAmount);
		}

		private function handleMapData(param1: ServerCall): void {
			this.initMap(param1);
			this.initObjects(param1);
			MissionManager.initialize();
			MissionManager.setupFromServer(param1);
			MissionManager.findNewActiveMissions();
			this.updateGrid();
			this.addNeighborAvatars();
			this.mScene.mFog.init();
			EnvEffectManager.init();
			this.changeState(STATE_PLAY);
			this.setCameraToStartingPosition(true);
			this.stopLoading();
		}

		public function moveCameraToSeeCell(param1: GridCell): void {}

		public function moveCameraToSeeRenderable(param1: Renderable, param2: Boolean = false, param3: Boolean = false): void {
			var _loc10_: Number = NaN;
			var _loc11_: Number = NaN;
			var _loc12_: Number = NaN;
			var _loc13_: Number = NaN;
			var _loc14_: Number = NaN;
			var _loc15_: Number = NaN;
		}

		public function activatePlayerUnit(param1: PlayerUnit): void {
			if (this.mCurrentAction) {
				return;
			}
			this.mActivatedPlayerUnit = param1;
			this.mActivatedPlayerUnit.setSelected();
			this.updateWalkableCellsForActiveCharacter();
			this.moveCameraToSeeRenderable(param1);
		}

		public function unActivatePlayerUnit(): void {
			if (this.mActivatedPlayerUnit) {
				this.mActivatedPlayerUnit = null;
				this.updateWalkableCellsForActiveCharacter();
			}
		}

		public function executeRefillEnergy(): void {
			var _loc1_: int = this.mPlayerProfile.mMaxEnergy;
			this.mPlayerProfile.setEnergy(_loc1_);
		}

		public function executeSellObject(param1: Renderable): void {
			ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_SELL_ITEM);
			var _loc2_: MapItem = MapItem(param1.mItem);
			if (param1 is HFEObject) {
				_loc2_ = ItemManager.getItem("Plot", "HFEPlot") as MapItem;
			}
			var _loc3_: int = _loc2_.mDisbandRewardMoney;
			var _loc4_: GridCell = param1.getCell();
			this.mScene.addLootReward(ItemManager.getItem("Money", "Resource"), _loc3_, param1.getContainer());
			this.mScene.removeObject(param1);
			if (param1 is ConstructionObject) {
				this.mPlayerProfile.updateUnitCaps();
			} else if (param1 is PlayerUnit) {
				this.mPlayerProfile.updateUnitCaps();
				this.mPlayerProfile.removeUnit(param1.mItem as PlayerUnitItem);
			} else if (param1 is DecorationObject) {
				this.mPlayerProfile.decreaseSuppliesCap(param1);
			}
			var _loc5_: Object = {
				"coord_x": _loc4_.mPosI,
				"coord_y": _loc4_.mPosJ,
				"reward_money": _loc3_
			};
			this.mServer.serverCallServiceWithParameters(ServiceIDs.SELL_ITEM, _loc5_, false);
			MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_ECONOMY, MagicBoxTracker.TYPE_GAME_ACTION, MagicBoxTracker.LABEL_TOOL_SELL_ITEM, MagicBoxTracker.paramsObj(param1.mItem.mType, param1.mItem.mId));
			if (Config.DEBUG_MODE) {}
		}

		public function executeCompleteConstructionWithPremium(param1: ConstructionObject): void {
			var _loc9_: ShopItem = null;
			var _loc10_: int = 0;
			var _loc12_: AskPartsDialogSmall = null;
			var _loc13_: AskPartsDialogBig = null;
			var _loc14_: Object = null;
			this.mConstruction = param1;
			var _loc2_: ConstructionItem = param1.mItem as ConstructionItem;
			var _loc3_: Inventory = this.mPlayerProfile.mInventory;
			var _loc4_: Array = _loc2_.mIngredientRequiredTypes;
			var _loc5_: Array = _loc2_.mIngredientRequiredAmounts;
			var _loc6_: * = "";
			var _loc7_: * = "";
			var _loc8_: int = 0;
			var _loc11_: int = 0;
			while (_loc11_ < _loc4_.length) {
				_loc9_ = ItemManager.getItem(_loc4_[_loc11_].ID, _loc4_[_loc11_].Type) as ShopItem;
				_loc10_ = _loc5_[_loc11_] - param1.getItemCount()[_loc11_];
				_loc8_ += _loc9_.getCostPremium() * _loc10_;
				if (_loc10_ > 0) {
					_loc6_ += _loc9_.mId;
					_loc7_ += _loc10_.toString();
					if (_loc11_ < _loc4_.length - 1) {
						_loc6_ += ",";
						_loc7_ += ",";
					}
				}
				_loc11_++;
			}
			if (this.mPlayerProfile.mPremium < _loc8_) {
				this.mHUD.openBuyGoldScreen();
				if (_loc4_.length <= 3) {
					if (PopUpManager.isPopUpCreated(AskPartsDialogSmall)) {
						(_loc12_ = PopUpManager.getPopUp(AskPartsDialogSmall) as AskPartsDialogSmall).closeDialog();
					}
				} else if (PopUpManager.isPopUpCreated(AskPartsDialogBig)) {
					(_loc13_ = PopUpManager.getPopUp(AskPartsDialogBig) as AskPartsDialogBig).closeDialog();
				}
			} else {
				_loc11_ = 0;
				while (_loc11_ < _loc4_.length) {
					_loc9_ = ItemManager.getItem(_loc4_[_loc11_].ID, _loc4_[_loc11_].Type) as ShopItem;
					_loc10_ = _loc5_[_loc11_] - param1.getItemCount()[_loc11_];
					_loc3_.addItems(_loc9_, _loc10_);
					_loc11_++;
				}
				this.mPlayerProfile.addPremium(-_loc8_, MagicBoxTracker.LABEL_BUY_INGREDIENTS, MagicBoxTracker.paramsObj(param1.mItem.mType, param1.mItem.mId));
				_loc14_ = {
					"ingredients": _loc6_,
					"amounts": _loc7_,
					"cost_premium": _loc8_
				};
				this.mServer.serverCallServiceWithParameters(ServiceIDs.BUY_INGREDIENTS, _loc14_, false);
				if (Config.DEBUG_MODE) {}
				if (Config.OFFLINE_MODE) {
					this.handleBuyIngredientsData(null);
				}
			}
		}

		public function executeUnlockObjectiveWithPremium(param1: Objective): void {
			var _loc3_: MissionProgressWindow = null;
			var _loc4_: MissionStackWindow = null;
			this.mPlayerProfile.addPremium(-param1.mCostFinish, MagicBoxTracker.LABEL_BUY_UNLOCK_MISSION_OBJECTIVE, MagicBoxTracker.paramsObj(param1.mType, param1.mId));
			var _loc2_: Object = {
				"mission_objective_id": param1.mId,
				"cost_premium": param1.mCostFinish,
				"map_id": param1.mMapId
			};
			this.mServer.serverCallServiceWithParameters(ServiceIDs.UNLOCK_MISSION_OBJECTIVE, _loc2_, false);
			if (Config.DEBUG_MODE) {}
			MissionManager.buyObjective(param1);
			if (PopUpManager.isPopUpCreated(MissionProgressWindow)) {
				_loc3_ = PopUpManager.getPopUp(MissionProgressWindow) as MissionProgressWindow;
				_loc3_.updateObjectives();
			}
			if (PopUpManager.isPopUpCreated(MissionStackWindow)) {
				(_loc4_ = PopUpManager.getPopUp(MissionStackWindow) as MissionStackWindow).updateObjectives();
			}
		}

		public function executeUpdateWishlist(param1: Wishlist): void {
			var _loc3_: Item = null;
			var _loc2_: Array = new Array();
			var _loc4_: int = int(param1.mItems.length);
			var _loc5_: int = 0;
			while (_loc5_ < _loc4_) {
				_loc3_ = param1.mItems[_loc5_] as Item;
				_loc2_.push({
					"item_id": _loc3_.mId,
					"item_type": ItemManager.getTableNameForItem(_loc3_)
				});
				_loc5_++;
			}
			var _loc6_: String = JSONWrapper.encode(_loc2_);
			var _loc7_: Object = {
				"wishlist": _loc6_
			};
			this.mServer.serverCallServiceWithParameters(ServiceIDs.SET_WISHLIST, _loc7_, false);
			if (Config.DEBUG_MODE) {}
		}

		public function reduceEnergy(param1: String, param2: int, param3: Object = null): void {
			var _loc5_: Object = null;
			var _loc4_: GamePlayerProfile;
			(_loc4_ = this.mPlayerProfile).addEnergy(-param2);
			if (param1 != "RepairPlayerUnitAction") {
				if (param1 != "RepairPlayerInstallationAction") {
					if (param1 != "RepairDecorationAction") {
						if (param1 != "RepairConstructionAction") {
							if (param1 != "HarvestProductionAction") {
								this.mScene.reduceEnemyUnitQueueNumber();
							}
						}
					}
				}
			}
			MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_ECONOMY, MagicBoxTracker.TYPE_SPEND_ENERGY, "" + param1, param3);
		}

		public function reduceMapResource(param1: int): void {
			if (this.mMapData.mMapSetupData.Resource) {
				this.mPlayerProfile.addMapResource(-param1);
			}
		}

		public function externalCallBuyFacebookCredits(): void {
			this.buyFacebookCreditsCallback("settled");
		}

		public function buyFacebookCreditsCallback(param1: String): void {
			if (Config.DEBUG_MODE) {}
			if (param1 == "settled") {
				this.mServer.serverCallServiceWithParameters(ServiceIDs.GET_GOLD_AND_CASH, {
					"ver": 1
				}, false);
				if (Config.DEBUG_MODE) {}
			}
		}

		public function buyFacebookCreditsError(param1: int): void {
			if (Config.DEBUG_MODE) {}
			this.mServer.serverCallServiceWithParameters(ServiceIDs.GET_GOLD_AND_CASH, {
				"ver": 1
			}, false);
			if (param1 != FB_ERROR_CODE_USER_CANCELED) {}
		}

		public function externalCallBuyMoney(param1: Object): void {
			this.mPricePoint = param1;
			if (this.mPlayerProfile.getPremium() >= this.mPricePoint.FBCreditPriceRef.CreditsCostNew) {
				this.buyMoneyCallback("123", "settled");
				return;
			}
			GameState.mInstance.mHUD.openBuyGoldScreen();
		}

		public function buyMoneyCallback(param1: String, param2: String): void {
			var _loc3_: ShopDialog = null;
			if (Config.DEBUG_MODE) {}
			if (param2 == "settled") {
				this.mPlayerProfile.addMoney(this.mPricePoint.FBCreditPriceRef.Amount, "buyMoneyCallback()");
				this.mPlayerProfile.addPremium(-this.mPricePoint.FBCreditPriceRef.CreditsCostNew, MagicBoxTracker.LABEL_BUY_ITEM, MagicBoxTracker.paramsObj(param1));
				if (PopUpManager.isPopUpCreated(ShopDialog)) {
					_loc3_ = PopUpManager.getPopUp(ShopDialog) as ShopDialog;
					_loc3_.setScreen();
				}
			}
		}

		public function buyMoneyError(param1: int): void {
			if (Config.DEBUG_MODE) {}
			if (param1 != FB_ERROR_CODE_USER_CANCELED) {}
		}

		public function externalCallBuyItem(param1: ShopItem): void {
			if (param1 is MapItem) {
				this.changeState(STATE_WAIT_FB_CALLBACK);
			}
			this.mPremiumItem = param1;
			var _loc2_: String = ItemManager.getTableNameForItem(param1) + "." + param1.mId;
			if (this.mPlayerProfile.getPremium() >= this.mPremiumItem.getCostPremium()) {
				this.buyItemCallback("123", "settled");
				return;
			}
			GameState.mInstance.mHUD.openBuyGoldScreen();
		}

		public function buyItemCallback(param1: String, param2: String): void {
			if (Config.DEBUG_MODE) {}
			if (param2 == "settled") {
				if (this.mPremiumItem is MapItem) {
					this.mScene.placeObjectBeingMoved();
				} else {
					this.executeBuyItem(this.mPremiumItem);
				}
				if (PopUpManager.isPopUpCreated(FireMissionDialog)) {
					FireMissionDialog(PopUpManager.getPopUp(FireMissionDialog)).refresh(false);
				}
				if (PopUpManager.isPopUpCreated(InventoryDialog)) {
					InventoryDialog(PopUpManager.getPopUp(InventoryDialog)).refresh();
				}
			} else if (this.mPremiumItem is MapItem) {
				this.cancelDecoPurchase();
				this.mHUD.showCancelButton(false);
			}
		}

		public function buyItemError(param1: int): void {
			if (Config.DEBUG_MODE) {}
			if (param1 != FB_ERROR_CODE_USER_CANCELED) {}
			if (this.mPremiumItem is MapItem) {
				this.cancelDecoPurchase();
				this.mHUD.showCancelButton(false);
			}
		}

		public function externalCallBuyUnlock(param1: ShopItem): void {
			this.mPremiumItem = param1;
			var _loc2_: String = ItemManager.getTableNameForItem(param1) + "." + param1.mId;
			if (this.mPlayerProfile.getPremium() >= this.mPremiumItem.getUnlockCost()) {
				this.buyUnlockCallback("123", "settled");
				return;
			}
			GameState.mInstance.mHUD.openBuyGoldScreen();
		}

		public function buyUnlockCallback(param1: String, param2: String): void {
			var _loc3_: ShopDialog = null;
			if (Config.DEBUG_MODE) {}
			if (param2 == "settled") {
				this.executeBuyEarlyUnlock(this.mPremiumItem);
				if (PopUpManager.isPopUpCreated(ShopDialog)) {
					_loc3_ = PopUpManager.getPopUp(ShopDialog) as ShopDialog;
					_loc3_.refresh();
				}
				if (PopUpManager.isPopUpCreated(ProductionDialog)) {
					ProductionDialog(PopUpManager.getPopUp(ProductionDialog)).refresh();
				}
			}
		}

		public function buyUnlockError(param1: int): void {
			if (Config.DEBUG_MODE) {}
			if (param1 != FB_ERROR_CODE_USER_CANCELED) {}
		}

		public function externalCallBuyIngredients(param1: ConstructionObject): void {
			var _loc9_: Object = null;
			var _loc10_: ShopItem = null;
			var _loc11_: String = null;
			var _loc12_: int = 0;
			this.mConstruction = param1;
			var _loc2_: ConstructionItem = param1.mItem as ConstructionItem;
			var _loc3_: Inventory = this.mPlayerProfile.mInventory;
			var _loc4_: Array = _loc2_.mIngredientRequiredTypes;
			var _loc5_: Array = _loc2_.mIngredientRequiredAmounts;
			var _loc6_: Array = new Array();
			var _loc7_: int = 0;
			while (_loc7_ < _loc4_.length) {
				_loc9_ = _loc4_[_loc7_] as Object;
				_loc10_ = ItemManager.getItem(_loc9_.ID, _loc9_.Type) as ShopItem;
				_loc11_ = ItemManager.getTableNameForItem(_loc10_) + "." + _loc10_.mId;
				if ((_loc12_ = _loc5_[_loc7_] - param1.getItemCount()[_loc7_]) > 0) {
					_loc6_.push({
						"id": _loc11_,
						"amount": _loc12_
					});
				}
				_loc7_++;
			}
			var _loc8_: String = JSONWrapper.encode(_loc6_);
			this.buyIngredientsCallback("123", "settled");
		}

		public function buyIngredientsCallback(param1: String, param2: String): void {
			if (Config.DEBUG_MODE) {}
			if (param2 == "settled") {
				this.executeCompleteConstructionWithPremium(this.mConstruction);
			}
		}

		public function buyIngredientsError(param1: int): void {
			if (Config.DEBUG_MODE) {}
			if (param1 != FB_ERROR_CODE_USER_CANCELED) {}
		}

		public function externalCallUnlockObjective(param1: Objective): void {
			this.mObjective = param1;
			if (this.mPlayerProfile.getPremium() >= this.mObjective.mCostFinish) {
				this.unlockObjectiveCallback("123", "settled");
				return;
			}
			GameState.mInstance.mHUD.openBuyGoldScreen();
		}

		public function unlockObjectiveCallback(param1: String, param2: String): void {
			if (Config.DEBUG_MODE) {}
			if (param2 == "settled") {
				this.executeUnlockObjectiveWithPremium(this.mObjective);
			}
		}

		public function unlockObjectiveError(param1: int): void {
			if (Config.DEBUG_MODE) {}
			if (param1 != FB_ERROR_CODE_USER_CANCELED) {}
		}

		public function newNeighborAcceptedCallback(): void {
			if (Config.DEBUG_MODE) {}
			this.mServer.serverCallService(ServiceIDs.GET_USER_DATA, false);
			this.mServer.serverCallService(ServiceIDs.GET_NEIGHBORS, false);
		}

		public function newGiftAcceptedCallback(): void {
			if (Config.DEBUG_MODE) {}
			this.mServer.serverCallService(ServiceIDs.GET_INVENTORY, false);
		}

		public function visitingFriend(): Boolean {
			return this.mVisitingFriend != null;
		}

		public function visitingTutor(): Boolean {
			return this.mVisitingFriend != null && this.mVisitingFriend.mIsTutor;
		}

		public function externalCallSendWishlistItem(param1: Friend, param2: Item): void {
			var _loc3_: String = null;
			var _loc4_: Object = null;
			this.mWishlistItem = param2;
			for each(_loc4_ in mConfig.Gift) {
				if (_loc4_.Item) {
					if (_loc4_.Item.ID == this.mWishlistItem.mId) {
						_loc3_ = String(_loc4_.ID);
						break;
					}
				}
			}
			if (!_loc3_) {
				if (Config.DEBUG_MODE) {}
			}
		}

		public function externalCallSendFrictionless(param1: Friend, param2: String): void {
			var _loc4_: Object = null;
			var _loc3_: String = null;
			for each(_loc4_ in mConfig.Gift) {
				if (_loc4_.ID == param2) {
					_loc3_ = String(_loc4_.ID);
					break;
				}
			}
			this.mFrictionlessFriend = param1;
			this.mFrictionlessGiftID = _loc3_;
			WebUtils.externalInterfaceCallWrapper("charlieFunctions.launchGiftPage", this.mFrictionlessGiftID, "", this.mServer.getUid(), "vir_gift_sent_frictionless", this.mFrictionlessFriend.mUserID, null, 0);
		}

		public function sendGiftCallback(): void {
			if (Config.DEBUG_MODE) {}
			this.mPlayerProfile.addItem(this.mWishlistItem, -1);
		}

		public function sendGiftError(): void {
			if (Config.DEBUG_MODE) {}
		}

		public function frictionlessCallback(): void {
			if (Config.DEBUG_MODE) {}
			if (this.mFrictionlessFriend) {
				if (this.mFrictionlessGiftID) {
					this.mPlayerProfile.addToRecentlyGifted(this.mFrictionlessFriend.mFacebookID, this.mFrictionlessGiftID);
					this.mFrictionlessFriend = null;
					this.mFrictionlessGiftID = null;
				}
			}
		}

		public function frictionlessError(): void {
			if (Config.DEBUG_MODE) {}
			this.mFrictionlessFriend = null;
			this.mFrictionlessGiftID = null;
		}

		public function getUserStateSummary(): String {
			var _loc3_: String = null;
			var _loc1_: String = "State: " + this.mState;
			if (this.mItemToBePlaced) {
				_loc1_ += ", mItemToBePlaced " + this.mItemToBePlaced;
			}
			if (this.mObjectToBePlaced) {
				_loc1_ += ", mObjectToBePlaced " + this.mObjectToBePlaced.mItem.mId;
			}
			if (this.mCurrentAction) {
				_loc1_ += ", mCurrentAction " + this.mCurrentAction.mName;
			}
			var _loc2_: Array = PopUpManager.getPopups();
			var _loc4_: int = int(_loc2_.length);
			var _loc5_: int = 0;
			while (_loc5_ < _loc4_) {
				_loc3_ = _loc2_[_loc5_] as String;
				if (_loc2_[_loc3_]) {
					_loc1_ += ", Popup open:" + _loc3_;
				}
				_loc5_++;
			}
			return _loc1_;
		}

		public function getSpawnEnemyTimer(): int {
			return this.mSpawnEnemyTimer;
		}

		public function restoreFogOfWar(param1: Boolean): void {
			this.mFogOfWarOn = param1;
		}

		public function setFogOfWarOn(param1: Boolean): void {
			this.mFogOfWarOn = param1;
			// Doin- a little challenge: most inefficient way to reload the game lmao
		}

		public function isFogOfWarOn(): Boolean {
			return this.mFogOfWarOn;
		}

		public function setAnimations(param1: Boolean): void {
			this.mAnimationsOn = param1;
			Cookie.saveCookieVariable(Config.COOKIE_SETTINGS_NAME, Config.COOKIE_SETTINGS_NAME_ANIMATION, param1);
			// We're doing the same challenge as above xD
			// Need to look for a better way
			var savedata: * = this.mHUD.generateSaveJson();
			(PopUpManager.getPopUp(PauseDialog) as PauseDialog).loadProgress(savedata);
			(PopUpManager.getPopUp(SettingsDialogClass) as SettingsDialogClass).closeSettingsAuto();
			(PopUpManager.getPopUp(PauseDialog) as PauseDialog).closePauseMenuAuto();
			this.mScene.mCamera.moveTo(this.mScene.mCamera.getCameraX() + 1, this.mScene.mCamera.getCameraY() + 1);
		}

		public function isAnimationsOn(): Boolean {
			return this.mAnimationsOn;
		}
	}
}