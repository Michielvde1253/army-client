package game.utils
{
   import flash.display.DisplayObject;
   
   public class ScreenShakeEffect
   {
       
      
      private var mTarget:DisplayObject;
      
      private var mCounter:int;
      
      private var mDuration:int;
      
      private var mStartX:int;
      
      private var mStartY:int;
      
      private var mShakeX:int;
      
      private var mShakeY:int;
      
      public var mStarted:Boolean;
      
      public function ScreenShakeEffect(param1:DisplayObject, param2:int, param3:int, param4:int)
      {
         super();
         this.mTarget = param1;
         this.mStartX = param1.x;
         this.mStartY = param1.y;
         this.mShakeX = param3;
         this.mShakeY = param4;
         this.mDuration = this.mCounter = param2;
      }
      
      public function update() : void
      {
         if(!this.mStarted)
         {
            return;
         }
         if(this.mCounter > 0)
         {
            --this.mCounter;
            this.mTarget.x = Math.random() * this.mShakeX / 2 - this.mShakeX + this.mStartX;
            this.mTarget.y = Math.random() * this.mShakeY / 2 - this.mShakeY + this.mStartY;
         }
         else
         {
            this.destroy();
         }
      }
      
      public function destroy() : void
      {
         if(this.mTarget)
         {
            this.mTarget.x = this.mStartX;
            this.mTarget.y = this.mStartY;
            this.mTarget = null;
         }
      }
   }
}
