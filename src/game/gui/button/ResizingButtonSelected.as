package game.gui.button
{
   import com.dchoc.GUI.DCButton;
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
   
   public class ResizingButtonSelected extends ArmyButtonSelected
   {
       
      
      protected var mVisibleBackGround:MovieClip;
      
      protected var mBackgrounds:Array;
      
      protected var mVisibleText:TextField;
      
      protected var mTexts:Array;
      
      public var mTextSize:int;
      
      public var useIPhoneTextSize:Boolean;
      
      public var resizeNeeded:Boolean;
      
      private var mButtonText:String;
      
      public function ResizingButtonSelected(param1:DisplayObjectContainer, param2:MovieClip, param3:int, param4:String = null, param5:EventDispatcher = null, param6:Function = null, param7:Function = null, param8:Function = null, param9:Function = null, param10:Function = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,false);
         this.resizeNeeded = true;
         this.initAssets();
         setEnabled(true);
         mSelected = false;
         setAllowDeselection(true);
         mClickSound = ArmySoundManager.SFX_UI_CLICK;
         this.useIPhoneTextSize = true;
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
         this.mBackgrounds[BUTTON_FRAME_NAME_DISABLED_OVER] = mButton.getChildByName("Background_Disabled") as MovieClip;
         this.mBackgrounds[BUTTON_FRAME_NAME_DISABLED_DOWN] = mButton.getChildByName("Background_Disabled") as MovieClip;
         this.mBackgrounds[BUTTON_FRAME_NAME_SELECTED_UP] = mButton.getChildByName("Background_Selected") as MovieClip;
         this.mBackgrounds[BUTTON_FRAME_NAME_SELECTED_OVER] = mButton.getChildByName("Background_Selected") as MovieClip;
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
         this.mTexts[BUTTON_FRAME_NAME_DISABLED_OVER] = mButton.getChildByName("Text_Disabled") as TextField;
         this.mTexts[BUTTON_FRAME_NAME_DISABLED_DOWN] = mButton.getChildByName("Text_Disabled") as TextField;
         this.mTexts[BUTTON_FRAME_NAME_SELECTED_UP] = mButton.getChildByName("Text_Selected") as TextField;
         this.mTexts[BUTTON_FRAME_NAME_SELECTED_OVER] = mButton.getChildByName("Text_Selected") as TextField;
         for each(_loc2_ in this.mTexts)
         {
            _loc2_.visible = false;
         }
         this.mVisibleText = this.mTexts[BUTTON_FRAME_NAME_UP];
         this.mVisibleText.visible = true;
      }
      
      public function setMaxWidth(param1:int) : void
      {
         mMaxWidth = param1;
         if(this.resizeNeeded)
         {
            this.recalculateSize();
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
      
      override public function enterFrame(param1:Event) : void
      {
         if(mButton.getCurrentLabel() != mCurrentPlayedLabel || mButton.currentFrame == mButton.totalFrames)
         {
            if(mButton.getCurrentLabel() != mCurrentPlayedLabel)
            {
               mButton.prevFrame();
               this.mVisibleBackGround.visible = false;
               this.mVisibleBackGround = this.mBackgrounds[mButton.getCurrentLabel()];
               this.mVisibleBackGround.visible = true;
               this.mVisibleText.visible = false;
               this.mVisibleText = this.mTexts[mButton.getCurrentLabel()];
               this.mVisibleText.visible = true;
               if(mCurrentPlayedLabel == BUTTON_FRAME_NAME_OUT)
               {
                  this.playAnim(BUTTON_FRAME_NAME_UP);
               }
            }
         }
      }
      
      override protected function mouseDown(param1:MouseEvent) : void
      {
         if(DCButton.TRIGGER_AT_MOUSE_UP)
         {
            super.mouseDown(param1);
            return;
         }
         if(!this.isEnable())
         {
            return;
         }
         this.buttonClicked(param1);
      }
      
      override protected function buttonClicked(param1:MouseEvent) : void
      {
         if(mSelected)
         {
            unselect();
         }
         else
         {
            select();
         }
         super.buttonClicked(param1);
      }
      
      override protected function mouseUp(param1:MouseEvent) : void
      {
         if(DCButton.TRIGGER_AT_MOUSE_UP)
         {
            super.mouseUp(param1);
            return;
         }
         if(!this.isEnable())
         {
            return;
         }
         if(mSelected)
         {
            if(mMouseUpFunction != null)
            {
               mMouseUpFunction(param1);
            }
            return;
         }
         super.mouseUp(param1);
      }
      
      override protected function mouseOut(param1:MouseEvent) : void
      {
         if(mSelected)
         {
            hideHelper();
            return;
         }
         super.mouseOut(param1);
      }
      
      override protected function mouseOver(param1:MouseEvent) : void
      {
         if(mSelected)
         {
            showHelper();
            return;
         }
         super.mouseOver(param1);
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
                  if(this.resizeNeeded)
                  {
                     this.recalculateSize();
                  }
               }
            }
         }
      }
      
      private function recalculateSize() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:TextField = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TextFormat = null;
         var _loc1_:* = true;
         var _loc2_:int = int(this.mVisibleText.getTextFormat().size);
         if(Config.FOR_IPHONE_PLATFORM)
         {
            if(this.useIPhoneTextSize)
            {
               if(_loc2_ < 20)
               {
                  _loc2_ = 20;
               }
            }
         }
         while(_loc1_)
         {
            _loc3_ = 0;
            for each(_loc4_ in this.mTexts)
            {
               (_loc6_ = _loc4_.getTextFormat()).size = _loc2_;
               _loc4_.defaultTextFormat = _loc6_;
               _loc4_.setTextFormat(_loc6_);
               if(_loc4_.width > _loc3_)
               {
                  _loc3_ = _loc4_.width;
               }
            }
            this.mTextSize = _loc2_;
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
                  _loc1_ = _loc3_ + ArmyButton.BUTTON_PADDING > mMaxWidth;
               }
               _loc2_--;
            }
         }
      }
      
      public function setTextSize(param1:int) : void
      {
         var _loc3_:TextField = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TextFormat = null;
         var _loc2_:Number = 0;
         for each(_loc3_ in this.mTexts)
         {
            (_loc5_ = _loc3_.getTextFormat()).size = param1;
            _loc3_.defaultTextFormat = _loc5_;
            _loc3_.setTextFormat(_loc5_);
            if(_loc3_.width > _loc2_)
            {
               _loc2_ = _loc3_.width;
            }
         }
         for each(_loc4_ in this.mBackgrounds)
         {
            _loc4_.getChildAt(0).width = _loc2_ + ArmyButton.BUTTON_PADDING;
         }
         this.mTextSize = param1;
      }
      
      public function setIPhoneTextSize(param1:Boolean) : void
      {
         this.useIPhoneTextSize = param1;
      }
   }
}
