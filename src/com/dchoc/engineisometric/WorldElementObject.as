package com.dchoc.engineisometric
{
   import flash.display.*;
   import flash.events.*;
   
   public class WorldElementObject extends WorldElement
   {
       
      
      private var mListenerObjectClicked:Function;
      
      private var mListenerObjectMouseOut:Function;
      
      private var mListenerObjectMouseOver:Function;
      
      private var listenerObjectMousePressed:Function;
      
      private var listenerObjectMouseReleased:Function;
      
      private var mDisplayObjectsOffsetX:Array;
      
      private var mDisplayObjectsOffsetY:Array;
      
      public function WorldElementObject(param1:World)
      {
         super(param1);
         this.mDisplayObjectsOffsetX = new Array();
         this.mDisplayObjectsOffsetY = new Array();
      }
      
      public function addListenerObjectMouseOver(param1:Function) : void
      {
         this.mListenerObjectMouseOver = param1;
      }
      
      public function addListenerObjectMouseOut(param1:Function) : void
      {
      }
      
      public function addListenerObjectClicked(param1:Function) : void
      {
         if(this.mListenerObjectClicked == null)
         {
            addEventListener(MouseEvent.CLICK,this.reportMouseClick,false);
         }
         this.mListenerObjectClicked = param1;
      }
      
      public function addListenerObjectMousePressed(param1:Function) : void
      {
         if(this.listenerObjectMousePressed == null)
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.reportMousePressed,false);
         }
         this.listenerObjectMousePressed = param1;
      }
      
      public function addListenerObjectMouseReleased(param1:Function) : void
      {
         if(this.listenerObjectMouseReleased == null)
         {
            addEventListener(MouseEvent.MOUSE_UP,this.reportMouseReleased,false);
         }
         this.listenerObjectMouseReleased = param1;
      }
      
      public function removeListenerObjectMouseOver() : void
      {
         this.mListenerObjectMouseOver = null;
      }
      
      public function removeListenerObjectMouseOut() : void
      {
      }
      
      public function removeListenerObjectClicked() : void
      {
         if(this.mListenerObjectClicked != null)
         {
            removeEventListener(MouseEvent.CLICK,this.reportMouseClick);
            this.mListenerObjectClicked = null;
         }
      }
      
      public function removeListenerObjectPressed() : void
      {
         if(this.listenerObjectMousePressed != null)
         {
            removeEventListener(MouseEvent.MOUSE_DOWN,this.reportMousePressed);
            this.listenerObjectMousePressed = null;
         }
      }
      
      public function removeListenerObjectReleased() : void
      {
         if(this.listenerObjectMouseReleased != null)
         {
            removeEventListener(MouseEvent.MOUSE_UP,this.reportMouseReleased);
            this.listenerObjectMouseReleased = null;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.mDisplayObjectsOffsetX = new Array();
         this.mDisplayObjectsOffsetY = new Array();
         this.removeListenerObjectReleased();
         this.removeListenerObjectPressed();
         this.removeListenerObjectClicked();
         this.removeListenerObjectMouseOut();
         this.removeListenerObjectMouseOver();
         this.mListenerObjectClicked = null;
         this.mListenerObjectMouseOut = null;
         this.mListenerObjectMouseOver = null;
         this.listenerObjectMousePressed = null;
         this.listenerObjectMouseReleased = null;
      }
      
      override public function logicUpdate(param1:int) : void
      {
         super.logicUpdate(param1);
         this.updatePhysics(param1);
      }
      
      public function setDisplayObject(param1:Class) : void
      {
         if(param1)
         {
            this.setDisplayObjectWithObject(new param1());
         }
      }
      
      public function insertDisplayObjectWithObject(param1:DisplayObject, param2:int = 0) : void
      {
         this.insertDisplayObjectWithObjectAndOffset(param1,param2,0,0);
      }
      
      public function insertDisplayObjectWithObjectAndOffset(param1:DisplayObject, param2:int = 0, param3:int = 0, param4:int = 0) : void
      {
         this.mDisplayObjectsOffsetX.splice(param2,0,param3);
         this.mDisplayObjectsOffsetY.splice(param2,0,param4);
         this.addChildAt(param1,param2);
         this.updateDisplayObjects();
      }
      
      public function setDisplayObjectWithObjectAndOffset(param1:DisplayObject, param2:int = 0, param3:int = 0, param4:int = 0) : void
      {
         if(param2 < this.numChildren)
         {
            this.removeChildAt(param2);
         }
         this.addChildAt(param1,param2);
         this.setDisplayObjectOffsets(param2,param3,param4);
      }
      
      public function setDisplayObjectOffsets(param1:int = 0, param2:int = 0, param3:int = 0) : void
      {
         this.mDisplayObjectsOffsetX[param1] = param2;
         this.mDisplayObjectsOffsetY[param1] = param3;
         this.updateDisplayObjects();
      }
      
      public function setDisplayObjectWithObject(param1:DisplayObject, param2:int = 0) : void
      {
         this.setDisplayObjectWithObjectAndOffset(param1,param2,0,0);
      }
      
      public function setShadowDisplayObjectWithObject(param1:DisplayObject, param2:int = 0) : void
      {
         if(param1)
         {
            mShadowDisplayObjects.addChildAt(param1,param2);
         }
         else if(mShadowDisplayObjects.numChildren > param2)
         {
            mShadowDisplayObjects.removeChildAt(param2);
         }
         this.updateDisplayObjects();
      }
      
      public function removeDisplayObjectAt(param1:int) : void
      {
         if(this.numChildren <= param1)
         {
            return;
         }
         this.removeChildAt(param1);
         this.mDisplayObjectsOffsetX.splice(param1,1);
         this.mDisplayObjectsOffsetY.splice(param1,1);
         this.updateDisplayObjects();
      }
      
      public function removeDisplayObject(param1:DisplayObject) : int
      {
         var _loc2_:int = 0;
         if(param1 != null && this.contains(param1))
         {
            _loc2_ = this.getChildIndex(param1);
            this.removeDisplayObjectAt(_loc2_);
            return _loc2_;
         }
         return -1;
      }
      
      public function getDisplayObject(param1:int = 0) : DisplayObject
      {
         if(this.numChildren > param1)
         {
            return this.getChildAt(param1);
         }
         return null;
      }
      
      public function getNumDisplayObjects() : int
      {
         return this.numChildren;
      }
      
      override public function updateDisplayObjects() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         super.updateDisplayObjects();
         _loc2_ = 0;
         while(_loc2_ < this.numChildren)
         {
            if(this.mDisplayObjectsOffsetX[_loc2_] != null)
            {
               _loc1_ = this.getChildAt(_loc2_);
               _loc1_.x += this.mDisplayObjectsOffsetX[_loc2_];
               _loc1_.y += this.mDisplayObjectsOffsetY[_loc2_];
            }
            _loc2_++;
         }
      }
      
      public function getCollisionObject() : WorldElementObject
      {
         var _loc2_:WorldElementObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < mWorld.mElementObjects.length)
         {
            _loc2_ = mWorld.mElementObjects[_loc1_];
            if(!(_loc2_ == this || mWorldX + mWorldSizeX < _loc2_.mWorldX || mWorldX > _loc2_.mWorldX + _loc2_.mWorldSizeX || mWorldY + mWorldSizeY < _loc2_.mWorldY || mWorldY > _loc2_.mWorldY + _loc2_.mWorldSizeY || mWorldZ + mWorldSizeZ < _loc2_.mWorldZ || mWorldZ > _loc2_.mWorldZ + _loc2_.mWorldSizeZ))
            {
               return _loc2_;
            }
            _loc1_++;
         }
         return null;
      }
      
      override protected function reportMouseMove(param1:MouseEvent) : void
      {
         if(mEnabled)
         {
            super.reportMouseMove(param1);
            if(this.mListenerObjectMouseOver != null && this != mWorld.getSelectedObject())
            {
               this.mListenerObjectMouseOver(param1);
            }
            mWorld.setSelectedObject(this);
         }
      }
      
      protected function reportMouseClick(param1:MouseEvent) : void
      {
         if(mEnabled)
         {
            if(this.mListenerObjectClicked != null)
            {
               this.mListenerObjectClicked(param1);
            }
         }
      }
      
      protected function reportMousePressed(param1:MouseEvent) : void
      {
         if(mEnabled)
         {
            mWorld.moveObject();
            if(this.listenerObjectMousePressed != null)
            {
               this.listenerObjectMousePressed(param1);
            }
         }
      }
      
      protected function reportMouseReleased(param1:MouseEvent) : void
      {
         if(mEnabled)
         {
            if(this.listenerObjectMouseReleased != null)
            {
               this.listenerObjectMouseReleased(param1);
            }
         }
      }
      
      public function reportMouseOut(param1:MouseEvent) : void
      {
         mWorld.setSelectedObject(null);
         if(this.mListenerObjectMouseOut != null)
         {
            this.mListenerObjectMouseOut(param1);
         }
      }
      
      public function updatePhysics(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(mWorld.hasElevation())
         {
            _loc2_ = 9999;
            _loc3_ = 0;
            _loc4_ = mWorldX;
            _loc6_ = _loc5_ = mWorldY;
            while(_loc6_ < _loc5_ + mWorldSizeY + mWorld.mTileSizeY)
            {
               _loc7_ = _loc4_;
               while(_loc7_ < _loc4_ + mWorldSizeX + mWorld.mTileSizeY)
               {
                  if((_loc8_ = mWorld.getGroundHeight(_loc7_,_loc6_)) > _loc3_)
                  {
                     _loc3_ = _loc8_;
                  }
                  if(_loc8_ < _loc2_)
                  {
                     _loc2_ = _loc8_;
                  }
                  _loc7_ += mWorld.mTileSizeX;
               }
               _loc6_ += mWorld.mTileSizeY;
            }
            if(mWorldZ < _loc3_)
            {
               mWorldZ = _loc3_;
               this.updateDisplayObjects();
            }
         }
      }
      
      public function enableHandCursor(param1:Boolean) : void
      {
         buttonMode = param1;
         useHandCursor = param1;
      }
      
      public function isTileRightOf(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = mWorld.getWorldToRealScreenX(param1,param2);
         var _loc4_:int = mWorld.getWorldToRealScreenX(mWorldX,mWorldY);
         return _loc3_ > _loc4_;
      }
      
      public function isTileLeftOf(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = mWorld.getWorldToRealScreenX(param1,param2);
         var _loc4_:int = mWorld.getWorldToRealScreenX(mWorldX,mWorldY);
         return _loc3_ < _loc4_;
      }
      
      public function isTileAboveOf(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = mWorld.getWorldToRealScreenY(param1,param2);
         var _loc4_:int = mWorld.getWorldToRealScreenY(mWorldX + mWorldSizeX,mWorldY);
         return _loc3_ < _loc4_;
      }
      
      public function isTileBelowOf(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = mWorld.getWorldToRealScreenY(param1,param2);
         var _loc4_:int = mWorld.getWorldToRealScreenY(mWorldX + mWorldSizeX,mWorldY);
         return _loc3_ > _loc4_;
      }
   }
}
