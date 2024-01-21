package game.isometric.elements
{
   import flash.display.Sprite;
   
   public class DisplayContainer extends Sprite
   {
       
      
      private var mRenderableObject:Renderable;
      
      public function DisplayContainer(param1:Renderable)
      {
         super();
         this.mRenderableObject = param1;
      }
      
      public function getRenderableObject() : Renderable
      {
         return this.mRenderableObject;
      }
   }
}
