package game.gui.popups {
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.gui.AutoTextField;
	import game.gui.DisplayObjectTransition;
	import game.gui.IconAdapter;
	import game.gui.IconLoader;
	import game.gui.button.ResizingButton;
	import game.states.GameState;

	public class WelcomeWindow extends PopUpWindow {


		private var mCharacter: MovieClip;

		private var mButtonOk: ResizingButton;

		public function WelcomeWindow() {
			var _loc1_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME, "popup_welcome");
			super(new _loc1_());
			mCloseTransitionName = DisplayObjectTransition.FADE_DISAPPEAR;
		}

		public function Activate(param1: Function, param2: int, param3: int, param4: int, param5: int): void {
			var _loc10_: String = null;
			var _loc6_: TextField;
			(_loc6_ = mClip.getChildByName("Text_Title") as TextField).text = GameState.getText("SITREP_TITLE");
			mDoneCallback = param1;
			var _loc7_: String = null;
			var _loc8_: String = null;
			if (param2 > 0) {
				_loc7_ = GameState.getText("SITREP_NEW_ENEMY", [param2]);
			}
			if (param3 > 0) {
				_loc10_ = GameState.getText("SITREP_ENEMY_ACTIVE", [param3]);
				if (_loc7_ == null) {
					_loc7_ = _loc10_;
				} else {
					_loc8_ = _loc10_;
				}
			}
			if (_loc8_ == null && param4 > 0) {
				_loc10_ = GameState.getText("SITREP_FRIENDLY_DOWN", [param4]);
				if (_loc7_ == null) {
					_loc7_ = _loc10_;
				} else {
					_loc8_ = _loc10_;
				}
			}
			if (_loc8_ == null && param5 > 0) {
				_loc10_ = GameState.getText("SITREP_READY_SUPPLIES", [param5]);
				if (_loc7_ == null) {
					_loc7_ = _loc10_;
				} else {
					_loc8_ = _loc10_;
				}
			}
			var _loc9_: AutoTextField = new AutoTextField(mClip.getChildByName("Text_Description") as TextField);
			if (_loc8_ != null) {
				_loc9_.setText(GameState.getText("SITREP_WELCOME", [_loc7_, _loc8_]));
			} else {
				_loc9_.setText(GameState.getText("SITREP_WELCOME2", [_loc7_]));
			}
			this.mButtonOk = Utils.createResizingButton(mClip, "Button_Submit", this.okClicked);
			this.mButtonOk.setText(GameState.getText("BUTTON_CONTINUE"));
			this.installCharacter();
			doOpeningTransition();
		}

		override public function alignToScreen(): void {
			x = GameState.mInstance.getStageWidth() / 2;
			CONFIG::BUILD_FOR_MOBILE_AIR {
				y = GameState.mInstance.getStageHeight() - (Config.SCREEN_HEIGHT);
			}
			CONFIG::BUILD_FOR_AIR {
				y = GameState.mInstance.getStageHeight() - Config.SCREEN_HEIGHT / 2;
			}
			CONFIG::NOT_BUILD_FOR_AIR {
				y = GameState.mInstance.getStageHeight() - Config.SCREEN_HEIGHT / 2;
			}
		}

		/*
		CONFIG::BUILD_FOR_MOBILE_AIR {
			override public function scaleToScreen(): void {
				var stageWidth: Number = GameState.mInstance.getStageWidth();
				var stageHeight: Number = GameState.mInstance.getStageHeight();

				var targetWidth: Number = stageWidth * 0.3;
				var targetHeight: Number = stageHeight * 0.3;

				var scaleXFactor: Number = targetWidth / mClip.width;
				var scaleYFactor: Number = targetHeight / mClip.height;

				var scaleFactor: Number = Math.min(scaleXFactor, scaleYFactor);
				mClip.scaleX = scaleFactor;
				mClip.scaleY = scaleFactor;
			}
		}
	*/

		private function installCharacter(): void {
			if (Boolean(this.mCharacter) && Boolean(this.mCharacter.parent)) {
				this.mCharacter.parent.removeChild(this.mCharacter);
			}
			var _loc1_: MovieClip = mClip.getChildByName("Icon_Character") as MovieClip;
			CONFIG::BUILD_FOR_MOBILE_AIR {
				_loc1_.x = _loc1_.x - 160;
				_loc1_.y = _loc1_.y - 40;
			}
			var _loc2_: Array = (GameState.mConfig.Character.Mutton.Graphic as String).split("/");
			IconLoader.addIcon(_loc1_, new IconAdapter(_loc2_[2], _loc2_[0] + "/" + _loc2_[1]));
		}

		private function okClicked(param1: MouseEvent): void {
			mDoneCallback((this as Object).constructor);
		}
	}
}