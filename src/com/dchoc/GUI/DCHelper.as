package com.dchoc.GUI
{
   import com.dchoc.graphics.DCResourceManager;
   import com.dchoc.utils.CursorManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class DCHelper extends DCWindow
   {
       
      
      private var mObjectToReceiveHelper:DisplayObject;
      
      private var mX:int;
      
      private var mY:int;
      
      private var mCoordinatesSetManually:Boolean = false;
      
      public function DCHelper(param1:DisplayObject, param2:String = null, param3:String = null, param4:String = "hud")
      {
         var _loc5_:Class = DCResourceManager.getInstance().getSWFClass(param4,param3);
         super(new _loc5_());
         this.mObjectToReceiveHelper = param1;
         this.setLabel(param2);
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      override public function open(param1:DisplayObjectContainer, param2:Boolean = false) : void
      {
         if(CursorManager.getInstance().getDraggedObject() == null)
         {
            super.open(param1,param2);
            this.setPosition();
         }
      }
      
      public function setPosition() : void
      {
         var _loc1_:Point = new Point(0,0);
         var _loc2_:Point = this.mObjectToReceiveHelper.localToGlobal(_loc1_);
         x = _loc2_.x;
         y = _loc2_.y;
         if(this.mCoordinatesSetManually)
         {
            x += this.mX;
            y += this.mY;
         }
         else if(getY() < mDesign.height)
         {
            y = this.mObjectToReceiveHelper.y + 100;
         }
         var _loc3_:Rectangle = mDesign.getBounds(mDesign);
         var _loc4_:Number;
         if((_loc4_ = getX() + _loc3_.x) < 0)
         {
            x = -_loc3_.x;
         }
         var _loc5_:Number;
         if((_loc5_ = getX() + _loc3_.y) < 0)
         {
            y = -_loc3_.y;
         }
      }
      
      public function setCoordinatesManually(param1:int, param2:int) : void
      {
         this.mCoordinatesSetManually = true;
         this.mX = param1;
         this.mY = param2;
         this.setPosition();
      }
      
      public function setLabel(param1:String) : void
      {
         DCGuiUtils.setTextAndResizeBackground(mDesign,param1,"Text_Title");
      }
      
      public function getObjectToReceiveHelper() : DisplayObject
      {
         return this.mObjectToReceiveHelper;
      }
      
      public function getCoordinates() : Point
      {
         return new Point(getX(),getY());
      }
   }
}
