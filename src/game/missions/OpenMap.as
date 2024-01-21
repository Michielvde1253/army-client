package game.missions
{
   import game.states.GameState;
   
   public class OpenMap extends Objective
   {
       
      
      public function OpenMap(param1:Object)
      {
         super(param1);
      }
      
      override public function initialize(param1:String, param2:Object) : void
      {
         super.initialize(param1,param2);
         if(param1 == Mission.TYPE_TOASTER_MESSAGE)
         {
            if(Config.USE_WORLD_MAP)
            {
               GameState.mInstance.mHUD.setMapButtonHighlight();
            }
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
