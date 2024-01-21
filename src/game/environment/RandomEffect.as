package game.environment
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import game.isometric.IsometricScene;
   import game.states.GameState;
   
   public class RandomEffect
   {
       
      
      protected var mScene:IsometricScene;
      
      protected var mClip:DisplayObject;
      
      protected var mParent:DisplayObjectContainer;
      
      protected var mGraphicsLoaded:Boolean;
      
      protected var mLoadingCallbackEventType:String;
      
      public var mDestroyed:Boolean;
      
      public function RandomEffect()
      {
         var _loc1_:DCResourceManager = null;
         var _loc2_:String = null;
         super();
         if(!this.mScene)
         {
            this.mScene = GameState.mInstance.mScene;
         }
         if(FeatureTuner.USE_RIVER_TILE_EFFECTS || FeatureTuner.USE_CLOUD_EFFECTS || FeatureTuner.USE_AIRPLANE_WEDGE_EFFECTS)
         {
            _loc1_ = DCResourceManager.getInstance();
            _loc2_ = "swf/effects_environment";
            if(_loc1_.isLoaded(_loc2_))
            {
               this.mGraphicsLoaded = true;
            }
            else
            {
               this.mGraphicsLoaded = false;
               if(!_loc1_.isAddedToLoadingList(_loc2_))
               {
                  _loc1_.load(Config.DIR_DATA + _loc2_ + ".swf",_loc2_,null,false);
               }
            }
         }
      }
      
      public function addToParent() : void
      {
         this.mParent.addChild(this.mClip);
      }
      
      public function update(param1:int) : Boolean
      {
         return true;
      }
      
      public function destroy() : void
      {
         if(this.mClip)
         {
            if(this.mClip.parent)
            {
               this.mClip.parent.removeChild(this.mClip);
            }
            if(this.mClip is Bitmap)
            {
               Bitmap(this.mClip).bitmapData.dispose();
            }
         }
         this.mParent = null;
         this.mScene = null;
         this.mClip = null;
         this.mDestroyed = true;
      }
   }
}
