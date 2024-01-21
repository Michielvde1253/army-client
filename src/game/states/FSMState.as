package game.states
{
   import flash.display.Sprite;
   
   public class FSMState
   {
       
      
      private var mStateMachine:StateMachine;
      
      protected var mMainClip:Sprite;
      
      public function FSMState(param1:StateMachine)
      {
         super();
         this.mStateMachine = param1;
         this.mMainClip = this.mStateMachine.getMainClip();
      }
      
      public function enter() : void
      {
      }
      
      public function exit() : void
      {
      }
      
      public function logicUpdate(param1:int) : void
      {
      }
      
      public function onMousePointerEventOccurred(param1:int, param2:int, param3:int) : void
      {
      }
      
      public function getStateMachine() : StateMachine
      {
         return this.mStateMachine;
      }
      
      public function getMainClip() : Sprite
      {
         return this.mMainClip;
      }
   }
}
