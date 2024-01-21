package game.isometric
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   public class ToScreen
   {
      
      public static var smWorldToScreen:Matrix;
      
      public static var smScreenToWorld:Matrix;
      
      public static var smTileHToScreen:Number = 24;
      
      private static var mVecOut:Vector3D = new Vector3D();
      
      private static var mVecIn:Vector3D = new Vector3D();
       
      
      public function ToScreen()
      {
         super();
      }
      
      public static function init(param1:IsometricScene) : void
      {
         smTileHToScreen = 30;
         smWorldToScreen = new Matrix();
         smTileHToScreen /= param1.mGridDimX;
         smScreenToWorld = smWorldToScreen.clone();
         smScreenToWorld.invert();
      }
      
      public static function transformVec(param1:Vector3D, param2:Vector3D) : void
      {
         param1.x = smWorldToScreen.a * param2.x + smWorldToScreen.b * param2.y;
         param1.y = smWorldToScreen.c * param2.x + smWorldToScreen.d * param2.y - param2.z * smTileHToScreen;
         param1.z = 0;
      }
      
      public static function transform(param1:Point, param2:Number, param3:Number, param4:Number) : void
      {
         mVecIn.x = param2;
         mVecIn.y = param3;
         mVecIn.z = param4;
         transformVec(mVecOut,mVecIn);
         param1.x = mVecOut.x;
         param1.y = mVecOut.y;
      }
      
      public static function inverseTransform(param1:Point, param2:Number, param3:Number, param4:Number) : void
      {
         param1.x = smScreenToWorld.a * param2 + smScreenToWorld.b * param3;
         param1.y = smScreenToWorld.c * param2 + smScreenToWorld.d * param3;
      }
   }
}
