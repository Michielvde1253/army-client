package game.gameElements
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import game.isometric.elements.Renderable;
   import game.states.GameState;
   
   public class Projectile extends Sprite
   {
       
      
      protected var mProjectile:Sprite;
      
      protected var mAtTarget:Boolean;
      
      protected var mGraphicsLoaded:Boolean;
      
      protected var mLoadingCallbackEventType:String;
      
      protected var mFinished:Boolean;
      
      public function Projectile(param1:Renderable, param2:Number, param3:Number)
      {
         super();
         GameState.mInstance.mScene.mSceneHud.addChild(this);
         this.x = param1.mX;
         this.y = param1.mY;
      }
      
      public function update(param1:int) : Boolean
      {
         return true;
      }
      
      protected function LoadingFinished(param1:Event) : void
      {
         DCResourceManager.getInstance().removeEventListener(param1.type,this.LoadingFinished);
         this.mLoadingCallbackEventType = null;
         this.mGraphicsLoaded = true;
         this.addMissile();
      }
      
      protected function addMissile() : void
      {
      }
      
      public function destroy() : void
      {
         if(this.mLoadingCallbackEventType)
         {
            DCResourceManager.getInstance().removeEventListener(this.mLoadingCallbackEventType,this.LoadingFinished);
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         this.mFinished = true;
      }
   }
}
