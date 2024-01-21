package game.player
{
   import game.battlefield.MapData;
   import game.gameElements.EnemyInstallationObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.items.AreaItem;
   import game.items.Item;
   import game.items.ItemManager;
   import game.missions.MissionManager;
   import game.states.GameState;
   
   public class Inventory
   {
       
      
      private var mInventory:Object;
      
      private var mFriendAreas:Array;
      
      public var mInventoryChangedForGetAreas:Boolean = true;
      
      private var mCurrentMapAreas:Array = null;
      
      public function Inventory()
      {
         this.mInventory = new Object();
         super();
         this.clear();
      }
      
      private function clear() : void
      {
         this.mInventoryChangedForGetAreas = true;
         this.mInventory.Ingredient = new Array();
         this.mInventory.Collectible = new Array();
         this.mInventory.Intel = new Array();
         this.mInventory.Area = new Array();
         this.mInventory.Medal = new Array();
         this.mInventory.Misc = new Array();
         this.mInventory.PowerUp = new Array();
         this.mInventory.SupplyPack = new Array();
         this.mInventory.EnergyRefill = new Array();
         this.mInventory.Booster = new Array();
      }
      
      public function initializeFromServer(param1:*) : void
      {
         var _loc3_:* = null;
         var _loc6_:Item = null;
         this.mInventoryChangedForGetAreas = true;
         this.clear();
         var _loc2_:Array = param1.inventory_items;
         var _loc4_:* = _loc2_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _loc2_[_loc5_] as Object;
            if(_loc6_ = ItemManager.getItemByTableName(_loc3_.item_id,_loc3_.item_type))
            {
               this.addItems(_loc6_,_loc3_.item_count);
            }
            else if(Config.DEBUG_MODE)
            {
               Utils.LogError("ERROR - User data contains invalid inventory item: " + _loc3_.item_id + " " + _loc3_.item_type);
            }
            _loc5_++;
         }
      }
      
      public function addItems(param1:Item, param2:int) : void
      {
         this.mInventoryChangedForGetAreas = true;
         if(this.mInventory[param1.mType])
         {
            this.addItemsToArray(this.mInventory[param1.mType],param1,param2);
            if(Config.DEBUG_MODE)
            {
            }
         }
         else
         {
            this.addItemsToArray(this.mInventory.Misc,param1,param2);
            if(Config.DEBUG_MODE)
            {
            }
         }
         if(GameState.mInstance.mHUD)
         {
            GameState.mInstance.mHUD.mCheckFireCallHint = true;
         }
      }
      
      private function addItemsToArray(param1:Array, param2:Item, param3:int) : void
      {
         var _loc5_:int = 0;
         this.mInventoryChangedForGetAreas = true;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(Item(param1[_loc4_]).mId == param2.mId)
            {
               if((_loc5_ = param1[_loc4_ + 1] + param3) > 0)
               {
                  param1[_loc4_ + 1] = _loc5_;
               }
               else
               {
                  param1.splice(_loc4_,2);
               }
               MissionManager.increaseCounter("StockpileItems",param2,0);
               MissionManager.increaseCounter("OwnItems",param2,0);
               return;
            }
            _loc4_ += 2;
         }
         if(param3 > 0)
         {
            param1.push(param2);
            param1.push(param3);
         }
         MissionManager.increaseCounter("StockpileItems",param2,0);
         MissionManager.increaseCounter("OwnItems",param2,0);
      }
      
      public function getNumberOfItems(param1:Item) : int
      {
         if(this.mInventory[param1.mType])
         {
            return this.getNumberOfItemsInArray(this.mInventory[param1.mType],param1);
         }
         return this.getNumberOfItemsInArray(this.mInventory.Misc,param1);
      }
      
      private function getNumberOfItemsInArray(param1:Array, param2:Item) : int
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(Item(param1[_loc3_]).mId == param2.mId)
            {
               return param1[_loc3_ + 1];
            }
            _loc3_ += 2;
         }
         return 0;
      }
      
      public function getIngredients() : Array
      {
         return this.mInventory.Ingredient;
      }
      
      public function getCollectibles() : Array
      {
         return this.mInventory.Collectible;
      }
      
      public function getBoosters() : Array
      {
         return this.mInventory.Booster;
      }
      
      public function getIntels() : Array
      {
         return this.mInventory.Intel;
      }
      
      public function getAreas(param1:Boolean = false) : Array
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:AreaItem = null;
         if(GameState.mInstance.visitingFriend() && !Config.OFFLINE_MODE)
         {
            return this.mFriendAreas;
         }
         if(!param1)
         {
            return this.mInventory.Area;
         }
         if(this.mInventoryChangedForGetAreas || !this.mCurrentMapAreas)
         {
            _loc2_ = GameState.mInstance.mCurrentMapId;
            trace(_loc2_);
            _loc3_ = new Array();
            _loc4_ = 0;
            trace(this.mInventory.Area.length);
            while(_loc4_ < this.mInventory.Area.length)
            {
               if(_loc5_ = this.mInventory.Area[_loc4_])
               {
                  trace(_loc5_.mMapId);
                  if(_loc5_.mMapId == _loc2_)
                  {
                     _loc3_.push(_loc5_);
                     _loc3_.push(this.mInventory.Area[_loc4_ + 1]);
                  }
               }
               _loc4_ += 2;
            }
            this.mCurrentMapAreas = _loc3_;
            this.mInventoryChangedForGetAreas = false;
            return _loc3_;
         }
         return this.mCurrentMapAreas;
      }
      
      public function getMedals() : Array
      {
         return this.mInventory.Medal;
      }
      
      public function getMisc() : Array
      {
         return this.mInventory.Misc;
      }
      
      public function getPowerUps() : Array
      {
         return this.mInventory.PowerUp;
      }
      
      public function getEnergyRefills() : Array
      {
         return this.mInventory.EnergyRefill;
      }
      
      public function getSupplyPacks() : Array
      {
         return this.mInventory.SupplyPack;
      }
      
      public function initFriendAreas() : void
      {
         var _loc2_:Item = null;
         var _loc5_:AreaItem = null;
         this.mInventoryChangedForGetAreas = true;
         this.mFriendAreas = new Array();
         var _loc1_:Array = ItemManager.getItemList();
         var _loc3_:* = _loc1_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _loc1_[_loc4_] as Item;
            if(_loc2_ is AreaItem)
            {
               if((_loc5_ = _loc2_ as AreaItem).mMapId == GameState.mInstance.mCurrentMapId)
               {
                  if(this.isFriendlyTilesInArea(_loc5_))
                  {
                     this.mFriendAreas.push(_loc5_);
                     this.mFriendAreas.push(1);
                  }
               }
            }
            _loc4_++;
         }
      }
      
      private function isFriendlyTilesInArea(param1:AreaItem) : Boolean
      {
         var _loc4_:* = 0;
         var _loc5_:GridCell = null;
         var _loc2_:IsometricScene = GameState.mInstance.mScene;
         var _loc3_:* = param1.mY;
         while(_loc3_ < param1.mY + param1.mHeight)
         {
            _loc4_ = param1.mX;
            while(_loc4_ < param1.mX + param1.mWidth)
            {
               if((_loc5_ = _loc2_.getCellAt(_loc4_,_loc3_)).mOwner == MapData.TILE_OWNER_FRIENDLY)
               {
                  return true;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function isEnemyInstallationsInArea(param1:AreaItem) : Boolean
      {
         var _loc3_:EnemyInstallationObject = null;
         var _loc6_:GridCell = null;
         var _loc2_:Array = GameState.mInstance.mScene.getEnemyInstallations();
         var _loc4_:* = _loc2_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _loc2_[_loc5_] as EnemyInstallationObject;
            if(_loc6_ = _loc3_.getCell())
            {
               if(_loc6_.mPosI >= param1.mX)
               {
                  if(_loc6_.mPosI < param1.mX + param1.mWidth)
                  {
                     if(_loc6_.mPosJ >= param1.mY)
                     {
                        if(_loc6_.mPosJ < param1.mY + param1.mHeight)
                        {
                           return true;
                        }
                     }
                  }
               }
            }
            _loc5_++;
         }
         return false;
      }
      
      public function getInventory() : *
      {
         return this.mInventory;
      }
      
      public function getFriendAreas() : Array
      {
         return this.mFriendAreas;
      }
      
      public function getCurrentMapAreas() : Array
      {
         return this.mCurrentMapAreas;
      }
      
      public function setInventoryFromOfflineSave(savedata:*) : void
      {
         var i:* = 0;
         var j:int = 0;
         var invtype:Array = [];
         var item:Item = null;
         var amount:int = 0;
         trace(savedata);
         for(i in savedata["mInventory"])
         {
            trace(i);
            invtype = savedata["mInventory"][i];
            trace(invtype);
            j = 0;
            while(j < invtype.length)
            {
               if(invtype[j]["mType"] == "Area")
               {
                  invtype[j]["mType"] = "MapArea";
               }
               item = ItemManager.getItemByTableName(invtype[j]["mId"],invtype[j]["mType"]);
               j++;
               amount = int(invtype[j]);
               this.addItems(item,amount);
               j++;
            }
         }
         this.mInventoryChangedForGetAreas = true;
         this.mFriendAreas = savedata["mFriendAreas"];
         this.getAreas();
      }
   }
}
