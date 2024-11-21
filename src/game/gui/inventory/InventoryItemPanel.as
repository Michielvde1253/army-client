package game.gui.inventory {
	import com.dchoc.GUI.DCButton;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.gui.IconLoader;
	import game.items.CollectibleItem;
	import game.items.Item;
	import game.items.ResourceItem;
	import game.items.ShopItem;
	import game.states.GameState;

	public class InventoryItemPanel {


		private var mName: TextField;

		private var mIconBase: MovieClip;

		private var mAmount: TextField;

		private var mItem: Item;

		public var mBasePanel: MovieClip;

		private var mDialog: InventoryDialog;

		private var mItemButton: DCButton;

		private var is_item_being_pressed: Boolean = false;

		public function InventoryItemPanel(param1: MovieClip, param2: InventoryDialog) {
			super();
			this.mBasePanel = param1;
			this.mDialog = param2;
		}

		public function hide(): void {
			if (this.mBasePanel.parent) {
				this.mBasePanel.parent.removeChild(this.mBasePanel);
			}
		}

		public function show(): void {
			this.mDialog.addChild(this.mBasePanel);
		}

		public function setData(param1: Item, param2: int): void {
			this.mItem = param1;
			this.mItemButton = Utils.createBasicButton(this.mBasePanel, "inventoryitem", this.usePressed);
			var _loc3_: MovieClip = this.mItemButton.getMovieClip() as MovieClip;
			var _loc4_: MovieClip = _loc3_.getChildByName("inventoryitem_container") as MovieClip;
			this.mIconBase = _loc4_.getChildByName("Icon_enable") as MovieClip;
			this.mName = _loc4_.getChildByName("Text_Title") as TextField;
			this.mAmount = _loc4_.getChildByName("amount_text") as TextField;
			this.mName.text = param1.mName;
			this.mAmount.text = "" + param2;
			IconLoader.addIcon(this.mIconBase, param1, this.iconLoaded);
			var _loc5_: MovieClip;
			((_loc5_ = _loc4_.getChildByName("Background_Enabled") as MovieClip).getChildByName("Text_Enable") as TextField).text = GameState.getText("BUTTON_USE");
			var _loc6_: MovieClip;
			((_loc6_ = _loc4_.getChildByName("Background_Disabled") as MovieClip).getChildByName("Text_Disable") as TextField).text = GameState.getText("BUTTON_USE");
			if (param1 is ResourceItem || param1 is CollectibleItem) {
				this.mItemButton.setEnabled(false);
				_loc5_.visible = false;
				_loc6_.visible = false;
			} else {
				_loc5_.visible = true;
				_loc6_.visible = false;
				if (param1 is ShopItem) {
					if (ShopItem(param1).capAvailable()) {
						_loc5_.visible = true;
						_loc6_.visible = false;
					} else {
						_loc5_.visible = false;
						_loc6_.visible = true;
					}
				}
			}
		}

		public function iconLoaded(param1: Sprite): void {
			Utils.scaleIcon(param1, 90, 90);
		}

		private function sellPressed(param1: MouseEvent): void {
			InventoryDialog(this.mDialog).sellItem(this.mItem);
		}

		private function usePressed(param1: MouseEvent): void {
			trace("usePressed")
			if (this.mItem is ResourceItem || this.mItem is CollectibleItem) {
				InventoryDialog(this.mDialog).refresh()
			}
			if (this.mItem is ShopItem) {
				if ((this.mItem as ShopItem).capAvailable()) {
					param1.stopImmediatePropagation();
					InventoryDialog(this.mDialog).useItem(this.mItem);
				} else {
					param1.stopImmediatePropagation();
					if (this.mItem.mType == "Infantry") {
						GameState.mInstance.mHUD.openInfantryCapTextBox();
					} else if (this.mItem.mType == "Armor") {
						GameState.mInstance.mHUD.openArmorCapTextBox();
					} else if (this.mItem.mType == "Artillery") {
						GameState.mInstance.mHUD.openArtilleryCapTextBox();
					} else { // unused
						GameState.mInstance.mHUD.openUnitCapTextBox(this.mItem as ShopItem);
					}
					InventoryDialog(this.mDialog).closeDialog();
				}
			} else {
				param1.stopImmediatePropagation();
				InventoryDialog(this.mDialog).useItem(this.mItem);
			}
		}
	}
}