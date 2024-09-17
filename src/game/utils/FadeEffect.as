package game.utils
{
   public class FadeEffect extends Effect
   {
      
      public static const FADE_STATE_NONE:int = 0;
      
      public static const FADE_STATE_IN:int = 1;
      
      public static const FADE_STATE_OUT:int = 2;
       
      
      public var mFadeState:int;
      
      public function FadeEffect()
      {
         super();
         this.mFadeState = FADE_STATE_NONE;
      }
      
      override public function setEffectSpecificValues() : void
      {
         if(!mMC)
         {
            this.mFadeState = FADE_STATE_NONE;
         }
         if(mType == EffectController.EFFECT_TYPE_FADE_IN)
         {
            this.mFadeState = FADE_STATE_IN;
            mMC.visible = false;
         }
         else
         {
            this.mFadeState = FADE_STATE_OUT;
            mMC.visible = true;
         }
      }
      
      override public function update(param1:int) : Boolean
      {
         if(!mMC)
         {
            return true;
         }
         return true;
      }
   }
}
