package game.utils
{
   import com.dchoc.graphics.DCResourceManager;
   
   public class PvPEffect extends Effect
   {
       
      
      public function PvPEffect()
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
         var _loc3_:Class = null;
         var _loc1_:DCResourceManager = DCResourceManager.getInstance();
         var _loc2_:String = "";
         if(mType == EffectController.EFFECT_TYPE_POWER_UP_HEALTH_PACK)
         {
            _loc2_ = "power_up_health_pack_effect";
         }
         else if(mType == EffectController.EFFECT_TYPE_POWER_UP_PARATROOPER)
         {
            _loc2_ = "power_up_paratrooper_effect";
         }
         else if(mType == EffectController.EFFECT_TYPE_POWER_UP_AIR_SUPPORT)
         {
            _loc2_ = "power_up_air_support_1_effect";
         }
         if(_loc2_ != "")
         {
            _loc3_ = _loc1_.getSWFClass("swf/pvp_effects",_loc2_);
            if(_loc3_ != null)
            {
               mMC = new _loc3_();
               mMC.gotoAndPlay(1);
            }
         }
      }
   }
}
