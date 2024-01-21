package com.dchoc.engineisometric
{
   import flash.display.*;
   
   public class WorldDisplayContainerSorted extends MovieClip
   {
       
      
      private var world:World;
      
      private var mFunctionToCallWhenObjectsAreInSameTile:Function;
      
      private var originalList:Vector.<WorldElement>;
      
      private var sortedList:Vector.<WorldElement>;
      
      public function WorldDisplayContainerSorted(param1:World = null, param2:Function = null)
      {
         this.originalList = new Vector.<WorldElement>();
         this.sortedList = new Vector.<WorldElement>();
         super();
         this.world = param1;
         this.mFunctionToCallWhenObjectsAreInSameTile = param2;
      }
      
      private function isObjectFrontOf(param1:WorldElement, param2:WorldElement) : Boolean
      {
         var _loc3_:int = param1.mWorldX as int;
         var _loc4_:int = param1.mWorldY as int;
         var _loc5_:int = param2.mWorldX as int;
         var _loc6_:int = param2.mWorldY as int;
         var _loc7_:int = param1.mWorldSizeY as int;
         var _loc8_:int = param1.mWorldSizeX as int;
         if(_loc3_ >= _loc5_)
         {
            if(_loc4_ >= _loc6_)
            {
               if(_loc3_ + _loc8_ < (_loc5_ + param2.mWorldSizeX as int))
               {
                  if(_loc4_ + _loc7_ < (_loc6_ + param2.mWorldSizeY as int))
                  {
                     return false;
                  }
               }
            }
         }
         if(this.mFunctionToCallWhenObjectsAreInSameTile())
         {
            if(param1.mWorldX as int == param2.mWorldX as int)
            {
               if(param1.mWorldY as int == param2.mWorldY as int)
               {
                  return this.mFunctionToCallWhenObjectsAreInSameTile(param1,param2);
               }
            }
         }
         if(_loc3_ > _loc5_)
         {
            if(_loc4_ >= _loc6_)
            {
               return true;
            }
            if(_loc4_ + _loc7_ > _loc6_)
            {
               return true;
            }
         }
         if(_loc4_ > _loc6_)
         {
            if(_loc3_ >= _loc5_)
            {
               return true;
            }
            if(_loc3_ + _loc8_ > _loc5_)
            {
               return true;
            }
         }
         else if(_loc3_ == _loc5_ && _loc4_ == _loc6_)
         {
            if(param1.mWorldX == param2.mWorldX)
            {
               if(param1.mWorldY == param2.mWorldY)
               {
                  return param1.mSortInTileIndex > param2.mSortInTileIndex;
               }
            }
            return param1.mWorldX + param1.mWorldY > param2.mWorldX + param2.mWorldY;
         }
         return false;
      }
      
      private function getSortedList(param1:Vector.<WorldElement>) : Vector.<WorldElement>
      {
         var _loc5_:int = 0;
         var _loc6_:WorldElement = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.getObjectBehindEverything(param1);
            _loc6_ = param1[_loc5_];
            param1.splice(_loc5_,1);
            this.sortedList[_loc4_] = _loc6_;
            if(_loc5_ != 0)
            {
               _loc2_ = true;
            }
            _loc4_++;
         }
         if(!_loc2_)
         {
            return null;
         }
         if(_loc4_ < this.sortedList.length)
         {
            this.sortedList.splice(_loc4_,this.sortedList.length - _loc4_);
         }
         return this.sortedList;
      }
      
      private function getObjectBehindEverything(param1:Vector.<WorldElement>) : int
      {
         var _loc4_:WorldElement = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:WorldElement = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(true)
         {
            if(_loc3_ >= _loc2_)
            {
               return 0;
            }
            _loc4_ = param1[_loc3_];
            _loc5_ = false;
            _loc6_ = 0;
            while(_loc6_ < _loc2_)
            {
               if(_loc3_ != _loc6_)
               {
                  _loc7_ = param1[_loc6_];
                  if(this.isObjectFrontOf(_loc4_,_loc7_))
                  {
                     _loc5_ = true;
                     break;
                  }
               }
               _loc6_++;
            }
            if(!_loc5_)
            {
               break;
            }
            _loc3_++;
         }
         return _loc3_;
      }
      
      public function sortChildren() : void
      {
         var _loc5_:WorldElement = null;
         var _loc1_:int = this.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            (_loc5_ = this.getChildAt(_loc2_) as WorldElement).mSortInTileIndex = _loc2_;
            this.originalList[_loc2_] = _loc5_;
            _loc2_++;
         }
         if(_loc2_ < this.originalList.length)
         {
            this.originalList.splice(_loc2_,this.originalList.length - _loc2_);
         }
         var _loc3_:Vector.<WorldElement> = this.getSortedList(this.originalList);
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            this.addChildAt(_loc3_[_loc4_],_loc4_);
            _loc4_++;
         }
      }
   }
}
