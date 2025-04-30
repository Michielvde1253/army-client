package game.isometric.pathfinding
{
   import flash.geom.Point;
   import game.battlefield.MapData;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.characters.IsometricCharacter;
   import game.states.GameState;
   
   internal class PathfindCriteria
   {
      
      private static const COST_ORTHOGONAL:Number = 1;
      
      private static const COST_DIAGONAL:Number = 1.4;
       
      
      private var mScene:IsometricScene;
      
      private var mWithDiagonals:Boolean;
      
      private var mConsiderCharacters:Boolean;
      
      private var mMoverType:int;
      
      private var mOrigin:Point;
      
      private var mDestiny:Point;
      
      private var mOriginCell:GridCell;
      
      private var mDestinyCell:GridCell;
      
      public function PathfindCriteria()
      {
         super();
      }
      
      public function setOptions(param1:IsometricScene, param2:Point, param3:Point, param4:Boolean, param5:Boolean, param6:int) : void
      {
         this.mScene = param1;
         this.mOrigin = param2;
         this.mDestiny = param3;
         this.mWithDiagonals = param4;
         this.mConsiderCharacters = param5;
         this.mMoverType = param6;
         if(param2)
         {
            this.mOriginCell = this.mScene.getCellAtLocation(param2.x,param2.y);
         }
         if(param3)
         {
            this.mDestinyCell = this.mScene.getCellAtLocation(param3.x,param3.y);
         }
      }
      
      public function getScene() : IsometricScene
      {
         return this.mScene;
      }
      
      public function getOrigin() : Point
      {
         return this.mOrigin;
      }
      
      public function getDestiny() : Point
      {
         return this.mDestiny;
      }
      
      public function getOriginCell() : GridCell
      {
         return this.mOriginCell;
      }
      
      public function getDestinyCell() : GridCell
      {
         return this.mDestinyCell;
      }
      
      public function getHeuristic(param1:GridCell) : Number
      {
         var _loc2_:int = param1.mPosI - this.mDestinyCell.mPosI;
         var _loc3_:int = param1.mPosJ - this.mDestinyCell.mPosJ;
         return Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_);
      }
      
      private function isCellTerrainPassableForMover(param1:GridCell, param2:int) : Boolean
      {
         if(GameState.mInstance.mState == GameState.STATE_PVP)
         {
            if(Boolean(param1.mCharacter) || Boolean(param1.mObject))
            {
               if((param2 & IsometricCharacter.MOVER_TYPE_STEALTH_FLAG) == 0)
               {
                  return false;
               }
            }
         }
         return (param2 & 1 << MapData.TILES_PASSABILITY[param1.mType] << IsometricCharacter.MOVER_TYPE_PASSABILITY_OFFSET) > 0;
      }
      
      public function getAccessibleFrom(param1:GridCell, param2:Array) : void
      {
         var _loc3_:GridCell = null;
         param2.length = 0;
         var _loc4_:* = (this.mMoverType & IsometricCharacter.MOVER_TYPE_FRIENDLY_FLAG) > 0;
         var _loc5_:* = (this.mMoverType & IsometricCharacter.MOVER_TYPE_STEALTH_FLAG) > 0;
         if(_loc4_ && !_loc5_ && param1.mOwner != MapData.TILE_OWNER_FRIENDLY)
         {
            return;
         }
         _loc3_ = this.mScene.getCellAt(param1.mPosI,param1.mPosJ - 1);
         if(Boolean(_loc3_) && this.isCellTerrainPassableForMover(_loc3_,this.mMoverType))
         {
            _loc3_.mPathCost = PathfindCriteria.COST_ORTHOGONAL;
            param2[param2.length] = _loc3_;
         }
         _loc3_ = this.mScene.getCellAt(param1.mPosI,param1.mPosJ + 1);
         if(Boolean(_loc3_) && this.isCellTerrainPassableForMover(_loc3_,this.mMoverType))
         {
            _loc3_.mPathCost = PathfindCriteria.COST_ORTHOGONAL;
            param2[param2.length] = _loc3_;
         }
         _loc3_ = this.mScene.getCellAt(param1.mPosI - 1,param1.mPosJ);
         if(Boolean(_loc3_) && this.isCellTerrainPassableForMover(_loc3_,this.mMoverType))
         {
            _loc3_.mPathCost = PathfindCriteria.COST_ORTHOGONAL;
            param2[param2.length] = _loc3_;
         }
         _loc3_ = this.mScene.getCellAt(param1.mPosI + 1,param1.mPosJ);
         if(Boolean(_loc3_) && this.isCellTerrainPassableForMover(_loc3_,this.mMoverType))
         {
            _loc3_.mPathCost = PathfindCriteria.COST_ORTHOGONAL;
            param2[param2.length] = _loc3_;
         }
         if(this.mWithDiagonals)
         {
            _loc3_ = this.mScene.getCellAt(param1.mPosI + 1,param1.mPosJ - 1);
            if(_loc3_ && this.isCellTerrainPassableForMover(_loc3_,this.mMoverType) && (_loc3_.mOwner == MapData.TILE_OWNER_FRIENDLY || !_loc4_ || _loc5_))
            {
               _loc3_.mPathCost = PathfindCriteria.COST_DIAGONAL;
               param2[param2.length] = _loc3_;
            }
            _loc3_ = this.mScene.getCellAt(param1.mPosI - 1,param1.mPosJ - 1);
            if(_loc3_ && this.isCellTerrainPassableForMover(_loc3_,this.mMoverType) && (_loc3_.mOwner == MapData.TILE_OWNER_FRIENDLY || !_loc4_ || _loc5_))
            {
               _loc3_.mPathCost = PathfindCriteria.COST_DIAGONAL;
               param2[param2.length] = _loc3_;
            }
            _loc3_ = this.mScene.getCellAt(param1.mPosI + 1,param1.mPosJ + 1);
            if(_loc3_ && this.isCellTerrainPassableForMover(_loc3_,this.mMoverType) && (_loc3_.mOwner == MapData.TILE_OWNER_FRIENDLY || !_loc4_ || _loc5_))
            {
               _loc3_.mPathCost = PathfindCriteria.COST_DIAGONAL;
               param2[param2.length] = _loc3_;
            }
            _loc3_ = this.mScene.getCellAt(param1.mPosI - 1,param1.mPosJ + 1);
            if(_loc3_ && this.isCellTerrainPassableForMover(_loc3_,this.mMoverType) && (_loc3_.mOwner == MapData.TILE_OWNER_FRIENDLY || !_loc4_ || _loc5_))
            {
               _loc3_.mPathCost = PathfindCriteria.COST_DIAGONAL;
               param2[param2.length] = _loc3_;
            }
         }
      }
      
      public function getEnemyAccessibleFrom(param1:GridCell, param2:Array) : void
      {
         var _loc3_:GridCell = null;
         var _loc4_:Boolean = false;
         param2.length = 0;
      }
   }
}
