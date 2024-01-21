package game.items
{
   import game.states.GameState;
   
   public class BuyGoldItem extends ShopItem
   {
       
      
      public var mGoldGain:int;
      
      public function BuyGoldItem(param1:Object)
      {
         super(param1);
         this.mGoldGain = param1.GoldGain;
      }
      
      override public function getDescription() : String
      {
         return GameState.replaceParameters(mDescription,[this.mGoldGain]);
      }
   }
}
