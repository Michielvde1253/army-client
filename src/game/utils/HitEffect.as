package game.utils
{
   import com.dchoc.graphics.DCResourceManager;
   
   public class HitEffect extends Effect
   {
       
      
      public function HitEffect()
      {
         super();
      }
      
      override public function update(param1:int) : Boolean
      {
         if(!mMC)
         {
            return true;
         }
         var _loc2_:String = mMC.currentFrameLabel;
         if(_loc2_ == "end")
         {
            mMC.gotoAndStop(1);
            mMC.visible = false;
            if(mMC.parent)
            {
               mMC.parent.removeChild(mMC);
            }
            mMC = null;
            return true;
         }
         return false;
      }
      
      override public function setEffectSpecificValues() : void
      {
         var _loc1_:DCResourceManager = DCResourceManager.getInstance();
         var _loc2_:String = "bullet_hitting";
         if(mType == EffectController.EFFECT_TYPE_HIT_EXPLOSION)
         {
            _loc2_ = "explosion_small_sequence";
         }
         else if(mType == EffectController.EFFECT_TYPE_BIG_EXPLOSION)
         {
            _loc2_ = "effect_explosion";
         }
         else if(mType == EffectController.EFFECT_TYPE_HIT_LIGHTNING)
         {
            _loc2_ = "electric_hitting";
         }
         else if(mType == EffectController.EFFECT_TYPE_LIGHTNING_BUBBLE)
         {
            _loc2_ = "electric_bubble";
         }
         var _loc3_:Class = _loc1_.getSWFClass(Config.SWF_EFFECTS_NAME,_loc2_);
         if(_loc3_ != null)
         {
            mMC = new _loc3_();
            mMC.gotoAndPlay(1);
         }
      }
   }
}
