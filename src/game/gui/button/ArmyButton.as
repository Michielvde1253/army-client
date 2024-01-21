package game.gui.button
{
   import com.dchoc.GUI.DCButton;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.sound.ArmySoundManager;
   
   public class ArmyButton extends DCButton
   {
      
      public static const BUTTON_PADDING:int = 30;
      
      public static const MAX_BUTTON_WIDTH_DEFAULT:int = 120;
       
      
      protected var mMaxWidth:int;
      
      protected var mClickSound:String;
      
      protected var mOverSound:String;
      
      public var resizeNeeded:Boolean;
      
      public function ArmyButton(param1:DisplayObjectContainer, param2:MovieClip, param3:int, param4:String = null, param5:EventDispatcher = null, param6:Function = null, param7:Function = null, param8:Function = null, param9:Function = null, param10:Function = null, param11:Boolean = true)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
         this.mClickSound = ArmySoundManager.SFX_UI_CLICK;
         this.mMaxWidth = MAX_BUTTON_WIDTH_DEFAULT;
         this.resizeNeeded = true;
      }
      
      public function setSounds(param1:String, param2:String = null) : void
      {
         this.mClickSound = param1;
         this.mOverSound = param2;
      }
      
      override protected function mouseOver(param1:MouseEvent) : void
      {
         super.mouseOver(param1);
         if(this.mOverSound)
         {
            ArmySoundManager.getInstance().playSound(this.mOverSound);
         }
      }
      
      override protected function buttonClicked(param1:MouseEvent) : void
      {
         super.buttonClicked(param1);
         if(this.mClickSound)
         {
            ArmySoundManager.getInstance().playSound(this.mClickSound);
         }
      }
      
      override public function setText(param1:String, param2:String = "Text") : void
      {
         super.setText(param1,param2);
         var _loc3_:TextField = mButton.getChildByName("Text_Background_01") as TextField;
         var _loc4_:TextField = mButton.getChildByName("Text_Background_02") as TextField;
         if(_loc3_ && param1 != null && param1 != "")
         {
            _loc3_.text = param1;
         }
         if(_loc4_ && param1 != null && param1 != "")
         {
            _loc4_.text = param1;
         }
         if(this.resizeNeeded)
         {
            this.recalculateSize();
         }
      }
      
      protected function recalculateSize() : void
      {
         var _loc1_:TextField = mButton.getChildByName(this.buttonTextFieldName) as TextField;
         Utils.lowerFontToMatchTextField(_loc1_);
      }
   }
}
