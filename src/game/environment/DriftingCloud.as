package game.environment
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import game.states.GameState;
   
   public class DriftingCloud extends RandomEffect
   {
       
      
      private var SPEED:Number = 0.2;
      
      private var DURATION_MS:int = 100000;
      
      private var FADE_MS:int = 3000;
      
      private var mAge:int = 0;
      
      public function DriftingCloud()
      {
         var _loc1_:Class = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         super();
         mParent = mScene.mSceneHud;
         if(FeatureTuner.USE_CLOUD_EFFECTS)
         {
            if(mGraphicsLoaded)
            {
               _loc1_ = DCResourceManager.getInstance().getSWFClass("swf/effects_environment","cloud_animation_01");
               _loc2_ = new _loc1_();
               mClip = new Bitmap(new BitmapData(_loc2_.width,_loc2_.height,true,0),"never",true);
               Bitmap(mClip).bitmapData.draw(_loc2_,new Matrix(1,0,0,1,-_loc2_.getBounds(_loc2_).x,-_loc2_.getBounds(_loc2_).y));
               _loc3_ = GameState.mInstance.getStageWidth() / mScene.mContainer.scaleX;
               mScene.mCamera.getCameraX() - _loc3_ / 2 * Math.random();
               mClip.y = mScene.mCamera.getCameraY() + (Math.random() * 400 - 200) / mScene.mContainer.scaleX;
               mClip.x = mScene.mCamera.getCameraX() + (Math.random() * 600 - 300) / mScene.mContainer.scaleX;
               if(0.5 > Math.random())
               {
                  this.SPEED = -this.SPEED;
               }
               mClip.scaleX = 0.5 + Math.random();
               mClip.scaleY = 0.5 + Math.random();
               mClip.visible = false;
               addToParent();
            }
         }
      }
      
      override public function update(param1:int) : Boolean
      {
         if(FeatureTuner.USE_CLOUD_EFFECTS)
         {
            if(!mClip || this.mAge > this.DURATION_MS)
            {
               destroy();
               return true;
            }
            if(this.mAge < this.FADE_MS)
            {
               if(!mClip.visible)
               {
                  mClip.visible = true;
               }
               mClip.alpha = this.mAge / this.FADE_MS;
            }
            else if(this.mAge > this.DURATION_MS - this.FADE_MS)
            {
               if(!mClip.visible)
               {
                  mClip.visible = true;
               }
               mClip.alpha = (this.DURATION_MS - this.mAge) / this.FADE_MS;
            }
            else if(mClip.alpha != 1)
            {
               if(!mClip.visible)
               {
                  mClip.visible = true;
               }
               mClip.alpha = 1;
            }
            this.mAge += param1;
            mClip.x -= this.SPEED * param1 / 25;
            return false;
         }
         return true;
      }
   }
}
