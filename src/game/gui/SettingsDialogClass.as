package game.gui {
	import com.dchoc.GUI.DCButton;
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.gui.button.ArmyButton;
	import game.gui.popups.PopUpWindow;
	import game.sound.ArmySoundManager;
	import game.states.GameState;

	public class SettingsDialogClass extends PopUpWindow {


		private var mButtonSettingMusicOn: ArmyButton;

		private var mButtonSettingMusicOff: ArmyButton;

		private var mButtonSettingSoundOn: ArmyButton;

		private var mButtonSettingSoundOff: ArmyButton;

		private var mButtonEditNotificationOn: ArmyButton;

		private var mButtonEditNotificationOff: ArmyButton;

		private var mButtonAnimationOn: ArmyButton;

		private var mButtonAnimationOff: ArmyButton;

		private var mButtonBack: ArmyButton;

		private var mButtonTutorial: ArmyButton;

		private var settingsHeader: TextField;

		private var musicTitle: TextField;

		private var sfxTitle: TextField;

		private var notificationTitle: TextField;

		private var animationsTitle: TextField;

		private var userIdTitle: TextField;

		private var userIdText: TextField;

		public function SettingsDialogClass() {
			var _loc2_: ArmySoundManager = null;
			var _loc3_: TextField = null;
			var _loc4_: TextField = null;
			var _loc1_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_MAIN_MENU_NAME, "SettingsDialog");
			super(new _loc1_());
			if (PauseDialog.mPauseScreenState == PauseDialog.STATE_SETTINGS_CLICK) {
				this.mButtonSettingMusicOn = addButton(mClip, "Button_music_on", this.tabPressed);
				this.mButtonSettingMusicOff = addButton(mClip, "Button_music_off", this.tabPressed);
				this.mButtonSettingMusicOff.setX(this.mButtonSettingMusicOn.getX());
				this.mButtonSettingMusicOff.setY(this.mButtonSettingMusicOn.getY());
				this.mButtonSettingSoundOn = addButton(mClip, "Button_sfx_on", this.tabPressed);
				this.mButtonSettingSoundOff = addButton(mClip, "Button_sfx_off", this.tabPressed);
				this.mButtonSettingSoundOff.setX(this.mButtonSettingSoundOn.getX());
				this.mButtonSettingSoundOff.setY(this.mButtonSettingSoundOn.getY());
				_loc2_ = ArmySoundManager.getInstance();
				this.mButtonSettingMusicOn.setVisible(_loc2_.isMusicOn());
				this.mButtonSettingMusicOff.setVisible(!_loc2_.isMusicOn());
				this.mButtonSettingSoundOn.setVisible(_loc2_.isSfxOn());
				this.mButtonSettingSoundOff.setVisible(!_loc2_.isSfxOn());
				this.mButtonEditNotificationOn = addButton(mClip, "Button_notification_on", this.tabPressed);
				this.mButtonEditNotificationOff = addButton(mClip, "Button_notification_off", this.tabPressed);
				this.mButtonEditNotificationOff.setX(this.mButtonEditNotificationOn.getX());
				this.mButtonEditNotificationOff.setY(this.mButtonEditNotificationOn.getY());
				this.mButtonEditNotificationOn.setVisible(!GameState.mInstance.isFogOfWarOn());
				this.mButtonEditNotificationOff.setVisible(GameState.mInstance.isFogOfWarOn());

				this.mButtonAnimationOn = addButton(mClip, "Button_animation_on", this.tabPressed);
				this.mButtonAnimationOff = addButton(mClip, "Button_animation_off", this.tabPressed);
				this.mButtonAnimationOff.setX(this.mButtonAnimationOn.getX());
				this.mButtonAnimationOff.setY(this.mButtonAnimationOn.getY());
				this.mButtonAnimationOn.setVisible(GameState.mInstance.isAnimationsOn());
				this.mButtonAnimationOff.setVisible(!GameState.mInstance.isAnimationsOn());

				this.mButtonBack = addButton(mClip, "Button_back", this.tabPressed);
				this.mButtonBack.setVisible(true);

				this.mButtonTutorial = addButton(mClip, "Button_tutorial", this.tabPressed);
				this.mButtonTutorial.setVisible(true);

				this.mButtonSettingMusicOn.setText(GameState.getText("BUTTON_ON_TEXT"), "Text_Title");
				this.mButtonSettingMusicOff.setText(GameState.getText("BUTTON_OFF_TEXT"), "Text_Title");
				this.mButtonSettingSoundOn.setText(GameState.getText("BUTTON_ON_TEXT"), "Text_Title");
				this.mButtonSettingSoundOff.setText(GameState.getText("BUTTON_OFF_TEXT"), "Text_Title");
				this.mButtonEditNotificationOn.setText(GameState.getText("BUTTON_ON_TEXT"), "Text_Title");
				this.mButtonEditNotificationOff.setText(GameState.getText("BUTTON_OFF_TEXT"), "Text_Title");
				this.mButtonBack.setText(GameState.getText("BACK_BUTTON_TEXT"), "Text_Title");
				this.settingsHeader = mClip.getChildByName("Text_Title") as TextField;
				this.settingsHeader.text = GameState.getText("SETTINGS_HEADER_TEXT");
				_loc3_ = mClip.getChildByName("Text_Background_01") as TextField;
				_loc4_ = mClip.getChildByName("Text_Background_02") as TextField;
				if (_loc3_) {
					_loc3_.text = this.settingsHeader.text;
				}
				if (_loc4_) {
					_loc4_.text = this.settingsHeader.text;
				}
				this.musicTitle = (mClip.getChildByName("Button_music") as DisplayObjectContainer).getChildByName("Button_music_text") as TextField;
				this.musicTitle.text = GameState.getText("MUSIC_TITLE_TEXT");
				this.sfxTitle = (mClip.getChildByName("Button_sfx") as DisplayObjectContainer).getChildByName("Button_sfx_text") as TextField;
				this.sfxTitle.text = GameState.getText("SFX_TITLE_TEXT");
				this.notificationTitle = (mClip.getChildByName("Notifications") as DisplayObjectContainer).getChildByName("Button_notifications_text") as TextField;
				this.notificationTitle.text = GameState.getText("NOTIFICATIONS_TITLE_TEXT");

				this.animationsTitle = (mClip.getChildByName("Animations") as DisplayObjectContainer).getChildByName("Button_animations_text") as TextField;
				this.animationsTitle.text = GameState.getText("ANIMATIONS_TITLE_TEXT");

				this.userIdTitle = (mClip.getChildByName("UserID") as DisplayObjectContainer).getChildByName("Button_UserID_text") as TextField;
				this.userIdTitle.text = GameState.getText("USER_ID_TITLE");
				this.userIdTitle = (mClip.getChildByName("UserID_textfield") as DisplayObjectContainer).getChildByName("UserID_text") as TextField;
				this.userIdTitle.text = "Offline";
			}
		}

		private static function addButton(param1: MovieClip, param2: String, param3: Function): ArmyButton {
			var _loc4_: MovieClip;
			if ((_loc4_ = param1.getChildByName(param2) as MovieClip) != null) {
				_loc4_.mouseEnabled = true;
				return new ArmyButton(param1, _loc4_, DCButton.BUTTON_TYPE_ICON, null, null, null, null, null, param3);
			}
			param3 = null;
			return null;
		}

		public function closeSettingsAuto(): void {
			this.mDoneCallback((this as Object).constructor);
			PauseDialog.mPauseScreenPreviousState = PauseDialog.STATE_SETTINGS_CLICK;
			GameState.mInstance.mHUD.openPauseScreen();
		}

		public function Activate(param1: Function): void {
			mDoneCallback = param1;
			doOpeningTransition();
		}

		private function tabPressed(param1: MouseEvent): void {
			var _loc2_: ArmySoundManager = ArmySoundManager.getInstance();
			if (ArmySoundManager.getInstance().isSfxOn()) {
				ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_CLICK);
			}
			if (param1.target == this.mButtonEditNotificationOn.getMovieClip() || param1.target == this.mButtonEditNotificationOff.getMovieClip()) {
				GameState.mInstance.setFogOfWarOn(!GameState.mInstance.isFogOfWarOn());
				this.updateToggleButtonStates();
				param1.stopPropagation();
			} else if (param1.target == this.mButtonBack.getMovieClip()) {
				mDoneCallback((this as Object).constructor);
				PauseDialog.mPauseScreenPreviousState = PauseDialog.STATE_SETTINGS_CLICK;
				GameState.mInstance.mHUD.openPauseScreen();
			} else if (param1.target == this.mButtonTutorial.getMovieClip()) {
				GameState.mInstance.mHUD.openRestartTutorialConfirmationTextBox();
			} else if (param1.target == this.mButtonSettingMusicOn.getMovieClip() || param1.target == this.mButtonSettingMusicOff.getMovieClip()) {
				_loc2_.setMusicOn(!_loc2_.isMusicOn());
				if (_loc2_.isMusicOn()) {
					GameState.mInstance.startMusic();
				} else {
					GameState.mInstance.mCurrentMusic = null;
				}
				this.updateToggleButtonStates();
				param1.stopPropagation();
			} else if (param1.target == this.mButtonSettingSoundOn.getMovieClip() || param1.target == this.mButtonSettingSoundOff.getMovieClip()) {
				_loc2_.setSfxOn(!_loc2_.isSfxOn());
				this.updateToggleButtonStates();
				param1.stopPropagation();
			} else if (param1.target == this.mButtonAnimationOn.getMovieClip() || param1.target == this.mButtonAnimationOff.getMovieClip()) {
				GameState.mInstance.setAnimations(!GameState.mInstance.isAnimationsOn());
				this.updateToggleButtonStates();
				param1.stopPropagation();
			}
		}

		public function updateToggleButtonStates(): void {
			var _loc1_: ArmySoundManager = ArmySoundManager.getInstance();
			this.mButtonSettingMusicOn.setVisible(_loc1_.isMusicOn());
			this.mButtonSettingMusicOff.setVisible(!_loc1_.isMusicOn());
			this.mButtonSettingSoundOn.setVisible(_loc1_.isSfxOn());
			this.mButtonSettingSoundOff.setVisible(!_loc1_.isSfxOn());
			this.mButtonEditNotificationOn.setVisible(!GameState.mInstance.isFogOfWarOn());
			this.mButtonEditNotificationOff.setVisible(GameState.mInstance.isFogOfWarOn());
			this.mButtonAnimationOn.setVisible(GameState.mInstance.isAnimationsOn());
			this.mButtonAnimationOff.setVisible(!GameState.mInstance.isAnimationsOn());
		}
	}
}