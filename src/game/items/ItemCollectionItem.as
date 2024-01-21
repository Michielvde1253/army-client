package game.items
{
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class ItemCollectionItem extends Item
   {
       
      
      public var mOrder:int;
      
      public var mItems:Array;
      
      public var mRewardMoney:int;
      
      public var mRewardXP:int;
      
      public var mRewardSupplies:int;
      
      public var mRewardEnergy:int;
      
      public var mRewardItems:Array;
      
      public function ItemCollectionItem(param1:Object)
      {
         var _loc2_:Object = null;
         var _loc3_:CollectibleItem = null;
         var _loc4_:Object = null;
         super(param1);
         this.mOrder = param1.Order;
         this.mRewardMoney = param1.RewardMoney;
         this.mRewardXP = param1.RewardXP;
         this.mRewardSupplies = param1.RewardSupplies;
         this.mRewardEnergy = param1.RewardEnergy;
         this.mItems = new Array();
         this.mRewardItems = new Array();
         if(param1.Items.ID)
         {
            this.mItems.push(ItemManager.getItem(param1.Items.ID,param1.Items.Type));
         }
         else
         {
            for each(_loc2_ in param1.Items)
            {
               _loc3_ = ItemManager.getItem(_loc2_.ID,_loc2_.Type) as CollectibleItem;
               if(_loc3_)
               {
                  this.mItems.push(_loc3_);
               }
            }
         }
         if(param1.RewardItems)
         {
            if(param1.RewardItems.ID)
            {
               this.mRewardItems.push(ItemManager.getItem(param1.RewardItems.ID,param1.RewardItems.Type));
            }
            else
            {
               for each(_loc4_ in param1.RewardItems)
               {
                  this.mRewardItems.push(ItemManager.getItem(_loc4_.ID,_loc4_.Type));
               }
               this.mRewardItems.sort(this.sorter);
            }
         }
      }
      
      public function getItems() : Array
      {
         return this.mItems;
      }
      
      public function getRewardsText() : String
      {
         var _loc2_:Item = null;
         var _loc1_:* = "";
         if(this.mRewardEnergy > 0)
         {
            _loc1_ = _loc1_ + this.mRewardEnergy + " " + GameState.getText("ENERGY");
         }
         if(this.mRewardMoney > 0)
         {
            if(_loc1_.length != 0)
            {
               _loc1_ += "\n";
            }
            _loc1_ = _loc1_ + this.mRewardMoney + " " + GameState.getText("MONEY");
         }
         if(this.mRewardSupplies > 0)
         {
            if(_loc1_.length != 0)
            {
               _loc1_ += "\n";
            }
            _loc1_ = _loc1_ + this.mRewardSupplies + " " + GameState.getText("SUPPLIES");
         }
         if(this.mRewardXP > 0)
         {
            if(_loc1_.length != 0)
            {
               _loc1_ += "\n";
            }
            _loc1_ = _loc1_ + this.mRewardXP + " " + GameState.getText("XP");
         }
         var _loc3_:int = int(this.mRewardItems.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mRewardItems[_loc4_] as Item;
            if(_loc1_.length != 0)
            {
               _loc1_ += "\n";
            }
            _loc1_ += _loc2_.mName;
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function playerOwns() : Boolean
      {
         var _loc2_:Item = null;
         var _loc1_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         var _loc3_:int = int(this.mItems.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mRewardItems[_loc4_] as Item;
            if(_loc1_.getItemCount(_loc2_) <= 0)
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
      
      private function sorter(param1:Item, param2:Item) : int
      {
         if(param1.mName > param2.mName)
         {
            return 1;
         }
         return -1;
      }
   }
}
