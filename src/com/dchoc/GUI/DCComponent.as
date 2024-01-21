package com.dchoc.GUI
{
   import com.dchoc.utils.CursorManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DCComponent extends MovieClip
   {
      
      public static const EVENT_WINDOW_CLOSED:String = "EVENT_WINDOW_CLOSED";
      
      public static const COMPONENT_FRAME_NAME_INTRO:String = "In";
      
      public static const COMPONENT_FRAME_NAME_NORMAL:String = "Open";
      
      public static const COMPONENT_FRAME_NAME_OUTRO:String = "Out";
      
      public static const INSTANCE_NAME_MODAL_SQUARE:String = "Modal_Square";
      
      public static const MODAL_ALPHA_RECTANGLE_COLOR:Number = 0;
      
      public static var MODAL_ALPHA_RECTANGLE_ALPHA_VALUE:Number = 0.6;
      
      public static var mIsModalWindowOpen:Boolean;
      
      private static const FADE_DURATION:int = 500;
      
      public static const STATE_UNDEFINED:int = 0;
      
      public static const STATE_OPENING:int = 1;
      
      public static const STATE_READY:int = 2;
      
      public static const STATE_CLOSING:int = 3;
      
      protected static var smNumberModalWindowsOpen:int = 0;
       
      
      private var mModalSquare:Sprite;
      
      private var mModalSquareChildIndex:int = -1;
      
      private var mCloseAnimationFrameNumber:int;
      
      protected var mParent:DisplayObjectContainer;
      
      protected var mIsModal:Boolean;
      
      protected var mCustomModalSquare:Sprite;
      
      protected var mModalSquareAlphaTimer:int;
      
      protected var mModalSquareTargetAlpha:Number;
      
      protected var mModalSquareStartAlpha:Number;
      
      private var mTime:Number = -1;
      
      protected var mState:int = 0;
      
      protected var mOpenAnimation:MovieClip;
      
      public function DCComponent()
      {
         super();
         gotoAndStop(1);
      }
      
      public static function isAModalWindowOpen() : Boolean
      {
         return smNumberModalWindowsOpen > 0;
      }
      
      protected function setModal() : void
      {
         this.mIsModal = true;
         var _loc1_:DisplayObject = this.mParent.getChildByName(INSTANCE_NAME_MODAL_SQUARE) as DisplayObject;
         if(_loc1_ == null)
         {
            this.mCustomModalSquare = new Sprite();
            this.mCustomModalSquare.name = INSTANCE_NAME_MODAL_SQUARE;
            this.mCustomModalSquare.graphics.beginFill(MODAL_ALPHA_RECTANGLE_COLOR);
            this.mCustomModalSquare.graphics.drawRect(0,0,this.mParent.width,this.mParent.height);
            if(this.mOpenAnimation)
            {
               this.mCustomModalSquare.alpha = 0;
               this.mModalSquareStartAlpha = 0;
               this.mModalSquareTargetAlpha = MODAL_ALPHA_RECTANGLE_ALPHA_VALUE;
               this.mModalSquareAlphaTimer = 0;
            }
            else
            {
               this.mCustomModalSquare.alpha = MODAL_ALPHA_RECTANGLE_ALPHA_VALUE;
            }
            this.mCustomModalSquare.graphics.endFill();
            this.mCustomModalSquare.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseHandler,false);
            this.mCustomModalSquare.addEventListener(MouseEvent.MOUSE_UP,this.mouseHandler,false);
            this.mCustomModalSquare.addEventListener(MouseEvent.CLICK,this.mouseHandler,false);
            this.mCustomModalSquare.addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseHandler,false);
            this.mParent.addChild(this.mCustomModalSquare);
         }
         else
         {
            this.mModalSquareChildIndex = this.mParent.getChildIndex(_loc1_);
            this.mParent.setChildIndex(_loc1_,this.mParent.numChildren - 1);
         }
         this.mModalSquare = _loc1_ as Sprite;
         mIsModalWindowOpen = true;
         ++smNumberModalWindowsOpen;
      }
      
      private function mouseHandler(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
      
      protected function removeModalSquare() : void
      {
         var _loc1_:DisplayObject = null;
         if(this.isModal())
         {
            --smNumberModalWindowsOpen;
            _loc1_ = this.mParent.getChildByName(INSTANCE_NAME_MODAL_SQUARE) as DisplayObject;
            if(_loc1_)
            {
               if(this.mModalSquareChildIndex == -1)
               {
                  mIsModalWindowOpen = false;
                  this.mParent.removeChild(_loc1_);
                  _loc1_ = null;
               }
               else
               {
                  this.mParent.setChildIndex(_loc1_,this.mModalSquareChildIndex);
               }
            }
            if(this.mCustomModalSquare != null)
            {
               this.mCustomModalSquare.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseHandler);
               this.mCustomModalSquare.removeEventListener(MouseEvent.MOUSE_UP,this.mouseHandler);
               this.mCustomModalSquare.removeEventListener(MouseEvent.CLICK,this.mouseHandler);
               this.mCustomModalSquare.removeEventListener(MouseEvent.MOUSE_WHEEL,this.mouseHandler);
               this.mCustomModalSquare = null;
            }
            this.mIsModal = false;
         }
      }
      
      public function isModal() : Boolean
      {
         return this.mIsModal;
      }
      
      public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         this.mParent = param1;
         if(param2)
         {
            this.setModal();
         }
         this.mParent.addChild(this);
         CursorManager.getInstance().bringToFront();
         if(this.mOpenAnimation != null)
         {
            addEventListener(Event.ENTER_FRAME,this.enterFrame,false,0,true);
            this.mState = STATE_OPENING;
            gotoAndPlay(COMPONENT_FRAME_NAME_INTRO);
         }
      }
      
      public function close() : void
      {
         this.mState = STATE_CLOSING;
         if(this.mCustomModalSquare)
         {
            this.mCustomModalSquare.alpha = MODAL_ALPHA_RECTANGLE_ALPHA_VALUE;
            this.mModalSquareStartAlpha = MODAL_ALPHA_RECTANGLE_ALPHA_VALUE;
            this.mModalSquareTargetAlpha = 0;
            this.mModalSquareAlphaTimer = 0;
         }
         if(this.mOpenAnimation == null)
         {
            this.clean();
         }
         else
         {
            this.mOpenAnimation.gotoAndPlay(COMPONENT_FRAME_NAME_OUTRO);
         }
      }
      
      public function enterFrame(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         if(this.mCustomModalSquare)
         {
            _loc2_ = new Date().getTime();
            if(this.mTime == -1)
            {
               this.mTime = _loc2_;
            }
            _loc3_ = _loc2_ - this.mTime;
            this.mTime = _loc2_;
            this.mModalSquareAlphaTimer += _loc3_;
            if(this.mModalSquareAlphaTimer > FADE_DURATION)
            {
               this.mModalSquareAlphaTimer = FADE_DURATION;
            }
            _loc4_ = this.mModalSquareAlphaTimer / FADE_DURATION;
            this.mCustomModalSquare.alpha = this.mModalSquareStartAlpha * (1 - _loc4_) + this.mModalSquareTargetAlpha * _loc4_;
         }
         switch(this.mState)
         {
            case STATE_OPENING:
               if(this.mOpenAnimation.currentLabel == COMPONENT_FRAME_NAME_NORMAL)
               {
                  this.mOpenAnimation.stop();
                  this.mCloseAnimationFrameNumber = this.mOpenAnimation.totalFrames - this.mOpenAnimation.currentFrame - 1;
                  this.mState = STATE_READY;
               }
               break;
            case STATE_READY:
               break;
            case STATE_CLOSING:
               if(this.mOpenAnimation.currentFrame == this.mOpenAnimation.totalFrames)
               {
                  stop();
                  this.clean();
                  this.dispatchEvent(new Event(EVENT_WINDOW_CLOSED));
               }
               break;
            default:
               if(Config.DEBUG_MODE)
               {
               }
         }
      }
      
      public function clean() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.enterFrame);
         this.mState = STATE_UNDEFINED;
         this.removeModalSquare();
         if(this.mParent != null)
         {
            this.mParent.removeChild(this);
            this.mParent = null;
         }
      }
      
      public function isClosed() : Boolean
      {
         return this.mState == STATE_UNDEFINED;
      }
      
      public function getState() : int
      {
         return this.mState;
      }
      
      public function centerClip() : void
      {
         x = stage.stageWidth >> 1;
         y = stage.stageHeight >> 1;
      }
      
      public function setPos(param1:int, param2:int) : void
      {
         x = param1;
         y = param2;
      }
      
      public function getX() : int
      {
         return x;
      }
      
      public function getY() : int
      {
         return y;
      }
      
      public function logicUpdate(param1:int) : void
      {
      }
   }
}
