package game.items
{
   import game.states.GameState;
   
   public class ItemManager
   {
      
      private static var mItemList:Array;
      
      private static var mItemListByTableName:Array;
      
      private static var mTableNameForItem:Array;
       
      
      public function ItemManager()
      {
         super();
      }
      
      public static function initialize() : void
      {
         mItemList = new Array();
         mItemListByTableName = new Array();
         mTableNameForItem = new Array();
         addItems("HomeFrontEffort",createHFE);
         addItems("PermanentHFE",createPermanentHFE);
         addItems("HFEDrives",createHFEDrive);
         addItems("BuildingDrives",createBuildingDrive);
         addItems("Building",createConstructionItem);
         addItems("ResourceBuilding",createResourceBuildingItem);
         addItems("PlayerUnit",createPlayerUnitItem);
         addItems("EnemyUnit",createEnemyUnitItem);
         addItems("EnemyAppearanceSetup",createEnemyAppearanceSetup);
         addItems("EnemyInstallation",createEnemyInstallationItem);
         addItems("PlayerInstallation",createPlayerInstallationItem);
         addItems("EnergyRefill",createEnergyRefillItem);
         addItems("Debris",createDebrisItem);
         addItems("Deco",createDecorationItem);
         addItems("MapArea",createAreaItem);
         addItems("Booster",createBoosterItem);
         addItems("SupplyPack",createSupplyPackItem);
         addItems("BuyGold",createBuyGoldItem);
         addItems("BuyCash",createBuyGoldItem);
         addItems("Resource",createResourceItem);
         addItems("Ingredient",createResourceItem);
         addItems("Intel",createResourceItem);
         addItems("Medal",createResourceItem);
         addItems("AllyReport",createResourceItem);
         addItems("Collectible",createCollectibleItem);
         addItems("Collections",createItemCollectionItem);
         addItems("FireMission",createFireMissionItem);
         addItems("PowerUp",createPowerUpItem);
         addItems("Timers",createTimerItem);
		 addItems("WaterPack",createWaterPackItem);
      }
      
      private static function addItems(param1:String, param2:Function) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Item = null;
         var _loc6_:String = null;
         var _loc3_:Object = GameState.mConfig[param1];
         if(!_loc3_)
         {
            return;
         }
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.hasOwnProperty("RewardXp"))
            {
               _loc4_.RewardXP = _loc4_.RewardXp;
            }
            else if(_loc4_.hasOwnProperty("RewardXP"))
            {
               _loc4_.RewardXp = _loc4_.RewardXP;
            }
            (_loc5_ = param2(_loc4_)).initGraphics(_loc4_);
            _loc6_ = _loc5_.mType + "_" + _loc5_.mId;
            mItemList[_loc6_] = _loc5_;
            mTableNameForItem[_loc6_] = param1;
            _loc6_ = param1 + "_" + _loc5_.mId;
            mItemListByTableName[_loc6_] = _loc5_;
         }
         mItemList[_loc6_] = _loc5_;
         param2 = null;
      }
      
      private static function createHFE(param1:Object) : Item
      {
         if(param1.Type == "HFEPlot")
         {
            return new HFEPlotItem(param1);
         }
         return new HFEItem(param1);
      }
      
      private static function createPermanentHFE(param1:Object) : Item
      {
         return new PermanentHFEItem(param1);
      }
      
      private static function createEnemyAppearanceSetup(param1:Object) : Item
      {
         return new EnemyAppearanceSetupItem(param1);
      }
      
      private static function createHFEDrive(param1:Object) : Item
      {
         return new HFEDriveItem(param1);
      }
      
      private static function createBuildingDrive(param1:Object) : Item
      {
         return new BuildingDriveItem(param1);
      }
      
      private static function createPlayerUnitItem(param1:Object) : Item
      {
         return new PlayerUnitItem(param1);
      }
      
      private static function createEnemyUnitItem(param1:Object) : Item
      {
         return new EnemyUnitItem(param1);
      }
      
      private static function createEnemyInstallationItem(param1:Object) : Item
      {
         return new EnemyInstallationItem(param1);
      }
      
      private static function createPlayerInstallationItem(param1:Object) : Item
      {
         return new PlayerInstallationItem(param1);
      }
      
      private static function createEnergyRefillItem(param1:Object) : Item
      {
         return new EnergyRefillItem(param1);
      }
      
      private static function createDebrisItem(param1:Object) : Item
      {
         return new DebrisItem(param1);
      }
      
      private static function createConstructionItem(param1:Object) : Item
      {
         return new ConstructionItem(param1);
      }
      
      private static function createResourceBuildingItem(param1:Object) : Item
      {
         return new ResourceBuildingItem(param1);
      }
      
      private static function createDecorationItem(param1:Object) : Item
      {
         if(param1.Type == "Signal")
         {
            return new SignalItem(param1);
         }
         return new DecorationItem(param1);
      }
      
      private static function createResourceItem(param1:Object) : Item
      {
         return new ResourceItem(param1);
      }
      
      private static function createCollectibleItem(param1:Object) : Item
      {
         return new CollectibleItem(param1);
      }
      
      private static function createItemCollectionItem(param1:Object) : Item
      {
         return new ItemCollectionItem(param1);
      }
      
      private static function createAreaItem(param1:Object) : Item
      {
         return new AreaItem(param1);
      }
      
      private static function createPowerUpItem(param1:Object) : Item
      {
         return new PowerUpItem(param1);
      }
      
      private static function createBoosterItem(param1:Object) : Item
      {
         return new BoosterItem(param1);
      }
      
      private static function createTimerItem(param1:Object) : Item
      {
         return new TimerItem(param1);
      }
      
      private static function createFireMissionItem(param1:Object) : Item
      {
         return new FireMissionItem(param1);
      }
      
      private static function createWaterPackItem(param1:Object) : Item
      {
         return new WaterPackItem(param1);
      }
      
      private static function createSupplyPackItem(param1:Object) : Item
      {
         return new SupplyPackItem(param1);
      }
      
      private static function createBuyGoldItem(param1:Object) : Item
      {
         if(param1.Type == "BuyCash")
         {
            return new BuyCashItem(param1);
         }
         return new BuyGoldItem(param1);
      }
      
      public static function getItemList() : Array
      {
         return mItemList;
      }
      
      public static function getItem(param1:String, param2:String) : Item
      {
         return mItemList[param2 + "_" + param1];
      }
      
      public static function getItemByTableName(param1:String, param2:String) : Item
      {
         return mItemListByTableName[param2 + "_" + param1];
      }
      
      public static function getTableNameForItem(param1:Item) : String
      {
         return mTableNameForItem[param1.mType + "_" + param1.mId];
      }
   }
}
