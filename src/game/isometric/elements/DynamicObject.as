package game.isometric.elements
{
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.characters.IsometricCharacter;
   import game.items.MapItem;
   
   public class DynamicObject extends WorldObject
   {
       
      
      public function DynamicObject(param1:int, param2:IsometricScene, param3:MapItem, param4:String = null)
      {
         super(param1,param2,param3,param4);
         mWalkable = true;
      }
      
      override public function setPos(param1:int, param2:int, param3:int) : void
      {
         var _loc6_:int = 0;
         var _loc4_:GridCell = mScene.getCellAtLocation(mX,mY);
         super.setPos(param1,param2,param3);
         var _loc5_:GridCell;
         if((_loc5_ = mScene.getCellAtLocation(mX,mY)) != _loc4_)
         {
            if((_loc6_ = _loc4_.mDynamicObjects.indexOf(this)) >= 0)
            {
               _loc4_.mDynamicObjects.splice(_loc6_,1);
            }
            _loc5_.mDynamicObjects.push(this);
            if(!_loc5_.mCharacter && this is IsometricCharacter)
            {
               _loc5_.mCharacter = this as IsometricCharacter;
            }
            if(_loc4_.mCharacter == this as IsometricCharacter)
            {
               _loc4_.mCharacter = null;
            }
         }
      }
      
      public function removeFromGrid() : void
      {
         var _loc1_:GridCell = mScene.getCellAtLocation(mX,mY);
         var _loc2_:int = _loc1_.mDynamicObjects.indexOf(this);
         if(_loc2_ >= 0)
         {
            _loc1_.mDynamicObjects.splice(_loc2_,1);
         }
         else if(Config.DEBUG_MODE)
         {
         }
      }
      
      public function updateMovement(param1:int) : void
      {
      }
   }
}
