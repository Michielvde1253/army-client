package
{
   import flash.display.StageAlign;
   import flash.display.StageDisplayState;
   import flash.display.StageScaleMode;
   
   public class iArmyAir extends GameMain
   {
       
      
      public function iArmyAir()
      {
         super();
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
		 stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
      }
   }
}
