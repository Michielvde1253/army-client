package game.items {
	import game.missions.MissionManager;
	import game.net.FriendsCollection;
	import game.player.GamePlayerProfile;
	import game.player.Inventory;
	import game.states.GameState;

	public class ShopItem extends Item {


		private var mCostMoney: int;

		private var mCostSupplies: int;

		private var mCostMaterial: int;

		public var mCostPremium: Number;

		public var mCostIntel: int;

		public var mRequiredLevel: int;

		public var mRequiredAllies: int;

		public var mRequiredMission: Object;

		public var mRequiredBuilding: Object;

		public var mRequiredItem: Object;

		public var mDisbandRewardMoney: int;

		private var mCostEarlyUnlock: int;

		public var mEarlyUnlockBought: Boolean;

		protected var mDescriptionSecondary: String;

		private var mMaxAmount: int;

		public var mAvailableInMaps: Array;

		public function ShopItem(param1: Object) {
			super(param1);
			this.mCostMoney = param1.CostMoney;
			this.mCostSupplies = param1.CostSupplies;
			this.mCostMaterial = param1.CostMaterial;
			this.mCostPremium = param1.CostPremium;
			this.mCostIntel = param1.CostIntel;
			this.mRequiredLevel = param1.RequiredLevel;
			this.mRequiredAllies = param1.RequiredAllies;
			this.mRequiredMission = param1.RequiredMission;
			this.mRequiredBuilding = param1.RequiredBuilding;
			this.mRequiredItem = param1.RequiredItem;
			this.mDisbandRewardMoney = param1.DisbandRewardMoney;
			this.mCostEarlyUnlock = param1.CostUnlock;
			this.mEarlyUnlockBought = false;
			this.mDescriptionSecondary = param1.DescriptionSecondary;
			this.mMaxAmount = param1.MaxAmount; // = 0 if no max amount set
			var _loc2_: String = ""
			if (param1.AvailableInMaps) {
				var _loc2_: String = String(param1.AvailableInMaps);
				this.mAvailableInMaps = null;
				if (_loc2_ != undefined) {
					if (_loc2_.indexOf(",") >= 0) {
						this.mAvailableInMaps = _loc2_.split(",");
					} else {
						this.mAvailableInMaps = [_loc2_];
					}
				}
			}
			trace("hier")
			trace(this.mAvailableInMaps)
		}

		public function hasRequiredBuilding(): Boolean {
			if (GameState.smUnlockCheat) {
				return true;
			}
			var _loc1_: GameState = GameState.mInstance;
			return !this.mRequiredBuilding || _loc1_.mScene.buildingExists(this.mRequiredBuilding.ID);
		}

		public function hasRequiredMission(): Boolean {
			if (GameState.smUnlockCheat) {
				return true;
			}
			return !this.mRequiredMission || MissionManager.isMissionCompleted(this.mRequiredMission.ID);
		}

		public function hasRequiredItem(): Boolean {
			if (GameState.smUnlockCheat) {
				return true;
			}
			var _loc1_: Inventory = GameState.mInstance.mPlayerProfile.mInventory;
			return !this.mRequiredItem || _loc1_.getNumberOfItems(ItemManager.getItem(this.mRequiredItem.ID as String, this.mRequiredItem.Type as String)) > 0;
		}

		public function hasRequiredAllies(): Boolean {
			if (GameState.smUnlockCheat) {
				return true;
			}
			return FriendsCollection.smFriends.getPlayingFriendCount() >= this.mRequiredAllies;
		}

		public function hasRequiredLevel(): Boolean {
			if (GameState.smUnlockCheat) {
				return true;
			}
			return GameState.mInstance.mPlayerProfile.mLevel >= this.mRequiredLevel;
		}

		public function hasRequiredIntel(): Boolean {
			var _loc1_: Inventory = GameState.mInstance.mPlayerProfile.mInventory;
			return this.mEarlyUnlockBought || this.mCostIntel == 0 || _loc1_.getNumberOfItems(ItemManager.getItem("Intel", "Intel")) >= this.mCostIntel;
		}

		public function canBeBuiltOnThisMap(): Boolean {
			trace(this.mAvailableInMaps)
			if (this.mAvailableInMaps == null) {
				return true;
			}
			var _loc1_: String = GameState.mInstance.mCurrentMapId;
			return this.mAvailableInMaps.indexOf(_loc1_) >= 0;
		}

		public function isAlreadyAdded(): Boolean {
			if (this.mMaxAmount == 0) {
				return false;
			} else {
				return GameState.mInstance.mScene.countBuildingsWithID(mId) >= this.mMaxAmount;
			}

		}

		public function isUnlocked(): Boolean {
			return this.mEarlyUnlockBought || this.hasRequiredLevel() && this.hasRequiredAllies() && this.hasRequiredMission() && this.hasRequiredItem() && this.hasRequiredBuilding() && !this.isAlreadyAdded() && this.canBeBuiltOnThisMap();
		}

		public function canAffordItemWithResources(): Boolean {
			var _loc1_: GamePlayerProfile = GameState.mInstance.mPlayerProfile;
			return _loc1_.mMoney >= this.getCostMoney() && _loc1_.mMaterial >= this.getCostMaterial() && _loc1_.mSupplies >= this.getCostSupplies() && this.hasRequiredIntel();
		}

		public function getUnlockText(): String {
			var _loc1_: String = "";
			if (this.isAlreadyAdded()) {
				_loc1_ = _loc1_ + GameState.replaceParameters(GameState.getText("SHOP_BUILDING_ALREADY_ADDED"), [this.mMaxAmount]);
			} else if (!this.canBeBuiltOnThisMap()) {
				_loc1_ = _loc1_ + GameState.getText("SHOP_BUILDING_NOT_ON_THIS_MAP");
			} else if (!this.hasRequiredMission()) {
				_loc1_ = _loc1_ + GameState.getText("SHOP_REQUIRES_MISSION") + " " + this.mRequiredMission.Name;
			} else if (!this.hasRequiredLevel()) {
				_loc1_ = _loc1_ + GameState.getText("SHOP_REQUIRES_LEVEL") + " " + this.mRequiredLevel;
			} else if (!this.hasRequiredAllies()) {
				_loc1_ = _loc1_ + this.mRequiredAllies + " " + GameState.getText("SHOP_REQUIRES_ALLIES");
			} else if (!this.hasRequiredBuilding()) {
				_loc1_ = _loc1_ + GameState.getText("SHOP_REQUIRES_BUILDING") + " " + this.mRequiredBuilding.Name;
			} else if (!this.hasRequiredIntel()) {
				_loc1_ = _loc1_ + this.mCostIntel + " " + GameState.getText("SHOP_REQUIRES_INTEL");
			}
			return _loc1_;
		}

		public function getUnlockCostText(): String {
			var _loc1_: String = "";
			if (this.hasRequiredMission()) {
				if (this.hasRequiredAllies()) {
					_loc1_ = _loc1_ + GameState.getText("SHOP_EARLY_UNLOCK_COST") + " " + this.getUnlockCost();
				}
			}
			return _loc1_;
		}

		public function getUnlockCost(): int {
			return this.mCostEarlyUnlock;
		}

		public function getCostMoney(param1: Boolean = false): int {
			return this.mCostMoney;
		}

		public function getCostSupplies(param1: Boolean = false): int {
			return this.mCostSupplies;
		}

		public function getCostMaterial(param1: Boolean = false): int {
			return this.mCostMaterial;
		}

		public function getCostPremium(param1: Boolean = false): Number {
			return this.mCostPremium;
		}

		public function getRequiredResourcesText(): String {
			var _loc1_: * = "";
			var _loc2_: GamePlayerProfile = GameState.mInstance.mPlayerProfile;
			if (_loc2_.mLevel < this.mRequiredLevel) {
				_loc1_ = _loc1_ + "Level: " + this.mRequiredLevel + "  (" + _loc2_.mLevel + ")\n";
			}
			if (this.getCostMoney() > 0) {
				_loc1_ = _loc1_ + "Cash: " + this.getCostMoney() + "  (" + _loc2_.mMoney + ")\n";
			}
			if (this.getCostMaterial() > 0) {
				_loc1_ = _loc1_ + "Steel: " + this.getCostMaterial() + "  (" + _loc2_.mMaterial + ")\n";
			}
			if (this.getCostSupplies() > 0) {
				_loc1_ = _loc1_ + "Suppl: " + this.getCostSupplies() + "  (" + _loc2_.mSupplies + ")";
			}
			return _loc1_;
		}

		public function capAvailable(): Boolean {
			return true;
		}

		public function getDescriptionSecondary(): String {
			return this.mDescriptionSecondary;
		}
	}
}