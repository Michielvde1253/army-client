package game.items
{
   public class FireMissionItemSetItem extends Item
   {
       
      
      public var mItems:Array;
      
      public var mAmounts:Array;
      
      public function FireMissionItemSetItem(param1:Object)
      {
         super(param1);
         this.mItems = new Array();
         this.mAmounts = new Array();
         var _loc2_:int = 1;
         while(param1["Item" + _loc2_])
         {
            this.mItems[_loc2_ - 1] = ItemManager.getItem((param1["Item" + _loc2_] as Object).ID,(param1["Item" + _loc2_] as Object).Type);
            this.mAmounts[_loc2_ - 1] = param1["Amount" + _loc2_];
            _loc2_++;
         }
      }
   }
}
