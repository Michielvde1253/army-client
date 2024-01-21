package game.items
{
   import game.states.GameState;
   
   public class EnergyRefillItem extends ShopItem
   {
       
      
      public var mEnergyGain:int;
      
      public function EnergyRefillItem(param1:Object)
      {
         super(param1);
         this.mEnergyGain = param1.EnergyGain;
      }
      
      override public function getDescription() : String
      {
         return GameState.replaceParameters(mDescription,[this.mEnergyGain]);
      }
   }
}
