package game.gameElements {
	import game.isometric.IsometricScene;
	import game.isometric.elements.DisplayContainer;
	import game.items.HFEItem;
	import game.items.ItemManager;
	import game.items.MapItem;
	import game.player.GamePlayerProfile;
	import game.states.GameState;

	public class Production {

		public static const TIME_DEFAULT: int = -1;

		public static const TIME_NEVER_WITHER: int = 0;


		private var mProducerItem: MapItem;

		private var mProducerBuilding: ResourceBuildingObject;

		private var mProductionID: String;

		private var mProduction: Object;

		private var mStartedTime: int;

		private var mProducingTime: int;

		private var mTimeToWither: int;

		public function Production(param1: MapItem, param2: String, param3: int = -1, param4: int = -1, param5: PlayerBuildingObject = null) {
			super();
			this.mProducerItem = param1;
			this.mProductionID = param2;
			if (param5 is ResourceBuildingObject) {
				this.mProducerBuilding = param5 as ResourceBuildingObject;
			}
			this.mProduction = param1.getCraftingObjectByID(param2);
			if (this.mProduction.hasOwnProperty("RewardXp")) {
				this.mProduction.RewardXP = this.mProduction.RewardXp;
			} else if (this.mProduction.hasOwnProperty("RewardXP")) {
				this.mProduction.RewardXp = this.mProduction.RewardXP;
			}
			if (param3 == TIME_DEFAULT) {
				this.mProducingTime = this.mProduction.Time;
			} else if (param3 > 0) {
				this.mProducingTime = param3;
			} else if (Config.DEBUG_MODE) {}
			this.mProducingTime *= 60 * 1000;
			if (param4 == TIME_NEVER_WITHER || this.mProduction.SpoilTime == TIME_NEVER_WITHER) {
				this.mTimeToWither = 0;
			} else if (param4 == TIME_DEFAULT) {
				this.mTimeToWither = this.mProducingTime + int(this.mProduction.SpoilTime) * 1000 * 60;
			} else if (param4 > 0) {
				this.mTimeToWither = this.mProducingTime + param4 * 1000 * 60;
			} else if (Config.DEBUG_MODE) {}
			this.mStartedTime = GameState.getActualTimer();
		}

		public function getProducedPartID(): String {
			if (this.mProduction.RewardItems) {
				return this.mProduction.RewardItems.ID;
			}
			return "";
		}

		public function getProducerID(): String {
			return this.mProducerItem.mId;
		}

		public function getProductionID(): String {
			return this.mProduction.ID;
		}

		public function getProductionName(): String {
			return this.mProduction.Name;
		}

		public function getRewardMoney(): int {
			return this.mProducerItem is HFEItem && this.isWithered() ? 0 : int(this.mProduction.RewardMoney);
		}

		public function getRewardXp(): int {
			return this.mProducerItem is HFEItem && this.isWithered() ? 0 : int(this.mProduction.RewardXp);
		}

		public function getRewardSupplies(): int {
			/*
		 This memorial was made to remember how Digital Chocolate was clearly on the side of the English
		 during the Great Crimson War. Other languages were being discriminated by not giving them supplies
		 when their drop zones were sabotaged.
		  
		 RIP getRewardSupplies()
		 2012-2024
		 You won't be missed.
		  
		  
		  
         var _loc1_:int = 0;
         switch(this.mProducerItem.mName)
         {
            case "Ammo Crates":
            case "M.R.E Containers":
               _loc1_ = 70 / 100 * this.mProduction.RewardSupplies;
               break;
            case "Gasoline Drop":
            case "Oil Containers":
               _loc1_ = 50 / 100 * this.mProduction.RewardSupplies;
               break;
            case "Military Crate":
            case "Big Container":
            case "Premium Container":
               _loc1_ = 30 / 100 * this.mProduction.RewardSupplies;
         }
         return this.mProducerItem is HFEItem && this.isWithered() ? _loc1_ : int(this.mProduction.RewardSupplies);
		 */

			var _loc1_: int = 0;
			switch (this.mProducerItem.mId) {
				case "Farm":
				case "Plantation":
					_loc1_ = 70 / 100 * this.mProduction.RewardSupplies;
					break;
				case "Ranch":
				case "Mine":
					_loc1_ = 50 / 100 * this.mProduction.RewardSupplies;
					break;
				case "Quarry":
				case "Sawmill":
				case "Oilwell":
					_loc1_ = 30 / 100 * this.mProduction.RewardSupplies;
			}
			return this.mProducerItem is HFEItem && this.isWithered() ? _loc1_ : int(this.mProduction.RewardSupplies);
		}

		public function getRewardMaterial(): int {
			return this.mProducerItem is HFEItem && this.isWithered() ? 0 : int(this.mProduction.RewardMaterial);
		}

		public function getRewardEnergy(): int {
			return this.mProducerItem is HFEItem && this.isWithered() ? 0 : int(this.mProduction.RewardEnergy);
		}

		public function getRewardWater(): int {
			return this.mProduction.RewardWater;
		}

		public function getLeftToHarvestPercentage(): int {
			var _loc1_: int = 0;
			if ((_loc1_ = this.getProducingTimeLeft()) > 0) {
				return Math.ceil(_loc1_ / this.mProducingTime * 100);
			}
			return 0;
		}

		public function getHarvestCompletePercentage(): int {
			return 100 - this.getLeftToHarvestPercentage();
		}

		public function isReady(): Boolean {
			return GameState.getActualTimer() > this.mStartedTime + this.mProducingTime;
		}

		public function setRemainingProductionTime(param1: int): void {
			this.mStartedTime = GameState.getActualTimer() - (this.mProducingTime - param1 * 1000);
		}

		public function speedUp(): void {
			var _loc1_: int = this.mProducingTime * GameState.mConfig.AllyAction.SpeedUpProduction.SpeedUpPercent / 100;
			_loc1_ = Math.min(_loc1_, this.getProducingTimeLeft());
			this.mStartedTime -= _loc1_;
		}

		public function setRemainingWitheringTime(param1: int): void {
			if (this.mTimeToWither == 0) {
				this.mStartedTime = GameState.getActualTimer() - this.mProducingTime;
			} else {
				this.mStartedTime = GameState.getActualTimer() - (this.mTimeToWither - param1 * 1000);
			}
		}

		public function setWithered(): void {
			this.mStartedTime = GameState.getActualTimer() - this.mTimeToWither;
		}

		public function getProducingTimeLeft(): int {
			var _loc1_: int = GameState.getActualTimer() - this.mStartedTime;
			return this.mProducingTime - _loc1_;
		}

		public function isWithered(): Boolean {
			return !this.isUnWitherable() && this.getTimeToWither() < 0;
		}

		public function isUnWitherable(): Boolean {
			return this.mTimeToWither == 0;
		}

		public function getTimeToWither(): int {
			var _loc1_: int = 0;
			if (this.isUnWitherable()) {
				return 0;
			}
			_loc1_ = GameState.getActualTimer() - this.mStartedTime;
			return this.mTimeToWither - _loc1_;
		}

		public function getTotalTimeToWither(): int {
			if (this.isUnWitherable()) {
				return 0;
			}
			return this.mTimeToWither;
		}

		public function getHireCostPremium(): int {
			if (this.mProduction.HireCostPremium) {
				return this.mProduction.HireCostPremium;
			}
			return 0;
		}

		public function addRewards(param1: DisplayContainer, param2: Object): void {
			var _loc3_: GameState = GameState.mInstance;
			var _loc4_: IsometricScene = _loc3_.mScene;
			var _loc5_: GamePlayerProfile = _loc3_.mPlayerProfile;
			var _loc6_: int = this.getRewardMoney();
			var _loc7_: int = this.getRewardXp();
			var _loc8_: int = this.getRewardSupplies();
			var _loc9_: int = this.getRewardEnergy();
			var _loc10_: int = this.getRewardWater();
			trace("Reward water:");
			trace(_loc10_);
			if (this.mProducerBuilding) {
				_loc10_ += _loc10_ * this.mProducerBuilding.getHelpingFriends().length;
				this.mProducerBuilding.resetHelpingFriends();
			}
			_loc5_.increaseEnergyRewardCounter(_loc9_);
			var _loc11_: int = _loc5_.getBonusEnergy();
			_loc4_.addLootReward(ItemManager.getItem("Money", "Resource"), _loc6_, param1);
			_loc4_.addLootReward(ItemManager.getItem("XP", "Resource"), _loc7_, param1);
			_loc4_.addLootReward(ItemManager.getItem("Supplies", "Resource"), _loc8_, param1);
			_loc4_.addLootReward(ItemManager.getItem("Energy", "Resource"), _loc11_, param1);
			_loc4_.addLootReward(ItemManager.getItem("Water", "Resource"), _loc10_, param1);
			param2.reward_money = _loc6_;
			param2.reward_xp = _loc7_;
			param2.reward_water = _loc10_;
			param2.reward_supplies = _loc8_;
			param2.reward_energy = _loc9_;
		}
	}
}