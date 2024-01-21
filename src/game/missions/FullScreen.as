package game.missions
{
   import game.states.GameState;
   
   public class FullScreen extends Objective
   {
       
      
      public function FullScreen(param1:Object)
      {
         super(param1);
      }
      
      override public function initialize(param1:String, param2:Object) : void
      {
      }
      
      override public function clean() : void
      {
         GameState.mInstance.mHUD.removeTutorialHighlight();
         GameState.mInstance.mScene.enableMouse();
      }
   }
}
