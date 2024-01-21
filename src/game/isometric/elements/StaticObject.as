package game.isometric.elements
{
   import game.isometric.IsometricScene;
   import game.items.MapItem;
   
   public class StaticObject extends WorldObject
   {
       
      
      public function StaticObject(param1:int, param2:IsometricScene, param3:MapItem, param4:String = null)
      {
         super(param1,param2,param3,param4);
         mMovable = true;
      }
      
      override public function setPos(param1:int, param2:int, param3:int) : void
      {
         super.setPos(param1,param2,param3);
      }
      
      public function logicUpdate(param1:int) : Boolean
      {
         return false;
      }
   }
}
