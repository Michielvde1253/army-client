package game.items
{
   import game.states.GameState;
   
   public class WaterPackItem extends ShopItem
   {
       
      
      public var mWaterGain:int;
      
      public function WaterPackItem(param1:Object)
      {
         super(param1);
         this.mWaterGain = param1.WaterGain;
      }
      
      override public function getDescription() : String
      {
         return GameState.replaceParameters(mDescription,[this.mWaterGain]);
      }
   }
}
