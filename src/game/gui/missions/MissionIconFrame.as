package game.gui.missions
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import game.states.GameState;
   
   public class MissionIconFrame
   {
       
      
      private var mButton:MissionButton;
      
      private var mFrame:MovieClip;
      
      public function MissionIconFrame(param1:MovieClip)
      {
         super();
         this.mFrame = param1;
         this.mButton = new MissionButton(param1,"Button_Mission");
      }
      
      public function getButton() : MissionButton
      {
         return this.mButton;
      }
      
      public function addToParent() : void
      {
         var _loc1_:DisplayObjectContainer = GameState.mInstance.mHUD.getHUDClip();
         var _loc2_:DisplayObjectContainer = _loc1_.getChildByName("pullout_mission_frame") as DisplayObjectContainer;
         var _loc3_:DisplayObjectContainer = _loc2_.getChildByName("pullout_mission") as DisplayObjectContainer;
         _loc3_.addChildAt(this.mFrame,1);
         this.mFrame.visible = true;
      }
      
      public function removeFromParent() : void
      {
         if(this.mFrame.parent)
         {
            this.mFrame.parent.removeChild(this.mFrame);
         }
      }
      
      public function setY(param1:int) : void
      {
         this.mFrame.y = param1;
      }
      
      public function setX(param1:int) : void
      {
         this.mFrame.x = param1;
      }
      
      public function getY() : int
      {
         return this.mFrame.y;
      }
      
      public function getX() : int
      {
         return this.mFrame.x;
      }
      
      public function getHeight() : int
      {
         return this.mFrame.height;
      }
      
      public function getWidth() : int
      {
         return this.mFrame.width;
      }
   }
}
