package game.items
{
   public class BoosterItem extends ShopItem
   {
       
      
      public var mHealthBoost:int;
      
      public var mPowerBoost:int;
      
      public var mRangeBoost:int;
      
      public function BoosterItem(param1:Object)
      {
         super(param1);
         this.mHealthBoost = param1.HealthBoost;
         this.mPowerBoost = param1.PowerBoost;
         this.mRangeBoost = param1.RangeBoost;
      }
   }
}
