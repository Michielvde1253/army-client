package game.gui.fireMission
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.items.FireMissionItem;
   import game.states.GameState;
   
   public class FireMissionStatsFrame
   {
       
      
      private var mParent:DisplayObjectContainer;
      
      private var mClip:DisplayObjectContainer;
      
      private var mPowerTF:TextField;
      
      private var mPowerAmountTF:TextField;
      
      private var mRangeTF:TextField;
      
      private var mRangeAmountTF:TextField;
      
      private var mPowerIcon:MovieClip;
      
      private var mRangeIcon:MovieClip;
      
      public function FireMissionStatsFrame(param1:DisplayObjectContainer, param2:DisplayObjectContainer)
      {
         super();
         this.mParent = param2;
         this.mClip = param1;
         this.mPowerTF = param1.getChildByName("Text_Fire_Power") as TextField;
         this.mRangeTF = param1.getChildByName("Text_Fire_Range") as TextField;
         this.mRangeAmountTF = param1.getChildByName("Text_Fire_Range_Value") as TextField;
         this.mPowerAmountTF = param1.getChildByName("Text_Fire_Power_Value") as TextField;
         this.mPowerIcon = param1.getChildByName("Fire_Power_Own") as MovieClip;
         this.mRangeIcon = param1.getChildByName("Icon_Range") as MovieClip;
      }
      
      public function setItem(param1:FireMissionItem) : void
      {
         this.show();
         this.mRangeTF.autoSize = TextFieldAutoSize.LEFT;
         this.mRangeTF.wordWrap = false;
         this.mRangeTF.multiline = false;
         this.mRangeTF.text = GameState.getText("TOOLTIP_UNIT_FIRE_RANGE");
         this.mRangeTF.width = this.mRangeTF.textWidth;
         this.mPowerTF.autoSize = TextFieldAutoSize.LEFT;
         this.mPowerTF.wordWrap = false;
         this.mPowerTF.multiline = false;
         this.mPowerTF.text = GameState.getText("TOOLTIP_UNIT_FIRE_POWER");
         this.mPowerTF.width = this.mPowerTF.textWidth;
         this.mRangeAmountTF.text = param1.mSize.x + "x" + param1.mSize.y;
         this.mPowerIcon.gotoAndStop(1);
         this.mPowerAmountTF.text = "x" + param1.mDamage;
         var _loc2_:int = Math.max(this.mPowerIcon.width / 2 + this.mPowerTF.x + this.mPowerTF.width,this.mRangeIcon.width / 2 + this.mRangeTF.x + this.mRangeTF.width);
         this.mPowerIcon.x = _loc2_;
         this.mRangeIcon.x = _loc2_;
         this.mPowerAmountTF.x = _loc2_ + this.mPowerIcon.width / 2;
         this.mRangeAmountTF.x = this.mPowerAmountTF.x;
      }
      
      public function hide() : void
      {
         if(this.mClip.parent)
         {
            this.mClip.parent.removeChild(this.mClip);
         }
      }
      
      public function show() : void
      {
         if(!this.mClip.parent)
         {
            this.mParent.addChild(this.mClip);
         }
      }
   }
}
