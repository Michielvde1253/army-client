package game.utils
{
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   
   public class ColorFadeEffect
   {
       
      
      private var mTarget:DisplayObject;
      
      private var mCounter:int;
      
      private var mDuration:int;
      
      public var mStartR:Number;
      
      public var mStartG:Number;
      
      public var mStartB:Number;
      
      public var mStarted:Boolean;
      
      public function ColorFadeEffect(param1:DisplayObject, param2:int, param3:Number, param4:Number, param5:Number)
      {
         super();
         this.mDuration = this.mCounter = param2;
         this.mTarget = param1;
         this.mStartR = param3;
         this.mStartG = param4;
         this.mStartB = param5;
      }
      
      public function update() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(!this.mStarted)
         {
            return;
         }
         if(this.mCounter > 0)
         {
            --this.mCounter;
            _loc1_ = 1 + (this.mStartR - 1) * this.mCounter / this.mDuration;
            _loc2_ = 1 + (this.mStartG - 1) * this.mCounter / this.mDuration;
            _loc3_ = 1 + (this.mStartB - 1) * this.mCounter / this.mDuration;
            this.mTarget.transform.colorTransform = new ColorTransform(_loc1_,_loc2_,_loc3_,1,0,0,0,0);
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
            this.mTarget.transform.colorTransform = new ColorTransform();
            this.mTarget = null;
         }
      }
   }
}
