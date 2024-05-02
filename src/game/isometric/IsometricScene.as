package game.isometric
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.events.TransformGestureEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.utils.Timer;
   import game.actions.NeighborActionQueue;
   import game.actions.RepairConstructionAction;
   import game.actions.RepairDecorationAction;
   import game.actions.RepairPlayerInstallationAction;
   import game.actions.RepairPlayerUnitAction;
   import game.actions.RepairResourceBuildingAction;
   import game.actions.WalkingAction;
   import game.battlefield.FogOfWar;
   import game.battlefield.MapArea;
   import game.battlefield.MapData;
   import game.battlefield.MapGUIEffectsLayer;
   import game.battlefield.TileMapGraphic;
   import game.characters.AnimationController;
   import game.characters.EnemyUnit;
   import game.characters.PlayerUnit;
   import game.characters.PvPEnemyUnit;
   import game.environment.EnvEffectManager;
   import game.gameElements.*;
   import game.gui.CursorManager;
   import game.gui.HUDInterface;
   import game.gui.popups.PopUpManager;
   import game.isometric.camera.IsoCamera;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.DisplayContainer;
   import game.isometric.elements.DynamicObject;
   import game.isometric.elements.Element;
   import game.isometric.elements.Floor;
   import game.isometric.elements.Renderable;
   import game.isometric.elements.StaticObject;
   import game.isometric.pathfinding.AStarPathfinder;
   import game.items.AreaItem;
   import game.items.DebrisItem;
   import game.items.EnemyInstallationItem;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.MapItem;
   import game.items.PlayerUnitItem;
   import game.items.ShopItem;
   import game.items.TimerItem;
   import game.missions.MissionManager;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   import game.utils.EffectController;
   
   public class IsometricScene
   {
      
      public static var mouseDownAction:Boolean;
      
      public static var mMinAreaX:Number = Number.MAX_VALUE;
      
      public static var mMinAreaY:Number = Number.MAX_VALUE;
      
      public static var mMaxAreaX:Number = Number.MIN_VALUE;
      
      public static var mMaxAreaY:Number = Number.MIN_VALUE;
      
      private static const CAM_SPEED:int = 15;
      
      private static const MINUTE_MS:int = 60000;
      
      private static var mRemoveArray:Array = new Array();
      
      private static const MOUSE_CURSOR_STATE_DOWN:int = 1;
      
      private static const MOUSE_CURSOR_STATE_UP:int = 2;
      
      public static const TUTORIAL_HIGHLIGHT_CIRCLE:int = 0;
      
      public static const TUTORIAL_HIGHLIGHT_TARGET:int = 1;
      
      public static const TUTORIAL_HIGHLIGHT_MOVE:int = 2;
      
      private static var smTmpSolution:Array = new Array();
      
      private static var counter:int = 0;
       
      
      private var mGame:GameState;
      
      public var mContainer:Sprite;
      
      public var mGridDimX:Number;
      
      public var mGridDimY:Number;
      
      public var mGridDimZ:Number;
      
      public var mSizeX:int;
      
      public var mSizeY:int;
      
      public var mTilemapGraphic:TileMapGraphic;
      
      public var mFog:FogOfWar;
      
      public var mSceneHud:Sprite;
      
      private var mFloor:Floor;
      
      public var mAllElements:Array;
      
      public var mCamera:IsoCamera;
      
      private var mPointTmp:Point;
      
      private var mPointTmp2:Point;
      
      private var mSceneActive:Boolean = false;
      
      private var mRubberBandTimer:int;
      
      public var mVisibleObjectCnt:int = 0;
      
      public var mObjectBeingMoved:Renderable;
      
      public var mObjectBeingMovedStartX:Number;
      
      public var mObjectBeingMovedStartY:Number;
      
      public var mMovedObjectIndicator:Sprite;
      
      public var mMapGUIEffectsLayer:MapGUIEffectsLayer;
      
      private var mObjectLoader:ObjectLoader;
      
      public var mTutorialHighlight:MovieClip;
      
      private var mMouseDisabled:Boolean = false;
      
      private var mAllowMouseX:int = -1;
      
      private var mAllowMouseY:int = -1;
      
      private var mEffectController:EffectController;
      
      private var mPatrolAppearTimer:int;
      
      private var mDebrisRandomSpawnTimer:int;
      
      public var mSoundMakers:Array;
      
      private var mSwitch:int = 0;
      
      private var mTimer:int = 0;
      
      private var mParatrooperAnimationName:String = "enemy_airdrop_01";
      
      public var mParatrooperAnimation:MovieClip = null;
      
      private var mParatrooperLocation:GridCell = null;
      
      private var mAllowedToCheckMisplacedDebris:Boolean = true;
      
      public var mSpawningBeaconObject:SpawningBeaconObject;
      
      public var mSpawningBeaconAppearTimer:int;
      
      private var mSpawningBeaconAppearTimerItem:TimerItem;
      
      public var mNeighborAvatars:Array;
      
      private var mEffectPending:Boolean;
      
      private var mEffectPendingMC:MovieClip;
      
      private var mEffectPendingType:int;
      
      private var mEffectPendingX:int;
      
      private var mEffectPendingY:int;
      
      private var mAppearTimer:Timer;
      
      private const mAppearDelayMs:int = Math.ceil(1000 / GameState.mInstance.getMainClip().stage.frameRate);
      
      private var mZoomActivated:Boolean;
      
      public var mMouseScrolling:Boolean = false;
      
      private var mMouseX:Number = 0;
      
      private var mMouseY:Number = 0;
      
      private var mMouseScrollStartX:Number = 0;
      
      private var mMouseScrollStartY:Number = 0;
      
      private var mKeyScrollStartX:Number = 0;
      
      private var mKeyScrollStartY:Number = 0;
      
      public var mAnyScrollKeyPressed:Boolean = false;
      
      public var mRightPressed:Boolean;
      
      public var mLeftPressed:Boolean;
      
      public var mDownPressed:Boolean;
      
      public var mUpPressed:Boolean;
      
      public var mFlagDrag:Boolean;
      
      public var mPlacePressed:Boolean;
      
      public var mDisabledCellsForMoving:Array;
      
      private var mTick:Number = 0;
      
      private var mRemoveCharactersArray:Array;
      
      private var mAllEnemies:Array;
      
      private var mHighlightedDebris:DebrisObject;
      
      public var mInfoBoxBG:Sprite;
      
      private var mPreviousCell:GridCell;
      
      public var mMouseLocalX:int;
      
      public var mMouseLocalY:int;
      
      private var mMouseCursorState:int;
      
      private var mPreviousCursorCell:GridCell;
      
      public var mTickCrossActive:Boolean;
      
      private var mFireItemX:int;
      
      private var mFireItemY:int;
      
      public var mAbsoluteVisibleArea:Shape;
      
      public var mRelativeVisibleArea:Shape;
      
      private var mVisibleObjects:Array;
      
      private var mSortingOrderChanged:Boolean;
      
      public function IsometricScene(param1:GameState, param2:Number, param3:Number, param4:Number)
      {
         this.mPointTmp = new Point();
         this.mPointTmp2 = new Point();
         this.mRemoveCharactersArray = new Array();
         this.mVisibleObjects = new Array();
         super();
         mouseDownAction = false;
         this.mGame = param1;
         this.mSoundMakers = new Array();
         this.mContainer = new Sprite();
         this.mGridDimX = param2;
         this.mGridDimY = param3;
         this.mGridDimZ = param4;
         this.mSwitch = 0;
         this.mTimer = 0;
         this.mZoomActivated = false;
         this.mObjectLoader = new ObjectLoader();
         this.mAllElements = new Array();
         if(FeatureTuner.USE_ZOOM_IN_OUT)
         {
            this.mContainer.addEventListener(TransformGestureEvent.GESTURE_ZOOM,this.ZoomInOut,false);
         }
         this.mContainer.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this.mContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.mContainer.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         this.mEffectController = new EffectController();
         EnvEffectManager.init();
      }
      
      private function ZoomInOut(param1:TransformGestureEvent) : void
      {
         if(this.mGame.getStageHeight() > 725)
         {
            this.mZoomActivated = true;
            this.setZoomInOut(param1.scaleX);
         }
         else
         {
            this.mContainer.removeEventListener(TransformGestureEvent.GESTURE_ZOOM,this.ZoomInOut);
         }
      }
      
      private function setZoomInOut(param1:Number) : void
      {
         if(!PopUpManager.isModalPopupActive())
         {
            if(param1 < 1)
            {
               GameState.mInstance.getHud().buttonZoomOutPressed(null);
            }
            else if(param1 > 1)
            {
               GameState.mInstance.getHud().buttonZoomInPressed(null);
            }
         }
      }
      
      public function startToolTipTimer() : void
      {
         if(this.mAppearTimer)
         {
            this.mAppearTimer.removeEventListener(TimerEvent.TIMER,this.appearTimerTick);
            this.mAppearTimer.stop();
            this.mAppearTimer = null;
         }
         this.mAppearTimer = new Timer(this.mAppearDelayMs);
         this.mAppearTimer.addEventListener(TimerEvent.TIMER,this.appearTimerTick);
         this.mAppearTimer.start();
      }
      
      public function appearTimerTick(param1:TimerEvent) : void
      {
         if(this.mAppearTimer)
         {
            if(this.mAppearTimer.currentCount > this.mAppearDelayMs)
            {
               this.mAppearTimer.removeEventListener(TimerEvent.TIMER,this.appearTimerTick);
               this.mAppearTimer.stop();
               this.mAppearTimer = null;
               this.hideObjectTooltip();
            }
         }
      }
      
      public function initTileMap() : void
      {
         var _loc2_:Item = null;
         var _loc3_:AreaItem = null;
         var _loc4_:GridCell = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         this.mTilemapGraphic = new TileMapGraphic(this);
         this.mFog = new FogOfWar(this);
         this.mMapGUIEffectsLayer = new MapGUIEffectsLayer(this);
         this.mSceneHud = new Sprite();
         this.mTilemapGraphic.updateTilemap();
         this.mTilemapGraphic.drawFog();
         var _loc1_:Array = ItemManager.getItemList();
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_ is AreaItem && AreaItem(_loc2_).mMapId == this.mGame.mCurrentMapId)
            {
               _loc3_ = _loc2_ as AreaItem;
               _loc4_ = this.getCellAt(_loc3_.mX + (_loc3_.mWidth >> 1),_loc3_.mY + (_loc3_.mHeight >> 1));
               if(this.isInsideOpenArea(_loc4_))
               {
                  if(_loc3_.mAreaLockedIcon)
                  {
                     if(_loc3_.mAreaLockedIcon.parent)
                     {
                        _loc3_.mAreaLockedIcon.parent.removeChild(_loc3_.mAreaLockedIcon);
                     }
                  }
               }
               else
               {
                  _loc7_ = 2;
                  _loc8_ = 2;
                  if(_loc3_.mId == "AreaSW")
                  {
                     _loc7_ = 3;
                  }
                  else if(_loc3_.mId == "AreaSE")
                  {
                     _loc7_ = 1;
                  }
                  else
                  {
                     _loc7_ = 2;
                     _loc8_ = 3;
                  }
                  _loc5_ = (_loc3_.mX + (_loc7_ * _loc3_.mWidth >> 2)) * this.mGridDimX;
                  _loc6_ = (_loc3_.mY + (_loc8_ * _loc3_.mHeight >> 2)) * this.mGridDimY;
                  if(!GameState.mInstance.visitingFriend())
                  {
                     _loc3_.addAreaLockedIcon(this.mSceneHud,_loc5_,_loc6_);
                  }
               }
            }
         }
      }
      
      public function initCamera() : void
      {
         this.mCamera = new IsoCamera();
         this.mCamera.setMargins(mMinAreaX,mMinAreaY,mMaxAreaX,mMaxAreaY,this.mContainer.scaleX);
      }
      
      public function reCheckCameraLimits(param1:Event = null) : void
      {
         var _loc2_:Item = null;
         mMinAreaX = Number.MAX_VALUE;
         mMinAreaY = Number.MAX_VALUE;
         mMaxAreaX = Number.MIN_VALUE;
         mMaxAreaY = Number.MIN_VALUE;
         for each(_loc2_ in ItemManager.getItemList())
         {
            if(_loc2_ is AreaItem)
            {
               (_loc2_ as AreaItem).checkLimits();
            }
         }
      }
      
      public function reCalculateCameraMargins(param1:Event = null) : void
      {
         this.mCamera.setMargins(mMinAreaX,mMinAreaY,mMaxAreaX,mMaxAreaY,this.mContainer.scaleX);
      }
      
      public function setMousePos(param1:MouseEvent) : void
      {
         this.mMouseX = param1.stageX;
         this.mMouseY = param1.stageY;
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         Config.DISABLE_SORT = true;
         if(this.mGame.resumeMusicOnMouseEvent)
         {
            this.mGame.startMusic();
            this.mGame.resumeMusicOnMouseEvent = false;
         }
         this.setMousePos(param1);
         mouseDownAction = true;
         this.mMouseCursorState = MOUSE_CURSOR_STATE_DOWN;
         this.mMouseScrollStartX = param1.stageX;
         this.mMouseScrollStartY = param1.stageY;
      }
      
      public function cancelPlaceClicked() : void
      {
         this.mGame.mHUD.cancelTools();
         this.setVisiblePlacementButton(false);
         this.mPlacePressed = false;
      }
      
      public function mouseUp(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:GridCell = null;
         this.mZoomActivated = false;
         Config.DISABLE_SORT = false;
         mouseDownAction = false;
         if(!this.mMouseScrolling)
         {
            if(this.mGame.isEditMode())
            {
               if(!this.mGame.mHUD.mBlock)
               {
                  if(this.mGame.mState == GameState.STATE_USE_INVENTORY_ITEM)
                  {
                     _loc2_ = false;
                     if(!this.mObjectBeingMoved)
                     {
                        _loc3_ = this.getTileUnderMouse();
                        if(_loc3_)
                        {
                           if(_loc3_.mObject)
                           {
                              if(_loc3_.mObject is PlayerBuildingObject)
                              {
                                 _loc2_ = (_loc3_.mObject as PlayerBuildingObject).setProductionReady();
                              }
                           }
                        }
                     }
                     else if(Boolean(this.mObjectBeingMoved) && this.isInLegalPlacementArea(this.mObjectBeingMoved))
                     {
                        this.setVisiblePlacementButton(true);
                        _loc2_ = true;
                     }
                     else if(Boolean(this.mObjectBeingMoved) && !this.isInLegalPlacementArea(this.mObjectBeingMoved))
                     {
                        this.setVisiblePlacementButton(false);
                        _loc2_ = false;
                        this.mPlacePressed = false;
                     }
                     if(_loc2_ && (this.mPlacePressed || FeatureTuner.USE_MOUSE_FOR_PLACE_ITEMS))
                     {
                        this.mGame.objectPlaced(this.mObjectBeingMoved,this.mObjectBeingMovedStartX,this.mObjectBeingMovedStartY);
                        this.mGame.inventoryItemUsed();
                        this.exitMoveMode();
                        this.setVisiblePlacementButton(false);
                     }
                  }
                  else if(this.mObjectBeingMoved)
                  {
                     if(this.isInLegalPlacementArea(this.mObjectBeingMoved))
                     {
                        this.setVisiblePlacementButton(true);
                        if(this.mGame.mState == GameState.STATE_PLACE_ITEM && this.mObjectBeingMoved.mItem is ShopItem && ShopItem(this.mObjectBeingMoved.mItem).getCostPremium() > 0)
                        {
                           if(this.mPlacePressed || FeatureTuner.USE_MOUSE_FOR_PLACE_ITEMS)
                           {
                              this.mGame.externalCallBuyItem(this.mObjectBeingMoved.mItem as ShopItem);
                           }
                        }
                        else if(this.mFlagDrag || this.mGame.mState != GameState.STATE_MOVE_ITEM)
                        {
                           if(this.mPlacePressed || FeatureTuner.USE_MOUSE_FOR_PLACE_ITEMS)
                           {
                              this.placeObjectBeingMoved();
                           }
                        }
                     }
                     else if(!this.isInLegalPlacementArea(this.mObjectBeingMoved))
                     {
                        this.mPlacePressed = false;
                        this.setVisiblePlacementButton(false);
                     }
                  }
               }
            }
         }
         this.mGame.getHud().enableMouse(true);
         this.mMouseScrolling = false;
         this.mTickCrossActive = false;
         this.mMouseCursorState = MOUSE_CURSOR_STATE_UP;
      }
      
      public function incrementViewersForPlacedObject() : void
      {
         if(this.mObjectBeingMoved is PlayerBuildingObject)
         {
            this.incrementViewersForBuilding(PlayerBuildingObject(this.mObjectBeingMoved),PlayerBuildingObject(this.mObjectBeingMoved).getSightRangeAccordingToCondition());
         }
         else if(this.mObjectBeingMoved is PlayerInstallationObject)
         {
            this.incrementViewersForInstallation(PlayerInstallationObject(this.mObjectBeingMoved),PlayerInstallationObject(this.mObjectBeingMoved).getSightRangeAccordingToCondition());
         }
         else if(this.mObjectBeingMoved is PlayerUnit)
         {
            this.mFog.incrementUnitSightArea(PlayerUnit(this.mObjectBeingMoved));
         }
      }
      
      public function placeObjectBeingMoved() : void
      {
         if(this.mObjectBeingMoved is HFEObject)
         {
            if(this.mGame.mState != GameState.STATE_MOVE_ITEM)
            {
               this.removeObject(this.mObjectBeingMoved.getCell().mObject,false,false);
            }
         }
         this.incrementViewersForPlacedObject();
         this.mGame.objectPlaced(this.mObjectBeingMoved,this.mObjectBeingMovedStartX,this.mObjectBeingMovedStartY);
         if(this.mGame.mState != GameState.STATE_PLACE_ITEM && this.mGame.mState != GameState.STATE_USE_INVENTORY_ITEM)
         {
            this.exitMoveMode();
            if(this.mGame.mState == GameState.STATE_MOVE_ITEM)
            {
               this.mMapGUIEffectsLayer.highlightMovableObjects();
            }
         }
         else
         {
            this.mMapGUIEffectsLayer.highlightPlacingArea();
         }
      }
      
      public function cancelEditMode() : void
      {
         this.mObjectBeingMoved = null;
         this.mFlagDrag = false;
         if(this.mMovedObjectIndicator)
         {
            this.mMovedObjectIndicator.graphics.clear();
            this.mMapGUIEffectsLayer.clearHighlights();
            this.mMapGUIEffectsLayer.clearMoveDisabledArea();
         }
      }
      
      public function getTilesUnderObject(param1:Renderable) : Array
      {
         var _loc2_:GridCell = this.getCellAtLocation(param1.mX,param1.mY);
         return MapArea.getArea(this,_loc2_.mPosI,_loc2_.mPosJ,param1.getTileSize().x,param1.getTileSize().y).getCells();
      }
      
      public function getTilesUnderObjectSightArea(param1:Renderable, param2:int) : Array
      {
         var _loc7_:int = 0;
         var _loc8_:GridCell = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc3_:GridCell = this.getCellAtLocation(param1.mX,param1.mY);
         var _loc4_:int = param1.getTileSize().x + param2 * 2;
         var _loc5_:int = param1.getTileSize().y + param2 * 2;
         var _loc6_:Array = MapArea.getArea(this,_loc3_.mPosI - param2,_loc3_.mPosJ - param2,_loc4_,_loc5_).getCells();
         if(param2 > 0)
         {
            _loc4_ = param1.getTileSize().x;
            _loc5_ = param1.getTileSize().y;
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               _loc8_ = _loc6_[_loc7_];
               _loc9_ = 0;
               _loc10_ = 0;
               if(_loc8_.mPosI < _loc3_.mPosI)
               {
                  _loc9_ = _loc8_.mPosI - _loc3_.mPosI;
               }
               else if(_loc8_.mPosI >= _loc3_.mPosI + _loc4_)
               {
                  _loc9_ = _loc8_.mPosI - (_loc3_.mPosI + _loc4_ - 1);
               }
               if(_loc8_.mPosJ < _loc3_.mPosJ)
               {
                  _loc10_ = _loc8_.mPosJ - _loc3_.mPosJ;
               }
               else if(_loc8_.mPosJ >= _loc3_.mPosJ + _loc5_)
               {
                  _loc10_ = _loc8_.mPosJ - (_loc3_.mPosJ + _loc5_ - 1);
               }
               if(Math.sqrt(_loc9_ * _loc9_ + _loc10_ * _loc10_) - 0.5 > param2)
               {
                  _loc6_.splice(_loc7_,1);
                  _loc7_--;
               }
               _loc7_++;
            }
         }
         return _loc6_;
      }
      
      private function isInLegalPlacementArea(param1:Renderable) : Boolean
      {
         var _loc3_:GridCell = null;
         var _loc6_:GridCell = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Array = this.getTilesUnderObject(param1);
         var _loc4_:int = int(_loc2_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _loc2_[_loc5_] as GridCell;
            _loc7_ = int(this.mDisabledCellsForMoving.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc6_ = this.mDisabledCellsForMoving[_loc8_] as GridCell;
               if(_loc3_ == _loc6_)
               {
                  return false;
               }
               _loc8_++;
            }
            if(_loc3_.mCharacter != null)
            {
               if(_loc3_.mCharacter != param1)
               {
                  return false;
               }
            }
            if(!param1.isPlaceableOnAllTiles())
            {
               if(_loc3_.mOwner != MapData.TILE_OWNER_FRIENDLY)
               {
                  return false;
               }
            }
            if(param1 is HFEObject)
            {
               if(this.mGame.mState == GameState.STATE_MOVE_ITEM)
               {
                  if(_loc3_.mObject != null)
                  {
                     if(_loc3_.mObject != param1)
                     {
                        return false;
                     }
                  }
               }
               else if(_loc3_.mObject == null || !(_loc3_.mObject is HFEPlotObject))
               {
                  return false;
               }
            }
            if(!(param1 is HFEObject))
            {
               if(_loc3_.mObject != null)
               {
                  if(_loc3_.mObject != param1)
                  {
                     return false;
                  }
               }
            }
            _loc5_++;
         }
         return true;
      }
      
      private function isObjectInLegalPosition(param1:Renderable) : Boolean
      {
         var _loc2_:GridCell = this.getCellAtLocation(param1.mX,param1.mY);
         if(!_loc2_)
         {
            return false;
         }
         return !this.willIntesectWithObjectAtTile(_loc2_.mPosI,_loc2_.mPosJ,param1.getTileSize().x,param1.getTileSize().y,param1);
      }
      
      private function willIntesectWithObjectAtTile(param1:int, param2:int, param3:int, param4:int, param5:Renderable) : Boolean
      {
         var _loc6_:Element = null;
         var _loc9_:Renderable = null;
         var _loc10_:Vector3D = null;
         var _loc11_:GridCell = null;
         var _loc7_:int = int(this.mAllElements.length);
         var _loc8_:int = 0;
         for(; _loc8_ < _loc7_; _loc8_++)
         {
            if(_loc9_ = (_loc6_ = this.mAllElements[_loc8_] as Element) as Renderable)
            {
               if(_loc9_ != param5)
               {
                  if(_loc9_ is PlayerUnit)
                  {
                     if(param5.isWalkable())
                     {
                        continue;
                     }
                  }
                  _loc10_ = _loc9_.getTileSize();
                  _loc11_ = this.getCellAtLocation(_loc9_.mX,_loc9_.mY);
                  if(param1 + param3 - 1 >= _loc11_.mPosI)
                  {
                     if(param1 < _loc11_.mPosI + _loc10_.x)
                     {
                        if(param2 + param4 - 1 >= _loc11_.mPosJ)
                        {
                           if(param2 < _loc11_.mPosJ + _loc10_.y)
                           {
                              return true;
                           }
                        }
                     }
                  }
               }
            }
         }
         return false;
      }
      
      public function updateBorderTiles() : void
      {
         var _loc2_:int = 0;
         var _loc3_:GridCell = null;
         var _loc4_:* = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.mSizeX)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mSizeY)
            {
               _loc3_ = this.getCellAt(_loc1_,_loc2_);
               _loc3_.mCloudBits = TileMapGraphic.CLOUD_BIT_NONE;
               if(!this.isInsideOpenArea(_loc3_))
               {
                  _loc4_ = TileMapGraphic.CLOUD_BIT_FULL;
                  if(this.isInsideOpenArea(this.getCellAt(_loc1_ + 1,_loc2_)))
                  {
                     _loc4_ |= TileMapGraphic.CLOUD_BIT_RIGHT;
                  }
                  if(this.isInsideOpenArea(this.getCellAt(_loc1_ - 1,_loc2_)))
                  {
                     _loc4_ |= TileMapGraphic.CLOUD_BIT_LEFT;
                  }
                  if(this.isInsideOpenArea(this.getCellAt(_loc1_,_loc2_ + 1)))
                  {
                     _loc4_ |= TileMapGraphic.CLOUD_BIT_BOTTOM;
                  }
                  if(this.isInsideOpenArea(this.getCellAt(_loc1_,_loc2_ - 1)))
                  {
                     _loc4_ |= TileMapGraphic.CLOUD_BIT_TOP;
                  }
                  if(_loc4_ == 0)
                  {
                     if(this.isInsideOpenArea(this.getCellAt(_loc1_ - 1,_loc2_ - 1)))
                     {
                        _loc4_ = TileMapGraphic.CLOUD_BIT_BR;
                     }
                     else if(this.isInsideOpenArea(this.getCellAt(_loc1_ + 1,_loc2_ - 1)))
                     {
                        _loc4_ = TileMapGraphic.CLOUD_BIT_BL;
                     }
                     else if(this.isInsideOpenArea(this.getCellAt(_loc1_ - 1,_loc2_ + 1)))
                     {
                        _loc4_ = TileMapGraphic.CLOUD_BIT_TR;
                     }
                     else if(this.isInsideOpenArea(this.getCellAt(_loc1_ + 1,_loc2_ + 1)))
                     {
                        _loc4_ = TileMapGraphic.CLOUD_BIT_TL;
                     }
                  }
                  else if(Boolean(_loc4_ & TileMapGraphic.CLOUD_BIT_BOTTOM) && Boolean(_loc4_ & TileMapGraphic.CLOUD_BIT_RIGHT))
                  {
                     _loc4_ = TileMapGraphic.CLOUD_BIT_CONVEX_BR;
                  }
                  else if(Boolean(_loc4_ & TileMapGraphic.CLOUD_BIT_BOTTOM) && Boolean(_loc4_ & TileMapGraphic.CLOUD_BIT_LEFT))
                  {
                     _loc4_ = TileMapGraphic.CLOUD_BIT_CONVEX_BL;
                  }
                  else if(Boolean(_loc4_ & TileMapGraphic.CLOUD_BIT_TOP) && Boolean(_loc4_ & TileMapGraphic.CLOUD_BIT_RIGHT))
                  {
                     _loc4_ = TileMapGraphic.CLOUD_BIT_CONVEX_TR;
                  }
                  else if(Boolean(_loc4_ & TileMapGraphic.CLOUD_BIT_TOP) && Boolean(_loc4_ & TileMapGraphic.CLOUD_BIT_LEFT))
                  {
                     _loc4_ = TileMapGraphic.CLOUD_BIT_CONVEX_TL;
                  }
                  _loc3_.mCloudBits = _loc4_;
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function isInsideOpenArea(param1:GridCell) : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:AreaItem = null;
         if(GameState.mInstance.visitingTutor() || GameState.mInstance.mState == GameState.STATE_PVP)
         {
            return true;
         }
         if(param1)
         {
            _loc2_ = this.mGame.mPlayerProfile.mInventory.getAreas();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if((_loc4_ = _loc2_[_loc3_] as AreaItem).mMapId == this.mGame.mCurrentMapId)
               {
                  if(_loc4_.mAreaLockedIcon)
                  {
                     _loc4_.mAreaLockedIcon.visible = false;
                     _loc4_.mAreaLockedIcon.parent.removeChild(_loc4_.mAreaLockedIcon);
                     _loc4_.mAreaLockedIcon = null;
                  }
                  if(param1.mPosI >= _loc4_.mX)
                  {
                     if(param1.mPosI < _loc4_.mRightX)
                     {
                        if(param1.mPosJ >= _loc4_.mY)
                        {
                           if(param1.mPosJ < _loc4_.mBottomY)
                           {
                              return true;
                           }
                        }
                     }
                  }
               }
               _loc3_ += 2;
            }
         }
         return false;
      }
      
      public function getContainingArea(param1:GridCell) : AreaItem
      {
         var _loc2_:Object = null;
         for each(_loc2_ in ItemManager.getItemList())
         {
            if(_loc2_ is AreaItem)
            {
               if(param1.mPosI >= _loc2_.mX)
               {
                  if(param1.mPosI < _loc2_.mRightX)
                  {
                     if(param1.mPosJ >= _loc2_.mY)
                     {
                        if(param1.mPosJ < _loc2_.mBottomY)
                        {
                           return _loc2_ as AreaItem;
                        }
                     }
                  }
               }
            }
         }
         return null;
      }
      
      public function isAreaReachable(param1:AreaItem) : Boolean
      {
         var _loc2_:GridCell = null;
         _loc2_ = this.getCellAt(param1.mX,param1.mY - 1);
         if(this.isInsideOpenArea(_loc2_))
         {
            return true;
         }
         _loc2_ = this.getCellAt(param1.mX,param1.mY + param1.mHeight);
         if(this.isInsideOpenArea(_loc2_))
         {
            return true;
         }
         _loc2_ = this.getCellAt(param1.mX - 1,param1.mY);
         if(this.isInsideOpenArea(_loc2_))
         {
            return true;
         }
         _loc2_ = this.getCellAt(param1.mX + param1.mWidth,param1.mY);
         if(this.isInsideOpenArea(_loc2_))
         {
            return true;
         }
         return false;
      }
      
      public function isInsideVisibleArea(param1:GridCell) : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:AreaItem = null;
         if(GameState.mInstance.visitingTutor() || GameState.mInstance.mState == GameState.STATE_PVP)
         {
            return true;
         }
         if(param1)
         {
            _loc2_ = this.mGame.mPlayerProfile.mInventory.getAreas(true);
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_] as AreaItem;
               if(param1.mPosI >= _loc4_.mX - 1)
               {
                  if(param1.mPosI < _loc4_.mRightX + 1)
                  {
                     if(param1.mPosJ >= _loc4_.mY - 1)
                     {
                        if(param1.mPosJ < _loc4_.mBottomY + 1)
                        {
                           return true;
                        }
                     }
                  }
               }
               _loc3_ += 2;
            }
         }
         return false;
      }
      
      public function isUnderCloudBorder(param1:GridCell) : Boolean
      {
         var _loc2_:MapArea = null;
         var _loc3_:Array = null;
         var _loc4_:GridCell = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(GameState.mInstance.visitingTutor() || GameState.mInstance.mState == GameState.STATE_PVP)
         {
            return true;
         }
         if(param1)
         {
            if(!this.isInsideVisibleArea(param1))
            {
               _loc2_ = MapArea.getAreaAroundCell(this,param1,1);
               _loc3_ = _loc2_.getCells();
               _loc5_ = int(_loc3_.length);
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc4_ = _loc3_[_loc6_] as GridCell;
                  if(this.isInsideVisibleArea(_loc4_))
                  {
                     return true;
                  }
                  _loc6_++;
               }
            }
         }
         return false;
      }
      
      public function getEnabledCellsForMovingObject() : Array
      {
         var _loc2_:Array = null;
         var _loc3_:GridCell = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Array = new Array();
         if(this.mObjectBeingMoved)
         {
            _loc2_ = this.mGame.mMapData.mGrid;
            this.mDisabledCellsForMoving = new Array();
            _loc4_ = int(_loc2_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = _loc2_[_loc5_] as GridCell;
               if(this.isCellEnableForMovingObject(_loc3_,false))
               {
                  _loc1_.push(_loc3_);
               }
               _loc5_++;
            }
         }
         return _loc1_;
      }
      
      public function getMovableObjects() : Array
      {
         var _loc2_:Boolean = false;
         var _loc3_:Renderable = null;
         var _loc1_:Array = new Array();
         var _loc4_:int = int(this.mAllElements.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this.mAllElements[_loc5_] as Renderable;
            if(_loc3_.isMovable())
            {
               _loc1_.push(_loc3_);
            }
            _loc5_++;
         }
         return _loc1_;
      }
      
      public function getSellableObjects() : Array
      {
         var _loc2_:Boolean = false;
         var _loc3_:Renderable = null;
         var _loc1_:Array = new Array();
         var _loc4_:int = int(this.mAllElements.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this.mAllElements[_loc5_] as Renderable;
            if(this.isCellEnableForSellObject(_loc3_.getCell()))
            {
               _loc1_.push(_loc3_);
            }
            _loc5_++;
         }
         return _loc1_;
      }
      
      private function isCellEnableForMovingObject(mainCell:GridCell, param2:Boolean) : Boolean
      {
         var iteratorY:int = 0;
         var iteratorX:int = 0;
         var nextCell:GridCell = null;
         var isEnabled:Boolean = false;
         if(mainCell && (mainCell.mOwner == MapData.TILE_OWNER_FRIENDLY || this.mObjectBeingMoved && this.mObjectBeingMoved.isPlaceableOnAllTiles()) && (mainCell.mCharacter == null || mainCell.mCharacter == this.mObjectBeingMoved) && (mainCell.mObject == null || mainCell.mObject == this.mObjectBeingMoved || (this.mGame.mState == GameState.STATE_PLACE_ITEM || this.mGame.mState == GameState.STATE_USE_INVENTORY_ITEM) && this.mObjectBeingMoved is HFEObject))
         {
            if(this.mGame.mState == GameState.STATE_PLACE_ITEM && this.mObjectBeingMoved is HFEObject && !(mainCell.mObject is HFEPlotObject))
            {
               isEnabled = false;
            }
            else if(this.mGame.mState == GameState.STATE_USE_INVENTORY_ITEM && this.mObjectBeingMoved is HFEObject && !(mainCell.mObject is HFEPlotObject))
            {
               isEnabled = false;
            }
            else
            {
               isEnabled = true;
            }
            if(isEnabled)
            {
               if(this.mObjectBeingMoved)
               {
                  if(!this.mObjectBeingMoved.isPlaceableOnAllTiles())
                  {
                     iteratorY = -1;
                     while(iteratorY <= 1)
                     {
                        iteratorX = -1;
                        while(iteratorX <= 1)
                        {
                           if(nextCell = this.getCellAt(mainCell.mPosI + iteratorY,mainCell.mPosJ + iteratorX))
                           {
                              if(nextCell.mCharacter && nextCell.mCharacter is EnemyUnit || nextCell.mObject && nextCell.mObject is EnemyInstallationObject && (nextCell.mObject as EnemyInstallationObject).canAttack())
                              {
                                 isEnabled = false;
                                 this.mDisabledCellsForMoving.push(mainCell);
                                 break;
                              }
                           }
                           iteratorX++;
                        }
                        if(!isEnabled)
                        {
                           break;
                        }
                        iteratorY++;
                     }
                  }
               }
            }
         }
         var dimX:int = this.mObjectBeingMoved.getTileSize().x;
         var dimInteratorX:int = 0;
         var dimInteratorY:int = 0;
         var occupiedCells:Array = null;
         var isAllowed:Boolean = false;
         var nextOccupiedCell:GridCell = null;
         var occupiedCellsCount:int = 0;
         var occupiedCellIndex:int = 0;
         if(!param2)
         {
            if(isEnabled)
            {
               if(dimX > 1)
               {
                  dimInteratorX = -(dimX - 1);
                  if(dimInteratorX > 0)
                  {
                     return false;
                  }
                  dimInteratorY = -(dimX - 1);
                  while(false)
                  {
                     if(dimInteratorY > 0)
                     {
                        dimInteratorX++;
                     }
                     else
                     {
                        nextCell = this.getCellAt(mainCell.mPosI + dimInteratorY,mainCell.mPosJ + dimInteratorX);
                        if(nextCell)
                        {
                           occupiedCells = MapArea.getArea(this,nextCell.mPosI,nextCell.mPosJ,dimX,dimX).getCells();
                           isAllowed = true;
                           occupiedCellsCount = int(occupiedCells.length);
                           occupiedCellIndex = 0;
                           while(occupiedCellIndex < occupiedCellsCount)
                           {
                              nextOccupiedCell = occupiedCells[occupiedCellIndex] as GridCell;
                              if(!this.isCellEnableForMovingObject(nextOccupiedCell,true))
                              {
                                 isAllowed = false;
                                 break;
                              }
                              occupiedCellIndex++;
                           }
                           if(isAllowed)
                           {
                              break;
                           }
                        }
                        dimInteratorY++;
                     }
                  }
                  return true;
               }
            }
         }
         return isEnabled;
      }
      
      public function getEnabledCellsForPickupUnit() : Array
      {
         var _loc3_:GridCell = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = this.mGame.mMapData.mGrid;
         var _loc4_:int = int(_loc2_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _loc2_[_loc5_] as GridCell;
            if(this.isCellEnableForPickupUnit(_loc3_))
            {
               _loc1_.push(_loc3_);
            }
            _loc5_++;
         }
         return _loc1_;
      }
      
      public function getEnabledCellsForRepairObject() : Array
      {
         var _loc3_:GridCell = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = this.mGame.mMapData.mGrid;
         var _loc4_:int = int(_loc2_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = _loc2_[_loc5_] as GridCell;
            if(this.isCellEnableForRepairObject(_loc3_))
            {
               _loc1_.push(_loc3_);
            }
            _loc5_++;
         }
         return _loc1_;
      }
      
      private function isCellEnableForPickupUnit(param1:GridCell) : Boolean
      {
         if(param1.mCharacter)
         {
            if(param1.mCharacter is PlayerUnit)
            {
               if(param1.mCharacter.isFullHealth())
               {
                  if(this.mGame.mPlayerProfile.mSupplies >= PlayerUnitItem(param1.mCharacter.mItem).mPickupCostSupplies)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      private function isCellEnableForRepairObject(param1:GridCell) : Boolean
      {
         if(param1.mCharacter && param1.mCharacter is PlayerUnit && !param1.mCharacter.isFullHealth())
         {
            return true;
         }
         if(Boolean(param1.mObject) && (param1.mObject is PlayerBuildingObject && PlayerBuildingObject(param1.mObject).isRepairable() || param1.mObject is PlayerInstallationObject && !PlayerInstallationObject(param1.mObject).isFullHealth()))
         {
            return true;
         }
         return false;
      }
      
      private function isCellEnableForSellObject(param1:GridCell) : Boolean
      {
         if(Boolean(param1.mCharacter) && param1.mCharacter is PlayerUnit)
         {
            return true;
         }
         if(Boolean(param1.mObject) && (param1.mObject is ConstructionObject || param1.mObject is DecorationObject || param1.mObject is PlayerInstallationObject || param1.mObject is HFEObject || param1.mObject is HFEPlotObject || param1.mObject is ResourceBuildingObject))
         {
            return true;
         }
         return false;
      }
      
      private function isCellEnableForRedeploying(param1:GridCell) : Boolean
      {
         var _loc2_:PlayerUnit = null;
         if(param1.mCharacter)
         {
            if(param1.mCharacter is PlayerUnit)
            {
               _loc2_ = param1.mCharacter as PlayerUnit;
               return _loc2_.isFullHealth() && this.mGame.mPlayerProfile.mSupplies >= PlayerUnitItem(_loc2_.mItem).mPickupCostSupplies;
            }
         }
         return false;
      }
      
      private function mouseOut(param1:MouseEvent) : void
      {
         this.mGame.getHud().enableMouse(true);
      }
      
      private function mouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         Config.DISABLE_SORT = true;
         if(!MissionManager.isTutorialCompleted() || this.mZoomActivated)
         {
            return;
         }
         if(param1.buttonDown)
         {
            _loc2_ = param1.stageX - this.mMouseX;
            _loc3_ = param1.stageY - this.mMouseY;
            _loc4_ = Math.abs(_loc2_) + Math.abs(_loc3_);
            if(!this.mMouseScrolling)
            {
               if(_loc4_ > 5)
               {
                  this.mMouseScrolling = true;
                  this.mGame.getHud().enableMouse(false);
                  this.setMousePos(param1);
               }
            }
         }
         else
         {
            this.mMouseScrolling = false;
         }
         if(this.mMouseScrolling)
         {
            _loc2_ = param1.stageX - this.mMouseX;
            _loc3_ = param1.stageY - this.mMouseY;
            _loc2_ /= this.mContainer.scaleX;
            _loc3_ /= this.mContainer.scaleY;
            this.mCamera.moveTo(-_loc2_ + this.mCamera.getCameraX(),-_loc3_ + this.mCamera.getCameraY());
            this.setMousePos(param1);
         }
      }
      
      public function addFloor(param1:Floor) : void
      {
         this.mFloor = param1;
      }
      
      public function addObject(param1:Element) : void
      {
         this.mAllElements.push(param1);
         var _loc2_:Renderable = param1 as Renderable;
         if(_loc2_)
         {
            if(!this.isObjectInLegalPosition(_loc2_))
            {
               Utils.LogError("Overlapping objects");
            }
            if(_loc2_.getContainer() != null)
            {
               if(_loc2_.getTileSize().z == 0)
               {
                  this.mContainer.addChildAt(_loc2_.getContainer(),0);
               }
               else
               {
                  this.mContainer.addChild(_loc2_.getContainer());
               }
            }
            _loc2_.addListenerObjectMouseReleased(this.FloorClicked);
         }
      }
      
      private function updateStaticObjects(param1:int) : void
      {
         var _loc2_:Element = null;
         var _loc3_:StaticObject = null;
         var _loc4_:Boolean = false;
         var _loc5_:EnemyInstallationObject = null;
         var _loc6_:PlayerInstallationObject = null;
         var _loc7_:StaticObject = null;
         mRemoveArray.length = 0;
         this.mSceneActive = false;
         if(this.mInfoBoxBG)
         {
            this.mInfoBoxBG.visible = false;
         }
         for each(_loc2_ in this.mAllElements)
         {
            _loc3_ = _loc2_ as StaticObject;
            if(_loc3_)
            {
               _loc4_ = _loc3_.logicUpdate(param1);
               if(_loc3_ is EnemyInstallationObject)
               {
                  (_loc5_ = _loc3_ as EnemyInstallationObject).updateActions(param1);
               }
               if(_loc3_ is PlayerInstallationObject)
               {
                  (_loc6_ = _loc3_ as PlayerInstallationObject).updateActions(param1);
               }
               if(_loc4_)
               {
                  mRemoveArray.push(_loc3_);
               }
            }
         }
         if(mRemoveArray.length > 0)
         {
            for each(_loc7_ in mRemoveArray)
            {
               this.removeObject(_loc7_,true);
            }
            this.updateGridInformation();
            this.updateGridCharacterInfo();
            if(this.mGame.mState != GameState.STATE_VISITING_NEIGHBOUR)
            {
               this.mGame.updateWalkableCellsForActiveCharacter();
            }
         }
      }
      
      private function updateCharacters(param1:int) : void
      {
         var _loc3_:Element = null;
         var _loc6_:IsometricCharacter = null;
         var _loc7_:IsometricCharacter = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         this.mRemoveCharactersArray.length = 0;
         var _loc2_:Boolean = false;
         this.mTick += param1;
         if(this.mTick > 1000)
         {
            _loc2_ = true;
            this.mTick -= 1000;
         }
         if(this.mInfoBoxBG)
         {
            this.mInfoBoxBG.visible = false;
         }
         var _loc4_:int = int(this.mAllElements.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this.mAllElements[_loc5_] as Element;
            if(_loc3_ is IsometricCharacter)
            {
               (_loc6_ = _loc3_ as IsometricCharacter).update(param1);
               if(_loc6_.isReadyToBeRemoved())
               {
                  this.mRemoveCharactersArray.push(_loc6_);
               }
               else
               {
                  _loc6_.updateActions(param1);
                  _loc6_.updateMovement(param1);
               }
            }
            _loc5_++;
         }
         if(this.mRemoveCharactersArray.length > 0)
         {
            _loc8_ = int(this.mRemoveCharactersArray.length);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc7_ = this.mRemoveCharactersArray[_loc9_] as IsometricCharacter;
               this.removeObject(_loc7_,false);
               if(_loc7_ is PlayerUnit)
               {
                  if(this.mGame.mState != GameState.STATE_PVP)
                  {
                     this.mGame.mHUD.openUnitDiedTextBox();
                     this.mGame.mPlayerProfile.updateUnitCaps();
                     this.mGame.mPlayerProfile.removeUnit((_loc7_ as PlayerUnit).mItem as PlayerUnitItem);
                  }
               }
               _loc9_++;
            }
            this.updateGridInformation();
            this.updateGridCharacterInfo();
            if(this.mGame.mState != GameState.STATE_VISITING_NEIGHBOUR)
            {
               this.mGame.updateWalkableCellsForActiveCharacter();
            }
         }
      }
      
      public function startCharacterAnimations() : void
      {
         var _loc1_:Element = null;
         var _loc4_:IsometricCharacter = null;
         var _loc2_:int = int(this.mAllElements.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mAllElements[_loc3_] as Element;
            if(_loc1_ is IsometricCharacter)
            {
               (_loc4_ = _loc1_ as IsometricCharacter).startAction();
            }
            _loc3_++;
         }
      }
      
      public function stopCharacterAnimations() : void
      {
         var _loc1_:Element = null;
         var _loc4_:IsometricCharacter = null;
         var _loc2_:int = int(this.mAllElements.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mAllElements[_loc3_] as Element;
            if(_loc1_ is IsometricCharacter)
            {
               (_loc4_ = _loc1_ as IsometricCharacter).stopAction();
            }
            _loc3_++;
         }
      }
      
      public function getEnemyUnits() : Array
      {
         var _loc2_:Element = null;
         var _loc5_:EnemyUnit = null;
         var _loc1_:Array = new Array();
         var _loc3_:int = int(this.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mAllElements[_loc4_] as Element;
            if(_loc2_ is EnemyUnit)
            {
               _loc5_ = _loc2_ as EnemyUnit;
               _loc1_.push(_loc5_);
            }
            else if(_loc2_ is PvPEnemyUnit)
            {
               _loc1_.push(_loc2_ as PvPEnemyUnit);
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getPvPEnemyAliveUnits() : Array
      {
         var _loc2_:Element = null;
         var _loc1_:Array = new Array();
         var _loc3_:int = int(this.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mAllElements[_loc4_] as Element;
            if(_loc2_ is PvPEnemyUnit)
            {
               if((_loc2_ as PvPEnemyUnit).getHealth() > 0)
               {
                  _loc1_.push(_loc2_ as PvPEnemyUnit);
               }
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getNumberOfEnemiesReadyToAct() : int
      {
         var _loc2_:Element = null;
         var _loc5_:EnemyUnit = null;
         var _loc1_:int = 0;
         var _loc3_:int = int(this.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mAllElements[_loc4_] as Element;
            if(_loc2_ is EnemyUnit)
            {
               if((_loc5_ = _loc2_ as EnemyUnit).mVisible)
               {
                  if(_loc5_.mRemainingTimeToNextAction == 0)
                  {
                     _loc1_++;
                  }
               }
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getEnemyInstallations() : Array
      {
         var _loc2_:Element = null;
         var _loc1_:Array = new Array();
         var _loc3_:int = int(this.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mAllElements[_loc4_] as Element;
            if(_loc2_ is EnemyInstallationObject)
            {
               _loc1_.push(_loc2_ as EnemyInstallationObject);
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getAllEnemies() : Array
      {
         var _loc1_:Element = null;
         if(this.mAllEnemies == null)
         {
            this.mAllEnemies = new Array();
         }
         this.mAllEnemies.splice(0,this.mAllEnemies.length);
         var _loc2_:int = int(this.mAllElements.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mAllElements[_loc3_] as Element;
            if(_loc1_ is EnemyUnit)
            {
               this.mAllEnemies.push(_loc1_ as EnemyUnit);
            }
            else if(_loc1_ is EnemyInstallationObject)
            {
               this.mAllEnemies.push(_loc1_ as EnemyInstallationObject);
            }
            else if(_loc1_ is PvPEnemyUnit)
            {
               this.mAllEnemies.push(_loc1_ as PvPEnemyUnit);
            }
            _loc3_++;
         }
         return this.mAllEnemies;
      }
      
      public function getNextEnemyUnitActionQueueNumber() : int
      {
         var _loc4_:Renderable = null;
         var _loc7_:EnemyUnit = null;
         var _loc1_:int = 1;
         var _loc2_:int = int(GameState.mConfig.EnemySetup.MovementCounterInterval.Value);
         var _loc3_:Array = this.getAllEnemies();
         var _loc5_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if((_loc4_ = _loc3_[_loc6_] as Renderable) is EnemyUnit)
            {
               if((_loc7_ = _loc4_ as EnemyUnit).getReactionState() == EnemyUnit.REACT_STATE_WAIT_FOR_ORDERS)
               {
                  if(_loc7_.mReactionStateCounter >= _loc1_)
                  {
                     _loc1_ = _loc7_.mReactionStateCounter + _loc2_;
                  }
               }
            }
            _loc6_++;
         }
         return _loc1_;
      }
      
      public function setPremiumEnemyUnitActionQueueNumber(param1:EnemyUnit) : void
      {
         var _loc6_:EnemyUnit = null;
         var _loc2_:int = 1;
         var _loc3_:int = 4;
         var _loc4_:Array = this.getEnemyUnits();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if((_loc6_ = _loc4_[_loc5_] as EnemyUnit) != param1)
            {
               if(_loc6_.getReactionState() == EnemyUnit.REACT_STATE_WAIT_FOR_ORDERS)
               {
                  if(_loc2_ == _loc3_)
                  {
                     if(_loc6_.mReactionStateCounter >= _loc2_)
                     {
                        ++_loc6_.mReactionStateCounter;
                     }
                  }
                  else if(_loc6_.mReactionStateCounter == _loc2_)
                  {
                     _loc2_++;
                     _loc4_.splice(_loc5_,1);
                     _loc5_ = -1;
                     if(_loc2_ >= param1.mReactionStateCounter)
                     {
                        break;
                     }
                  }
               }
            }
            _loc5_++;
         }
         if(_loc2_ < param1.mReactionStateCounter)
         {
            param1.mReactionStateCounter = _loc2_;
         }
      }
      
      public function reduceEnemyUnitQueueNumber() : void
      {
         var _loc2_:EnemyUnit = null;
         var _loc1_:Array = this.getEnemyUnits();
         var _loc3_:int = int(_loc1_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _loc1_[_loc4_] as EnemyUnit;
            if(_loc2_.getReactionState() == EnemyUnit.REACT_STATE_WAIT_FOR_ORDERS)
            {
               --_loc2_.mReactionStateCounter;
            }
            _loc4_++;
         }
      }
      
      private function launchParatrooperAirplane(param1:GridCell) : void
      {
         var _loc4_:String = null;
         var _loc2_:DCResourceManager = DCResourceManager.getInstance();
         var _loc3_:String = Config.SWF_EFFECTS_NAME;
         this.mParatrooperLocation = param1;
         if(_loc2_.isLoaded(_loc3_))
         {
            this.addParatrooperAnimaion();
         }
         else
         {
            _loc4_ = _loc3_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
            _loc2_.addEventListener(_loc4_,this.paratroopAnimationLoaded,false,0,true);
            if(!_loc2_.isAddedToLoadingList(_loc3_))
            {
               _loc2_.load(Config.DIR_DATA + _loc3_ + ".swf",_loc3_,null,false);
            }
         }
      }
      
      private function paratroopAnimationLoaded(param1:Event) : void
      {
         DCResourceManager.getInstance().removeEventListener(param1.type,this.paratroopAnimationLoaded);
         this.addParatrooperAnimaion();
      }
      
      private function addParatrooperAnimaion() : void
      {
         var _loc1_:Class = null;
         if(this.mParatrooperLocation)
         {
            _loc1_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_EFFECTS_NAME,this.mParatrooperAnimationName);
            this.mParatrooperAnimation = new _loc1_();
            this.mParatrooperAnimation.addEventListener(Event.ENTER_FRAME,this.checkParatrooperFrame);
            this.mParatrooperAnimation.x = this.getCenterPointXOfCell(this.mParatrooperLocation);
            this.mParatrooperAnimation.y = this.getCenterPointYOfCell(this.mParatrooperLocation);
            this.mParatrooperAnimation.mouseChildren = false;
            this.mParatrooperAnimation.mouseEnabled = false;
            this.mSceneHud.addChild(this.mParatrooperAnimation);
            this.mParatrooperLocation = null;
         }
      }
      
      private function checkParatrooperFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = (param1.target as MovieClip).getChildAt(0) as MovieClip;
         if(_loc2_.totalFrames == _loc2_.currentFrame)
         {
            if(this.mParatrooperAnimation)
            {
               this.mParatrooperAnimation.removeEventListener(Event.ENTER_FRAME,this.checkParatrooperFrame);
               this.mParatrooperAnimation.stop();
               if(this.mParatrooperAnimation.parent)
               {
                  this.mParatrooperAnimation.parent.removeChild(this.mParatrooperAnimation);
               }
               this.mParatrooperAnimation = null;
            }
         }
      }
      
      private function updateBeaconSpawnerAppearing(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:GridCell = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:EnemyInstallationItem = null;
         var _loc8_:GridCell = null;
         if(!this.mSpawningBeaconAppearTimerItem)
         {
            this.mSpawningBeaconAppearTimerItem = ItemManager.getItemByTableName("EnemySmokeTimer","Timers") as TimerItem;
            _loc2_ = int(GameState.mInstance.mTimers[this.mSpawningBeaconAppearTimerItem.mId]);
            if(_loc2_ == -1)
            {
               this.resetSpawningBeaconTimer();
               this.mSpawningBeaconAppearTimer = this.mSpawningBeaconAppearTimerItem.mDuration * MINUTE_MS;
            }
            else
            {
               this.mSpawningBeaconAppearTimer = _loc2_;
            }
         }
         if(this.mSpawningBeaconObject || this.mGame.mState == GameState.STATE_VISITING_NEIGHBOUR || this.mGame.mState == GameState.STATE_PVP || this.mGame.mCurrentMapId != "Home" || !MissionManager.isSpawnBeaconMissionCompleted())
         {
            return;
         }
         this.mSpawningBeaconAppearTimer += param1;
         if(this.mSpawningBeaconAppearTimer / MINUTE_MS >= this.mSpawningBeaconAppearTimerItem.mDuration)
         {
            if(this.mSpawningBeaconAppearTimerItem.mProbability > Math.random() * 100)
            {
               _loc3_ = new Array();
               _loc5_ = int(this.mGame.mMapData.mGrid.length);
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  if((_loc4_ = this.mGame.mMapData.mGrid[_loc6_] as GridCell).mOwner == MapData.TILE_OWNER_FRIENDLY)
                  {
                     if(!_loc4_.mObject)
                     {
                        if(!_loc4_.mCharacter)
                        {
                           if(!_loc4_.mCharacterComingToThisTile)
                           {
                              if(this.isInsideOpenArea(_loc4_))
                              {
                                 _loc3_.push(_loc4_);
                              }
                           }
                        }
                     }
                  }
                  _loc6_++;
               }
               if(_loc3_.length > 0)
               {
                  _loc7_ = ItemManager.getItem("EnemySmokeSignal","SpawningBeacon") as EnemyInstallationItem;
                  _loc8_ = _loc3_[int(Math.random() * _loc3_.length)];
                  this.createSpawningBeacon(_loc7_,_loc8_);
               }
            }
            else
            {
               this.resetSpawningBeaconTimer();
            }
         }
      }
      
      public function resetSpawningBeaconTimer() : void
      {
         var _loc1_:Object = null;
         if(this.mGame.mState != GameState.STATE_PVP && this.mGame.mState != GameState.STATE_VISITING_NEIGHBOUR)
         {
            this.mSpawningBeaconAppearTimer = 0;
            _loc1_ = {
               "timer_name":this.mSpawningBeaconAppearTimerItem.mId,
               "timer_duration":this.mSpawningBeaconAppearTimerItem.mDuration * MINUTE_MS
            };
            this.mGame.mServer.serverCallServiceWithParameters(ServiceIDs.START_TIMER,_loc1_,false);
         }
      }
      
      public function findSpawningBeacon() : void
      {
         var _loc1_:Renderable = null;
         this.mSpawningBeaconObject = null;
         var _loc2_:int = int(this.mAllElements.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mAllElements[_loc3_] as Renderable;
            if(_loc1_ is SpawningBeaconObject)
            {
               this.mSpawningBeaconObject = _loc1_ as SpawningBeaconObject;
               return;
            }
            _loc3_++;
         }
      }
      
      private function createSpawningBeacon(param1:EnemyInstallationItem, param2:GridCell) : void
      {
         var _loc3_:Object = null;
         if(!this.mSpawningBeaconObject)
         {
            if(this.mGame.mCurrentMapId == "Home")
            {
               this.mSpawningBeaconObject = this.createObject(param1,new Point()) as SpawningBeaconObject;
               this.mSpawningBeaconObject.setPos(this.getCenterPointXOfCell(param2),this.getCenterPointYOfCell(param2),0);
               this.mSpawningBeaconObject.getContainer().visible = true;
               this.mSpawningBeaconObject.mVisible = true;
               _loc3_ = {
                  "coord_x":param2.mPosI,
                  "coord_y":param2.mPosJ,
                  "item_id":param1.mId,
                  "claim_player_tile":true
               };
               this.mGame.mServer.serverCallServiceWithParameters(ServiceIDs.PLACE_ENEMY_INSTALLATION,_loc3_,false);
               if(param2.mOwner == MapData.TILE_OWNER_FRIENDLY)
               {
                  this.changeCellOwner(param2);
               }
               this.updateGridInformation();
               this.updateGridCharacterInfo();
               this.resetSpawningBeaconTimer();
               GameState.mInstance.moveCameraToSeeRenderable(this.mSpawningBeaconObject,true);
            }
         }
      }
      
      private function updateParatroops(param1:int) : void
      {
      }
      
      private function updatePatrols(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:GridCell = null;
         var _loc12_:Boolean = false;
         var _loc13_:MapArea = null;
         var _loc14_:Array = null;
         var _loc15_:GridCell = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:String = null;
         var _loc21_:Renderable = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         if(GameState.mConfig.EnemyAppearanceSetup.Patrol.Probability > 0)
         {
            this.mPatrolAppearTimer += param1;
            if(this.mPatrolAppearTimer / MINUTE_MS >= GameState.mConfig.EnemyAppearanceSetup.Patrol.ActivationTime)
            {
               this.mPatrolAppearTimer = 0;
               _loc2_ = this.mFloor.getGridTop();
               _loc3_ = this.mFloor.getGridBottom();
               _loc4_ = this.mFloor.getGridLeft();
               _loc5_ = this.mFloor.getGridRight();
               _loc6_ = this.mSizeX * this.mSizeY;
               _loc7_ = this.mGame.mMapData.mGrid;
               _loc8_ = _loc4_;
               while(_loc8_ < _loc5_)
               {
                  _loc9_ = _loc2_;
                  while(_loc9_ < _loc3_)
                  {
                     if(!((_loc10_ = _loc9_ * this.mSizeX + _loc8_) < 0 || _loc10_ >= _loc6_))
                     {
                        if(!(_loc11_ = _loc7_[_loc10_] as GridCell).mCharacter)
                        {
                           if(!_loc11_.hasFog())
                           {
                              if(_loc11_.mOwner == MapData.TILE_OWNER_ENEMY)
                              {
                                 if(Math.random() * 100 < GameState.mConfig.EnemyAppearanceSetup.Patrol.Probability)
                                 {
                                    _loc12_ = false;
                                    _loc14_ = (_loc13_ = MapArea.getAreaAroundCell(this,_loc11_,1)).getCells();
                                    _loc16_ = 0;
                                    while(_loc16_ < _loc14_.length)
                                    {
                                       if(Boolean((_loc15_ = _loc14_[_loc16_]).mCharacter) && _loc15_.mCharacter is PlayerUnit)
                                       {
                                          _loc12_ = true;
                                          break;
                                       }
                                       _loc16_++;
                                    }
                                    if(!_loc12_)
                                    {
                                       _loc17_ = 0;
                                       _loc18_ = Math.random() * 100;
                                       _loc19_ = 0;
                                       while(_loc19_ < GameState.mConfig.EnemyAppearanceSetup.Patrol.EnemyUnits.length)
                                       {
                                          _loc17_ += int(GameState.mConfig.EnemyAppearanceSetup.Patrol.EnemyUnitsP[_loc19_]);
                                          if(_loc18_ < _loc17_)
                                          {
                                             _loc20_ = String((GameState.mConfig.EnemyAppearanceSetup.Patrol.EnemyUnits[_loc19_] as Object).ID);
                                             _loc21_ = this.createObject(ItemManager.getItem(_loc20_,"EnemyUnit") as MapItem,new Point(0,0));
                                             _loc22_ = this.getCenterPointXAtIJ(_loc11_.mPosI,_loc11_.mPosJ);
                                             _loc23_ = this.getCenterPointYAtIJ(_loc11_.mPosI,_loc11_.mPosJ);
                                             _loc21_.setPos(_loc22_,_loc23_,0);
                                             _loc21_.getContainer().visible = true;
                                             _loc21_.mVisible = true;
                                             break;
                                          }
                                          _loc19_++;
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                     _loc9_++;
                  }
                  _loc8_++;
               }
            }
         }
      }
      
      private function updateDebrisSpawn(param1:int) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:GridCell = null;
         var _loc6_:int = 0;
         var _loc7_:GridCell = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(GameState.mConfig.DebrisSetup.RandomSpawn.Probability > 0)
         {
            this.mDebrisRandomSpawnTimer += param1;
            if(this.mDebrisRandomSpawnTimer / MINUTE_MS > GameState.mConfig.DebrisSetup.RandomSpawn.ActivationTime)
            {
               this.mDebrisRandomSpawnTimer = 0;
               if(Math.random() * 100 < GameState.mConfig.DebrisSetup.RandomSpawn.Probability)
               {
                  _loc2_ = new Array();
                  _loc3_ = MapArea.getArea(this,0,0,this.mSizeX,this.mSizeY).getCells();
                  _loc4_ = 0;
                  while(_loc4_ < _loc3_.length)
                  {
                     if((_loc5_ = _loc3_[_loc4_] as GridCell).mWalkable)
                     {
                        if(_loc5_.mOwner == MapData.TILE_OWNER_ENEMY)
                        {
                           if(!_loc5_.mCharacter)
                           {
                              if(!_loc5_.mObject)
                              {
                                 _loc2_.push(_loc3_[_loc4_]);
                              }
                           }
                        }
                     }
                     _loc4_++;
                  }
                  if(_loc2_.length > 0)
                  {
                     _loc6_ = Math.random() * _loc2_.length;
                     _loc7_ = _loc2_[_loc6_];
                     _loc8_ = this.getCenterPointXAtIJ(_loc7_.mPosI,_loc7_.mPosJ);
                     _loc9_ = this.getCenterPointYAtIJ(_loc7_.mPosI,_loc7_.mPosJ);
                     this.mGame.spawnNewDebris(GameState.mConfig.DebrisSetup.RandomSpawn.DebrisObject.ID,GameState.mConfig.DebrisSetup.RandomSpawn.DebrisObject.Type,_loc8_,_loc9_);
                  }
               }
            }
         }
      }
      
      public function castSaboteurs(param1:GridCell) : void
      {
         var _loc2_:MapArea = null;
         var _loc3_:Array = null;
         var _loc4_:GridCell = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:GridCell = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:Renderable = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         if(GameState.mConfig.EnemyAppearanceSetup.Saboteur.Probability == 0)
         {
            return;
         }
         if(Math.random() * 100 < GameState.mConfig.EnemyAppearanceSetup.Saboteur.Probability)
         {
            _loc2_ = MapArea.getAreaAroundCell(this,param1,1);
            _loc3_ = _loc2_.getCells();
            _loc5_ = new Array();
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               if((_loc4_ = _loc3_[_loc6_]).mWalkable)
               {
                  if(!_loc4_.hasFog())
                  {
                     if(!_loc4_.mCharacter)
                     {
                        if(!_loc4_.mObject)
                        {
                           _loc5_.push(_loc4_);
                        }
                     }
                  }
               }
               _loc6_++;
            }
            if(_loc5_.length > 0)
            {
               _loc7_ = Math.random() * _loc5_.length;
               _loc8_ = _loc5_[_loc7_] as GridCell;
               if(GameState.mConfig.EnemyAppearanceSetup.Saboteur.EnemyUnits is Array)
               {
                  _loc9_ = 0;
                  _loc10_ = Math.random() * 100;
                  _loc11_ = 0;
                  while(_loc11_ < GameState.mConfig.EnemyAppearanceSetup.Saboteur.EnemyUnits.length)
                  {
                     _loc9_ += int(GameState.mConfig.EnemyAppearanceSetup.Saboteur.EnemyUnitsP[_loc11_]);
                     if(_loc10_ < _loc9_)
                     {
                        _loc12_ = String((GameState.mConfig.EnemyAppearanceSetup.Saboteur.EnemyUnits[_loc11_] as Object).ID);
                        _loc13_ = this.createObject(ItemManager.getItem(_loc12_,"EnemyUnit") as MapItem,new Point(0,0));
                        _loc14_ = this.getCenterPointXAtIJ(_loc8_.mPosI,_loc8_.mPosJ);
                        _loc15_ = this.getCenterPointYAtIJ(_loc8_.mPosI,_loc8_.mPosJ);
                        _loc13_.setPos(_loc14_,_loc15_,0);
                        _loc13_.getContainer().visible = true;
                        _loc13_.mVisible = true;
                        break;
                     }
                     _loc11_++;
                  }
               }
               else
               {
                  _loc13_ = this.createObject(ItemManager.getItem(GameState.mConfig.EnemyAppearanceSetup.Saboteur.EnemyUnits.ID,"EnemyUnit") as MapItem,new Point(0,0));
                  _loc14_ = this.getCenterPointXAtIJ(_loc8_.mPosI,_loc8_.mPosJ);
                  _loc15_ = this.getCenterPointYAtIJ(_loc8_.mPosI,_loc8_.mPosJ);
                  _loc13_.setPos(_loc14_,_loc15_,0);
                  _loc13_.getContainer().visible = true;
                  _loc13_.mVisible = true;
               }
            }
         }
      }
      
      public function getPlayerUnitsAndObjects() : Array
      {
         var _loc2_:Element = null;
         var _loc1_:Array = new Array();
         var _loc3_:int = int(this.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mAllElements[_loc4_] as Element;
            if(_loc2_ is PlayerUnit)
            {
               if((_loc2_ as PlayerUnit).isAlive())
               {
                  _loc1_.push(_loc2_);
               }
            }
            else if(_loc2_ is PlayerInstallationObject && (_loc2_ as PlayerInstallationObject).isAlive())
            {
               _loc1_.push(_loc2_);
            }
            else if(_loc2_ is PlayerBuildingObject)
            {
               if(_loc2_ is ConstructionObject)
               {
                  if((_loc2_ as ConstructionObject).mHasBeenCompleted)
                  {
                     if((_loc2_ as ConstructionObject).mState != PlayerBuildingObject.STATE_RUINS)
                     {
                        _loc1_.push(_loc2_);
                     }
                  }
               }
               else if(!(_loc2_ is ResourceBuildingObject))
               {
                  if((_loc2_ as PlayerBuildingObject).getHealth() > 0)
                  {
                     _loc1_.push(_loc2_);
                  }
               }
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getPlayerBuildingTargets() : Array
      {
         var _loc2_:Element = null;
         var _loc1_:Array = new Array();
         var _loc3_:int = int(this.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mAllElements[_loc4_] as Element;
            if(_loc2_ is ConstructionObject)
            {
               if((_loc2_ as ConstructionObject).mHasBeenCompleted)
               {
                  if((_loc2_ as ConstructionObject).mState != PlayerBuildingObject.STATE_RUINS)
                  {
                     _loc1_.push(_loc2_);
                  }
               }
            }
            else if(_loc2_ is ResourceBuildingObject)
            {
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getPlayerInstallations() : Array
      {
         var _loc2_:Element = null;
         var _loc1_:Array = new Array();
         var _loc3_:int = int(this.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mAllElements[_loc4_] as Element;
            if(_loc2_ is PlayerInstallationObject)
            {
               _loc1_.push(_loc2_);
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getPlayerAliveUnits() : Array
      {
         var _loc2_:Element = null;
         var _loc1_:Array = new Array();
         var _loc3_:int = int(this.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mAllElements[_loc4_] as Element;
            if(_loc2_ is PlayerUnit && (_loc2_ as PlayerUnit).isAlive())
            {
               _loc1_.push(_loc2_ as PlayerUnit);
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      private function highlightCell(param1:GridCell) : void
      {
         switch(this.mGame.mState)
         {
            case GameState.STATE_PVP:
            case GameState.STATE_PLAY:
               if(param1 != this.mPreviousCell)
               {
                  if(this.mGame.mActivatedPlayerUnit)
                  {
                     this.mMapGUIEffectsLayer.highlightSelectedGridCell(param1,true);
                     this.mMapGUIEffectsLayer.highlightSelectedGridCell(this.mPreviousCell,false);
                  }
               }
               break;
            case GameState.STATE_MOVE_ITEM:
            case GameState.STATE_PLACE_ITEM:
            case GameState.STATE_USE_INVENTORY_ITEM:
         }
      }
      
      public function highlightDebris(param1:GridCell) : void
      {
         if(this.mHighlightedDebris)
         {
            if(this.mHighlightedDebris.getContainer())
            {
               this.mHighlightedDebris.getContainer().mouseEnabled = false;
               this.mHighlightedDebris.getContainer().mouseChildren = false;
            }
         }
         if(param1 && param1.mObject && param1.mObject is DebrisObject && !this.mGame.mActivatedPlayerUnit && param1.mCharacter == null)
         {
            this.mHighlightedDebris = DebrisObject(param1.mObject);
            if(mouseDownAction)
            {
               this.showObjectTooltip(this.mHighlightedDebris);
               this.startToolTipTimer();
            }
            if(param1.mOwner == MapData.TILE_OWNER_FRIENDLY && (this.mAllowMouseX == param1.mPosI && this.mAllowMouseY == param1.mPosJ || !this.mMouseDisabled))
            {
               this.setHandCursor(this.mHighlightedDebris.getContainer(),true);
               this.mHighlightedDebris.getContainer().mouseEnabled = true;
               this.mHighlightedDebris.getContainer().mouseChildren = true;
            }
         }
         else if(param1 && !param1.mObject && !param1.mCharacter && !param1.mPowerUp)
         {
            this.hideObjectTooltip();
         }
      }
      
      private function highlightCharacter(param1:GridCell, param2:int) : void
      {
         var _loc3_:Array = null;
         var _loc4_:PlayerUnit = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:PlayerUnit = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(param1 != this.mPreviousCell)
         {
            if(this.mPreviousCell)
            {
               if(this.mPreviousCell.mCharacter)
               {
                  if(this.mPreviousCell.mCharacter is EnemyUnit)
                  {
                     _loc3_ = this.mGame.searchAttackablePlayerUnits(this.mPreviousCell.mCharacter);
                     if(_loc3_)
                     {
                        _loc5_ = int(_loc3_.length);
                        _loc6_ = 0;
                        while(_loc6_ < _loc5_)
                        {
                           if(!(_loc4_ = _loc3_[_loc6_] as PlayerUnit).isShooting())
                           {
                              _loc4_.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                           }
                           _loc6_++;
                        }
                        this.mMapGUIEffectsLayer.hideAttackGridCells();
                     }
                  }
                  if(!param1 || this.mPreviousCell.mCharacter != param1.mCharacter)
                  {
                     this.hideObjectTooltip();
                  }
                  this.setHandCursor(this.mPreviousCell.mCharacter.getContainer(),false);
               }
            }
         }
         if(!this.isInsideVisibleArea(param1))
         {
            return;
         }
         if(param1)
         {
            if(param1.mCharacter)
            {
               if(!param1.hasFog())
               {
                  this.setHandCursor(param1.mCharacter.getContainer(),true);
                  if(param1.mCharacter is EnemyUnit && !this.mGame.mVisitingFriend)
                  {
                     _loc3_ = this.mGame.searchAttackablePlayerUnits(param1.mCharacter);
                     _loc7_ = 0;
                     if(_loc3_)
                     {
                        _loc9_ = int(_loc3_.length);
                        _loc10_ = 0;
                        while(_loc10_ < _loc9_)
                        {
                           (_loc8_ = _loc3_[_loc10_] as PlayerUnit).aimTo(param1.mCharacter.mX,param1.mCharacter.mY);
                           _loc7_ += _loc8_.getPower();
                           if((_loc11_ = Math.floor(_loc8_.mX / this.mGridDimX)) < param1.mPosI)
                           {
                              _loc8_.setAnimationDirection(AnimationController.DIR_RIGHT);
                           }
                           else if(_loc11_ > param1.mPosI)
                           {
                              _loc8_.setAnimationDirection(AnimationController.DIR_LEFT);
                           }
                           if(_loc8_.isStill())
                           {
                              this.mMapGUIEffectsLayer.highlightAttackerGridCell(_loc8_.getCell());
                           }
                           _loc10_++;
                        }
                     }
                     if(mouseDownAction)
                     {
                        this.showObjectTooltip(param1.mCharacter,_loc7_);
                        this.startToolTipTimer();
                     }
                  }
                  else if(mouseDownAction)
                  {
                     this.showObjectTooltip(param1.mCharacter);
                     this.startToolTipTimer();
                  }
               }
            }
         }
      }
      
      public function showObjectTooltip(param1:Renderable, param2:int = 0) : void
      {
         if(LootReward.smActivatedCounter == 0)
         {
            this.mGame.getHud().showObjectTooltip(param1,param2);
         }
      }
      
      public function hideObjectTooltip() : void
      {
         var _loc1_:HUDInterface = this.mGame.getHud();
         if(_loc1_ != null)
         {
            _loc1_.hideObjectTooltip();
         }
      }
      
      private function highlightEnemyInstallation(param1:GridCell, param2:int) : void
      {
         var _loc3_:Array = null;
         var _loc4_:PlayerUnit = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:PlayerUnit = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(param1 != this.mPreviousCell)
         {
            if(this.mPreviousCell)
            {
               if(this.mPreviousCell.mObject)
               {
                  if(this.mPreviousCell.mObject is EnemyInstallationObject)
                  {
                     if(!(param1 && param1.mObject && param1.mObject == this.mPreviousCell.mObject))
                     {
                        _loc3_ = this.mGame.searchAttackablePlayerUnits(this.mPreviousCell.mObject);
                        if(_loc3_)
                        {
                           _loc5_ = int(_loc3_.length);
                           _loc6_ = 0;
                           while(_loc6_ < _loc5_)
                           {
                              if(!(_loc4_ = _loc3_[_loc6_] as PlayerUnit).isShooting())
                              {
                                 _loc4_.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                              }
                              _loc6_++;
                           }
                           this.mMapGUIEffectsLayer.hideAttackGridCells();
                        }
                        if(!param1 || this.mPreviousCell.mObject != param1.mObject)
                        {
                           this.hideObjectTooltip();
                           this.setHandCursor(this.mPreviousCell.mObject.getContainer(),false);
                        }
                     }
                  }
               }
            }
         }
         if(param1)
         {
            if(!param1.hasFog())
            {
               if(param1.mObject)
               {
                  if(param1.mObject is EnemyInstallationObject)
                  {
                     if((param1.mObject as EnemyInstallationObject).isAlive())
                     {
                        if(mouseDownAction)
                        {
                           this.showObjectTooltip(param1.mObject);
                           this.startToolTipTimer();
                        }
                        this.setHandCursor(param1.mObject.getContainer(),true);
                     }
                     if(!param1.mObject.isWalkable())
                     {
                        if(!this.mGame.mVisitingFriend)
                        {
                           if(!(param1.mObject is SpawningBeaconObject))
                           {
                              _loc3_ = this.mGame.searchAttackablePlayerUnits(param1.mObject);
                              if(_loc3_)
                              {
                                 _loc8_ = int(_loc3_.length);
                                 _loc9_ = 0;
                                 while(_loc9_ < _loc8_)
                                 {
                                    (_loc7_ = _loc3_[_loc9_] as PlayerUnit).aimTo(param1.mObject.mX,param1.mObject.mY + (param1.mObject.getTileSize().y * this.mGridDimX >> 1));
                                    if((_loc10_ = Math.floor(_loc7_.mX / this.mGridDimX)) < param1.mPosI)
                                    {
                                       _loc7_.setAnimationDirection(AnimationController.DIR_RIGHT);
                                    }
                                    else if(_loc10_ > param1.mPosI)
                                    {
                                       _loc7_.setAnimationDirection(AnimationController.DIR_LEFT);
                                    }
                                    if(_loc7_.isStill())
                                    {
                                       this.mMapGUIEffectsLayer.highlightAttackerGridCell(_loc7_.getCell());
                                    }
                                    _loc9_++;
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function highlightFriendlyInstallation(param1:GridCell, param2:int) : void
      {
         var _loc3_:Array = null;
         var _loc4_:PlayerUnit = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:PlayerUnit = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(param1 != this.mPreviousCell)
         {
            if(this.mPreviousCell && this.mPreviousCell.mObject && (this.mPreviousCell.mObject is PlayerBuildingObject || this.mPreviousCell.mObject is PlayerInstallationObject || this.mPreviousCell.mObject is SignalObject))
            {
               if(param1 && param1.mObject && param1.mObject == this.mPreviousCell.mObject)
               {
                  if(param1.mCharacter)
                  {
                     if(this.mPreviousCell.mObject is PlayerBuildingObject)
                     {
                        this.hideObjectTooltip();
                     }
                     else
                     {
                        this.hideObjectTooltip();
                     }
                  }
               }
               else
               {
                  _loc3_ = this.mGame.searchUnitsInRange(this.mPreviousCell.mObject);
                  if(_loc3_)
                  {
                     _loc5_ = int(_loc3_.length);
                     _loc6_ = 0;
                     while(_loc6_ < _loc5_)
                     {
                        if(!(_loc4_ = _loc3_[_loc6_] as PlayerUnit).isShooting())
                        {
                           _loc4_.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                        }
                        _loc6_++;
                     }
                     this.mMapGUIEffectsLayer.hideAttackGridCells();
                  }
                  if(!param1 || this.mPreviousCell.mObject != param1.mObject)
                  {
                     if(this.mPreviousCell.mObject is PlayerBuildingObject)
                     {
                        this.hideObjectTooltip();
                     }
                     else
                     {
                        this.hideObjectTooltip();
                     }
                  }
               }
            }
         }
         if(param1)
         {
            if(!param1.hasFog())
            {
               if(param1.mObject)
               {
                  if(param1.mObject is PlayerBuildingObject)
                  {
                     if((param1.mObject as PlayerBuildingObject).getState() != PlayerBuildingObject.STATE_RUINS)
                     {
                        _loc7_ = (param1.mObject as PlayerBuildingObject).getState();
                        if(this.mGame.mActivatedPlayerUnit || !(param1.mObject as PlayerBuildingObject).isFullHealth() || _loc7_ == PlayerBuildingObject.STATE_BEING_HARVESTED || _loc7_ == PlayerBuildingObject.STATE_PLACING_ON_MAP || _loc7_ == PlayerBuildingObject.STATE_PRODUCING || _loc7_ == PlayerBuildingObject.STATE_REMOVE)
                        {
                           this.setHandCursor(param1.mObject.getContainer(),false);
                        }
                        else
                        {
                           this.setHandCursor(param1.mObject.getContainer(),true);
                        }
                     }
                     if(!param1.mCharacter)
                     {
                        if(mouseDownAction)
                        {
                           this.showObjectTooltip(param1.mObject);
                           this.startToolTipTimer();
                        }
                     }
                     if(param1.mObject is PermanentHFEObject)
                     {
                        if(!this.mGame.mVisitingFriend)
                        {
                           _loc3_ = this.mGame.searchUnitsInRange(param1.mObject);
                           if(_loc3_)
                           {
                              _loc9_ = int(_loc3_.length);
                              _loc10_ = 0;
                              while(_loc10_ < _loc9_)
                              {
                                 (_loc8_ = _loc3_[_loc10_] as PlayerUnit).aimTo(param1.mObject.mX,param1.mObject.mY + (param1.mObject.getTileSize().y * this.mGridDimX >> 1));
                                 if((_loc11_ = Math.floor(_loc8_.mX / this.mGridDimX)) < param1.mPosI)
                                 {
                                    _loc8_.setAnimationDirection(AnimationController.DIR_RIGHT);
                                 }
                                 else if(_loc11_ > param1.mPosI)
                                 {
                                    _loc8_.setAnimationDirection(AnimationController.DIR_LEFT);
                                 }
                                 if(!(param1.mObject as PermanentHFEObject).isFullHealth())
                                 {
                                    if(_loc8_.isStill())
                                    {
                                       this.mMapGUIEffectsLayer.highlightAttackerGridCell(_loc8_.getCell());
                                    }
                                 }
                                 _loc10_++;
                              }
                           }
                        }
                     }
                  }
                  else if(param1.mObject is PlayerInstallationObject)
                  {
                     if(mouseDownAction)
                     {
                        this.showObjectTooltip(param1.mObject);
                        this.startToolTipTimer();
                     }
                  }
                  else if(param1.mObject is SignalObject)
                  {
                     if(mouseDownAction)
                     {
                        this.showObjectTooltip(param1.mObject);
                        this.startToolTipTimer();
                     }
                  }
               }
            }
         }
      }
      
      public function addEffect(param1:MovieClip, param2:int, param3:int, param4:int) : void
      {
         this.mEffectPending = !this.mEffectController.startEffect(this,param1,param2,param3,param4);
         if(this.mEffectPending)
         {
            this.mEffectPendingMC = param1;
            this.mEffectPendingType = param2;
            this.mEffectPendingX = param3;
            this.mEffectPendingY = param4;
         }
      }
      
      private function setHandCursor(param1:DisplayContainer, param2:Boolean) : void
      {
         param1.buttonMode = param2;
         param1.useHandCursor = param2;
         param1.mouseEnabled = param2;
      }
      
      public function initCursors() : void
      {
         CursorManager.getInstance().initCursorImages();
      }
      
      private function shouldShowSelectCursorOnBuilding(param1:Renderable) : Boolean
      {
         return param1 is PlayerBuildingObject && (!(param1 is ConstructionObject) || (param1 as ConstructionObject).mState != PlayerBuildingObject.STATE_RUINS) && (!(param1 is ResourceBuildingObject) || (param1 as ResourceBuildingObject).mState != PlayerBuildingObject.STATE_RUINS) && (!(param1 is PermanentHFEObject) || param1 is PermanentHFEObject && PermanentHFEObject(param1).isFullHealth()) || param1 is PlayerInstallationObject || param1 is DebrisObject;
      }
      
      private function shouldShowAttackCursorOnBuilding(param1:Renderable) : Boolean
      {
         return param1 is EnemyInstallationObject && EnemyInstallationObject(param1).isAlive() || param1 is PermanentHFEObject && !PermanentHFEObject(param1).isFullHealth();
      }
      
      private function shouldShowSelectCursorAtNeighbourCell(param1:GridCell) : Boolean
      {
         if(this.mGame.mPlayerProfile.mNeighborActionsLeft <= 0)
         {
            return false;
         }
         if(param1.mViewers <= 0)
         {
            if(param1.mOwner != MapData.TILE_OWNER_FRIENDLY)
            {
               return false;
            }
         }
         if(param1.mCharacter)
         {
            return true;
         }
         if(param1.mObject)
         {
            if(param1.mObject is EnemyInstallationObject)
            {
               if((param1.mObject as EnemyInstallationObject).hasForceField())
               {
                  return false;
               }
            }
            if(param1.mObject is DebrisObject)
            {
               if(param1.mOwner == MapData.TILE_OWNER_FRIENDLY)
               {
                  return true;
               }
            }
            if(param1.mObject is HFEObject)
            {
               return true;
            }
            if(param1.mObject is EnemyInstallationObject)
            {
               return true;
            }
            if(param1.mObject.isPlaceableOnAllTiles())
            {
               return true;
            }
         }
         return false;
      }
      
      public function setVisiblePlacementButton(param1:Boolean) : void
      {
         if(!this.mTickCrossActive && param1)
         {
            this.mTickCrossActive = true;
         }
         this.mGame.mHUD.mPlaceButton.setVisible(param1);
         this.mGame.mHUD.mPlaceCancelButton.setVisible(param1);
      }
      
      private function moveButton(param1:GridCell) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Point = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.mObjectBeingMoved)
         {
            _loc4_ = this.mObjectBeingMoved.getContainer().width;
            _loc5_ = this.mObjectBeingMoved.getContainer().height;
            _loc6_ = new Point(this.mObjectBeingMoved.mX,this.mObjectBeingMoved.mY);
            _loc2_ = (_loc6_ = this.mSceneHud.localToGlobal(_loc6_)).x;
            _loc3_ = _loc6_.y;
            _loc7_ = this.mObjectBeingMoved.getTileSize().x - 1;
            _loc8_ = this.mObjectBeingMoved.getTileSize().y - 1;
            _loc9_ = 0;
            _loc10_ = CursorManager.CURSOR_TYPE_RELOCATE_WITH_COST_1 + _loc7_;
            switch(_loc10_)
            {
               case CursorManager.CURSOR_TYPE_RELOCATE_WITH_COST_1:
                  _loc9_ = _loc2_ - 25 - this.mGame.mHUD.mPlaceCancelButton.getWidth();
                  _loc2_ = _loc2_ - 180 - this.mGame.mHUD.mPlaceButton.getWidth();
                  break;
               case CursorManager.CURSOR_TYPE_RELOCATE_WITH_COST_2:
                  _loc9_ = _loc2_ + 75 - this.mGame.mHUD.mPlaceCancelButton.getWidth();
                  _loc2_ = _loc2_ - 180 - this.mGame.mHUD.mPlaceButton.getWidth();
                  break;
               case CursorManager.CURSOR_TYPE_RELOCATE_WITH_COST_3:
                  _loc9_ = _loc2_ + 170 - this.mGame.mHUD.mPlaceCancelButton.getWidth();
                  _loc2_ = _loc2_ - 180 - this.mGame.mHUD.mPlaceButton.getWidth();
                  break;
               case CursorManager.CURSOR_TYPE_RELOCATE_WITH_COST_4:
                  _loc9_ = _loc2_ + 270 - this.mGame.mHUD.mPlaceCancelButton.getWidth();
                  _loc2_ = _loc2_ - 180 - this.mGame.mHUD.mPlaceButton.getWidth();
            }
            this.mGame.mHUD.mPlaceButton.setX(_loc2_);
            this.mGame.mHUD.mPlaceButton.setY(_loc3_ - 30);
            this.mGame.mHUD.mPlaceCancelButton.setX(_loc9_);
            this.mGame.mHUD.mPlaceCancelButton.setY(_loc3_ - 30);
         }
         else
         {
            _loc11_ = this.mGridDimX * param1.mPosI;
            _loc12_ = this.mGridDimY * param1.mPosJ;
            _loc13_ = new Point(_loc11_,_loc12_);
            _loc13_ = this.mSceneHud.localToGlobal(_loc13_);
            this.mGame.mHUD.mPlaceButton.setX(_loc13_.x - 140);
            this.mGame.mHUD.mPlaceButton.setY(_loc13_.y - 40);
            this.mGame.mHUD.mPlaceCancelButton.setX(_loc13_.x - 60);
            this.mGame.mHUD.mPlaceCancelButton.setY(_loc13_.y - 40);
         }
      }
      
      public function updateCursors(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:GridCell = null;
         var _loc13_:MapArea = null;
         if(this.isLootRewardActivated() || this.mGame.mHUD && this.mGame.mHUD.mBlock)
         {
            this.hideCursors();
            this.mPreviousCursorCell = null;
            this.mMapGUIEffectsLayer.removeHighlightRange();
            this.mMapGUIEffectsLayer.clearEnemyMovementHighlights();
            return;
         }
         _loc3_ = this.getTileUnderMouse();
         if(!_loc3_ || !this.isInsideVisibleArea(_loc3_))
         {
            this.mPreviousCursorCell = null;
            this.hideCursors();
            return;
         }
         if(_loc3_ != this.mPreviousCursorCell || param2)
         {
            this.mPreviousCursorCell = _loc3_;
            this.hideCursors();
            this.mMapGUIEffectsLayer.removeHighlightRange();
            this.mMapGUIEffectsLayer.clearEnemyMovementHighlights();
         }
         var _loc4_:Boolean = true;
         var _loc5_:CursorManager = CursorManager.getInstance();
         var _loc6_:int = 0;
         var _loc7_:int = -1;
         var _loc8_:* = false;
         var _loc9_:IsometricCharacter = _loc3_.mCharacter;
         var _loc10_:Renderable = _loc3_.mObject;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         if(this.mObjectBeingMoved)
         {
            if(this.mObjectBeingMoved.mScene)
            {
               _loc11_ = this.mObjectBeingMoved.getTileSize().x - 1;
               _loc12_ = this.mObjectBeingMoved.getTileSize().y - 1;
               _loc5_.setPos(this.mObjectBeingMoved.getCell());
               if(this.isInLegalPlacementArea(this.mObjectBeingMoved))
               {
                  this.setVisiblePlacementButton(true);
               }
               else
               {
                  this.setVisiblePlacementButton(false);
               }
               this.moveButton(this.mObjectBeingMoved.getCell());
            }
         }
         else if(_loc10_ && _loc10_.getContainer().visible && this.mGame.mState != GameState.STATE_PLACE_FIRE_MISSION)
         {
            _loc11_ = _loc10_.getTileSize().x - 1;
            _loc12_ = _loc10_.getTileSize().y - 1;
            _loc5_.setPos(_loc10_.getCell());
         }
         else
         {
            _loc5_.setPos(_loc3_);
         }
         switch(this.mGame.mState)
         {
            case GameState.STATE_PVP:
            case GameState.STATE_PLAY:
               if(Boolean(_loc9_) && _loc9_.getContainer().visible)
               {
                  _loc5_.setPos(_loc3_);
                  if(_loc9_ is PlayerUnit)
                  {
                     if(this.mGame.mCurrentAction)
                     {
                        _loc8_ = true;
                     }
                     _loc7_ = CursorManager.CURSOR_TYPE_SELECT_1;
                  }
                  else if(_loc9_ is EnemyUnit && _loc9_.isAlive())
                  {
                     if(this.mGame.searchUnitsInRange(_loc9_).length > 0)
                     {
                        _loc7_ = CursorManager.CURSOR_TYPE_ATTACK_1;
                     }
                     else
                     {
                        _loc7_ = CursorManager.CURSOR_TYPE_SELECT_1;
                     }
                  }
                  else if(FeatureTuner.USE_PVP_MATCH && _loc9_ is PvPEnemyUnit)
                  {
                     this.mGame.updateWalkableCellsForPvPEnemy(_loc9_ as PvPEnemyUnit);
                  }
                  this.mMapGUIEffectsLayer.highlightRange(_loc3_,_loc9_);
               }
               else if(Boolean(_loc10_) && _loc10_.getContainer().visible)
               {
                  _loc5_.setPos(_loc10_.getCell());
                  if(this.shouldShowSelectCursorOnBuilding(_loc10_))
                  {
                     if(_loc11_ == _loc12_)
                     {
                        _loc7_ = CursorManager.CURSOR_TYPE_SELECT_1 + _loc11_;
                     }
                     else
                     {
                        _loc7_ = this.getSpecialCursor(CursorManager.CURSOR_TYPE_SELECT_1,_loc11_,_loc12_);
                     }
                  }
                  else if(this.shouldShowAttackCursorOnBuilding(_loc10_))
                  {
                     if(this.mGame.searchUnitsInRange(_loc10_).length > 0)
                     {
                        if(_loc11_ == _loc12_)
                        {
                           _loc7_ = CursorManager.CURSOR_TYPE_ATTACK_1 + _loc11_;
                        }
                        else
                        {
                           _loc7_ = this.getSpecialCursor(CursorManager.CURSOR_TYPE_ATTACK_1,_loc11_,_loc12_);
                        }
                     }
                     else if(_loc11_ == _loc12_)
                     {
                        _loc7_ = CursorManager.CURSOR_TYPE_SELECT_1 + _loc11_;
                     }
                     else
                     {
                        _loc7_ = this.getSpecialCursor(CursorManager.CURSOR_TYPE_SELECT_1,_loc11_,_loc12_);
                     }
                  }
                  this.mMapGUIEffectsLayer.highlightRange(_loc3_,_loc10_);
               }
               if(_loc7_ == -1)
               {
                  if(this.mGame.mActivatedPlayerUnit)
                  {
                     if(this.mGame.mActiveCharacteWalkableCells.indexOf(_loc3_) != -1)
                     {
                        _loc5_.setPos(_loc3_);
                        _loc7_ = CursorManager.CURSOR_TYPE_SELECT_1;
                        _loc6_ = -1;
                     }
                  }
               }
               break;
            case GameState.STATE_MOVE_ITEM:
               if(this.mObjectBeingMoved)
               {
                  this.mFlagDrag = true;
                  _loc7_ = CursorManager.CURSOR_TYPE_RELOCATE_WITH_COST_1 + _loc11_;
                  _loc8_ = !this.isCellEnableForMovingObject(_loc3_,false) || !this.isInLegalPlacementArea(this.mObjectBeingMoved);
               }
               else
               {
                  _loc7_ = CursorManager.CURSOR_TYPE_RELOCATE_WITH_COST_1 + _loc11_;
                  _loc8_ = !_loc10_ || !_loc10_.isMovable();
               }
               if(this.mObjectBeingMoved)
               {
                  if(!_loc8_)
                  {
                     if(!this.mGame.mHUD.mBlock)
                     {
                        this.mMapGUIEffectsLayer.highlightRange(_loc3_,this.mObjectBeingMoved);
                     }
                  }
               }
               break;
            case GameState.STATE_PLACE_ITEM:
               _loc7_ = CursorManager.CURSOR_TYPE_RELOCATE_1 + _loc11_;
               _loc8_ = !this.isCellEnableForMovingObject(_loc3_,false) || !this.isInLegalPlacementArea(this.mObjectBeingMoved);
               if(this.mObjectBeingMoved)
               {
                  if(!_loc8_)
                  {
                     this.mMapGUIEffectsLayer.highlightRange(_loc3_,this.mObjectBeingMoved);
                  }
               }
               break;
            case GameState.STATE_PLACE_FIRE_MISSION:
               _loc7_ = CursorManager.CURSOR_TYPE_FM_1 + this.mGame.mFireMisssionToBePlaced.mCursorOffset;
               this.setVisiblePlacementButton(true);
               this.moveButton(_loc3_);
               _loc13_ = MapArea.getArea(this,_loc3_.mPosI,_loc3_.mPosJ,this.mGame.mFireMisssionToBePlaced.mSize.x,this.mGame.mFireMisssionToBePlaced.mSize.y);
               if(!this.mPlacePressed)
               {
                  this.mFireItemX = _loc3_.mPosI;
                  this.mFireItemY = _loc3_.mPosJ;
               }
               _loc8_ = false;
               break;
            case GameState.STATE_USE_INVENTORY_ITEM:
               if(_loc10_ && _loc10_.isMovable() || Boolean(this.mObjectBeingMoved))
               {
                  if(this.mObjectBeingMoved)
                  {
                     _loc11_ = this.mObjectBeingMoved.getTileSize().x - 1;
                     _loc12_ = this.mObjectBeingMoved.getTileSize().y - 1;
                     if(!(_loc8_ = !this.isCellEnableForMovingObject(_loc3_,false) || !this.isInLegalPlacementArea(this.mObjectBeingMoved)))
                     {
                        this.mMapGUIEffectsLayer.highlightRange(_loc3_,this.mObjectBeingMoved);
                     }
                  }
                  _loc7_ = CursorManager.CURSOR_TYPE_RELOCATE_1 + _loc11_;
               }
               break;
            case GameState.STATE_REPAIR_ITEM:
               if(_loc11_ == _loc12_)
               {
                  _loc7_ = CursorManager.CURSOR_TYPE_REPAIR_1 + _loc11_;
               }
               else
               {
                  _loc7_ = CursorManager.CURSOR_TYPE_REPAIR_1;
                  _loc5_.setPos(_loc3_);
               }
               _loc8_ = !this.isCellEnableForRepairObject(_loc3_);
               break;
            case GameState.STATE_SELL_ITEM:
               _loc7_ = CursorManager.CURSOR_TYPE_SELL_1 + _loc11_;
               _loc8_ = !this.isCellEnableForSellObject(_loc3_);
               break;
            case GameState.STATE_PICKUP_UNIT:
               _loc7_ = CursorManager.CURSOR_TYPE_REDEPLOY;
               _loc8_ = !this.isCellEnableForRedeploying(_loc3_);
               break;
            case GameState.STATE_VISITING_NEIGHBOUR:
               if(this.shouldShowSelectCursorAtNeighbourCell(_loc3_))
               {
                  if(_loc11_ == _loc12_)
                  {
                     _loc7_ = CursorManager.CURSOR_TYPE_SELECT_1 + _loc11_;
                  }
                  else
                  {
                     _loc7_ = this.getSpecialCursor(CursorManager.CURSOR_TYPE_SELECT_1,_loc11_,_loc12_);
                  }
                  this.mMapGUIEffectsLayer.highlightNeighbourClickableCell(_loc3_);
               }
               if(_loc7_ == -1)
               {
                  this.mMapGUIEffectsLayer.clearHighlights();
               }
         }
         if(_loc7_ != -1)
         {
            _loc5_.addCursorImage(_loc7_,_loc8_,_loc6_);
         }
      }
      
      private function getSpecialCursor(param1:int, param2:int, param3:int) : int
      {
         var _loc4_:int = -1;
         if(param1 == CursorManager.CURSOR_TYPE_SELECT_1)
         {
            if(param2 == 1 && param3 == 0)
            {
               _loc4_ = CursorManager.CURSOR_TYPE_SELECT_SPECIAL_2X1;
            }
            else if(param2 == 3 && param3 == 0)
            {
               _loc4_ = CursorManager.CURSOR_TYPE_SELECT_SPECIAL_4X1;
            }
            else if(param2 == 3 && param3 == 1)
            {
               _loc4_ = CursorManager.CURSOR_TYPE_SELECT_SPECIAL_4X2;
            }
            else if(param2 == 2 && param3 == 1)
            {
               _loc4_ = CursorManager.CURSOR_TYPE_SELECT_SPECIAL_3X2;
            }
         }
         else if(param1 == CursorManager.CURSOR_TYPE_ATTACK_1)
         {
            if(param2 == 1 && param3 == 0)
            {
               _loc4_ = CursorManager.CURSOR_TYPE_ATTACK_SPECIAL_2X1;
            }
            else if(param2 == 3 && param3 == 0)
            {
               _loc4_ = CursorManager.CURSOR_TYPE_ATTACK_SPECIAL_4X1;
            }
            else if(param2 == 3 && param3 == 1)
            {
               _loc4_ = CursorManager.CURSOR_TYPE_ATTACK_SPECIAL_4X2;
            }
            else if(param2 == 2 && param3 == 1)
            {
               _loc4_ = CursorManager.CURSOR_TYPE_ATTACK_SPECIAL_3X2;
            }
         }
         return _loc4_;
      }
      
      private function hideCursors() : void
      {
         CursorManager.getInstance().hideCursorImages();
         this.setVisiblePlacementButton(false);
      }
      
      public function updateKeyScrolling() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(!this.mMouseScrolling)
         {
            _loc1_ = this.mCamera.getCameraX();
            _loc2_ = this.mCamera.getCameraY();
            _loc3_ = this.mCamera.getTargetX();
            _loc4_ = this.mCamera.getTargetY();
            _loc5_ = false;
            if(this.mLeftPressed)
            {
               this.mCamera.setTargetTo(_loc3_ - CAM_SPEED,_loc4_);
               _loc3_ = this.mCamera.getTargetX();
               _loc5_ = true;
            }
            if(this.mRightPressed)
            {
               this.mCamera.setTargetTo(_loc3_ + CAM_SPEED,_loc4_);
               _loc3_ = this.mCamera.getTargetX();
               _loc5_ = true;
            }
            if(this.mUpPressed)
            {
               this.mCamera.setTargetTo(_loc3_,_loc4_ - CAM_SPEED);
               _loc4_ = this.mCamera.getTargetY();
               _loc5_ = true;
            }
            if(this.mDownPressed)
            {
               this.mCamera.setTargetTo(_loc3_,_loc4_ + CAM_SPEED);
               _loc4_ = this.mCamera.getTargetY();
               _loc5_ = true;
            }
            if(!this.mAnyScrollKeyPressed && _loc5_)
            {
               this.mKeyScrollStartX = _loc1_;
               this.mKeyScrollStartY = _loc2_;
            }
            else if(this.mAnyScrollKeyPressed && !_loc5_)
            {
               _loc6_ = _loc1_ - this.mKeyScrollStartX;
               _loc7_ = _loc2_ - this.mKeyScrollStartY;
               _loc8_ = Math.abs(_loc6_) + Math.abs(_loc7_);
               MissionManager.increaseCounter("Scroll",null,_loc8_);
               if(this.mAllowMouseX >= 0)
               {
                  if(this.mAllowMouseY >= 0)
                  {
                     this.mRubberBandTimer = this.mGame.mMapData.mMapSetupData.CenterCamOnArrowDelay;
                  }
               }
            }
            this.mAnyScrollKeyPressed = _loc5_;
         }
      }
      
      public function update(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc5_:GridCell = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Point = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         if(PopUpManager.isModalPopupActive())
         {
            return;
         }
         _loc2_ = 25;
         var _loc3_:* = this.mSwitch % _loc2_ == _loc2_ - 1;
         if(FeatureTuner.USE_CAMERA_TRANSITION)
         {
            if(this.mAllowMouseX >= 0)
            {
               if(this.mAllowMouseY >= 0)
               {
                  if(this.mRubberBandTimer > 0)
                  {
                     this.mRubberBandTimer -= param1;
                     if(this.mRubberBandTimer < 0)
                     {
                        this.mCamera.setTargetTo(this.mGridDimX * this.mAllowMouseX,this.mGridDimY * this.mAllowMouseY);
                     }
                  }
               }
            }
         }
         EnvEffectManager.update(param1);
         this.mTimer += param1;
         this.updateKeyScrolling();
         this.updateCharacters(param1);
         this.updateStaticObjects(param1);
         this.updateHudObjects(param1);
         this.updatePatrols(param1);
         this.updateDebrisSpawn(param1);
         var _loc4_:GridCell = this.getTileUnderMouse();
         if(this.mGame.mState == GameState.STATE_PLAY || this.mGame.mState == GameState.STATE_PVP || this.mGame.mState == GameState.STATE_VISITING_NEIGHBOUR)
         {
            this.highlightDebris(_loc4_);
            this.highlightCell(_loc4_);
            this.highlightCharacter(_loc4_,param1);
            this.highlightEnemyInstallation(_loc4_,param1);
            this.highlightFriendlyInstallation(_loc4_,param1);
            if(_loc4_)
            {
               if(_loc4_.mPowerUp)
               {
                  if(mouseDownAction)
                  {
                     this.showObjectTooltip(_loc4_.mPowerUp);
                     this.startToolTipTimer();
                  }
               }
            }
         }
         if(!Config.DISABLE_SORT)
         {
            this.sortAll(_loc3_ || this.mMouseScrolling || Boolean(this.mObjectBeingMoved),_loc3_);
         }
         if(_loc4_ != this.mPreviousCell)
         {
            this.mPreviousCell = _loc4_;
            if(this.mGame.mActivatedPlayerUnit)
            {
               _loc7_ = Math.floor(this.mGame.mActivatedPlayerUnit.mX / this.mGridDimX);
               if(_loc5_ = this.getTileUnderMouse())
               {
                  _loc8_ = _loc5_.mPosI;
                  if(_loc7_ < _loc8_)
                  {
                     this.mGame.mActivatedPlayerUnit.setAnimationDirection(AnimationController.DIR_RIGHT);
                  }
                  else if(_loc7_ > _loc8_)
                  {
                     this.mGame.mActivatedPlayerUnit.setAnimationDirection(AnimationController.DIR_LEFT);
                  }
               }
            }
            this.mSwitch = _loc2_ - 2;
         }
         switch(this.mGame.mState)
         {
            case GameState.STATE_PVP:
            case GameState.STATE_PLAY:
            case GameState.STATE_REPAIR_ITEM:
            case GameState.STATE_SELL_ITEM:
               break;
            case GameState.STATE_MOVE_ITEM:
            case GameState.STATE_PLACE_ITEM:
            case GameState.STATE_USE_INVENTORY_ITEM:
               if(this.mObjectBeingMoved)
               {
                  if(this.mGame.mHUD.mBlock)
                  {
                     this.mObjectBeingMoved.getContainer().visible = false;
                     break;
                  }
                  this.mObjectBeingMoved.getContainer().visible = true;
                  this.mPointTmp.x = 0;
                  this.mPointTmp.y = 0;
                  _loc10_ = (_loc9_ = this.mContainer.localToGlobal(this.mPointTmp)).x;
                  _loc11_ = _loc9_.y;
                  _loc12_ = (this.mGame.mMouseX - _loc10_) / this.mContainer.scaleX;
                  _loc13_ = (this.mGame.mMouseY - _loc11_) / this.mContainer.scaleY;
                  ToScreen.inverseTransform(this.mPointTmp,_loc12_,_loc13_,0);
                  this.mPointTmp.x = this.mGridDimX * Math.floor(this.mPointTmp.x / this.mGridDimX) - 0.5 * (this.mObjectBeingMoved.getTileSize().x - 1) * this.mGridDimX;
                  this.mPointTmp.y = this.mGridDimY * Math.floor(this.mPointTmp.y / this.mGridDimY) - 0.5 * (this.mObjectBeingMoved.getTileSize().y - 1) * this.mGridDimY;
                  if(_loc5_ = this.getCellAtLocation(this.mPointTmp.x,this.mPointTmp.y))
                  {
                     this.mObjectBeingMoved.setPos(this.getCenterPointXOfCell(_loc5_),this.getCenterPointYOfCell(_loc5_),0);
                  }
                  if(!this.mMovedObjectIndicator)
                  {
                     this.mMovedObjectIndicator = new Sprite();
                     this.mMapGUIEffectsLayer.mTopLayer.addChild(this.mMovedObjectIndicator);
                  }
               }
         }
         this.updateCursors(param1);
         this.updateCamera(param1);
         var _loc6_:Boolean = false;
         if(this.mFog.mUpdateRequired)
         {
            _loc6_ = true;
            this.mFog.recalculateFogEdges();
            this.mFog.mUpdateRequired = false;
         }
         if(this.mGame.mMapData.mUpdateRequired)
         {
            _loc6_ = true;
            this.mGame.mMapData.mUpdateRequired = false;
            this.mGame.mMapData.countFriendlyTiles();
            this.mTilemapGraphic.recalculateBorderEdges();
            MissionManager.increaseCounter("Control",null,1);
         }
         if(_loc6_)
         {
            this.mTilemapGraphic.updateTilemap();
         }
         this.mEffectController.update(param1);
         if(this.mEffectPending)
         {
            this.mEffectPending = !this.mEffectController.startEffect(this,this.mEffectPendingMC,this.mEffectPendingType,this.mEffectPendingX,this.mEffectPendingY);
         }
         this.mSwitch = ++this.mSwitch % _loc2_;
      }
      
      public function exitMoveMode(param1:Boolean = false) : void
      {
         if(this.mObjectBeingMoved)
         {
            if(!this.mGame.visitingFriend())
            {
               if(param1 || !this.isObjectInLegalPosition(this.mObjectBeingMoved))
               {
                  this.mObjectBeingMoved.setPos(this.mObjectBeingMovedStartX,this.mObjectBeingMovedStartY,0);
                  this.mObjectBeingMoved.getContainer().alpha = 1;
                  this.mObjectBeingMoved.getContainer().visible = true;
                  this.incrementViewersForPlacedObject();
               }
            }
         }
         this.cancelEditMode();
      }
      
      public function getTileUnderMouse() : GridCell
      {
         if(this.mGame.mHUD)
         {
            if(this.mGame.mHUD.mBlock)
            {
               return null;
            }
         }
         if(NeighborAvatar.smMouseOver)
         {
            return null;
         }
         this.mPointTmp.x = 0;
         this.mPointTmp.y = 0;
         var _loc1_:Point = this.mContainer.localToGlobal(this.mPointTmp);
         var _loc2_:int = _loc1_.x;
         var _loc3_:int = _loc1_.y;
         var _loc4_:int = (this.mGame.mMouseX - _loc2_) / this.mContainer.scaleX;
         var _loc5_:int = (this.mGame.mMouseY - _loc3_) / this.mContainer.scaleY;
         ToScreen.inverseTransform(this.mPointTmp,_loc4_,_loc5_,0);
         this.mPointTmp.x = this.mGridDimX * Math.floor(this.mPointTmp.x / this.mGridDimX);
         this.mPointTmp.y = this.mGridDimY * Math.floor(this.mPointTmp.y / this.mGridDimY);
         this.mMouseLocalX = _loc4_;
         this.mMouseLocalY = _loc5_;
         return this.getCellAtLocation(this.mPointTmp.x,this.mPointTmp.y);
      }
      
      public function active() : Boolean
      {
         return this.mSceneActive;
      }
      
      public function updateCamera(param1:Number) : void
      {
         var _loc4_:Renderable = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = this.mContainer.scaleX * -this.mCamera.getCameraX() + this.mGame.getStageWidth() / 2;
         var _loc3_:int = this.mContainer.scaleY * -this.mCamera.getCameraY() + this.mGame.getStageHeight() / 2;
         if(this.mContainer.x != _loc2_)
         {
            _loc5_ = int(this.mSoundMakers.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(_loc4_ = this.mSoundMakers[_loc6_] as Renderable)
               {
                  _loc4_.updateSoundtransform();
               }
               _loc6_++;
            }
         }
         if(this.mContainer.x != _loc2_ || this.mContainer.y != _loc3_)
         {
            this.mContainer.x = _loc2_;
            this.mContainer.y = _loc3_;
            this.mSceneHud.x = _loc2_;
            this.mSceneHud.y = _loc3_;
            this.mTilemapGraphic.updateTilemap();
         }
      }
      
      public function areaDamage(param1:Number, param2:Number, param3:int, param4:Number) : void
      {
         this.areaDamageImpl(Math.floor(param1 / this.mGridDimX),Math.floor(param2 / this.mGridDimY),param3,param4);
      }
      
      private function areaDamageImpl(param1:int, param2:int, param3:int, param4:Number) : void
      {
         var _loc6_:int = 0;
         var _loc7_:GridCell = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc5_:int = param1 - param3;
         while(_loc5_ <= param1 + param3)
         {
            _loc6_ = param2 - param3;
            while(_loc6_ <= param2 + param3)
            {
               if((_loc7_ = this.getCellAt(_loc5_,_loc6_)) != null)
               {
                  _loc9_ = (_loc8_ = Math.abs(param1 - _loc5_) + Math.abs(param2 - _loc6_)) == 0 ? param4 : param4 / _loc8_;
                  if(_loc7_.mCharacter)
                  {
                     _loc7_.mCharacter.reduceHealth(Math.floor(_loc9_),IsometricCharacter.HIT_BY_EXPLOSION);
                  }
               }
               _loc6_++;
            }
            _loc5_++;
         }
      }
      
      public function addFloorToScene() : void
      {
         this.mContainer.addChild(this.mFloor.getContainer());
         this.initializeFloorHitArea();
         this.mFloor.addListenerObjectMouseReleased(this.FloorClicked);
         this.mContainer.addChild(this.mMapGUIEffectsLayer.mGroundLayer);
         this.mContainer.addChild(this.mMapGUIEffectsLayer.mTopLayer);
         this.mSceneHud.mouseEnabled = false;
      }
      
      private function initializeFloorHitArea() : void
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.graphics.lineStyle(4,11184810);
         ToScreen.transform(this.mPointTmp,0,0,0);
         _loc1_.graphics.moveTo(this.mPointTmp.x,this.mPointTmp.y);
         _loc1_.graphics.beginFill(0,0);
         var _loc2_:Number = this.mPointTmp.x;
         var _loc3_:Number = this.mPointTmp.y;
         ToScreen.transform(this.mPointTmp,this.mSizeX * this.mGridDimX,0,0);
         _loc1_.graphics.lineTo(this.mPointTmp.x,this.mPointTmp.y);
         ToScreen.transform(this.mPointTmp,this.mSizeX * this.mGridDimX,this.mSizeY * this.mGridDimY,0);
         _loc1_.graphics.lineTo(this.mPointTmp.x,this.mPointTmp.y);
         ToScreen.transform(this.mPointTmp,0 * this.mGridDimX,this.mSizeY * this.mGridDimY,0);
         _loc1_.graphics.lineTo(this.mPointTmp.x,this.mPointTmp.y);
         _loc1_.graphics.lineTo(_loc2_,_loc3_);
         _loc1_.graphics.endFill();
         this.mFloor.addSprite(_loc1_);
      }
      
      private function isObjectFrontOf(param1:Renderable, param2:Renderable) : Boolean
      {
         return param1.mY > param2.mY;
      }
      
      private function clampY(param1:int) : int
      {
         if(param1 >= this.mSizeY)
         {
            return this.mSizeY - 1;
         }
         if(param1 < 0)
         {
            return 0;
         }
         return param1;
      }
      
      private function clampX(param1:int) : int
      {
         if(param1 >= this.mSizeX)
         {
            return this.mSizeX - 1;
         }
         if(param1 < 0)
         {
            return 0;
         }
         return param1;
      }
      
      public function getTileRectSize(param1:Renderable) : int
      {
         var _loc2_:int = param1.getContainer().height / this.mGridDimY;
         var _loc3_:int = param1.getTileSize().x;
         var _loc4_:int = param1.getTileSize().y;
         return Math.max(_loc2_,_loc3_,_loc4_);
      }
      
      public function getHeightDebug(param1:Renderable) : int
      {
         return param1.getContainer().height;
      }
      
      private function nothingBehind_Fast(param1:Array, param2:Renderable) : Boolean
      {
         var _loc10_:Renderable = null;
         var _loc3_:int = Math.floor(param2.mX / this.mGridDimX);
         var _loc4_:int = Math.floor(param2.mY / this.mGridDimY);
         var _loc5_:int = _loc3_ - 1;
         var _loc6_:int = _loc3_ + param2.getTileSize().x + 1;
         var _loc7_:int = _loc4_ + 1;
         var _loc8_:int = _loc4_ - 1;
         _loc5_ = this.clampX(_loc5_);
         _loc6_ = this.clampX(_loc6_);
         _loc8_ = this.clampY(_loc8_);
         _loc7_ = this.clampY(_loc7_);
         var _loc9_:Array;
         var _loc11_:int = int((_loc9_ = this.getObjectsFromTiles(_loc5_,_loc6_,_loc8_,_loc7_)).length);
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_)
         {
            if(!((_loc10_ = _loc9_[_loc12_] as Renderable) == param2 || _loc10_.mSorted || !_loc10_.mVisible || _loc10_.getTileSize().z == 0 || param1.indexOf(_loc10_) == -1))
            {
               if(this.isObjectFrontOf(param2,_loc10_))
               {
                  return false;
               }
            }
            _loc12_++;
         }
         return true;
      }
      
      private function nothingBehind_Slow(param1:Array, param2:Renderable) : Boolean
      {
         var _loc3_:Renderable = null;
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = param1[_loc5_] as Renderable;
            if(_loc3_ != param2)
            {
               if(this.isObjectFrontOf(param2,_loc3_))
               {
                  return false;
               }
            }
            _loc5_++;
         }
         return true;
      }
      
      private function sortAll(param1:Boolean = true, param2:Boolean = true) : void
      {
         var _loc3_:* = false;
         var _loc4_:Sprite = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:DisplayObjectContainer = null;
         var _loc8_:int = 0;
         var _loc9_:Renderable = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(param1)
         {
            this.mRelativeVisibleArea.x = this.mCamera.getCameraX();
            this.mRelativeVisibleArea.y = this.mCamera.getCameraY();
            _loc5_ = false;
            _loc6_ = false;
            _loc10_ = 0;
            while(_loc10_ < this.mAllElements.length)
            {
               if(_loc7_ = (_loc4_ = (_loc9_ = this.mAllElements[_loc10_]).getContainer()).parent)
               {
                  _loc6_ = _loc4_.hitTestObject(this.mAbsoluteVisibleArea);
               }
               else
               {
                  _loc6_ = _loc4_.hitTestObject(this.mRelativeVisibleArea);
               }
               if(_loc9_ is Renderable)
               {
                  _loc6_ &&= this.isInsideVisibleArea(_loc9_.getCell());
               }
               _loc3_ = _loc9_.getTileSize().z == 0;
               _loc8_ = this.mVisibleObjects.indexOf(_loc9_);
               if(!_loc4_.visible)
               {
                  if(_loc7_)
                  {
                     _loc7_.removeChild(_loc4_);
                  }
                  if(_loc8_ != -1)
                  {
                     this.mVisibleObjects.splice(_loc8_,1);
                     _loc5_ = true;
                  }
               }
               else if(_loc3_)
               {
                  if(!_loc7_)
                  {
                     this.mContainer.addChildAt(_loc4_,0);
                  }
               }
               else if(_loc8_ == -1)
               {
                  this.mVisibleObjects.push(_loc9_);
                  _loc5_ = true;
               }
               _loc10_++;
            }
            this.mVisibleObjectCnt = this.mVisibleObjects.length;
         }
         if(param2)
         {
            _loc5_ ||= this.armySortObjects(this.mVisibleObjects);
         }
         if(_loc5_)
         {
            this.mContainer.addChildAt(this.mMapGUIEffectsLayer.mGroundLayer,this.mContainer.numChildren);
            _loc11_ = 0;
            while(_loc11_ < this.mVisibleObjects.length)
            {
               this.mContainer.addChildAt((this.mVisibleObjects[_loc11_] as Renderable).getContainer(),this.mContainer.numChildren);
               _loc11_++;
            }
            this.mContainer.addChildAt(this.mMapGUIEffectsLayer.mTopLayer,this.mContainer.numChildren);
            if(FeatureTuner.USE_SEA_WAVES_EFFECT)
            {
               this.mContainer.addChildAt(this.mTilemapGraphic.mWaveContainer,this.mContainer.numChildren);
            }
         }
      }
      
      public function setScale(param1:Number) : void
      {
         var _loc2_:Renderable = null;
         var _loc3_:int = int(this.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mAllElements[_loc4_] as Renderable;
            if(_loc2_)
            {
               _loc2_.reactToZoom(param1);
            }
            _loc4_++;
         }
         this.mContainer.scaleX = param1;
         this.mContainer.scaleY = param1;
         this.mSceneHud.scaleX = param1;
         this.mSceneHud.scaleY = param1;
         this.reCalculateCameraMargins();
         this.mRelativeVisibleArea.graphics.clear();
         this.mRelativeVisibleArea.graphics.drawRect(-this.mGame.getStageWidth() / this.mContainer.scaleX / 2,-this.mGame.getStageHeight() / this.mContainer.scaleX / 2,this.mGame.getStageWidth() / this.mContainer.scaleX,this.mGame.getStageHeight() / this.mContainer.scaleX);
         this.mTilemapGraphic.createBitmaps();
         this.mTilemapGraphic.updateTilemap();
         if(!Config.DISABLE_SORT)
         {
            this.sortAll();
         }
      }
      
      private function sortStatic() : void
      {
         var _loc2_:Element = null;
         var _loc1_:Array = new Array();
         var _loc3_:int = int(this.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mAllElements[_loc4_] as Element;
            if(_loc2_.mEnabled)
            {
               if(_loc2_.getContainer() != null)
               {
                  _loc1_.push(_loc2_);
               }
            }
            _loc4_++;
         }
         if(this.mFloor.mEnabled)
         {
            if(this.mFloor.getContainer() != null)
            {
               _loc1_.push(this.mFloor);
            }
         }
         _loc1_ = this.sortObjects(_loc1_);
      }
      
      private function sortObjectsOld(param1:Array) : void
      {
         var _loc2_:Renderable = null;
         param1.sortOn("mY",Array.NUMERIC);
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1[_loc4_] as Renderable;
            this.mContainer.addChild(_loc2_.getContainer());
            _loc4_++;
         }
      }
      
      private function ySort(param1:Renderable, param2:Renderable) : int
      {
         if(param1.mY < param2.mY)
         {
            return -1;
         }
         if(param1.mY > param2.mY)
         {
            return 1;
         }
         return 0;
      }
      
      private function armySortObjects(param1:Array) : Boolean
      {
         var _loc3_:Renderable = null;
         var _loc4_:Renderable = null;
         var _loc7_:Renderable = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:Boolean = false;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            (_loc7_ = param1[_loc5_]).mSortIdx = _loc5_;
            _loc5_++;
         }
         param1.sort(this.ySort);
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            if(!(_loc7_ = param1[_loc6_]).mScene)
            {
               param1.splice(_loc6_,1);
               _loc2_ = true;
               _loc6_--;
            }
            else
            {
               _loc4_ = _loc7_.getCell().mObject;
               if((_loc7_ is PlayerUnit || _loc7_ is EnemyUnit || _loc7_ == this.mObjectBeingMoved) && Boolean(_loc4_))
               {
                  _loc8_ = param1.indexOf(_loc4_);
                  _loc9_ = param1.indexOf(_loc7_);
                  if(_loc8_ > _loc9_)
                  {
                     if(_loc9_ > -1)
                     {
                        param1.splice(_loc8_,1,_loc7_);
                        param1.splice(_loc9_,1,_loc4_);
                        _loc2_ = true;
                     }
                  }
               }
               if(_loc7_.mSortIdx != _loc5_)
               {
                  _loc2_ = true;
               }
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      private function sortObjects(param1:Array) : Array
      {
         var _loc3_:Renderable = null;
         var _loc4_:Renderable = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Renderable = null;
         var _loc11_:Renderable = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc2_:Array = new Array();
         param1.sortOn("mY",Array.NUMERIC);
         var _loc5_:int = int(this.mAllElements.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            (_loc4_ = this.mAllElements[_loc6_] as Renderable).mSorted = false;
            _loc6_++;
         }
         var _loc7_:int = 0;
         this.mSortingOrderChanged = false;
         do
         {
            if(param1.length <= 0)
            {
               return _loc2_;
            }
            _loc8_ = int(param1.length);
            _loc9_ = 0;
            while(_loc9_ < param1.length)
            {
               _loc10_ = param1[_loc9_];
               if(this.nothingBehind_Fast(param1,_loc10_))
               {
                  if(_loc10_.mSortIdx != _loc2_.length)
                  {
                     this.mSortingOrderChanged = true;
                  }
                  _loc10_.mSortIdx = _loc2_.length;
                  _loc10_.mSorted = true;
                  _loc2_.push(_loc10_);
                  param1.splice(_loc9_,1);
                  _loc7_ += _loc9_;
                  break;
               }
               _loc9_++;
            }
         }
         while(_loc8_ != param1.length);
         
         if(Config.DEBUG_MODE)
         {
            _loc12_ = int(param1.length);
            _loc13_ = 0;
            while(_loc13_ < _loc12_)
            {
               _loc11_ = param1[_loc13_] as Renderable;
               _loc13_++;
            }
         }
         return _loc2_;
      }
      
      public function removeObject(param1:Element, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc8_:GridCell = null;
         if(!param1)
         {
            return;
         }
         var _loc4_:Renderable = param1 as Renderable;
         if(Config.DEBUG_MODE)
         {
         }
         var _loc5_:int;
         if((_loc5_ = this.mAllElements.indexOf(param1)) >= 0)
         {
            this.mAllElements.splice(_loc5_,1);
         }
         if((_loc5_ = this.mVisibleObjects.indexOf(param1)) >= 0)
         {
            this.mVisibleObjects.splice(_loc5_,1);
         }
         if(_loc4_ != this.mObjectBeingMoved)
         {
            if(param3)
            {
               if(param1 is PlayerBuildingObject)
               {
                  this.decrementViewersForBuilding(PlayerBuildingObject(param1),PlayerBuildingObject(param1).getSightRangeAccordingToCondition());
               }
               else if(param1 is PlayerInstallationObject)
               {
                  this.decrementViewersForInstallation(PlayerInstallationObject(param1),PlayerInstallationObject(param1).getSightRangeAccordingToCondition());
               }
               else if(param1 is PlayerUnit)
               {
                  this.mFog.decrementUnitSightArea(PlayerUnit(param1));
               }
            }
         }
         var _loc6_:DynamicObject;
         if(_loc6_ = _loc4_ as DynamicObject)
         {
            _loc6_.removeFromGrid();
         }
         var _loc7_:DisplayContainer;
         if((_loc7_ = param1.getContainer()) != null)
         {
            if(_loc7_.parent)
            {
               _loc7_.parent.removeChild(_loc7_);
            }
         }
         param1.destroy();
         if(param2)
         {
            this.updateGridInformation();
            this.updateGridCharacterInfo();
            this.updateCursors(0,true);
            if(this.mGame.mState == GameState.STATE_SELL_ITEM)
            {
               this.mMapGUIEffectsLayer.highlightSellableObjects();
            }
            this.mGame.mMapData.mUpdateRequired = true;
         }
         if(_loc4_)
         {
            if(_loc4_.mKilledByFireMission)
            {
               for each(_loc8_ in this.getTilesUnderObject(_loc4_))
               {
                  this.mGame.spawnNewDebris("ScorchedGround","Debris",this.getCenterPointXOfCell(_loc8_),this.getCenterPointYOfCell(_loc8_));
               }
            }
            if(_loc4_ is SpawningBeaconObject)
            {
               this.findSpawningBeacon();
               this.resetSpawningBeaconTimer();
            }
         }
      }
      
      public function setSelectedObject(param1:Renderable) : void
      {
         this.mObjectBeingMoved = param1;
         this.mMapGUIEffectsLayer.highlightPlacingArea();
      }
      
      public function addIntel(param1:int, param2:int) : void
      {
         var _loc3_:int = this.getCenterPointXAtIJ(param1,param2);
         var _loc4_:int = this.getCenterPointYAtIJ(param1,param2);
         var _loc5_:Rectangle = new Rectangle(_loc3_,_loc4_,1,1);
         var _loc6_:Item = ItemManager.getItem("Intel1","Intel");
         var _loc7_:LootReward = new LootReward(_loc6_,1,_loc5_);
         this.mSceneHud.addChild(_loc7_);
      }
      
      public function addLootReward(param1:Item, param2:int, param3:DisplayObject) : void
      {
         var _loc4_:int = 0;
         var _loc5_:LootReward = null;
         if(param1 != null)
         {
            _loc4_ = 50;
            if(param1.mId == "Energy" || param1.mId == "SocialXP")
            {
               _loc4_ = 5;
            }
            else if(param1.mId == "XP")
            {
               _loc4_ = 2;
            }
            else if(param1.mId == "Water")
            {
               _loc4_ = 10;
            }
            if(param2 > 0)
            {
               while(param2 > 0)
               {
                  _loc5_ = new LootReward(param1,Math.min(_loc4_,param2),param3.getBounds(this.mContainer));
                  this.mSceneHud.addChild(_loc5_);
                  param2 -= _loc4_;
               }
            }
            else if(param2 < 0)
            {
               _loc5_ = new LootReward(param1,param2,param3.getBounds(this.mContainer));
               this.mSceneHud.addChild(_loc5_);
            }
         }
      }
      
      public function addNeighborAvatar(param1:NeighborActionQueue) : void
      {
         var _loc2_:NeighborAvatar = new NeighborAvatar(param1);
         if(!this.mNeighborAvatars)
         {
            this.mNeighborAvatars = new Array();
         }
         this.mNeighborAvatars.push(_loc2_);
         this.mSceneHud.addChild(_loc2_);
      }
      
      public function removeLootAndGetRewards() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:LootReward = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.mSceneHud.numChildren)
         {
            _loc2_ = this.mSceneHud.getChildAt(_loc1_);
            if(_loc2_ is LootReward)
            {
               _loc3_ = _loc2_ as LootReward;
               if(!_loc3_.mRewardGiven)
               {
                  _loc3_.getRewardFromLoot();
               }
               this.mSceneHud.removeChild(_loc3_);
               if(_loc3_.isIntel())
               {
                  MissionManager.increaseCounter("CollectIntel",_loc3_,1);
               }
               if(Config.DEBUG_MODE)
               {
               }
            }
            _loc1_++;
         }
      }
      
      private function updateHudObjects(param1:int) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:LootReward = null;
         var _loc6_:NeighborAvatar = null;
         var _loc7_:int = 0;
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.mSceneHud.numChildren)
         {
            if((_loc4_ = this.mSceneHud.getChildAt(_loc3_)) is LootReward)
            {
               (_loc5_ = _loc4_ as LootReward).Update(param1);
               if(_loc5_.canGiveReward())
               {
                  _loc5_.getRewardFromLoot();
               }
               if(_loc5_.canBeRemoved())
               {
                  _loc2_ = _loc4_;
                  if(_loc5_.isIntel())
                  {
                     MissionManager.increaseCounter("CollectIntel",_loc5_,1);
                  }
               }
            }
            else if(_loc4_ is NeighborAvatar)
            {
               (_loc6_ = _loc4_ as NeighborAvatar).update(param1);
               if(_loc6_.canBeRemoved())
               {
                  _loc2_ = _loc4_;
                  if((_loc7_ = this.mNeighborAvatars.indexOf(_loc6_)) >= 0)
                  {
                     this.mNeighborAvatars.splice(_loc7_,1);
                  }
               }
            }
            _loc3_++;
         }
         if(_loc2_ != null)
         {
            this.mSceneHud.removeChild(_loc2_);
            if(Config.DEBUG_MODE)
            {
            }
         }
      }
      
      public function getUncollectedSupplies() : int
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:LootReward = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.mSceneHud.numChildren)
         {
            _loc3_ = this.mSceneHud.getChildAt(_loc2_);
            if(_loc3_ is LootReward)
            {
               _loc4_ = _loc3_ as LootReward;
               _loc1_ += _loc4_.getSupplies();
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getUncollectedWater() : int
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:LootReward = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.mSceneHud.numChildren)
         {
            _loc3_ = this.mSceneHud.getChildAt(_loc2_);
            if(_loc3_ is LootReward)
            {
               _loc4_ = _loc3_ as LootReward;
               _loc1_ += _loc4_.getWater();
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function isLootRewardActivated() : Boolean
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.mSceneHud.numChildren)
         {
            _loc2_ = this.mSceneHud.getChildAt(_loc1_);
            if(_loc2_ is LootReward && (_loc2_ as LootReward).isActivated())
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function setTutorialHighlight(param1:int, param2:int, param3:int, param4:int = 0, param5:int = 0) : void
      {
         var _loc8_:Class = null;
         var _loc9_:MovieClip = null;
         var _loc6_:Number = this.getCenterPointXAtIJ(param2,param3);
         var _loc7_:Number = this.getCenterPointYAtIJ(param2,param3);
         if(param1 == TUTORIAL_HIGHLIGHT_CIRCLE)
         {
            _loc8_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"tutorial_circle_01");
         }
         else if(param1 == TUTORIAL_HIGHLIGHT_TARGET)
         {
            _loc8_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"tutorial_target_01");
         }
         else
         {
            _loc8_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"tutorial_mark_01");
         }
         this.mTutorialHighlight = new _loc8_();
         this.mTutorialHighlight.x = _loc6_;
         this.mTutorialHighlight.y = _loc7_;
         this.mTutorialHighlight.mouseEnabled = false;
         if(param1 == TUTORIAL_HIGHLIGHT_MOVE)
         {
            _loc9_ = new (_loc8_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"tutorial_circle_01"))();
            _loc9_.gotoAndStop(_loc9_.totalFrames);
            _loc9_.x = this.mGridDimX;
            _loc9_.y = this.mGridDimY * 2;
            this.mTutorialHighlight.addChild(_loc9_);
         }
         this.mSceneHud.addChild(this.mTutorialHighlight);
      }
      
      public function removeTutorialHighlight() : void
      {
         if(this.mTutorialHighlight)
         {
            this.mSceneHud.removeChild(this.mTutorialHighlight);
            this.mTutorialHighlight = null;
         }
      }
      
      public function disableMouse(param1:int, param2:int, param3:Boolean = false) : void
      {
         this.mMouseDisabled = true;
         this.mAllowMouseX = param1;
         this.mAllowMouseY = param2;
      }
      
      public function enableMouse() : void
      {
         this.mMouseDisabled = false;
         this.mAllowMouseX = -1;
         this.mAllowMouseY = -1;
      }
      
      public function initializeAfterLoading() : void
      {
         this.addFloorToScene();
         if(!Config.DISABLE_SORT)
         {
            this.sortStatic();
         }
         if(!this.mRelativeVisibleArea)
         {
            this.mAbsoluteVisibleArea = new Shape();
            this.mAbsoluteVisibleArea.graphics.clear();
            this.mAbsoluteVisibleArea.graphics.drawRect(0,0,this.mGame.getStageWidth(),this.mGame.getStageHeight());
            this.mRelativeVisibleArea = new Shape();
            this.mRelativeVisibleArea.graphics.clear();
            this.mRelativeVisibleArea.graphics.drawRect(-this.mGame.getStageWidth() / this.mContainer.scaleX / 2,-this.mGame.getStageHeight() / this.mContainer.scaleX / 2,this.mGame.getStageWidth() / this.mContainer.scaleX,this.mGame.getStageHeight() / this.mContainer.scaleX);
         }
      }
      
      public function calculateWalkManhattanDist(param1:IsometricCharacter, param2:Number, param3:Number) : int
      {
         var _loc4_:GridCell;
         if((_loc4_ = this.getCellAtLocation(param2,param3)) == null)
         {
            return 100000;
         }
         if(!_loc4_.mWalkable || _loc4_.mCharacter != null)
         {
            return 100000;
         }
         AStarPathfinder.findPathAStar(smTmpSolution,this,new Point(param1.mX,param1.mY),new Point(param2,param3),param1.mMovementFlags);
         if(smTmpSolution.length == 0)
         {
            return 100000;
         }
         var _loc5_:int = Math.abs(param1.mX - param2) / this.mGridDimX + Math.abs(param1.mY - param3) / this.mGridDimY;
         return Math.max(0.5 * smTmpSolution.length,_loc5_);
      }
      
      public function calculateWalkEuclidianDist(param1:IsometricCharacter, param2:Number, param3:Number) : int
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc4_:GridCell;
         if((_loc4_ = this.getCellAtLocation(param2,param3)) == null)
         {
            return 100000;
         }
         if(!_loc4_.mWalkable || _loc4_.mCharacter != null)
         {
            return 100000;
         }
         AStarPathfinder.findPathAStar(smTmpSolution,this,new Point(param1.mX,param1.mY),new Point(param2,param3),param1.mMovementFlags);
         if(smTmpSolution.length == 0)
         {
            return 100000;
         }
         var _loc5_:Number = param1.mX;
         var _loc6_:Number = param1.mY;
         var _loc9_:Number = 0;
         var _loc10_:int = int(smTmpSolution.length - 1);
         while(_loc10_ >= 0)
         {
            _loc7_ = Number(smTmpSolution[_loc10_ - 1]);
            _loc8_ = Number(smTmpSolution[_loc10_]);
            _loc9_ += Math.sqrt((_loc7_ - _loc5_) * (_loc7_ - _loc5_) + (_loc8_ - _loc6_) * (_loc8_ - _loc6_));
            _loc5_ = _loc7_;
            _loc6_ = _loc8_;
            _loc10_ -= 2;
         }
         return _loc9_;
      }
      
      public function fireActive(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:GridCell = null;
         if(this.mPlacePressed)
         {
            _loc2_ = this.mGridDimX * this.mFireItemX;
            _loc3_ = this.mGridDimY * this.mFireItemY;
            _loc4_ = this.getCellAtLocation(_loc2_,_loc3_);
            this.mGame.useFireMission(_loc4_,this.mFireItemX,this.mFireItemY,this.mGame.mFireMisssionToBePlaced);
            this.mPlacePressed = false;
         }
      }
      
      public function FloorClicked(param1:MouseEvent) : void
      {
         var _loc7_:PlayerUnit = null;
         var _loc8_:Element = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:PlayerUnit = null;
         var _loc12_:Array = null;
         var _loc13_:EnemyUnit = null;
         var _loc14_:PvPEnemyUnit = null;
         var _loc15_:Boolean = false;
         if(this.mMouseScrolling || this.mAnyScrollKeyPressed || this.mTickCrossActive)
         {
            return;
         }
         if(Config.DEBUG_MODE)
         {
         }
         var _loc2_:int = this.mGame.mState;
         this.mPointTmp.x = 0;
         this.mPointTmp.y = 0;
         var _loc3_:Point = this.mContainer.localToGlobal(this.mPointTmp);
         var _loc4_:int = _loc3_.x;
         var _loc5_:int = _loc3_.y;
         ToScreen.inverseTransform(this.mPointTmp,(param1.stageX - _loc4_) / this.mContainer.scaleX,(param1.stageY - _loc5_) / this.mContainer.scaleY,0);
         var _loc6_:GridCell = this.getCellAtLocation(this.mPointTmp.x,this.mPointTmp.y);
         this.mPreviousCursorCell = null;
         if(!this.isInsideVisibleArea(_loc6_) || this.mMouseDisabled && (this.mAllowMouseX != _loc6_.mPosI || this.mAllowMouseY != _loc6_.mPosJ))
         {
            ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ERROR);
            return;
         }
         param1.updateAfterEvent();
         switch(_loc2_)
         {
            case GameState.STATE_PVP:
            case GameState.STATE_PLAY:
               _loc7_ = this.mGame.mActivatedPlayerUnit;
               _loc9_ = int(this.mAllElements.length);
               _loc10_ = 0;
               while(_loc10_ < _loc9_)
               {
                  if((_loc8_ = this.mAllElements[_loc10_] as Element) is PlayerUnit)
                  {
                     _loc11_ = _loc8_ as PlayerUnit;
                     if(_loc6_ == _loc11_.getCell() && !(this.mGame.mCurrentAction is WalkingAction) && (this.mGame.mState != GameState.STATE_PVP || FeatureTuner.USE_PVP_MATCH && this.mGame.mPvPMatch.mPlayerTurn))
                     {
                        if(_loc11_.isAlive())
                        {
                           if(FeatureTuner.USE_PVP_MATCH && this.mGame.mPvPMatch.mActivatedBooster && this.mGame.mState == GameState.STATE_PVP)
                           {
                              _loc11_.useBooster(this.mGame.mPvPMatch.mActivatedBooster);
                              this.mGame.mPlayerProfile.mInventory.addItems(this.mGame.mPvPMatch.mActivatedBooster,-1);
                              this.mGame.mPvPMatch.mActivatedBooster = null;
                              this.mGame.mPvPHUD.mBoosterBar.addToScreen();
                           }
                           else
                           {
                              this.mGame.unActivatePlayerUnit();
                              this.mGame.activatePlayerUnit(_loc11_);
                              _loc12_ = new Array(_loc6_.mPosI,_loc6_.mPosJ);
                              MissionManager.increaseCounter("Select",_loc12_,1);
                           }
                           break;
                        }
                        if(MissionManager.isTutorialCompleted())
                        {
                           this.mGame.mHUD.openCorpseMarkerTextBox(_loc11_);
                        }
                     }
                  }
                  else
                  {
                     if(_loc8_ is EnemyUnit)
                     {
                        if((_loc13_ = _loc8_ as EnemyUnit).isAlive())
                        {
                           if(_loc6_ == _loc13_.getCell())
                           {
                              if(!_loc6_.hasFog())
                              {
                                 if(_loc13_.mState != IsometricCharacter.STATE_AIR_DROP)
                                 {
                                    if(this.isInsideVisibleArea(_loc6_))
                                    {
                                       if(!(this.mGame.mCurrentAction is WalkingAction))
                                       {
                                          if(GameState.smCheatCodeTyped && this.mGame.mCtrlPressed)
                                          {
                                             _loc13_.changeReactionState(EnemyUnit.REACT_STATE_BYPASS_THE_LINE);
                                          }
                                          else
                                          {
                                             this.mGame.attackEnemy(_loc13_);
                                             this.mGame.moveCameraToSeeRenderable(_loc13_);
                                          }
                                          break;
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                     if(FeatureTuner.USE_PVP_MATCH && _loc8_ is PvPEnemyUnit)
                     {
                        if((_loc14_ = _loc8_ as PvPEnemyUnit).isAlive())
                        {
                           if(_loc6_ == _loc14_.getCell())
                           {
                              if(!(this.mGame.mCurrentAction is WalkingAction))
                              {
                                 if(this.mGame.mPvPMatch.mPlayerTurn)
                                 {
                                    this.mGame.attackEnemy(_loc14_);
                                    this.mGame.moveCameraToSeeRenderable(_loc14_);
                                    break;
                                 }
                              }
                           }
                        }
                     }
                  }
                  _loc10_++;
               }
               if(_loc6_.mObject && !_loc6_.mCharacter && !(_loc6_.mObject is DebrisObject && _loc6_.mOwner == MapData.TILE_OWNER_ENEMY) && !(_loc7_ && _loc6_.mObject is DebrisObject) && !(Boolean(_loc7_) && _loc6_.mObject is ConstructionObject && ConstructionObject(_loc6_.mObject).getState() == PlayerBuildingObject.STATE_RUINS) && !(Boolean(_loc7_) && _loc6_.mObject is ResourceBuildingObject && ResourceBuildingObject(_loc6_.mObject).getState() == PlayerBuildingObject.STATE_RUINS))
               {
                  if(!(this.mGame.mCurrentAction is WalkingAction) || _loc6_.mObject is PlayerBuildingObject)
                  {
                     _loc6_.mObject.MousePressed(null);
                     this.mGame.unActivatePlayerUnit();
                  }
               }
               else if(_loc7_)
               {
                  if(!(_loc6_ != _loc7_.getCell() && !_loc6_.mCharacter))
                  {
                     ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ERROR);
                     this.mGame.unActivatePlayerUnit();
                     return;
                  }
                  _loc15_ = this.mGame.doPlayerWalkAction(this.getCenterPointXOfCell(_loc6_),this.getCenterPointYOfCell(_loc6_));
                  this.mGame.moveCameraToSeeCell(_loc6_);
                  this.mGame.unActivatePlayerUnit();
               }
               break;
            case GameState.STATE_PLACE_ITEM:
               if(!this.isCellEnableForMovingObject(_loc6_,false))
               {
                  ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ERROR);
               }
               break;
            case GameState.STATE_MOVE_ITEM:
               if(Boolean(_loc6_.mObject) && _loc6_.mObject.isMovable())
               {
                  if(!this.mObjectBeingMoved)
                  {
                     if(_loc6_.mObject.getMoveCostSupplies() > this.mGame.mPlayerProfile.mSupplies)
                     {
                        this.mGame.mHUD.openOutOfSuppliesTextBox([_loc6_.mObject.getMoveCostSupplies(),this.mGame.mPlayerProfile.mSupplies]);
                     }
                     else
                     {
                        this.setSelectedObject(_loc6_.mObject);
                        if(_loc6_.mObject is PlayerBuildingObject)
                        {
                           this.decrementViewersForBuilding(PlayerBuildingObject(_loc6_.mObject),PlayerBuildingObject(_loc6_.mObject).getSightRangeAccordingToCondition());
                        }
                        else if(_loc6_.mObject is PlayerInstallationObject)
                        {
                           this.decrementViewersForInstallation(PlayerInstallationObject(_loc6_.mObject),PlayerInstallationObject(_loc6_.mObject).getSightRangeAccordingToCondition());
                        }
                        this.mObjectBeingMovedStartX = _loc6_.mObject.mX;
                        this.mObjectBeingMovedStartY = _loc6_.mObject.mY;
                        this.mMouseScrolling = false;
                     }
                     param1.stopPropagation();
                  }
               }
               else
               {
                  ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ERROR);
               }
               break;
            case GameState.STATE_PICKUP_UNIT:
               if(Boolean(_loc6_.mCharacter) && _loc6_.mCharacter is PlayerUnit)
               {
                  if(this.mGame.checkIfUnitIsPickable(_loc6_.mCharacter as PlayerUnit))
                  {
                     this.mGame.mHUD.openRedeploymentConfirmationTextBox(_loc6_.mCharacter as PlayerUnit);
                  }
               }
               break;
            case GameState.STATE_REPAIR_ITEM:
               if(_loc6_.mCharacter && _loc6_.mCharacter is PlayerUnit && !_loc6_.mCharacter.isFullHealth())
               {
                  this.mGame.queueAction(new RepairPlayerUnitAction(_loc6_.mCharacter as PlayerUnit));
               }
               else if(_loc6_.mObject)
               {
                  if(_loc6_.mObject is ConstructionObject && !ConstructionObject(_loc6_.mObject).isFullHealth())
                  {
                     this.mGame.queueAction(new RepairConstructionAction(_loc6_.mObject as ConstructionObject));
                  }
                  else if(_loc6_.mObject is ResourceBuildingObject && !ResourceBuildingObject(_loc6_.mObject).isFullHealth())
                  {
                     this.mGame.queueAction(new RepairResourceBuildingAction(_loc6_.mObject as ResourceBuildingObject));
                  }
                  else if(_loc6_.mObject is DecorationObject && !(_loc6_.mObject is SignalObject) && !DecorationObject(_loc6_.mObject).isFullHealth())
                  {
                     this.mGame.queueAction(new RepairDecorationAction(_loc6_.mObject as DecorationObject));
                  }
                  else if(_loc6_.mObject is PlayerInstallationObject && !PlayerInstallationObject(_loc6_.mObject).isFullHealth())
                  {
                     this.mGame.queueAction(new RepairPlayerInstallationAction(_loc6_.mObject as PlayerInstallationObject));
                  }
                  else
                  {
                     ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ERROR);
                  }
               }
               else
               {
                  ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ERROR);
               }
               GameState.mInstance.mHUD.cancelTools();
               break;
            case GameState.STATE_SELL_ITEM:
               if(Boolean(_loc6_.mCharacter) && _loc6_.mCharacter is PlayerUnit)
               {
                  this.mGame.mHUD.openSellConfirmTextBox(_loc6_.mCharacter);
               }
               else if(_loc6_.mObject)
               {
                  if(_loc6_.mObject is ConstructionObject || _loc6_.mObject is DecorationObject || _loc6_.mObject is PlayerInstallationObject || _loc6_.mObject is HFEObject || _loc6_.mObject is HFEPlotObject || _loc6_.mObject is ResourceBuildingObject)
                  {
                     this.mGame.mHUD.openSellConfirmTextBox(_loc6_.mObject);
                  }
                  else
                  {
                     ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ERROR);
                  }
               }
               else
               {
                  ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ERROR);
               }
               break;
            case GameState.STATE_VISITING_NEIGHBOUR:
               if(_loc6_.mCharacter)
               {
                  _loc6_.mCharacter.MousePressed(null);
               }
               else if(Boolean(_loc6_.mObject) && (_loc6_.mObject is DebrisObject && _loc6_.mOwner == MapData.TILE_OWNER_FRIENDLY || _loc6_.mObject is HFEObject || _loc6_.mObject is PermanentHFEObject || _loc6_.mObject is ConstructionObject || _loc6_.mObject is ResourceBuildingObject))
               {
                  _loc6_.mObject.MousePressed(null);
               }
               else if(_loc6_.mObject && _loc6_.mObject is EnemyInstallationObject && !(_loc6_.mObject as EnemyInstallationObject).hasForceField())
               {
                  _loc6_.mObject.MousePressed(null);
               }
         }
      }
      
      private function printBoundingGrid() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc4_:GridCell = null;
      }
      
      public function updateGridInformation() : void
      {
         var _loc9_:Element = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Renderable = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:GridCell = null;
         var _loc18_:int = 0;
         this.mSizeX = this.mFloor.getGridRight();
         this.mSizeY = this.mFloor.getGridBottom();
         var _loc1_:Floor = this.mFloor;
         var _loc2_:int = 0;
         var _loc3_:int = this.mSizeY;
         var _loc4_:int = 0;
         var _loc5_:int = this.mSizeX;
         var _loc6_:int = this.mSizeX * this.mSizeY;
         var _loc7_:Array = this.mGame.mMapData.mGrid;
         var _loc8_:int = _loc4_;
         while(_loc8_ < _loc5_)
         {
            _loc10_ = _loc2_;
            while(_loc10_ < _loc3_)
            {
               if((_loc11_ = _loc10_ * this.mSizeX + _loc8_) < 0 || _loc11_ >= _loc6_)
               {
                  Utils.LogError("Piece of floor outside grid");
               }
               else
               {
                  (_loc7_[_loc11_] as GridCell).mWalkable = (_loc7_[_loc11_] as GridCell).mDefaultWalkable && MapData.isTilePassable((_loc7_[_loc11_] as GridCell).mType);
                  (_loc7_[_loc11_] as GridCell).mCharacter = null;
                  (_loc7_[_loc11_] as GridCell).mObject = null;
               }
               _loc10_++;
            }
            _loc8_++;
         }
         for each(_loc9_ in this.mAllElements)
         {
            if(_loc12_ = _loc9_ as Renderable)
            {
               if(!(_loc12_ is IsometricCharacter))
               {
                  _loc13_ = _loc12_.getTileSize().x;
                  _loc14_ = _loc12_.getTileSize().y;
                  _loc15_ = 0;
                  while(_loc15_ < _loc13_)
                  {
                     _loc16_ = 0;
                     while(_loc16_ < _loc14_)
                     {
                        if(_loc17_ = this.getCellAtLocation(_loc12_.mX + _loc15_ * this.mGridDimX,_loc12_.mY + _loc16_ * this.mGridDimY))
                        {
                           if(_loc17_.mObject)
                           {
                              Utils.LogError("ERROR: UpdateGridInformation - Overlapping objects in cell: " + _loc17_.mPosI + "," + _loc17_.mPosJ);
                              if(this.mAllowedToCheckMisplacedDebris)
                              {
                                 if(_loc17_.mObject is DebrisObject)
                                 {
                                    this.forceClearMisplacedDebris(_loc17_.mObject as DebrisObject);
                                 }
                              }
                           }
                           else if(Boolean(_loc17_.mCharacter) && !_loc12_.isWalkable())
                           {
                              Utils.LogError("ERROR: UpdateGridInformation - Overlapping object and character in cell: " + _loc17_.mPosI + "," + _loc17_.mPosJ);
                           }
                           _loc17_.mWalkable = _loc12_.isWalkable();
                           _loc17_.mObject = _loc12_;
                           if(this.mAllowedToCheckMisplacedDebris)
                           {
                              if(_loc12_ is DebrisObject)
                              {
                                 _loc18_ = this.mGame.mMapData.getType(_loc17_.mPosI,_loc17_.mPosJ);
                                 if(!MapData.isTilePassable(_loc18_))
                                 {
                                    this.forceClearMisplacedDebris(_loc12_ as DebrisObject);
                                 }
                              }
                           }
                        }
                        _loc16_++;
                     }
                     _loc15_++;
                  }
               }
            }
         }
         this.printBoundingGrid();
         this.mAllowedToCheckMisplacedDebris = false;
      }
      
      private function forceClearMisplacedDebris(param1:DebrisObject) : void
      {
         if(this.mGame.mPlayerProfile.mEnergy < 1)
         {
            return;
         }
         var _loc2_:DebrisItem = DebrisItem(param1.mItem);
         var _loc3_:int = _loc2_.mHitRewardXP;
         var _loc4_:int = _loc2_.mHitRewardMoney;
         var _loc5_:int = _loc2_.mHitRewardMaterial;
         var _loc6_:int = _loc2_.mHitRewardSupplies;
         var _loc7_:int = _loc2_.mHitRewardEnergy;
         _loc3_ += _loc2_.mKillRewardXP;
         _loc4_ += _loc2_.mKillRewardMoney;
         _loc5_ += _loc2_.mKillRewardMaterial;
         _loc6_ += _loc2_.mKillRewardSupplies;
         _loc7_ += _loc2_.mKillRewardEnergy;
         var _loc8_:Object = {
            "coord_x":param1.getCell().mPosI,
            "coord_y":param1.getCell().mPosJ,
            "item_hit_points":0,
            "cost_energy":1,
            "reward_xp":_loc3_,
            "reward_money":_loc4_,
            "reward_material":_loc5_,
            "reward_supplies":_loc6_,
            "reward_energy":_loc7_
         };
         this.mGame.mServer.serverCallServiceWithParameters(ServiceIDs.CLEAN_DEBRIS,_loc8_,false);
         param1.remove();
      }
      
      public function updateGridCharacterInfo() : void
      {
         var _loc8_:Element = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:GridCell = null;
         var _loc1_:int = 0;
         var _loc2_:int = this.mSizeY;
         var _loc3_:int = 0;
         var _loc4_:int = this.mSizeX;
         var _loc5_:int = this.mSizeX * this.mSizeY;
         var _loc6_:Array = this.mGame.mMapData.mGrid;
         var _loc7_:int = _loc3_;
         while(_loc7_ < _loc4_)
         {
            _loc9_ = _loc1_;
            while(_loc9_ < _loc2_)
            {
               if(!((_loc10_ = _loc9_ * this.mSizeX + _loc7_) < 0 || _loc10_ >= _loc5_))
               {
                  (_loc6_[_loc10_] as GridCell).mCharacter = null;
               }
               _loc9_++;
            }
            _loc7_++;
         }
         for each(_loc8_ in this.mAllElements)
         {
            if(_loc8_ is IsometricCharacter)
            {
               if((_loc11_ = this.getCellAtLocation(_loc8_.mX,_loc8_.mY)).mCharacter)
               {
                  if(Config.DEBUG_MODE)
                  {
                  }
               }
               else if(Boolean(_loc11_.mObject) && !_loc11_.mWalkable)
               {
                  Utils.LogError("ERROR: UpdateGridCharacterInfo - Overlapping character and object in cell: " + _loc11_.mPosI + "," + _loc11_.mPosJ);
               }
               _loc11_.mCharacter = _loc8_ as IsometricCharacter;
            }
         }
      }
      
      private function addObjectTo(param1:Array, param2:Renderable) : void
      {
         var _loc3_:int = 0;
         if(param2)
         {
            if(param2.mVisible)
            {
               if(!param2.mSorted)
               {
                  _loc3_ = param1.indexOf(param2);
                  if(_loc3_ < 0)
                  {
                     param1.push(param2);
                  }
               }
            }
         }
      }
      
      private function getObjectsFromTiles(param1:int, param2:int, param3:int, param4:int) : Array
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:GridCell = null;
         var _loc11_:Renderable = null;
         var _loc12_:Renderable = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc5_:Array = new Array();
         var _loc6_:Array = this.mGame.mMapData.mGrid;
         var _loc7_:int = param1;
         while(_loc7_ < param2)
         {
            _loc8_ = param3;
            while(_loc8_ < param4)
            {
               _loc9_ = _loc8_ * this.mSizeX + _loc7_;
               _loc11_ = (_loc10_ = _loc6_[_loc9_]).mObject;
               this.addObjectTo(_loc5_,_loc11_);
               _loc13_ = int(_loc10_.mDynamicObjects.length);
               _loc14_ = 0;
               while(_loc14_ < _loc13_)
               {
                  _loc12_ = _loc10_.mDynamicObjects[_loc14_] as Renderable;
                  this.addObjectTo(_loc5_,_loc12_);
                  _loc14_++;
               }
               _loc8_++;
            }
            _loc7_++;
         }
         return _loc5_;
      }
      
      private function dangerZoneAt(param1:Array, param2:Number, param3:Number) : Boolean
      {
         var _loc4_:MovieClip = null;
         var _loc5_:int = int(param1.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if((_loc4_ = param1[_loc6_] as MovieClip).x == param2)
            {
               if(_loc4_.y == param3)
               {
                  return true;
               }
            }
            _loc6_++;
         }
         return false;
      }
      
      protected function MouseEnteredObject(param1:MouseEvent) : void
      {
         var _loc2_:int = this.mGame.mState;
         var _loc3_:DisplayContainer = param1.currentTarget as DisplayContainer;
         var _loc4_:Renderable = _loc3_.getRenderableObject();
         switch(_loc2_)
         {
            case GameState.STATE_VISITING_NEIGHBOUR:
               break;
            case GameState.STATE_PVP:
            case GameState.STATE_PLAY:
               _loc4_.MouseOver(param1);
               break;
            case GameState.STATE_MOVE_ITEM:
            case GameState.STATE_PLACE_ITEM:
            case GameState.STATE_USE_INVENTORY_ITEM:
               if(_loc4_.isMovable())
               {
                  if(!this.mObjectBeingMoved)
                  {
                     _loc4_.MouseOver(param1);
                  }
               }
         }
      }
      
      protected function MouseExitedObject(param1:MouseEvent) : void
      {
         var _loc2_:DisplayContainer = param1.currentTarget as DisplayContainer;
         _loc2_.getRenderableObject().MouseOut(param1);
      }
      
      protected function MousePressedOnObject(param1:MouseEvent) : void
      {
         if(this.mGame.mActivatedPlayerUnit)
         {
            this.mGame.unActivatePlayerUnit();
            return;
         }
         var _loc2_:int = this.mGame.mState;
         var _loc3_:DisplayContainer = param1.currentTarget as DisplayContainer;
         var _loc4_:Renderable = _loc3_.getRenderableObject();
         switch(_loc2_)
         {
            case GameState.STATE_VISITING_NEIGHBOUR:
               break;
            case GameState.STATE_PVP:
            case GameState.STATE_PLAY:
               _loc4_.MousePressed(param1);
               break;
            case GameState.STATE_MOVE_ITEM:
               if(_loc4_.isMovable())
               {
                  if(!this.mObjectBeingMoved)
                  {
                     this.setSelectedObject(_loc4_);
                     if(_loc4_ is PlayerBuildingObject)
                     {
                        this.decrementViewersForBuilding(PlayerBuildingObject(_loc4_),PlayerBuildingObject(_loc4_).getSightRangeAccordingToCondition());
                     }
                     else if(_loc4_ is PlayerInstallationObject)
                     {
                        this.decrementViewersForInstallation(PlayerInstallationObject(_loc4_),PlayerInstallationObject(_loc4_).getSightRangeAccordingToCondition());
                     }
                     this.mObjectBeingMovedStartX = _loc4_.mX;
                     this.mObjectBeingMovedStartY = _loc4_.mY;
                     this.mMouseScrolling = false;
                     param1.stopPropagation();
                  }
               }
               break;
            case GameState.STATE_REPAIR_ITEM:
               break;
            case GameState.STATE_SELL_ITEM:
               if(_loc4_ is ConstructionObject || _loc4_ is DecorationObject || _loc4_ is PlayerInstallationObject || _loc4_ is HFEObject || _loc4_ is HFEPlotObject || _loc4_ is ResourceBuildingObject)
               {
                  this.mGame.mHUD.openSellConfirmTextBox(_loc4_);
               }
         }
      }
      
      public function getNeighboringCellsAtDistance(param1:IsometricCharacter, param2:int, param3:Array) : void
      {
         var _loc6_:int = 0;
         var _loc7_:GridCell = null;
         var _loc8_:int = 0;
         var _loc4_:GridCell = this.getCellAtLocation(param1.mX,param1.mY);
         param3.length = 0;
         var _loc5_:int = -param2;
         while(_loc5_ <= param2)
         {
            _loc6_ = -param2;
            while(_loc6_ <= param2)
            {
               if(_loc7_ = this.getCellAt(_loc4_.mPosI + _loc5_,_loc4_.mPosJ + _loc6_))
               {
                  if(_loc7_.mWalkable)
                  {
                     if(!_loc7_.mCharacter)
                     {
                        if((_loc8_ = this.calculateWalkManhattanDist(param1,(_loc4_.mPosI + _loc5_ + 0.5) * this.mGridDimX,(_loc4_.mPosJ + _loc6_ + 0.5) * this.mGridDimY)) <= param2)
                        {
                           param3.push(_loc7_);
                        }
                     }
                  }
               }
               _loc6_++;
            }
            _loc5_++;
         }
      }
      
      public function getNeighboringAvailableCellsAtChessboardDistance(param1:GridCell, param2:int) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:GridCell = null;
         var _loc3_:Array = new Array();
         var _loc4_:int = -param2;
         while(_loc4_ <= param2)
         {
            _loc5_ = -param2;
            while(_loc5_ <= param2)
            {
               if(_loc6_ = this.getCellAt(param1.mPosI + _loc4_,param1.mPosJ + _loc5_))
               {
                  if(_loc6_.mWalkable)
                  {
                     if(!_loc6_.mCharacter)
                     {
                        if(!_loc6_.mObject || _loc6_.mObject.isWalkable())
                        {
                           _loc3_.push(_loc6_);
                        }
                     }
                  }
               }
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function findGridLocation(param1:Number, param2:Number, param3:Point) : void
      {
         param3.x = Math.floor(param1 / this.mGridDimX);
         param3.y = Math.floor(param2 / this.mGridDimY);
      }
      
      public function findGridLocationX(param1:Number) : int
      {
         return Math.floor(param1 / this.mGridDimX);
      }
      
      public function findGridLocationY(param1:Number) : int
      {
         return Math.floor(param1 / this.mGridDimY);
      }
      
      public function getCellAt(param1:int, param2:int) : GridCell
      {
         if(param1 < 0 || param2 < 0 || param1 >= this.mSizeX || param2 >= this.mSizeY)
         {
            return null;
         }
         return this.mGame.mMapData.mGrid[param2 * this.mSizeX + param1];
      }
      
      public function getCellAtLocation(param1:int, param2:int) : GridCell
      {
         if(param1 < 0 || param2 < 0 || param1 >= this.mSizeX * this.mGridDimX || param2 >= this.mSizeY * this.mGridDimY)
         {
            return null;
         }
         var _loc3_:Array = this.mGame.mMapData.mGrid;
         if(!_loc3_)
         {
            return null;
         }
         return _loc3_[Math.floor(param2 / this.mGridDimY) * this.mSizeX + Math.floor(param1 / this.mGridDimX)];
      }
      
      public function getCenterPointXAtIJ(param1:int, param2:int) : Number
      {
         return (param1 + 0.5) * this.mGridDimX;
      }
      
      public function getCenterPointYAtIJ(param1:int, param2:int) : Number
      {
         return (param2 + 0.5) * this.mGridDimY;
      }
      
      public function getCenterPointXOfCell(param1:GridCell) : Number
      {
         return (param1.mPosI + 0.5) * this.mGridDimX;
      }
      
      public function getCenterPointYOfCell(param1:GridCell) : Number
      {
         return (param1.mPosJ + 0.5) * this.mGridDimY;
      }
      
      public function getLeftUpperXOfCell(param1:GridCell) : Number
      {
         return param1.mPosI * this.mGridDimX;
      }
      
      public function getLeftUpperYOfCell(param1:GridCell) : Number
      {
         return param1.mPosJ * this.mGridDimY;
      }
      
      public function getCellManhattanDistance(param1:GridCell, param2:GridCell) : int
      {
         return Math.abs(param1.mPosJ - param2.mPosJ) + Math.abs(param1.mPosI - param2.mPosI);
      }
      
      public function getCellChebyshevDistance(param1:GridCell, param2:GridCell) : int
      {
         return Math.max(Math.abs(param1.mPosJ - param2.mPosJ),Math.abs(param1.mPosI - param2.mPosI));
      }
      
      public function getFreeCellsInTheArea(param1:int, param2:int, param3:int, param4:int) : Array
      {
         var _loc7_:int = 0;
         var _loc8_:GridCell = null;
         var _loc5_:Array = new Array();
         var _loc6_:int = param1;
         while(_loc6_ < param1 + param3)
         {
            _loc7_ = param2;
            while(_loc7_ < param2 + param4)
            {
               if(_loc8_ = this.getCellAt(_loc6_,_loc7_))
               {
                  if(_loc8_.mWalkable)
                  {
                     if(!_loc8_.mCharacter)
                     {
                        if(!_loc8_.mObject || _loc8_.mObject.isWalkable())
                        {
                           _loc5_.push(_loc8_);
                        }
                     }
                  }
               }
               _loc7_++;
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public function findShortestChebyshev(param1:Renderable, param2:Renderable) : int
      {
         var _loc6_:GridCell = null;
         var _loc9_:GridCell = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc3_:Array = this.getTilesUnderObject(param1);
         var _loc4_:Array = this.getTilesUnderObject(param2);
         var _loc5_:int = this.mGridDimX;
         var _loc7_:int = int(_loc3_.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc6_ = _loc3_[_loc8_] as GridCell;
            _loc10_ = int(_loc4_.length);
            _loc11_ = 0;
            while(_loc11_ < _loc10_)
            {
               _loc9_ = _loc4_[_loc11_] as GridCell;
               if((_loc12_ = this.getCellChebyshevDistance(_loc6_,_loc9_)) < _loc5_)
               {
                  _loc5_ = _loc12_;
               }
               _loc11_++;
            }
            _loc8_++;
         }
         return _loc5_;
      }
      
      public function createObject(param1:MapItem, param2:Point) : Renderable
      {
         var _loc3_:Renderable = null;
         var _loc4_:GamePlayerProfile;
         var _loc5_:int = (_loc4_ = this.mGame.mPlayerProfile).getNextId();
         var _loc6_:Class;
         if((_loc6_ = param1.mObjectClass) == PlayerUnit || _loc6_ == EnemyUnit || _loc6_ == EnemyInstallationObject || _loc6_ == PlayerInstallationObject)
         {
            _loc3_ = new _loc6_(_loc5_,this,param1);
         }
         else
         {
            _loc3_ = new _loc6_(_loc5_,this,param1,param2);
            if(_loc3_ is ImportedObject)
            {
               (_loc3_ as ImportedObject).getInternalGraphicsLoaded();
               if(!(_loc3_ is PowerUpObject))
               {
                  (_loc3_ as ImportedObject).setPositionInternally();
               }
            }
            if(this.mObjectLoader.isHitAreaChanged())
            {
               _loc3_.getContainer().mouseEnabled = false;
            }
         }
         _loc3_.showHealthWarning(false);
         _loc3_.setTileSize(param1.mSize);
         _loc3_.setWalkable(param1.mWalkable);
         _loc3_.setPlaceableOnAllTiles(param1.mPlaceableOnAllTiles);
         this.addObject(_loc3_);
         return _loc3_;
      }
      
      public function addPowerUpToMap(param1:String, param2:GridCell) : PowerUpObject
      {
         var _loc4_:PowerUpObject = null;
         var _loc3_:MapItem = ItemManager.getItem(param1,"PowerUp") as MapItem;
         if(_loc3_)
         {
            return this.createObject(_loc3_,new Point(param2.mPosI,param2.mPosJ)) as PowerUpObject;
         }
         return null;
      }
      
      public function addRewardedPlayerUnit(param1:PlayerUnitItem, param2:GridCell) : void
      {
         var _loc3_:int = this.getCenterPointXOfCell(param2);
         var _loc4_:int = this.getCenterPointYOfCell(param2);
         var _loc5_:Renderable;
         (_loc5_ = this.createObject(param1,new Point(0,0))).setPos(_loc3_,_loc4_,0);
         _loc5_.getContainer().visible = true;
         _loc5_.mVisible = true;
         param2.mOwner = MapData.TILE_OWNER_FRIENDLY;
         this.mGame.mMapData.mUpdateRequired = true;
      }
      
      public function getObjectLoader() : ObjectLoader
      {
         return this.mObjectLoader;
      }
      
      public function getSurroundingFreeCell(param1:int, param2:int) : GridCell
      {
         var _loc4_:MapArea = null;
         var _loc5_:Array = null;
         var _loc6_:GridCell = null;
         var _loc7_:int = 0;
         var _loc3_:GridCell = this.getCellAtLocation(param1,param2);
         if(_loc3_)
         {
            _loc5_ = (_loc4_ = MapArea.getAreaAroundCell(this,_loc3_,1)).getCells();
            _loc7_ = 0;
            while(_loc7_ < _loc5_.length)
            {
               if(!(_loc6_ = _loc5_[_loc7_]).mCharacter && !_loc6_.mObject)
               {
                  return _loc6_;
               }
               _loc7_++;
            }
         }
         return null;
      }
      
      public function isInAttackRange(param1:Renderable) : Boolean
      {
         var _loc2_:Array = this.mGame.searchUnitsInRange(param1);
         if(_loc2_)
         {
            if(_loc2_.length > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function destroy() : void
      {
         var _loc1_:Renderable = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         this.mContainer.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this.mContainer.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.mContainer.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         this.mContainer.removeEventListener(TransformGestureEvent.GESTURE_ZOOM,this.ZoomInOut);
         CursorManager.getInstance().clean();
         while(this.mContainer.numChildren > 0)
         {
            this.mContainer.removeChildAt(0);
         }
         if(this.mContainer.parent)
         {
            this.mContainer.parent.removeChild(this.mContainer);
            this.mContainer = null;
         }
         this.removeLootAndGetRewards();
         while(this.mSceneHud.numChildren > 0)
         {
            this.mSceneHud.removeChildAt(0);
         }
         if(this.mSceneHud.parent)
         {
            this.mSceneHud.parent.removeChild(this.mSceneHud);
            this.mSceneHud = null;
         }
         if(this.mTilemapGraphic)
         {
            this.mTilemapGraphic.destroy();
            this.mTilemapGraphic = null;
         }
         for(_loc2_ in this.mAllElements)
         {
            (this.mAllElements[_loc2_] as Element).destroy();
            this.mAllElements[_loc2_] = null;
         }
         this.mAllElements = null;
         for(_loc3_ in this.mSoundMakers)
         {
            (this.mSoundMakers[_loc3_] as Renderable).destroy();
            this.mSoundMakers[_loc3_] = null;
         }
         this.mSoundMakers = null;
         this.mFog.destroy();
         this.mFog = null;
         this.mFloor.destroy();
         this.mFloor = null;
         this.mMapGUIEffectsLayer.destroy();
         this.mMapGUIEffectsLayer = null;
         this.mGame = null;
      }
      
      public function characterArrivedInCell(param1:IsometricCharacter, param2:GridCell, param3:Boolean = true) : void
      {
         if(param1.isInOpponentsTile())
         {
            this.changeCellOwner(param2);
         }
         if(param1 is PlayerUnit)
         {
            this.mGame.updateWalkableCellsForActiveCharacter();
            if(param3)
            {
               this.mGame.setEnemyInstallationsToAttack(param1 as PlayerUnit);
            }
         }
         else if(param1 is EnemyUnit)
         {
            if(param3)
            {
               this.mGame.setPlayerInstallationsToAttack(param1 as EnemyUnit);
            }
         }
         if(param2.mPowerUp)
         {
            param2.mPowerUp.execute(param1);
            this.removeObject(param2.mPowerUp,true,false);
         }
      }
      
      public function incrementViewersForBuilding(param1:PlayerBuildingObject, param2:int) : void
      {
         var _loc4_:GridCell = null;
         var _loc3_:Array = this.getTilesUnderObjectSightArea(param1,param2);
         var _loc5_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = _loc3_[_loc6_] as GridCell;
            if(this.isInsideVisibleArea(_loc4_))
            {
               this.mFog.incrementViewersForCell(_loc4_);
            }
            _loc6_++;
         }
      }
      
      public function incrementViewersForInstallation(param1:PlayerInstallationObject, param2:int) : void
      {
         var _loc4_:GridCell = null;
         var _loc3_:Array = this.getTilesUnderObjectSightArea(param1,param2);
         var _loc5_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = _loc3_[_loc6_] as GridCell;
            if(this.isInsideVisibleArea(_loc4_))
            {
               this.mFog.incrementViewersForCell(_loc4_);
            }
            _loc6_++;
         }
      }
      
      public function decrementViewersForBuilding(param1:PlayerBuildingObject, param2:int) : void
      {
         var _loc4_:GridCell = null;
         var _loc3_:Array = this.getTilesUnderObjectSightArea(param1,param2);
         var _loc5_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = _loc3_[_loc6_] as GridCell;
            if(this.isInsideVisibleArea(_loc4_))
            {
               this.mFog.decrementViewersForCell(_loc4_);
            }
            _loc6_++;
         }
      }
      
      public function decrementViewersForInstallation(param1:PlayerInstallationObject, param2:int) : void
      {
         var _loc4_:GridCell = null;
         var _loc3_:Array = this.getTilesUnderObjectSightArea(param1,param2);
         var _loc5_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = _loc3_[_loc6_] as GridCell;
            if(this.isInsideVisibleArea(_loc4_))
            {
               this.mFog.decrementViewersForCell(_loc4_);
            }
            _loc6_++;
         }
      }
      
      private function changeCellOwner(param1:GridCell) : void
      {
         var _loc2_:Array = null;
         if(param1.mOwner != MapData.TILE_OWNER_NEUTRAL)
         {
            if(param1.mOwner == MapData.TILE_OWNER_ENEMY)
            {
               param1.mOwner = MapData.TILE_OWNER_FRIENDLY;
               _loc2_ = new Array(param1.mPosI,param1.mPosJ);
               MissionManager.increaseCounter("Conquer",_loc2_,1);
            }
            else
            {
               param1.mOwner = MapData.TILE_OWNER_ENEMY;
               _loc2_ = new Array(param1.mPosI,param1.mPosJ);
               MissionManager.increaseCounter("Conquer",_loc2_,-1);
            }
            this.mGame.mMapData.mUpdateRequired = true;
         }
      }
      
      public function dumpWorldObjects() : void
      {
         var _loc2_:Element = null;
         var _loc5_:Renderable = null;
         var _loc6_:Item = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:int = 1;
         var _loc3_:int = int(this.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mAllElements[_loc4_] as Element;
            if(_loc5_ = _loc2_ as Renderable)
            {
               if(_loc6_ = _loc5_.mItem)
               {
                  _loc7_ = 0;
                  if(_loc6_ is DebrisItem)
                  {
                  }
                  _loc8_ = int(_loc5_.mX / this.mGridDimX);
                  _loc9_ = int(_loc5_.mY / this.mGridDimY);
                  _loc1_++;
               }
            }
            _loc4_++;
         }
      }
      
      public function buildingExists(param1:String) : Boolean
      {
         var _loc2_:Renderable = null;
         var _loc3_:int = int(this.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mAllElements[_loc4_] as Renderable;
            if(_loc2_ is ConstructionObject)
            {
               if(ConstructionObject(_loc2_).mHasBeenCompleted)
               {
                  if(_loc2_.mItem.mId == param1)
                  {
                     return true;
                  }
               }
            }
            if(_loc2_ is ResourceBuildingObject)
            {
               if(_loc2_.mItem.mId == param1)
               {
                  return true;
               }
            }
            _loc4_++;
         }
         return false;
      }
      
      public function chooseCellClosestToCell(param1:Array, param2:GridCell) : GridCell
      {
         var _loc3_:int = 0;
         var _loc4_:GridCell = null;
         var _loc5_:GridCell = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param2 && param1 && param1.length > 0)
         {
            _loc3_ = int.MAX_VALUE;
            _loc4_ = param1[0];
            _loc6_ = int(param1.length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               if((_loc5_ = param1[_loc7_] as GridCell) != param2)
               {
                  if((_loc8_ = Math.abs(param2.mPosI - _loc5_.mPosI) + Math.abs(param2.mPosJ - _loc5_.mPosJ)) < _loc3_)
                  {
                     _loc3_ = _loc8_;
                     _loc4_ = _loc5_;
                  }
               }
               _loc7_++;
            }
            return _loc4_;
         }
         return null;
      }
      
      public function chooseCellClosestToCellAvoidingPlayers(param1:Array, param2:GridCell) : GridCell
      {
         var _loc3_:int = 0;
         var _loc4_:GridCell = null;
         var _loc5_:GridCell = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:PlayerUnit = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         if(param2 && param1 && param1.length > 0)
         {
            _loc3_ = int.MAX_VALUE;
            _loc4_ = param1[0];
            _loc6_ = int(param1.length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               if((_loc5_ = param1[_loc7_] as GridCell) != param2)
               {
                  _loc8_ = Math.abs(param2.mPosI - _loc5_.mPosI) + Math.abs(param2.mPosJ - _loc5_.mPosJ);
                  _loc11_ = int((_loc9_ = this.mGame.mPvPMatch.mAI.searchCellAttackablePlayerUnits(_loc5_)).length);
                  _loc12_ = 0;
                  while(_loc12_ < _loc11_)
                  {
                     _loc10_ = _loc9_[_loc12_] as PlayerUnit;
                     _loc8_ *= 1.4;
                     _loc12_++;
                  }
                  if(_loc8_ < _loc3_)
                  {
                     _loc3_ = _loc8_;
                     _loc4_ = _loc5_;
                  }
               }
               _loc7_++;
            }
            return _loc4_;
         }
         return null;
      }
   }
}
