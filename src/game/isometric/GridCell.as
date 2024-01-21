package game.isometric
{
   import game.battlefield.MapData;
   import game.gameElements.PowerUpObject;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.Renderable;
   
   public class GridCell
   {
       
      
      public var mPosI:int;
      
      public var mPosJ:int;
      
      public var mWalkable:Boolean;
      
      public var mObject:Renderable;
      
      public var mDefaultWalkable:Boolean;
      
      public var mFogEdgeBits:int;
      
      public var mBorderEdgeBits:int;
      
      public var mType:int;
      
      public var mOwner:int;
      
      public var mViewers:int;
      
      public var mCloudBits:int;
      
      public var mCharacter:IsometricCharacter;
      
      public var mCharacterComingToThisTile:IsometricCharacter;
      
      public var mPathCost:Number;
      
      public var mG:Number;
      
      public var mHeuristic:Number;
      
      public var mParent:GridCell;
      
      public var mDynamicObjects:Array;
      
      public var mNeighborActionAvailable:Boolean;
      
      public var mPowerUp:PowerUpObject;
      
      public function GridCell(param1:int, param2:int)
      {
         this.mDynamicObjects = new Array();
         super();
         this.mPosI = param1;
         this.mPosJ = param2;
         this.mDefaultWalkable = true;
         this.mPathCost = 0;
         this.mNeighborActionAvailable = true;
      }
      
      public function hasFog() : Boolean
      {
         return this.mViewers == 0 && this.mOwner != MapData.TILE_OWNER_FRIENDLY;
      }
   }
}
