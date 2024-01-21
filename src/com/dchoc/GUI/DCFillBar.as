package com.dchoc.GUI
{
   import flash.display.MovieClip;
   
   public class DCFillBar
   {
      
      public static const ANIMATION_TIME:int = 500;
       
      
      private var mBarMC:MovieClip;
      
      private var mMinValue:int;
      
      private var mMaxValue:int;
      
      private var mMinValuePrevious:int;
      
      private var mMaxValuePrevious:int;
      
      private var mAddedValue:int;
      
      private var mAddedValueSpeed:Number;
      
      private var mAddedValueRemainder:Number;
      
      private var mValue:int;
      
      private var mTime:int;
      
      private var LINER_PROGRESS:Boolean = false;
      
      public function DCFillBar(param1:MovieClip, param2:int, param3:int)
      {
         super();
         this.mBarMC = param1;
         this.setValues(param2,param2,param3);
         this.mAddedValue = 0;
         this.mTime = 0;
      }
      
      public function setValues(param1:int, param2:int, param3:int) : void
      {
         param1 = Math.min(Math.max(param1,param2),param3);
         this.setMinValue(param2);
         this.setMaxValue(param3);
         this.setValue(param1);
      }
      
      public function setMinValue(param1:int) : void
      {
         if(param1 != this.mMinValue)
         {
            this.mMinValuePrevious = this.mMinValue;
         }
         this.mMinValue = param1;
      }
      
      public function setMaxValue(param1:int) : void
      {
         if(param1 != this.mMaxValue)
         {
            this.mMaxValuePrevious = this.mMaxValue;
         }
         this.mMaxValue = param1;
      }
      
      public function setValue(param1:int) : void
      {
         if(!this.LINER_PROGRESS)
         {
            if(this.mAddedValue != 0)
            {
               this.mValue += this.mAddedValue;
            }
         }
         this.mAddedValue = param1 - this.mValue;
         this.mAddedValueSpeed = this.mAddedValue / ANIMATION_TIME;
         this.mAddedValueRemainder = 0;
         this.mTime = ANIMATION_TIME;
         this.setFrameForCurrentValue();
      }
      
      public function setValueWithoutBarAnimation(param1:int) : void
      {
         this.setValue(param1);
         this.mValue = param1;
         this.mAddedValue = 0;
         this.mTime = 0;
         this.setFrameForCurrentValue();
      }
      
      public function getFrameForCurrentValue() : int
      {
         return this.getFrameForGivenValue(this.mValue);
      }
      
      private function setFrameForCurrentValue() : void
      {
         this.mBarMC.gotoAndStop(this.getFrameForCurrentValue());
      }
      
      public function getFrameForGivenValue(param1:Number) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 >= this.mMinValue)
         {
            _loc2_ = this.mMaxValue;
            _loc3_ = this.mMinValue;
         }
         else
         {
            _loc2_ = this.mMaxValuePrevious;
            _loc3_ = this.mMinValuePrevious;
         }
         var _loc4_:Number = param1 - _loc3_;
         var _loc5_:int = this.mBarMC.totalFrames * _loc4_ / (_loc2_ - _loc3_);
         return int(Math.max(0,Math.min(_loc5_,this.mBarMC.totalFrames)));
      }
      
      private function setFrameForGivenValue(param1:Number) : void
      {
         this.mBarMC.gotoAndStop(this.getFrameForGivenValue(param1));
      }
      
      public function logicUpdate(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(this.LINER_PROGRESS)
         {
            if(this.mAddedValue != 0)
            {
               _loc2_ = 0;
               if(this.mAddedValue > 0)
               {
                  this.mAddedValueRemainder += Math.min(this.mAddedValue,this.mAddedValueSpeed * param1);
               }
               else if(this.mAddedValue < 0)
               {
                  this.mAddedValueRemainder += Math.max(this.mAddedValue,this.mAddedValueSpeed * param1);
               }
               _loc2_ = this.mAddedValueRemainder;
               this.mAddedValueRemainder -= _loc2_;
               this.mValue += _loc2_;
               this.mAddedValue -= _loc2_;
               this.mTime -= param1;
               if(this.mTime <= 0)
               {
                  if(this.mAddedValue != 0)
                  {
                     this.mValue += this.mAddedValue;
                     this.mAddedValue = 0;
                     this.mTime = 0;
                  }
               }
               this.setFrameForCurrentValue();
            }
         }
         else if(this.mTime > 0)
         {
            this.mTime = Math.max(0,this.mTime - param1);
            _loc3_ = this.mTime / ANIMATION_TIME;
            _loc3_ *= _loc3_;
            _loc3_ = 1 - _loc3_;
            this.setFrameForGivenValue(this.mValue + this.mAddedValue * _loc3_);
            if(this.mTime == 0)
            {
               this.mValue += this.mAddedValue;
               this.setFrameForCurrentValue();
               this.mAddedValue = 0;
            }
         }
      }
   }
}
