package game.environment
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import game.battlefield.MapData;
   import game.isometric.GridCell;
   import game.isometric.SceneLoader;
   import game.states.GameState;
   
   public class RiverEffect extends RandomEffect
   {
      
      private static var mGoodClips:Array;
      
      private static var mBadClips:Array;
       
      
      public function RiverEffect(param1:Array)
      {
         var _loc2_:Class = null;
         var _loc3_:GridCell = null;
         var _loc4_:Array = null;
         var _loc5_:MapData = null;
         var _loc6_:GridCell = null;
         super();
         mParent = mScene.mContainer;
         if(mGraphicsLoaded)
         {
            if(!mGoodClips)
            {
               mGoodClips = new Array();
               _loc2_ = DCResourceManager.getInstance().getSWFClass("swf/new_backgroud_01","Bg_RiverTile_Shine_03");
               mGoodClips.push(_loc2_);
               _loc2_ = DCResourceManager.getInstance().getSWFClass("swf/new_backgroud_01","Bg_RiverTile_Shine_02");
               mGoodClips.push(_loc2_);
               _loc2_ = DCResourceManager.getInstance().getSWFClass("swf/new_backgroud_01","Bg_RiverTile_Shine_05");
               mGoodClips.push(_loc2_);
               _loc2_ = DCResourceManager.getInstance().getSWFClass("swf/new_backgroud_01","Bg_RiverTile_Shine_01");
               mGoodClips.push(_loc2_);
               mBadClips = new Array();
               _loc2_ = DCResourceManager.getInstance().getSWFClass("swf/new_backgroud_01","Bg_BadRiverTile_Bubbles_03");
               mBadClips.push(_loc2_);
               _loc2_ = DCResourceManager.getInstance().getSWFClass("swf/new_backgroud_01","Bg_BadRiverTile_Bubbles_02");
               mBadClips.push(_loc2_);
               _loc2_ = DCResourceManager.getInstance().getSWFClass("swf/new_backgroud_01","Bg_BadRiverTile_Bubbles_05");
               mBadClips.push(_loc2_);
               _loc2_ = DCResourceManager.getInstance().getSWFClass("swf/new_backgroud_01","Bg_BadRiverTile_Bubbles_01");
               mBadClips.push(_loc2_);
            }
            _loc3_ = param1[int(Math.random() * param1.length)];
            _loc4_ = new Array();
            if(_loc3_.mOwner == MapData.TILE_OWNER_FRIENDLY)
            {
               _loc4_ = mGoodClips;
            }
            else
            {
               _loc4_ = mBadClips;
            }
            if(!(_loc6_ = (_loc5_ = GameState.mInstance.mMapData).getNeighbourUp(_loc3_)) || _loc6_.mType != MapData.TILE_TYPE_RIVER)
            {
               mClip = new _loc4_[2 + _loc3_.mPosJ % 2]();
            }
            else if(_loc3_.mPosJ < mScene.mSizeY - 2)
            {
               mClip = new _loc4_[_loc3_.mPosJ % 2]();
            }
         }
         if(mClip)
         {
            (mClip as MovieClip).gotoAndPlay(1);
            mClip.x = SceneLoader.GRID_CELL_SIZE * _loc3_.mPosI;
            mClip.y = SceneLoader.GRID_CELL_SIZE * _loc3_.mPosJ;
            this.addToParent();
         }
      }
      
      override public function addToParent() : void
      {
         mParent.addChildAt(mClip,0);
      }
      
      override public function update(param1:int) : Boolean
      {
         var _loc2_:MovieClip = mClip as MovieClip;
         if(!_loc2_ || _loc2_.currentFrame == _loc2_.totalFrames)
         {
            destroy();
            return true;
         }
         return false;
      }
   }
}
