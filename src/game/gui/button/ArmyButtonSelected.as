package game.gui.button
{
   import com.dchoc.GUI.DCButtonSelected;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import game.sound.ArmySoundManager;
   
   public class ArmyButtonSelected extends DCButtonSelected
   {
       
      
      protected var mClickSound:String;
      
      protected var mOverSound:String;
      
      protected var mMaxWidth:int;
      
      public function ArmyButtonSelected(param1:DisplayObjectContainer, param2:MovieClip, param3:int, param4:String = null, param5:EventDispatcher = null, param6:Function = null, param7:Function = null, param8:Function = null, param9:Function = null, param10:Function = null, param11:Boolean = true)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
         this.mClickSound = ArmySoundManager.SFX_UI_CLICK;
         this.mMaxWidth = ArmyButton.MAX_BUTTON_WIDTH_DEFAULT;
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
      
      override protected function mouseUp(param1:MouseEvent) : void
      {
         if(!mSelected || mAllowDeselection)
         {
            super.mouseUp(param1);
         }
      }
      
      override protected function mouseDown(param1:MouseEvent) : void
      {
         if(!mSelected || mAllowDeselection)
         {
            super.mouseDown(param1);
         }
      }
      
      public function getClip() : MovieClip
      {
         return mButton;
      }
      
      public function _mouseDown(param1:MouseEvent) : void
      {
         this.mouseDown(param1);
      }
      
      public function _mouseUp(param1:MouseEvent) : void
      {
         this.mouseUp(param1);
      }
      
      public function _mouseOver(param1:MouseEvent) : void
      {
         this.mouseOver(param1);
      }
      
      public function _mouseOut(param1:MouseEvent) : void
      {
         mouseOut(param1);
      }
      
      public function _mouseClick(param1:MouseEvent) : void
      {
         mouseClick(param1);
      }
   }
}
