package game.gui {
	import com.dchoc.GUI.DCButton;
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.MovieClip;
	import flash.events.*;
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
	}
	import game.gui.button.ArmyButton;
	import game.gui.popups.PopUpWindow;
	import game.magicBox.FlurryEvents;
	import game.missions.MissionManager;
	import game.net.ServerCall;
	import game.sound.ArmySoundManager;
	import game.states.GameState;
	import game.utils.OfflineSave;
	import com.dchoc.utils.Cookie;

	public class PauseDialog extends PopUpWindow {

		public static var mPauseScreenState: int;

		public static var mPauseScreenPreviousState: int;

		public static const STATE_IN_GAME: int = 0;

		public static const STATE_UNDEFINED: int = 1;

		public static const STATE_CONTINUE: int = 2;

		public static const STATE_HELP_CLICK: int = 3;

		public static const STATE_SETTINGS_CLICK: int = 4;


		private var mButtonPlay: ArmyButton;

		private var mButtonResume: ArmyButton;

		private var mButtonSettings: ArmyButton;

		private var mButtonHelp: ArmyButton;

		private var mButtonLoad: ArmyButton;

		CONFIG::NOT_BUILD_FOR_AIR {
			private var fileRef: FileReference;
		}

		public function PauseDialog() {
			var _loc1_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_MAIN_MENU_NAME, "MainMenu");
			super(new _loc1_(), false);
			if (mPauseScreenState == STATE_CONTINUE) {
				this.mButtonPlay = this.addButton(mClip, "Button_play", this.tabPressed);
				this.mButtonPlay.resizeNeeded = false;
				this.mButtonResume = this.addButton(mClip, "Button_resume", this.tabPressed);
				this.mButtonResume.resizeNeeded = false;
				this.mButtonSettings = this.addButton(mClip, "Button_settings", this.tabPressed);
				this.mButtonSettings.resizeNeeded = false;
				this.mButtonHelp = this.addButton(mClip, "Button_how_to_play", this.tabPressed);
				this.mButtonHelp.resizeNeeded = false;
				this.mButtonLoad = this.addButton(mClip, "Button_loadsave", this.tabPressed);
				this.mButtonLoad.resizeNeeded = false;
				this.mButtonPlay.setText(GameState.getText("PLAY_BUTTON_TEXT"), "Text_Title");
				this.mButtonResume.setText(GameState.getText("RESUME_BUTTON_TEXT"), "Text_Title");
				this.mButtonSettings.setText(GameState.getText("SETTINGS_BUTTON_TEXT"), "Text_Title");
				this.mButtonHelp.setText(GameState.getText("HELP_BUTTON_TEXT"), "Text_Title");
				this.mButtonLoad.setText(GameState.getText("LOAD_BUTTON_TEXT"), "Text_Title");
				this.updatePlayResumeButton();

				//var nativeAlert:NativeAlert = new NativeAlert();
				//nativeAlert.alert("Hello there!");

				// MOBILE: we do not support loading external files and instead use the default save file.
				CONFIG::BUILD_FOR_MOBILE_AIR {
					this.mButtonLoad.setVisible(false);
				}
			}
		}

		public function Activate(param1: Function): void {
			mDoneCallback = param1;
			doOpeningTransition();
		}

		CONFIG::BUILD_FOR_MOBILE_AIR {
			override public function scaleToScreen(): void {
				// Calculate the scaling factors based on the clip's dimensions
				var scaleXFactor: Number = GameState.mInstance.getStageWidth() / mClip.width;
				var scaleYFactor: Number = GameState.mInstance.getStageHeight() / mClip.height;

				// Add a small buffer to prevent rounding issues (adjust value if necessary)
				scaleXFactor += 0.05;
				scaleYFactor += 0.05;

				var scaleFactor: Number = Math.max(scaleXFactor, scaleYFactor)

				// Apply the scaling factors to stretch across both axes
				mClip.scaleX = scaleFactor;
				mClip.scaleY = scaleFactor;
			}
		}

		public function startSelectingFile(): void {
			CONFIG::BUILD_FOR_AIR {
				var file: File = new File();
				file.addEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
				file.requestPermission();
			}
			CONFIG::NOT_BUILD_FOR_AIR {
				this.fileRef = new FileReference();
				this.fileRef.addEventListener(Event.SELECT, this.onFileSelected);
				this.fileRef.browse();
			}
			CONFIG::BUILD_FOR_MOBILE_AIR {
				if (GameState.mInstance.mSaveLocation == "documents") {
					var file: File = File.documentsDirectory.resolvePath("ArmyAttack/savefile.txt");
					if (!file.exists) {
						// Check if a legacy save file (from v21) exists, use if yes
						file = File.applicationStorageDirectory.resolvePath("savefile.txt");
						if (!file.exists) {
							return
						}
					}
				} else if (GameState.mInstance.mSaveLocation == "legacy") {
					file = File.applicationStorageDirectory.resolvePath("savefile.txt");
					if (!file.exists) {
						return
					}
				}
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
					file.browseForOpen("Select a file");
				}
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
					loadProgress(savedata);
				}
			}
		}
		public function onFileSelected(evt: Event): void {
			CONFIG::BUILD_FOR_AIR {
				var file: File = evt.target as File;
				var stream: FileStream = new FileStream();
				stream.open(file, FileMode.READ);
				var savedata: * = JSON.parse(stream.readUTFBytes(stream.bytesAvailable));
				stream.close()
				loadProgress(savedata);
			}
			CONFIG::NOT_BUILD_FOR_AIR {
				this.fileRef.addEventListener(Event.COMPLETE, this.onComplete, false, 0, true);
				this.fileRef.load();
			}
		}
		CONFIG::NOT_BUILD_FOR_AIR {
			public function onComplete(evt: Event): void {
				var savedata2: * = JSON.parse(this.fileRef.data.toString());
				loadProgress(savedata2);
			}
		}

		public function fixOldSave(savedata: * , version: int): * {
			if (version < 3) {
				savedata["isFogOfWarOff"] = true;
			}
			return savedata;
		}

		public function loadProgress(savedata: * ): void {
			OfflineSave.loadProgress(savedata);
		}

		private function tabPressed(param1: MouseEvent): void {
			var fileRef: * = undefined;
			if (ArmySoundManager.getInstance().isSfxOn()) {
				ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_CLICK);
			}
			switch (param1.target) {
				case this.mButtonPlay.getMovieClip():
				case this.mButtonResume.getMovieClip():
					GameHUD.isPauseButtonClicked = false;
					if (param1.target == this.mButtonPlay.getMovieClip()) {
						if (FeatureTuner.USE_RATEAPP_POPUP) {
							GameState.mInstance.checkRateApp();
						}
					}
					if (MissionManager.isTutorialCompleted()) {
						GameState.mInstance.changeState(GameState.STATE_PLAY);
					} else {
						ArmySoundManager.getInstance().stopSound(ArmySoundManager.MUSIC_HOME);
						GameState.mInstance.mHUD.openIntroTextBox();
					}
					mDoneCallback((this as Object).constructor);
					break;
				case this.mButtonHelp.getMovieClip():
					GameState.mInstance.mHUD.openHelpScreen();
					break;
				case this.mButtonSettings.getMovieClip():
					GameState.mInstance.mHUD.openSettingsScreen();
					break;
				case this.mButtonLoad.getMovieClip():
					this.startSelectingFile();
			}
		}

		private function updatePlayResumeButton(): void {
			if (GameHUD.isPauseButtonClicked) {
				this.mButtonPlay.setVisible(false);
				this.mButtonResume.setVisible(true);
			} else {
				this.mButtonPlay.setVisible(true);
				this.mButtonResume.setVisible(false);
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