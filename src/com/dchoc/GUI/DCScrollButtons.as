package com.dchoc.GUI
{
   import com.dchoc.utils.DCUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
   public class DCScrollButtons extends MovieClip
   {
      
      public static const MOVE_PIXELS:int = 25;
       
      
      private var mButtonLeft:DCButton;
      
      private var mButtonRight:DCButton;
      
      private var mButtonHome:DCButton;
      
      private var mButtonEnd:DCButton;
      
      private var mTargetClip:MovieClip;
      
      private var mTargetClipOriginalX:Number;
      
      private var mTargetClipOriginalY:Number;
      
      private var mTargetClipOriginalEndX:Number;
      
      private var mTargetClipOriginalEndY:Number;
      
      private var mTargetClipDestinationX:Number;
      
      private var mTargetClipDestinationY:Number;
      
      private var mTargetClipBeforeMoveX:Number;
      
      private var mTargetClipBeforeMoveY:Number;
      
      private var mScrollBarClip:Sprite;
      
      private var mRootMC:MovieClip;
      
      private var mLastTime:Number;
      
      private var mAmountToMoveOnAClickX:Number;
      
      private var mAmountToMoveOnAClickY:Number;
      
      private var mAmountToMoveOneItemOnAClickX:Number;
      
      private var mTargetOriginalWidth:Number;
      
      private var mTargetOriginalHeight:Number;
      
      private var mScrollLeftCallback:Function;
      
      private var mScrollRightCallback:Function;
      
      private var mScrollHomeCallback:Function;
      
      private var mScrollEndCallback:Function;
      
      private var mScrollSpeed:int;
      
      public function DCScrollButtons(param1:Sprite, param2:MovieClip, param3:Number, param4:Number, param5:int = -1, param6:Number = 0)
      {
         super();
         this.mAmountToMoveOnAClickX = param3;
         this.mAmountToMoveOnAClickY = param4;
         this.mAmountToMoveOneItemOnAClickX = param6;
         this.mScrollBarClip = param1;
         this.mTargetClip = param2;
         var _loc7_:MovieClip;
         if(_loc7_ = this.mScrollBarClip.getChildByName(DCWindow.INSTANCE_NAME_SCROLL_BAR_BUTTON_LEFT) as MovieClip)
         {
            this.mButtonLeft = new DCButton(this,_loc7_,DCButton.BUTTON_TYPE_SCROLL_LEFT);
            this.mButtonLeft.setMouseClickFunction(this.leftScroll);
         }
         if(_loc7_ = this.mScrollBarClip.getChildByName(DCWindow.INSTANCE_NAME_SCROLL_BAR_BUTTON_RIGHT) as MovieClip)
         {
            this.mButtonRight = new DCButton(this,_loc7_,DCButton.BUTTON_TYPE_SCROLL_RIGHT);
            this.mButtonRight.setMouseClickFunction(this.rightScroll);
         }
         if(_loc7_ = this.mScrollBarClip.getChildByName(DCWindow.INSTANCE_NAME_SCROLL_BAR_BUTTON_HOME) as MovieClip)
         {
            this.mButtonHome = new DCButton(this,_loc7_,DCButton.BUTTON_TYPE_SCROLL_HOME);
            this.mButtonHome.setMouseClickFunction(this.home);
         }
         if(_loc7_ = this.mScrollBarClip.getChildByName(DCWindow.INSTANCE_NAME_SCROLL_BAR_BUTTON_END) as MovieClip)
         {
            this.mButtonEnd = new DCButton(this,_loc7_,DCButton.BUTTON_TYPE_SCROLL_END);
            this.mButtonEnd.setMouseClickFunction(this.end);
         }
         this.setPredefinedMask();
         this.init();
         this.setScrollSpeed(param5);
         this.checkBoundaries();
         this.mScrollLeftCallback = null;
         this.mScrollRightCallback = null;
         this.mScrollHomeCallback = null;
         this.mScrollEndCallback = null;
      }
      
      public function setScrollCallbacks(param1:Function, param2:Function, param3:Function, param4:Function) : void
      {
         this.mScrollLeftCallback = param1;
         this.mScrollRightCallback = param2;
         this.mScrollHomeCallback = param3;
         this.mScrollEndCallback = param4;
      }
      
      private function setPredefinedMask() : void
      {
         var _loc1_:MovieClip = this.mScrollBarClip.getChildByName(DCWindow.INSTANCE_NAME_MASK) as MovieClip;
         this.mTargetOriginalWidth = _loc1_.width;
         this.mTargetOriginalHeight = _loc1_.height;
      }
      
      private function setScrollSpeed(param1:int) : void
      {
         if(param1 == -1)
         {
            this.mScrollSpeed = MOVE_PIXELS;
         }
         else
         {
            this.mScrollSpeed = param1;
         }
      }
      
      private function init() : void
      {
         this.mTargetClipBeforeMoveX = this.mTargetClipOriginalX = this.mTargetClipDestinationX = this.mTargetClip.x;
         this.mTargetClipBeforeMoveY = this.mTargetClipOriginalY = this.mTargetClipDestinationY = this.mTargetClip.y;
         this.updateSize();
         addEventListener(Event.ENTER_FRAME,this.enterFrameFunction,false,0,true);
         this.mRootMC = DCUtils.getRoot(this.mTargetClip);
      }
      
      public function updateSize() : void
      {
         this.mTargetClipOriginalEndX = this.mTargetClipOriginalX - this.mTargetClip.width + this.mTargetOriginalWidth;
         this.mTargetClipOriginalEndY = this.mTargetClipOriginalY - this.mTargetClip.height + this.mTargetOriginalHeight;
         this.checkBoundaries();
      }
      
      public function setPosition(param1:int = 2147483647, param2:int = 2147483647, param3:Boolean = true) : void
      {
         if(param1 != int.MAX_VALUE)
         {
            this.mTargetClipDestinationX = Math.max(this.mTargetClipOriginalX - param1 * this.mAmountToMoveOnAClickX,this.mTargetClipOriginalEndX);
            if(param3)
            {
               this.mTargetClip.x = this.mTargetClipDestinationX;
               this.checkBoundaries();
            }
         }
         if(param2 != int.MAX_VALUE)
         {
            this.mTargetClipDestinationY = this.mTargetClipOriginalY - param2 * this.mAmountToMoveOnAClickY;
            if(param3)
            {
               this.mTargetClip.y = this.mTargetClipDestinationY;
               this.checkBoundaries();
            }
         }
      }
      
      public function areWeScrolling() : Boolean
      {
         return Math.abs(this.mTargetClip.x - this.mTargetClipDestinationX) > 0.1;
      }
      
      public function leftScroll(param1:MouseEvent) : void
      {
         if(this.areWeScrolling())
         {
            return;
         }
         if(this.canScrollLeft())
         {
            this.mTargetClipDestinationX += this.mAmountToMoveOnAClickX;
         }
         if(this.mScrollLeftCallback != null)
         {
            this.mScrollLeftCallback(param1,-1);
         }
      }
      
      public function rightScroll(param1:MouseEvent) : void
      {
         if(this.areWeScrolling())
         {
            return;
         }
         if(this.canScrollRight())
         {
            this.mTargetClipDestinationX -= this.mAmountToMoveOnAClickX;
         }
         if(this.mScrollRightCallback != null)
         {
            this.mScrollRightCallback(param1,1);
         }
      }
      
      public function home(param1:MouseEvent, param2:Boolean = false) : void
      {
         if(param2)
         {
            this.mTargetClipDestinationX = this.mTargetClipOriginalX;
            this.mTargetClip.x = this.mTargetClipDestinationX;
            this.checkBoundaries();
         }
         else
         {
            this.mTargetClipDestinationX = this.mTargetClipOriginalX;
         }
         if(this.mScrollHomeCallback != null)
         {
            this.mScrollHomeCallback(param1,(this.mTargetClip.x - this.mTargetClipOriginalX) / this.mAmountToMoveOnAClickX);
         }
      }
      
      public function end(param1:MouseEvent, param2:Boolean = false) : void
      {
         var _loc3_:Number = NaN;
         if(this.mTargetClipOriginalEndX > -this.mAmountToMoveOnAClickX)
         {
            _loc3_ = this.mTargetClip.x - this.mAmountToMoveOnAClickX;
         }
         else
         {
            _loc3_ = this.mTargetClipOriginalEndX;
         }
         if(param2)
         {
            this.mTargetClipDestinationX = _loc3_;
            this.mTargetClip.x = this.mTargetClipDestinationX;
            this.checkBoundaries();
         }
         else
         {
            this.mTargetClipDestinationX = _loc3_;
         }
         if(this.mScrollEndCallback != null)
         {
            this.mScrollEndCallback(param1,(this.mTargetClip.x - this.mTargetClipDestinationX) / this.mAmountToMoveOnAClickX);
         }
      }
      
      public function enterFrameFunction(param1:Event) : void
      {
         this.mLastTime = getTimer();
         if(this.mTargetClip.x > this.mTargetClipDestinationX)
         {
            this.mTargetClip.x = Math.max(this.mTargetClipDestinationX,this.mTargetClip.x - this.mScrollSpeed);
            this.checkBoundaries();
         }
         else if(this.mTargetClip.x < this.mTargetClipDestinationX)
         {
            this.mTargetClip.x = Math.min(this.mTargetClipDestinationX,this.mTargetClip.x + this.mScrollSpeed);
            this.checkBoundaries();
         }
      }
      
      private function canScrollRight() : Boolean
      {
         var _loc1_:Number = this.mTargetClip.width - this.mTargetOriginalWidth - this.mTargetClipOriginalX + this.mTargetClip.x;
         return _loc1_ >= this.mAmountToMoveOneItemOnAClickX;
      }
      
      private function canScrollLeft() : Boolean
      {
         return Math.abs(this.mTargetClip.x - this.mTargetClipOriginalX) > this.mAmountToMoveOnAClickX / 2;
      }
      
      private function checkBoundaries() : void
      {
         if(this.mAmountToMoveOnAClickX != 0)
         {
            if(!this.canScrollLeft())
            {
               if(this.mButtonLeft)
               {
                  this.mButtonLeft.setEnabled(false);
               }
               if(this.mButtonHome)
               {
                  this.mButtonHome.setEnabled(false);
               }
            }
            else
            {
               if(this.mButtonLeft)
               {
                  this.mButtonLeft.setEnabled(true);
               }
               if(this.mButtonHome)
               {
                  this.mButtonHome.setEnabled(true);
               }
            }
            if(!this.canScrollRight())
            {
               if(this.mButtonRight)
               {
                  this.mButtonRight.setEnabled(false);
               }
               if(this.mButtonEnd)
               {
                  this.mButtonEnd.setEnabled(false);
               }
            }
            else
            {
               if(this.mButtonRight)
               {
                  this.mButtonRight.setEnabled(true);
               }
               if(this.mButtonEnd)
               {
                  this.mButtonEnd.setEnabled(true);
               }
            }
         }
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         if(this.mButtonLeft)
         {
            this.mButtonLeft.setEnabled(param1);
         }
         if(this.mButtonRight)
         {
            this.mButtonRight.setEnabled(param1);
         }
         if(this.mButtonHome)
         {
            this.mButtonHome.setEnabled(param1);
         }
         if(this.mButtonEnd)
         {
            this.mButtonEnd.setEnabled(param1);
         }
      }
      
      public function clean() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.enterFrameFunction);
         if(this.mButtonLeft)
         {
            this.mButtonLeft.clean();
         }
         if(this.mButtonRight)
         {
            this.mButtonRight.clean();
         }
         if(this.mButtonHome)
         {
            this.mButtonHome.clean();
         }
         if(this.mButtonEnd)
         {
            this.mButtonEnd.clean();
         }
      }
   }
}
