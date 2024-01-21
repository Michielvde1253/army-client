package com.dchoc.utils
{
   import com.dchoc.engineisometric.World;
   import com.dchoc.engineisometric.WorldElementObject;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   
   public class CursorManager
   {
      
      private static var instance:CursorManager;
      
      private static var allowInstantiation:Boolean;
       
      
      private var cursors:Array;
      
      private var currentCursorIndex:int;
      
      private var _stage:Stage;
      
      private var draggedObject:DisplayObject;
      
      private var draggedWorldElementObject:WorldElementObject;
      
      private var dragTileDeltaX:Number;
      
      private var dragTileDeltaY:Number;
      
      private var _smoothDragging:Boolean;
      
      private var offsetX:int;
      
      private var offsetY:int;
      
      private var alwaysShowOSCursor:Boolean;
      
      private const lastMousePoint:Point = new Point();
      
      private var mouseHasLeft:Boolean;
      
      public function CursorManager()
      {
         super();
         if(!allowInstantiation)
         {
            throw new Error("ERROR: CursorManager Error: Instantiation failed: Use CursorManager.getInstance() instead of new.");
         }
         this.cursors = new Array();
         this.currentCursorIndex = -1;
         this.alwaysShowOSCursor = false;
      }
      
      public static function getInstance() : CursorManager
      {
         if(instance == null)
         {
            allowInstantiation = true;
            instance = new CursorManager();
            allowInstantiation = false;
         }
         return instance;
      }
      
      public function set smoothDragging(param1:Boolean) : void
      {
         this._smoothDragging = param1;
      }
      
      public function setAlwaysShowOSCursor(param1:Boolean) : void
      {
      }
      
      public function init(param1:Stage) : void
      {
         this._stage = param1;
      }
      
      public function addCursor(param1:DisplayObject) : void
      {
         var _loc2_:int = int(this.cursors.length);
         if(param1 is InteractiveObject)
         {
            InteractiveObject(param1).mouseEnabled = false;
            if(param1 is DisplayObjectContainer)
            {
               DisplayObjectContainer(param1).mouseChildren = false;
            }
         }
         this.cursors[_loc2_] = param1;
      }
      
      public function setCursor(param1:int) : DisplayObject
      {
         var _loc2_:DisplayObject = null;
         if(!this._stage)
         {
            throw new Error("ERROR: CursorManager. Call CursorManager.init first");
         }
         if(this.cursors == null || this.cursors[param1] == null)
         {
            throw new Error("ERROR: CursorManager. Cursor does not exist");
         }
         this.removeCursor();
         if(!this.alwaysShowOSCursor)
         {
            Mouse.hide();
         }
         this.currentCursorIndex = param1;
         _loc2_ = this.cursors[param1] as DisplayObject;
         _loc2_.x = this._stage.mouseX;
         _loc2_.y = this._stage.mouseY;
         this._stage.addChild(_loc2_);
         this._stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoved,false);
         this._stage.addEventListener(Event.MOUSE_LEAVE,this.mouseLeft,false);
         return _loc2_;
      }
      
      public function getCursor() : int
      {
         return this.currentCursorIndex;
      }
      
      private function mouseLeft(param1:Event) : void
      {
         var _loc2_:DisplayObject = null;
         if(this.currentCursorIndex != -1)
         {
            _loc2_ = this.cursors[this.currentCursorIndex] as DisplayObject;
            _loc2_.visible = false;
         }
         if(this.draggedObject != null)
         {
            this.draggedObject.visible = false;
         }
         if(this.draggedWorldElementObject != null)
         {
            this.draggedWorldElementObject.visible = false;
         }
         if(!this.alwaysShowOSCursor)
         {
            Mouse.show();
         }
         this.mouseHasLeft = true;
      }
      
      private function mouseMoved(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = null;
         if(this.mouseHasLeft)
         {
            this.mouseHasLeft = false;
            if(!this.alwaysShowOSCursor)
            {
               Mouse.hide();
            }
         }
         if(this.currentCursorIndex != -1)
         {
            _loc2_ = this.cursors[this.currentCursorIndex] as DisplayObject;
            _loc2_.x = this._stage.mouseX;
            _loc2_.y = this._stage.mouseY;
            _loc2_.visible = true;
         }
         if(this.draggedObject != null)
         {
            this.draggedObject.x = this._stage.mouseX;
            this.draggedObject.y = this._stage.mouseY;
         }
         if(this.draggedWorldElementObject != null)
         {
            this.updateIsoObject();
         }
         param1.updateAfterEvent();
      }
      
      public function updateIsoObject() : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this.draggedWorldElementObject == null)
         {
            return;
         }
         var _loc1_:World = this.draggedWorldElementObject.getWorld();
         var _loc2_:Number = _loc1_.mouseX;
         var _loc3_:Number = _loc1_.mouseY;
         if(this._smoothDragging)
         {
            _loc4_ = _loc1_.getScreenToWorldExactX(_loc2_,_loc3_);
            _loc5_ = _loc1_.getScreenToWorldExactY(_loc2_,_loc3_);
         }
         else
         {
            _loc4_ = _loc1_.getScreenToWorldX(_loc2_,_loc3_);
            _loc5_ = _loc1_.getScreenToWorldY(_loc2_,_loc3_);
         }
         if(isNaN(this.dragTileDeltaX))
         {
            this.dragTileDeltaX = _loc4_ - this.draggedWorldElementObject.mWorldX;
            this.dragTileDeltaY = _loc5_ - this.draggedWorldElementObject.mWorldY;
         }
         _loc1_.elementDraggedTo(this.draggedWorldElementObject,_loc4_ - this.dragTileDeltaX,_loc5_ - this.dragTileDeltaY);
      }
      
      public function bringToFront() : void
      {
         if(this.currentCursorIndex == -1)
         {
            return;
         }
         DCUtils.bringToFront(this._stage,this.cursors[this.currentCursorIndex] as DisplayObject);
      }
      
      public function removeCursor() : void
      {
         if(this.currentCursorIndex == -1)
         {
            return;
         }
         this._stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoved);
         this._stage.removeEventListener(Event.MOUSE_LEAVE,this.mouseLeft);
         this._stage.removeChild(this.cursors[this.currentCursorIndex]);
         this.currentCursorIndex = -1;
         if(!this.alwaysShowOSCursor)
         {
            Mouse.show();
         }
      }
      
      public function setCursorAnimation(param1:String) : void
      {
         MovieClip(this.cursors[this.currentCursorIndex]).gotoAndStop(param1);
      }
      
      public function clean() : void
      {
         this.removeCursor();
         this.cursors = null;
      }
      
      public function logicUpdate() : void
      {
         var _loc1_:DisplayObject = this.cursors[this.currentCursorIndex] as DisplayObject;
         _loc1_.x = this._stage.mouseX;
         _loc1_.y = this._stage.mouseY;
         if(this.draggedWorldElementObject)
         {
            if(int(this.lastMousePoint.x) == int(this._stage.mouseX))
            {
               if(int(this.lastMousePoint.y) == int(this._stage.mouseY))
               {
                  this.draggedWorldElementObject.draggingStopped();
               }
            }
         }
         this.lastMousePoint.x = this._stage.mouseX;
         this.lastMousePoint.y = this._stage.mouseY;
      }
      
      public function attachObjectToCursor(param1:DisplayObject, param2:WorldElementObject = null) : void
      {
         this.draggedObject = param1;
         this.draggedObject.x = this._stage.mouseX;
         this.draggedObject.y = this._stage.mouseY;
         if(this.draggedObject is Sprite)
         {
            Sprite(this.draggedObject).mouseChildren = false;
            Sprite(this.draggedObject).mouseEnabled = false;
         }
         this._stage.addChild(this.draggedObject);
         if(param2 != null)
         {
            this.attachWorldElementObjectToCursor(param2);
         }
         this.bringToFront();
      }
      
      public function setOffset(param1:int, param2:int) : void
      {
         this.offsetX = param1;
         this.offsetY = param2;
         this.updateIsoObject();
      }
      
      public function attachWorldElementObjectToCursor(param1:WorldElementObject) : void
      {
         this.draggedWorldElementObject = param1;
         this.updateIsoObject();
         this.bringToFront();
      }
      
      public function removeAttachObjectToCursor(param1:Boolean = true) : void
      {
         if(this.draggedObject != null)
         {
            if(this._stage.getChildByName(this.draggedObject.name) != null)
            {
               this._stage.removeChild(this.draggedObject);
            }
            this.draggedObject = null;
         }
         if(this.draggedWorldElementObject)
         {
            this.draggedWorldElementObject.rotation = 0;
            if(param1)
            {
               this.draggedWorldElementObject.getWorld().removeObject(this.draggedWorldElementObject);
               this.draggedWorldElementObject.destroy();
            }
            this.draggedWorldElementObject.visible = true;
         }
         this.draggedWorldElementObject = null;
         this.dragTileDeltaX = Number.NaN;
         this.dragTileDeltaY = Number.NaN;
         this.offsetX = 0;
         this.offsetY = 0;
      }
      
      public function getDraggedObject() : DisplayObject
      {
         return this.draggedObject;
      }
      
      public function getDraggedWorldElementObject() : WorldElementObject
      {
         return this.draggedWorldElementObject;
      }
   }
}
