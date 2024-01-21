package game.isometric.boundingElements
{
   public class BoundingElement
   {
       
      
      public var mX:Number;
      
      public var mY:Number;
      
      public var mZ:Number;
      
      public var mBoundingRadius:Number;
      
      public function BoundingElement()
      {
         super();
      }
      
      public function setLocation(param1:Number, param2:Number, param3:Number) : void
      {
         this.mX = param1;
         this.mY = param2;
         this.mZ = param3;
      }
   }
}
