package game.gui.popups {
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.gui.AutoTextField;
	import game.gui.IconAdapter;
	import game.gui.IconLoader;
	import game.gui.button.ResizingButton;
	import game.missions.Mission;
	import game.states.GameState;

	public class CampaignProgressWindow extends PopUpWindow {


		private var mCharacter: MovieClip;

		private var mButtonSubmit: ResizingButton;

		private var mCharacterIndex: int;

		private var mTexts: Array;

		private var mMission: Mission;

		private var mCampaignCompleted: Boolean;

		private var mObjectiveWasJustCompleted: String;

		private var mTitle: AutoTextField;

		private var mDesc: AutoTextField;

		public function CampaignProgressWindow() {
			var _loc1_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_01_NAME, "popup_campaign_progress");
			super(new _loc1_() as MovieClip);
		}

		public function Activate(param1: Mission, param2: Function, param3: Array, param4: Boolean, param5: String): void {
			this.mCharacterIndex = 0;
			this.mTexts = param3;
			mDoneCallback = param2;
			this.mMission = param1;
			this.mCampaignCompleted = param4;
			this.mObjectiveWasJustCompleted = param5;
			if (!this.mTexts) {
				return;
			}
			if (!this.installCharacter()) {
				mDoneCallback((this as Object).constructor);
				if (!this.mCampaignCompleted) {
					GameState.mInstance.mHUD.openCampaignWindow(this.mMission, this.mObjectiveWasJustCompleted);
				}
				return;
			}
			this.mButtonSubmit = Utils.createResizingButton(mClip, "Button_Submit", this.okClicked);
			this.mButtonSubmit.setText(GameState.getText("BUTTON_CONTINUE"));
			doOpeningTransition();
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

		private function installCharacter(): Boolean {
			var _loc2_: MovieClip = null;
			var _loc3_: MovieClip = null;
			if (this.mCharacterIndex >= this.mTexts.length) {
				return false;
			}
			if (this.mCharacter) {
				if (this.mCharacter.parent) {
					this.mCharacter.parent.removeChild(this.mCharacter);
				}
			}
			var _loc1_: Array = ((this.mTexts[this.mCharacterIndex] as Object).Graphic as String).split("/");
			this.mCharacter = IconLoader.addIcon(null, new IconAdapter(_loc1_[2], _loc1_[0] + "/" + _loc1_[1]));
			if (!this.mTitle) {
				this.mTitle = new AutoTextField(mClip.getChildByName("Text_Description") as TextField);
			}
			this.mTitle.setText(this.mTexts[this.mCharacterIndex + 1]);
			if (this.mCharacter) {
				if (FeatureTuner.USE_CHARACTER_DIALOQUE) {
					_loc3_ = mClip.getChildByName("Icon_Character") as MovieClip;
					if (_loc3_.numChildren > 0) {
						_loc3_.removeChildAt(0);
					}
					_loc3_.addChildAt(this.mCharacter, _loc3_.numChildren);
				}
				if (!FeatureTuner.USE_CHARACTER_DIALOQUE_EFFECTS) {
					if (FeatureTuner.USE_LOW_SWF) {
						_loc2_ = mClip.getChildByName("overlay_levelup") as MovieClip;
						if (_loc2_) {
							_loc2_.parent.removeChild(_loc2_);
						}
					}
				}
				if (!this.mDesc) {
					this.mDesc = new AutoTextField(mClip.getChildByName("Text_Title") as TextField);
				}
				this.mDesc.setText((this.mTexts[this.mCharacterIndex] as Object).Name);
				this.mCharacterIndex += 2;
				return true;
			}
			return false;
		}

		private function okClicked(param1: MouseEvent): void {
			if (!this.installCharacter()) {
				mDoneCallback((this as Object).constructor);
				if (!this.mCampaignCompleted) {
					GameState.mInstance.mHUD.openCampaignWindow(this.mMission, this.mObjectiveWasJustCompleted);
				}
			}
		}
	}
}