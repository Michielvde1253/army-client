package game.missions
{
   import game.states.GameState;
   
   public class Zoom extends Objective
   {
       
      
      public function Zoom(param1:Object)
      {
         super(param1);
      }
      
      override public function initialize(param1:String, param2:Object) : void
      {
         super.initialize(param1,param2);
      }
      
      override public function clean() : void
      {
         GameState.mInstance.mHUD.removeTutorialHighlight();
         GameState.mInstance.mScene.enableMouse();
      }
   }
}
