package game.gui.popups {
	import com.dchoc.GUI.DCButton;
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.actions.RedeployPlayerUnitAction;
	import game.characters.PlayerUnit;
	import game.gui.button.ResizingButton;
	import game.isometric.elements.Renderable;
	import game.items.PlayerUnitItem;
	import game.states.GameState;
	import com.dchoc.utils.Cookie;
	import game.sound.ArmySoundManager;

	public class ConfirmRestartTutorialWindow extends PopUpWindow {


		private var mButtonCancel: DCButton;

		private var mButtonYes: ResizingButton;

		private var mButtonNo: ResizingButton;

		private var mTarget: Renderable;

		public function ConfirmRestartTutorialWindow() {
			var _loc1_: Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME, "popup_confirm_restart_tutorial");
			super(new _loc1_() as MovieClip, true);
			this.mButtonCancel = Utils.createBasicButton(mClip, "Button_Cancel", this.noClicked);
			this.mButtonNo = Utils.createResizingButton(mClip, "Button_Skip", this.noClicked);
			this.mButtonYes = Utils.createResizingButton(mClip, "Button_Submit", this.yesClicked);
			this.mButtonNo.setText(GameState.getText("BUTTON_NO"));
			this.mButtonYes.setText(GameState.getText("BUTTON_YES"));
		}

		public function Activate(param1: Function): void {
			var _loc3_: TextField = null;
			mDoneCallback = param1;
			(mClip.getChildByName("Header") as MovieClip).visible = false;
			_loc3_ = mClip.getChildByName("Text_Description") as TextField;
			_loc3_.text = GameState.getText("POP_UP_RESTART_TUTORIAL");
		}

		private function yesClicked(param1: MouseEvent): void {
			Cookie.saveCookieVariable(Config.COOKIE_SESSION_NAME, Config.COOKIE_SESSION_NAME_TUTOTRIAL_INDEX, false);
			if (Config.RESTART_STATUS == -1) {
				Config.RESTART_STATUS = 0;
				GameState.mInstance.mServer.resetMyServerOnReload();
				ArmySoundManager.getInstance().stopAll();
				mDoneCallback((this as Object).constructor);
				if (GameState.mInstance.mHUD.mIngameHUDClip.numChildren > 0) {
					GameState.mInstance.mHUD.mIngameHUDClip.visible = false;
					GameState.mInstance.mHUD.mIngameHUDClip.removeChildren(0, GameState.mInstance.mHUD.mIngameHUDClip.numChildren - 1);
				}
				if (GameState.mInstance.mMapData) {
					GameState.mInstance.mMapData.destroy();
				}
				if (GameState.mInstance.mScene != null) {
					GameState.mInstance.mScene.destroy();
				}
				GameState.mInstance.mServer = null;
				GameState.updateUserDataFlag = false;
				(GameState.mInstance.getMainClip() as GameMain).resetGame();
			}
		}

		private function noClicked(param1: MouseEvent): void {
			mDoneCallback((this as Object).constructor);
		}
	}
}