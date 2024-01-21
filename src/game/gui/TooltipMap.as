package game.gui
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import game.states.GameState;
   
   public class TooltipMap extends MovieClip
   {
      
      private static const MARGIN:Number = 3;
       
      
      private var mMainClip:MovieClip;
      
      public var mMaxAppearDelayMs:int;
      
      private var mAppearDelayMs:int;
      
      private var mAppearTimer:Timer;
      
      private var mTitle:AutoTextField;
      
      private var mDescription:TextField;
      
      private var mIconClip:MovieClip;
      
      private var mBody:MovieClip;
      
      private var mOffsetX:Number;
      
      private var mOffsetY:Number;
      
      private var mLockedWidth:Number;
      
      private var mFollowsMouse:Boolean;
      
      public var mVisible:Boolean;
      
      public var mUpdated:Boolean;
      
      public function TooltipMap(param1:int, param2:int = 0, param3:Boolean = true)
      {
         super();
         var _loc4_:Class = DCResourceManager.getInstance().getSWFClass("swf/map","tooltip_campaign");
         this.mMainClip = new _loc4_();
         this.mTitle = new AutoTextField((this.mMainClip.getChildAt(0) as MovieClip).getChildByName("Text_Title") as TextField);
         this.mDescription = (this.mMainClip.getChildAt(0) as MovieClip).getChildByName("Text_Details") as TextField;
         this.mBody = (this.mMainClip.getChildAt(0) as MovieClip).getChildByName("Tooltip_Bg") as MovieClip;
         this.mIconClip = (this.mMainClip.getChildAt(0) as MovieClip).getChildByName("Campaign_Icon") as MovieClip;
         mouseEnabled = false;
         mouseChildren = false;
         this.mOffsetX = this.mBody.getBounds(this.mMainClip).left;
         this.mOffsetY = this.mBody.getBounds(this.mMainClip).top;
         this.mLockedWidth = param1;
         this.mBody.width = param1;
         this.mDescription.wordWrap = true;
         this.mDescription.autoSize = TextFieldAutoSize.LEFT;
         this.mTitle.setBoxWidth(this.mLockedWidth - 2 * MARGIN);
         this.mDescription.width = this.mLockedWidth - 2 * MARGIN;
         addChild(this.mMainClip);
         this.mMaxAppearDelayMs = param2;
         this.setAppearDelayMs(this.mMaxAppearDelayMs);
         this.mFollowsMouse = param3;
         this.resize();
         this.visible = false;
         super.visible = false;
         this.mUpdated = false;
      }
      
      public function setAppearDelayMs(param1:int) : void
      {
         this.mAppearDelayMs = param1;
      }
      
      public function setOffsets(param1:int, param2:int) : void
      {
         this.mMainClip.x = param1;
         this.mMainClip.y = param2;
      }
      
      public function setPosition(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(param1 && !this.mVisible)
         {
            LocalizationUtils.replaceFonts(this);
            _loc2_ = Math.ceil(1000 / GameState.mInstance.getMainClip().stage.frameRate);
            this.mAppearTimer = new Timer(_loc2_);
            this.mAppearTimer.addEventListener(TimerEvent.TIMER,this.appearTimerTick);
            this.mAppearTimer.start();
            if(this.mFollowsMouse)
            {
               addEventListener(Event.ENTER_FRAME,this.moveTooltip);
            }
         }
         else if(!param1 && this.mVisible)
         {
            if(this.mAppearTimer)
            {
               this.mAppearTimer.stop();
               this.mAppearTimer.removeEventListener(TimerEvent.TIMER,this.appearTimerTick);
               this.mAppearTimer = null;
            }
            if(this.mFollowsMouse)
            {
               removeEventListener(Event.ENTER_FRAME,this.moveTooltip);
            }
         }
         if(this.mVisible != param1)
         {
            super.visible = false;
         }
         this.mVisible = param1;
      }
      
      private function moveTooltip(param1:Event) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         if(parent)
         {
            _loc2_ = GameState.mInstance.getMainClip();
            _loc3_ = parent.getBounds(_loc2_).topLeft;
            this.x = parent.mouseX;
            this.y = parent.mouseY;
            _loc4_ = 30;
            if(_loc2_.mouseX > GameState.mInstance.getStageWidth() - this.mBody.width - this.mOffsetX)
            {
               x -= this.mBody.width + this.mOffsetX + _loc4_;
            }
            else
            {
               x = x + this.mOffsetX + _loc4_;
            }
            if(_loc2_.mouseY > GameState.mInstance.getStageHeight() - this.mBody.height - this.mOffsetY - GameState.mInstance.mScene.mGridDimY)
            {
               y -= this.mBody.height + this.mOffsetY + (_loc4_ >> 1);
            }
            else
            {
               y = y + this.mOffsetY + _loc4_;
            }
         }
      }
      
      public function appearTimerTick(param1:TimerEvent) : void
      {
         if(Boolean(this.mAppearTimer) && this.mAppearTimer.currentCount * this.mAppearTimer.delay > this.mAppearDelayMs)
         {
            this.mAppearTimer.removeEventListener(TimerEvent.TIMER,this.appearTimerTick);
            this.mAppearTimer.stop();
            this.mAppearTimer = null;
            super.visible = true;
         }
      }
      
      public function setText(param1:String, param2:String) : void
      {
         this.mTitle.setText(param1);
         this.mDescription.text = param2;
         this.resize();
      }
      
      private function resize() : void
      {
         this.mTitle.setBoxX(MARGIN);
         this.mDescription.x = MARGIN;
         this.mBody.height = MARGIN * 2 + this.mTitle.getBoxHeight() * 2 + this.mDescription.textHeight;
      }
   }
}
