package game.utils
{
   import flash.display.MovieClip;
   
   public class Effect
   {
       
      
      public var mTimer:int;
      
      public var mMaxTime:int;
      
      public var mMC:MovieClip;
      
      public var mType:int;
      
      public function Effect()
      {
         super();
         this.mTimer = 0;
         this.mMaxTime = 100;
      }
      
      public function start(param1:MovieClip, param2:int) : void
      {
         this.mTimer = 0;
         this.mMC = param1;
         this.mType = param2;
         this.setEffectSpecificValues();
      }
      
      public function setEffectSpecificValues() : void
      {
      }
      
      public function update(param1:int) : Boolean
      {
         this.mTimer += param1;
         if(this.mTimer >= this.mMaxTime)
         {
            this.mTimer = this.mMaxTime;
            if(Boolean(this.mMC) && Boolean(this.mMC.parent))
            {
               this.mMC.parent.removeChild(this.mMC);
            }
            this.mMC = null;
            return true;
         }
         return false;
      }
   }
}
