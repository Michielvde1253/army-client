package com.dchoc.events
{
   import com.dchoc.GUI.DCButton;
   import flash.events.Event;
   
   public class ButtonEvent extends Event
   {
       
      
      public var mButtonType:int;
      
      public var mButtonID:String;
      
      public var mButton:DCButton;
      
      public function ButtonEvent(param1:DCButton, param2:String, param3:int, param4:String = "", param5:Boolean = false, param6:Boolean = false)
      {
         super(param2);
         this.mButtonType = param3;
         this.mButtonID = param4;
         this.mButton = param1;
      }
      
      public function getButton() : DCButton
      {
         return this.mButton;
      }
      
      public function getID() : String
      {
         return this.mButtonID;
      }
      
      public function getButtonType() : int
      {
         return this.mButtonType;
      }
   }
}
