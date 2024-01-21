package com.dchoc.utils
{
   import com.dchoc.GUI.DCComponent;
   import com.dchoc.GUI.DCGuiUtils;
   import com.dchoc.GUI.DCMessageBox;
   import com.dchoc.GUI.DCWindow;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.ContextMenu;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class DCUtils
   {
       
      
      public function DCUtils()
      {
         super();
      }
      
      public static function bringToFront(param1:DisplayObjectContainer, param2:DisplayObject) : void
      {
         param1.setChildIndex(param2,param1.numChildren - 1);
      }
      
      public static function duplicateDisplayObject(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         return null;
      }
      
      public static function centerClip(param1:DisplayObject) : void
      {
         param1.x = param1.stage.stageWidth >> 1;
         param1.y = param1.stage.stageHeight >> 1;
      }
      
      public static function getClass(param1:Object) : Class
      {
         return Class(getDefinitionByName(getQualifiedClassName(param1)));
      }
      
      public static function getChildByPath(param1:DisplayObjectContainer, param2:String) : DisplayObject
      {
         if(param2 == null || param2 == "")
         {
            return param1;
         }
         var _loc3_:Array = param2.split("/");
         var _loc4_:DisplayObjectContainer = param1;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length - 1)
         {
            _loc4_ = _loc4_.getChildByName(_loc3_[_loc5_]) as DisplayObjectContainer;
            _loc5_++;
         }
         if(_loc4_ == null)
         {
            return null;
         }
         return _loc4_.getChildByName(_loc3_[_loc5_]);
      }
      
      public static function bitmap9Scale(param1:Sprite, param2:int, param3:int) : Sprite
      {
         param2 = param2 - param1.getChildByName("left").width - param1.getChildByName("right").width;
         param3 = param3 - param1.getChildByName("top").height - param1.getChildByName("bottom").height;
         param1.getChildByName("top").width = param1.getChildByName("top").width + (param2 - param1.getChildByName("top_right").width);
         param1.getChildByName("top_right").x = param1.getChildByName("top_right").x + (param2 - param1.getChildByName("top_right").width);
         param1.getChildByName("left").height = param1.getChildByName("left").height + (param3 - param1.getChildByName("bottom_left").height);
         param1.getChildByName("middle").width = param1.getChildByName("middle").width + (param2 - param1.getChildByName("right").width);
         param1.getChildByName("middle").height = param1.getChildByName("middle").height + (param3 - param1.getChildByName("bottom").height);
         param1.getChildByName("right").height = param1.getChildByName("right").height + (param3 - param1.getChildByName("bottom_right").height);
         param1.getChildByName("right").x = param1.getChildByName("right").x + (param2 - param1.getChildByName("right").width);
         param1.getChildByName("bottom_left").y = param1.getChildByName("bottom_left").y + (param3 - param1.getChildByName("bottom_left").height);
         param1.getChildByName("bottom").width = param1.getChildByName("bottom").width + (param2 - param1.getChildByName("bottom_right").width);
         param1.getChildByName("bottom").y = param1.getChildByName("bottom").y + (param3 - param1.getChildByName("bottom").height);
         param1.getChildByName("bottom_right").x = param1.getChildByName("bottom_right").x + (param2 - param1.getChildByName("bottom_right").width);
         param1.getChildByName("bottom_right").y = param1.getChildByName("bottom_right").y + (param3 - param1.getChildByName("bottom_right").height);
         return param1;
      }
      
      public static function sprite3Scale(param1:Sprite, param2:int) : Sprite
      {
         param1.getChildByName(DCWindow.INSTANCE_NAME_BACKGROUND_MIDDLE).width = param1.getChildByName(DCWindow.INSTANCE_NAME_BACKGROUND_MIDDLE).width + (param2 - param1.getChildByName(DCWindow.INSTANCE_NAME_BACKGROUND_RIGHT).width);
         param1.getChildByName(DCWindow.INSTANCE_NAME_BACKGROUND_RIGHT).x = param1.getChildByName(DCWindow.INSTANCE_NAME_BACKGROUND_RIGHT).x + (param2 - param1.getChildByName(DCWindow.INSTANCE_NAME_BACKGROUND_RIGHT).width);
         return param1;
      }
      
      public static function getRoot(param1:MovieClip) : MovieClip
      {
         var _loc2_:DisplayObject = param1;
         while(_loc2_.parent != null)
         {
            _loc2_ = _loc2_.parent;
         }
         return _loc2_ as MovieClip;
      }
      
      public static function getLowestChildY(param1:MovieClip) : Number
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Number = NaN;
         var _loc2_:Number = -1;
         var _loc3_:int = 1;
         while(_loc3_ < param1.numChildren)
         {
            if((_loc5_ = (_loc4_ = param1.getChildAt(_loc3_)).localToGlobal(new Point(0,0)).y) + _loc4_.height > _loc2_)
            {
               _loc2_ = _loc5_ + _loc4_.height;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getSpriteAsMovieClip(param1:Sprite) : MovieClip
      {
         var _loc2_:MovieClip = new MovieClip();
         _loc2_.addChild(param1);
         return _loc2_;
      }
      
      public static function randomNumber(param1:int, param2:int) : Number
      {
         return Math.round(Math.random() * (param2 - param1)) + param1;
      }
      
      public static function isProbability(param1:int) : Boolean
      {
         return randomNumber(0,100) < param1;
      }
      
      public static function strStartsWith(param1:String, param2:String) : Boolean
      {
         return !param1.indexOf(param2);
      }
      
      public static function replaceSubstring(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:int;
         return (_loc4_ = param1.indexOf(param2)) >= 0 ? param1.substring(0,_loc4_) + param3 + param1.substring(_loc4_ + param2.length) : param1;
      }
      
      public static function showTextBox(param1:Sprite, param2:String, param3:String, param4:Function = null) : void
      {
         var _loc5_:DCMessageBox;
         (_loc5_ = new DCMessageBox(new (DCResourceManager.getInstance().getSWFClass("hud","TextBoxMessage"))(),param2,param3,DCMessageBox.BUTTONS_OK)).open(param1,true);
         _loc5_.centerClip();
         if(param4 != null)
         {
            _loc5_.addEventListener(DCComponent.EVENT_WINDOW_CLOSED,param4);
         }
         param4 = null;
      }
      
      public static function showTextBoxYesNo(param1:Sprite, param2:String, param3:String, param4:Function) : void
      {
         var _loc5_:DCMessageBox;
         (_loc5_ = new DCMessageBox(new (DCResourceManager.getInstance().getSWFClass("hud","TextBoxMessage"))(),param2,param3,DCMessageBox.BUTTONS_YES_NO,param4)).open(param1,true);
         _loc5_.centerClip();
         param4 = null;
      }
      
      public static function alignCentered(param1:DisplayObject) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:Rectangle = param1.getBounds(param1);
         var _loc3_:Number = _loc2_.x * param1.scaleX;
         _loc4_ = _loc2_.y * param1.scaleY;
         var _loc5_:Number = _loc2_.width * 0.5 * param1.scaleX;
         var _loc6_:Number = _loc2_.height * 0.5 * param1.scaleY;
         param1.x -= _loc5_ + _loc3_;
         param1.y -= _loc6_ + _loc4_;
      }
      
      public static function replaceDisplayObject(param1:DisplayObject, param2:DisplayObject, param3:Boolean = false, param4:Boolean = false, param5:Boolean = true) : void
      {
      }
      
      public static function addDisplayObjectChild(param1:DisplayObjectContainer, param2:DisplayObject, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:Rectangle = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         param1.addChild(param2);
         param2.x = param1.x;
         param2.y = param1.y;
         if(param4)
         {
            DCGuiUtils.scaleToFitSize(param2,param1.width,param1.height);
         }
         if(param3)
         {
            _loc6_ = (_loc5_ = param2.getBounds(param2)).x * param2.scaleX;
            _loc7_ = _loc5_.y * param2.scaleY;
            _loc8_ = _loc5_.width * 0.5 * param2.scaleX;
            _loc9_ = _loc5_.height * 0.5 * param2.scaleY;
            param2.x -= _loc8_ + _loc6_;
            param2.y -= _loc9_ + _loc7_;
         }
      }
      
      public static function getTimeAsString(param1:int, param2:Boolean = true) : String
      {
         var _loc3_:int = param1 % 60;
         param1 /= 60;
         var _loc4_:int = param1 % 60;
         param1 /= 60;
         var _loc5_:int = param1;
         var _loc6_:String = "";
         if(_loc5_ > 0)
         {
            _loc6_ += _loc5_ + "h" + " " + _loc4_ + "m " + _loc3_ + "s";
         }
         else if(_loc4_ > 0)
         {
            _loc6_ += _loc4_ + "m " + _loc3_ + "s";
         }
         else
         {
            _loc6_ += _loc3_ + "s";
         }
         return _loc6_;
      }
      
      public static function trim(param1:String, param2:String = " ") : String
      {
         return trimBack(trimFront(param1,param2),param2);
      }
      
      public static function trimFront(param1:String, param2:String) : String
      {
         param2 = stringToCharacter(param2);
         if(param1.charAt(0) == param2)
         {
            param1 = trimFront(param1.substring(1),param2);
         }
         return param1;
      }
      
      public static function trimBack(param1:String, param2:String) : String
      {
         param2 = stringToCharacter(param2);
         if(param1.charAt(param1.length - 1) == param2)
         {
            param1 = trimBack(param1.substring(0,param1.length - 1),param2);
         }
         return param1;
      }
      
      private static function stringToCharacter(param1:String) : String
      {
         if(param1.length == 1)
         {
            return param1;
         }
         return param1.slice(0,1);
      }
      
      public static function removeAllChildren(param1:DisplayObjectContainer) : void
      {
         var _loc2_:int = param1.numChildren;
         while(--_loc2_ >= 0)
         {
            param1.removeChildAt(0);
         }
      }
      
      public static function setBitmapSmoothing(param1:DisplayObjectContainer, param2:Boolean) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Bitmap = null;
         var _loc3_:int = param1.numChildren;
         while(--_loc3_ >= 0)
         {
            if((_loc4_ = param1.getChildAt(_loc3_)) is DisplayObjectContainer)
            {
               setBitmapSmoothing(_loc4_ as DisplayObjectContainer,param2);
            }
            else if(_loc4_ is Bitmap)
            {
               (_loc5_ = _loc4_ as Bitmap).smoothing = param2;
            }
         }
      }
      
      public static function gotoAndStopAllMovieClips(param1:DisplayObjectContainer, param2:Object) : void
      {
         var _loc4_:DisplayObject = null;
         if(param1 is MovieClip)
         {
            MovieClip(param1).gotoAndStop(param2);
         }
         var _loc3_:int = param1.numChildren;
         while(--_loc3_ >= 0)
         {
            if((_loc4_ = param1.getChildAt(_loc3_)) is DisplayObjectContainer)
            {
               gotoAndStopAllMovieClips(_loc4_ as DisplayObjectContainer,param2);
            }
         }
      }
      
      public static function isChildOf(param1:DisplayObject, param2:DisplayObjectContainer) : Boolean
      {
         var _loc3_:int = param2.numChildren;
         while(--_loc3_ >= 0)
         {
            if(param1 == param2.getChildAt(_loc3_))
            {
               return true;
            }
         }
         return false;
      }
      
      public static function removeZoomOptionsFromContextMenu(param1:MovieClip) : void
      {
         var _loc2_:ContextMenu = new ContextMenu();
         _loc2_.builtInItems.zoom = false;
         param1.contextMenu = _loc2_;
      }
      
      public static function movieClipContainsLabel(param1:MovieClip, param2:String) : Boolean
      {
         var _loc3_:Array = param1.currentLabels;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc3_[_loc5_].name == param2)
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
   }
}
