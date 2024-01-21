package game.actions
{
   import game.characters.AnimationController;
   import game.characters.PlayerUnit;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.Element;
   import game.states.GameState;
   
   public class PvPWalkingAction extends WalkingAction
   {
       
      
      public function PvPWalkingAction(param1:PlayerUnit, param2:Number, param3:Number)
      {
         super(param1,param2,param3,"PvPWalk");
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         if(GameState.mInstance.mPvPMatch.mActionsLeft == 0)
         {
            skip();
            return;
         }
         mOriginCell = mActor.getCell();
         (mActor as IsometricCharacter).moveTo(mTargetX,mTargetY);
         mActor.playCollectionSound(mActor.mMoveSounds);
      }
      
      override protected function execute() : void
      {
         if(!mSkipped)
         {
            (mActor as Element).mScene.characterArrivedInCell(mActor as IsometricCharacter,mActor.getCell());
            mActor.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
            GameState.mInstance.playerMoveMade();
         }
      }
   }
}
