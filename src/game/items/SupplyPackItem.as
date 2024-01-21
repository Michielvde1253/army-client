package game.items
{
   import game.states.GameState;
   
   public class SupplyPackItem extends ShopItem
   {
       
      
      public var mSuppliesGain:int;
      
      public function SupplyPackItem(param1:Object)
      {
         super(param1);
         this.mSuppliesGain = param1.SuppliesGain;
      }
      
      override public function getDescription() : String
      {
         return GameState.replaceParameters(mDescription,[this.mSuppliesGain]);
      }
   }
}
