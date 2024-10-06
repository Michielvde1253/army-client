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
	import com.dchoc.utils.Cookie;

	public class FirstTimeChooseDialog extends PopUpWindow {

		private var mButtonContinue: ArmyButton;
		
		private var savefile:*;

		public function FirstTimeChooseDialog() {
			var _loc1_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_MAIN_MENU_NAME, "FirstTimeChooseMenu");
			super(new _loc1_(), false);
			this.mButtonContinue = this.addButton(mClip, "Button_Continue", this.tabPressed);
			this.mButtonContinue.resizeNeeded = false;
			this.mButtonContinue.setText(GameState.getText("OFFLINE_BUTTON_TEXT"), "Text_Title");
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
				case this.mButtonContinue.getMovieClip():
					checkIfFileExists()
					break;
			}
		}

		public function onPermission(e: PermissionEvent): void {
			var file: File = e.target as File;
			file.removeEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
			if (e.status == PermissionStatus.GRANTED) {
				var savedata: * = {};
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
			
				Cookie.saveCookieVariable(Config.COOKIE_PERMISSION_NAME,Config.COOKIE_PERMISSION_NAME_OK,"ok")

				mDoneCallback((this as Object).constructor);
				GameState.mInstance.mHUD.openPauseScreen()
			}
		}
	
			public function checkIfFileExists(): void {
				// Convert previous progress
				var file: File = File.applicationStorageDirectory.resolvePath("savefile.txt");
				if (file.exists) {
					file.addEventListener(PermissionEvent.PERMISSION_STATUS, onLoadPermission);
					file.requestPermission();
				} else {
					savedata = OfflineSave.generateSaveJson();
				}
			}

			public function onLoadPermission(e: PermissionEvent): void {
				var file: File = e.target as File;
				file.removeEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
				if (e.status == PermissionStatus.GRANTED) {
					var fs: FileStream = new FileStream();
					fs.open(file, FileMode.READ);
					savedata = JSON.parse(fs.readUTFBytes(fs.bytesAvailable));
					fs.close();
					
					OfflineSave.loadProgress(savedata);
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