package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import game.gui.AutoTextField;
   import game.gui.DisplayObjectTransition;
   import game.gui.button.ResizingButton;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class IntroWindow extends PopUpWindow
   {
      
      private static const STATE_BEGINNING:int = 0;
      
      private static const STATE_PLAYING:int = 1;
      
      private static const STATE_END:int = 2;
       
      
      private var mButtonSkip:ResizingButton;
      
      private var mIntro:MovieClip;
      
      private var mCaptionClip:MovieClip;
      
      private var mCaptionText:AutoTextField;
      
      private var mIntroState:int;
      
      public function IntroWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME,"popup_intro");
         super(new _loc1_() as MovieClip,true);
         this.mCaptionClip = mClip.getChildByName("Text_intro") as MovieClip;
         this.mCaptionClip.mouseEnabled = false;
         this.mCaptionClip.mouseChildren = false;
         this.mCaptionText = new AutoTextField(this.mCaptionClip.getChildByName("Text_movie") as TextField);
         this.mCaptionText.setMutliline(true);
         this.mButtonSkip = Utils.createResizingButton(mClip,"Button_Skip",this.skipClicked);
      }
      
      private function setState(param1:int) : void
      {
         var _loc2_:Class = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Rectangle = null;
         switch(param1)
         {
            case STATE_BEGINNING:
               _loc2_ = DCResourceManager.getInstance().getSWFClass("swf/intro","intro_animation");
               this.mIntro = new _loc2_();
               _loc3_ = mClip.getChildByName("Intro_Container") as MovieClip;
               _loc4_ = this.mIntro.getBounds(this.mIntro);
               this.mIntro.x = -(_loc4_.left + _loc4_.right) / 2;
               this.mIntro.y = -(_loc4_.bottom + _loc4_.top) / 2;
               _loc3_.addChild(this.mIntro);
               this.mIntro.gotoAndStop(1);
               this.mButtonSkip.setText(GameState.getText("BUTTON_START"));
               this.mCaptionText.setText(GameState.getText("INTRO_MOVIE_BEGINNING"));
               break;
            case STATE_PLAYING:
               ArmySoundManager.getInstance().playSound(ArmySoundManager.MUSIC_INTRO);
               if(Config.FOR_IPHONE_PLATFORM)
               {
                  if(FeatureTuner.USE_POPUP_OPENING_TRANSITION_EFFECT)
                  {
                     new DisplayObjectTransition(DisplayObjectTransition.DISAPPEAR_UP,this.mCaptionClip,DisplayObjectTransition.TYPE_DISAPPEAR);
                  }
               }
               else
               {
                  this.mCaptionClip.visible = false;
               }
               this.mButtonSkip.setText(GameState.getText("BUTTON_SKIP"));
               this.mIntro.addEventListener(Event.ENTER_FRAME,this.stopAnimation,false,0,true);
               this.mIntro.play();
               break;
            case STATE_END:
               this.mIntro.removeEventListener(Event.ENTER_FRAME,this.stopAnimation);
               this.mCaptionClip.visible = true;
               this.mCaptionText.setText(GameState.getText("INTRO_MOVIE_ENDING"));
               if(Config.FOR_IPHONE_PLATFORM)
               {
                  if(FeatureTuner.USE_POPUP_OPENING_TRANSITION_EFFECT)
                  {
                     new DisplayObjectTransition(DisplayObjectTransition.APPEAR_UP,this.mCaptionClip,DisplayObjectTransition.TYPE_APPEAR);
                  }
               }
               else
               {
                  this.mCaptionClip.visible = true;
               }
               this.mButtonSkip.setText(GameState.getText("BUTTON_CONTINUE"));
               this.mIntro.gotoAndStop(this.mIntro.totalFrames);
         }
         this.mIntroState = param1;
      }
      
      public function Activate(param1:Function) : void
      {
         this.setState(STATE_BEGINNING);
         mDoneCallback = param1;
         doOpeningTransition();
      }
      
      private function skipClicked(param1:MouseEvent) : void
      {
         if(this.mIntroState == STATE_BEGINNING)
         {
            this.setState(STATE_PLAYING);
         }
         else if(this.mIntroState == STATE_PLAYING)
         {
            this.setState(STATE_END);
         }
         else if(this.mIntroState == STATE_END)
         {
            this.closeIntro();
         }
      }
      
      public function stopAnimation(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            this.setState(STATE_END);
         }
      }
      
      private function closeIntro() : void
      {
         ArmySoundManager.getInstance().stopSound(ArmySoundManager.MUSIC_INTRO);
         ArmySoundManager.getInstance().playSound(ArmySoundManager.MUSIC_HOME,1,0,-1);
         GameState.mInstance.changeState(GameState.STATE_INTRO);
         mDoneCallback((this as Object).constructor);
      }
   }
}
