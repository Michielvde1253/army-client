package game.gui
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class BigHudBar
   {
      
      public static var ANIMATE_INCREASE:int = 1;
      
      public static var ANIMATE_DECREASE:int = 2;
      
      private static const smTextColorBoosted:uint = 0;
       
      
      private var mDefaultDirection:int;
      
      private var mMainClip:MovieClip;
      
      private var mFillAnimation:MovieClip;
      
      private var mBarGraphic:MovieClip;
      
      private var mAmountText:TextField;
      
      private var mTargetPrc:Number;
      
      private var mCurrentPrc:Number;
      
      private var mMaxAmount:Number;
      
      private var mOwnedAmount:Number;
      
      private var mOffsetAmount:Number;
      
      private var mShowMax:Boolean;
      
      private var mTextColorNormal:uint;
      
      private var mPrevAnimatedAmount:int = -1;
      
      private var mPrevMaxVal:int = -1;
      
      public function BigHudBar(param1:MovieClip, param2:Boolean, param3:int = 0)
      {
         var _loc4_:TextFormat = null;
         super();
         this.mMainClip = param1;
         this.mAmountText = param1.getChildByName("Text_Amount") as TextField;
         if(Config.FOR_IPHONE_PLATFORM)
         {
            (_loc4_ = this.mAmountText.getTextFormat()).size = 22;
            this.mAmountText.defaultTextFormat = _loc4_;
            this.mAmountText.setTextFormat(_loc4_);
         }
         this.mTextColorNormal = this.mAmountText.textColor;
         this.mFillAnimation = param1.getChildByName("Fill") as MovieClip;
         this.mBarGraphic = this.mFillAnimation.getChildByName("Bar") as MovieClip;
         this.mMainClip.addEventListener(Event.ENTER_FRAME,this.update);
         this.mTargetPrc = 0;
         this.mCurrentPrc = 0;
         this.mOwnedAmount = 0;
         this.mMaxAmount = 0;
         this.mOffsetAmount = 0;
         this.mFillAnimation.gotoAndStop(1);
         this.mBarGraphic.gotoAndStop(1);
         this.mDefaultDirection = param3;
         this.mShowMax = param2;
         this.updateText();
      }
      
      public function setTextAmountVisible(param1:Boolean) : void
      {
         this.mAmountText.visible = param1;
      }
      
      private function updateText() : void
      {
         var _loc1_:int = this.mOffsetAmount + (this.mCurrentPrc == this.mTargetPrc ? this.mOwnedAmount : this.mCurrentPrc * this.mMaxAmount);
         if(this.mShowMax)
         {
            if(this.mAmountText.text != _loc1_ + "/" + (this.mMaxAmount + this.mOffsetAmount))
            {
               this.mAmountText.text = _loc1_ + "/" + (this.mMaxAmount + this.mOffsetAmount);
            }
         }
         else if(this.mAmountText.text != String(_loc1_))
         {
            this.mAmountText.text = String(_loc1_);
         }
         var _loc2_:uint = this.mCurrentPrc > 1 ? smTextColorBoosted : this.mTextColorNormal;
         if(_loc2_ != this.mAmountText.textColor)
         {
            this.mAmountText.textColor = _loc2_;
         }
      }
      
      private function update(param1:Event) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:Number = 0.01;
         var _loc3_:Number = 0.05;
         if(this.mCurrentPrc != this.mTargetPrc)
         {
            _loc4_ = this.mTargetPrc - this.mCurrentPrc;
            if(Math.abs(_loc4_) * _loc3_ < _loc2_)
            {
               if(Math.abs(_loc4_) < _loc2_)
               {
                  this.mCurrentPrc += _loc4_;
               }
               else if(_loc4_ > 0)
               {
                  this.mCurrentPrc += _loc2_;
               }
               else
               {
                  this.mCurrentPrc -= _loc2_;
               }
            }
            else
            {
               this.mCurrentPrc += _loc4_ * _loc3_;
            }
            this.mFillAnimation.gotoAndStop(int(this.mCurrentPrc * (this.mFillAnimation.totalFrames - 1) + 1));
         }
         this.updateText();
         if(this.mCurrentPrc == this.mTargetPrc && this.mCurrentPrc <= 1)
         {
            this.mBarGraphic.stop();
         }
         else
         {
            this.mBarGraphic.play();
         }
      }
      
      public function setTargetValues(param1:Number, param2:Number, param3:Number = 0) : void
      {
         var _loc4_:Number = param1 / param2;
         this.mOffsetAmount = param3;
         if(_loc4_ != this.mTargetPrc || this.mMaxAmount != param2)
         {
            if(this.mMaxAmount != param2)
            {
               this.mMaxAmount = param2;
               this.update(null);
            }
            this.mOwnedAmount = param1;
            if(this.mDefaultDirection == ANIMATE_INCREASE && _loc4_ < this.mTargetPrc)
            {
               this.mCurrentPrc = 0;
               this.update(null);
            }
            else if(this.mDefaultDirection == ANIMATE_DECREASE && _loc4_ > this.mTargetPrc)
            {
               this.mCurrentPrc = _loc4_;
               this.update(null);
            }
            this.mTargetPrc = _loc4_;
         }
      }
   }
}
