package com.dchoc.GUI
{
   import com.dchoc.utils.DCUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class DCScrollBar extends MovieClip
   {
      
      public static const MOVE_PIXELS:int = 4;
       
      
      private var mButtonUp:DCButton;
      
      private var mButtonDown:DCButton;
      
      private var mButtonHandle:DCButton;
      
      private var mTargetClip:MovieClip;
      
      private var mTargetClipOriginalY:int;
      
      private var mTargetOriginalHeight:Number;
      
      private var mScrollBarClip:Sprite;
      
      private var mHandlerTop:Number;
      
      private var mHandlerBottom:Number;
      
      private var mHandlerRange:Number;
      
      private var mIsUp:Boolean;
      
      private var mIsDown:Boolean;
      
      private var mHandlerDragRect:Rectangle;
      
      private var mRootMC:MovieClip;
      
      private var mScrollUpCallback:Function;
      
      private var mScrollDownCallback:Function;
      
      public function DCScrollBar(param1:MovieClip, param2:MovieClip, param3:Number, param4:Number)
      {
         super();
         this.mScrollBarClip = param1;
         this.mTargetClip = param2;
         this.mTargetOriginalHeight = param4;
         this.mButtonUp = new DCButton(this,this.mScrollBarClip.getChildByName(DCWindow.INSTANCE_NAME_SCROLL_BAR_BUTTON_UP) as MovieClip,DCButton.BUTTON_TYPE_SCROLL_UP,null,null,this.upScroll,null,null,this.stopScroll,this.upScrollControlHandler);
         this.mButtonDown = new DCButton(this,this.mScrollBarClip.getChildByName(DCWindow.INSTANCE_NAME_SCROLL_BAR_BUTTON_DOWN) as MovieClip,DCButton.BUTTON_TYPE_SCROLL_DOWN,null,null,this.downScroll,null,null,this.stopScroll,this.downScrollControlHandler);
         this.mButtonHandle = new DCButton(this,this.mScrollBarClip.getChildByName(DCWindow.INSTANCE_NAME_SCROLL_BAR_HANDLE) as MovieClip,DCButton.BUTTON_TYPE_SCROLL_HANDLE_VERTICAL,null,null,this.dragScroll,null,null,this.stopScroll,null);
         this.init();
         this.setMaskWithSize(param3,param4);
         this.mScrollUpCallback = null;
         this.mScrollDownCallback = null;
      }
      
      public function setScrollUpCallback(param1:Function) : void
      {
         this.mScrollUpCallback = param1;
      }
      
      public function setScrollDownCallback(param1:Function) : void
      {
         this.mScrollDownCallback = param1;
      }
      
      public function getButtonUp() : DCButton
      {
         return this.mButtonUp;
      }
      
      public function getButtonDown() : DCButton
      {
         return this.mButtonDown;
      }
      
      private function init() : void
      {
         this.mTargetClipOriginalY = this.mTargetClip.y;
         if(this.mTargetOriginalHeight >= this.mTargetClip.height)
         {
            this.mScrollBarClip.visible = false;
         }
         this.mHandlerTop = this.mButtonHandle.getY();
         this.mHandlerBottom = this.mButtonDown.getY();
         this.mHandlerDragRect = new Rectangle(0,this.mHandlerTop,0,this.mHandlerBottom - this.mButtonHandle.getHeight() * 2);
         this.mHandlerRange = this.mHandlerDragRect.height;
         this.mRootMC = DCUtils.getRoot(this.mTargetClip);
      }
      
      private function setMaskWithSize(param1:Number, param2:Number) : void
      {
         var _loc4_:MovieClip = null;
         var _loc3_:MovieClip = this.mTargetClip.parent.getChildByName(DCWindow.INSTANCE_NAME_MASK) as MovieClip;
         if(_loc3_)
         {
            param1 = _loc3_.width;
            param2 = _loc3_.height;
         }
         else
         {
            (_loc4_ = new MovieClip()).graphics.beginFill(0);
            _loc4_.graphics.drawRect(this.mTargetClip.x,this.mTargetClip.y,param1,param2);
            this.mTargetClip.parent.addChild(_loc4_);
            this.mTargetClip.mask = _loc4_;
         }
      }
      
      public function upScroll(param1:MouseEvent) : void
      {
         this.mIsUp = true;
         if(this.mScrollUpCallback != null)
         {
            this.mScrollUpCallback(param1);
         }
      }
      
      public function downScroll(param1:MouseEvent) : void
      {
         this.startScroll();
         this.mIsDown = true;
         if(this.mScrollDownCallback != null)
         {
            this.mScrollDownCallback(param1);
         }
      }
      
      public function upScrollControlHandler(param1:Event) : void
      {
         if(this.mIsUp)
         {
            if(this.mButtonHandle.getY() > this.mHandlerTop)
            {
               this.mButtonHandle.setY(this.mButtonHandle.getY() - MOVE_PIXELS);
               if(this.mButtonHandle.getY() < this.mHandlerTop)
               {
                  this.mButtonHandle.setY(this.mHandlerTop);
               }
               this.startScroll();
            }
         }
      }
      
      public function downScrollControlHandler(param1:Event) : void
      {
         if(this.mIsDown)
         {
            if(this.mButtonHandle.getY() + this.mButtonHandle.getHeight() < this.mHandlerBottom)
            {
               this.mButtonHandle.setY(this.mButtonHandle.getY() + MOVE_PIXELS);
               if(this.mButtonHandle.getY() + this.mButtonHandle.getHeight() > this.mHandlerBottom)
               {
                  this.mButtonHandle.setY(this.mHandlerBottom - this.mButtonHandle.getHeight());
               }
               this.startScroll();
            }
         }
      }
      
      public function moveScroll(param1:MouseEvent) : void
      {
         this.startScroll();
      }
      
      public function startScroll() : void
      {
         var _loc1_:int = this.mTargetClip.height - this.mTargetOriginalHeight;
         var _loc2_:Number = (this.mButtonHandle.getY() - this.mHandlerTop) / this.mHandlerRange;
         var _loc3_:Number = _loc1_ * _loc2_;
         this.mTargetClip.y = this.mTargetClipOriginalY - int(_loc3_);
      }
      
      public function stopScroll(param1:MouseEvent) : void
      {
         this.mIsDown = this.mIsUp = false;
         this.mButtonHandle.stopDrag();
         this.mRootMC.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveScroll);
         this.mRootMC.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         removeEventListener(MouseEvent.MOUSE_MOVE,this.moveScroll);
      }
      
      public function dragScroll(param1:MouseEvent) : void
      {
         this.mButtonHandle.startDrag(false,this.mHandlerDragRect);
         this.mRootMC.addEventListener(MouseEvent.MOUSE_MOVE,this.moveScroll,false,0,true);
         this.mRootMC.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll,false,0,true);
         addEventListener(MouseEvent.MOUSE_MOVE,this.moveScroll,false,0,true);
      }
      
      public function clean() : void
      {
         this.mButtonUp.clean();
         this.mButtonDown.clean();
         this.mButtonHandle.clean();
      }
   }
}
