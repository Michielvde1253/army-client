package com.dchoc.engineisometric
{
   import com.dchoc.utils.DCUtils;
   import flash.display.*;
   import flash.events.*;
   
   public class WorldElementTile extends WorldElement
   {
       
      
      public var mPropertyTransparent:Boolean;
      
      protected var resourceClass:Class;
      
      protected var resourceDisplayObject:DisplayObject;
      
      public function WorldElementTile(param1:World)
      {
         super(param1);
         mWorldSizeX = 1;
         mWorldSizeY = 1;
         mWorldSizeZ = 0.2;
         mScreenOffsetX = -mWorld.mTileWidthScreen / 2;
      }
      
      public function replaceWith(param1:WorldElementTile) : void
      {
         mWorld.mTiles[mWorldY][mWorldX] = param1;
         param1.setWorldPosition(mWorldX,mWorldY,mWorldZ);
         var _loc2_:DisplayObjectContainer = this.parent;
         _loc2_.addChild(param1);
         _loc2_.swapChildren(this,param1);
         _loc2_.removeChild(this);
         mWorld.setSelectedTile(param1);
      }
      
      override protected function reportMouseMove(param1:MouseEvent) : void
      {
      }
      
      override public function updateDisplayObjects() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Number = NaN;
         var _loc5_:WorldElementTile = null;
         var _loc6_:Number = NaN;
         DCUtils.removeAllChildren(this);
         var _loc3_:Number = mWorldZ;
         var _loc4_:Number = mWorldZ;
         if(mWorld.isTilePositionInBoundaries(mWorldX + mWorld.mTileSizeX,mWorldY))
         {
            if((_loc5_ = mWorld.mTiles[mWorldY][mWorldX + mWorld.mTileSizeX]) != null)
            {
               if(!_loc5_.mPropertyTransparent)
               {
                  _loc3_ = mWorldZ - _loc5_.mWorldZ;
               }
            }
         }
         if(mWorld.isTilePositionInBoundaries(mWorldX,mWorldY + mWorld.mTileSizeY))
         {
            if((_loc5_ = mWorld.mTiles[mWorldY + mWorld.mTileSizeY][mWorldX]) != null)
            {
               if(!_loc5_.mPropertyTransparent)
               {
                  _loc4_ = mWorldZ - _loc5_.mWorldZ;
               }
            }
         }
         if(_loc4_ > _loc3_)
         {
            _loc2_ = _loc4_;
         }
         else
         {
            _loc2_ = _loc3_;
         }
         if(_loc2_ > -mWorldSizeZ)
         {
            if(!this.mPropertyTransparent)
            {
               _loc6_ = mWorldZ - _loc2_;
               while(_loc6_ < mWorldZ)
               {
                  this.addDisplayObjectChild(mWorldX,mWorldY,_loc6_);
                  _loc6_ += mWorldSizeZ;
               }
            }
            this.addDisplayObjectChild(mWorldX,mWorldY,mWorldZ);
         }
      }
      
      private function addDisplayObjectChild(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:DisplayObject = null;
         _loc4_ = this.resourceDisplayObject;
         if(this.resourceClass != null)
         {
            _loc4_ = new this.resourceClass();
         }
         if(_loc4_ == null)
         {
            return;
         }
         _loc4_.x = mWorld.getWorldToScreenX(param1,param2) - _loc4_.width / 2;
         _loc4_.y = mWorld.getWorldToScreenY(param1,param2,param3);
         addChild(_loc4_);
      }
   }
}
