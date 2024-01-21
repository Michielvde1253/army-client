package game.battlefield
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.characters.EnemyUnit;
   import game.gameElements.PermanentHFEObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.SceneLoader;
   import game.isometric.camera.IsoCamera;
   import game.isometric.elements.Renderable;
   import game.states.GameState;
   import game.utils.Random;
   
   public class TileMapGraphic
   {
      
      private static var mDrawMatrix:Matrix = new Matrix();
      
      private static var smTempPoint:Point = new Point();
      
      private static const COAST_S_FRIENDLY_UP:int = 0;
      
      private static const COAST_S_ENEMY_UP:int = 1;
      
      private static const COAST_S_FRIENDLY_LEFT:int = 2;
      
      private static const COAST_S_FRIENDLY_RIGHT:int = 3;
      
      private static const COAST_S_FRIENDLY_LEFT_RIGHT:int = 4;
      
      private static const COAST_N_FRIENDLY_DOWN:int = 0;
      
      private static const COAST_N_ENEMY_DOWN:int = 1;
      
      private static const COAST_N_FRIENDLY_LEFT:int = 2;
      
      private static const COAST_N_FRIENDLY_RIGHT:int = 3;
      
      private static const COAST_N_FRIENDLY_LEFT_RIGHT:int = 4;
      
      private static const COAST_W_FRIENDLY_RIGHT:int = 0;
      
      private static const COAST_W_ENEMY_RIGHT:int = 1;
      
      private static const COAST_W_FRIENDLY_UP:int = 2;
      
      private static const COAST_W_FRIENDLY_DOWN:int = 3;
      
      private static const COAST_W_FRIENDLY_UP_DOWN:int = 4;
      
      private static const COAST_E_FRIENDLY_LEFT:int = 0;
      
      private static const COAST_E_ENEMY_LEFT:int = 1;
      
      private static const COAST_E_FRIENDLY_UP:int = 2;
      
      private static const COAST_E_FRIENDLY_DOWN:int = 3;
      
      private static const COAST_E_FRIENDLY_UP_DOWN:int = 4;
      
      private static const COAST_CORNER_FRIENDLY:int = 0;
      
      private static const COAST_CORNER_ENEMY:int = 1;
      
      private static const COAST_CORNER_INSIDE_1:int = 0;
      
      private static const COAST_CORNER_INSIDE_2:int = 1;
      
      private static const COAST_CORNER_INSIDE_3:int = 2;
      
      private static const COAST_CORNER_INSIDE_4:int = 3;
      
      private static const COAST_CORNER_INSIDE_5:int = 4;
      
      private static const COAST_CORNER_INSIDE_6:int = 5;
      
      private static const COAST_CORNER_INSIDE_7:int = 6;
      
      private static const COAST_CORNER_INSIDE_8:int = 7;
      
      private static const COAST_CORNER_INSIDE_9:int = 8;
      
      private static const COAST_CORNER_INSIDE_10:int = 9;
      
      private static const COAST_CORNER_INSIDE_11:int = 10;
      
      private static const COAST_CORNER_INSIDE_12:int = 11;
      
      private static const COAST_CORNER_INSIDE_13:int = 12;
      
      private static const EDGE_TL_DENT:int = 0;
      
      private static const EDGE_TL_SHARP:int = 1;
      
      private static const EDGE_TR_DENT:int = 2;
      
      private static const EDGE_TR_SHARP:int = 3;
      
      private static const EDGE_BL_DENT:int = 4;
      
      private static const EDGE_BL_SHARP:int = 5;
      
      private static const EDGE_BR_DENT:int = 6;
      
      private static const EDGE_BR_SHARP:int = 7;
      
      private static const EDGE_TOP_FULL:int = 8;
      
      private static const EDGE_TOP_SHORT:int = 9;
      
      private static const EDGE_TOP_SHORT_L:int = 10;
      
      private static const EDGE_TOP_SHORT_R:int = 11;
      
      private static const EDGE_BOTTOM_FULL:int = 12;
      
      private static const EDGE_BOTTOM_SHORT:int = 13;
      
      private static const EDGE_BOTTOM_SHORT_L:int = 14;
      
      private static const EDGE_BOTTOM_SHORT_R:int = 15;
      
      private static const EDGE_LEFT_FULL:int = 16;
      
      private static const EDGE_LEFT_SHORT:int = 17;
      
      private static const EDGE_LEFT_SHORT_T:int = 18;
      
      private static const EDGE_LEFT_SHORT_B:int = 19;
      
      private static const EDGE_RIGHT_FULL:int = 20;
      
      private static const EDGE_RIGHT_SHORT:int = 21;
      
      private static const EDGE_RIGHT_SHORT_T:int = 22;
      
      private static const EDGE_RIGHT_SHORT_B:int = 23;
      
      private static const EDGE_FULL:int = 24;
      
      public static const CLOUD_INDEX_FULL:int = 0;
      
      public static const CLOUD_INDEX_C_TL:int = 1;
      
      public static const CLOUD_INDEX_TOP:int = 2;
      
      public static const CLOUD_INDEX_C_TR:int = 3;
      
      public static const CLOUD_INDEX_LEFT:int = 4;
      
      public static const CLOUD_INDEX_RIGHT:int = 5;
      
      public static const CLOUD_INDEX_C_BL:int = 6;
      
      public static const CLOUD_INDEX_BOTTOM:int = 7;
      
      public static const CLOUD_INDEX_C_BR:int = 8;
      
      public static const CLOUD_INDEX_TL:int = 9;
      
      public static const CLOUD_INDEX_TR:int = 10;
      
      public static const CLOUD_INDEX_BL:int = 11;
      
      public static const CLOUD_INDEX_BR:int = 12;
      
      public static const CLOUD_INDEX_NONE:int = 13;
      
      public static const CLOUD_BIT_NONE:int = -1;
      
      public static const CLOUD_BIT_LEFT:int = 1;
      
      public static const CLOUD_BIT_RIGHT:int = 2;
      
      public static const CLOUD_BIT_TOP:int = 4;
      
      public static const CLOUD_BIT_BOTTOM:int = 8;
      
      public static const CLOUD_BIT_CONVEX_TL:int = 16;
      
      public static const CLOUD_BIT_CONVEX_TR:int = 32;
      
      public static const CLOUD_BIT_CONVEX_BL:int = 64;
      
      public static const CLOUD_BIT_CONVEX_BR:int = 128;
      
      public static const CLOUD_BIT_TL:int = 256;
      
      public static const CLOUD_BIT_TR:int = 512;
      
      public static const CLOUD_BIT_BL:int = 1024;
      
      public static const CLOUD_BIT_BR:int = 2048;
      
      public static const CLOUD_BIT_FULL:int = 0;
      
      private static const TRANSITION_TOP_LEFT:int = 3;
      
      private static const TRANSITION_TOP_RIGHT:int = 2;
      
      private static const TRANSITION_BOTTOM_LEFT:int = 1;
      
      private static const TRANSITION_BOTTOM_RIGHT:int = 0;
      
      private static const TRANSITION_TOP:int = 4;
      
      private static const TRANSITION_BOTTOM:int = 5;
      
      private static const TRANSITION_LEFT:int = 6;
      
      private static const TRANSITION_RIGHT:int = 7;
      
      private static var TILES_CATEGORIES:Array;
      
      private static var TILES_CATEGORIES_ENEMY:Array;
      
      private static var TILES_FOG:Array;
      
      private static var TILES_OVERLAYS:Array;
      
      private static var TILES_OVERLAYS_ENEMY:Array;
      
      private static var TILES_BORDER:Array;
      
      private static var TILES_CLOUD:Array;
      
      private static var TILES_TRANSITION:Array;
      
      private static const EMPTY_DISP_OBJECT:Shape = new Shape();
       
      
      private var mUid:int;
      
      public var mWaveContainer:Sprite;
      
      private var mRandom:Random;
      
      private var mScene:IsometricScene;
      
      private var mMapData:MapData;
      
      private var mGrid:Array;
      
      private var mFieldMovieClip:MovieClip;
      
      private var mFieldBmpArray:Array;
      
      private var mFogMovieClip:MovieClip;
      
      private var mFogBmpArray:Array;
      
      private var mTargetBitmapArray:Array;
      
      private var mTargetMovieClip:MovieClip;
      
      public var mFieldBmp:Bitmap;
      
      private var mFieldBmpData:BitmapData;
      
      public var mFogBmp:Bitmap;
      
      private var mFogBmpData:BitmapData;
      
      private var mTargetBitmap:Bitmap;
      
      private var mSizeX:int;
      
      private var mDOs:Array;
      
      private var mBitmaps:Array;
      
      private var mBitmapOffsets:Array;
      
      private var EMPTY_BITMAPDATA:BitmapData;
      
      private var EMPTY_OFFSETS:Array;
      
      private var mBlitCounter:int = 0;
      
      private var mVectCounter:int = 0;
      
      public function TileMapGraphic(param1:IsometricScene)
      {
         this.EMPTY_BITMAPDATA = new BitmapData(SceneLoader.GRID_CELL_SIZE,SceneLoader.GRID_CELL_SIZE,true,2147483776);
         this.EMPTY_OFFSETS = [0,0];
         super();
         this.mScene = param1;
         this.mSizeX = param1.mSizeX;
         this.mMapData = GameState.mInstance.mMapData;
         this.mGrid = this.mMapData.mGrid;
         initArrays();
         this.createBitmaps();
         this.generateLayers();
         if(FeatureTuner.USE_SEA_WAVES_EFFECT)
         {
            this.mWaveContainer = new Sprite();
         }
      }
      
      public static function getVisibleArea() : Rectangle
      {
         var _loc1_:IsometricScene = GameState.mInstance.mScene;
         var _loc2_:IsoCamera = _loc1_.mCamera;
         var _loc3_:Number = GameState.mInstance.getStageWidth();
         var _loc4_:Number = GameState.mInstance.getStageHeight();
         var _loc5_:Number = _loc2_.getCameraX();
         var _loc6_:Number = _loc2_.getCameraY();
         var _loc7_:Number = _loc1_.mContainer.scaleX;
         var _loc8_:int = Math.max(0,_loc5_ - _loc3_ / 2 / _loc7_) / _loc1_.mGridDimX;
         var _loc9_:int = Math.max(0,_loc6_ - _loc4_ / 2 / _loc7_) / _loc1_.mGridDimY;
         var _loc10_:int = Math.min(_loc1_.mSizeX * _loc1_.mGridDimX,_loc5_ + _loc3_ / 2 / _loc7_ + _loc1_.mGridDimX) / _loc1_.mGridDimX;
         var _loc11_:int = Math.min(_loc1_.mSizeY * _loc1_.mGridDimY,_loc6_ + _loc4_ / 2 / _loc7_ + _loc1_.mGridDimY) / _loc1_.mGridDimY;
         return new Rectangle(_loc8_,_loc9_,_loc10_ - _loc8_,_loc11_ - _loc9_);
      }
      
      private static function initArrays() : void
      {
         var _loc2_:Object = null;
         TILES_CATEGORIES = new Array();
         TILES_CATEGORIES_ENEMY = new Array();
         TILES_OVERLAYS = new Array();
         TILES_OVERLAYS_ENEMY = new Array();
         TILES_FOG = new Array();
         TILES_BORDER = new Array();
         TILES_CLOUD = new Array();
         TILES_TRANSITION = new Array();
         var _loc1_:Object = GameState.mConfig.TileType;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.GraphicsFriendly)
            {
               if(_loc2_.GraphicsFriendly is Array)
               {
                  TILES_CATEGORIES[_loc2_.ID] = _loc2_.GraphicsFriendly;
               }
               else
               {
                  TILES_CATEGORIES[_loc2_.ID] = new Array();
                  (TILES_CATEGORIES[_loc2_.ID] as Array).push(_loc2_.GraphicsFriendly);
               }
            }
            if(_loc2_.GraphicsEnemy)
            {
               if(_loc2_.GraphicsEnemy is Array)
               {
                  TILES_CATEGORIES_ENEMY[_loc2_.ID] = _loc2_.GraphicsEnemy;
               }
               else
               {
                  TILES_CATEGORIES_ENEMY[_loc2_.ID] = new Array();
                  (TILES_CATEGORIES_ENEMY[_loc2_.ID] as Array).push(_loc2_.GraphicsEnemy);
               }
            }
            if(_loc2_.OverlaysFriendly)
            {
               if(_loc2_.OverlaysFriendly is Array)
               {
                  TILES_OVERLAYS[_loc2_.ID] = _loc2_.OverlaysFriendly;
               }
               else
               {
                  TILES_OVERLAYS[_loc2_.ID] = new Array();
                  (TILES_OVERLAYS[_loc2_.ID] as Array).push(_loc2_.OverlaysFriendly);
               }
            }
            if(_loc2_.OverlaysEnemy)
            {
               if(_loc2_.OverlaysEnemy is Array)
               {
                  TILES_OVERLAYS_ENEMY[_loc2_.ID] = _loc2_.OverlaysEnemy;
               }
               else
               {
                  TILES_OVERLAYS_ENEMY[_loc2_.ID] = new Array();
                  (TILES_OVERLAYS_ENEMY[_loc2_.ID] as Array).push(_loc2_.OverlaysEnemy);
               }
            }
         }
         TILES_FOG[0] = ["swf/tiles_common/Bg_FogTile_10","swf/tiles_common/Bg_FogTile_09","swf/tiles_common/Bg_FogTile_12","swf/tiles_common/Bg_FogTile_07","swf/tiles_common/Bg_FogTile_15","swf/tiles_common/Bg_FogTile_04","swf/tiles_common/Bg_FogTile_17","swf/tiles_common/Bg_FogTile_02","swf/tiles_common/Bg_FogTile_08","swf/tiles_common/Bg_FogTile_11","swf/tiles_common/Bg_FogTile_22","swf/tiles_common/Bg_FogTile_18","swf/tiles_common/Bg_FogTile_03","swf/tiles_common/Bg_FogTile_16","swf/tiles_common/Bg_FogTile_21","swf/tiles_common/Bg_FogTile_25","swf/tiles_common/Bg_FogTile_06","swf/tiles_common/Bg_FogTile_13","swf/tiles_common/Bg_FogTile_19","swf/tiles_common/Bg_FogTile_23","swf/tiles_common/Bg_FogTile_05","swf/tiles_common/Bg_FogTile_14","swf/tiles_common/Bg_FogTile_24","swf/tiles_common/Bg_FogTile_20","swf/tiles_common/Bg_FogTile_01"];
         TILES_BORDER[0] = ["swf/tiles_common/Bg_BorderTile_14","swf/tiles_common/Bg_BorderTile_09","swf/tiles_common/Bg_BorderTile_16","swf/tiles_common/Bg_BorderTile_07","swf/tiles_common/Bg_BorderTile_20","swf/tiles_common/Bg_BorderTile_03","swf/tiles_common/Bg_BorderTile_22","swf/tiles_common/Bg_BorderTile_01","swf/tiles_common/Bg_BorderTile_23","swf/tiles_common/Bg_BorderTile_15","swf/tiles_common/Bg_BorderTile_39","swf/tiles_common/Bg_BorderTile_35","swf/tiles_common/Bg_BorderTile_26","swf/tiles_common/Bg_BorderTile_21","swf/tiles_common/Bg_BorderTile_38","swf/tiles_common/Bg_BorderTile_42","swf/tiles_common/Bg_BorderTile_24","swf/tiles_common/Bg_BorderTile_17","swf/tiles_common/Bg_BorderTile_36","swf/tiles_common/Bg_BorderTile_40","swf/tiles_common/Bg_BorderTile_25","swf/tiles_common/Bg_BorderTile_19","swf/tiles_common/Bg_BorderTile_41","swf/tiles_common/Bg_BorderTile_37"];
         TILES_CLOUD[0] = ["swf/tiles_common/Bg_CloudTile_01","swf/tiles_common/Bg_CloudTile_02","swf/tiles_common/Bg_CloudTile_03","swf/tiles_common/Bg_CloudTile_04","swf/tiles_common/Bg_CloudTile_05","swf/tiles_common/Bg_CloudTile_06","swf/tiles_common/Bg_CloudTile_07","swf/tiles_common/Bg_CloudTile_08","swf/tiles_common/Bg_CloudTile_09","swf/tiles_common/Bg_CloudTile_10","swf/tiles_common/Bg_CloudTile_12","swf/tiles_common/Bg_CloudTile_15","swf/tiles_common/Bg_CloudTile_17"];
         TILES_TRANSITION[MapData.TILE_MAP_TYPE_GRASSLANDS] = ["swf/new_backgroud_01/Bg_TransitionTile_02","swf/new_backgroud_01/Bg_TransitionTile_04","swf/new_backgroud_01/Bg_TransitionTile_07","swf/new_backgroud_01/Bg_TransitionTile_09","swf/new_backgroud_01/Bg_TransitionTile_08","swf/new_backgroud_01/Bg_TransitionTile_03","swf/new_backgroud_01/Bg_TransitionTile_06","swf/new_backgroud_01/Bg_TransitionTile_05"];
         TILES_TRANSITION[MapData.TILE_MAP_TYPE_DESERT] = ["swf/desert_backgroud_01/Bg_TransitionTile_02","swf/desert_backgroud_01/Bg_TransitionTile_04","swf/desert_backgroud_01/Bg_TransitionTile_07","swf/desert_backgroud_01/Bg_TransitionTile_09","swf/desert_backgroud_01/Bg_TransitionTile_08","swf/desert_backgroud_01/Bg_TransitionTile_03","swf/desert_backgroud_01/Bg_TransitionTile_06","swf/desert_backgroud_01/Bg_TransitionTile_05"];
      }
      
      private function initSingleTileMapDataStructures() : void
      {
         var _loc1_:int = int(GameState.mInstance.getMainClip().stage.fullScreenWidth);
         var _loc2_:int = int(GameState.mInstance.getMainClip().stage.fullScreenHeight);
         _loc1_ = Math.max(_loc1_,Config.SCREEN_WIDTH);
         _loc2_ = Math.max(_loc2_,Config.SCREEN_HEIGHT);
         this.mFogBmpData = new BitmapData(_loc1_,_loc2_,true,16711935);
         this.mFieldBmpData = new BitmapData(_loc1_,_loc2_,false,255);
         if(this.mFogBmp)
         {
            this.mFogBmp.bitmapData.dispose();
            if(this.mFogBmp.parent)
            {
               this.mFogBmp.parent.removeChild(this.mFogBmp);
            }
         }
         if(this.mFieldBmp)
         {
            this.mFieldBmp.bitmapData.dispose();
            if(this.mFieldBmp.parent)
            {
               this.mFieldBmp.parent.removeChild(this.mFieldBmp);
            }
         }
         this.mFieldBmp = new Bitmap(this.mFieldBmpData);
         this.mFogBmp = new Bitmap(this.mFogBmpData);
      }
      
      private function initMultipleTileMapsDataStructures() : void
      {
         if(this.mFieldBmpArray)
         {
            Utils.removeAllChildren(this.mFieldMovieClip);
            Utils.removeFromParent(this.mFieldMovieClip);
            this.mFieldBmpArray = null;
         }
         if(this.mFogBmpArray)
         {
            Utils.removeAllChildren(this.mFogMovieClip);
            Utils.removeFromParent(this.mFogMovieClip);
            this.mFogBmpArray = null;
         }
         this.mFieldBmpArray = new Array();
         this.mFogBmpArray = new Array();
         this.mFieldMovieClip = new MovieClip();
         this.mFogMovieClip = new MovieClip();
      }
      
      public function generateLayers() : void
      {
         if(Config.ENABLE_SINGLE_BITMAP_FIELD_RENDERING)
         {
            this.initSingleTileMapDataStructures();
         }
         else
         {
            this.initMultipleTileMapsDataStructures();
         }
      }
      
      public function updateTilemap() : void
      {
         var _loc5_:int = 0;
         var _loc6_:MovieClip = null;
         var _loc7_:Class = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         this.mUid = !!Config.smUserId ? int(Config.smUserId) : int(GameState.mInstance.mServer.getUid());
         smTempPoint.x = 0;
         smTempPoint.y = 0;
         if(Config.ENABLE_SINGLE_BITMAP_FIELD_RENDERING)
         {
            this.mFogBmpData.fillRect(this.mFogBmpData.rect,0);
            this.mFieldBmpData.fillRect(this.mFieldBmpData.rect,0);
         }
         var _loc1_:int = 0;
         var _loc2_:DisplayObject = Config.ENABLE_SINGLE_BITMAP_FIELD_RENDERING ? this.mFieldBmp : this.mFieldMovieClip;
         var _loc3_:DisplayObject = Config.ENABLE_SINGLE_BITMAP_FIELD_RENDERING ? this.mFogBmp : this.mFogMovieClip;
         if(Config.RESTART_STATUS == -1 && GameState.mInstance.mRootNode.numChildren < 6)
         {
            GameState.mInstance.mRootNode.addChildAt(_loc2_,_loc1_++);
            GameState.mInstance.mRootNode.addChildAt(this.mScene.mContainer,_loc1_++);
            GameState.mInstance.mRootNode.addChildAt(_loc3_,_loc1_++);
            GameState.mInstance.mRootNode.addChildAt(this.mScene.mSceneHud,_loc1_++);
         }
         smTempPoint.x = 0;
         smTempPoint.y = 0;
         smTempPoint = this.mScene.mContainer.globalToLocal(smTempPoint);
         var _loc4_:Rectangle = getVisibleArea();
         this.drawArea(_loc4_.left,_loc4_.top,_loc4_.right,_loc4_.bottom);
         this.updateUnderCloudEnemyUnits();
         if(FeatureTuner.USE_SEA_WAVES_EFFECT)
         {
            while(this.mWaveContainer.numChildren > 0)
            {
               this.mWaveContainer.removeChildAt(0);
            }
            if((_loc5_ = this.mMapData.getType(this.mMapData.mGridWidth - 1,this.mMapData.mGridHeight - 1)) == MapData.TILE_TYPE_SHORE_S_1 || _loc5_ == MapData.TILE_TYPE_SHORE_S_2)
            {
               _loc7_ = DCResourceManager.getInstance().getSWFClass("swf/new_backgroud_01","Water_CoastTile");
               _loc8_ = (_loc4_.left - _loc4_.left % 2) * this.mScene.mGridDimX;
               _loc9_ = 0;
               while(_loc8_ < _loc4_.right * this.mScene.mGridDimX)
               {
                  (_loc6_ = new _loc7_()).x = _loc8_ - _loc4_.left * this.mScene.mGridDimY;
                  this.mWaveContainer.addChild(_loc6_);
                  _loc8_ += this.mScene.mGridDimX * 2;
                  _loc9_++;
               }
               this.mWaveContainer.x = this.mScene.mGridDimY * this.mScene.mSizeY;
               this.mWaveContainer.y = _loc4_.left * this.mScene.mGridDimX;
            }
         }
      }
      
      public function createBitmaps() : void
      {
         this.mDOs = new Array();
         this.mBitmaps = new Array();
         this.mBitmapOffsets = new Array();
         this.createBitmapsForAssets(TILES_OVERLAYS);
         this.createBitmapsForAssets(TILES_OVERLAYS_ENEMY);
         if(!Config.DISABLE_FOG)
         {
            this.createBitmapsForAssets(TILES_FOG);
         }
         this.createBitmapsForAssets(TILES_BORDER);
         this.createBitmapsForAssets(TILES_CLOUD);
         this.createBitmapsForAssets(TILES_TRANSITION);
         this.createBitmapsForAssets(TILES_CATEGORIES);
         this.createBitmapsForAssets(TILES_CATEGORIES_ENEMY);
      }
      
      private function createBitmapsForAssets(param1:Array) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Class = null;
         var _loc4_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc5_:Number = this.mScene.mContainer.scaleX;
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            if(_loc7_ = param1[_loc6_])
            {
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  _loc9_ = String(_loc7_[_loc8_]);
                  if(!this.mBitmaps[_loc9_])
                  {
                     _loc3_ = DCResourceManager.getInstance().getSWFClass(_loc9_);
                     if(_loc3_)
                     {
                        _loc2_ = new _loc3_();
                        _loc4_ = this.getTileOffsets(_loc2_);
                        this.mBitmapOffsets[_loc9_] = _loc4_;
                        mDrawMatrix.d = mDrawMatrix.a = _loc5_;
                        mDrawMatrix.tx = -_loc4_[0] * _loc5_;
                        mDrawMatrix.ty = -_loc4_[1] * _loc5_;
                        if(!this.mBitmaps[_loc9_])
                        {
                           this.mBitmaps[_loc9_] = new BitmapData(_loc2_.width,_loc2_.height,true,0);
                        }
                        (this.mBitmaps[_loc9_] as BitmapData).draw(_loc2_,mDrawMatrix);
                        _loc2_.scaleX = _loc5_;
                        _loc2_.scaleY = _loc2_.scaleX;
                        this.mDOs[_loc9_] = _loc2_;
                     }
                     else
                     {
                        this.mBitmapOffsets[_loc9_] = this.EMPTY_OFFSETS;
                        this.mDOs[_loc9_] = EMPTY_DISP_OBJECT;
                        this.mBitmaps[_loc9_] = this.EMPTY_BITMAPDATA;
                        if(Config.DEBUG_MODE)
                        {
                        }
                     }
                  }
                  _loc8_++;
               }
            }
            _loc6_++;
         }
      }
      
      public function recalculateBorderEdges() : void
      {
         var _loc3_:GridCell = null;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:int = this.mMapData.mGridWidth;
         var _loc2_:int = this.mMapData.mGridHeight;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc3_ = this.mGrid[_loc5_ * _loc1_ + _loc4_];
               _loc6_ = 0;
               if(_loc3_.mOwner == MapData.TILE_OWNER_ENEMY || _loc3_.mOwner == MapData.TILE_OWNER_NEUTRAL)
               {
                  _loc7_ = (_loc5_ - 1) * _loc1_ + (_loc4_ - 1);
                  _loc9_ = 0;
                  while(_loc9_ < 9)
                  {
                     if((_loc8_ = _loc7_ + _loc9_ % 3 + int(_loc9_ / 3) * _loc1_) >= 0)
                     {
                        if(_loc8_ < this.mGrid.length)
                        {
                           if((this.mGrid[_loc8_] as GridCell).mOwner == MapData.TILE_OWNER_FRIENDLY)
                           {
                              _loc6_ |= 1 << _loc9_;
                           }
                        }
                     }
                     _loc9_++;
                  }
               }
               _loc3_.mBorderEdgeBits = _loc6_;
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      private function drawBorderEdges(param1:int, param2:int) : void
      {
         var _loc5_:* = false;
         var _loc6_:* = false;
         var _loc3_:int = this.mScene.getCellAt(param1,param2).mBorderEdgeBits;
         if(_loc3_ == 0)
         {
            return;
         }
         var _loc4_:Array = TILES_BORDER[0];
         if(Boolean(_loc3_ & 1 << 1) && Boolean(_loc3_ & 1 << 3))
         {
            this.vectorDrawBitmap(_loc4_[EDGE_TL_DENT],param1,param2);
         }
         else if(!(_loc3_ & 1 << 1) && !(_loc3_ & 1 << 3))
         {
            if(_loc3_ & 1 << 0)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_TL_SHARP],param1 - 1,param2 - 1);
            }
         }
         if(Boolean(_loc3_ & 1 << 1) && Boolean(_loc3_ & 1 << 5))
         {
            this.vectorDrawBitmap(_loc4_[EDGE_TR_DENT],param1,param2);
         }
         else if(!(_loc3_ & 1 << 1) && !(_loc3_ & 1 << 5))
         {
            if(_loc3_ & 1 << 2)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_TR_SHARP],param1 + 1,param2 - 1);
            }
         }
         if(Boolean(_loc3_ & 1 << 3) && Boolean(_loc3_ & 1 << 7))
         {
            this.vectorDrawBitmap(_loc4_[EDGE_BL_DENT],param1,param2);
         }
         else if(!(_loc3_ & 1 << 3) && !(_loc3_ & 1 << 7))
         {
            if(_loc3_ & 1 << 6)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_BL_SHARP],param1 - 1,param2 + 1);
            }
         }
         if(Boolean(_loc3_ & 1 << 7) && Boolean(_loc3_ & 1 << 5))
         {
            this.vectorDrawBitmap(_loc4_[EDGE_BR_DENT],param1,param2);
         }
         else if(!(_loc3_ & 1 << 7) && !(_loc3_ & 1 << 5))
         {
            if(_loc3_ & 1 << 8)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_BR_SHARP],param1 + 1,param2 + 1);
            }
         }
         if(_loc3_ & 1 << 7)
         {
            _loc5_ = 0 < (_loc3_ & 1 << 3) == 0 < (_loc3_ & 1 << 6);
            _loc6_ = 0 < (_loc3_ & 1 << 5) == 0 < (_loc3_ & 1 << 8);
            if(_loc5_ && _loc6_)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_BOTTOM_SHORT],param1,param2);
            }
            else if(_loc5_)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_BOTTOM_SHORT_R],param1,param2);
            }
            else if(_loc6_)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_BOTTOM_SHORT_L],param1,param2);
            }
            else
            {
               this.vectorDrawBitmap(_loc4_[EDGE_BOTTOM_FULL],param1,param2);
            }
         }
         if(_loc3_ & 1 << 1)
         {
            _loc5_ = 0 < (_loc3_ & 1 << 3) == 0 < (_loc3_ & 1 << 0);
            _loc6_ = 0 < (_loc3_ & 1 << 5) == 0 < (_loc3_ & 1 << 2);
            if(_loc5_ && _loc6_)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_TOP_SHORT],param1,param2);
            }
            else if(_loc5_)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_TOP_SHORT_R],param1,param2);
            }
            else if(_loc6_)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_TOP_SHORT_L],param1,param2);
            }
            else
            {
               this.vectorDrawBitmap(_loc4_[EDGE_TOP_FULL],param1,param2);
            }
         }
         if(_loc3_ & 1 << 5)
         {
            _loc5_ = 0 < (_loc3_ & 1 << 1) == 0 < (_loc3_ & 1 << 2);
            _loc6_ = 0 < (_loc3_ & 1 << 7) == 0 < (_loc3_ & 1 << 8);
            if(_loc5_ && _loc6_)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_RIGHT_SHORT],param1,param2);
            }
            else if(_loc5_)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_RIGHT_SHORT_B],param1,param2);
            }
            else if(_loc6_)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_RIGHT_SHORT_T],param1,param2);
            }
            else
            {
               this.vectorDrawBitmap(_loc4_[EDGE_RIGHT_FULL],param1,param2);
            }
         }
         if(_loc3_ & 1 << 3)
         {
            _loc5_ = 0 < (_loc3_ & 1 << 0) == 0 < (_loc3_ & 1 << 1);
            _loc6_ = 0 < (_loc3_ & 1 << 6) == 0 < (_loc3_ & 1 << 7);
            if(_loc5_ && _loc6_)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_LEFT_SHORT],param1,param2);
            }
            else if(_loc5_)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_LEFT_SHORT_B],param1,param2);
            }
            else if(_loc6_)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_LEFT_SHORT_T],param1,param2);
            }
            else
            {
               this.vectorDrawBitmap(_loc4_[EDGE_LEFT_FULL],param1,param2);
            }
         }
      }
      
      private function getTileOffsets(param1:Sprite) : Array
      {
         var _loc2_:Rectangle = param1.transform.pixelBounds;
         var _loc3_:Matrix = param1.transform.concatenatedMatrix;
         return [_loc2_.x / _loc3_.a,_loc2_.y / _loc3_.d];
      }
      
      public function destroy() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         this.mFieldBmp.bitmapData.dispose();
         this.mFogBmp.bitmapData.dispose();
         if(this.mFieldBmp.parent)
         {
            this.mFieldBmp.parent.removeChild(this.mFieldBmp);
         }
         this.mFieldBmp = null;
         if(this.mFogBmp.parent)
         {
            this.mFogBmp.parent.removeChild(this.mFogBmp);
         }
         this.mFogBmp = null;
         if(FeatureTuner.USE_SEA_WAVES_EFFECT)
         {
            if(!this.mWaveContainer.parent)
            {
            }
            this.mWaveContainer = null;
         }
         for(_loc1_ in this.mDOs)
         {
            this.mDOs[_loc1_] = null;
         }
         for(_loc2_ in this.mBitmaps)
         {
            (this.mBitmaps[_loc2_] as BitmapData).dispose();
            this.mBitmaps[_loc2_] = null;
         }
         for(_loc3_ in this.mBitmapOffsets)
         {
            this.mBitmapOffsets[_loc3_] = null;
         }
         this.mScene = null;
         this.mMapData = null;
      }
      
      public function drawFog() : void
      {
         var _loc4_:int = 0;
         var _loc1_:int = this.mScene.mSizeY;
         var _loc2_:int = this.mScene.mSizeX;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc1_)
            {
               this.drawClouds(_loc3_,_loc4_,(this.mMapData.mGrid[_loc4_ * this.mSizeX + _loc3_] as GridCell).mCloudBits);
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      private function drawArea(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         this.mRandom = new Random();
         var _loc6_:String = String(TILES_FOG[0][EDGE_FULL]);
         var _loc7_:int = param1;
         while(_loc7_ < param3)
         {
            _loc8_ = param2;
            while(_loc8_ < param4)
            {
               this.mTargetBitmap = this.mFieldBmp;
               this.mTargetBitmapArray = this.mFieldBmpArray;
               this.mTargetMovieClip = this.mFieldMovieClip;
               if((this.mMapData.mGrid[_loc8_ * this.mSizeX + _loc7_] as GridCell).mCloudBits != CLOUD_BIT_FULL)
               {
                  this.blitBitmap(this.getTileGraphicNameForCell(_loc7_,_loc8_),_loc7_,_loc8_);
                  if(_loc9_ = this.getMidLayerGraphicForCell(_loc7_,_loc8_))
                  {
                     this.blitBitmap(_loc9_,_loc7_,_loc8_);
                  }
               }
               this.drawTransition(_loc7_,_loc8_);
               this.mTargetBitmap = this.mFogBmp;
               this.mTargetBitmapArray = this.mFogBmpArray;
               this.mTargetMovieClip = this.mFogMovieClip;
               _loc5_ = (this.mMapData.mGrid[_loc8_ * this.mSizeX + _loc7_] as GridCell).mCloudBits;
               if(!Config.DISABLE_FOG)
               {
                  if(_loc5_ != CLOUD_BIT_FULL)
                  {
                     if(this.mMapData.hasFog(_loc7_,_loc8_))
                     {
                        this.blitBitmap(_loc6_,_loc7_,_loc8_);
                     }
                     else
                     {
                        this.drawFogEdges(_loc7_,_loc8_);
                     }
                  }
               }
               this.drawClouds(_loc7_,_loc8_,_loc5_);
               _loc8_++;
            }
            _loc7_++;
         }
         this.mTargetBitmap = this.mFieldBmp;
         this.mTargetBitmapArray = this.mFieldBmpArray;
         this.mTargetMovieClip = this.mFieldMovieClip;
         _loc7_ = param1;
         while(_loc7_ < param3)
         {
            _loc8_ = param2;
            while(_loc8_ < param4)
            {
               this.drawBorderEdges(_loc7_,_loc8_);
               _loc8_++;
            }
            _loc7_++;
         }
         if(GameState.needToUpdatePermanentHFE)
         {
            this.updatePermanentHFEs();
            GameState.needToUpdatePermanentHFE = false;
         }
         this.mBlitCounter = 0;
         this.mVectCounter = 0;
      }
      
      public function updatePermanentHFEs() : void
      {
         var _loc1_:Renderable = null;
         var _loc4_:PermanentHFEObject = null;
         var _loc5_:MovieClip = null;
         var _loc2_:int = int(this.mScene.mAllElements.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mScene.mAllElements[_loc3_] as Renderable;
            if(_loc1_ is PermanentHFEObject)
            {
               if(_loc5_ = (_loc4_ = PermanentHFEObject(_loc1_)).mCloudedGraphicVersion)
               {
                  if(!this.mScene.isInsideOpenArea(_loc4_.getCell()))
                  {
                     if(!_loc5_.parent)
                     {
                        _loc5_.x = _loc4_.getContainer().x;
                        _loc5_.y = _loc4_.getContainer().y;
                        this.mScene.mSceneHud.addChildAt(_loc5_,0);
                     }
                  }
                  else if(_loc5_.parent)
                  {
                     _loc5_.parent.removeChild(_loc5_);
                     _loc5_ = null;
                  }
               }
            }
            _loc3_++;
         }
      }
      
      public function updateUnderCloudEnemyUnits() : void
      {
         var _loc1_:Renderable = null;
         var _loc5_:EnemyUnit = null;
         var _loc2_:Array = null;
         _loc2_ = this.mScene.getAllEnemies();
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc1_ = _loc2_[_loc4_] as Renderable;
            if(_loc1_ is EnemyUnit)
            {
               _loc5_ = _loc1_ as EnemyUnit;
               if(this.mScene.isUnderCloudBorder(_loc5_.getCell()))
               {
                  if(_loc5_.mUnderCloudImage)
                  {
                     if(!_loc5_.mUnderCloudImage.parent)
                     {
                        this.mScene.mSceneHud.addChild(_loc5_.mUnderCloudImage);
                     }
                  }
               }
               else if(_loc5_.mUnderCloudImage)
               {
                  if(_loc5_.mUnderCloudImage.parent)
                  {
                     this.mScene.mSceneHud.removeChild(_loc5_.mUnderCloudImage);
                     _loc5_.mUnderCloudImage = null;
                  }
               }
            }
            _loc4_++;
         }
      }
      
      private function getTileGraphicNameForCell(param1:int, param2:int) : String
      {
         var _loc4_:Array = null;
         var _loc3_:int = this.mMapData.getType(param1,param2);
         if(MapData.TILES_PASSABILITY[_loc3_] == MapData.TILE_SHORE)
         {
            return this.getSeaShoreTileName(_loc3_,param1,param2);
         }
         this.mRandom.setRandomSeed(this.mUid * param1 * param2);
         if(!this.mMapData.isFriendly(param1,param2))
         {
            _loc4_ = TILES_CATEGORIES_ENEMY[_loc3_];
         }
         else
         {
            _loc4_ = TILES_CATEGORIES[_loc3_];
         }
         return _loc4_[this.mRandom.nextInt(_loc4_.length)];
      }
      
      public function getRiverGraphicNameForCell(param1:int, param2:int) : String
      {
         var _loc5_:Array = null;
         var _loc3_:int = this.mMapData.getType(param1,param2);
         var _loc4_:GridCell = this.mScene.getCellAt(param1,param2);
         if(!this.mMapData.isFriendly(param1,param2))
         {
            _loc5_ = TILES_OVERLAYS_ENEMY[_loc3_];
         }
         else
         {
            _loc5_ = TILES_OVERLAYS[_loc3_];
         }
         _loc3_ = 0;
         var _loc6_:GridCell;
         if(!(_loc6_ = this.mMapData.getNeighbourUp(_loc4_)) || _loc6_.mType != MapData.TILE_TYPE_RIVER)
         {
            _loc3_ = 3 + param2 % 2;
         }
         else if(param2 < this.mScene.mSizeY - 2)
         {
            _loc3_ = param2 % 2 + 1;
         }
         if(Boolean(_loc5_) && Boolean(_loc5_[_loc3_]))
         {
            return _loc5_[_loc3_];
         }
         return null;
      }
      
      private function getMidLayerGraphicForCell(param1:int, param2:int) : String
      {
         var _loc5_:Array = null;
         var _loc3_:GridCell = this.mScene.getCellAt(param1,param2);
         var _loc4_:int;
         if((_loc4_ = _loc3_.mType) == MapData.TILE_TYPE_RIVER)
         {
            return this.getRiverGraphicNameForCell(param1,param2);
         }
         if(!this.mMapData.isFriendly(param1,param2))
         {
            _loc5_ = TILES_OVERLAYS_ENEMY[_loc4_];
         }
         else
         {
            if(_loc3_.mObject)
            {
               return null;
            }
            _loc5_ = TILES_OVERLAYS[_loc4_];
         }
         if(_loc5_)
         {
            return _loc5_[this.mRandom.nextInt(_loc5_.length)];
         }
         return null;
      }
      
      private function getSeaShoreTileName(param1:int, param2:int, param3:int) : String
      {
         var _loc13_:* = 0;
         var _loc4_:Boolean = this.mMapData.isFriendly(param2,param3 - 1);
         var _loc5_:Boolean = this.mMapData.isFriendly(param2,param3 + 1);
         var _loc6_:Boolean = this.mMapData.isFriendly(param2 - 1,param3);
         var _loc7_:Boolean = this.mMapData.isFriendly(param2 + 1,param3);
         var _loc8_:Boolean = this.mMapData.isFriendly(param2 - 1,param3 - 1);
         var _loc9_:Boolean = this.mMapData.isFriendly(param2 + 1,param3 - 1);
         var _loc10_:Boolean = this.mMapData.isFriendly(param2 - 1,param3 + 1);
         var _loc11_:Boolean = this.mMapData.isFriendly(param2 + 1,param3 + 1);
         var _loc12_:int = 0;
         switch(param1)
         {
            case MapData.TILE_TYPE_SHORE_S_1:
            case MapData.TILE_TYPE_DESERT_DECO_31:
            case MapData.TILE_TYPE_SHORE_S_2:
            case MapData.TILE_TYPE_DESERT_SHORE_S:
               _loc12_ = COAST_S_FRIENDLY_UP;
               if(!_loc4_)
               {
                  if(_loc8_ && _loc9_)
                  {
                     _loc12_ = COAST_S_FRIENDLY_LEFT_RIGHT;
                  }
                  else if(_loc8_)
                  {
                     _loc12_ = COAST_S_FRIENDLY_LEFT;
                  }
                  else if(_loc9_)
                  {
                     _loc12_ = COAST_S_FRIENDLY_RIGHT;
                  }
                  else
                  {
                     _loc12_ = COAST_S_ENEMY_UP;
                  }
               }
               break;
            case MapData.TILE_TYPE_DESERT_SHORE_N:
               _loc12_ = COAST_N_FRIENDLY_DOWN;
               if(!_loc5_)
               {
                  if(_loc10_ && _loc11_)
                  {
                     _loc12_ = COAST_N_FRIENDLY_LEFT_RIGHT;
                  }
                  else if(_loc10_)
                  {
                     _loc12_ = COAST_N_FRIENDLY_LEFT;
                  }
                  else if(_loc11_)
                  {
                     _loc12_ = COAST_N_FRIENDLY_RIGHT;
                  }
                  else
                  {
                     _loc12_ = COAST_N_ENEMY_DOWN;
                  }
               }
               break;
            case MapData.TILE_TYPE_DESERT_SHORE_W:
               _loc12_ = COAST_W_FRIENDLY_RIGHT;
               if(!_loc7_)
               {
                  if(_loc9_ && _loc11_)
                  {
                     _loc12_ = COAST_W_FRIENDLY_UP_DOWN;
                  }
                  else if(_loc9_)
                  {
                     _loc12_ = COAST_W_FRIENDLY_UP;
                  }
                  else if(_loc11_)
                  {
                     _loc12_ = COAST_W_FRIENDLY_DOWN;
                  }
                  else
                  {
                     _loc12_ = COAST_W_ENEMY_RIGHT;
                  }
               }
               break;
            case MapData.TILE_TYPE_DESERT_SHORE_E:
               _loc12_ = COAST_E_FRIENDLY_LEFT;
               if(!_loc6_)
               {
                  if(_loc8_ && _loc10_)
                  {
                     _loc12_ = COAST_E_FRIENDLY_UP_DOWN;
                  }
                  else if(_loc8_)
                  {
                     _loc12_ = COAST_E_FRIENDLY_UP;
                  }
                  else if(_loc10_)
                  {
                     _loc12_ = COAST_E_FRIENDLY_DOWN;
                  }
                  else
                  {
                     _loc12_ = COAST_E_ENEMY_LEFT;
                  }
               }
               break;
            case MapData.TILE_TYPE_DESERT_SHORE_NW:
               _loc12_ = COAST_CORNER_FRIENDLY;
               if(!_loc11_)
               {
                  _loc12_ = COAST_CORNER_ENEMY;
               }
               break;
            case MapData.TILE_TYPE_DESERT_SHORE_NE:
               _loc12_ = COAST_CORNER_FRIENDLY;
               if(!_loc10_)
               {
                  _loc12_ = COAST_CORNER_ENEMY;
               }
               break;
            case MapData.TILE_TYPE_DESERT_SHORE_SW:
               _loc12_ = COAST_CORNER_FRIENDLY;
               if(!_loc9_)
               {
                  _loc12_ = COAST_CORNER_ENEMY;
               }
               break;
            case MapData.TILE_TYPE_DESERT_SHORE_SE:
               _loc12_ = COAST_CORNER_FRIENDLY;
               if(!_loc8_)
               {
                  _loc12_ = COAST_CORNER_ENEMY;
               }
               break;
            case MapData.TILE_TYPE_DESERT_SHORE_NW_INSIDE:
            case MapData.TILE_TYPE_DESERT_SHORE_NE_INSIDE:
            case MapData.TILE_TYPE_DESERT_SHORE_SE_INSIDE:
            case MapData.TILE_TYPE_DESERT_SHORE_SW_INSIDE:
               _loc12_ = COAST_CORNER_INSIDE_1;
               _loc13_ = 0;
               if(param1 == MapData.TILE_TYPE_DESERT_SHORE_NW_INSIDE)
               {
                  if(_loc10_)
                  {
                     _loc13_ |= 1 << 0;
                  }
                  if(_loc6_)
                  {
                     _loc13_ |= 1 << 1;
                  }
                  if(_loc8_)
                  {
                     _loc13_ |= 1 << 2;
                  }
                  if(_loc4_)
                  {
                     _loc13_ |= 1 << 3;
                  }
                  if(_loc9_)
                  {
                     _loc13_ |= 1 << 4;
                  }
               }
               else if(param1 == MapData.TILE_TYPE_DESERT_SHORE_NE_INSIDE)
               {
                  if(_loc11_)
                  {
                     _loc13_ |= 1 << 0;
                  }
                  if(_loc7_)
                  {
                     _loc13_ |= 1 << 1;
                  }
                  if(_loc9_)
                  {
                     _loc13_ |= 1 << 2;
                  }
                  if(_loc4_)
                  {
                     _loc13_ |= 1 << 3;
                  }
                  if(_loc8_)
                  {
                     _loc13_ |= 1 << 4;
                  }
               }
               else if(param1 == MapData.TILE_TYPE_DESERT_SHORE_SE_INSIDE)
               {
                  if(_loc9_)
                  {
                     _loc13_ |= 1 << 0;
                  }
                  if(_loc7_)
                  {
                     _loc13_ |= 1 << 1;
                  }
                  if(_loc11_)
                  {
                     _loc13_ |= 1 << 2;
                  }
                  if(_loc5_)
                  {
                     _loc13_ |= 1 << 3;
                  }
                  if(_loc10_)
                  {
                     _loc13_ |= 1 << 4;
                  }
               }
               else
               {
                  if(_loc8_)
                  {
                     _loc13_ |= 1 << 0;
                  }
                  if(_loc6_)
                  {
                     _loc13_ |= 1 << 1;
                  }
                  if(_loc10_)
                  {
                     _loc13_ |= 1 << 2;
                  }
                  if(_loc5_)
                  {
                     _loc13_ |= 1 << 3;
                  }
                  if(_loc11_)
                  {
                     _loc13_ |= 1 << 4;
                  }
               }
               switch(_loc13_)
               {
                  case 0:
                     _loc12_ = COAST_CORNER_INSIDE_2;
                     break;
                  case 1:
                     _loc12_ = COAST_CORNER_INSIDE_3;
                     break;
                  case 2:
                  case 3:
                  case 6:
                  case 7:
                     _loc12_ = COAST_CORNER_INSIDE_9;
                     break;
                  case 4:
                     _loc12_ = COAST_CORNER_INSIDE_5;
                     break;
                  case 5:
                     _loc12_ = COAST_CORNER_INSIDE_6;
                     break;
                  case 8:
                  case 12:
                  case 24:
                  case 28:
                     _loc12_ = COAST_CORNER_INSIDE_10;
                     break;
                  case 9:
                  case 13:
                  case 25:
                  case 29:
                     _loc12_ = COAST_CORNER_INSIDE_12;
                     break;
                  case 16:
                     _loc12_ = COAST_CORNER_INSIDE_4;
                     break;
                  case 17:
                     _loc12_ = COAST_CORNER_INSIDE_13;
                     break;
                  case 18:
                  case 19:
                  case 22:
                  case 23:
                     _loc12_ = COAST_CORNER_INSIDE_11;
                     break;
                  case 20:
                     _loc12_ = COAST_CORNER_INSIDE_7;
                     break;
                  case 21:
                     _loc12_ = COAST_CORNER_INSIDE_8;
               }
         }
         return TILES_CATEGORIES_ENEMY[param1][_loc12_];
      }
      
      private function getTileBmp(param1:int, param2:int) : Bitmap
      {
         if(this.mTargetBitmapArray[param1] as Array == null)
         {
            this.mTargetBitmapArray[param1] = new Array();
         }
         var _loc3_:Bitmap = this.mTargetBitmapArray[param1][param2];
         if(_loc3_ == null)
         {
            _loc3_ = new Bitmap(null);
            this.mTargetBitmapArray[param1][param2] = _loc3_;
         }
         return _loc3_;
      }
      
      private function blitBitmap(param1:String, param2:int, param3:int) : void
      {
         var _loc10_:Bitmap = null;
         var _loc11_:BitmapData = null;
         var _loc12_:Boolean = false;
         var _loc13_:uint = 0;
         var _loc4_:BitmapData = this.mBitmaps[param1];
         var _loc5_:Array = this.mBitmapOffsets[param1];
         var _loc6_:Number = param2 * this.mScene.mGridDimX * this.mScene.mContainer.scaleX + this.mScene.mContainer.x;
         var _loc7_:Number = param3 * this.mScene.mGridDimY * this.mScene.mContainer.scaleY + this.mScene.mContainer.y;
         var _loc8_:Number = _loc5_[0] * this.mScene.mContainer.scaleX;
         var _loc9_:Number = _loc5_[1] * this.mScene.mContainer.scaleY;
         mDrawMatrix.tx = _loc6_ + _loc8_;
         mDrawMatrix.ty = _loc7_ + _loc9_;
         if(Config.ENABLE_SINGLE_BITMAP_FIELD_RENDERING)
         {
            smTempPoint.x = mDrawMatrix.tx;
            smTempPoint.y = mDrawMatrix.ty;
            this.mTargetBitmap.bitmapData.copyPixels(_loc4_,_loc4_.rect,smTempPoint);
         }
         else
         {
            smTempPoint.x = _loc8_;
            smTempPoint.y = _loc9_;
            if((_loc11_ = (_loc10_ = this.getTileBmp(param2,param3)).bitmapData) == null)
            {
               _loc12_ = true;
               _loc13_ = 16711935;
               if(this.mTargetBitmapArray == this.mFieldBmpArray)
               {
                  _loc12_ = false;
                  _loc13_ = 255;
               }
               _loc11_ = new BitmapData(_loc4_.width,_loc4_.height,_loc12_,_loc13_);
            }
            _loc11_.draw(_loc4_,mDrawMatrix);
            _loc10_.x = _loc6_;
            _loc10_.y = _loc7_;
            _loc10_.bitmapData = _loc11_;
            this.mTargetMovieClip.addChildAt(_loc10_,0);
         }
         ++this.mBlitCounter;
      }
      
      private function vectorDrawBitmap(param1:String, param2:int, param3:int) : void
      {
         var _loc7_:Bitmap = null;
         var _loc8_:BitmapData = null;
         var _loc9_:Boolean = false;
         var _loc10_:uint = 0;
         var _loc4_:DisplayObject = this.mDOs[param1];
         var _loc5_:Number = param2 * this.mScene.mGridDimX * this.mScene.mContainer.scaleX + this.mScene.mContainer.x;
         var _loc6_:Number = param3 * this.mScene.mGridDimY * this.mScene.mContainer.scaleY + this.mScene.mContainer.y;
         if(Config.ENABLE_SINGLE_BITMAP_FIELD_RENDERING)
         {
            mDrawMatrix.tx = _loc5_;
            mDrawMatrix.ty = _loc6_;
            this.mTargetBitmap.bitmapData.draw(_loc4_,mDrawMatrix,null,null,null,false);
         }
         else
         {
            if((_loc8_ = (_loc7_ = this.getTileBmp(param2,param3)).bitmapData) == null)
            {
               _loc9_ = true;
               _loc10_ = 16711935;
               if(this.mTargetBitmapArray == this.mFieldBmpArray)
               {
                  _loc9_ = false;
                  _loc10_ = 255;
               }
               _loc8_ = new BitmapData(_loc4_.width,_loc4_.height,_loc9_,_loc10_);
            }
            mDrawMatrix.tx = 0;
            mDrawMatrix.ty = 0;
            _loc8_.draw(_loc4_,mDrawMatrix,null,null,null,false);
            _loc7_.bitmapData = _loc8_;
            _loc7_.x = _loc5_;
            _loc7_.y = _loc6_;
            this.mTargetMovieClip.addChildAt(_loc7_,0);
         }
         ++this.mVectCounter;
      }
      
      private function drawClouds(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:Array = TILES_CLOUD[0];
         if(param3 != CLOUD_BIT_NONE)
         {
            if(param3 == CLOUD_BIT_FULL)
            {
               this.blitBitmap(_loc4_[CLOUD_INDEX_FULL],param1,param2);
            }
            else if(param3 & CLOUD_BIT_CONVEX_TL)
            {
               this.vectorDrawBitmap(_loc4_[CLOUD_INDEX_C_TL],param1,param2);
            }
            else if(param3 & CLOUD_BIT_CONVEX_TR)
            {
               this.vectorDrawBitmap(_loc4_[CLOUD_INDEX_C_TR],param1,param2);
            }
            else if(param3 & CLOUD_BIT_CONVEX_BL)
            {
               this.vectorDrawBitmap(_loc4_[CLOUD_INDEX_C_BL],param1,param2);
            }
            else if(param3 & CLOUD_BIT_CONVEX_BR)
            {
               this.vectorDrawBitmap(_loc4_[CLOUD_INDEX_C_BR],param1,param2);
            }
            else if(param3 & CLOUD_BIT_LEFT)
            {
               this.vectorDrawBitmap(_loc4_[CLOUD_INDEX_LEFT],param1,param2);
            }
            else if(param3 & CLOUD_BIT_RIGHT)
            {
               this.vectorDrawBitmap(_loc4_[CLOUD_INDEX_RIGHT],param1,param2);
            }
            else if(param3 & CLOUD_BIT_TOP)
            {
               this.vectorDrawBitmap(_loc4_[CLOUD_INDEX_TOP],param1,param2);
            }
            else if(param3 & CLOUD_BIT_BOTTOM)
            {
               this.vectorDrawBitmap(_loc4_[CLOUD_INDEX_BOTTOM],param1,param2);
            }
            else if(param3 & CLOUD_BIT_TL)
            {
               this.vectorDrawBitmap(_loc4_[CLOUD_INDEX_TL],param1,param2);
            }
            else if(param3 & CLOUD_BIT_TR)
            {
               this.vectorDrawBitmap(_loc4_[CLOUD_INDEX_TR],param1,param2);
            }
            else if(param3 & CLOUD_BIT_BR)
            {
               this.vectorDrawBitmap(_loc4_[CLOUD_INDEX_BR],param1,param2);
            }
            else if(param3 & CLOUD_BIT_BL)
            {
               this.vectorDrawBitmap(_loc4_[CLOUD_INDEX_BL],param1,param2);
            }
         }
      }
      
      private function drawTransition(param1:int, param2:int) : void
      {
         var _loc3_:Array = null;
         var _loc4_:GridCell = null;
         var _loc5_:GridCell = null;
         var _loc6_:GridCell = null;
         var _loc7_:GridCell = null;
         var _loc8_:GridCell = null;
         var _loc9_:GridCell = null;
         var _loc10_:GridCell = null;
         var _loc11_:GridCell = null;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         if(this.mScene.getCellAt(param1,param2).mOwner == MapData.TILE_OWNER_ENEMY)
         {
            _loc3_ = TILES_TRANSITION[MapData.TILES_MAP_TYPE[this.mScene.getCellAt(param1,param2).mType]];
            _loc4_ = this.mScene.getCellAt(param1,param2 - 1);
            _loc5_ = this.mScene.getCellAt(param1,param2 + 1);
            _loc6_ = this.mScene.getCellAt(param1 - 1,param2);
            _loc7_ = this.mScene.getCellAt(param1 + 1,param2);
            _loc8_ = this.mScene.getCellAt(param1 - 1,param2 - 1);
            _loc9_ = this.mScene.getCellAt(param1 + 1,param2 - 1);
            _loc10_ = this.mScene.getCellAt(param1 - 1,param2 + 1);
            _loc11_ = this.mScene.getCellAt(param1 + 1,param2 + 1);
            _loc12_ = Boolean(_loc4_) && _loc4_.mOwner == MapData.TILE_OWNER_FRIENDLY;
            _loc13_ = Boolean(_loc5_) && _loc5_.mOwner == MapData.TILE_OWNER_FRIENDLY;
            _loc14_ = Boolean(_loc6_) && _loc6_.mOwner == MapData.TILE_OWNER_FRIENDLY;
            _loc15_ = Boolean(_loc7_) && _loc7_.mOwner == MapData.TILE_OWNER_FRIENDLY;
            _loc16_ = Boolean(_loc8_) && _loc8_.mOwner == MapData.TILE_OWNER_FRIENDLY;
            _loc17_ = Boolean(_loc9_) && _loc9_.mOwner == MapData.TILE_OWNER_FRIENDLY;
            _loc18_ = Boolean(_loc10_) && _loc10_.mOwner == MapData.TILE_OWNER_FRIENDLY;
            _loc19_ = Boolean(_loc11_) && _loc11_.mOwner == MapData.TILE_OWNER_FRIENDLY;
            if(_loc12_)
            {
               this.blitBitmap(_loc3_[TRANSITION_TOP],param1,param2);
            }
            else
            {
               if(!_loc15_ && _loc17_)
               {
                  this.blitBitmap(_loc3_[TRANSITION_TOP_RIGHT],param1,param2);
               }
               if(!_loc14_ && _loc16_)
               {
                  this.blitBitmap(_loc3_[TRANSITION_TOP_LEFT],param1,param2);
               }
            }
            if(_loc13_)
            {
               this.blitBitmap(_loc3_[TRANSITION_BOTTOM],param1,param2);
            }
            else
            {
               if(!_loc15_ && _loc19_)
               {
                  this.blitBitmap(_loc3_[TRANSITION_BOTTOM_RIGHT],param1,param2);
               }
               if(!_loc14_ && _loc18_)
               {
                  this.blitBitmap(_loc3_[TRANSITION_BOTTOM_LEFT],param1,param2);
               }
            }
            if(_loc14_)
            {
               this.blitBitmap(_loc3_[TRANSITION_LEFT],param1,param2);
            }
            if(_loc15_)
            {
               this.blitBitmap(_loc3_[TRANSITION_RIGHT],param1,param2);
            }
         }
      }
      
      private function drawFogEdges(param1:int, param2:int) : void
      {
         var _loc3_:int = this.mScene.getCellAt(param1,param2).mFogEdgeBits;
         var _loc4_:Array = TILES_FOG[0];
         if(_loc3_ == 0 || this.mScene.getCellAt(param1,param2).mCloudBits == CLOUD_BIT_FULL)
         {
            return;
         }
         if(_loc3_ & 1 << 1)
         {
            if(Boolean(_loc3_ & 1 << 3) && Boolean(_loc3_ & 1 << 5))
            {
               this.vectorDrawBitmap(_loc4_[EDGE_TOP_SHORT],param1,param2);
            }
            else if(_loc3_ & 1 << 3)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_TOP_SHORT_R],param1,param2);
            }
            else if(_loc3_ & 1 << 5)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_TOP_SHORT_L],param1,param2);
            }
            else
            {
               this.vectorDrawBitmap(_loc4_[EDGE_TOP_FULL],param1,param2);
            }
         }
         if(_loc3_ & 1 << 7)
         {
            if(Boolean(_loc3_ & 1 << 3) && Boolean(_loc3_ & 1 << 5))
            {
               this.vectorDrawBitmap(_loc4_[EDGE_BOTTOM_SHORT],param1,param2);
            }
            else if(_loc3_ & 1 << 3)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_BOTTOM_SHORT_R],param1,param2);
            }
            else if(_loc3_ & 1 << 5)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_BOTTOM_SHORT_L],param1,param2);
            }
            else
            {
               this.vectorDrawBitmap(_loc4_[EDGE_BOTTOM_FULL],param1,param2);
            }
         }
         if(_loc3_ & 1 << 3)
         {
            if(Boolean(_loc3_ & 1 << 1) && Boolean(_loc3_ & 1 << 7))
            {
               this.vectorDrawBitmap(_loc4_[EDGE_LEFT_SHORT],param1,param2);
            }
            else if(_loc3_ & 1 << 1)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_LEFT_SHORT_B],param1,param2);
            }
            else if(_loc3_ & 1 << 7)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_LEFT_SHORT_T],param1,param2);
            }
            else
            {
               this.vectorDrawBitmap(_loc4_[EDGE_LEFT_FULL],param1,param2);
            }
         }
         if(_loc3_ & 1 << 5)
         {
            if(Boolean(_loc3_ & 1 << 1) && Boolean(_loc3_ & 1 << 7))
            {
               this.vectorDrawBitmap(_loc4_[EDGE_RIGHT_SHORT],param1,param2);
            }
            else if(_loc3_ & 1 << 1)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_RIGHT_SHORT_B],param1,param2);
            }
            else if(_loc3_ & 1 << 7)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_RIGHT_SHORT_T],param1,param2);
            }
            else
            {
               this.vectorDrawBitmap(_loc4_[EDGE_RIGHT_FULL],param1,param2);
            }
         }
         if(!(_loc3_ & 1 << 1) && !(_loc3_ & 1 << 3))
         {
            if(_loc3_ & 1 << 0)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_TL_SHARP],param1,param2);
            }
         }
         else if(Boolean(_loc3_ & 1 << 1) && Boolean(_loc3_ & 1 << 3))
         {
            this.vectorDrawBitmap(_loc4_[EDGE_TL_DENT],param1,param2);
         }
         if(!(_loc3_ & 1 << 1) && !(_loc3_ & 1 << 5))
         {
            if(_loc3_ & 1 << 2)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_TR_SHARP],param1,param2);
            }
         }
         else if(Boolean(_loc3_ & 1 << 1) && Boolean(_loc3_ & 1 << 5))
         {
            this.vectorDrawBitmap(_loc4_[EDGE_TR_DENT],param1,param2);
         }
         if(!(_loc3_ & 1 << 3) && !(_loc3_ & 1 << 7))
         {
            if(_loc3_ & 1 << 6)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_BL_SHARP],param1,param2);
            }
         }
         else if(Boolean(_loc3_ & 1 << 3) && Boolean(_loc3_ & 1 << 7))
         {
            this.vectorDrawBitmap(_loc4_[EDGE_BL_DENT],param1,param2);
         }
         if(!(_loc3_ & 1 << 7) && !(_loc3_ & 1 << 5))
         {
            if(_loc3_ & 1 << 8)
            {
               this.vectorDrawBitmap(_loc4_[EDGE_BR_SHARP],param1,param2);
            }
         }
         else if(Boolean(_loc3_ & 1 << 7) && Boolean(_loc3_ & 1 << 5))
         {
            this.vectorDrawBitmap(_loc4_[EDGE_BR_DENT],param1,param2);
         }
      }
   }
}
