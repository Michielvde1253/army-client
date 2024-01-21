package game.environment
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class AirplaneWedge extends RandomEffect
   {
       
      
      private var SPEED:int = 50;
      
      public function AirplaneWedge()
      {
         var _loc1_:Class = null;
         var _loc2_:Sprite = null;
         super();
         mParent = mScene.mSceneHud;
         if(FeatureTuner.USE_AIRPLANE_WEDGE_EFFECTS)
         {
            if(mGraphicsLoaded)
            {
               _loc1_ = DCResourceManager.getInstance().getSWFClass("swf/effects_environment","airplanes_animation");
               _loc2_ = new _loc1_();
               mClip = new Bitmap(new BitmapData(_loc2_.width,_loc2_.height,true,0));
               Bitmap(mClip).bitmapData.draw(_loc2_,new Matrix(1,0,0,1,-_loc2_.getBounds(_loc2_).x,-_loc2_.getBounds(_loc2_).y));
               mClip.y = mScene.mCamera.getCameraY() + (Math.random() * 400 - 200) / mScene.mContainer.scaleX;
               if(0 == int(Math.random() * 2))
               {
                  mClip.rotation = 180;
                  mClip.x = mScene.mGridDimX * mScene.mSizeX;
                  this.SPEED = -this.SPEED;
               }
               addToParent();
            }
         }
      }
      
      override public function update(param1:int) : Boolean
      {
         if(FeatureTuner.USE_AIRPLANE_WEDGE_EFFECTS)
         {
            if(!mClip || mClip.x > mScene.mGridDimX * mScene.mSizeX || mClip.x < 0)
            {
               destroy();
               return true;
            }
            mClip.x += this.SPEED * param1 / 25;
            return false;
         }
         return true;
      }
   }
}
