package game.gui
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import game.states.GameState;
   
   public class TooltipHUD extends Sprite
   {
      
      private static const MARGIN:Number = 3;
       
      
      private var mMainClip:MovieClip;
      
      public var mMaxAppearDelayMs:int;
      
      private var mAppearDelayMs:int;
      
      private var mAppearTimer:Timer;
      
      private var mTitle:TextField;
      
      private var mDescription:TextField;
      
      private var mBody:Sprite;
      
      private var mOffsetX:Number;
      
      private var mOffsetY:Number;
      
      private var mLockedWidth:Number;
      
      private var mFollowsMouse:Boolean;
      
      public var mVisible:Boolean;
      
      public var mUpdated:Boolean;
      
      public function TooltipHUD(param1:int, param2:int = 0, param3:Boolean = false)
      {
         super();
         var _loc4_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"tooltip_details");
         this.mMainClip = new _loc4_();
         this.mTitle = (this.mMainClip.getChildAt(0) as MovieClip).getChildAt(2) as TextField;
         this.mDescription = (this.mMainClip.getChildAt(0) as MovieClip).getChildAt(1) as TextField;
         this.mBody = (this.mMainClip.getChildAt(0) as MovieClip).getChildAt(0) as MovieClip;
         mouseEnabled = false;
         mouseChildren = false;
         this.mOffsetX = this.mBody.getBounds(this.mMainClip).left;
         this.mOffsetY = this.mBody.getBounds(this.mMainClip).top;
         this.mTitle.defaultTextFormat = this.mTitle.getTextFormat();
         this.mDescription.defaultTextFormat = this.mDescription.getTextFormat();
         this.mTitle.wordWrap = true;
         this.mDescription.wordWrap = true;
         this.mTitle.autoSize = TextFieldAutoSize.CENTER;
         this.mDescription.autoSize = TextFieldAutoSize.CENTER;
         this.mLockedWidth = param1;
         this.mTitle.width = param1 - 2 * MARGIN;
         this.mDescription.width = param1 - 2 * MARGIN;
         this.mBody.width = param1;
         addChild(this.mMainClip);
         this.mMaxAppearDelayMs = param2;
         this.setAppearDelayMs(this.mMaxAppearDelayMs);
         this.mFollowsMouse = param3;
         LocalizationUtils.replaceFonts(this);
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
      
      override public function set visible(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(param1 && !this.mVisible)
         {
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
         var _loc2_:Stage = null;
         var _loc3_:Point = null;
         if(parent)
         {
            _loc2_ = GameState.mInstance.getMainClip().stage;
            _loc3_ = parent.getBounds(_loc2_).topLeft;
            this.x = parent.mouseX;
            this.y = parent.mouseY;
            if(_loc2_.mouseX > GameState.mInstance.getStageWidth() - this.mBody.width - this.mOffsetX)
            {
               x -= this.mBody.width + this.mOffsetX;
            }
            else
            {
               x += this.mOffsetX;
            }
            if(_loc2_.mouseY > GameState.mInstance.getStageHeight() - this.mBody.height - this.mOffsetY - GameState.mInstance.mScene.mGridDimY)
            {
               y -= this.mBody.height + this.mOffsetY;
            }
            else
            {
               y += this.mOffsetY;
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
      
      public function setTitleText(param1:String) : void
      {
         this.mTitle.visible = param1 != null && param1 != "";
         this.mTitle.text = param1;
         this.resize();
      }
      
      public function setDescriptionText(param1:String) : void
      {
         this.mDescription.visible = param1 != null && param1 != "";
         this.mDescription.text = param1;
         this.resize();
      }
      
      private function resize() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = MARGIN;
         this.mTitle.y = _loc1_;
         this.mDescription.y = _loc1_ + this.mTitle.height;
         this.mTitle.x = this.mDescription.x = -(this.mLockedWidth / 2) + MARGIN;
         this.mBody.height = _loc1_ + this.mTitle.height + this.mDescription.height + MARGIN;
         this.mBody.y = this.mBody.height / 2;
         _loc2_ = this.mMainClip.getChildAt(0) as MovieClip;
         _loc2_.x -= _loc2_.getBounds(this.mMainClip).left;
         _loc2_.y -= _loc2_.getBounds(this.mMainClip).top;
         this.mUpdated = true;
      }
   }
}
