package com.dchoc.GUI
{
   import flash.display.Sprite;
   
   public class DCMessageBox extends DCWindow
   {
      
      public static const BUTTONS_CUSTOM:int = 0;
      
      public static const BUTTONS_OK:int = 1;
      
      public static const BUTTONS_YES_NO:int = 4;
      
      public static const BUTTONS_OK_CANCEL:int = 8;
      
      public static const BUTTONS_NONE:int = 16;
       
      
      private var leftButton:DCButton;
      
      private var rightButton:DCButton;
      
      public function DCMessageBox(param1:Sprite, param2:String, param3:String, param4:int, param5:Function = null, param6:int = -1, param7:String = null, param8:int = -1, param9:String = null)
      {
         var _loc11_:String = null;
         super(param1,param2,param5);
         if(!(BUTTONS_NONE & param4))
         {
            addCloseButton(DCButton.BUTTON_TYPE_X);
         }
         var _loc10_:Boolean = true;
         do
         {
            if((_loc11_ = param3.replace("\\n","\n")) == param3)
            {
               _loc10_ = false;
            }
            param3 = _loc11_;
         }
         while(_loc10_);
         
         setText(mDesign,"TextMessage",param3);
         if(param4 == BUTTONS_CUSTOM)
         {
            if(param6 == -1)
            {
               setDisplayObjectVisible("Button_Left",false);
            }
            else
            {
               this.leftButton = createButton(DCButton,"Button_Left",param6,param7);
            }
            if(param8 == -1)
            {
               setDisplayObjectVisible("Button_Right",false);
            }
            else
            {
               this.rightButton = createButton(DCButton,"Button_Right",param8,param9);
            }
         }
         else if(BUTTONS_NONE & param4)
         {
            setDisplayObjectVisible("Button_Left",false);
            setDisplayObjectVisible("Button_Right",false);
            setDisplayObjectVisible(INSTANCE_NAME_BUTTON_CLOSE,false);
         }
         else if(BUTTONS_YES_NO & param4)
         {
            this.leftButton = createButton(DCButton,"Button_Left",DCButton.BUTTON_TYPE_NO,"no");
            this.rightButton = createButton(DCButton,"Button_Right",DCButton.BUTTON_TYPE_YES,"yes");
         }
         else if(BUTTONS_OK_CANCEL & param4)
         {
            this.leftButton = createButton(DCButton,"Button_Left",DCButton.BUTTON_TYPE_OK,"ok");
            this.rightButton = createButton(DCButton,"Button_Right",DCButton.BUTTON_TYPE_CANCEL,"cancel");
         }
         else if(BUTTONS_OK & param4)
         {
            setDisplayObjectVisible("Button_Left",false);
            this.rightButton = createButton(DCButton,"Button_Right",DCButton.BUTTON_TYPE_OK,"ok");
         }
      }
      
      public function setButtonTexts(param1:String, param2:String) : void
      {
         if(this.leftButton != null)
         {
            this.leftButton.setText(param1);
         }
         if(this.rightButton != null)
         {
            this.rightButton.setText(param2);
         }
      }
      
      public function setMessage(param1:String) : void
      {
         setText(mDesign,"TextMessage",param1);
      }
   }
}
