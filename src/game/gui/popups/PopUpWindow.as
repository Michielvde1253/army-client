package game.gui.popups
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.gui.DCWindow;
   import game.gui.DisplayObjectTransition;
   import game.states.GameState;
   
   public class PopUpWindow extends DCWindow
   {
      
      protected static var smAnimationClass:Class;
       
      
      protected var mClip:MovieClip;
      
      protected var mDoneCallback:Function;
      
      protected var mOpenTransitionName:String;
      
      protected var mCloseTransitionName:String;
      
      public function PopUpWindow(param1:MovieClip, param2:Boolean = true, param3:Boolean = true)
      {
         super(param1);
         this.mClip = param1;
         LocalizationUtils.replaceFonts(this.mClip);
         if(param2)
         {
            x = GameState.mInstance.getStageWidth() / 2;
            y = GameState.mInstance.getStageHeight() / 2;
         }
         if(param3)
         {
            if(FeatureTuner.USE_POPUP_OPENING_TRANSITION_EFFECT)
            {
               this.mOpenTransitionName = DisplayObjectTransition.APPEAR;
               this.mCloseTransitionName = DisplayObjectTransition.DISAPPEAR;
            }
         }
      }
      
      public function getOpenAnimation() : String
      {
         return this.mOpenTransitionName;
      }
      
      public function getCloseAnimation() : String
      {
         return this.mCloseTransitionName;
      }
      
      public function alignToScreen() : void
      {
         x = GameState.mInstance.getStageWidth() / 2;
         y = GameState.mInstance.getStageHeight() / 2;
      }
      
      override public function enterFrame(param1:Event) : void
      {
         super.enterFrame(param1);
         this.alignToOpenAnimation();
      }
      
      protected function alignToOpenAnimation() : void
      {
         var _loc1_:DisplayObject = null;
         if(mOpenAnimation)
         {
            _loc1_ = mOpenAnimation.getChildAt(0);
            this.mClip.x = _loc1_.x;
            this.mClip.y = _loc1_.y;
            this.mClip.alpha = _loc1_.alpha;
         }
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         super.open(param1,param2);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown,false,0,true);
         ++PopUpManager.mTotalOpenCount;
         if(param2)
         {
            ++PopUpManager.mModalOpenCount;
         }
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      protected function doOpeningTransition() : void
      {
         if(FeatureTuner.USE_POPUP_OPENING_TRANSITION_EFFECT)
         {
            if(this.mOpenTransitionName != null)
            {
               new DisplayObjectTransition(this.mOpenTransitionName,this,DisplayObjectTransition.TYPE_APPEAR);
            }
         }
      }
      
      override public function close() : void
      {
         removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         --PopUpManager.mTotalOpenCount;
         if(mIsModal)
         {
            --PopUpManager.mModalOpenCount;
            if(PopUpManager.mModalOpenCount == 0)
            {
            }
         }
         super.close();
         this.mDoneCallback = null;
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         if(GameState.mInstance.resumeMusicOnMouseEvent)
         {
            GameState.mInstance.startMusic();
            GameState.mInstance.resumeMusicOnMouseEvent = false;
         }
      }
   }
}
