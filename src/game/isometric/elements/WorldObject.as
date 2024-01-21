package game.isometric.elements
{
   import game.isometric.IsometricScene;
   import game.isometric.boundingElements.BoundingElement;
   import game.items.MapItem;
   
   public class WorldObject extends Renderable
   {
       
      
      public var mBoundingElement:BoundingElement;
      
      public function WorldObject(param1:int, param2:IsometricScene, param3:MapItem, param4:String = null)
      {
         super(param1,param2,param3,param4);
      }
   }
}
