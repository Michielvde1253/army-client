package game.items
{
   import game.states.GameState;
   
   public class BuyCashItem extends ShopItem
   {
       
      
      public var mCashGain:int;
      
      public function BuyCashItem(param1:Object)
      {
         super(param1);
         this.mCashGain = param1.CashGain;
      }
      
      override public function getDescription() : String
      {
         return GameState.replaceParameters(mDescription,[this.mCashGain]);
      }
   }
}
