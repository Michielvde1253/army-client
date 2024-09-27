package game.gui {
	import com.dchoc.GUI.DCButton;
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.MovieClip;
	import flash.events.*;
	import game.gui.button.ArmyButton;
	import game.gui.popups.PopUpWindow;
	import game.magicBox.FlurryEvents;
	import game.missions.MissionManager;
	import game.net.ServerCall;
	import game.sound.ArmySoundManager;
	import game.states.GameState;
	import game.utils.OfflineSave;

	public class FirstTimeChooseDialog extends PopUpWindow {

		public static var mPauseScreenState: int;

		public static var mPauseScreenPreviousState: int;

		public static const STATE_IN_GAME: int = 0;

		public static const STATE_UNDEFINED: int = 1;

		public static const STATE_CONTINUE: int = 2;

		public static const STATE_HELP_CLICK: int = 3;

		public static const STATE_SETTINGS_CLICK: int = 4;


		private var mButtonOnlineNew: ArmyButton;

		private var mButtonOnlineResume: ArmyButton;

		private var mButtonOffline: ArmyButton;

		public function FirstTimeChooseDialog() {
			var _loc1_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_MAIN_MENU_NAME, "FirstTimeChooseMenu");
			super(new _loc1_(), false);
			this.mButtonOnlineNew = this.addButton(mClip, "Button_Online_New", this.tabPressed);
			this.mButtonOnlineNew.resizeNeeded = false;
			this.mButtonOnlineResume = this.addButton(mClip, "Button_Online_Resume", this.tabPressed);
			this.mButtonOnlineResume.resizeNeeded = false;
			this.mButtonOffline = this.addButton(mClip, "Button_Offline", this.tabPressed);
			this.mButtonOffline.resizeNeeded = false;
			this.mButtonOnlineNew.setText(GameState.getText("ONLINE_NEW_BUTTON_TEXT"), "Text_Title");
			this.mButtonOnlineResume.setText(GameState.getText("ONLINE_RESUME_BUTTON_TEXT"), "Text_Title");
			this.mButtonOffline.setText(GameState.getText("OFFLINE_BUTTON_TEXT"), "Text_Title");
		}

		public function Activate(param1: Function): void {
			mDoneCallback = param1;
			doOpeningTransition();
		}

		private function tabPressed(param1: MouseEvent): void {
			var fileRef: * = undefined;
			if (ArmySoundManager.getInstance().isSfxOn()) {
				ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_CLICK);
			}
			switch (param1.target) {
				case this.mButtonOnlineNew.getMovieClip():
					break;
				case this.mButtonOnlineResume.getMovieClip():
					break;
				case this.mButtonOffline.getMovieClip():
					mDoneCallback((this as Object).constructor);
					GameState.mInstance.mHUD.openPauseScreen()
					break;
			}
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

		public function closePauseMenuAuto(): void {
			GameHUD.isPauseButtonClicked = false;
			if (MissionManager.isTutorialCompleted()) {
				GameState.mInstance.changeState(GameState.STATE_PLAY);
			} else {
				ArmySoundManager.getInstance().stopSound(ArmySoundManager.MUSIC_HOME);
				GameState.mInstance.mHUD.openIntroTextBox();
			}
			mDoneCallback((this as Object).constructor);
		}
	}
}