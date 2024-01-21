package com.dchoc.engineisometric
{
   import com.dchoc.utils.CollectionItem;
   import com.dchoc.utils.DCUtils;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class WorldElement extends Sprite
   {
       
      
      private var mCollectionItem:CollectionItem;
      
      public var mWorldX:Number;
      
      public var mWorldY:Number;
      
      public var mWorldZ:Number;
      
      public var mWorldSizeX:Number = 1;
      
      public var mWorldSizeY:Number = 1;
      
      public var mWorldSizeZ:Number = 0;
      
      protected var mScreenOffsetX:Number = 0;
      
      protected var mScreenOffsetY:Number = 0;
      
      protected var mWorld:World;
      
      protected var mShadowDisplayObjects:Sprite;
      
      protected var mEnabled:Boolean = true;
      
      public var mSortInTileIndex:int;
      
      protected var gridOutlineThickness:Number = 0.3;
      
      protected var gridOutlineAlpha:Number = 0.3;
      
      public function WorldElement(param1:World)
      {
         super();
         this.mWorld = param1;
         this.mShadowDisplayObjects = new Sprite();
         this.mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_MOVE,this.reportMouseMove,false);
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         this.mEnabled = param1;
      }
      
      public function isEnabled() : Boolean
      {
         return this.mEnabled;
      }
      
      public function storeToByteArray(param1:ByteArray) : void
      {
         param1.writeFloat(this.mWorldX);
         param1.writeFloat(this.mWorldY);
         param1.writeFloat(this.mWorldZ);
      }
      
      public function restoreFromByteArray(param1:ByteArray) : void
      {
         this.mWorldX = param1.readFloat();
         this.mWorldY = param1.readFloat();
         this.mWorldZ = param1.readFloat();
         this.updateDisplayObjects();
      }
      
      public function removeMouseMoveCallback() : void
      {
         removeEventListener(MouseEvent.MOUSE_MOVE,this.reportMouseMove);
      }
      
      public function destroy() : void
      {
         this.removeMouseMoveCallback();
         DCUtils.removeAllChildren(this);
         this.mShadowDisplayObjects = new Sprite();
      }
      
      public function translate(param1:Number, param2:Number, param3:Number = 0) : void
      {
         this.setWorldPosition(this.mWorldX + param1,this.mWorldY + param2,this.mWorldZ + param3);
      }
      
      public function setWorldPosition(param1:Number, param2:Number, param3:Number = 0) : void
      {
         if(this.mWorldX == param1)
         {
            if(this.mWorldY == param2)
            {
               if(this.mWorldZ == param3)
               {
                  return;
               }
            }
         }
         this.mWorldX = param1;
         this.mWorldY = param2;
         this.mWorldZ = param3;
         this.updateDisplayObjects();
      }
      
      public function draggedTo(param1:Number, param2:Number, param3:Number = 0) : void
      {
         this.setWorldPosition(param1,param2,param3);
      }
      
      public function draggingStopped() : void
      {
      }
      
      protected function reportMouseMove(param1:MouseEvent) : void
      {
         this.mWorld.setSelectedElement(this);
      }
      
      public function updateDisplayObjects() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:Number = this.mWorld.getWorldToScreenX(this.mWorldX,this.mWorldY) + this.mScreenOffsetX;
         var _loc2_:Number = this.mWorld.getWorldToScreenY(this.mWorldX,this.mWorldY) + this.mScreenOffsetY;
         this.x = _loc1_;
         this.y = _loc2_;
         var _loc4_:Number = 0;
         if(this.mWorldZ != 0)
         {
            _loc4_ = _loc2_ - (this.mWorld.getWorldToScreenY(this.mWorldX,this.mWorldY,this.mWorldZ) + this.mScreenOffsetY);
         }
         var _loc5_:int = 0;
         while(_loc5_ < this.numChildren)
         {
            _loc3_ = this.getChildAt(_loc5_);
            _loc3_.x = 0;
            _loc3_.y = _loc4_;
            _loc5_++;
         }
         this.mShadowDisplayObjects.x = _loc1_;
         this.mShadowDisplayObjects.y = _loc2_;
      }
      
      public function logicUpdate(param1:int) : void
      {
      }
      
      public function getWorld() : World
      {
         return this.mWorld;
      }
      
      public function drawOnGC(param1:Graphics, param2:int) : void
      {
         var _loc3_:Number = this.mWorld.getWorldToScreenX(this.mWorldX,this.mWorldY);
         var _loc4_:Number = this.mWorld.getWorldToScreenY(this.mWorldX,this.mWorldY,this.mWorldZ);
         var _loc5_:Number = this.mWorld.getWorldToScreenX(this.mWorldX + this.mWorldSizeX,this.mWorldY);
         var _loc6_:Number = this.mWorld.getWorldToScreenY(this.mWorldX + this.mWorldSizeX,this.mWorldY,this.mWorldZ);
         var _loc7_:Number = this.mWorld.getWorldToScreenX(this.mWorldX + this.mWorldSizeX,this.mWorldY + this.mWorldSizeY);
         var _loc8_:Number = this.mWorld.getWorldToScreenY(this.mWorldX + this.mWorldSizeX,this.mWorldY + this.mWorldSizeY,this.mWorldZ);
         var _loc9_:Number = this.mWorld.getWorldToScreenX(this.mWorldX,this.mWorldY + this.mWorldSizeY);
         var _loc10_:Number = this.mWorld.getWorldToScreenY(this.mWorldX,this.mWorldY + this.mWorldSizeY,this.mWorldZ);
         param1.lineStyle(this.gridOutlineThickness,param2,this.gridOutlineAlpha);
         param1.moveTo(_loc3_,_loc4_);
         param1.lineTo(_loc5_,_loc6_);
         param1.lineTo(_loc7_,_loc8_);
         param1.lineTo(_loc9_,_loc10_);
         param1.lineTo(_loc3_,_loc4_);
      }
      
      public function getShadowDisplayObjects() : Sprite
      {
         return this.mShadowDisplayObjects;
      }
      
      public function setGameObject(param1:CollectionItem = null) : void
      {
         this.mCollectionItem = param1;
      }
      
      public function getGameObject() : CollectionItem
      {
         return this.mCollectionItem;
      }
   }
}
