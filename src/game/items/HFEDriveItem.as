package game.items
{
   import game.states.GameState;
   
   public class HFEDriveItem extends HFEItem
   {
       
      
      public function HFEDriveItem(param1:Object)
      {
         super(param1);
      }
      
      override public function getDescription() : String
      {
         return GameState.replaceParameters(mDescription,[mRewardMoney]);
      }
   }
}
