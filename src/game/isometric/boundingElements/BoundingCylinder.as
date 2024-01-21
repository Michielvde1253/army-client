package game.isometric.boundingElements
{
   public class BoundingCylinder extends BoundingElement
   {
       
      
      public var mHeight:Number;
      
      public var mRadius:Number;
      
      public function BoundingCylinder(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number)
      {
         super();
         setLocation(param1,param2,param3);
         this.mHeight = param4;
         this.mRadius = param5;
         mBoundingRadius = Math.max(0.71 * param4,param5);
      }
   }
}
