package game.actions
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import game.characters.PlayerUnit;
   import game.sound.ArmySoundManager;
   import game.sound.SoundCollection;
   import game.states.GameState;
   
   public class RedeployPlayerUnitAction extends Action
   {
      
      private static const STATE_ANIMATION:int = 0;
      
      private static const STATE_OVER:int = 1;
       
      
      private var mState:int;
      
      private var mHarvestAnimation:MovieClip;
      
      private var mAnimationSound:SoundCollection;
      
      public function RedeployPlayerUnitAction(param1:PlayerUnit)
      {
         super("RedeployPlayerUnitAction");
         mTarget = param1;
         this.mState = -1;
      }
      
      protected function initSounds() : void
      {
         this.mAnimationSound = ArmySoundManager.SC_HELI;
         this.mAnimationSound.load();
      }
      
      override public function isOver() : Boolean
      {
         return this.mState == STATE_OVER || mSkipped;
      }
      
      override public function start() : void
      {
         var _loc3_:String = null;
         if(mSkipped || !GameState.mInstance.checkIfUnitIsPickable(mTarget as PlayerUnit))
         {
            return;
         }
         if(FeatureTuner.USE_SOUNDS)
         {
            this.initSounds();
         }
         var _loc1_:DCResourceManager = DCResourceManager.getInstance();
         var _loc2_:String = Config.SWF_EFFECTS_NAME;
         if(_loc1_.isLoaded(_loc2_))
         {
            this.addHarvestAnimaion();
         }
         else
         {
            _loc3_ = _loc2_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
            _loc1_.addEventListener(_loc3_,this.harvestAnimationLoaded,false,0,true);
            if(!_loc1_.isAddedToLoadingList(_loc2_))
            {
               _loc1_.load(Config.DIR_DATA + _loc2_ + ".swf",_loc2_,null,false);
            }
         }
         this.mState = STATE_ANIMATION;
      }
      
      protected function harvestAnimationLoaded(param1:Event) : void
      {
         DCResourceManager.getInstance().removeEventListener(param1.type,this.harvestAnimationLoaded);
         this.addHarvestAnimaion();
      }
      
      private function addHarvestAnimaion() : void
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_EFFECTS_NAME,"redeploy_pickup");
         this.mHarvestAnimation = new _loc1_();
         this.mHarvestAnimation.addEventListener(Event.ENTER_FRAME,this.checkHarvestFrame);
         this.mHarvestAnimation.x = mTarget.mX;
         this.mHarvestAnimation.y = mTarget.mY;
         this.mHarvestAnimation.mouseChildren = false;
         this.mHarvestAnimation.mouseEnabled = false;
         GameState.mInstance.mScene.mSceneHud.addChild(this.mHarvestAnimation);
         mTarget.playCollectionSound(this.mAnimationSound);
         this.execute();
         this.mState = STATE_ANIMATION;
      }
      
      private function checkHarvestFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.currentFrame == 360)
         {
            this.removeHarvestClip();
         }
      }
      
      private function removeHarvestClip() : void
      {
         if(this.mHarvestAnimation)
         {
            this.mHarvestAnimation.removeEventListener(Event.ENTER_FRAME,this.checkHarvestFrame);
            this.mHarvestAnimation.stop();
            if(this.mHarvestAnimation.parent)
            {
               this.mHarvestAnimation.parent.removeChild(this.mHarvestAnimation);
            }
            this.mHarvestAnimation = null;
         }
         this.mState = STATE_OVER;
      }
      
      private function execute() : void
      {
         GameState.mInstance.pickupUnit(mTarget as PlayerUnit);
      }
   }
}
