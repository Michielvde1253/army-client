package com.dchoc.GUI
{
   import com.dchoc.events.*;
   import com.dchoc.graphics.DCResourceManager;
   import com.dchoc.utils.*;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class DCWindow extends DCComponent
   {
      
      public static const EVENT_BUTTON_CLICKED:String = "BUTTON_CLICKED";
      
      public static const EVENT_BUTTON_OVER:String = "BUTTON_OVER";
      
      public static const EVENT_BUTTON_OUT:String = "BUTTON_OUT";
      
      public static const ALIGN_LEFT:int = 1;
      
      public static const ALIGN_RIGHT:int = 2;
      
      public static const RES_TYPE_TEXT:int = 0;
      
      public static const RES_TYPE_ICON:int = 1;
      
      public static const RES_TYPE_ICON_FROM_RES_MANAGER:int = 2;
      
      public static const INSTANCE_NAME_WINDOW_TEXT_FIELD_TITLE:String = "Text_Title";
      
      public static const INSTANCE_NAME_WINDOW_MOVIE_CLIP_TITLE:String = "Title";
      
      public static const INSTANCE_NAME_PANEL_TITLE:String = "Panel_Title";
      
      public static const INSTANCE_NAME_SCROLL_BAR_BUTTON_UP:String = "Button_Up";
      
      public static const INSTANCE_NAME_SCROLL_BAR_BUTTON_DOWN:String = "Button_Down";
      
      public static const INSTANCE_NAME_SCROLL_BAR_BUTTON_LEFT:String = "Button_Left";
      
      public static const INSTANCE_NAME_SCROLL_BAR_BUTTON_RIGHT:String = "Button_Right";
      
      public static const INSTANCE_NAME_SCROLL_BAR_BUTTON_HOME:String = "Button_Home";
      
      public static const INSTANCE_NAME_SCROLL_BAR_BUTTON_END:String = "Button_End";
      
      public static const INSTANCE_NAME_SCROLL_BAR_HANDLE:String = "Handle";
      
      public static const INSTANCE_NAME_MASK:String = "Mask";
      
      public static const INSTANCE_NAME_TEXTBOX_CONTENTS_IN_OPEN_ANIM:String = "Contents";
      
      public static const INSTANCE_NAME_BUTTON_CLOSE:String = "Button_Close";
      
      public static const INSTANCE_NAME_BACKGROUND:String = "Background";
      
      public static const INSTANCE_NAME_BUTTON_BACKGROUND:String = "Base";
      
      public static const INSTANCE_NAME_BACKGROUND_MIDDLE:String = "Background_Middle";
      
      public static const INSTANCE_NAME_BACKGROUND_RIGHT:String = "Background_Right";
      
      public static const POSITION_DOWN_MIDDLE:int = 1;
      
      public static const POSITION_MIDDLE:int = 2;
       
      
      private var mButtons:Array;
      
      private var mScrollBars:Array;
      
      protected var mTabs:DCTabs;
      
      private var mHelpers:Array;
      
      protected var mDesign:Sprite;
      
      private var mIsButtonClose:Boolean;
      
      protected var mButtonClickedFunction:Function;
      
      protected var mButtonMouseOverFunction:Function;
      
      protected var mButtonMouseOutFunction:Function;
      
      protected var mCloseButton:DCButton;
      
      public function DCWindow(param1:DisplayObjectContainer, param2:String = null, param3:Function = null, param4:Function = null, param5:Function = null)
      {
         super();
         addChild(param1);
         var _loc6_:DisplayObject = null;
         if(param1 is MovieClip && MovieClip(param1).totalFrames > 1)
         {
            _loc6_ = param1.getChildByName(INSTANCE_NAME_TEXTBOX_CONTENTS_IN_OPEN_ANIM);
         }
         if(_loc6_ != null)
         {
            mOpenAnimation = MovieClip(param1);
            this.mDesign = _loc6_ as Sprite;
         }
         else
         {
            mOpenAnimation = null;
            this.mDesign = param1 as Sprite;
         }
         this.init();
         this.mIsButtonClose = false;
         this.mButtonClickedFunction = param3;
         this.mButtonMouseOverFunction = param4;
         this.mButtonMouseOutFunction = param5;
         this.setTitle(param2);
      }
      
      private function init() : void
      {
         this.mButtons = new Array();
         this.mScrollBars = new Array();
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         super.open(param1,param2);
         addEventListener(EVENT_BUTTON_CLICKED,this.buttonClicked,false,0,true);
         addEventListener(EVENT_BUTTON_OVER,this.buttonMouseOver,false,0,true);
         addEventListener(EVENT_BUTTON_OUT,this.buttonMouseOut,false,0,true);
      }
      
      protected function noMouseAction() : void
      {
         mouseEnabled = false;
         buttonMode = false;
         mouseChildren = false;
      }
      
      public function addCloseButton(param1:int) : void
      {
         this.mIsButtonClose = true;
         this.mCloseButton = this.createButton(DCButton,INSTANCE_NAME_BUTTON_CLOSE,param1);
      }
      
      public function getCloseButton() : DCButton
      {
         return this.mCloseButton;
      }
      
      public function createButton(param1:Class, param2:String, param3:int, param4:String = null, param5:String = null, param6:String = null, param7:String = "") : DCButton
      {
         var _loc8_:MovieClip;
         if((_loc8_ = DCUtils.getChildByPath(this.mDesign,param2) as MovieClip) == null)
         {
            if(Config.DEBUG_MODE)
            {
            }
            return null;
         }
         return this.createButtonOutOfClip(param1,_loc8_,param3,param4,param5,param6,null,param7);
      }
      
      public function createButtonSelected(param1:String, param2:int, param3:String = null, param4:String = null, param5:String = null, param6:Array = null) : DCButtonSelected
      {
         var _loc7_:MovieClip;
         if((_loc7_ = DCUtils.getChildByPath(this.mDesign,param1) as MovieClip) == null)
         {
            if(Config.DEBUG_MODE)
            {
            }
            return null;
         }
         return this.createButtonOutOfClip(DCButtonSelected,_loc7_,param2,param3,param4,param5,param6) as DCButtonSelected;
      }
      
      public function createButtonOutOfClip(param1:Class, param2:MovieClip, param3:int, param4:String = null, param5:String = null, param6:String = null, param7:Array = null, param8:String = "") : DCButton
      {
         var _loc9_:DCButton = new param1(this,param2,param3,param5,this);
         if(param4 != null)
         {
            _loc9_.setText(param4);
         }
         if(param6)
         {
            _loc9_.setHelper(param6,param8);
         }
         this.mButtons.push(_loc9_);
         if(_loc9_ is DCButtonSelected)
         {
            if(param7 != null)
            {
               DCButtonSelected(_loc9_).setPool(param7);
            }
         }
         return _loc9_;
      }
      
      public function getButtons() : Array
      {
         return this.mButtons;
      }
      
      public function setDisplayObjectVisible(param1:String, param2:Boolean) : void
      {
         var _loc3_:DisplayObject = DCUtils.getChildByPath(this.mDesign,param1) as DisplayObject;
         if(_loc3_ != null)
         {
            _loc3_.visible = param2;
         }
      }
      
      public function setDisplayObjectFrame(param1:String, param2:int) : void
      {
         var _loc3_:DisplayObject = DCUtils.getChildByPath(this.mDesign,param1) as DisplayObject;
         if(_loc3_ != null)
         {
            MovieClip(_loc3_).gotoAndStop(param2);
         }
      }
      
      public function focusTextField(param1:String) : void
      {
         var _loc2_:TextField = this.mDesign.getChildByName(param1) as TextField;
         _loc2_.stage.focus = _loc2_;
         _loc2_.setSelection(0,_loc2_.text.length);
      }
      
      public function resizeBackground(param1:DisplayObjectContainer, param2:int, param3:int = 0) : void
      {
         var _loc4_:DisplayObjectContainer;
         if((_loc4_ = param1.getChildByName(DCWindow.INSTANCE_NAME_BACKGROUND) as DisplayObjectContainer) != null)
         {
            _loc4_.width += param2;
            _loc4_.height += param3;
         }
      }
      
      public function getPanelsNumber(param1:Sprite, param2:String) : int
      {
         var _loc3_:Sprite = param1.getChildByName(param2) as Sprite;
         var _loc4_:int = 0;
         do
         {
            _loc4_++;
            _loc3_ = param1.getChildByName(param2 + _loc4_) as Sprite;
         }
         while(_loc3_ != null);
         
         return _loc4_;
      }
      
      public function createPanelsButton(param1:Sprite, param2:String, param3:String, param4:Object, param5:int, param6:String = null, param7:Array = null) : void
      {
         var _loc10_:String = null;
         var _loc11_:MovieClip = null;
         var _loc12_:String = null;
         var _loc8_:DisplayObjectContainer = param1.getChildByName(param2) as DisplayObjectContainer;
         var _loc9_:int = 0;
         do
         {
            _loc10_ = param7 == null ? String(_loc9_) : String(param7[_loc9_]);
            if(param3)
            {
               _loc11_ = _loc8_.getChildByName(param3) as MovieClip;
            }
            else
            {
               _loc11_ = _loc8_ as MovieClip;
            }
            if(param4 is Array)
            {
               _loc12_ = param4[_loc9_] as String;
            }
            else
            {
               _loc12_ = param4 as String;
            }
            this.createButtonOutOfClip(DCButton,_loc11_,param5,_loc12_,_loc10_,param6);
            _loc9_++;
         }
         while((_loc8_ = param1.getChildByName(param2 + _loc9_) as Sprite) != null);
         
      }
      
      public function changePanelsItem(param1:DisplayObjectContainer, param2:String, param3:int, param4:String, param5:Array) : void
      {
         if(param5 == null || param5.length == 0)
         {
            return;
         }
         var _loc6_:DisplayObjectContainer = param1.getChildByName(param2) as DisplayObjectContainer;
         var _loc7_:int = 0;
         do
         {
            this.setItem(param3,_loc6_,param4,param5[_loc7_]);
            _loc7_++;
         }
         while((_loc6_ = param1.getChildByName(param2 + _loc7_) as DisplayObjectContainer) != null && param5[_loc7_] != null);
         
      }
      
      public function addPanelsEventListener(param1:DisplayObjectContainer, param2:String, param3:String, param4:String, param5:Function) : void
      {
         var _loc8_:DisplayObject = null;
         var _loc6_:DisplayObjectContainer = param1.getChildByName(param2) as DisplayObjectContainer;
         var _loc7_:int = 0;
         while(true)
         {
            if(param3 != null)
            {
               if((_loc8_ = DCUtils.getChildByPath(_loc6_,param3)) == null)
               {
                  break;
               }
            }
            _loc7_++;
            if((_loc6_ = param1.getChildByName(param2 + _loc7_) as DisplayObjectContainer) == null)
            {
               return;
            }
         }
      }
      
      public function getPanelAt(param1:DisplayObjectContainer, param2:String, param3:int) : DisplayObjectContainer
      {
         var _loc4_:DisplayObjectContainer = null;
         if(param3 == 0)
         {
            _loc4_ = param1.getChildByName(param2) as Sprite;
         }
         else
         {
            _loc4_ = param1.getChildByName(param2 + param3) as Sprite;
         }
         return _loc4_;
      }
      
      public function changePanelsFrameAt(param1:Sprite, param2:String, param3:String, param4:int, param5:String) : void
      {
         var _loc7_:MovieClip = null;
         var _loc6_:DisplayObjectContainer = this.getPanelAt(param1,param2,param4);
         if(param3)
         {
            _loc6_ = _loc6_.getChildByName(param3) as MovieClip;
         }
         if(_loc6_)
         {
            _loc7_ = _loc6_ as MovieClip;
            MovieClip(_loc6_).gotoAndStop(param5);
         }
      }
      
      public function setPanelVisibleAt(param1:Sprite, param2:String, param3:String, param4:int, param5:Boolean) : void
      {
         var _loc6_:DisplayObjectContainer = this.getPanelAt(param1,param2,param4);
         if(param3)
         {
            _loc6_ = _loc6_.getChildByName(param3) as Sprite;
         }
         if(_loc6_)
         {
            _loc6_.visible = param5;
         }
      }
      
      public function constructScrollBar(param1:MovieClip, param2:MovieClip, param3:Number, param4:Number) : DCScrollBar
      {
         return new DCScrollBar(param1,param2,param3,param4);
      }
      
      public function constructScrollButtons(param1:Sprite, param2:MovieClip, param3:Number, param4:Number, param5:Number, param6:Number, param7:int = -1, param8:Number = 0, param9:int = 2147483647, param10:int = 2147483647) : DCScrollButtons
      {
         var _loc11_:DCScrollButtons;
         (_loc11_ = new DCScrollButtons(param1,param2,param5,param6,param7,param8)).setPosition(param9,param10);
         return _loc11_;
      }
      
      public function addTab(param1:int, param2:DisplayObjectContainer, param3:String, param4:DisplayObjectContainer, param5:String = null, param6:DisplayObject = null, param7:int = -1, param8:String = null, param9:String = "") : void
      {
         if(this.mTabs == null)
         {
            this.mTabs = new (this.getTabsClass())(this);
         }
         param1 = this.mTabs.getSize();
         this.mTabs.addTab(param1,param5,DCUtils.getChildByPath(param2,param3) as MovieClip,param4,true,param6,param7,param8,param9);
         this.mTabs.selectTab(0);
      }
      
      public function getTabs() : DCTabs
      {
         return this.mTabs;
      }
      
      protected function getTabsClass() : Class
      {
         return DCTabs;
      }
      
      public function setTitle(param1:String) : void
      {
         var _loc2_:TextField = null;
         if(param1 != null)
         {
            _loc2_ = this.mDesign.getChildByName(INSTANCE_NAME_WINDOW_TEXT_FIELD_TITLE) as TextField;
            if(_loc2_ != null)
            {
               _loc2_.text = param1;
            }
            else
            {
               DCGuiUtils.setTextAndResizeBackground(this.mDesign.getChildByName(INSTANCE_NAME_WINDOW_MOVIE_CLIP_TITLE) as MovieClip,param1);
            }
         }
      }
      
      protected function setItem(param1:int, param2:DisplayObjectContainer, param3:String, param4:String) : void
      {
         switch(param1)
         {
            case RES_TYPE_TEXT:
               this.setText(param2,param3,param4);
               break;
            case RES_TYPE_ICON:
               if(Config.DEBUG_MODE)
               {
               }
               break;
            case RES_TYPE_ICON_FROM_RES_MANAGER:
               this.setIconFromResManager(param2,param3,param4,null,true);
         }
      }
      
      public function setText(param1:DisplayObjectContainer, param2:String, param3:String) : void
      {
         var _loc4_:TextField = null;
         if(param3 != null)
         {
            if((_loc4_ = DCUtils.getChildByPath(param1,param2) as TextField) == null)
            {
               if(Config.DEBUG_MODE)
               {
               }
               return;
            }
            _loc4_.text = param3;
         }
      }
      
      protected function setTextAndResize(param1:DisplayObjectContainer, param2:String, param3:String) : void
      {
         var _loc4_:TextField = null;
         var _loc5_:int = (_loc4_ = DCUtils.getChildByPath(param1,param2) as TextField).width;
         var _loc6_:int = _loc4_.height;
         _loc4_.text = param3;
         _loc4_.width = _loc4_.textWidth + 5;
         _loc4_.height = _loc4_.textHeight + 5;
         this.resizeBackground(this.mDesign,_loc4_.width - _loc5_,_loc4_.height - _loc6_);
         var _loc7_:DisplayObjectContainer = this.mDesign.getChildByName(DCWindow.INSTANCE_NAME_BACKGROUND) as DisplayObjectContainer;
         _loc4_.x = _loc7_.x - _loc7_.width * 0.5 + 5;
         _loc4_.y = _loc7_.y - _loc7_.height * 0.5 + 5;
      }
      
      protected function setTextForResize(param1:DisplayObjectContainer, param2:String, param3:String) : Number
      {
         var _loc4_:TextField;
         var _loc5_:int = (_loc4_ = DCUtils.getChildByPath(param1,param2) as TextField).width;
         _loc4_.text = param3;
         _loc4_.width = _loc4_.textWidth + 5;
         return _loc4_.width - _loc5_;
      }
      
      protected function getText(param1:DisplayObjectContainer, param2:String) : String
      {
         var _loc3_:DisplayObject = DCUtils.getChildByPath(param1,param2);
         if(_loc3_ == null)
         {
            if(Config.DEBUG_MODE)
            {
            }
            return null;
         }
         return TextField(_loc3_).text;
      }
      
      protected function getTextField(param1:DisplayObjectContainer, param2:String) : String
      {
         var _loc3_:DisplayObject = DCUtils.getChildByPath(param1,param2);
         return TextField(_loc3_).text;
      }
      
      protected function setIconFromResManager(param1:DisplayObjectContainer, param2:String, param3:String, param4:String = null, param5:Boolean = true) : Number
      {
         if(param3 == null || param3 == "")
         {
            return 0;
         }
         var _loc6_:DisplayObject;
         if((_loc6_ = DCResourceManager.getInstance().get(param3) as Sprite) == null)
         {
            return 0;
         }
         return this.setIcon(param1,param2,_loc6_,param4,param5);
      }
      
      protected function setIconFromSwf(param1:DisplayObjectContainer, param2:String, param3:String, param4:String, param5:String = null, param6:Boolean = true, param7:int = 0) : Number
      {
         if(param4 == null || param4 == "")
         {
            return 0;
         }
         var _loc8_:Class;
         if((_loc8_ = DCResourceManager.getInstance().getSWFClass(param3,param4)) == null)
         {
            return 0;
         }
         var _loc9_:DisplayObject = new _loc8_();
         return this.setIcon(param1,param2,_loc9_,param5,param6,param7);
      }
      
      protected function setIconFromSku(param1:DisplayObjectContainer, param2:String, param3:String, param4:String = null, param5:Boolean = true, param6:int = 0) : Number
      {
         if(!AssetManager.SKU[param3])
         {
            return 0;
         }
         var _loc7_:String;
         if((_loc7_ = String(AssetManager.SKU[param3][AssetManager.SKU_GFX_SWF_FILE])) == null)
         {
            return this.setIconFromResManager(param1,param2,AssetManager.SKU[param3][AssetManager.SKU_GFX],param4,param5);
         }
         if(_loc7_ == "constructor")
         {
            return this.setIcon(param1,param2,AssetManager.getInstance().getAssetByName(AssetManager.SKU[param3][AssetManager.SKU_GFX]),param4,param5,param6);
         }
         return this.setIconFromSwf(param1,param2,_loc7_,AssetManager.SKU[param3][AssetManager.SKU_GFX],param4,param5,param6);
      }
      
      protected function setIcon(param1:DisplayObjectContainer, param2:String, param3:DisplayObject, param4:String = null, param5:Boolean = true, param6:int = 0) : Number
      {
         var _loc7_:DisplayObjectContainer = param1;
         if(param2)
         {
            _loc7_ = DCUtils.getChildByPath(param1,param2) as DisplayObjectContainer;
         }
         if(_loc7_ == null)
         {
            if(Config.DEBUG_MODE)
            {
            }
            return 0;
         }
         var _loc8_:DisplayObject;
         var _loc9_:Number = (_loc8_ = _loc7_.getChildAt(0)).x;
         var _loc10_:Number = _loc8_.y;
         var _loc11_:Number = _loc8_.width;
         var _loc12_:Number = _loc8_.height;
         var _loc13_:Number = _loc11_;
         _loc7_.removeChildAt(0);
         if(param4)
         {
            param3.name = param4;
         }
         param3.x = _loc9_;
         param3.y = _loc10_;
         if(POSITION_DOWN_MIDDLE & param6)
         {
            param3.x += _loc11_ / 2;
            param3.y += _loc12_ * 9 / 10;
         }
         else if(POSITION_MIDDLE & param6)
         {
            param3.x += _loc11_ / 2;
            param3.y += _loc12_ / 2;
         }
         if(param5)
         {
            param3.width = _loc11_;
            param3.height = _loc12_;
         }
         _loc7_.addChild(param3);
         return param3.width - _loc13_;
      }
      
      public function setTextAlignedInContainer(param1:String, param2:String, param3:int) : void
      {
         var _loc8_:DisplayObject = null;
         var _loc4_:TextField;
         var _loc5_:Number = (_loc4_ = DCUtils.getChildByPath(this.mDesign,param1) as TextField).textWidth;
         _loc4_.text = param2;
         _loc4_.width = _loc4_.textWidth + 5;
         _loc5_ = _loc4_.textWidth - _loc5_;
         var _loc6_:DisplayObjectContainer = _loc4_.parent;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_.numChildren)
         {
            _loc8_ = _loc6_.getChildAt(_loc7_);
            if(ALIGN_RIGHT & param3)
            {
               if(_loc8_.x < _loc4_.x)
               {
                  _loc8_.x -= _loc5_;
               }
            }
            if(ALIGN_LEFT & param3)
            {
               if(_loc8_.x > _loc4_.x)
               {
                  _loc8_.x += _loc5_;
               }
            }
            _loc7_++;
         }
         if(ALIGN_RIGHT & param3)
         {
            _loc4_.x -= _loc5_;
         }
         else if(ALIGN_LEFT & param3)
         {
            _loc4_.x += _loc5_;
         }
      }
      
      public function setFillBar(param1:String, param2:String, param3:int, param4:int, param5:int = 0) : int
      {
         var _loc6_:TextField;
         (_loc6_ = DCUtils.getChildByPath(this.mDesign,param2) as TextField).text = param3 + "/" + param4;
         var _loc7_:MovieClip;
         return (_loc7_ = DCUtils.getChildByPath(this.mDesign,param1) as MovieClip).totalFrames * (param3 - param5) / (param4 - param5);
      }
      
      public function getChildByPath(param1:String) : DisplayObject
      {
         return DCUtils.getChildByPath(this.mDesign,param1);
      }
      
      public function isButtonOfType(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.mButtons.length)
         {
            if(DCButton(this.mButtons[_loc2_]).getType() == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function buttonClicked(param1:ButtonEvent) : void
      {
         if(this.mButtonClickedFunction != null)
         {
            this.mButtonClickedFunction(param1);
            param1.stopImmediatePropagation();
         }
         switch(param1.mButtonType)
         {
            case DCButton.BUTTON_TYPE_OK:
            case DCButton.BUTTON_TYPE_CANCEL:
            case DCButton.BUTTON_TYPE_YES:
            case DCButton.BUTTON_TYPE_NO:
            case DCButton.BUTTON_TYPE_X:
            case DCButton.BUTTON_TYPE_COMMON_CLOSE_TEXT_BOX:
               close();
         }
      }
      
      private function buttonMouseOver(param1:ButtonEvent) : void
      {
         if(this.mButtonMouseOverFunction != null)
         {
            this.mButtonMouseOverFunction(param1);
            param1.stopImmediatePropagation();
         }
      }
      
      private function buttonMouseOut(param1:ButtonEvent) : void
      {
         if(this.mButtonMouseOutFunction != null)
         {
            this.mButtonMouseOutFunction(param1);
            param1.stopImmediatePropagation();
         }
      }
      
      public function addHelper(param1:DisplayObject, param2:String, param3:String, param4:String = "hud") : DCHelper
      {
         if(this.mHelpers == null)
         {
            this.mHelpers = new Array();
         }
         var _loc5_:DCHelper = new DCHelper(param1,param2,param3,param4);
         this.mHelpers[this.mHelpers.length] = _loc5_;
         if(param1 is DisplayObjectContainer)
         {
            DisplayObjectContainer(param1).mouseChildren = false;
         }
         return _loc5_;
      }
      
      protected function mouseOutHelper(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this.mHelpers.length - 1);
         while(_loc2_ >= 0)
         {
            if(this.mHelpers[_loc2_].getObjectToReceiveHelper() == param1.target)
            {
               this.mHelpers[_loc2_].close();
            }
            _loc2_--;
         }
      }
      
      protected function mouseOverHelper(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this.mHelpers.length - 1);
         while(_loc2_ >= 0)
         {
            if(this.mHelpers[_loc2_].getObjectToReceiveHelper() == param1.target)
            {
               this.mHelpers[_loc2_].open(this.parent);
            }
            _loc2_--;
         }
      }
      
      public function cleanHelpers() : void
      {
         var _loc1_:DCHelper = null;
         var _loc2_:DisplayObject = null;
         if(this.mHelpers != null)
         {
            for each(_loc1_ in this.mHelpers)
            {
               _loc2_ = _loc1_.getObjectToReceiveHelper();
               _loc1_.clean();
            }
            this.mHelpers = null;
         }
      }
      
      override public function clean() : void
      {
         var _loc2_:DCButton = null;
         var _loc3_:DCScrollBar = null;
         removeEventListener(EVENT_BUTTON_CLICKED,this.buttonClicked);
         removeEventListener(EVENT_BUTTON_OVER,this.buttonMouseOver);
         removeEventListener(EVENT_BUTTON_OUT,this.buttonMouseOut);
         super.clean();
         var _loc1_:int = 0;
         while(_loc1_ < this.mButtons.length)
         {
            _loc2_ = this.mButtons[_loc1_];
            _loc2_.clean();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.mScrollBars.length)
         {
            _loc3_ = this.mScrollBars[_loc1_];
            _loc3_.clean();
            _loc1_++;
         }
         this.cleanHelpers();
         if(this.mTabs)
         {
            this.mTabs.clean();
         }
      }
   }
}
