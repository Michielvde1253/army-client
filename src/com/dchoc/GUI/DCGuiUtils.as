package com.dchoc.GUI
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class DCGuiUtils
   {
       
      
      public function DCGuiUtils()
      {
         super();
      }
      
      public static function putObjectBehindModalWindowSquare(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObjectContainer = param1.parent;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.numChildren)
         {
            if(_loc2_.getChildAt(_loc3_).name == DCComponent.INSTANCE_NAME_MODAL_SQUARE)
            {
               _loc2_.setChildIndex(param1,_loc3_ - 1);
            }
            _loc3_++;
         }
      }
      
      public static function setTextAndResizeBackground(param1:Sprite, param2:String, param3:String = "Text") : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:DisplayObject = null;
         if(param2 == null)
         {
            return;
         }
         var _loc4_:TextField;
         if((_loc4_ = param1.getChildByName(param3) as TextField) != null)
         {
            _loc4_.autoSize = "left";
            _loc5_ = _loc4_.textWidth;
            _loc4_.text = param2;
            _loc5_ += 5;
            _loc6_ = _loc4_.textWidth - _loc5_;
            if(_loc4_.getTextFormat().align == "center")
            {
               _loc4_.x += _loc6_ / 2;
            }
            if((_loc7_ = getBackground(param1)) != null)
            {
               _loc7_.width += _loc6_;
               _loc7_.x -= _loc6_ / 2;
            }
            else
            {
               param1.width += _loc6_;
            }
            _loc4_.x -= _loc6_;
         }
      }
      
      private static function getBackground(param1:DisplayObjectContainer) : DisplayObject
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:DisplayObjectContainer = param1.getChildByName(DCWindow.INSTANCE_NAME_BACKGROUND) as DisplayObjectContainer;
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getChildByName(DCWindow.INSTANCE_NAME_BUTTON_BACKGROUND);
            if(_loc3_ != null)
            {
               return _loc3_;
            }
            return _loc2_;
         }
         return _loc2_;
      }
      
      public static function scaleToFitSize(param1:DisplayObject, param2:int, param3:int) : void
      {
         param1.scaleX = 1;
         param1.scaleY = 1;
         var _loc4_:Number = param2 / param1.width;
         var _loc5_:Number = param3 / param1.height;
         var _loc6_:Number = Math.min(_loc4_,_loc5_);
         _loc6_ = Math.min(_loc6_,1);
         param1.scaleX = _loc6_;
         param1.scaleY = _loc6_;
      }
      
      public static function hitTestPoint(param1:DisplayObject, param2:Number, param3:Number, param4:Boolean = false, param5:Rectangle = null) : Boolean
      {
         var _loc6_:Rectangle = null;
         var _loc7_:Point = null;
         var _loc8_:DisplayObjectContainer = null;
         var _loc9_:int = 0;
         if(param1 == null || !param1.visible)
         {
            return false;
         }
         if(!param4)
         {
            _loc6_ = param1.getBounds(param1);
            if(param5 != null)
            {
               _loc6_.x += param5.x;
               _loc6_.y += param5.y;
               _loc6_.width += param5.width;
               _loc6_.height += param5.height;
            }
            _loc7_ = param1.localToGlobal(new Point(_loc6_.x,_loc6_.y));
            if(param2 >= _loc7_.x)
            {
               if(param3 >= _loc7_.y)
               {
                  _loc7_ = param1.localToGlobal(new Point(_loc6_.x + _loc6_.width,_loc6_.y + _loc6_.height));
                  if(param2 < _loc7_.x)
                  {
                     if(param3 < _loc7_.y)
                     {
                        return true;
                     }
                  }
               }
            }
            return false;
         }
         if(param1 is DisplayObjectContainer)
         {
            _loc8_ = param1 as DisplayObjectContainer;
            _loc9_ = 0;
            while(_loc9_ < _loc8_.numChildren)
            {
               if(hitTestPoint(_loc8_.getChildAt(_loc9_),param2,param3,true))
               {
                  return true;
               }
               _loc9_++;
            }
            return false;
         }
         return param1.hitTestPoint(param2,param3,true);
      }
   }
}
