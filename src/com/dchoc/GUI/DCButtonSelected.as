package com.dchoc.GUI
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class DCButtonSelected extends DCButton
   {
       
      
      protected var mSelected:Boolean;
      
      private var mPool:Array;
      
      protected var mAllowDeselection:Boolean;
      
      public function DCButtonSelected(param1:DisplayObjectContainer, param2:MovieClip, param3:int, param4:String = null, param5:EventDispatcher = null, param6:Function = null, param7:Function = null, param8:Function = null, param9:Function = null, param10:Function = null, param11:Boolean = true)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
         this.mSelected = false;
         this.setAllowDeselection(true);
      }
      
      public function isSelected() : Boolean
      {
         return this.mSelected;
      }
      
      public function setAllowDeselection(param1:Boolean) : void
      {
         this.mAllowDeselection = param1;
      }
      
      public function select() : void
      {
         this.unselectAllInPool();
         this.mSelected = true;
         playAnim(BUTTON_FRAME_NAME_SELECTED_UP);
      }
      
      public function unselect(param1:Boolean = false) : void
      {
         if(this.mSelected)
         {
            if(param1 || this.mAllowDeselection)
            {
               this.mSelected = false;
               playAnim(BUTTON_FRAME_NAME_UP);
            }
         }
      }
      
      public function setPool(param1:Array) : void
      {
         param1.push(this);
         this.mPool = param1;
      }
      
      public function unselectAllInPool() : void
      {
         if(this.mPool == null)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.mPool.length)
         {
            (this.mPool[_loc1_] as DCButtonSelected).unselect(true);
            _loc1_++;
         }
      }
      
      override protected function mouseDown(param1:MouseEvent) : void
      {
         if(DCButton.TRIGGER_AT_MOUSE_UP)
         {
            super.mouseDown(param1);
            return;
         }
         if(!this.isEnable())
         {
            return;
         }
         this.buttonClicked(param1);
      }
      
      override protected function buttonClicked(param1:MouseEvent) : void
      {
         if(this.mSelected)
         {
            this.unselect();
         }
         else
         {
            this.select();
         }
         super.buttonClicked(param1);
      }
      
      override protected function mouseUp(param1:MouseEvent) : void
      {
         if(DCButton.TRIGGER_AT_MOUSE_UP)
         {
            super.mouseUp(param1);
            return;
         }
         if(!this.isEnable())
         {
            return;
         }
         if(this.mSelected)
         {
            if(mMouseUpFunction != null)
            {
               mMouseUpFunction(param1);
            }
            return;
         }
         super.mouseUp(param1);
      }
      
      override protected function mouseOut(param1:MouseEvent) : void
      {
         if(this.mSelected)
         {
            hideHelper();
            return;
         }
         super.mouseOut(param1);
      }
      
      override protected function mouseOver(param1:MouseEvent) : void
      {
         if(this.mSelected)
         {
            showHelper();
            return;
         }
         super.mouseOver(param1);
      }
   }
}
