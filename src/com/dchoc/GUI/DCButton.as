package com.dchoc.GUI
{
   import com.dchoc.events.ButtonEvent;
   import com.dchoc.utils.CursorManager;
   import com.dchoc.utils.DCUtils;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class DCButton extends EventDispatcher
   {
      
      public static var TRIGGER_AT_MOUSE_UP:Boolean = false;
      
      public static const BUTTON_TYPE_NAMES:Array = ["BUTTON_TYPE_OK","BUTTON_TYPE_YES","BUTTON_TYPE_NO","BUTTON_TYPE_CANCEL","BUTTON_TYPE_X","BUTTON_TYPE_SCROLL_UP","BUTTON_TYPE_SCROLL_DOWN","BUTTON_TYPE_SCROLL_LEFT","BUTTON_TYPE_SCROLL_RIGHT","BUTTON_TYPE_SCROLL_HANDLE_VERTICAL","BUTTON_TYPE_SCROLL_HANDLE_HORIZONTAL","BUTTON_TYPE_TAB","BUTTON_TYPE_ICON","BUTTON_TYPE_SCROLL_HOME","BUTTON_TYPE_SCROLL_END","BUTTON_COMMON","BUTTON_TYPE_COMMON_CLOSE_TEXT_BOX","BUTTON_TYPE_X_SET_INVISIBLE","BUTTON_TYPE_BUY","BUTTON_TYPE_BUY_NOW"];
      
      public static const BUTTON_FRAME_NAME_UP:String = "UpState";
      
      public static const BUTTON_FRAME_NAME_DOWN:String = "DownState";
      
      public static const BUTTON_FRAME_NAME_OVER:String = "OverState";
      
      public static const BUTTON_FRAME_NAME_OUT:String = "OutState";
      
      public static const BUTTON_FRAME_NAME_DISABLED_UP:String = "DisabledUpState";
      
      public static const BUTTON_FRAME_NAME_DISABLED_OVER:String = "DisabledOverState";
      
      public static const BUTTON_FRAME_NAME_DISABLED_DOWN:String = "DisabledDownState";
      
      public static const BUTTON_FRAME_NAME_SELECTED_UP:String = "SelectedState";
      
      public static const BUTTON_FRAME_NAME_SELECTED_OVER:String = "SelectedStateOver";
      
      public static const BUTTON_NAME_HIT_AREA:String = "Hit_Area";
      
      public static const BUTTON_TYPE_OK:int = 0;
      
      public static const BUTTON_TYPE_YES:int = 1;
      
      public static const BUTTON_TYPE_NO:int = 2;
      
      public static const BUTTON_TYPE_CANCEL:int = 3;
      
      public static const BUTTON_TYPE_X:int = 4;
      
      public static const BUTTON_TYPE_SCROLL_UP:int = 5;
      
      public static const BUTTON_TYPE_SCROLL_DOWN:int = 6;
      
      public static const BUTTON_TYPE_SCROLL_LEFT:int = 7;
      
      public static const BUTTON_TYPE_SCROLL_RIGHT:int = 8;
      
      public static const BUTTON_TYPE_SCROLL_HANDLE_VERTICAL:int = 9;
      
      public static const BUTTON_TYPE_SCROLL_HANDLE_HORIZONTAL:int = 10;
      
      public static const BUTTON_TYPE_TAB:int = 11;
      
      public static const BUTTON_TYPE_ICON:int = 12;
      
      public static const BUTTON_TYPE_SCROLL_HOME:int = 13;
      
      public static const BUTTON_TYPE_SCROLL_END:int = 14;
      
      public static const BUTTON_TYPE_COMMON_CLOSE_TEXT_BOX:int = 16;
      
      public static const BUTTON_TYPE_X_SET_INVISIBLE:int = 17;
      
      public static const BUTTON_TYPE_BUY:int = 18;
      
      public static const BUTTON_TYPE_BUY_NOW:int = 19;
       
      
      public var USE_BUTTON_STATES_ANIM:Boolean = true;
      
      protected var mButton:MovieClip;
      
      private var mType:int;
      
      private var mID:String;
      
      private var mObjectToWarnForClick:EventDispatcher;
      
      private var mMouseDownFunction:Function;
      
      private var mMouseOverFunction:Function;
      
      private var mMouseOutFunction:Function;
      
      public var mMouseUpFunction:Function;
      
      public var mEnterFrameFunction:Function;
      
      public var mMouseClickFunction:Function;
      
      private var mEnabled:Boolean;
      
      private var mParent:DisplayObjectContainer;
      
      protected var mCurrentPlayedLabel:String;
      
      protected var mReactWhenDraggingObject:Boolean;
      
      private var _alwaysShowHelper:Boolean;
      
      private var buttonText:String;
      
      protected var buttonTextFieldName:String;
      
      private var mHelper:DCHelper;
      
      public function DCButton(param1:DisplayObjectContainer, param2:MovieClip, param3:int, param4:String = null, param5:EventDispatcher = null, param6:Function = null, param7:Function = null, param8:Function = null, param9:Function = null, param10:Function = null, param11:Boolean = true)
      {
         super();
         this.mParent = param1;
         this.mButton = param2;
         this.mType = param3;
         this.mID = param4;
         var _loc12_:TextField;
         if((_loc12_ = param2.getChildByName("Text") as TextField) != null)
         {
            this.buttonText = _loc12_.text;
         }
         this.buttonTextFieldName = "Text";
         if(param11)
         {
            this.setEnabled(true);
         }
         var _loc13_:MovieClip;
         if((_loc13_ = this.mButton.getChildByName(BUTTON_NAME_HIT_AREA) as MovieClip) != null)
         {
            _loc13_.visible = false;
            this.mButton.hitArea = _loc13_;
         }
         this.mButton.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown,false,0,true);
         this.mButton.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp,false,0,true);
         if(TRIGGER_AT_MOUSE_UP)
         {
            this.mButton.addEventListener(MouseEvent.CLICK,this.mouseClick,false,0,true);
         }
         if(Config.BUTTON_USE_HAND_CURSOR)
         {
            this.mButton.buttonMode = true;
            this.mButton.mouseChildren = false;
            this.mButton.useHandCursor = true;
         }
         if(param10 != null)
         {
            this.mButton.addEventListener(Event.ENTER_FRAME,param10,false,0,true);
            this.mEnterFrameFunction = param10;
         }
         this.setMouseDownFunction(param6);
         this.setMouseOutFunction(param8);
         this.setMouseOverFunction(param7);
         this.setMouseUpFunction(param9);
         this.setReactWhenDraggingObject(false);
         this.setObjectToWarnForClick(param5);
      }
      
      public static function getStringFromType(param1:int) : String
      {
         return BUTTON_TYPE_NAMES[param1];
      }
      
      public function setMouseClickFunction(param1:Function) : void
      {
         this.mMouseClickFunction = param1;
      }
      
      public function setReactWhenDraggingObject(param1:Boolean) : void
      {
         this.mReactWhenDraggingObject = param1;
      }
      
      public function setObjectToWarnForClick(param1:EventDispatcher) : void
      {
         this.mObjectToWarnForClick = param1;
      }
      
      public function getObjectToWarnForClick() : EventDispatcher
      {
         return this.mObjectToWarnForClick;
      }
      
      public function setMouseUpFunction(param1:Function) : void
      {
         this.mMouseUpFunction = param1;
      }
      
      public function setMouseDownFunction(param1:Function) : void
      {
         this.mMouseDownFunction = param1;
      }
      
      public function setMouseOverFunction(param1:Function) : void
      {
         this.mMouseOverFunction = param1;
      }
      
      public function setMouseOutFunction(param1:Function) : void
      {
         this.mMouseOutFunction = param1;
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this.mButton.visible = param1;
      }
      
      public function getVisible() : Boolean
      {
         return this.mButton.visible;
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         if(param1 == this.mEnabled)
         {
            return;
         }
         this.mEnabled = param1;
         if(param1)
         {
            this.playAnim(BUTTON_FRAME_NAME_UP);
         }
         else
         {
            this.playAnim(BUTTON_FRAME_NAME_DISABLED_UP);
            this.terminateAnimations();
            this.hideHelper();
         }
      }
      
      public function terminateAnimations() : void
      {
         this.mButton.stop();
         this.mCurrentPlayedLabel = null;
         this.mButton.removeEventListener(Event.ENTER_FRAME,this.enterFrame);
      }
      
      public function isEnable() : Boolean
      {
         return this.mEnabled;
      }
      
      public function setText(param1:String, param2:String = "Text") : void
      {
         var _loc3_:TextField = null;
         if(param1 != null)
         {
            if(param1 != "")
            {
               _loc3_ = this.mButton.getChildByName(param2) as TextField;
               if(_loc3_ != null)
               {
                  _loc3_.text = param1;
                  LocalizationUtils.replaceFont(_loc3_);
               }
            }
         }
         this.buttonText = param1;
         this.buttonTextFieldName = param2;
      }
      
      public function getType() : int
      {
         return this.mType;
      }
      
      public function getX() : int
      {
         return this.mButton.x;
      }
      
      public function getY() : int
      {
         return this.mButton.y;
      }
      
      public function getGlobalX() : int
      {
         return this.mButton.localToGlobal(new Point()).x;
      }
      
      public function getGlobalY() : int
      {
         return this.mButton.localToGlobal(new Point()).y;
      }
      
      public function getWidth() : int
      {
         return this.mButton.width;
      }
      
      public function getHeight() : int
      {
         return this.mButton.height;
      }
      
      public function setX(param1:int) : void
      {
         this.mButton.x = param1;
      }
      
      public function setY(param1:int) : void
      {
         this.mButton.y = param1;
      }
      
      protected function mouseDown(param1:MouseEvent) : void
      {
         if(!this.mEnabled)
         {
            return;
         }
         this.playAnim(BUTTON_FRAME_NAME_DOWN);
         if(this.mMouseDownFunction != null)
         {
            this.mMouseDownFunction(param1);
         }
         if(!TRIGGER_AT_MOUSE_UP)
         {
            this.buttonClicked(param1);
         }
      }
      
      protected function buttonClicked(param1:MouseEvent) : void
      {
         if(this.mObjectToWarnForClick != null)
         {
            this.mObjectToWarnForClick.dispatchEvent(new ButtonEvent(this,DCWindow.EVENT_BUTTON_CLICKED,this.mType,this.mID,true));
         }
         if(this.mMouseClickFunction != null)
         {
            this.mMouseClickFunction(param1);
         }
      }
      
      public function getID() : String
      {
         return this.mID;
      }
      
      protected function mouseClick(param1:MouseEvent) : void
      {
         if(!this.mEnabled)
         {
            return;
         }
         this.buttonClicked(param1);
      }
      
      protected function mouseOver(param1:MouseEvent) : void
      {
         if(!this.mEnabled)
         {
            return;
         }
         if(!this.mReactWhenDraggingObject)
         {
            if(CursorManager.getInstance().getDraggedObject())
            {
               return;
            }
         }
         this.playAnim(BUTTON_FRAME_NAME_OVER);
         if(this.mObjectToWarnForClick != null)
         {
            this.mObjectToWarnForClick.dispatchEvent(new ButtonEvent(this,DCWindow.EVENT_BUTTON_OVER,this.mType,this.mID,true));
         }
         if(this.mMouseOverFunction != null)
         {
            this.mMouseOverFunction(param1);
         }
         this.showHelper();
      }
      
      protected function mouseOut(param1:MouseEvent) : void
      {
         if(!this.mEnabled)
         {
            return;
         }
         if(!this.mReactWhenDraggingObject)
         {
            if(CursorManager.getInstance().getDraggedObject())
            {
               return;
            }
         }
         this.playAnim(BUTTON_FRAME_NAME_OUT);
         if(this.mObjectToWarnForClick != null)
         {
            this.mObjectToWarnForClick.dispatchEvent(new ButtonEvent(this,DCWindow.EVENT_BUTTON_OUT,this.mType,this.mID,true));
         }
         if(this.mMouseOutFunction != null)
         {
            this.mMouseOutFunction(param1);
         }
         if(!this.getAlwaysShowHelper())
         {
            this.hideHelper();
         }
      }
      
      protected function mouseUp(param1:MouseEvent) : void
      {
         if(!this.mEnabled)
         {
            return;
         }
         this.playAnim(BUTTON_FRAME_NAME_UP);
         if(this.mMouseUpFunction != null)
         {
            this.mMouseUpFunction(param1);
         }
      }
      
      public function playAnim(param1:String) : void
      {
         if(this.mButton.currentLabel == null || this.mButton.currentLabel.length == 0)
         {
            return;
         }
         var _loc2_:Boolean = DCUtils.movieClipContainsLabel(this.mButton,param1);
         if(!_loc2_)
         {
            this.playAnim(BUTTON_FRAME_NAME_UP);
            return;
         }
         if(this.USE_BUTTON_STATES_ANIM)
         {
            this.mButton.gotoAndPlay(param1);
            this.mButton.addEventListener(Event.ENTER_FRAME,this.enterFrame,false,0,true);
            this.mCurrentPlayedLabel = param1;
         }
         else
         {
            this.mButton.gotoAndStop(param1);
         }
         this.setText(this.buttonText,this.buttonTextFieldName);
      }
      
      public function enterFrame(param1:Event) : void
      {
         if(this.mButton.currentLabel != this.mCurrentPlayedLabel || this.mButton.currentFrame == this.mButton.totalFrames)
         {
            if(this.mButton.currentLabel != this.mCurrentPlayedLabel)
            {
               this.mButton.prevFrame();
               this.setText(this.buttonText,this.buttonTextFieldName);
            }
            this.terminateAnimations();
            if(this.mCurrentPlayedLabel == BUTTON_FRAME_NAME_OUT)
            {
               this.playAnim(BUTTON_FRAME_NAME_UP);
            }
         }
      }
      
      public function putToFront() : void
      {
         this.mButton.parent.setChildIndex(this.mButton,this.mButton.parent.numChildren - 1);
      }
      
      public function putToBack() : void
      {
         this.mButton.parent.setChildIndex(this.mButton,0);
      }
      
      public function stopDrag() : void
      {
         this.mButton.stopDrag();
      }
      
      public function startDrag(param1:Boolean = false, param2:Rectangle = null) : void
      {
         this.mButton.startDrag(param1,param2);
      }
      
      public function clean() : void
      {
         this.mButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.mButton.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         this.mButton.removeEventListener(MouseEvent.CLICK,this.mouseClick);
         this.mButton.removeEventListener(Event.ENTER_FRAME,this.enterFrame);
         this.hideHelper();
         try
         {
            this.mParent.removeChildAt(this.mParent.getChildIndex(this.mButton));
         }
         catch(error:Error)
         {
         }
         this.mMouseDownFunction = null;
         this.mMouseOverFunction = null;
         this.mMouseOutFunction = null;
         this.mMouseUpFunction = null;
         this.mEnterFrameFunction = null;
         this.mMouseClickFunction = null;
      }
      
      public function getMovieClip() : DisplayObjectContainer
      {
         return this.mButton;
      }
      
      public function setHelper(param1:String = null, param2:String = null, param3:String = "hud") : void
      {
         if(!this.mHelper)
         {
            if(Boolean(param1) || Boolean(param2))
            {
               this.mHelper = new DCHelper(this.mButton,param1,param2,param3);
            }
         }
      }
      
      public function getHelper() : DCHelper
      {
         return this.mHelper;
      }
      
      public function showHelper() : void
      {
      }
      
      public function hideHelper() : void
      {
         if(this.mHelper != null)
         {
            this.mHelper.close();
         }
      }
      
      public function setHelperCoordinates(param1:int, param2:int) : void
      {
         if(this.mHelper != null)
         {
            this.mHelper.setCoordinatesManually(param1,param2);
         }
      }
      
      public function getHelperCoordinates() : Point
      {
         if(this.mHelper)
         {
            return this.mHelper.getCoordinates();
         }
         return null;
      }
      
      public function setAlwaysShowHelper(param1:Boolean) : void
      {
         this._alwaysShowHelper = param1;
      }
      
      public function getAlwaysShowHelper() : Boolean
      {
         return this._alwaysShowHelper;
      }
      
      public function removeHelper() : void
      {
         if(this.mHelper)
         {
            this.mHelper.close();
         }
         this.mHelper = null;
      }
      
      public function enableHandCursor(param1:Boolean) : void
      {
         this.mButton.buttonMode = param1;
         this.mButton.useHandCursor = param1;
      }
   }
}
