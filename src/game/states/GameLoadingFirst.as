package game.states {
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.text.TextField;
	import game.gui.CursorManager;
	import game.net.GameFeedPublisher;
	import game.net.MyServer;
	import game.net.ServerCall;
	import game.net.ServiceIDs;
	import game.sound.ArmySoundManager;
	import com.dchoc.utils.Cookie;

	public class GameLoadingFirst extends LoadingFirst {

		public static var LoadingScreen: Class = background;


		private var mGameState: GameState;

		private var mFileCountToLoad: int;

		public function GameLoadingFirst(param1: StateMachine, param2: Stage, param3: FSMState, param4: GameState) {
			super(param1, param2, param3, new LoadingScreen());
			this.mGameState = param4;
		}

		override public function enter(): void {
			var _loc2_: String = null;
			var _loc3_: String = null;
			var _loc6_: String = null;
			super.enter();
			var _loc1_: DCResourceManager = DCResourceManager.getInstance();
			for each(_loc2_ in AssetManager.JSON_FILES_TO_LOAD) {
				_loc1_.load(Config.DIR_CONFIG + _loc2_ + ".json", _loc2_);
				mResourcesToLoad.push(_loc2_);
			}
			_loc3_ = "army_config_" + Config.smLanguageCode;
			_loc1_.load(Config.DIR_CONFIG + _loc3_ + ".json", _loc3_);
			mResourcesToLoad.push(_loc3_);

			_loc1_.load(Config.DIR_CONFIG + "army_config_pvp_opponents.json", "army_config_pvp_opponents");
			mResourcesToLoad.push("army_config_pvp_opponents");		
		
			if (FeatureTuner.LOAD_TILE_MAP_CSV) {
				for each(_loc6_ in AssetManager.CVS_FILES_TO_LOAD) {
					_loc1_.load(Config.DIR_CONFIG + _loc6_ + ".csv", _loc6_);
					mResourcesToLoad.push(_loc6_);
				}
			}
			ArmySoundManager.getInstance();
			ArmySoundManager.load();
			this.mFileCountToLoad = _loc1_.getFileCountToLoad();
			var _loc5_: TextField;
			var _loc4_: MovieClip;
			(_loc5_ = (_loc4_ = mLoadingClip.getChildByName("Fill_Bar") as MovieClip).getChildByName("Text_Description") as TextField).text = Config.smLoadingDescription;
			LocalizationUtils.replaceFont(_loc5_);
			if (Config.DEBUG_MODE) {
				mLoadingClip.addEventListener(MouseEvent.MOUSE_MOVE, toggleDescription);
				mLoadingClip.mouseEnabled = true;
				mLoadingClip.mouseChildren = true;
			}
		
			// Start camera at default position until save file is loaded
			Cookie.saveCookieVariable(Config.COOKIE_SESSION_NAME,Config.COOKIE_SESSION_NAME_CAM_POS + "_Home","");
		}

		override public function logicUpdate(param1: int): void {
			var _loc5_: int = 0;
			var _loc6_: Object = null;
			var _loc7_: MyServer = null;
			if (mPercent >= 100) {
				this.loadingFinished();
				return;
			}
			var _loc2_: DCResourceManager = DCResourceManager.getInstance();
			var _loc3_: int = _loc2_.getFileCountToLoad();
			var _loc4_: int = 100;
			if (this.mFileCountToLoad > 0) {
				_loc4_ = 100 - _loc3_ * 100 / this.mFileCountToLoad;
			}
			if (this.mGameState.mServer == null) {
				_loc5_ = 0;
				if (Config.isLoadingcomplete()) {
					this.mGameState.initServer();
					if (Config.CREATE_NEW_SESSION_IN_CLIENT) {
						this.mGameState.mServer.serverCallServiceWithParameters(ServiceIDs.CREATE_NEW_SESSION, {
							"ver": "0.0.1"
						}, true);
					}
					_loc6_ = {
						"map_id": "Home"
					};
					this.mGameState.mServer.serverCallServiceWithParameters(ServiceIDs.GET_USER_DATA, _loc6_, true);
					mServerResponsesNeeded.push(ServiceIDs.GET_USER_DATA);
				}
			} else if ((_loc7_ = this.mGameState.mServer).getNumberOfBlockingCalls() > 0 && !_loc7_.isConnectionError() && !_loc7_.isServerCommError()) {
				_loc5_ = 100 * (1 - _loc7_.getNumberOfBlockingCalls());
			} else {
				_loc5_ = 100;
			}
			setPercent((_loc4_ + _loc5_) / 2);
		}

		private function loadingFinished(): void {
			var _loc2_: Array = null;
			var _loc1_: ServerCall = this.mGameState.mServer.fetchResponseFromBuffer(ServiceIDs.GET_USER_DATA);
			mServerResponsesNeeded.length = 0;
			mResourcesToLoad.length = 0;
			this.mGameState.mCurrentMapId = "Home";
			this.mGameState.mCurrentMapGraphicsId = Math.max(GameState.GRAPHICS_MAP_ID_LIST.indexOf(this.mGameState.mCurrentMapId), 0);
			this.mGameState.loadingFirstFinished();
			GameFeedPublisher.init(_loc1_);
			this.mGameState.initPlayerProfile(_loc1_);
			this.mGameState.initTimers(_loc1_);
			if (_loc1_ != null) {
				_loc2_ = _loc1_.mData.gained_free_units as Array;
				this.mGameState.mShowFreeUnitsReceived = _loc2_ != null && _loc2_.length > 0;
			}
			goToNextState();
		}

		override protected function setLoadingBarPercent(param1: int): void {
			param1 = Math.max(0, param1);
			mLoadingFillBar.setValueWithoutBarAnimation(param1 * 90 / 100);
			var _loc2_: TextField = DisplayObjectContainer(mLoadingClip.getChildByName("Fill_Bar")).getChildByName("Progress") as TextField;
			_loc2_.text = int(param1 * 90 / 100) + "%";
		}

		override protected function initCursorManager(): void {
			var _loc1_: CursorManager = CursorManager.getInstance();
			_loc1_.init();
		}

		public function getLoadingPercent(): int {
			return mPercent;
		}
	}
}