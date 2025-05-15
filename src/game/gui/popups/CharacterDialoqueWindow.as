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
	import game.missions.Mission;
	import game.states.GameState;

	public class CharacterDialoqueWindow extends PopUpWindow {


		private var mCharacter: MovieClip;

		private var mButtonSubmit: ResizingButton;

		private var mTexts: Array;

		private var mMission: Mission;

		public function CharacterDialoqueWindow() {
			var _loc1_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME, "popup_dialogue");
			super(new _loc1_() as MovieClip);
			if (FeatureTuner.USE_POPUP_OPENING_TRANSITION_EFFECT) {
				mCloseTransitionName = DisplayObjectTransition.FADE_DISAPPEAR;
			}
		}

		public function Activate(param1: Function, param2: Mission): void {
			var _loc3_: AutoTextField = null;
			mDoneCallback = param1;
			this.mMission = param2;
			param2.setTargetPopup(this);
			if (param2.mNarratorCharacter) {
				this.installCharacter();
				_loc3_ = new AutoTextField(mClip.getChildByName("Text_Title") as TextField);
				_loc3_.setText(param2.mNarratorCharacter.Name);
			}
			if (param2.mDescription) {
				_loc3_ = new AutoTextField(mClip.getChildByName("Text_Description") as TextField);
				_loc3_.setText(param2.mDescription);
			}
			this.mButtonSubmit = Utils.createResizingButton(mClip, "Button_Submit", this.okClicked);
			this.mButtonSubmit.setText(GameState.getText("BUTTON_CONTINUE"));
		}
	
		CONFIG::BUILD_FOR_AIR {
			override public function alignToScreen(): void {
				x = GameState.mInstance.getStageWidth() / 2;
				y = GameState.mInstance.getStageHeight() - Config.SCREEN_HEIGHT / 2;
			}
		}

		CONFIG::NOT_BUILD_FOR_AIR {
			override public function alignToScreen(): void {
				x = GameState.mInstance.getStageWidth() / 2;
				y = GameState.mInstance.getStageHeight() - Config.SCREEN_HEIGHT / 2;
			}
		}

		/*
		CONFIG::BUILD_FOR_MOBILE_AIR {
			override public function scaleToScreen(): void {
				// Get the current stage width and height
				var stageWidth: Number = GameState.mInstance.getStageWidth();
				var stageHeight: Number = GameState.mInstance.getStageHeight();

				// Define the target size relative to the provided percentages
				var targetWidth: Number = stageWidth * 0.3;
				var targetHeight: Number = stageHeight * 0.3;

				// Calculate the scaling factors based on the clip's dimensions
				var scaleXFactor: Number = targetWidth / mClip.width;
				var scaleYFactor: Number = targetHeight / mClip.height;

				// Apply the smaller scaling factor to maintain aspect ratio
				var scaleFactor: Number = Math.min(scaleXFactor, scaleYFactor);
				mClip.scaleX = scaleFactor;
				mClip.scaleY = scaleFactor;
			}
		}
		*/

		private function installCharacter(): void {
			var _loc2_: MovieClip = null;
			if (this.mCharacter) {
				if (this.mCharacter.parent) {
					this.mCharacter.parent.removeChild(this.mCharacter);
				}
			}
			var _loc1_: MovieClip = null;
			if (FeatureTuner.USE_CHARACTER_DIALOQUE) {
				_loc1_ = mClip.getChildByName("Icon_Character") as MovieClip;
			}
			if (!FeatureTuner.USE_CHARACTER_DIALOQUE_EFFECTS) {
				_loc2_ = mClip.getChildByName("overlay_levelup") as MovieClip;
				if (_loc2_) {
					_loc2_.parent.removeChild(_loc2_);
				}
			}
			var _loc3_: Array = (this.mMission.mNarratorCharacter.Graphic as String).split("/");
			IconLoader.addIcon(_loc1_, new IconAdapter(_loc3_[2], _loc3_[0] + "/" + _loc3_[1]));
		}

		private function okClicked(param1: MouseEvent): void {
			mDoneCallback((this as Object).constructor);
		}
	}
}