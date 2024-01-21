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
   import game.gameElements.EnemyInstallationObject;
   import game.gameElements.PlayerInstallationObject;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.Renderable;
   import game.states.GameState;
   
   public class TooltipHealth extends Sprite
   {
      
      public static const TYPE_DEFAULT:int = 0;
      
      public static const TYPE_BUILDING:int = 1;
      
      public static const TYPE_ATTACK:int = 2;
      
      public static const TYPE_ENEMY:int = 3;
      
      public static const TYPE_ENEMY_BUILDING:int = 4;
      
      public static const TYPE_DETAILS:int = 5;
      
      public static const TYPE_BUILDING_WATERPLANT:int = 6;
      
      public static const TYPE_INFO:int = 7;
      
      private static const MARGIN:Number = 4;
       
      
      private var mType:int;
      
      private var mMainClip:MovieClip;
      
      private var mAppearDelayMs:int;
      
      private var mAppearTimer:Timer;
      
      private var mTitle:TextField;
      
      private var mFirePowerText:TextField;
      
      private var mFirePowerTextValue:TextField;
      
      private var mFireRangeText:TextField;
      
      private var mFireRangeTextValue:TextField;
      
      private var mFirePowerIcon:MovieClip;
      
      private var mFireRangeIcon:MovieClip;
      
      private var mHealthBar:MovieClip;
      
      private var mDetails:TextField;
      
      private var mAttackSummaryTitle:TextField;
      
      private var mAttackSummaryValue:TextField;
      
      private var mAttackSummaryIcon:MovieClip;
      
      private var mAttackSummaryIconValue:TextField;
      
      private var mWaterAmount:TextField;
      
      private var mBody:Sprite;
      
      private var mOffsetX:Number;
      
      private var mOffsetY:Number;
      
      private var mLockedWidth:Number;
      
      private var mDefaultHeight:Number;
      
      private var mFollowsMouse:Boolean;
      
      private var mVisible:Boolean;
      
      private var mDeltaT:int;
      
      private var mRenderable:Renderable;
      
      private var mObjectHealth:int;
      
      private var mObjectMaxHealth:int;
      
      private var mLastMouseX:Number = 0;
      
      private var mLastMouseY:Number = 0;
      
      public function TooltipHealth(param1:int, param2:int, param3:int = 0, param4:Boolean = false)
      {
         var _loc5_:Class = null;
         var _loc6_:MovieClip = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         super();
         this.mType = param1;
         this.mDeltaT = Math.ceil(1000 / GameState.mInstance.getMainClip().stage.frameRate);
         switch(this.mType)
         {
            case TYPE_BUILDING:
               _loc6_ = new (_loc5_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"tooltip_building"))();
               this.mMainClip = _loc6_.getChildAt(0) as MovieClip;
               this.mTitle = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(3) as TextField;
               this.mHealthBar = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(2) as MovieClip;
               this.mDetails = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(0) as TextField;
               this.mDetails.text = "";
               this.mFirePowerText = null;
               this.mFirePowerIcon = null;
               this.mFireRangeIcon = null;
               this.mFireRangeText = null;
               this.mFireRangeTextValue = null;
               this.mFirePowerTextValue = null;
               break;
            case TYPE_ATTACK:
               _loc6_ = new (_loc5_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"tooltip_attack"))();
               this.mMainClip = _loc6_.getChildAt(0) as MovieClip;
               this.mTitle = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(8) as TextField;
               this.mFirePowerText = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(3) as TextField;
               this.mFirePowerIcon = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(4) as MovieClip;
               this.mFireRangeText = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(0) as TextField;
               this.mFireRangeIcon = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(2) as MovieClip;
               this.mFireRangeTextValue = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(1) as TextField;
               this.mFirePowerTextValue = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(5) as TextField;
               this.mHealthBar = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(6) as MovieClip;
               this.mAttackSummaryTitle = (this.mMainClip.getChildAt(5) as MovieClip).getChildAt(0) as TextField;
               this.mAttackSummaryTitle.text = GameState.getText("TOOLTIP_UNIT_ATTACK_POWER_TITLE");
               this.mAttackSummaryValue = (this.mMainClip.getChildAt(5) as MovieClip).getChildAt(3) as TextField;
               this.mAttackSummaryValue.autoSize = TextFieldAutoSize.LEFT;
               this.mAttackSummaryIcon = (this.mMainClip.getChildAt(5) as MovieClip).getChildAt(1) as MovieClip;
               this.mAttackSummaryIcon.gotoAndStop(1);
               this.mAttackSummaryIconValue = (this.mMainClip.getChildAt(5) as MovieClip).getChildAt(2) as TextField;
               this.mDetails = null;
               break;
            case TYPE_ENEMY:
               _loc6_ = new (_loc5_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"tooltip_enemy"))();
               this.mMainClip = _loc6_.getChildAt(0) as MovieClip;
               this.mTitle = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(8) as TextField;
               this.mFirePowerText = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(3) as TextField;
               this.mFirePowerIcon = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(4) as MovieClip;
               this.mFireRangeText = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(0) as TextField;
               this.mFireRangeIcon = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(2) as MovieClip;
               this.mFireRangeTextValue = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(1) as TextField;
               this.mFirePowerTextValue = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(5) as TextField;
               this.mHealthBar = (this.mMainClip.getChildAt(6) as MovieClip).getChildAt(6) as MovieClip;
               this.mDetails = this.mMainClip.getChildAt(5) as TextField;
               this.mDetails.text = "";
               break;
            case TYPE_ENEMY_BUILDING:
               _loc6_ = new (_loc5_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"tooltip_building_enemy"))();
               this.mMainClip = _loc6_.getChildAt(0) as MovieClip;
               this.mTitle = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(3) as TextField;
               this.mHealthBar = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(2) as MovieClip;
               this.mDetails = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(0) as TextField;
               this.mDetails.text = "";
               this.mFirePowerText = null;
               this.mFirePowerIcon = null;
               this.mFireRangeText = null;
               this.mFireRangeIcon = null;
               this.mFireRangeTextValue = null;
               this.mFirePowerTextValue = null;
               break;
            case TYPE_DETAILS:
               _loc6_ = new (_loc5_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"tooltip_default_details"))();
               this.mMainClip = _loc6_.getChildAt(0) as MovieClip;
               this.mTitle = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(8) as TextField;
               this.mFirePowerText = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(3) as TextField;
               this.mFirePowerIcon = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(4) as MovieClip;
               this.mFireRangeText = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(0) as TextField;
               this.mFireRangeIcon = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(2) as MovieClip;
               this.mFireRangeTextValue = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(1) as TextField;
               this.mFirePowerTextValue = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(5) as TextField;
               this.mHealthBar = (this.mMainClip.getChildAt(3) as MovieClip).getChildAt(6) as MovieClip;
               this.mDetails = this.mMainClip.getChildAt(2) as TextField;
               this.mDetails.text = "";
               break;
            case TYPE_BUILDING_WATERPLANT:
               _loc6_ = new (_loc5_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"tooltip_building_waterplant"))();
               this.mMainClip = _loc6_.getChildAt(0) as MovieClip;
               this.mTitle = (this.mMainClip.getChildAt(2) as MovieClip).getChildAt(4) as TextField;
               this.mWaterAmount = (this.mMainClip.getChildAt(2) as MovieClip).getChildAt(2) as TextField;
               this.mDetails = (this.mMainClip.getChildAt(2) as MovieClip).getChildAt(0) as TextField;
               this.mDetails.text = "";
               this.mFirePowerText = null;
               this.mFirePowerIcon = null;
               this.mFireRangeText = null;
               this.mFireRangeIcon = null;
               this.mFireRangeTextValue = null;
               this.mFirePowerTextValue = null;
               this.mHealthBar = null;
               break;
            case TYPE_INFO:
               _loc6_ = new (_loc5_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"tooltip_details"))();
               this.mMainClip = _loc6_.getChildAt(0) as MovieClip;
               this.mTitle = this.mMainClip.getChildAt(2) as TextField;
               this.mWaterAmount = null;
               this.mDetails = this.mMainClip.getChildAt(1) as TextField;
               this.mDetails.text = "";
               this.mFirePowerText = null;
               this.mFirePowerIcon = null;
               this.mFireRangeText = null;
               this.mFireRangeIcon = null;
               this.mFireRangeTextValue = null;
               this.mFirePowerTextValue = null;
               this.mHealthBar = null;
               break;
            default:
               _loc6_ = new (_loc5_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"tooltip_default"))();
               this.mMainClip = _loc6_.getChildAt(0) as MovieClip;
               this.mTitle = (this.mMainClip.getChildAt(2) as MovieClip).getChildAt(8) as TextField;
               this.mFirePowerText = (this.mMainClip.getChildAt(2) as MovieClip).getChildAt(3) as TextField;
               this.mFirePowerIcon = (this.mMainClip.getChildAt(2) as MovieClip).getChildAt(4) as MovieClip;
               this.mFireRangeText = (this.mMainClip.getChildAt(2) as MovieClip).getChildAt(0) as TextField;
               this.mFireRangeIcon = (this.mMainClip.getChildAt(2) as MovieClip).getChildAt(2) as MovieClip;
               this.mFireRangeTextValue = (this.mMainClip.getChildAt(2) as MovieClip).getChildAt(1) as TextField;
               this.mFirePowerTextValue = (this.mMainClip.getChildAt(2) as MovieClip).getChildAt(5) as TextField;
               this.mHealthBar = (this.mMainClip.getChildAt(2) as MovieClip).getChildAt(6) as MovieClip;
               this.mDetails = null;
         }
         this.mBody = this.mMainClip.getChildAt(0) as MovieClip;
         mouseEnabled = false;
         mouseChildren = false;
         this.mOffsetX = this.mBody.getBounds(this.mMainClip).left;
         this.mOffsetY = this.mBody.getBounds(this.mMainClip).top;
         this.mTitle.autoSize = TextFieldAutoSize.CENTER;
         LocalizationUtils.replaceFonts(_loc6_);
         if(this.mFirePowerText)
         {
            this.mFirePowerText.text = GameState.getText("TOOLTIP_UNIT_FIRE_POWER");
            this.mFirePowerText.width = this.mFirePowerText.textWidth;
            this.mFirePowerText.multiline = false;
            this.mFirePowerText.wordWrap = false;
            this.mFirePowerText.autoSize = TextFieldAutoSize.LEFT;
         }
         if(this.mFireRangeText)
         {
            this.mFireRangeText.text = GameState.getText("TOOLTIP_UNIT_FIRE_RANGE");
            this.mFireRangeText.width = this.mFireRangeText.textWidth;
            this.mFireRangeText.multiline = false;
            this.mFireRangeText.wordWrap = false;
            this.mFireRangeText.autoSize = TextFieldAutoSize.LEFT;
            _loc7_ = Math.max(this.mFirePowerText.x + this.mFirePowerText.width,this.mFireRangeText.x + this.mFireRangeText.width);
         }
         if(this.mFirePowerIcon)
         {
            this.mFirePowerIcon.gotoAndStop(1);
            this.mFirePowerIcon.x = _loc7_;
         }
         if(this.mFireRangeIcon)
         {
            _loc8_ = Math.max(this.mFirePowerIcon.width,this.mFireRangeIcon.width);
            this.mFireRangeIcon.gotoAndStop(1);
            this.mFireRangeIcon.x = _loc7_ + _loc8_ / 2;
         }
         _loc7_ += _loc8_;
         if(this.mFireRangeTextValue)
         {
            this.mFireRangeTextValue.autoSize = TextFieldAutoSize.LEFT;
            this.mFireRangeTextValue.x = _loc7_;
         }
         if(this.mFirePowerTextValue)
         {
            this.mFirePowerTextValue.autoSize = TextFieldAutoSize.LEFT;
            this.mFirePowerTextValue.x = _loc7_;
         }
         this.mLockedWidth = param2;
         this.mBody.width = param2;
         this.mDefaultHeight = this.mBody.height;
         addChild(this.mMainClip);
         this.mObjectHealth = -999;
         this.mAppearDelayMs = param3;
         this.mFollowsMouse = param4;
         this.resize();
         this.visible = false;
         super.visible = false;
      }
      
      public function setOffsets(param1:int, param2:int) : void
      {
         this.mOffsetX = param1;
         this.mOffsetY = param2;
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
            addEventListener(Event.ENTER_FRAME,this.logicUpdate);
         }
         else if(!param1 && this.mVisible)
         {
            if(this.mAppearTimer)
            {
               this.mAppearTimer.stop();
               this.mAppearTimer.removeEventListener(TimerEvent.TIMER,this.appearTimerTick);
               this.mAppearTimer = null;
            }
            removeEventListener(Event.ENTER_FRAME,this.logicUpdate);
         }
         if(this.mVisible != param1)
         {
            super.visible = false;
         }
         this.mVisible = param1;
      }
      
      private function logicUpdate(param1:Event) : void
      {
         if(this.mFollowsMouse)
         {
            this.moveTooltip(param1);
         }
         if(Boolean(this.mRenderable) && Boolean(this.mRenderable.getCell()))
         {
            this.mRenderable.updateTooltip(this.mDeltaT,this);
         }
         else
         {
            this.visible = false;
         }
      }
      
      public function setRenderable(param1:Renderable) : void
      {
         this.mRenderable = param1;
         if(this.mRenderable is IsometricCharacter)
         {
            if(this.mFireRangeTextValue)
            {
               this.mFireRangeTextValue.text = "x" + IsometricCharacter(this.mRenderable).mAttackRange;
               this.mFirePowerTextValue.text = "x" + IsometricCharacter(this.mRenderable).getPower();
               this.mFirePowerIcon.visible = true;
            }
         }
         else if(this.mRenderable is PlayerInstallationObject)
         {
            if(this.mFireRangeTextValue)
            {
               this.mFireRangeTextValue.text = "x" + PlayerInstallationObject(this.mRenderable).mAttackRange;
               this.mFirePowerTextValue.text = "x" + PlayerInstallationObject(this.mRenderable).getPower();
            }
         }
         else if(this.mRenderable is EnemyInstallationObject)
         {
            if(this.mFireRangeTextValue)
            {
               this.mFireRangeTextValue.text = "x" + EnemyInstallationObject(this.mRenderable).mAttackRange;
               if(EnemyInstallationObject(this.mRenderable).getPower() > 0)
               {
                  this.mFirePowerIcon.visible = true;
                  this.mFirePowerTextValue.text = "x" + EnemyInstallationObject(this.mRenderable).getPower();
               }
               else
               {
                  this.mFirePowerIcon.visible = false;
               }
            }
         }
      }
      
      public function moveTooltip(param1:Event) : void
      {
         var _loc2_:Stage = null;
         var _loc3_:Point = null;
         if(parent)
         {
            if(parent.mouseX == this.mLastMouseX && parent.mouseY == this.mLastMouseY)
            {
               return;
            }
            this.mLastMouseX = parent.mouseX;
            this.mLastMouseY = parent.mouseY;
            _loc2_ = GameState.mInstance.getMainClip().stage;
            _loc3_ = parent.getBounds(_loc2_).topLeft;
            this.x = parent.mouseX + (this.mBody.width >> 1);
            this.y = parent.mouseY + (this.mBody.height >> 1) + 20;
            if(_loc2_.mouseX > GameState.mInstance.getStageWidth() - this.mBody.width + this.mOffsetX)
            {
               x -= this.mBody.width - this.mOffsetX + 10;
            }
            else
            {
               x -= this.mBody.width - this.mOffsetX;
            }
            if(_loc2_.mouseY > GameState.mInstance.getStageHeight() - this.mBody.height + this.mOffsetY - GameState.mInstance.mScene.mGridDimY)
            {
               y -= this.mBody.height - this.mOffsetY * 2;
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
      
      public function setHealth(param1:int, param2:int) : void
      {
         var _loc3_:TextField = null;
         if(this.mObjectHealth != param1 || param2 != this.mObjectMaxHealth)
         {
            this.mObjectHealth = param1;
            this.mObjectMaxHealth = param2;
            this.mHealthBar.gotoAndStop(int(param1 / param2 * this.mHealthBar.totalFrames));
            _loc3_ = this.mHealthBar.getChildAt(4) as TextField;
            _loc3_.text = param1 + "/" + param2;
            _loc3_.wordWrap = false;
            _loc3_.width = _loc3_.textWidth + 9;
            this.resize();
         }
      }
      
      public function setWaterAmountText(param1:String) : void
      {
         this.mWaterAmount.text = param1;
      }
      
      public function setTitleText(param1:String) : void
      {
         if(Boolean(this.mTitle) && this.mTitle.text != param1)
         {
            this.mTitle.visible = param1 != null && param1 != "";
            this.mTitle.text = param1;
            this.resize();
         }
      }
      
      public function setDetailsText(param1:String) : void
      {
         if(Boolean(this.mDetails) && this.mDetails.text != param1)
         {
            this.mDetails.visible = param1 != null && param1 != "";
            this.mDetails.text = param1;
            this.resize();
         }
      }
      
      public function setAttackValues(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.mAttackSummaryValue)
         {
            _loc2_ = 100;
            if(param1 < this.mObjectHealth)
            {
               _loc2_ = param1 / this.mObjectHealth * 100;
            }
            this.mAttackSummaryValue.text = _loc2_ + "%";
            this.mAttackSummaryIconValue.text = "x" + param1;
            this.resize();
         }
      }
      
      private function resize() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         if(Math.max(this.mTitle.width,!!this.mHealthBar ? this.mHealthBar.width : 0) > this.mLockedWidth - 2 * MARGIN)
         {
            this.mBody.width = Math.max(this.mTitle.width,!!this.mHealthBar ? this.mHealthBar.width : 0) + 2 * MARGIN;
         }
         else if(this.mBody.width != this.mLockedWidth)
         {
            this.mBody.width = this.mLockedWidth;
         }
         if(this.mDetails)
         {
            _loc1_ = 15;
            if(this.mHealthBar)
            {
               _loc1_ *= 2;
            }
            _loc2_ = this.mDetails.textHeight > _loc1_ ? int(this.mDefaultHeight + this.mDetails.textHeight - _loc1_) : int(this.mDefaultHeight);
            this.mBody.y += (_loc2_ - int(this.mBody.height)) / 2;
            this.mDetails.height = this.mDetails.textHeight + 5;
            this.mBody.height = _loc2_;
         }
      }
   }
}
