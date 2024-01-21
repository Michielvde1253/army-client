package game.player
{
   import game.items.Item;
   import game.items.ItemManager;
   
   public class Wishlist
   {
      
      private static const WISHLIST_LENGTH:int = 5;
       
      
      public var mItems:Array;
      
      public var mEdited:Boolean = false;
      
      public function Wishlist()
      {
         super();
         this.mItems = new Array();
      }
      
      public function addToWishlist(param1:Item) : Boolean
      {
         var _loc2_:Item = null;
         for each(_loc2_ in this.mItems)
         {
            if(_loc2_.mId == param1.mId)
            {
               return false;
            }
         }
         if(this.mItems.length < WISHLIST_LENGTH)
         {
            this.mItems.push(param1);
            this.mEdited = true;
            return true;
         }
         return false;
      }
      
      public function getItemNro(param1:int) : Item
      {
         if(this.mItems.length > param1)
         {
            return this.mItems[param1];
         }
         return null;
      }
      
      public function removeItemNro(param1:int) : void
      {
         if(this.mItems.length > param1)
         {
            this.mItems.splice(param1,1);
            this.mEdited = true;
         }
      }
      
      public function removeFromWishlist(param1:Item) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.mItems.length)
         {
            if((this.mItems[_loc2_] as Item).mId == param1.mId)
            {
               this.mItems.splice(_loc2_,1);
               this.mEdited = true;
            }
            _loc2_++;
         }
      }
      
      public function setupFromServer(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Item = null;
         if(param1)
         {
            for each(_loc2_ in param1)
            {
               _loc3_ = ItemManager.getItemByTableName(_loc2_.item_id,_loc2_.item_type);
               if(_loc3_)
               {
                  this.addToWishlist(_loc3_);
               }
            }
         }
      }
   }
}
