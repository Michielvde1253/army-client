package game.isometric.pathfinding
{
   import flash.geom.Vector3D;
   import game.isometric.GridCell;
   import game.isometric.characters.IsometricCharacter;
   
   public class GridCollisionInfo
   {
       
      
      public var mCollisionPoint:Vector3D;
      
      public var mCollisionNormal:Vector3D;
      
      public var mCollisionCell:GridCell;
      
      public var mWallCollision:Boolean;
      
      public var mCollisionCharacter:IsometricCharacter;
      
      public function GridCollisionInfo()
      {
         this.mCollisionPoint = new Vector3D();
         this.mCollisionNormal = new Vector3D();
         super();
      }
   }
}
