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
	CONFIG::BUILD_FOR_MOBILE_AIR {
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
		import flash.permissions.PermissionStatus
		import flash.utils.Timer;
		import flash.utils.ByteArray;
	}

	public class GiveFilePermissionDialog extends PopUpWindow {

		public static var mPauseScreenState: int;

		public static var mPauseScreenPreviousState: int;

		public static const STATE_IN_GAME: int = 0;

		public static const STATE_UNDEFINED: int = 1;

		public static const STATE_CONTINUE: int = 2;

		public static const STATE_HELP_CLICK: int = 3;

		public static const STATE_SETTINGS_CLICK: int = 4;


		private var mButtonGivePerms: ArmyButton;

		private var mButtonDenyPerms: ArmyButton;

		public function GiveFilePermissionDialog() {
			var _loc1_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_MAIN_MENU_NAME, "GiveFilePermissionMenu");
			super(new _loc1_(), false);
			this.mButtonGivePerms = this.addButton(mClip, "Button_GivePerms", this.tabPressed);
			this.mButtonGivePerms.resizeNeeded = false;
			this.mButtonDenyPerms = this.addButton(mClip, "Button_DenyPerms", this.tabPressed);
			this.mButtonDenyPerms.resizeNeeded = false;
			this.mButtonGivePerms.setText(GameState.getText("BUTTON_DOCUMENTS"), "Text_Title");
			this.mButtonDenyPerms.setText(GameState.getText("BUTTON_APPFILES"), "Text_Title");
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
				case this.mButtonGivePerms.getMovieClip():
					GameState.mInstance.mSaveLocation = "documents";
					this.saveSettingsSave(param1);
					this.buttonSavePressed(param1); // aka save progress
					break;
				case this.mButtonDenyPerms.getMovieClip():
					GameState.mInstance.mSaveLocation = "legacy";
					this.buttonSavePressed(param1);
					break;
			}
			mDoneCallback((this as Object).constructor);
			GameState.mInstance.mHUD.openPauseScreen();
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
		public function buttonSavePressed(param1: MouseEvent): void {
			CONFIG::BUILD_FOR_MOBILE_AIR {
				// Resolve the file path
				var file2: File = null;
				if (GameState.mInstance.mSaveLocation == "documents") {
					var file: File = File.documentsDirectory.resolvePath("ArmyAttack/savefile.txt");
					file2 = File.applicationStorageDirectory.resolvePath("savefile.txt"); // Also save in appdata, just to be sure
				} else {
					var file: File = File.applicationStorageDirectory.resolvePath("savefile.txt");
				}
				file.addEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
				file.requestPermission();
				if(file2 != null){
					trace("saved game in appdata as well")
					file2.addEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
					file2.requestPermission();
				}
			}
		}

		CONFIG::BUILD_FOR_MOBILE_AIR {
			public function onPermission(e: PermissionEvent): void {
				var file: File = e.target as File;
				file.removeEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
				if (e.status == PermissionStatus.GRANTED) {

					var savedata: * = {};
					savedata = OfflineSave.generateSaveJson();

					// Open a file stream to write content to the file
					var fileStream: FileStream = new FileStream();
					fileStream.open(file, FileMode.WRITE);
					fileStream.writeUTFBytes(savedata);
					fileStream.close();

					var bytearray: ByteArray = new ByteArray();
					bytearray.writeUTF(savedata);
					var stream: FileStream = new FileStream();
					stream.open(file, FileMode.WRITE);
					stream.writeUTFBytes(JSON.stringify(savedata));
					stream.close()
				}
			}
		}
		CONFIG::BUILD_FOR_MOBILE_AIR {
			public function saveSettingsSave(param1: MouseEvent): void {
				var file: File = File.applicationStorageDirectory.resolvePath("savesettings.txt");
				file.addEventListener(PermissionEvent.PERMISSION_STATUS, onSaveSettingsSavePermission);
				file.requestPermission();
			}
		}

		CONFIG::BUILD_FOR_MOBILE_AIR {
			public function onSaveSettingsSavePermission(e: PermissionEvent): void {
				var file: File = e.target as File;
				file.removeEventListener(PermissionEvent.PERMISSION_STATUS, onSaveSettingsSavePermission);
				if (e.status == PermissionStatus.GRANTED) {

					var data: * = {};
					data["savelocation"] = GameState.mInstance.mSaveLocation;

					// Open a file stream to write content to the file
					var fileStream: FileStream = new FileStream();
					fileStream.open(file, FileMode.WRITE);
					fileStream.writeUTFBytes(data);
					fileStream.close();

					var bytearray: ByteArray = new ByteArray();
					bytearray.writeUTF(data);
					var stream: FileStream = new FileStream();
					stream.open(file, FileMode.WRITE);
					stream.writeUTFBytes(JSON.stringify(data));
					stream.close()
				}
			}
		}
	}
}