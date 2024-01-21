package game.states
{
   import flash.display.Sprite;
   
   public class StateMachine
   {
       
      
      private var mCurrentState:FSMState;
      
      private var mPreviousState:FSMState;
      
      private var mNextState:FSMState;
      
      private var mMainClip:Sprite;
      
      public function StateMachine(param1:Sprite)
      {
         super();
         this.mCurrentState = this.mPreviousState = this.mNextState = null;
         this.mMainClip = param1;
      }
      
      public function setNextState(param1:FSMState) : void
      {
         this.mNextState = param1;
         this.goToNextState();
      }
      
      public function logicUpdate(param1:int) : void
      {
         if(this.mCurrentState)
         {
            this.mCurrentState.logicUpdate(param1);
         }
      }
      
      public function onMousePointerEventOccurred(param1:int, param2:int, param3:int) : void
      {
         if(this.mCurrentState)
         {
            this.mCurrentState.onMousePointerEventOccurred(param1,param2,param3);
         }
      }
      
      public function changeState(param1:FSMState) : void
      {
         if(this.mCurrentState != null)
         {
            this.mCurrentState.exit();
            this.mPreviousState = this.mCurrentState;
         }
         this.mCurrentState = param1;
         this.mCurrentState.enter();
      }
      
      public function goToPreviousState() : void
      {
         this.changeState(this.mPreviousState);
      }
      
      public function goToNextState() : void
      {
         this.changeState(this.mNextState);
      }
      
      public function getMainClip() : Sprite
      {
         return this.mMainClip;
      }
      
      public function getCurrentState() : FSMState
      {
         return this.mCurrentState;
      }
   }
}
