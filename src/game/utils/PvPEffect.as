package game.utils
{
   import flash.display.MovieClip;
   import com.dchoc.graphics.DCResourceManager;
   
   public class PvPEffect extends Effect
   {
	   
	  public var mEffectClipName:String;
       
      
      public function PvPEffect()
      {
         super();
      }
  
      override public function start(param1:MovieClip, param2:int, effectClipName:String = "") : void
      {
         this.mTimer = 0;
         this.mMC = param1;
         this.mType = param2;
		 this.mEffectClipName = effectClipName;
         this.setEffectSpecificValues();
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
		  
		 // No longer needed as we now load the MovieClip directly in PowerUpObject.as through the config.
		  
		 
         var _loc3_:Class = null;
         var _loc1_:DCResourceManager = DCResourceManager.getInstance();
		  
		 /*
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
		 */
		 trace("Clip name:")
		 trace(mEffectClipName)
         if(mEffectClipName != "")
         {
            _loc3_ = _loc1_.getSWFClass("swf/pvp_effects",mEffectClipName);
            if(_loc3_ != null)
            {
               mMC = new _loc3_();
               mMC.gotoAndPlay(1);
            }
         }
      }
   }
}
