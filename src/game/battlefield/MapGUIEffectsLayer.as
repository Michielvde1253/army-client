package game.battlefield
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.characters.PlayerUnit;
   import game.gameElements.PermanentHFEObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.SceneLoader;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.Renderable;
   import game.states.GameState;
   
   public class MapGUIEffectsLayer
   {
      
      public static const TILE_TL:int = 0;
      
      public static const TILE_TR:int = 1;
      
      public static const TILE_BL:int = 2;
      
      public static const TILE_BR:int = 3;
      
      public static const TILE_TOP_TL:int = 4;
      
      public static const TILE_LEFT_BL:int = 5;
      
      public static const TILE_RIGHT_TR:int = 6;
      
      public static const TILE_BOTTOM_BR:int = 7;
      
      public static const TILE_TOP_TR:int = 8;
      
      public static const TILE_RIGHT_BR:int = 9;
      
      public static const TILE_LEFT_TL:int = 10;
      
      public static const TILE_BOTTOM_BL:int = 11;
      
      public static const TILE_TOP:int = 12;
      
      public static const TILE_RIGHT:int = 13;
      
      public static const TILE_BOTTOM:int = 14;
      
      public static const TILE_LEFT:int = 15;
      
      public static const TILE_FULL_TL:int = 16;
      
      public static const TILE_FULL_TR:int = 17;
      
      public static const TILE_FULL_BR:int = 18;
      
      public static const TILE_FULL_BL:int = 19;
       
      
      private var mScene:IsometricScene;
      
      private var mMoveClass:Class;
      
      private var mArrowClass:Class;
      
      private var mEnableGrid1Class:Class;
      
      private var mEnableGrid2Class:Class;
      
      private var mEnableGrid3Class:Class;
      
      private var mEnableGrid4Class:Class;
      
      private var mEnableGrids:Array;
      
      private var mAttackGridClass:Class;
      
      private var mToolGrid1Class:Class;
      
      private var mToolGrid2Class:Class;
      
      private var mToolGrid3Class:Class;
      
      private var mToolGrid4Class:Class;
      
      private var mToolGridSpecialClass_3x2:Class;
      
      private var mToolGrids:Array;
      
      private var mDisabledGridClass:Class;
      
      private var mHighlightedCells:Array;
      
      private var mHighlightedEnemyMovingCells:Array;
      
      private var mDisabledCells:Array;
      
      private var mRangeBitmapClasses:Array;
      
      private var mRangeHighlights:Array;
      
      private var mRangeHighlightRenderable:Renderable = null;
      
      public var mTopLayer:Sprite;
      
      public var mGroundLayer:Sprite;
      
      public function MapGUIEffectsLayer(param1:IsometricScene)
      {
         super();
         this.mTopLayer = new Sprite();
         this.mTopLayer.mouseChildren = false;
         this.mTopLayer.mouseEnabled = false;
         this.mGroundLayer = new Sprite();
         this.mGroundLayer.mouseChildren = false;
         this.mGroundLayer.mouseEnabled = false;
         this.mScene = param1;
         var _loc2_:DCResourceManager = DCResourceManager.getInstance();
         this.mEnableGrid1Class = _loc2_.getSWFClass(Config.SWF_INTERFACE_NAME,"grid_enabled");
         this.mEnableGrid2Class = _loc2_.getSWFClass(Config.SWF_INTERFACE_NAME,"grid_enabled_2x2");
         this.mEnableGrid3Class = _loc2_.getSWFClass(Config.SWF_INTERFACE_NAME,"grid_enabled_3x3");
         this.mEnableGrid4Class = _loc2_.getSWFClass(Config.SWF_INTERFACE_NAME,"cursor_grid_enabled_4x4");
         this.mEnableGrids = [this.mEnableGrid1Class,this.mEnableGrid2Class,this.mEnableGrid3Class,this.mEnableGrid4Class];
         this.mAttackGridClass = _loc2_.getSWFClass(Config.SWF_INTERFACE_NAME,"cursor_attack_highlight");
         this.mToolGrid1Class = _loc2_.getSWFClass(Config.SWF_INTERFACE_NAME,"cursor_moveunits_1x1");
         this.mToolGrid2Class = _loc2_.getSWFClass(Config.SWF_INTERFACE_NAME,"cursor_move_2x2");
         this.mToolGrid3Class = _loc2_.getSWFClass(Config.SWF_INTERFACE_NAME,"cursor_move_3x3");
         this.mToolGrid4Class = _loc2_.getSWFClass(Config.SWF_INTERFACE_NAME,"cursor_move_4x4");
         this.mToolGridSpecialClass_3x2 = _loc2_.getSWFClass(Config.SWF_INTERFACE_NAME,"cursor_move_special_3x2");
         this.mToolGrids = [this.mToolGrid1Class,this.mToolGrid2Class,this.mToolGrid3Class,this.mToolGrid4Class];
         this.mDisabledGridClass = _loc2_.getSWFClass(Config.SWF_INTERFACE_NAME,"grid_disabled");
         this.mArrowClass = _loc2_.getSWFClass(Config.SWF_INTERFACE_NAME,"grid_highlighted");
         this.mMoveClass = _loc2_.getSWFClass(Config.SWF_INTERFACE_NAME,"cursor_moveunits_1x1");
         this.mHighlightedCells = new Array();
         this.mHighlightedEnemyMovingCells = new Array();
         this.mDisabledCells = new Array();
         this.mRangeHighlights = new Array();
         this.mRangeBitmapClasses = new Array();
         this.mRangeBitmapClasses[TILE_TL] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_01");
         this.mRangeBitmapClasses[TILE_TR] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_02");
         this.mRangeBitmapClasses[TILE_BL] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_03");
         this.mRangeBitmapClasses[TILE_BR] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_04");
         this.mRangeBitmapClasses[TILE_TOP_TL] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_05");
         this.mRangeBitmapClasses[TILE_LEFT_BL] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_06");
         this.mRangeBitmapClasses[TILE_RIGHT_TR] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_07");
         this.mRangeBitmapClasses[TILE_BOTTOM_BR] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_08");
         this.mRangeBitmapClasses[TILE_TOP_TR] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_09");
         this.mRangeBitmapClasses[TILE_RIGHT_BR] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_10");
         this.mRangeBitmapClasses[TILE_LEFT_TL] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_12");
         this.mRangeBitmapClasses[TILE_BOTTOM_BL] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_11");
         this.mRangeBitmapClasses[TILE_TOP] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_13");
         this.mRangeBitmapClasses[TILE_RIGHT] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_14");
         this.mRangeBitmapClasses[TILE_BOTTOM] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_15");
         this.mRangeBitmapClasses[TILE_LEFT] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_16");
         this.mRangeBitmapClasses[TILE_FULL_TL] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_17");
         this.mRangeBitmapClasses[TILE_FULL_TR] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_18");
         this.mRangeBitmapClasses[TILE_FULL_BR] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_19");
         this.mRangeBitmapClasses[TILE_FULL_BL] = _loc2_.getSWFClass("swf/tiles_common","Bg_FireRange_20");
      }
      
      public function removeHighlightRange() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = int(this.mRangeHighlights.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mRangeHighlights[_loc3_] as DisplayObject;
            if(_loc1_.parent)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
            _loc3_++;
         }
         _loc1_ = null;
         this.mRangeHighlights = new Array();
      }
      
      public function highlightRange(param1:GridCell, param2:Renderable) : void
      {
         var _loc13_:int = 0;
         if(!param2.hasOwnProperty("mAttackRange"))
         {
            return;
         }
         var _loc3_:int = int((param2 as Object).mAttackRange);
         if(param2 is IsometricCharacter)
         {
            if(_loc3_ <= 1 || _loc3_ == 0)
            {
               return;
            }
         }
         var _loc4_:int;
         if((_loc4_ = int((param2 as Object).mPower)) == 0)
         {
            return;
         }
         if(this.mRangeHighlightRenderable == param2)
         {
            if(this.mRangeHighlights.length > 0)
            {
               return;
            }
         }
         this.mRangeHighlightRenderable = param2;
         param1 = param2.getCell();
         if(!param1)
         {
            return;
         }
         var _loc5_:PlayerUnit = GameState.mInstance.mActivatedPlayerUnit;
         if(param1.mCharacter != _loc5_)
         {
            return;
         }
         var _loc6_:int = param2.getTileSize().x - 1;
         var _loc7_:int = param2.getTileSize().y - 1;
         var _loc8_:int = Math.max(param1.mPosI - _loc3_,0);
         var _loc9_:int = Math.min(param1.mPosI + _loc6_ + _loc3_,this.mScene.mSizeX);
         var _loc10_:int = Math.max(param1.mPosJ - _loc3_,0);
         var _loc11_:int = Math.min(param1.mPosJ + _loc7_ + _loc3_,this.mScene.mSizeY);
         this.removeHighlightRange();
         var _loc12_:int = _loc8_;
         while(_loc12_ <= _loc9_)
         {
            _loc13_ = _loc10_;
            while(_loc13_ <= _loc11_)
            {
               if(_loc12_ == _loc8_)
               {
                  if(_loc13_ == _loc10_)
                  {
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_TL]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_TOP_TR]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_LEFT_BL]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_BR]());
                  }
                  else if(_loc13_ == _loc11_)
                  {
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_BL]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_LEFT_TL]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_BOTTOM_BR]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_TR]());
                  }
                  else
                  {
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_LEFT]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_BR]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_TR]());
                  }
               }
               else if(_loc12_ == _loc9_)
               {
                  if(_loc13_ == _loc10_)
                  {
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_TR]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_TOP_TL]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_RIGHT_BR]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_BL]());
                  }
                  else if(_loc13_ == _loc11_)
                  {
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_BR]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_RIGHT_TR]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_BOTTOM_BL]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_TL]());
                  }
                  else
                  {
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_RIGHT]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_BL]());
                     this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_TL]());
                  }
               }
               else if(_loc13_ == _loc10_)
               {
                  this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_TOP]());
                  this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_BR]());
                  this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_BL]());
               }
               else if(_loc13_ == _loc11_)
               {
                  this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_BOTTOM]());
                  this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_TL]());
                  this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_TR]());
               }
               else
               {
                  this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_TL]());
                  this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_TR]());
                  this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_BL]());
                  this.addRangeHighlightToCell(_loc12_,_loc13_,new this.mRangeBitmapClasses[TILE_FULL_BR]());
               }
               _loc13_++;
            }
            _loc12_++;
         }
      }
      
      private function addRangeHighlightToCell(param1:int, param2:int, param3:DisplayObject) : void
      {
         param3.x = param1 * SceneLoader.GRID_CELL_SIZE;
         param3.y = param2 * SceneLoader.GRID_CELL_SIZE;
         this.mRangeHighlights.push(param3);
         this.mGroundLayer.addChild(param3);
      }
      
      public function highlightGridCell(param1:GridCell, param2:Boolean) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         if(!param1)
         {
            return;
         }
         if(param2)
         {
            _loc3_ = new this.mEnableGrid1Class();
            _loc3_.x = this.mScene.getCenterPointXOfCell(param1);
            _loc3_.y = this.mScene.getCenterPointYOfCell(param1);
            this.mHighlightedCells.push(_loc3_);
            this.mTopLayer.addChild(_loc3_);
         }
         else
         {
            (_loc4_ = new this.mDisabledGridClass()).x = this.mScene.getCenterPointXOfCell(param1);
            _loc4_.y = this.mScene.getCenterPointYOfCell(param1);
            this.mDisabledCells.push(_loc4_);
            this.mTopLayer.addChild(_loc4_);
         }
      }
      
      public function highlightSelectedGridCell(param1:GridCell, param2:Boolean) : void
      {
         if(!param1)
         {
            return;
         }
      }
      
      public function highlightAttackerGridCell(param1:GridCell) : void
      {
         var _loc3_:MovieClip = null;
         var _loc6_:MovieClip = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:Boolean = true;
         var _loc4_:int = int(this.mHighlightedCells.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this.mHighlightedCells[_loc5_] as MovieClip;
            if(_loc3_.x == this.mScene.getCenterPointXOfCell(param1))
            {
               if(_loc3_.y == this.mScene.getCenterPointYOfCell(param1))
               {
                  _loc2_ = false;
                  break;
               }
            }
            _loc5_++;
         }
         if(_loc2_)
         {
            (_loc6_ = new this.mAttackGridClass()).x = this.mScene.getCenterPointXOfCell(param1);
            _loc6_.y = this.mScene.getCenterPointYOfCell(param1);
            this.mHighlightedCells.push(_loc6_);
            this.mGroundLayer.addChild(_loc6_);
         }
      }
      
      public function hideAttackGridCells() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         if(this.mHighlightedCells)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mHighlightedCells.length)
            {
               _loc1_ = this.mHighlightedCells[_loc2_] as MovieClip;
               if(this.mGroundLayer.contains(_loc1_))
               {
                  this.mGroundLayer.removeChild(_loc1_);
                  this.mHighlightedCells.splice(_loc2_,1);
                  _loc2_--;
               }
               _loc2_++;
            }
            _loc1_ = null;
         }
      }
      
      public function clearHighlights() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.mHighlightedCells)
         {
            _loc2_ = int(this.mHighlightedCells.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc1_ = this.mHighlightedCells[_loc3_] as MovieClip;
               if(this.mTopLayer.contains(_loc1_))
               {
                  this.mTopLayer.removeChild(_loc1_);
               }
               else if(this.mGroundLayer.contains(_loc1_))
               {
                  this.mGroundLayer.removeChild(_loc1_);
               }
               _loc3_++;
            }
            _loc1_ = null;
         }
         if(this.mDisabledCells)
         {
            _loc5_ = int(this.mDisabledCells.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc4_ = this.mDisabledCells[_loc6_] as MovieClip;
               this.mTopLayer.removeChild(_loc4_);
               _loc6_++;
            }
            _loc1_ = null;
         }
         this.mDisabledCells = new Array();
         this.mHighlightedCells = new Array();
         this.mScene.mDisabledCellsForMoving = new Array();
         this.mTopLayer.mouseChildren = false;
         this.removeHighlightRange();
         this.clearEnemyMovementHighlights();
      }
      
      public function clearEnemyMovementHighlights() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mHighlightedEnemyMovingCells)
         {
            _loc2_ = int(this.mHighlightedEnemyMovingCells.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc1_ = this.mHighlightedEnemyMovingCells[_loc3_] as MovieClip;
               if(this.mTopLayer.contains(_loc1_))
               {
                  this.mTopLayer.removeChild(_loc1_);
               }
               else if(this.mGroundLayer.contains(_loc1_))
               {
                  this.mGroundLayer.removeChild(_loc1_);
               }
               _loc3_++;
            }
            _loc1_ = null;
         }
         this.mHighlightedEnemyMovingCells = new Array();
         this.mTopLayer.mouseChildren = false;
      }
      
      public function highlightNeighbourClickables() : void
      {
      }
      
      public function highlightNeighbourClickableCell(param1:GridCell) : void
      {
         var _loc2_:MovieClip = null;
         var _loc5_:MovieClip = null;
         if(param1.mObject)
         {
            param1 = param1.mObject.getCell();
         }
         var _loc3_:int = int(this.mHighlightedCells.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mHighlightedCells[_loc4_] as MovieClip;
            if(_loc2_.x == this.mScene.getCenterPointXOfCell(param1))
            {
               if(_loc2_.y == this.mScene.getCenterPointYOfCell(param1))
               {
                  return;
               }
            }
            _loc4_++;
         }
         this.clearHighlights();
         this.mHighlightedCells = new Array();
         if(param1.mCharacter)
         {
            _loc5_ = new this.mToolGrids[param1.mCharacter.getTileSize().x - 1]();
         }
         else if(param1.mObject)
         {
            if(param1.mObject.getTileSize().x == param1.mObject.getTileSize().y)
            {
               _loc5_ = new this.mToolGrids[param1.mObject.getTileSize().x - 1]();
            }
            else
            {
               _loc5_ = new this.mToolGridSpecialClass_3x2();
            }
         }
         if(_loc5_)
         {
            _loc5_.x = this.mScene.getCenterPointXOfCell(param1);
            _loc5_.y = this.mScene.getCenterPointYOfCell(param1);
            this.mHighlightedCells.push(_loc5_);
            this.mTopLayer.addChild(_loc5_);
         }
      }
      
      public function highlightMoveArea(param1:Boolean = false) : void
      {
         var _loc2_:Array = null;
         var _loc3_:MovieClip = null;
         var _loc4_:GridCell = null;
         var _loc7_:GridCell = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:TextField = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         if(param1)
         {
            if(this.mHighlightedCells)
            {
               if(this.mHighlightedCells.length > 0)
               {
                  return;
               }
            }
         }
         this.clearHighlights();
         if(param1)
         {
            _loc2_ = GameState.mInstance.mEnemyWalkableCells;
         }
         else
         {
            _loc2_ = GameState.mInstance.mActiveCharacteWalkableCells;
         }
         if(param1)
         {
            this.mHighlightedEnemyMovingCells = new Array();
         }
         else
         {
            this.mHighlightedCells = new Array();
         }
         var _loc5_:int = int(_loc2_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(_loc4_ = _loc2_[_loc6_] as GridCell)
            {
               _loc3_ = new this.mEnableGrid1Class();
               _loc3_.x = this.mScene.getCenterPointXOfCell(_loc4_);
               _loc3_.y = this.mScene.getCenterPointYOfCell(_loc4_);
               _loc3_.buttonMode = true;
               if(param1)
               {
                  this.mHighlightedEnemyMovingCells.push(_loc3_);
               }
               else
               {
                  this.mHighlightedCells.push(_loc3_);
               }
               this.mTopLayer.addChild(_loc3_);
               _loc3_.addEventListener(MouseEvent.MOUSE_UP,this.reportMouseReleased,false,0,true);
            }
            _loc6_++;
         }
         this.mTopLayer.mouseChildren = true;
         if(Config.DEBUG_PATHFINDING)
         {
            _loc8_ = int(_loc2_.length);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               if(_loc7_ = _loc2_[_loc9_] as GridCell)
               {
                  (_loc10_ = new TextField()).text = "G: " + _loc7_.mG;
                  _loc10_.y = 10;
                  _loc3_.addChild(_loc10_);
                  _loc3_.graphics.lineStyle(3,16711680);
                  _loc3_.graphics.drawCircle(0,0,5);
                  _loc3_.graphics.moveTo(0,0);
                  _loc11_ = (_loc7_.mParent.mPosI - _loc7_.mPosI) * 20;
                  _loc12_ = (_loc7_.mParent.mPosJ - _loc7_.mPosJ) * 20;
                  _loc3_.graphics.lineTo(_loc11_,_loc12_);
               }
               _loc9_++;
            }
         }
      }
      
      private function reportMouseReleased(param1:MouseEvent) : void
      {
         if(!this.mScene.mMouseScrolling && !this.mScene.mTickCrossActive)
         {
            if(!this.mScene.mAnyScrollKeyPressed)
            {
               this.mScene.FloorClicked(param1);
            }
         }
         var _loc2_:MovieClip = param1.target as MovieClip;
         _loc2_.removeEventListener(param1.type,this.reportMouseReleased);
      }
      
      public function clearMoveDisabledArea() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mDisabledCells)
         {
            _loc2_ = int(this.mDisabledCells.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc1_ = this.mDisabledCells[_loc3_] as MovieClip;
               this.mTopLayer.removeChild(_loc1_);
               _loc3_++;
            }
            _loc1_ = null;
         }
         this.mDisabledCells = new Array();
         this.mScene.mDisabledCellsForMoving = new Array();
      }
      
      public function highlightMovementDisabledArea() : void
      {
         var _loc2_:MovieClip = null;
         var _loc4_:GridCell = null;
         this.clearMoveDisabledArea();
         var _loc1_:Array = GameState.mInstance.mActiveCharacteNonWalkableCells;
         this.mDisabledCells = new Array();
         var _loc3_:PlayerUnit = GameState.mInstance.mActivatedPlayerUnit;
         var _loc5_:int = int(_loc1_.length);
         var _loc6_:int = 0;
         for(; _loc6_ < _loc5_; _loc6_++)
         {
            if(_loc4_ = _loc1_[_loc6_] as GridCell)
            {
               if(_loc4_.mCharacter == _loc3_)
               {
                  _loc2_ = new this.mMoveClass();
                  _loc2_.mouseChildren = false;
                  _loc2_.mouseEnabled = false;
               }
               else
               {
                  if(!(_loc4_.mCharacter is PlayerUnit))
                  {
                     continue;
                  }
                  _loc2_ = new this.mDisabledGridClass();
               }
               _loc2_.x = this.mScene.getCenterPointXOfCell(_loc4_);
               _loc2_.y = this.mScene.getCenterPointYOfCell(_loc4_);
               this.mDisabledCells.push(_loc2_);
               this.mTopLayer.addChild(_loc2_);
            }
         }
      }
      
      public function highlightPlacingArea() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:GridCell = null;
         var _loc4_:MovieClip = null;
         var _loc5_:GridCell = null;
         this.clearHighlights();
         this.clearMoveDisabledArea();
         this.mHighlightedCells = new Array();
         this.mDisabledCells = new Array();
         var _loc1_:Array = this.mScene.getEnabledCellsForMovingObject();
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_)
            {
               _loc2_ = new this.mEnableGrid1Class();
               _loc2_.x = this.mScene.getCenterPointXOfCell(_loc3_);
               _loc2_.y = this.mScene.getCenterPointYOfCell(_loc3_);
               this.mHighlightedCells.push(_loc2_);
               this.mTopLayer.addChild(_loc2_);
            }
         }
         for each(_loc5_ in this.mScene.mDisabledCellsForMoving)
         {
            (_loc4_ = new this.mDisabledGridClass()).x = this.mScene.getCenterPointXOfCell(_loc5_);
            _loc4_.y = this.mScene.getCenterPointYOfCell(_loc5_);
            this.mDisabledCells.push(_loc4_);
            this.mTopLayer.addChild(_loc4_);
         }
      }
      
      public function highlightFireMission() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Renderable = null;
         var _loc5_:GridCell = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         this.clearHighlights();
         var _loc3_:int = int(this.mScene.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mScene.mAllElements[_loc4_] as Renderable;
            if(_loc2_)
            {
               if(_loc2_ is PermanentHFEObject)
               {
                  _loc6_ = null;
                  _loc7_ = int((_loc6_ = this.mScene.getTilesUnderObject(_loc2_)).length);
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_)
                  {
                     _loc5_ = _loc6_[_loc8_] as GridCell;
                     _loc1_ = new this.mDisabledGridClass();
                     _loc1_.x = this.mScene.getCenterPointXOfCell(_loc5_);
                     _loc1_.y = this.mScene.getCenterPointYOfCell(_loc5_);
                     this.mDisabledCells.push(_loc1_);
                     this.mTopLayer.addChild(_loc1_);
                     _loc8_++;
                  }
               }
            }
            _loc4_++;
         }
      }
      
      public function highlightMovableObjects() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Renderable = null;
         var _loc6_:GridCell = null;
         this.clearHighlights();
         var _loc1_:Array = this.mScene.getMovableObjects();
         this.mHighlightedCells = new Array();
         var _loc4_:int = int(_loc1_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _loc1_[_loc5_] as Renderable;
            if(_loc6_ = _loc3_.getCell())
            {
               _loc2_ = new this.mToolGrids[_loc3_.getTileSize().x - 1]();
               _loc2_.x = this.mScene.getCenterPointXOfCell(_loc6_);
               _loc2_.y = this.mScene.getCenterPointYOfCell(_loc6_);
               this.mHighlightedCells.push(_loc2_);
               this.mTopLayer.addChild(_loc2_);
            }
            _loc5_++;
         }
      }
      
      public function highlightSellableObjects() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Renderable = null;
         var _loc6_:GridCell = null;
         this.clearHighlights();
         var _loc1_:Array = this.mScene.getSellableObjects();
         this.mHighlightedCells = new Array();
         var _loc4_:int = int(_loc1_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _loc1_[_loc5_] as Renderable;
            if(_loc6_ = _loc3_.getCell())
            {
               _loc2_ = new this.mToolGrids[_loc3_.getTileSize().x - 1]();
               _loc2_.x = this.mScene.getCenterPointXOfCell(_loc6_);
               _loc2_.y = this.mScene.getCenterPointYOfCell(_loc6_);
               this.mHighlightedCells.push(_loc2_);
               this.mTopLayer.addChild(_loc2_);
            }
            _loc5_++;
         }
      }
      
      public function highlightRepairEnabledCells() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:GridCell = null;
         var _loc7_:Renderable = null;
         this.clearHighlights();
         var _loc1_:Array = this.mScene.getEnabledCellsForRepairObject();
         this.mHighlightedCells = new Array();
         var _loc5_:int = int(_loc1_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(_loc4_ = _loc1_[_loc6_] as GridCell)
            {
               _loc7_ = !!_loc4_.mObject ? _loc4_.mObject : _loc4_.mCharacter;
               _loc2_ = new this.mToolGrids[_loc7_.getTileSize().x - 1]();
               _loc2_.y = this.mScene.getCenterPointYOfCell(_loc7_.getCell());
               _loc2_.x = this.mScene.getCenterPointXOfCell(_loc7_.getCell());
               this.mHighlightedCells.push(_loc2_);
               this.mTopLayer.addChild(_loc2_);
            }
            _loc6_++;
         }
      }
      
      public function highlightPickupableUnitCells() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:GridCell = null;
         var _loc7_:Renderable = null;
         this.clearHighlights();
         var _loc1_:Array = this.mScene.getEnabledCellsForPickupUnit();
         this.mHighlightedCells = new Array();
         var _loc5_:int = int(_loc1_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(_loc4_ = _loc1_[_loc6_] as GridCell)
            {
               _loc7_ = !!_loc4_.mObject ? _loc4_.mObject : _loc4_.mCharacter;
               _loc2_ = new this.mToolGrids[_loc7_.getTileSize().x - 1]();
               _loc2_.x = this.mScene.getCenterPointYOfCell(_loc7_.getCell());
               _loc2_.y = this.mScene.getCenterPointXOfCell(_loc7_.getCell());
               this.mHighlightedCells.push(_loc2_);
               this.mTopLayer.addChild(_loc2_);
            }
            _loc6_++;
         }
      }
      
      public function destroy() : void
      {
         this.mScene = null;
         if(this.mTopLayer.parent)
         {
            this.mTopLayer.parent.removeChild(this.mTopLayer);
         }
         this.mTopLayer = null;
         if(this.mGroundLayer.parent)
         {
            this.mGroundLayer.parent.removeChild(this.mGroundLayer);
         }
         this.mGroundLayer = null;
      }
   }
}
