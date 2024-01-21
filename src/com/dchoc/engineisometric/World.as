package com.dchoc.engineisometric
{
   import com.dchoc.utils.DCUtils;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.*;
   
   public class World extends MovieClip implements IWorldInterface
   {
      
      public static const TILES_LAYER_NAME:String = "Tiles";
      
      public static const STATE_START:int = 0;
      
      public static const STATE_SELECT:int = 1;
      
      public static const STATE_SCROLL:int = 2;
      
      public static const STATE_MOVE_OBJECT:int = 3;
      
      public static const STATE_TILE_EDITING:int = 4;
      
      public static const STATE_OBJECT_DESTROY:int = 5;
      
      public static const STATE_TILE_RAISE:int = 6;
      
      public static const STATE_TILE_LOWER:int = 7;
      
      public static const STATE_STOP:int = 8;
       
      
      public var mTiles:Array;
      
      public var mElementObjects:Vector.<WorldElementObject>;
      
      public var mTileWidthScreen:int;
      
      public var mTileHeightScreen:int;
      
      public var mTileSizeX:Number = 1;
      
      public var mTileSizeY:Number = 1;
      
      private var mSelectedElement:WorldElement;
      
      private var mLastSelectedElement:WorldElement;
      
      private var mSelectedObject:WorldElementObject;
      
      private var mSelectedObjectOriginalTileX:Number = -1;
      
      private var mSelectedObjectOriginalTileY:Number = -1;
      
      private var mSelectedTile:WorldElementTile;
      
      public var mLayerTiles:Sprite;
      
      public var mLayerGroundObjects:WorldDisplayContainerSorted;
      
      public var mLayerShadows:Sprite;
      
      public var mLayerObjects:WorldDisplayContainerSorted;
      
      protected var mGridLayer:Shape;
      
      private var mEngineState:int = 0;
      
      private var mToolTileClass:Class;
      
      protected var mWorldWidth:int;
      
      protected var mWorldHeight:int;
      
      protected var mDidScrollingOccur:Boolean;
      
      protected var scrollingThreshold:int = 5;
      
      protected var scale:int = 100;
      
      protected var scrollSpeed:Number = 1;
      
      protected var zoomStep:int = 1;
      
      protected var mUpdateObjectPositionInMoveObjectMode:Boolean;
      
      protected var mDisableMouseListeners:Boolean;
      
      private var mousePressed:Boolean;
      
      private var mListenerObjectMoved:Function;
      
      private var mListenerObjectDestroyed:Function;
      
      private const HILL_RADIUS:int = 4;
      
      private var mMouseDownX:Number;
      
      private var mMouseDownY:Number;
      
      protected var mSelectedTileObject:DisplayObject;
      
      public function World(param1:Number, param2:Number, param3:Boolean = false)
      {
         this.mElementObjects = new Vector.<WorldElementObject>();
         super();
         this.mTileWidthScreen = param1;
         this.mTileHeightScreen = param2;
         this.mDisableMouseListeners = param3;
         this.setUpdateObjectPositionInMoveObjectMode(true);
         this.initDisplayContainers();
      }
      
      public function clearLevel() : void
      {
         DCUtils.removeAllChildren(this.mLayerTiles);
         DCUtils.removeAllChildren(this.mLayerObjects);
      }
      
      public function changeEngineState(param1:int) : void
      {
         if(this.mEngineState == STATE_SCROLL)
         {
            this.mousePressed = false;
         }
         if(param1 == STATE_SCROLL)
         {
            this.mMouseDownX = this.x;
            this.mMouseDownY = this.y;
         }
         this.mEngineState = param1;
      }
      
      public function logicUpdate(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(!stage)
         {
            return;
         }
         switch(this.mEngineState)
         {
            case STATE_START:
               if(!this.mDisableMouseListeners)
               {
                  stage.addEventListener(MouseEvent.CLICK,this.reportMouseClick);
                  stage.addEventListener(MouseEvent.MOUSE_UP,this.reportMouseUp);
                  addEventListener(MouseEvent.MOUSE_DOWN,this.reportMouseDown);
                  stage.addEventListener(MouseEvent.MOUSE_MOVE,this.reportMouseMove);
               }
               this.changeEngineState(STATE_SELECT);
               break;
            case STATE_SELECT:
            case STATE_SCROLL:
               break;
            case STATE_MOVE_OBJECT:
               if(this.mSelectedObject)
               {
                  if(this.mUpdateObjectPositionInMoveObjectMode)
                  {
                     _loc3_ = this.getScreenToWorldX(mouseX,mouseY);
                     _loc2_ = this.getScreenToWorldY(mouseX,mouseY);
                     _loc4_ = this.getGroundHeight(_loc3_,_loc2_);
                     _loc3_ = Math.max(0,Math.min(_loc3_,this.mWorldWidth - 1));
                     _loc2_ = Math.max(0,Math.min(_loc2_,this.mWorldHeight - 1));
                     this.elementDraggedTo(this.mSelectedObject,_loc3_,_loc2_);
                     this.onObjectMoving();
                  }
               }
               break;
            case STATE_STOP:
               if(!this.mDisableMouseListeners)
               {
                  stage.removeEventListener(MouseEvent.CLICK,this.reportMouseClick);
                  stage.removeEventListener(MouseEvent.MOUSE_UP,this.reportMouseUp);
                  removeEventListener(MouseEvent.MOUSE_DOWN,this.reportMouseDown);
                  stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.reportMouseMove);
               }
         }
         this.clearGrid();
         this.updateObjects(param1);
         this.updateGrid();
      }
      
      protected function updateObjects(param1:int) : void
      {
         var _loc2_:WorldElement = null;
         for each(_loc2_ in this.mElementObjects)
         {
            _loc2_.logicUpdate(param1);
         }
         this.mLayerGroundObjects.sortChildren();
         this.mLayerObjects.sortChildren();
         this.updateShadowLayer();
      }
      
      protected function updateShadowLayer() : void
      {
         var _loc3_:WorldElement = null;
         var _loc4_:Sprite = null;
         DCUtils.removeAllChildren(this.mLayerShadows);
         var _loc1_:int = this.mLayerObjects.numChildren;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = WorldElement(this.mLayerObjects.getChildAt(_loc2_));
            if(_loc3_.visible)
            {
               if((_loc4_ = _loc3_.getShadowDisplayObjects()).numChildren > 0)
               {
                  this.mLayerShadows.addChild(_loc4_);
               }
            }
            _loc2_++;
         }
      }
      
      public function getObjectBeingMoved() : WorldElementObject
      {
         if(this.mEngineState == STATE_MOVE_OBJECT)
         {
            return this.mSelectedObject;
         }
         return null;
      }
      
      protected function onObjectMoving() : void
      {
      }
      
      public function moveObject() : void
      {
         if(this.mEngineState == STATE_SELECT || this.mEngineState == STATE_SCROLL)
         {
            if(this.mSelectedObject == null)
            {
               return;
            }
            this.mSelectedObjectOriginalTileX = this.mSelectedObject.mWorldX;
            this.mSelectedObjectOriginalTileY = this.mSelectedObject.mWorldY;
            this.changeEngineState(STATE_MOVE_OBJECT);
         }
      }
      
      public function getMovedObjectOriginalTileX() : Number
      {
         return this.mSelectedObjectOriginalTileX;
      }
      
      public function getMovedObjectOriginalTileY() : Number
      {
         return this.mSelectedObjectOriginalTileY;
      }
      
      public function addListenerObjectMoved(param1:Function) : void
      {
         this.mListenerObjectMoved = param1;
      }
      
      public function addListenerObjectDestroyed(param1:Function) : void
      {
         this.mListenerObjectDestroyed = param1;
      }
      
      public function addObject(param1:Class) : WorldElementObject
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:WorldElementObject = new param1(this);
         if(_loc2_)
         {
            this.mElementObjects[this.mElementObjects.length] = _loc2_;
            this.mLayerObjects.addChild(_loc2_);
            _loc3_ = this.getScreenToWorldX(mouseX,mouseY);
            _loc4_ = this.getScreenToWorldY(mouseX,mouseY);
            _loc5_ = this.getGroundHeight(_loc3_,_loc4_);
            _loc2_.setWorldPosition(_loc3_,_loc4_,_loc5_);
            _loc2_.updatePhysics(0);
         }
         return _loc2_;
      }
      
      public function addElementObject(param1:WorldElementObject, param2:Number = -1, param3:Number = -1, param4:Number = 0) : void
      {
         if(param1)
         {
            this.mElementObjects[this.mElementObjects.length] = param1;
            if(param2 != -1)
            {
               param1.setWorldPosition(param2,param3,param4);
            }
            param1.updatePhysics(0);
         }
      }
      
      public function addWorldObject(param1:WorldElementObject, param2:Number = -1, param3:Number = -1, param4:Number = 0) : void
      {
         if(param1)
         {
            this.addElementObject(param1,param2,param3,param4);
            this.mLayerObjects.addChild(param1);
         }
      }
      
      public function addWorldGroundObject(param1:WorldElementObject, param2:Number = -1, param3:Number = -1, param4:Number = 0) : void
      {
         if(param1)
         {
            this.addElementObject(param1,param2,param3,param4);
            this.mLayerGroundObjects.addChild(param1);
         }
      }
      
      public function selectToolTile(param1:Class) : void
      {
         this.mToolTileClass = param1;
         this.changeEngineState(STATE_TILE_EDITING);
      }
      
      public function selectToolSelect() : void
      {
         this.changeEngineState(STATE_SELECT);
      }
      
      public function getDisplayObjectContainer() : DisplayObjectContainer
      {
         return this.mLayerObjects;
      }
      
      public function isTilePositionInBoundaries(param1:Number, param2:Number) : Boolean
      {
         return param1 >= 0 && param2 >= 0 && param2 < this.mTiles.length && param1 < (this.mTiles[param2] as Array).length;
      }
      
      public function setSelectedElement(param1:WorldElement) : void
      {
         switch(this.mEngineState)
         {
            case STATE_SELECT:
            case STATE_TILE_EDITING:
            case STATE_OBJECT_DESTROY:
            case STATE_TILE_RAISE:
            case STATE_TILE_LOWER:
               this.mSelectedElement = param1;
         }
      }
      
      public function setForceSelectedElement(param1:WorldElement) : void
      {
         this.mSelectedElement = param1;
      }
      
      public function setSelectedObject(param1:WorldElementObject) : void
      {
         switch(this.mEngineState)
         {
            case STATE_SELECT:
            case STATE_OBJECT_DESTROY:
               this.mSelectedObject = param1;
         }
      }
      
      public function resetSelectedObject() : void
      {
         this.mSelectedObject = null;
      }
      
      public function setSelectedTile(param1:WorldElementTile) : void
      {
         switch(this.mEngineState)
         {
            case STATE_SELECT:
            case STATE_TILE_EDITING:
            case STATE_TILE_RAISE:
            case STATE_TILE_LOWER:
               this.mSelectedTile = param1;
         }
      }
      
      public function setForceSelectedTile(param1:WorldElementTile) : void
      {
         this.mSelectedTile = param1;
      }
      
      public function lowerSelectedTileMountain() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:WorldElement = null;
         var _loc1_:Number = -this.HILL_RADIUS;
         while(_loc1_ <= this.HILL_RADIUS)
         {
            _loc2_ = -this.HILL_RADIUS;
            while(_loc2_ <= this.HILL_RADIUS)
            {
               _loc3_ = (this.HILL_RADIUS * this.HILL_RADIUS * 2 - _loc2_ * _loc2_ - _loc1_ * _loc1_) * 0.125 / (this.HILL_RADIUS * this.HILL_RADIUS * 2);
               if(this.isTilePositionInBoundaries(this.mSelectedTile.mWorldX + _loc2_,this.mSelectedTile.mWorldY + _loc1_))
               {
                  _loc4_ = this.mTiles[this.mSelectedTile.mWorldY + _loc1_][this.mSelectedTile.mWorldX + _loc2_];
                  _loc4_.setWorldPosition(_loc4_.mWorldX,_loc4_.mWorldY,_loc4_.mWorldZ - _loc3_);
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function raiseSelectedTileMountain() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:WorldElement = null;
         var _loc1_:Number = -this.HILL_RADIUS;
         while(_loc1_ <= this.HILL_RADIUS)
         {
            _loc2_ = -this.HILL_RADIUS;
            while(_loc2_ <= this.HILL_RADIUS)
            {
               _loc3_ = (this.HILL_RADIUS * this.HILL_RADIUS * 2 - _loc2_ * _loc2_ - _loc1_ * _loc1_) * 0.125 / (this.HILL_RADIUS * this.HILL_RADIUS * 2);
               if(this.isTilePositionInBoundaries(this.mSelectedTile.mWorldX + _loc2_,this.mSelectedTile.mWorldY + _loc1_))
               {
                  _loc4_ = this.mTiles[this.mSelectedTile.mWorldY + _loc1_][this.mSelectedTile.mWorldX + _loc2_];
                  _loc4_.setWorldPosition(_loc4_.mWorldX,_loc4_.mWorldY,_loc4_.mWorldZ + _loc3_);
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function raiseSelectedTile() : void
      {
         this.mSelectedTile.setWorldPosition(this.mSelectedTile.mWorldX,this.mSelectedTile.mWorldY,this.mSelectedTile.mWorldZ + 0.125);
      }
      
      public function lowerSelectedTile() : void
      {
         this.mSelectedTile.setWorldPosition(this.mSelectedTile.mWorldX,this.mSelectedTile.mWorldY,this.mSelectedTile.mWorldZ - 0.125);
      }
      
      protected function initDisplayContainers() : void
      {
         this.mLayerObjects = new WorldDisplayContainerSorted(this);
         this.mLayerTiles = new Sprite();
         this.mLayerTiles.name = TILES_LAYER_NAME;
         this.mGridLayer = new Shape();
         this.mLayerShadows = new Sprite();
         this.mLayerGroundObjects = new WorldDisplayContainerSorted(this);
         addChild(this.mLayerTiles);
         addChild(this.mLayerGroundObjects);
         addChild(this.mLayerShadows);
         addChild(this.mLayerObjects);
         addChild(this.mGridLayer);
      }
      
      protected function reportMouseWheel(param1:MouseEvent) : void
      {
         this.updateScale(param1.delta);
      }
      
      protected function setScale(param1:int) : void
      {
         this.scale = param1;
         this.scaleX = param1 / 100;
         this.scaleY = this.scaleX;
      }
      
      protected function updateScale(param1:int) : void
      {
         var _loc2_:int = this.scale;
         this.scale += param1 * this.zoomStep;
         if(this.scale < 10)
         {
            this.scale = 10;
         }
         else if(this.scale > 200)
         {
            this.scale = 200;
         }
         if(_loc2_ > 100 && this.scale < 100 || _loc2_ < 100 && this.scale > 100)
         {
            this.scale = 100;
         }
         this.setScale(this.scale);
      }
      
      protected function reportMouseDown(param1:MouseEvent) : void
      {
         this.mousePressed = true;
         this.mDidScrollingOccur = false;
         switch(this.mEngineState)
         {
            case STATE_SELECT:
               this.mMouseDownX = this.mouseX;
               this.mMouseDownY = this.mouseY;
               break;
            case STATE_SCROLL:
               break;
            case STATE_TILE_EDITING:
               if(this.mSelectedTile)
               {
                  if(this.mToolTileClass)
                  {
                     this.mSelectedTile.replaceWith(new this.mToolTileClass(this));
                  }
               }
               break;
            case STATE_MOVE_OBJECT:
            case STATE_OBJECT_DESTROY:
         }
      }
      
      protected function reportMouseUp(param1:MouseEvent) : void
      {
         this.mousePressed = false;
         switch(this.mEngineState)
         {
            case STATE_SELECT:
               break;
            case STATE_SCROLL:
               this.changeEngineState(STATE_SELECT);
               break;
            case STATE_TILE_EDITING:
               break;
            case STATE_MOVE_OBJECT:
               if(this.mListenerObjectMoved != null)
               {
                  if(this.mSelectedObject)
                  {
                     this.mListenerObjectMoved(this.mSelectedObject);
                  }
               }
               this.changeEngineState(STATE_SELECT);
         }
      }
      
      private function reportMouseMove(param1:MouseEvent) : void
      {
         switch(this.mEngineState)
         {
            case STATE_SCROLL:
               this.updateScrolling();
               break;
            case STATE_SELECT:
               this.checkTileBelowMouse();
               if(this.mousePressed)
               {
                  this.checkForScrolling();
                  if(this.mDidScrollingOccur)
                  {
                     this.changeEngineState(STATE_SCROLL);
                  }
               }
               break;
            case STATE_TILE_EDITING:
               if(param1.buttonDown)
               {
                  if(this.mSelectedTile)
                  {
                     if(this.mToolTileClass)
                     {
                        this.mSelectedTile.replaceWith(new this.mToolTileClass(this));
                     }
                  }
               }
               break;
            case STATE_MOVE_OBJECT:
         }
      }
      
      private function checkTileBelowMouse() : void
      {
         var _loc1_:Number = stage.mouseX - x;
         var _loc2_:Number = stage.mouseY - y;
         _loc1_ /= scaleX;
         _loc2_ /= scaleY;
         var _loc3_:Number = this.getScreenToWorldX(_loc1_,_loc2_);
         var _loc4_:Number = this.getScreenToWorldY(_loc1_,_loc2_);
         if(_loc3_ < 0 || _loc4_ < 0 || _loc3_ >= this.mWorldWidth || _loc4_ >= this.mWorldHeight)
         {
            this.setSelectedElement(null);
            this.setSelectedTile(null);
         }
         else if(this.mSelectedElement != this.mTiles[_loc4_][_loc3_])
         {
            this.setSelectedElement(this.mTiles[_loc4_][_loc3_]);
            this.setSelectedTile(this.mTiles[_loc4_][_loc3_]);
         }
      }
      
      public function getSelectedTileFromMouseCoordinates(param1:int, param2:int) : WorldElementTile
      {
         var _loc3_:Number = param1 - x;
         var _loc4_:Number = param2 - y;
         _loc3_ /= scaleX;
         _loc4_ /= scaleY;
         var _loc5_:Number = this.getScreenToWorldX(_loc3_,_loc4_);
         var _loc6_:Number = this.getScreenToWorldY(_loc3_,_loc4_);
         if(_loc5_ < 0 || _loc6_ < 0 || _loc5_ >= this.mWorldWidth || _loc6_ >= this.mWorldHeight)
         {
            return null;
         }
         return this.mTiles[_loc6_][_loc5_];
      }
      
      public function getExactTileXCoordinate(param1:Number, param2:Number) : Number
      {
         return this.getScreenToWorldExactX((param1 - x) / scaleX,(param2 - y) / scaleY);
      }
      
      public function getExactTileYCoordinate(param1:Number, param2:Number) : Number
      {
         return this.getScreenToWorldExactY((param1 - x) / scaleX,(param2 - y) / scaleY);
      }
      
      public function getTileXCoordinate(param1:int, param2:int) : int
      {
         return this.getScreenToWorldX((param1 - x) / scaleX,(param2 - y) / scaleY);
      }
      
      public function getTileYCoordinate(param1:int, param2:int) : int
      {
         return this.getScreenToWorldY((param1 - x) / scaleX,(param2 - y) / scaleY);
      }
      
      protected function updateScrolling() : void
      {
         if(this.mouseX == this.mMouseDownX)
         {
            if(this.mouseY == this.mMouseDownY)
            {
               return;
            }
         }
         var _loc1_:Number = (this.mouseX - this.mMouseDownX) * scaleX * this.scrollSpeed;
         var _loc2_:Number = (this.mouseY - this.mMouseDownY) * scaleY * this.scrollSpeed;
         this.scrollGameCanvas(_loc1_,_loc2_);
         this.mMouseDownX = this.mouseX;
         this.mMouseDownY = this.mouseY;
      }
      
      public function scrollGameCanvas(param1:Number, param2:Number) : void
      {
         this.x += param1;
         this.y += param2;
      }
      
      private function checkForScrolling() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!this.mDidScrollingOccur)
         {
            _loc1_ = this.mMouseDownX - this.mouseX;
            _loc2_ = this.mMouseDownY - this.mouseY;
            if(_loc1_ * _loc1_ + _loc2_ * _loc2_ >= this.scrollingThreshold * this.scrollingThreshold + this.scrollingThreshold * this.scrollingThreshold)
            {
               this.mDidScrollingOccur = true;
            }
         }
      }
      
      public function selectToolDestroy() : void
      {
         this.changeEngineState(STATE_OBJECT_DESTROY);
      }
      
      public function selectToolRaise() : void
      {
         this.changeEngineState(STATE_TILE_RAISE);
      }
      
      public function selectToolLower() : void
      {
         this.changeEngineState(STATE_TILE_LOWER);
      }
      
      protected function reportMouseClick(param1:MouseEvent) : void
      {
         if(this.mDidScrollingOccur)
         {
            return;
         }
         switch(this.mEngineState)
         {
            case STATE_TILE_LOWER:
               this.lowerSelectedTileMountain();
               break;
            case STATE_TILE_RAISE:
               this.raiseSelectedTileMountain();
               break;
            case STATE_SELECT:
            case STATE_SCROLL:
            case STATE_TILE_EDITING:
            case STATE_MOVE_OBJECT:
               break;
            case STATE_OBJECT_DESTROY:
               if(this.mSelectedObject == this.mSelectedElement)
               {
                  this.removeObject(this.mSelectedObject);
               }
         }
      }
      
      private function clearGrid() : void
      {
         var _loc1_:Graphics = null;
         if(this.mGridLayer != null)
         {
            _loc1_ = this.mGridLayer.graphics;
            _loc1_.clear();
         }
      }
      
      protected function removeGrid() : void
      {
         if(this.mGridLayer)
         {
            removeChild(this.mGridLayer);
            this.mGridLayer = null;
         }
      }
      
      protected function updateGrid() : void
      {
         if(this.mGridLayer == null)
         {
            return;
         }
         var _loc1_:Graphics = this.mGridLayer.graphics;
         if(this.mSelectedElement)
         {
            if(this.mSelectedTileObject != null)
            {
               this.updateSelectedTileObject();
            }
            else if(Boolean(this.mSelectedObject) && this.mSelectedObject.getCollisionObject() != null)
            {
               this.mSelectedObject.drawOnGC(_loc1_,16711680);
            }
            else
            {
               this.mSelectedElement.drawOnGC(_loc1_,65280);
            }
         }
      }
      
      public function initLevel(param1:int, param2:int, param3:Class) : void
      {
         var _loc5_:int = 0;
         this.mTiles = new Array();
         this.mElementObjects = new Vector.<WorldElementObject>();
         this.mWorldWidth = param1;
         this.mWorldHeight = param2;
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            this.mTiles[_loc4_] = new Array();
            if(param3 != null)
            {
               _loc5_ = 0;
               while(_loc5_ < param1)
               {
                  this.setTile(_loc5_,_loc4_,param3);
                  _loc5_++;
               }
            }
            _loc4_++;
         }
      }
      
      public function resizeLevel(param1:int, param2:int) : void
      {
         var _loc3_:int = this.mWorldHeight;
         while(_loc3_ < param2)
         {
            this.mTiles[_loc3_] = new Array();
            _loc3_++;
         }
         this.mWorldWidth = param1;
         this.mWorldHeight = param2;
      }
      
      public function getTile(param1:int, param2:int) : WorldElementTile
      {
         param1 = Math.max(param1,0);
         param2 = Math.max(param2,0);
         param1 = Math.min(param1,this.mWorldWidth - 1);
         param2 = Math.min(param2,this.mWorldHeight - 1);
         return this.mTiles[param2][param1];
      }
      
      public function setTileFromElementTile(param1:int, param2:int, param3:WorldElementTile) : void
      {
         var _loc4_:int = -1;
         var _loc5_:WorldElementTile;
         if((_loc5_ = this.getTile(param1,param2)) != null)
         {
            _loc4_ = this.mLayerTiles.getChildIndex(_loc5_);
            this.mLayerTiles.removeChildAt(_loc4_);
         }
         param3.setWorldPosition(param1,param2,0);
         this.mTiles[param2][param1] = param3;
         if(_loc4_ == -1)
         {
            this.mLayerTiles.addChild(param3);
         }
         else
         {
            this.mLayerTiles.addChildAt(param3,_loc4_);
         }
      }
      
      public function setTile(param1:int, param2:int, param3:Class = null) : void
      {
         var _loc4_:WorldElementTile = null;
         if(param3 != null)
         {
            _loc4_ = new param3(this);
         }
         else
         {
            _loc4_ = new WorldElementTile(this);
         }
         this.setTileFromElementTile(param1,param2,_loc4_);
      }
      
      public function getWorldToRealScreenX(param1:Number, param2:Number, param3:Number = 0) : Number
      {
         return x + this.getWorldToScreenX(param1,param2) * scaleX;
      }
      
      public function getWorldToRealScreenY(param1:Number, param2:Number, param3:Number = 0) : Number
      {
         return y + this.getWorldToScreenY(param1,param2,param3) * scaleY;
      }
      
      public function getWorldToRealScreenFromObjectX(param1:WorldElement) : Number
      {
         return x + this.getWorldToScreenX(param1.mWorldX,param1.mWorldY) * scaleX;
      }
      
      public function getWorldToRealScreenFromObjectY(param1:WorldElement) : Number
      {
         return y + this.getWorldToScreenY(param1.mWorldX,param1.mWorldY,param1.mWorldZ) * scaleY;
      }
      
      public function getWorldToScreenX(param1:Number, param2:Number, param3:Number = 0) : Number
      {
         return this.mTileWidthScreen * (param1 - param2) * 0.5 / this.mTileSizeX;
      }
      
      public function getWorldToScreenY(param1:Number, param2:Number, param3:Number = 0) : Number
      {
         return this.mTileHeightScreen * ((param1 + param2) * 0.5 - param3) / this.mTileSizeY;
      }
      
      public function getScreenToWorldX(param1:Number, param2:Number) : int
      {
         var _loc3_:Number = this.getScreenToWorldExactX(param1,param2);
         if(_loc3_ < 0)
         {
            if(_loc3_ > -1)
            {
               _loc3_ = -1;
            }
         }
         return _loc3_ as int;
      }
      
      public function getScreenToWorldY(param1:Number, param2:Number) : int
      {
         var _loc3_:Number = this.getScreenToWorldExactY(param1,param2);
         if(_loc3_ < 0)
         {
            if(_loc3_ > -1)
            {
               _loc3_ = -1;
            }
         }
         return _loc3_ as int;
      }
      
      public function getScreenToWorldExactX(param1:Number, param2:Number) : Number
      {
         return param1 * this.mTileSizeX / this.mTileWidthScreen + param2 * this.mTileSizeY / this.mTileHeightScreen;
      }
      
      public function getScreenToWorldExactY(param1:Number, param2:Number) : Number
      {
         return param2 * this.mTileSizeY / this.mTileHeightScreen - param1 * this.mTileSizeX / this.mTileWidthScreen;
      }
      
      public function getGroundHeight(param1:Number, param2:Number) : Number
      {
         var _loc3_:WorldElement = null;
         if(this.isTilePositionInBoundaries(param1,param2))
         {
            _loc3_ = this.mTiles[param2][param1];
            if(_loc3_ != null)
            {
               return _loc3_.mWorldZ;
            }
         }
         return 0;
      }
      
      public function getLevelData() : ByteArray
      {
         var _loc2_:WorldElement = null;
         var _loc5_:int = 0;
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeInt(this.mTiles.length);
         var _loc3_:int = 0;
         while(_loc3_ < this.mTiles.length)
         {
            _loc1_.writeInt((this.mTiles[_loc3_] as Array).length);
            _loc5_ = 0;
            while(_loc5_ < (this.mTiles[_loc3_] as Array).length)
            {
               _loc2_ = this.mTiles[_loc3_][_loc5_];
               _loc1_.writeUTF(getQualifiedClassName(_loc2_));
               _loc2_.storeToByteArray(_loc1_);
               _loc5_++;
            }
            _loc3_++;
         }
         _loc1_.writeInt(this.mElementObjects.length);
         var _loc4_:int = 0;
         while(_loc4_ < this.mElementObjects.length)
         {
            _loc2_ = this.mElementObjects[_loc4_];
            _loc1_.writeUTF(getQualifiedClassName(_loc2_));
            _loc2_.storeToByteArray(_loc1_);
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function setLevelData(param1:ByteArray) : void
      {
         var _loc3_:String = null;
         var _loc4_:Class = null;
         var _loc5_:WorldElementObject = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         DCUtils.removeAllChildren(this);
         this.initDisplayContainers();
         var _loc2_:int = param1.readInt();
         this.mTiles = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            _loc9_ = param1.readInt();
            this.mTiles[_loc6_] = new Array();
            _loc10_ = 0;
            while(_loc10_ < _loc9_)
            {
               _loc3_ = param1.readUTF();
               (_loc5_ = new (_loc4_ = getDefinitionByName(_loc3_) as Class)(this)).restoreFromByteArray(param1);
               this.mTiles[_loc6_][_loc10_] = _loc5_;
               this.mLayerTiles.addChild(_loc5_);
               _loc10_++;
            }
            _loc6_++;
         }
         var _loc7_:int = param1.readInt();
         this.mElementObjects = new Vector.<WorldElementObject>();
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc3_ = param1.readUTF();
            (_loc5_ = new (_loc4_ = getDefinitionByName(_loc3_) as Class)(this)).restoreFromByteArray(param1);
            this.mElementObjects[_loc8_] = _loc5_;
            this.mLayerObjects.addChild(_loc5_);
            _loc8_++;
         }
      }
      
      public function setLevelDataTiles(param1:ByteArray) : void
      {
         var _loc3_:String = null;
         var _loc4_:Class = null;
         var _loc5_:WorldElement = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         DCUtils.removeAllChildren(this);
         this.initDisplayContainers();
         var _loc2_:int = param1.readInt();
         this.mTiles = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            _loc7_ = param1.readInt();
            this.mTiles[_loc6_] = new Array();
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc3_ = param1.readUTF();
               (_loc5_ = new (_loc4_ = getDefinitionByName(_loc3_) as Class)(this)).restoreFromByteArray(param1);
               this.mTiles[_loc6_][_loc8_] = _loc5_;
               this.mLayerTiles.addChild(_loc5_);
               _loc8_++;
            }
            _loc6_++;
         }
      }
      
      public function removeObject(param1:WorldElementObject) : void
      {
         var _loc2_:int = this.mElementObjects.indexOf(param1);
         if(_loc2_ != -1)
         {
            if(this.mSelectedObject == param1)
            {
               this.mSelectedObject = null;
            }
            if(this.mLayerObjects.contains(param1))
            {
               this.mLayerObjects.removeChild(param1);
            }
            if(this.mLayerGroundObjects.contains(param1))
            {
               this.mLayerGroundObjects.removeChild(param1);
            }
            this.mElementObjects[_loc2_] = null;
            this.mElementObjects.splice(_loc2_,1);
            if(this.mListenerObjectDestroyed != null)
            {
               if(param1)
               {
                  this.mListenerObjectDestroyed(param1);
               }
            }
            param1 = null;
         }
      }
      
      public function removeObjectAndDestroyIt(param1:WorldElementObject) : void
      {
         this.removeObject(param1);
         param1.destroy();
      }
      
      public function getSelectedObject() : WorldElementObject
      {
         return this.mSelectedObject;
      }
      
      public function getEngineState() : int
      {
         return this.mEngineState;
      }
      
      public function getSelectedTile() : WorldElementTile
      {
         return this.mSelectedTile;
      }
      
      public function getSelectedElement() : WorldElement
      {
         return this.mSelectedElement;
      }
      
      public function getWorldWidth() : int
      {
         return this.mWorldWidth;
      }
      
      public function getWorldHeight() : int
      {
         return this.mWorldHeight;
      }
      
      public function isInsideLevel(param1:int, param2:int) : Boolean
      {
         return param1 >= 0 && param2 >= 0 && param1 < this.mWorldWidth && param2 < this.mWorldHeight;
      }
      
      public function setUpdateObjectPositionInMoveObjectMode(param1:Boolean) : void
      {
         this.mUpdateObjectPositionInMoveObjectMode = param1;
      }
      
      public function getGridLayer() : Shape
      {
         return this.mGridLayer;
      }
      
      public function setSelectedTileObject(param1:DisplayObject) : void
      {
         this.mSelectedTileObject = param1;
         this.mSelectedTileObject.visible = false;
         var _loc2_:int = numChildren - 1;
         while(_loc2_ >= 0)
         {
            if(getChildAt(_loc2_).name == TILES_LAYER_NAME)
            {
               addChildAt(this.mSelectedTileObject,_loc2_ + 1);
               break;
            }
            _loc2_--;
         }
      }
      
      public function updateSelectedTileObject() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         this.mLastSelectedElement = this.mSelectedElement;
         if(this.mSelectedElement == null)
         {
            this.mSelectedTileObject.visible = false;
         }
         else
         {
            this.mSelectedTileObject.visible = true;
            if(this.mSelectedObject != null && this.mSelectedObject.mWorldX % 1 == 0)
            {
               _loc1_ = this.mSelectedObject.mWorldX;
               _loc2_ = this.mSelectedObject.mWorldY;
            }
            else
            {
               _loc1_ = this.mSelectedElement.mWorldX;
               _loc2_ = this.mSelectedElement.mWorldY;
            }
            _loc1_ += this.mTileSizeX / 2;
            _loc2_ += this.mTileSizeY / 2;
            this.mSelectedTileObject.x = this.getWorldToScreenX(_loc1_,_loc2_);
            this.mSelectedTileObject.y = this.getWorldToScreenY(_loc1_,_loc2_,this.mSelectedElement.mWorldZ);
         }
      }
      
      public function hasElevation() : Boolean
      {
         return false;
      }
      
      public function elementDraggedTo(param1:WorldElement, param2:Number, param3:Number, param4:Number = 0) : void
      {
         param1.draggedTo(param2,param3,param4);
      }
   }
}
