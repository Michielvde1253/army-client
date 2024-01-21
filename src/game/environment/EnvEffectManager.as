package game.environment
{
   import game.battlefield.MapData;
   import game.isometric.GridCell;
   import game.states.GameState;
   
   public class EnvEffectManager
   {
      
      private static const RANDOM_PRC:int = 15;
      
      private static const EFFECTS_MAX_SIMULT_CLOUD:int = 3;
      
      private static const EFFECTS_DELAY_CLOUD:int = 100000;
      
      private static var mCloudClock:int;
      
      private static const EFFECTS_MAX_SIMULT_TILE:int = 5;
      
      private static const EFFECTS_DELAY_TILE:int = 1700;
      
      private static var mTileClock:int;
      
      private static const EFFECTS_MAX_SIMULT_FLY:int = 1;
      
      private static const EFFECTS_DELAY_FLY:int = 25000;
      
      private static var mFlyClock:int;
      
      private static var mClouds:Array;
      
      private static var mFly:Array;
      
      private static var mTile:Array;
      
      private static var mRiverTiles:Array;
       
      
      public function EnvEffectManager()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc2_:GridCell = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(mFly)
         {
            destroy();
         }
         mFly = new Array();
         mTile = new Array();
         mClouds = new Array();
         var _loc1_:Array = GameState.mInstance.mMapData.mGrid;
         if(!mRiverTiles)
         {
            mRiverTiles = new Array();
            _loc3_ = int(_loc1_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = _loc1_[_loc4_] as GridCell;
               if(_loc2_.mType == MapData.TILE_TYPE_RIVER)
               {
                  mRiverTiles.push(_loc2_);
               }
               _loc4_++;
            }
         }
      }
      
      public static function destroy() : void
      {
         var _loc1_:RandomEffect = null;
         var _loc4_:RandomEffect = null;
         var _loc7_:RandomEffect = null;
         var _loc2_:int = int(mClouds.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = mClouds[_loc3_] as RandomEffect;
            _loc1_.destroy();
            _loc3_++;
         }
         var _loc5_:int = int(mFly.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            (_loc4_ = mFly[_loc6_] as RandomEffect).destroy();
            _loc6_++;
         }
         var _loc8_:int = int(mTile.length);
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            (_loc7_ = mTile[_loc9_] as RandomEffect).destroy();
            _loc9_++;
         }
         mFly = null;
         mTile = null;
         mClouds = null;
         mRiverTiles = null;
      }
      
      public static function update(param1:int) : void
      {
         var _loc2_:RandomEffect = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(FeatureTuner.USE_AIRPLANE_WEDGE_EFFECTS)
         {
            if(mFlyClock > EFFECTS_DELAY_FLY && mFly.length < EFFECTS_MAX_SIMULT_FLY)
            {
               mFly.push(new AirplaneWedge());
               mFlyClock = Math.random() * (EFFECTS_DELAY_FLY / 100 * RANDOM_PRC);
            }
            else
            {
               mFlyClock += param1;
            }
         }
         if(FeatureTuner.USE_RIVER_TILE_EFFECTS)
         {
            if(mRiverTiles && mRiverTiles.length > 0 && mTileClock > EFFECTS_DELAY_TILE && mTile.length < EFFECTS_MAX_SIMULT_TILE)
            {
               mTile.push(new RiverEffect(mRiverTiles));
               mTileClock = Math.random() * (EFFECTS_DELAY_FLY / 100 * RANDOM_PRC);
            }
            else
            {
               mTileClock += param1;
            }
         }
         if(FeatureTuner.USE_CLOUD_EFFECTS)
         {
            if(mCloudClock > EFFECTS_DELAY_CLOUD && mClouds.length < EFFECTS_MAX_SIMULT_CLOUD)
            {
               if(GameState.mInstance.mCurrentMapId == "Desert")
               {
                  mTile.push(new DesertCloud());
               }
               else
               {
                  mTile.push(new DriftingCloud());
               }
               mCloudClock = Math.random() * (EFFECTS_DELAY_CLOUD / 100 * RANDOM_PRC);
            }
            else
            {
               mCloudClock += param1;
            }
         }
         if(FeatureTuner.USE_AIRPLANE_WEDGE_EFFECTS)
         {
            _loc3_ = 0;
            while(_loc3_ < mFly.length)
            {
               _loc2_ = mFly[_loc3_];
               if(_loc2_)
               {
                  if(_loc2_.update(param1) || _loc2_.mDestroyed)
                  {
                     mFly.splice(_loc3_,1);
                     _loc3_--;
                  }
               }
               _loc3_++;
            }
         }
         if(FeatureTuner.USE_RIVER_TILE_EFFECTS)
         {
            _loc4_ = 0;
            while(_loc4_ < mTile.length)
            {
               _loc2_ = mTile[_loc4_];
               if(_loc2_)
               {
                  if(_loc2_.update(param1) || _loc2_.mDestroyed)
                  {
                     mTile.splice(_loc4_,1);
                     _loc4_--;
                  }
               }
               _loc4_++;
            }
         }
         if(FeatureTuner.USE_CLOUD_EFFECTS)
         {
            _loc5_ = 0;
            while(_loc5_ < mClouds.length)
            {
               _loc2_ = mClouds[_loc5_];
               if(_loc2_)
               {
                  if(_loc2_.update(param1) || _loc2_.mDestroyed)
                  {
                     mClouds.splice(_loc5_,1);
                     _loc5_--;
                  }
               }
               _loc5_++;
            }
         }
      }
   }
}
