package game.isometric.elements
{
   import flash.geom.Vector3D;
   import game.isometric.IsometricScene;
   
   public class Floor extends Renderable
   {
       
      
      protected var mDimensions:Vector3D;
      
      public function Floor(param1:IsometricScene, param2:String = null)
      {
         super(-1,param1,null,param2);
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         this.setDim(new Vector3D(param1,param2,0));
      }
      
      public function getGridTop() : int
      {
         return mScene.findGridLocationY(mY);
      }
      
      public function getGridBottom() : int
      {
         return mScene.findGridLocationY(mY + this.mDimensions.y);
      }
      
      public function getGridLeft() : int
      {
         return mScene.findGridLocationY(mX);
      }
      
      public function getGridRight() : int
      {
         return mScene.findGridLocationY(mX + this.mDimensions.x);
      }
      
      public function getMidPoint() : Vector3D
      {
         return new Vector3D(mX + this.mDimensions.x / 2,mY + this.mDimensions.y / 2,mZ + this.mDimensions.z / 2);
      }
      
      public function getDim() : Vector3D
      {
         return this.mDimensions;
      }
      
      public function setDim(param1:Vector3D) : void
      {
         this.mDimensions = param1.clone();
      }
   }
}
