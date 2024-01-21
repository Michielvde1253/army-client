package game.gui.button
{
   import com.dchoc.utils.DCUtils;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import game.sound.ArmySoundManager;
   
   public class ResizingButton extends ArmyButton
   {
       
      
      private var mType:int;
      
      private var mID:String;
      
      private var mObjectToWarnForClick:EventDispatcher;
      
      protected var mButtonText:String;
      
      protected var mVisibleBackGround:MovieClip;
      
      protected var mBackgrounds:Array;
      
      protected var mVisibleText:TextField;
      
      protected var mTexts:Array;
      
      protected var mOriginalTextSize:int;
      
      public function ResizingButton(param1:DisplayObjectContainer, param2:MovieClip, param3:int, param4:String = null, param5:EventDispatcher = null, param6:Function = null, param7:Function = null, param8:Function = null, param9:Function = null, param10:Function = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,false);
         this.initAssets();
         this.mType = param3;
         this.mID = param4;
         setEnabled(true);
         var _loc11_:MovieClip;
         if((_loc11_ = mButton.getChildByName(BUTTON_NAME_HIT_AREA) as MovieClip) != null)
         {
            _loc11_.visible = false;
            mButton.hitArea = _loc11_;
         }
         mButton.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown,false,0,true);
         mButton.addEventListener(MouseEvent.MOUSE_UP,mouseUp,false,0,true);
         if(TRIGGER_AT_MOUSE_UP)
         {
            mButton.addEventListener(MouseEvent.CLICK,mouseClick,false,0,true);
         }
         if(Config.BUTTON_USE_HAND_CURSOR)
         {
            mButton.buttonMode = true;
            mButton.mouseChildren = false;
            mButton.useHandCursor = true;
         }
         if(param10 != null)
         {
            mButton.addEventListener(Event.ENTER_FRAME,param10,false,0,true);
            mEnterFrameFunction = param10;
         }
         setMouseDownFunction(param6);
         setMouseOutFunction(param8);
         setMouseOverFunction(param7);
         setMouseUpFunction(param9);
         this.setReactWhenDraggingObject(false);
         this.setObjectToWarnForClick(param5);
         mClickSound = ArmySoundManager.SFX_UI_CLICK;
      }
      
      protected function initAssets() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:TextField = null;
         this.mBackgrounds = new Array();
         this.mBackgrounds[BUTTON_FRAME_NAME_UP] = mButton.getChildByName("Background_Enabled") as MovieClip;
         this.mBackgrounds[BUTTON_FRAME_NAME_OVER] = mButton.getChildByName("Background_Over") as MovieClip;
         this.mBackgrounds[BUTTON_FRAME_NAME_OUT] = mButton.getChildByName("Background_Out") as MovieClip;
         this.mBackgrounds[BUTTON_FRAME_NAME_DOWN] = mButton.getChildByName("Background_Down") as MovieClip;
         this.mBackgrounds[BUTTON_FRAME_NAME_DISABLED_UP] = mButton.getChildByName("Background_Disabled") as MovieClip;
         for each(_loc1_ in this.mBackgrounds)
         {
            _loc1_.visible = false;
         }
         this.mVisibleBackGround = this.mBackgrounds[BUTTON_FRAME_NAME_UP];
         this.mVisibleBackGround.visible = true;
         this.mTexts = new Array();
         this.mTexts[BUTTON_FRAME_NAME_UP] = mButton.getChildByName("Text_Enabled") as TextField;
         this.mTexts[BUTTON_FRAME_NAME_OVER] = mButton.getChildByName("Text_Over") as TextField;
         this.mTexts[BUTTON_FRAME_NAME_OUT] = mButton.getChildByName("Text_Down") as TextField;
         this.mTexts[BUTTON_FRAME_NAME_DOWN] = mButton.getChildByName("Text_Out") as TextField;
         this.mTexts[BUTTON_FRAME_NAME_DISABLED_UP] = mButton.getChildByName("Text_Disabled") as TextField;
         for each(_loc2_ in this.mTexts)
         {
            _loc2_.visible = false;
         }
         this.mVisibleText = this.mTexts[BUTTON_FRAME_NAME_UP];
         this.mVisibleText.visible = true;
         this.mOriginalTextSize = int(this.mVisibleText.getTextFormat().size);
      }
      
      override protected function mouseOver(param1:MouseEvent) : void
      {
         super.mouseOver(param1);
         if(mOverSound)
         {
            ArmySoundManager.getInstance().playSound(mOverSound);
         }
      }
      
      override protected function buttonClicked(param1:MouseEvent) : void
      {
         super.buttonClicked(param1);
      }
      
      override public function setMouseClickFunction(param1:Function) : void
      {
         mMouseClickFunction = param1;
      }
      
      override public function setReactWhenDraggingObject(param1:Boolean) : void
      {
         mReactWhenDraggingObject = param1;
      }
      
      override public function setObjectToWarnForClick(param1:EventDispatcher) : void
      {
         this.mObjectToWarnForClick = param1;
      }
      
      override public function getObjectToWarnForClick() : EventDispatcher
      {
         return this.mObjectToWarnForClick;
      }
      
      override public function enterFrame(param1:Event) : void
      {
         if(mButton.getCurrentLabel() != mCurrentPlayedLabel || mButton.currentFrame == mButton.totalFrames)
         {
            if(mButton.getCurrentLabel() != mCurrentPlayedLabel)
            {
               mButton.prevFrame();
            }
            terminateAnimations();
            if(mCurrentPlayedLabel == BUTTON_FRAME_NAME_OUT)
            {
               this.playAnim(BUTTON_FRAME_NAME_UP);
            }
         }
      }
      
      override public function playAnim(param1:String) : void
      {
         if(mButton.currentLabels == null || mButton.currentLabels.length == 0)
         {
            return;
         }
         var _loc2_:Boolean = DCUtils.movieClipContainsLabel(mButton,param1);
         if(!_loc2_ || param1 == BUTTON_FRAME_NAME_OUT)
         {
            param1 = BUTTON_FRAME_NAME_UP;
         }
         this.mVisibleBackGround.visible = false;
         this.mVisibleBackGround = this.mBackgrounds[param1];
         this.mVisibleBackGround.visible = true;
         this.mVisibleText.visible = false;
         this.mVisibleText = this.mTexts[param1];
         this.mVisibleText.visible = true;
      }
      
      override public function setText(param1:String, param2:String = "Text") : void
      {
         var _loc3_:TextField = null;
         if(param1 != null)
         {
            if(param1 != "")
            {
               if(param1 != this.mButtonText)
               {
                  for each(_loc3_ in this.mTexts)
                  {
                     _loc3_.autoSize = TextFieldAutoSize.CENTER;
                     _loc3_.wordWrap = false;
                     _loc3_.multiline = false;
                     _loc3_.text = param1;
                  }
                  this.mButtonText = param1;
                  this.recalculateSize();
               }
            }
         }
      }
      
      public function setMaxWidth(param1:int) : void
      {
         mMaxWidth = param1;
         this.recalculateSize();
      }
      
      override protected function recalculateSize() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:TextField = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TextFormat = null;
         var _loc1_:Boolean = true;
         var _loc2_:int = int(this.mVisibleText.getTextFormat().size);
         if(Config.FOR_IPHONE_PLATFORM)
         {
            if(_loc2_ < 20)
            {
               _loc2_ = 20;
            }
         }
         while(_loc1_)
         {
            _loc3_ = 0;
            for each(_loc4_ in this.mTexts)
            {
               (_loc6_ = _loc4_.getTextFormat()).size = _loc2_;
               _loc6_.letterSpacing = 2.5;
               _loc4_.defaultTextFormat = _loc6_;
               _loc4_.setTextFormat(_loc6_);
               if(_loc4_.width > _loc3_)
               {
                  _loc3_ = _loc4_.width;
               }
            }
            if(Config.FOR_IPHONE_PLATFORM)
            {
               if(_loc3_ > mMaxWidth)
               {
                  _loc3_ = mMaxWidth;
               }
            }
            if(_loc3_ > mMaxWidth)
            {
               _loc2_--;
            }
            else
            {
               _loc1_ = false;
               for each(_loc5_ in this.mBackgrounds)
               {
                  _loc5_.getChildAt(0).width = _loc3_ + ArmyButton.BUTTON_PADDING;
               }
            }
         }
      }
      
      public function getClip() : MovieClip
      {
         return mButton;
      }
   }
}
