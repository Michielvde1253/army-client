package game.missions
{
   import game.states.GameState;
   
   public class ActivateRepair extends Objective
   {
       
      
      public function ActivateRepair(param1:Object)
      {
         super(param1);
      }
      
      override public function initialize(param1:String, param2:Object) : void
      {
         if(param2)
         {
            mGoal = param2.goal - param2.startValue;
            mCounter = Math.min(param2.counterValue - param2.startValue,mGoal);
            mPurchased = param2.purchased as Boolean;
         }
         else
         {
            mCounter = 0;
         }
         if(param1 == Mission.TYPE_MODAL_ARROW)
         {
            GameState.mInstance.mHUD.setRepairButtonHighlight();
            GameState.mInstance.mScene.disableMouse(-1,-1);
         }
      }
      
      override public function clean() : void
      {
         GameState.mInstance.mHUD.removeTutorialHighlight();
         GameState.mInstance.mScene.enableMouse();
      }
   }
}
