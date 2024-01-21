package game.items
{
   public class CollectibleItem extends ShopItem
   {
       
      
      public var mCollection:Object;
      
      public function CollectibleItem(param1:Object)
      {
         super(param1);
         this.mCollection = param1.Collection;
      }
   }
}
