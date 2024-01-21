package game.isometric.elements
{
   import game.isometric.IsometricScene;
   
   public class Element
   {
      
      public static var counter:int = 0;
       
      
      public var mName:String;
      
      public var mPortrait:String;
      
      public var mId:int;
      
      public var mX:int;
      
      public var mY:int;
      
      public var mZ:int;
      
      public var mScene:IsometricScene;
      
      public var mEnabled:Boolean;
      
      public function Element(param1:int, param2:IsometricScene, param3:String = null)
      {
         super();
         if(param3 == null)
         {
            this.mName = "Element_" + counter;
         }
         else
         {
            this.mName = param3;
         }
         this.mId = param1;
         this.mScene = param2;
         this.mEnabled = true;
      }
      
      public function setPos(param1:int, param2:int, param3:int) : void
      {
         this.mX = param1;
         this.mY = param2;
         this.mZ = param3;
      }
      
      public function getContainer() : DisplayContainer
      {
         return null;
      }
      
      public function destroy() : void
      {
         this.mScene = null;
      }
   }
}
