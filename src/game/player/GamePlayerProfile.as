package game.player
{
   import com.dchoc.utils.DCUtils;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import game.characters.PlayerUnit;
   import game.gameElements.ConstructionObject;
   import game.gameElements.DecorationObject;
   import game.gui.FriendPanel;
   import game.isometric.elements.Renderable;
   import game.items.ConstructionItem;
   import game.items.DecorationItem;
   import game.items.EnergyRefillItem;
   import game.items.Item;
   import game.items.ItemCollectionItem;
   import game.items.ItemManager;
   import game.items.PlayerUnitItem;
   import game.items.ShopItem;
   import game.items.SupplyPackItem;
   import game.items.WaterPackItem;
   import game.magicBox.FlurryEvents;
   import game.magicBox.MagicBoxTracker;
   import game.missions.Mission;
   import game.missions.MissionManager;
   import game.net.Friend;
   import game.net.FriendsCollection;
   import game.net.PvPOpponentCollection;
   import game.net.ServerCall;
   import game.net.ServiceIDs;
   import game.states.GameState;
   import game.utils.WebUtils;
   
   public class GamePlayerProfile
   {
       
      
      private var mLoaded:Boolean;
      
      public var mMaxEnergy:int;
      
      public var mEnergy:int;
      
      public var mWater:int;
      
      public var mSupplies:int;
      
      public var mSocialXp:int;
      
      public var mSocialLevel:int;
      
      public var mMaxNeighborActions:int;
      
      public var mNeighborActionsLeft:int;
      
      public var mLevel:int;
      
      public var mRankIdx:int = 0;
      
      public var mXp:int;
      
      public var mBadassXp:int;
      
      public var mBadassLevel:int;
      
      public var mMoney:int;
      
      public var mMaterial:int;
      
      public var mPremium:int;
      
      public var mSecondsToRechargeEnergy:int;
      
      public var mTimeBetweenEnergyRecharges:int;
      
      public var mInventory:Inventory;
      
      public var mWishList:Wishlist;
      
      private var mRecentlyGiftedEnergy:Array;
      
      private var mRecentlyGiftedSupplies:Array;
      
      private var mLevelProgression:Array;
      
      private var mLevelConfig:*;
      
      private var mSocialLevelProgression:Array;
      
      private var mBadassLevelProgression:Array;
      
      public var mPic:String;
      
      public var mFirstName:String;
      
      public var mUid:String;
      
      private var mHasBookmarkedGame:Boolean;
      
      private var mEmailAllowed:Boolean;
      
      private var mLevelGained:Boolean;
      
      private var mSocialLevelGained:Boolean;
      
      private var mBadassLevelGained:Boolean;
      
      public var mSuppliesCap:int;
      
      public var mUnitCaps:*;
      
      public var mUnitCounts:*;
      
      private var mIdCounter:int;
      
      private var mEnergyRewardCounter:int;
      
      public var mSpawnEnemyLevel:int = 0;
      
      public var mSecsSinceLastEnemySpawn:int;
      
      public var mRewardDropSeedTerm:int;
      
      public var mRewardDropsCounter:int;
      
      private var mOutOfEnergyAppearTimer:Timer;
      
      public var mBadassWins:int;
      
      public var mGlobalUnitCounts:*;
      
      public function GamePlayerProfile()
      {
         this.mLevelProgression = new Array();
         this.mSocialLevelProgression = new Array();
         this.mBadassLevelProgression = new Array();
         super();
         this.mLevel = 1;
         this.mXp = 0;
         this.mSocialLevel = 1;
         this.mSocialXp = 0;
         this.mBadassXp = 0;
         this.mBadassLevel = 1;
         this.mNeighborActionsLeft = 0;
         this.mMoney = 0;
         this.mPremium = 0;
         this.mLoaded = false;
         this.mLevelGained = false;
         this.mSocialLevelGained = false;
         this.mBadassLevelGained = false;
         this.mIdCounter = 0;
         this.mUnitCaps = new Object();
         this.mUnitCounts = new Object();
         this.mWishList = new Wishlist();
         this.mEnergyRewardCounter = 0;
         this.mBadassWins = 0;
      }
      
      public function setProcessInitialValues(param1:ServerCall) : void
      {
         var _loc2_:* = param1.mData;
         this.mXp = _loc2_.resource_experience;
         this.mMoney = _loc2_.resource_money;
         this.mPremium = _loc2_.resource_premium;
         this.mEnergy = _loc2_.resource_energy;
         this.mSupplies = _loc2_.resource_supplies;
         this.mMaterial = _loc2_.resource_material;
         this.mSocialXp = _loc2_.resource_socialxp;
         this.mWater = _loc2_.resource_water;
         this.mSuppliesCap = _loc2_.supply_cap;
         this.mSecondsToRechargeEnergy = _loc2_.secs_to_energy_gain;
         this.mRewardDropSeedTerm = _loc2_.reward_drop_seed_term;
         this.mRewardDropsCounter = _loc2_.reward_drops_counter;
         this.mEnergyRewardCounter = _loc2_.resource_energy_percentiles;
         this.mSecsSinceLastEnemySpawn = _loc2_.secs_since_last_enemy_spawn;
      }
      
      public function setInitialValues(param1:ServerCall) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc7_:Item = null;
         var _loc8_:* = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:* = null;
         var _loc12_:ShopItem = null;
         this.mLoaded = true;
         var _loc2_:* = GameState.mConfig;
         this.setupLevelProgression(_loc2_.Levels);
         this.setupSocialLevelProgression(_loc2_.SocialLevels);
         this.setupBadassLevelProgression(_loc2_.BadassLevels);
         this.mInventory = new Inventory();
         var _loc3_:int = getTimer();
         var _loc6_:int = 8454143;
         if(param1 == null)
         {
            this.mTimeBetweenEnergyRecharges = Number(_loc2_.PlayerRechargeIntervals.Default.Energy) * 60;
            this.mSecsSinceLastEnemySpawn = 0;
            this.mXp = _loc2_.PlayerStartValues.Default.XP;
            if(!Config.CHEAT_GOD_MODE)
            {
               this.mMoney = _loc2_.PlayerStartValues.Default.Money;
            }
            else
            {
               this.mMoney = 1000000;
            }
            if(!Config.CHEAT_GOD_MODE)
            {
               this.mPremium = _loc2_.PlayerStartValues.Default.Premium;
            }
            else
            {
               this.mPremium = 1000;
            }
            if(!Config.CHEAT_GOD_MODE)
            {
               this.mEnergy = _loc2_.PlayerStartValues.Default.Energy;
            }
            else
            {
               this.mEnergy = 7500;
            }
            if(!Config.CHEAT_GOD_MODE)
            {
               this.mSupplies = _loc2_.PlayerStartValues.Default.Supplies;
            }
            else
            {
               this.mSupplies = 59500;
            }
            this.mMaterial = _loc2_.PlayerStartValues.Default.Material;
            this.mSocialXp = _loc2_.PlayerStartValues.Default.SocialXP;
            this.mWater = _loc2_.PlayerStartValues.Default.Water;
            if(!Config.CHEAT_GOD_MODE)
            {
               this.mSuppliesCap = _loc2_.PlayerStartValues.Default.SuppliesCap;
            }
            else
            {
               this.mSuppliesCap = 60000;
            }
            this.mSecondsToRechargeEnergy = 0;
            _loc7_ = ItemManager.getItem("Intel","Intel");
            if(!Config.CHEAT_GOD_MODE)
            {
               this.mInventory.addItems(_loc7_,100);
            }
            else
            {
               this.mInventory.addItems(_loc7_,500);
            }
            _loc7_ = ItemManager.getItem("AllyReport","Intel");
            if(!Config.CHEAT_GOD_MODE)
            {
               this.mInventory.addItems(_loc7_,100);
            }
            else
            {
               this.mInventory.addItems(_loc7_,500);
            }
            if(!Config.CHEAT_GOD_MODE)
            {
               this.mMaxEnergy = this.getMaxEnergyForThisLevel();
            }
            else
            {
               this.mMaxEnergy = 7500;
            }
         }
         else
         {
            _loc8_ = param1.mData;
            this.mXp = _loc8_.resource_experience;
            this.mMoney = _loc8_.resource_money;
            this.mPremium = _loc8_.resource_premium;
            this.mEnergy = _loc8_.resource_energy;
            this.mSupplies = _loc8_.resource_supplies;
            this.mMaterial = _loc8_.resource_material;
            this.mSocialXp = _loc8_.resource_socialxp;
            this.mWater = _loc8_.resource_water;
            this.mSuppliesCap = _loc8_.supply_cap;
            this.mSecondsToRechargeEnergy = _loc8_.secs_to_energy_gain;
            this.mRewardDropSeedTerm = _loc8_.reward_drop_seed_term;
            this.mRewardDropsCounter = _loc8_.reward_drops_counter;
            this.mEnergyRewardCounter = _loc8_.resource_energy_percentiles;
            this.mInventory.initializeFromServer(_loc8_);
            this.mRecentlyGiftedEnergy = new Array();
            this.mRecentlyGiftedSupplies = new Array();
            this.mTimeBetweenEnergyRecharges = _loc8_.energy_recharge_time;
            this.mSecsSinceLastEnemySpawn = _loc8_.secs_since_last_enemy_spawn;
            _loc9_ = String(_loc8_.recently_gifted_energy_to);
            _loc10_ = String(_loc8_.recently_gifted_supplies_to);
            _loc9_ = DCUtils.trim(_loc9_);
            _loc10_ = DCUtils.trim(_loc10_);
            if(_loc9_.indexOf(",") == -1)
            {
               this.mRecentlyGiftedEnergy = [_loc9_];
            }
            else
            {
               this.mRecentlyGiftedEnergy = _loc9_.split(",");
            }
            if(_loc10_.indexOf(",") == -1)
            {
               this.mRecentlyGiftedSupplies = [_loc10_];
            }
            else
            {
               this.mRecentlyGiftedSupplies = _loc10_.split(",");
            }
            if(_loc8_.item_unlocks)
            {
               for each(_loc11_ in _loc8_.item_unlocks)
               {
                  if(_loc12_ = ItemManager.getItemByTableName(_loc11_.item_id,_loc11_.item_type) as ShopItem)
                  {
                     _loc12_.mEarlyUnlockBought = true;
                  }
               }
            }
            if(_loc8_.wishlist)
            {
               this.mWishList.setupFromServer(_loc8_.wishlist);
            }
            if(!Config.CHEAT_GOD_MODE)
            {
               this.mMaxEnergy = _loc8_.energy_cap;
            }
            else
            {
               this.mMaxEnergy = 7500;
            }
         }
         this.mLevel = this.getLevelForExperience(this.mXp);
         this.mSocialLevel = this.getSocialLevelForExperience(this.mSocialXp);
         this.mMaxNeighborActions = 5;
         this.setEnemySpawningLevel();
      }
      
      public function canGiftEnergyTo(param1:String) : Boolean
      {
         if(this.mRecentlyGiftedEnergy == null)
         {
            return true;
         }
         return this.mRecentlyGiftedEnergy.indexOf(param1) == -1;
      }
      
      public function canGiftSuppliesTo(param1:String) : Boolean
      {
         if(this.mRecentlyGiftedSupplies == null)
         {
            return true;
         }
         return this.mRecentlyGiftedSupplies.indexOf(param1) == -1;
      }
      
      public function addToRecentlyGifted(param1:String, param2:String) : void
      {
         if(param2 == FriendPanel.FRICTIONLESS_GIFT_ENERGY)
         {
            this.addToRecentlyGiftedEnergy(param1);
         }
         else if(param2 == FriendPanel.FRICTIONLESS_GIFT_SUPPLIES)
         {
            this.addToRecentlyGiftedSupplies(param1);
         }
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      private function addToRecentlyGiftedEnergy(param1:String) : void
      {
         if(this.mRecentlyGiftedEnergy.indexOf(param1) == -1)
         {
            this.mRecentlyGiftedEnergy.push(param1);
         }
      }
      
      private function addToRecentlyGiftedSupplies(param1:String) : void
      {
         if(this.mRecentlyGiftedSupplies.indexOf(param1) == -1)
         {
            this.mRecentlyGiftedSupplies.push(param1);
         }
      }
      
      public function useItem(param1:Item) : void
      {
         if(param1 is EnergyRefillItem)
         {
            this.addEnergy(EnergyRefillItem(param1).mEnergyGain);
         }
         else if(param1 is SupplyPackItem)
         {
            this.addSupplies(SupplyPackItem(param1).mSuppliesGain);
         }
		 else if(param1 is WaterPackItem)
         {
            this.addWater(WaterPackItem(param1).mWaterGain);
         }
      }
      
      private function setupLevelProgression(param1:*) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            this.mLevelProgression[_loc2_] = (param1[_loc2_] as Object).XPLimit;
         }
         this.mLevelConfig = param1;
      }
      
      private function setupSocialLevelProgression(param1:*) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            this.mSocialLevelProgression[_loc2_] = (param1[_loc2_] as Object).SocialXPLimit;
         }
      }
      
      private function setupBadassLevelProgression(param1:*) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            this.mBadassLevelProgression[_loc2_] = (param1[_loc2_] as Object).BadassPointLimit;
         }
      }
      
      private function getLevelForExperience(param1:int) : int
      {
         var _loc2_:* = this.mLevelProgression.length - 1;
         while(_loc2_ >= 0)
         {
            if(param1 >= this.mLevelProgression[_loc2_])
            {
               return _loc2_;
            }
            _loc2_--;
         }
         return 0;
      }
      
      public function getSocialLevelForExperience(param1:int) : int
      {
         var _loc2_:* = this.mSocialLevelProgression.length - 1;
         while(_loc2_ >= 0)
         {
            if(param1 >= this.mSocialLevelProgression[_loc2_])
            {
               return _loc2_;
            }
            _loc2_--;
         }
         return 0;
      }
      
      public function getBadassLevelForExperience(param1:int) : int
      {
         var _loc2_:* = this.mBadassLevelProgression.length - 1;
         while(_loc2_ >= 1)
         {
            if(param1 >= this.mBadassLevelProgression[_loc2_])
            {
               return _loc2_;
            }
            _loc2_--;
         }
         return 1;
      }
      
      private function getMaxEnergyForThisLevel() : int
      {
         var _loc1_:int = 0;
         if(!Config.CHEAT_GOD_MODE)
         {
            _loc1_ = int((this.mLevelConfig[this.mLevel] as Object).MaxEnergy);
         }
         else
         {
            _loc1_ = 7500;
         }
         return _loc1_;
      }
      
      private function getPremiumRewardForThisLevel() : int
      {
         return (this.mLevelConfig[this.mLevel] as Object).RewardPremium;
      }
      
      public function getXpForLevel(param1:int) : int
      {
         return this.mLevelProgression[param1];
      }
      
      public function getXpForNextLevel() : int
      {
         if(this.mLevel + 1 < this.mLevelProgression.length)
         {
            return this.mLevelProgression[this.mLevel + 1];
         }
         return this.getXpForThisLevel();
      }
      
      public function getXpForThisLevel() : int
      {
         return this.mLevelProgression[this.mLevel];
      }
      
      public function getSocialXpForNextLevel() : int
      {
         if(this.mSocialLevel + 1 < this.mSocialLevelProgression.length)
         {
            return this.mSocialLevelProgression[this.mSocialLevel + 1];
         }
         return this.getSocialXpForThisLevel();
      }
      
      public function getSocialXpForThisLevel() : int
      {
         return this.mSocialLevelProgression[this.mSocialLevel];
      }
      
      public function isLoaded() : Boolean
      {
         return this.mLoaded;
      }
      
      public function wasLevelGained() : Boolean
      {
         var _loc1_:* = null;
         if(this.mLevelGained)
         {
            if(WebUtils.getExternalInterfaceAvailable())
            {
               WebUtils.externalInterfaceCallWrapper("charlieFunctions.setGameLevel",this.mLevel);
            }
            this.mSecondsToRechargeEnergy = this.mTimeBetweenEnergyRecharges;
            this.mMaxEnergy = this.getMaxEnergyForThisLevel();
            this.setEnergy(Math.max(this.mMaxEnergy,this.mEnergy));
            this.addPremium(this.getPremiumRewardForThisLevel());
            this.setEnemySpawningLevel();
            this.mLevelGained = false;
            MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_LEVEL,MagicBoxTracker.TYPE_LEVEL_REACHED,"" + this.mLevel);
            return true;
         }
         return false;
      }
      
      public function wasSocialLevelGained() : Boolean
      {
         var _loc1_:Boolean = this.mSocialLevelGained;
         this.mSocialLevelGained = false;
         return _loc1_;
      }
      
      public function wasBadassLevelGained() : Boolean
      {
         var _loc1_:Boolean = this.mBadassLevelGained;
         this.mBadassLevelGained = false;
         return _loc1_;
      }
      
      public function hasCompleteCollection(param1:ItemCollectionItem) : Boolean
      {
         return param1.playerOwns();
      }
      
      public function hasBookmarked() : Boolean
      {
         return this.mHasBookmarkedGame;
      }
      
      public function hasGivenHisEmail() : Boolean
      {
         return this.mEmailAllowed;
      }
      
      private function setXp(param1:int) : void
      {
         this.mXp = param1;
         var _loc2_:* = this.mLevel;
         this.mLevel = this.getLevelForExperience(this.mXp);
         if(this.mLevel > _loc2_)
         {
            this.mLevelGained = true;
         }
         MissionManager.increaseCounter("Stockpile",ItemManager.getItem("XP","Resource"),0);
         MissionManager.increaseCounter("Own",ItemManager.getItem("XP","Resource"),0);
      }
      
      public function addXp(param1:int) : void
      {
         var _loc2_:* = this.mXp;
         this.setXp(this.mXp + param1);
         var _loc3_:Friend = FriendsCollection.smFriends.GetThePlayer();
         if(_loc3_)
         {
            _loc3_.mLevel = this.mLevel;
            _loc3_.mXp = this.mXp;
         }
         if(_loc2_ < GameState.mConfig.PlayerStartValues.Default.InviteFriendsPopupXPLimit)
         {
            if(this.mXp >= GameState.mConfig.PlayerStartValues.Default.InviteFriendsPopupXPLimit)
            {
               if(GameState.mInstance.mHUD)
               {
                  GameState.mInstance.mHUD.openInviteFriendsWindow();
               }
            }
         }
      }
      
      private function setMoney(param1:int) : void
      {
         this.mMoney = param1;
         MissionManager.increaseCounter("Stockpile",ItemManager.getItem("Money","Resource"),0);
         MissionManager.increaseCounter("Own",ItemManager.getItem("Money","Resource"),0);
      }
      
      public function addMoney(param1:int, param2:String = null, param3:* = null, param4:* = null) : void
      {
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         this.setMoney(this.mMoney + param1);
         if(param1 < 0)
         {
            if(param2 == null)
            {
               param2 = "ActionName Not Configured";
            }
            MagicBoxTracker.paramsAddGameCurrency(param3,-param1);
            MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_ECONOMY,MagicBoxTracker.TYPE_SPEND_CASH,param2,param3);
         }
         else
         {
            if(param4)
            {
               _loc6_ = Number(param4.mCostPremium) * 100;
               MagicBoxTracker.paramsTrackRealCurrency(param3,_loc6_,param4.mCashGain);
               param3["product"] = param4.mId;
               MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_ECONOMY,MagicBoxTracker.TYPE_BUY_CASH,MagicBoxTracker.LABEL_SUCCESS,param3);
            }

         }
      }
      
      public function addMoneyFailed(param1:int, param2:*, param3:String = null, param4:* = null) : void
      {
         param4["product"] = param2.mId;
         MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_ECONOMY,MagicBoxTracker.TYPE_BUY_CASH,MagicBoxTracker.LABEL_FAIL,param4);
      }
      
      public function addPremium(param1:int, param2:String = null, param3:* = null, param4:* = null) : void
      {
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:int = 0;
         var _loc8_:* = null;
         if(GameState.mInstance.mPlayerProfile.getPremium() > this.mPremium + param1)
         {
            _loc5_ = {
               "gold":-param1,
               "ver":1
            };
            GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.DEDUCT_GOLD_AND_CASH,_loc5_,false);
         }
         this.setPremium(this.mPremium + param1);
         if(param1 < 0)
         {
            if(param2 == null)
            {
               param2 = "SPEND_PC";
            }
            MagicBoxTracker.paramsTrackPremiumCurrency(param3,-param1);
            MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_ECONOMY,MagicBoxTracker.TYPE_SPEND_PC,param2,param3);

         }
         else
         {
            if(param4)
            {
               _loc7_ = Number(param4.mCostPremium) * 100;
               MagicBoxTracker.paramsTrackRealCurrency(param3,_loc7_,param4.mGoldGain);
               param3["product"] = param4.mId;
               MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_ECONOMY,MagicBoxTracker.TYPE_BUY_PC,MagicBoxTracker.LABEL_SUCCESS,param3);
            }
 
         }
      }
      
      public function addPremiumFailed(param1:int, param2:*, param3:String = null, param4:* = null) : void
      {
         param4["product"] = param2.mId;
         MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_ECONOMY,MagicBoxTracker.TYPE_BUY_PC,MagicBoxTracker.LABEL_FAIL,param4);
      }
      
      private function setPremium(param1:int) : void
      {
         this.mPremium = param1;
         MissionManager.increaseCounter("Stockpile",ItemManager.getItem("Premium","Resource"),0);
         MissionManager.increaseCounter("Own",ItemManager.getItem("Premium","Resource"),0);
      }
      
      public function getPremium() : int
      {
         return this.mPremium;
      }
      
      public function setPic(param1:String) : void
      {
         if(param1 != null)
         {
            this.mPic = param1;
         }
      }
      
      public function setEnergy(param1:int) : void
      {
         this.mEnergy = param1;
         MissionManager.increaseCounter("Stockpile",ItemManager.getItem("Energy","Resource"),0);
         MissionManager.increaseCounter("Own",ItemManager.getItem("Energy","Resource"),0);
      }
      
      public function addEnergy(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:* = null;
         this.setEnergy(this.mEnergy + param1);

         if(this.mEnergy == 0)
         {
            if(param2)
            {
               this.mOutOfEnergyAppearTimer = new Timer(2000);
               this.mOutOfEnergyAppearTimer.addEventListener(TimerEvent.TIMER,this.appearTimerTick);
               this.mOutOfEnergyAppearTimer.start();
            }
         }
      }
      
      public function setMapResource(param1:int) : void
      {
         var _loc2_:String = String(GameState.mInstance.mMapData.mMapSetupData.Resource);
         if(_loc2_ == "Water")
         {
            this.mWater = param1;
         }
      }
      
      public function addMapResource(param1:int) : void
      {
         var _loc2_:String = String(GameState.mInstance.mMapData.mMapSetupData.Resource);
         if(_loc2_ == "Water")
         {
            this.mWater += param1;
         }
      }
      
      public function appearTimerTick(param1:TimerEvent) : void
      {
         if(this.mOutOfEnergyAppearTimer)
         {
            this.removeOutOfEnergyTimer();
            if(this.mEnergy == 0)
            {
               GameState.mInstance.getHud().openOutOfEnergyWindow();
            }
         }
      }
      
      public function removeOutOfEnergyTimer() : void
      {
         if(this.mOutOfEnergyAppearTimer)
         {
            this.mOutOfEnergyAppearTimer.stop();
            this.mOutOfEnergyAppearTimer.removeEventListener(TimerEvent.TIMER,this.appearTimerTick);
            this.mOutOfEnergyAppearTimer = null;
         }
      }
      
      private function setMaterial(param1:int) : void
      {
         this.mMaterial = param1;
         MissionManager.increaseCounter("Stockpile",ItemManager.getItem("Material","Resource"),0);
         MissionManager.increaseCounter("Own",ItemManager.getItem("Material","Resource"),0);
      }
      
      public function addMaterial(param1:int) : void
      {
         this.setMaterial(this.mMaterial + param1);
      }
      
      private function setSupplies(param1:int) : void
      {
         this.mSupplies = param1;
         MissionManager.increaseCounter("Stockpile",ItemManager.getItem("Supplies","Resource"),0);
         MissionManager.increaseCounter("Own",ItemManager.getItem("Supplies","Resource"),0);
      }
      
      public function addSupplies(param1:int, param2:String = null, param3:* = null) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = null;
         this.setSupplies(this.mSupplies + param1);
         if(param1 < 0)
         {
            if(param2 == null)
            {
               param2 = "ActionName Not Configured";
            }
            MagicBoxTracker.paramsAddSupplyResource(param3,-param1);
            MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_ECONOMY,MagicBoxTracker.TYPE_SPEND_SUPPLY,param2,param3);

         }
      }
      
      private function setSocialXp(param1:int) : void
      {
         this.mSocialXp = param1;
         var _loc2_:* = this.mSocialLevel;
         this.mSocialLevel = this.getSocialLevelForExperience(this.mSocialXp);
         if(this.mSocialLevel > _loc2_)
         {
            this.mSocialLevelGained = true;
         }
         MissionManager.increaseCounter("Stockpile",ItemManager.getItem("SocialXP","Resource"),0);
         MissionManager.increaseCounter("Own",ItemManager.getItem("SocialXP","Resource"),0);
      }
      
      public function addSocialXp(param1:int) : void
      {
         this.setSocialXp(this.mSocialXp + param1);
      }
      
      private function setBadassXp(param1:int) : void
      {
         this.mBadassXp = param1;
         var _loc2_:* = this.mBadassLevel;
         this.mBadassLevel = this.getBadassLevelForExperience(this.mBadassXp);
         if(this.mBadassLevel > _loc2_)
         {
            this.mBadassLevelGained = true;
         }
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      public function addBaddassXp(param1:int) : void
      {
         this.setBadassXp(this.mBadassXp + param1);
      }
      
      private function setWater(param1:int) : void
      {
         this.mWater = param1;
         MissionManager.increaseCounter("Stockpile",ItemManager.getItem("Water","Resource"),0);
         MissionManager.increaseCounter("Own",ItemManager.getItem("Water","Resource"),0);
      }
      
      public function addWater(param1:int) : void
      {
         this.setWater(this.mWater + param1);
      }
      
      public function setNeighborActions(param1:int) : void
      {
         this.mNeighborActionsLeft = param1;
      }
      
      public function addNeighborActions(param1:int) : void
      {
         this.setNeighborActions(this.mNeighborActionsLeft + param1);
         if(param1 < 0)
         {
            if(this.mNeighborActionsLeft == 0 && !GameState.mInstance.visitingTutor())
            {
               GameState.mInstance.mScene.mMapGUIEffectsLayer.clearHighlights();
               GameState.mInstance.mHUD.openOutOfSocialEnergyWindow();
            }
            else
            {
               GameState.mInstance.mScene.mMapGUIEffectsLayer.highlightNeighbourClickables();
            }
         }
      }
      
      public function getItemCount(param1:Item) : int
      {
         var _loc2_:String = null;
         if(param1.mType != "Resource")
         {
            return this.mInventory.getNumberOfItems(param1);
         }
         _loc2_ = param1.mId;
         switch(_loc2_)
         {
            case "Premium":
               return this.mPremium;
            case "Money":
               return this.mMoney;
            case "Energy":
               return this.mEnergy;
            case "XP":
               return this.mXp;
            case "Material":
               return this.mMaterial;
            case "SocialXP":
               return this.mSocialXp;
            case "Supplies":
               return this.mSupplies;
            default:
               return 0;
         }
      }
      
      public function addItem(param1:Item, param2:int) : void
      {
         var _loc3_:String = null;
         if(param1.mType == "Resource")
         {
            _loc3_ = param1.mId;
            switch(_loc3_)
            {
               case "Premium":
                  this.addPremium(param2);
                  break;
               case "Money":
                  this.addMoney(param2);
                  break;
               case "Energy":
                  this.addEnergy(param2);
                  break;
               case "XP":
                  this.addXp(param2);
                  break;
               case "Material":
                  this.addMaterial(param2);
                  break;
               case "SocialXP":
                  this.addSocialXp(param2);
                  break;
               case "Supplies":
                  this.addSupplies(param2);
                  break;
               case "Water":
                  this.addWater(param2);
                  break;
               case "BadAssXP":
                  this.addBaddassXp(param2);
                  break;
               default:
                  Utils.LogError("invalid resource ");
            }
         }
         else
         {
            this.mInventory.addItems(param1,param2);
         }
      }
      
      public function rechargeTimerTick() : void
      {
         --this.mSecondsToRechargeEnergy;
         if(this.mEnergy >= this.mMaxEnergy)
         {
            this.mSecondsToRechargeEnergy = this.mTimeBetweenEnergyRecharges;
         }
         else if(this.mSecondsToRechargeEnergy <= 0)
         {
            this.mSecondsToRechargeEnergy = this.mTimeBetweenEnergyRecharges;
            this.setEnergy(Math.min(this.mEnergy + 1,this.mMaxEnergy));
         }
      }
      
      public function getNextId() : int
      {
         return this.mIdCounter++;
      }
      
      public function updateUnitCaps() : void
      {
         var _loc3_:Renderable = null;
         var _loc4_:ConstructionObject = null;
         var _loc5_:ConstructionItem = null;
         if(GameState.mInstance.visitingFriend())
         {
            return;
         }
         var _loc1_:* = GameState.mConfig;
		 if(_loc1_.MapSetup[GameState.mInstance.mCurrentMapId].hasOwnProperty("UnitCapInfantry")){
			 // Use map-specific values
			 this.mUnitCaps.Infantry = int(_loc1_.MapSetup[GameState.mInstance.mCurrentMapId].UnitCapInfantry);
			 this.mUnitCaps.Armor = int(_loc1_.MapSetup[GameState.mInstance.mCurrentMapId].UnitCapArmor);
			 this.mUnitCaps.Artillery = int(_loc1_.MapSetup[GameState.mInstance.mCurrentMapId].UnitCapArtillery);
		 } else {
			 // Use default values
			 this.mUnitCaps.Infantry = int(_loc1_.PlayerStartValues.Default.UnitCapInfantry);
			 this.mUnitCaps.Armor = int(_loc1_.PlayerStartValues.Default.UnitCapArmor);
			 this.mUnitCaps.Artillery = int(_loc1_.PlayerStartValues.Default.UnitCapArtillery);
		 }
         this.mUnitCounts.Infantry = 0;
         this.mUnitCounts.Armor = 0;
         this.mUnitCounts.Artillery = 0;
         var _loc2_:Array = GameState.mInstance.mScene.mAllElements;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ is ConstructionObject)
            {
               if((_loc4_ = _loc3_ as ConstructionObject).mHasBeenCompleted)
               {
                  _loc5_ = _loc4_.mItem as ConstructionItem;
                  this.mUnitCaps.Infantry += _loc5_.mUnitCapIncrements.Infantry;
                  this.mUnitCaps.Armor += _loc5_.mUnitCapIncrements.Armor;
                  this.mUnitCaps.Artillery += _loc5_.mUnitCapIncrements.Artilery;
               }
            }
            else if(!(_loc3_ is DecorationObject))
            {
               if(_loc3_ is PlayerUnit)
               {
                  this.mUnitCounts[_loc3_.mItem.mType] += 1;
               }
            }
         }
      }
      
      public function increaseSuppliesCap(param1:Renderable) : void
      {
         var _loc2_:DecorationItem = param1.mItem as DecorationItem;
         this.mSuppliesCap += _loc2_.mSuppliesCapIncrement;
      }
      
      public function decreaseSuppliesCap(param1:Renderable) : void
      {
         var _loc2_:DecorationItem = param1.mItem as DecorationItem;
         this.mSuppliesCap -= _loc2_.mSuppliesCapIncrement;
      }
      
      public function capAvailable(param1:String) : Boolean
      {
         return this.mUnitCounts[param1] < this.mUnitCaps[param1];
      }
      
      public function getUnitCap(param1:String) : int
      {
         return this.mUnitCaps[param1];
      }
      
      public function getUnitCount(param1:String) : int
      {
         return this.mUnitCounts[param1];
      }
      
      public function increaseEnergyRewardCounter(param1:int) : void
      {
         this.mEnergyRewardCounter += param1;
      }
      
      public function getBonusEnergy() : int
      {
         var _loc1_:int = 0;
         if(this.mEnergyRewardCounter >= 100)
         {
            _loc1_ = this.mEnergyRewardCounter / 100;
            this.mEnergyRewardCounter %= 100;
         }
         return _loc1_;
      }
      
      public function setEnemySpawningLevel() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         for(_loc2_ in GameState.mConfig.SpawnLevels)
         {
            _loc1_ = _loc2_ as int;
            if(_loc1_ <= this.mLevel)
            {
               if(_loc1_ > this.mSpawnEnemyLevel)
               {
                  this.mSpawnEnemyLevel = _loc1_;
               }
            }
         }
      }
      
      public function getActiveRankMission() : Mission
      {
         return RankManager.getMissionByIndex(this.mRankIdx);
      }
      
      public function getRewardDropsCounter() : int
      {
         return this.mRewardDropsCounter++;
      }
      
      public function getMapResourceAmount() : int
      {
         var _loc1_:String = String(GameState.mInstance.mMapData.mMapSetupData.Resource);
         if(_loc1_ == "Water")
         {
            return this.mWater;
         }
         return 0;
      }
      
      public function hasEnoughMapResource(param1:int) : Boolean
      {
         if(!GameState.mInstance.mMapData.mMapSetupData.Resource || (GameState.mInstance.mMapData.mMapSetupData.Resource as String).length == 0)
         {
            return true;
         }
         return this.getMapResourceAmount() >= param1;
      }
      
      public function getBadassName() : String
      {
         return (GameState.mConfig.BadassLevels[this.mBadassLevel] as Object).BadassName as String;
      }
      
      public function setupGlobalUnitCounts(param1:*) : void
      {
         var _loc2_:* = null;
         if(param1.player_unit_count)
         {
            this.mGlobalUnitCounts = new Object();
            for each(_loc2_ in param1.player_unit_count)
            {
               if(_loc2_.item_count > 0)
               {
                  this.mGlobalUnitCounts[_loc2_.item_id] = _loc2_.item_count;
               }
            }
         }
      }
      
      public function addUnit(param1:PlayerUnitItem) : void
      {
         if(this.mGlobalUnitCounts != null)
         {
            if(this.mGlobalUnitCounts[param1.mId] != null)
            {
               ++this.mGlobalUnitCounts[Number(param1.mId)];
            }
            else
            {
               this.mGlobalUnitCounts[param1.mId] = 1;
            }
         }
      }
      
      public function removeUnit(param1:PlayerUnitItem) : void
      {
         if(this.mGlobalUnitCounts != null)
         {
            --this.mGlobalUnitCounts[Number(param1.mId)];
         }
      }
      
      public function setupPvPData(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:Array = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:Friend = null;
         this.mBadassXp = param1.pvp_data.score;
         this.mBadassLevel = this.getBadassLevelForExperience(this.mBadassXp);
         this.mBadassWins = param1.pvp_data.wins;
         for each(_loc2_ in param1.allies)
         {
            if((_loc6_ = FriendsCollection.smFriends.GetFriend(_loc2_.facebook_id)) == null)
            {
               if(Config.DEBUG_MODE)
               {
                  Utils.LogError("Couldn\'t find an ally from the friend collection: " + _loc2_.facebook_id);
               }
            }
            else
            {
               _loc6_.mBadassXp = _loc2_.score;
               _loc6_.mBadassLevel = _loc2_.level;
               _loc6_.mPvPWins = _loc2_.wins;
            }
         }
         _loc3_ = new Array();
         for each(_loc4_ in param1.possible_opponents)
         {
            PvPOpponentCollection.smCollection.addOpponent(_loc4_.facebook_id,_loc4_.score,_loc4_.level,_loc4_.wins, _loc4_.player_name, _loc4_.avatar);
            _loc3_.push(_loc4_.facebook_id);
         }
         for each(_loc5_ in param1.recent_attacks)
         {
            PvPOpponentCollection.smCollection.addRecentAttack(_loc5_.facebook_id,_loc5_.score,_loc5_.level,_loc5_.wins);
            _loc3_.push(_loc5_.facebook_id);
         }
      }
      
      public function setValuesFromOfflineSave(savedata:*) : void
      {
         var i:* = null;
         for(i in savedata)
         {
            if(i != "mWishList" && i != "mInventory")
            {
               this[i] = savedata[i];
            }
         }
      }
      
      public function getEnergyRewardCounter() : int
      {
         return this.mEnergyRewardCounter;
      }
   }
}
