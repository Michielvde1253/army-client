package game.gui.button
{
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import game.gui.IconInterface;
   import game.gui.IconLoader;
   import game.sound.ArmySoundManager;
   
   public class ResizingIconButton extends ResizingButton
   {
      
      public static const BUTTON_WIDTH_DEFAULT:int = 50;
      
      private static const safetyScaleDown:Number = 1;
       
      
      private var mType:int;
      
      private var mID:String;
      
      private var mIcon:Sprite;
      
      private var mIconCentered:Boolean;
      
      private var mUseDefaultWidth:Boolean;
      
      public function ResizingIconButton(param1:DisplayObjectContainer, param2:MovieClip, param3:int, param4:String = null, param5:DisplayObjectContainer = null, param6:Function = null, param7:Function = null, param8:Function = null, param9:Function = null, param10:Function = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
         this.mType = param3;
         this.mID = param4;
         setEnabled(true);
         var _loc11_:MovieClip;
         if((_loc11_ = mButton.getChildByName(BUTTON_NAME_HIT_AREA) as MovieClip) != null)
         {
            _loc11_.visible = false;
            mButton.hitArea = _loc11_;
         }
         mButton.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown,false,0,true);
         mButton.addEventListener(MouseEvent.MOUSE_UP,mouseUp,false,0,true);
         if(TRIGGER_AT_MOUSE_UP)
         {
            mButton.addEventListener(MouseEvent.CLICK,mouseClick,false,0,true);
         }
         if(Config.BUTTON_USE_HAND_CURSOR)
         {
            mButton.buttonMode = true;
            mButton.mouseChildren = false;
            mButton.useHandCursor = true;
         }
         if(param10 != null)
         {
            mButton.addEventListener(Event.ENTER_FRAME,param10,false,0,true);
            mEnterFrameFunction = param10;
         }
         setMouseDownFunction(param6);
         setMouseOutFunction(param8);
         setMouseOverFunction(param7);
         setMouseUpFunction(param9);
         setReactWhenDraggingObject(false);
         setObjectToWarnForClick(param5);
         mClickSound = ArmySoundManager.SFX_UI_CLICK;
         this.mUseDefaultWidth = false;
      }
      
      override public function setText(param1:String, param2:String = "Text") : void
      {
         super.setText(param1,param2);
         this.recalculateSize();
      }
      
      override protected function recalculateSize() : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:TextField = null;
         var _loc6_:MovieClip = null;
         var _loc7_:TextField = null;
         var _loc8_:TextFormat = null;
         var _loc1_:Boolean = true;
         var _loc2_:Number = !!this.mIcon ? this.mIcon.width : 0;
         var _loc3_:int = int(mVisibleText.getTextFormat().size);
         while(_loc1_)
         {
            _loc4_ = 0;
            for each(_loc5_ in mTexts)
            {
               (_loc8_ = _loc5_.getTextFormat()).size = _loc3_;
               _loc5_.defaultTextFormat = _loc8_;
               _loc5_.setTextFormat(_loc8_);
               if(_loc5_.width > _loc4_)
               {
                  _loc4_ = _loc5_.textWidth;
               }
            }
            if(this.mUseDefaultWidth)
            {
               _loc4_ = BUTTON_WIDTH_DEFAULT;
            }
            if(_loc4_ > mMaxWidth)
            {
               _loc3_--;
            }
            else
            {
               _loc1_ = false;
               _loc4_ += _loc2_ / 2 + ArmyButton.BUTTON_PADDING / 2;
               for each(_loc6_ in mBackgrounds)
               {
                  _loc6_.getChildAt(0).width = _loc4_;
               }
               if(this.mIcon)
               {
                  this.mIcon.x = -_loc4_ / 2;
                  if(!this.mIconCentered)
                  {
                     this.mIcon.x -= _loc2_ / 2;
                  }
               }
               if(_loc1_)
               {
                  _loc3_--;
               }
               else
               {
                  for each(_loc7_ in mTexts)
                  {
                     if(this.mIcon)
                     {
                        _loc7_.x = (ArmyButton.BUTTON_PADDING / 4 - _loc7_.width) / 2;
                     }
                     else
                     {
                        _loc7_.x = -_loc7_.width / 2;
                     }
                  }
               }
            }
         }
      }
      
      override public function getWidth() : int
      {
         return this.mVisibleBackGround.width;
      }
      
      public function setIcon(param1:IconInterface) : void
      {
         if(mButton.getChildByName("Icon"))
         {
            mButton.removeChild(mButton.getChildByName("Icon"));
         }
         if(param1)
         {
            IconLoader.addIcon(mButton,param1,this.iconLoaded,false);
         }
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         var _loc4_:Bitmap = null;
         if(param1.numChildren >= 0 && param1.getChildAt(0) is Bitmap)
         {
            (_loc4_ = param1.getChildAt(0) as Bitmap).smoothing = true;
         }
         var _loc2_:Rectangle = param1.getBounds(param1);
         this.mIconCentered = _loc2_.x < 0;
         var _loc3_:int = mVisibleBackGround.height * safetyScaleDown;
         this.mIcon = param1;
         this.mIcon.scaleX = Math.min(_loc3_ / this.mIcon.height,_loc3_ / this.mIcon.width,1);
         this.mIcon.scaleY = Math.min(_loc3_ / this.mIcon.height,_loc3_ / this.mIcon.width,1);
         if(!this.mIconCentered)
         {
            this.mIcon.y = -this.mIcon.height / 2;
         }
         this.mIcon.name = "Icon";
         this.mIcon.mouseEnabled = false;
         this.mIcon.mouseChildren = false;
         this.setText(mButtonText);
      }
      
      public function setDefaultWidth(param1:Boolean) : void
      {
         this.mUseDefaultWidth = param1;
      }
   }
}
