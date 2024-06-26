package game.battlefield
{
   import com.dchoc.graphics.DCResourceManager;
   import game.isometric.GridCell;
   import game.net.ServerCall;
   import game.states.GameState;
   
   public class MapData
   {
      
      public static const MAP_HOME:String = "Home";
      
      public static const TILE_OWNER_ENEMY:int = 0;
      
      public static const TILE_OWNER_FRIENDLY:int = 1;
      
      public static const TILE_OWNER_NEUTRAL:int = 2;
      
      public static const TILE_LAND:int = 0;
      
      public static const TILE_MOUNTAIN:int = 1;
      
      public static const TILE_SHORE:int = 2;
      
      public static const TILE_SEA:int = 3;
      
      public static const TILE_MAP_TYPE_GRASSLANDS:int = 0;
      
      public static const TILE_MAP_TYPE_DESERT:int = 1;
      
      public static const TILE_TYPE_RIVER:int = 18;
      
      public static const TILE_TYPE_SHORE_S_1:int = 19;
      
      public static const TILE_TYPE_SHORE_S_2:int = 21;
      
      public static const TILE_TYPE_DESERT_SHORE_S:int = 128;
      
      public static const TILE_TYPE_DESERT_SHORE_W:int = 129;
      
      public static const TILE_TYPE_DESERT_SHORE_N:int = 126;
      
      public static const TILE_TYPE_DESERT_SHORE_E:int = 127;
      
      public static const TILE_TYPE_DESERT_SHORE_NW:int = 122;
      
      public static const TILE_TYPE_DESERT_SHORE_NE:int = 123;
      
      public static const TILE_TYPE_DESERT_SHORE_SE:int = 125;
      
      public static const TILE_TYPE_DESERT_SHORE_SW:int = 124;
      
      public static const TILE_TYPE_DESERT_SHORE_NW_INSIDE:int = 118;
      
      public static const TILE_TYPE_DESERT_SHORE_NE_INSIDE:int = 119;
      
      public static const TILE_TYPE_DESERT_SHORE_SE_INSIDE:int = 121;
      
      public static const TILE_TYPE_DESERT_SHORE_SW_INSIDE:int = 120;
      
      public static const TILE_TYPE_DESERT_DECO_31:int = 1045;
      
      private static const EXTENSIONS_TO_REMOVE_FROM_NAME:Array = [".csv"];
      
      public static const TILE_PASSABILITY_STRING_TO_ID:Object = {
         "Land":TILE_LAND,
         "Shore":TILE_SHORE,
         "Sea":TILE_SEA,
         "Mountain":TILE_MOUNTAIN
      };
      
      public static var TILES_PASSABILITY:Array;
      
      public static var TILES_MAP_TYPE:Array;
       
      
      public var mGridWidth:int;
      
      public var mGridHeight:int;
      
      public var mGrid:Array;
      
      public var mUpdateRequired:Boolean;
      
      public var mNumberOfFriendlyTiles:int;
      
      public var mMapSetupData:Object;
      
      public function MapData()
      {
         super();
      }
      
      private static function initArrays() : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc1_:Object = GameState.mConfig.TileType;
         TILES_PASSABILITY = new Array();
         TILES_MAP_TYPE = new Array();
         for each(_loc2_ in _loc1_)
         {
            TILES_PASSABILITY[_loc2_.ID] = TILE_PASSABILITY_STRING_TO_ID[_loc2_.Passability.ID];
            _loc3_ = String(_loc2_.MapType.ID);
            if(_loc3_ == "Grassland")
            {
               TILES_MAP_TYPE[_loc2_.ID] = TILE_MAP_TYPE_GRASSLANDS;
            }
            else if(_loc3_ == "Desert")
            {
               TILES_MAP_TYPE[_loc2_.ID] = TILE_MAP_TYPE_DESERT;
            }
         }
      }
      
      public static function isTilePassable(param1:int) : Boolean
      {
         return TILES_PASSABILITY[param1] == TILE_LAND;
      }
      
      public function initFromServer(param1:ServerCall) : void
      {
         var _loc2_:int = 0;
         var _loc5_:String = null;
         var _loc10_:Array = null;
         var _loc14_:GridCell = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         if(!param1)
         {
            this.initOfflineMap("Home",false);
         }
         initArrays();
         this.mUpdateRequired = true;
         var _loc3_:Object = GameState.mConfig;
         var _loc4_:DCResourceManager = DCResourceManager.getInstance();
         var _loc6_:String = null;
         if(param1.mData.map_id)
         {
            _loc6_ = String(param1.mData.map_id);
         }
         else if(param1.mData.tutor_map)
         {
            _loc6_ = "Tutor";
         }
         else
         {
            _loc6_ = "Home";
         }
         var _loc7_:Object = _loc3_.MapSetup[_loc6_];
         this.mMapSetupData = _loc7_;
         var _loc9_:int;
         var _loc8_:String;
         if((_loc9_ = (_loc8_ = String(_loc7_.TilemapFileName)).lastIndexOf(".")) > 0)
         {
            if(EXTENSIONS_TO_REMOVE_FROM_NAME.indexOf(_loc8_.substr(_loc8_.lastIndexOf("."))) >= 0)
            {
               _loc8_ = _loc8_.substring(0,_loc8_.lastIndexOf("."));
            }
         }
         _loc5_ = _loc4_.get(_loc8_);
         this.mGridWidth = _loc7_.Width;
         this.mGridHeight = _loc7_.Height;
         if(FeatureTuner.LOAD_TILE_MAP_CSV)
         {
            _loc10_ = _loc5_.split(",");
         }
         _loc2_ = this.mGridWidth * this.mGridHeight;
         this.mGrid = new Array(_loc2_);
         var _loc11_:int = 0;
         while(_loc11_ < this.mGrid.length)
         {
            (_loc14_ = new GridCell(_loc11_ % this.mGridWidth,_loc11_ / this.mGridWidth)).mWalkable = false;
            if(FeatureTuner.LOAD_TILE_MAP_CSV)
            {
               _loc14_.mType = _loc10_[_loc11_];
               if(isTilePassable(_loc10_[_loc11_]))
               {
                  _loc14_.mOwner = TILE_OWNER_ENEMY;
               }
               else
               {
                  _loc14_.mOwner = TILE_OWNER_NEUTRAL;
               }
            }
            else
            {
               _loc14_.mOwner = TILE_OWNER_ENEMY;
            }
            this.mGrid[_loc11_] = _loc14_;
            _loc11_++;
         }
         GameState.mInstance.mPlayerProfile.mSecsSinceLastEnemySpawn = param1.mData.secs_since_last_enemy_spawn;
         GameState.mInstance.setSpawnTimer();
         var _loc12_:Array = param1.mData.player_tiles;
         var _loc13_:int = 0;
         while(_loc13_ < _loc12_.length)
         {
            _loc15_ = int((_loc12_[_loc13_] as Object).coord_x);
            _loc16_ = int((_loc12_[_loc13_] as Object).coord_y);
            (this.mGrid[_loc16_ * this.mGridWidth + _loc15_] as GridCell).mOwner = TILE_OWNER_FRIENDLY;
            _loc13_++;
         }
         this.countFriendlyTiles();
      }
      
      public function initOfflineMap(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:int = 0;
         var _loc6_:String = null;
         var _loc10_:Array = null;
         var _loc12_:GridCell = null;
         initArrays();
         this.mUpdateRequired = true;
         var _loc4_:Object = GameState.mConfig;
         var _loc5_:DCResourceManager = DCResourceManager.getInstance();
         var _loc7_:Object = _loc4_.MapSetup[param1];
         this.mMapSetupData = _loc7_;
         var _loc9_:int;
         var _loc8_:String;
         if((_loc9_ = (_loc8_ = String(_loc7_.TilemapFileName)).lastIndexOf(".")) > 0)
         {
            if(EXTENSIONS_TO_REMOVE_FROM_NAME.indexOf(_loc8_.substr(_loc8_.lastIndexOf("."))) >= 0)
            {
               _loc8_ = _loc8_.substring(0,_loc8_.lastIndexOf("."));
            }
         }
         _loc6_ = _loc5_.get(_loc8_);
		 trace("wtf is this: " + _loc6_);
         this.mGridWidth = _loc7_.Width;
         this.mGridHeight = _loc7_.Height;
         if(FeatureTuner.LOAD_TILE_MAP_CSV)
         {
            _loc10_ = _loc6_.split(",");
         }
         _loc3_ = this.mGridWidth * this.mGridHeight;
         this.mGrid = new Array(_loc3_);
         var _loc11_:int = 0;
         while(_loc11_ < this.mGrid.length)
         {
            (_loc12_ = new GridCell(_loc11_ % this.mGridWidth,_loc11_ / this.mGridWidth)).mWalkable = false;
            if(FeatureTuner.LOAD_TILE_MAP_CSV)
            {
               _loc12_.mType = _loc10_[_loc11_];
               if(isTilePassable(_loc10_[_loc11_]))
               {
                  _loc12_.mOwner = TILE_OWNER_ENEMY; // Modified to load desert as enemy: needs to be updated if we add friends.
               }
               else
               {
                  _loc12_.mOwner = TILE_OWNER_NEUTRAL;
               }
            }
            else
            {
               _loc12_.mOwner = param2 ? TILE_OWNER_FRIENDLY : TILE_OWNER_ENEMY;
            }
            this.mGrid[_loc11_] = _loc12_;
            _loc11_++;
         }
         if(this.mGrid.length > 4814)
         {
            if(param1 == "Home")
            {
               (this.mGrid[4601] as GridCell).mOwner = 1;
               (this.mGrid[4602] as GridCell).mOwner = 1;
               (this.mGrid[4670] as GridCell).mOwner = 1;
               (this.mGrid[4671] as GridCell).mOwner = 1;
               (this.mGrid[4673] as GridCell).mOwner = 1;
               (this.mGrid[4674] as GridCell).mOwner = 1;
               (this.mGrid[4740] as GridCell).mOwner = 1;
               (this.mGrid[4741] as GridCell).mOwner = 1;
               (this.mGrid[4742] as GridCell).mOwner = 1;
               (this.mGrid[4743] as GridCell).mOwner = 1;
               (this.mGrid[4744] as GridCell).mOwner = 1;
               (this.mGrid[4810] as GridCell).mOwner = 1;
               (this.mGrid[4811] as GridCell).mOwner = 1;
               (this.mGrid[4812] as GridCell).mOwner = 1;
               (this.mGrid[4813] as GridCell).mOwner = 1;
               (this.mGrid[4814] as GridCell).mOwner = 1;
            } else if(param1 == "Desert") {
               (this.mGrid[4881] as GridCell).mOwner = 1;
               (this.mGrid[4882] as GridCell).mOwner = 1;
               (this.mGrid[4883] as GridCell).mOwner = 1;
               (this.mGrid[4884] as GridCell).mOwner = 1;
			}
         }
         this.countFriendlyTiles();
      }
      
      public function destroy() : void
      {
         this.mMapSetupData = null;
      }
      
      public function getType(param1:int, param2:int) : int
      {
         return (this.mGrid[param2 * this.mGridWidth + param1] as GridCell).mType;
      }
      
      public function hasFog(param1:int, param2:int) : Boolean
      {
         return (this.mGrid[param2 * this.mGridWidth + param1] as GridCell).hasFog();
      }
      
      public function isFriendly(param1:int, param2:int) : Boolean
      {
         if(param1 < 0 || param1 >= this.mGridWidth || param2 < 0 || param2 >= this.mGridHeight)
         {
            return false;
         }
         return (this.mGrid[param2 * this.mGridWidth + param1] as GridCell).mOwner == TILE_OWNER_FRIENDLY;
      }
      
      public function getNeighbourUp(param1:GridCell) : GridCell
      {
         if((param1.mPosJ - 1) * this.mGridWidth + param1.mPosI < 0)
         {
            return null;
         }
         return this.mGrid[(param1.mPosJ - 1) * this.mGridWidth + param1.mPosI];
      }
      
      public function getNeighbourDown(param1:GridCell) : GridCell
      {
         if((param1.mPosJ + 1) * this.mGridWidth + param1.mPosI >= this.mGrid.length)
         {
            return null;
         }
         return this.mGrid[(param1.mPosJ + 1) * this.mGridWidth + param1.mPosI];
      }
      
      public function getNeighbourLeft(param1:GridCell) : GridCell
      {
         if(param1.mPosI % this.mGridWidth == 0)
         {
            return null;
         }
         return this.mGrid[param1.mPosJ * this.mGridWidth + (param1.mPosI - 1)];
      }
      
      public function getNeighbourRight(param1:GridCell) : GridCell
      {
         if(param1.mPosI % this.mGridWidth == this.mGridWidth - 1)
         {
            return null;
         }
         return this.mGrid[param1.mPosJ * this.mGridWidth + (param1.mPosI + 1)];
      }
      
      public function countFriendlyTiles() : void
      {
         var _loc2_:int = 0;
         var _loc1_:GameState = GameState.mInstance;
         if(!_loc1_.visitingFriend())
         {
            if(_loc1_.mCurrentMapId == "Home")
            {
               this.mNumberOfFriendlyTiles = 0;
               _loc2_ = 0;
               while(_loc2_ < this.mGrid.length)
               {
                  if((this.mGrid[_loc2_] as GridCell).mOwner == MapData.TILE_OWNER_FRIENDLY)
                  {
                     ++this.mNumberOfFriendlyTiles;
                  }
                  _loc2_++;
               }
            }
         }
      }
   }
}
