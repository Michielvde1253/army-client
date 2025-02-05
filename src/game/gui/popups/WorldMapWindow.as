package game.gui.popups {
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import game.gui.StylizedHeaderClip;
	import game.gui.TooltipMap;
	import game.gui.button.ArmyButton;
	import game.missions.MissionManager;
	import game.states.GameState;

	public class WorldMapWindow extends PopUpWindow {

		public static const WORLD_MAP_ID_LIST: Array = ["Home", "Desert", ""];


		private var mCampaignButtons: Array;

		private var mCampaignTexts: Array;

		private var mButtonCancel: ArmyButton;

		private var mTooltip: TooltipMap;

		private var mButtonContainer: MovieClip;

		public function WorldMapWindow() {
			var _loc3_: MovieClip = null;
			var _loc4_: MovieClip = null;
			var _loc6_: MovieClip = null;
			var _loc7_: MovieClip = null;
			var _loc8_: MovieClip = null;
			var _loc1_: Class = DCResourceManager.getInstance().getSWFClass("swf/map", "map");
			super(new _loc1_(), true);
			var _loc2_: MovieClip = mClip.getChildByName("map_gloss") as MovieClip;
			_loc2_.mouseEnabled = false;
			this.mButtonCancel = Utils.createBasicButton(mClip, "Button_Cancel", this.closeClicked);
			this.mButtonContainer = mClip.getChildByName("Map_Container") as MovieClip;
			_loc3_ = this.mButtonContainer.getChildByName("Map_Grid") as MovieClip;
			_loc3_.mouseEnabled = false;
			_loc3_.mouseChildren = false;
			(_loc4_ = this.mButtonContainer.getChildByName("Icon_Mappin") as MovieClip).mouseChildren = false;
			_loc4_.mouseEnabled = false;
			_loc4_.visible = false;
			this.mCampaignButtons = new Array();
			var _loc5_: int = 0;
			while (_loc5_ < WORLD_MAP_ID_LIST.length) {
				_loc7_ = (_loc6_ = this.mButtonContainer.getChildByName("Button_Campaign_0" + (_loc5_ + 1)) as MovieClip).getChildByName("Hit_Area") as MovieClip;
				this.mCampaignButtons.push(_loc7_);
				if (_loc8_ = _loc6_.getChildByName("Conquered_Icon") as MovieClip) {
					_loc8_.visible = false;
				}
				if (WORLD_MAP_ID_LIST.indexOf(GameState.mInstance.mCurrentMapId) == _loc5_) {
					_loc4_.x = _loc6_.x;
					_loc4_.y = _loc6_.y;
					_loc4_.visible = true;
				}
				this.setAreaAvailability(_loc5_, !MissionManager.isMapLocked(WORLD_MAP_ID_LIST[_loc5_]));
				_loc5_++;
			}
			this.setAreaAvailability(2, false);
			this.mTooltip = new TooltipMap(120);
			this.addChild(this.mTooltip);
			this.createCampaignTexts();
			mCloseTransitionName = null;
		}

		private function createCampaignTexts(): void {
			this.mCampaignTexts = new Array();
			this.mCampaignTexts.push(GameState.getText("MAP_TOOLTIP_HOMELAND_TITLE"));
			this.mCampaignTexts.push(GameState.getText("MAP_TOOLTIP_HOMELAND_DESC"));
			this.mCampaignTexts.push("");
			this.mCampaignTexts.push(GameState.getText("MAP_TOOLTIP_LIBERY_TITLE"));
			this.mCampaignTexts.push(GameState.getText("MAP_TOOLTIP_LIBERY_DESC"));
			this.mCampaignTexts.push(GameState.getText("MAP_TOOLTIP_LIBERY_LOCKED"));
			this.mCampaignTexts.push(GameState.getText("MAP_TOOLTIP_COMING_SOON"));
			this.mCampaignTexts.push("");
			this.mCampaignTexts.push("");
		}

		public function Activate(param1: Function): void {
			var _loc2_: StylizedHeaderClip = null;
			mDoneCallback = param1;
			_loc2_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip, GameState.getText("HUD_MAP_TOOLTIP"));
			MissionManager.increaseCounter("OpenMap", null, 1);
		}

		CONFIG::BUILD_FOR_MOBILE_AIR {
			override public function scaleToScreen(): void {
				// Get the current stage width and height
				var stageWidth: Number = GameState.mInstance.getStageWidth();
				var stageHeight: Number = GameState.mInstance.getStageHeight();

				// Define the target size relative to the provided percentages
				var targetWidth: Number = stageWidth * 1.5;
				var targetHeight: Number = stageHeight * 1.5;

				// Calculate the scaling factors based on the clip's dimensions
				var scaleXFactor: Number = targetWidth / mClip.width;
				var scaleYFactor: Number = targetHeight / mClip.height;

				// Apply the smaller scaling factor to maintain aspect ratio
				var scaleFactor: Number = Math.min(scaleXFactor, scaleYFactor);
				mClip.scaleX = scaleFactor;
				mClip.scaleY = scaleFactor;
			}
		}

		private function setupIcon(param1: MovieClip): void {
			param1.setMouseEnabled(false);
			param1.setMouseChildren(false);
		}

		private function mouseDown(param1: MouseEvent): void {
			var _loc2_: int = this.getAreaIndex(param1.target) + 1;
			var _loc3_: MovieClip = this.mButtonContainer.getChildByName("Button_Campaign_0" + _loc2_) as MovieClip;
			(_loc3_.getChildByName("Background_Enabled") as MovieClip).visible = false;
			(_loc3_.getChildByName("Background_Over") as MovieClip).visible = false;
			(_loc3_.getChildByName("Background_Down") as MovieClip).visible = true;
			(_loc3_.getChildByName("Background_Out") as MovieClip).visible = false;
			(_loc3_.getChildByName("Background_Disabled") as MovieClip).visible = false;
		}

		private function mouseOver(param1: MouseEvent): void {
			var _loc3_: MovieClip = null;
			var _loc2_: int = this.getAreaIndex(param1.target);
			if (!MissionManager.isMapLocked(WORLD_MAP_ID_LIST[_loc2_])) {
				_loc3_ = this.mButtonContainer.getChildByName("Button_Campaign_0" + (_loc2_ + 1)) as MovieClip;
				(_loc3_.getChildByName("Background_Enabled") as MovieClip).visible = false;
				(_loc3_.getChildByName("Background_Over") as MovieClip).visible = true;
				(_loc3_.getChildByName("Background_Down") as MovieClip).visible = false;
				(_loc3_.getChildByName("Background_Out") as MovieClip).visible = false;
				(_loc3_.getChildByName("Background_Disabled") as MovieClip).visible = false;
			}
			if (!this.mTooltip.visible) {
				if (MissionManager.isMapLocked(WORLD_MAP_ID_LIST[_loc2_])) {
					this.mTooltip.setText(this.mCampaignTexts[_loc2_ * 3], this.mCampaignTexts[_loc2_ * 3 + 2]);
				} else {
					this.mTooltip.setText(this.mCampaignTexts[_loc2_ * 3], this.mCampaignTexts[_loc2_ * 3 + 1]);
				}
				this.mTooltip.visible = true;
			}
		}

		private function mouseOut(param1: MouseEvent): void {
			var _loc3_: MovieClip = null;
			var _loc2_: int = this.getAreaIndex(param1.target);
			if (!MissionManager.isMapLocked(WORLD_MAP_ID_LIST[_loc2_])) {
				_loc3_ = this.mButtonContainer.getChildByName("Button_Campaign_0" + (_loc2_ + 1)) as MovieClip;
				(_loc3_.getChildByName("Background_Enabled") as MovieClip).visible = true;
				(_loc3_.getChildByName("Background_Over") as MovieClip).visible = false;
				(_loc3_.getChildByName("Background_Down") as MovieClip).visible = false;
				(_loc3_.getChildByName("Background_Out") as MovieClip).visible = false;
				(_loc3_.getChildByName("Background_Disabled") as MovieClip).visible = false;
			}
			this.mTooltip.setText("", "");
			this.mTooltip.visible = false;
		}

		private function mouseUp(param1: MouseEvent): void {
			var _loc2_: int = this.getAreaIndex(param1.target);
			var _loc3_: MovieClip = this.mButtonContainer.getChildByName("Button_Campaign_0" + (_loc2_ + 1)) as MovieClip;
			(_loc3_.getChildByName("Background_Enabled") as MovieClip).visible = true;
			(_loc3_.getChildByName("Background_Over") as MovieClip).visible = false;
			(_loc3_.getChildByName("Background_Down") as MovieClip).visible = false;
			(_loc3_.getChildByName("Background_Out") as MovieClip).visible = false;
			(_loc3_.getChildByName("Background_Disabled") as MovieClip).visible = false;
			this.mTooltip.visible = false;
			this.goToArea(WORLD_MAP_ID_LIST[_loc2_]);
		}

		private function getAreaIndex(param1: * ): int {
			var _loc2_: int = 0;
			while (_loc2_ < this.mCampaignButtons.length) {
				if (this.mCampaignButtons[_loc2_] == param1) {
					return _loc2_;
				}
				_loc2_++;
			}
			return 0;
		}

		private function setAreaAvailability(param1: int, param2: Boolean): void {
			var _loc3_: MovieClip = this.mCampaignButtons[param1];
			_loc3_.buttonMode = param2;
			var _loc5_: MovieClip;
			var _loc4_: MovieClip;
			if (_loc5_ = (_loc4_ = this.mButtonContainer.getChildByName("Button_Campaign_0" + (param1 + 1)) as MovieClip).getChildByName("Lock_Icon") as MovieClip) {
				_loc5_.visible = !param2;
			}
			if (param2) {
				_loc3_.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDown, false, 0, true);
				_loc3_.addEventListener(MouseEvent.MOUSE_UP, this.mouseUp, false, 0, true);
			}
			if (!param2) {
				(_loc4_.getChildByName("Background_Enabled") as MovieClip).visible = false;
				(_loc4_.getChildByName("Background_Over") as MovieClip).visible = false;
				(_loc4_.getChildByName("Background_Down") as MovieClip).visible = false;
				(_loc4_.getChildByName("Background_Out") as MovieClip).visible = false;
				(_loc4_.getChildByName("Background_Disabled") as MovieClip).visible = true;
			}
		}

		private function goToArea(param1: String): void {
			mDoneCallback((this as Object).constructor);
			GameState.mInstance.executeSwitchMap(param1, null);
		}

		private function closeClicked(param1: MouseEvent): void {
			var _loc2_: MovieClip = param1.target as MovieClip;
			_loc2_.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDown);
			_loc2_.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUp);
			mDoneCallback((this as Object).constructor);
		}
	}
}