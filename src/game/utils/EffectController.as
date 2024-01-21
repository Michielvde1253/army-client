package game.utils
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import game.isometric.IsometricScene;
   import game.states.GameState;
   
   public class EffectController
   {
      
      public static const EFFECT_TYPE_FADE_IN:int = 0;
      
      public static const EFFECT_TYPE_FADE_OUT:int = 1;
      
      public static const EFFECT_TYPE_HIT_BULLET:int = 2;
      
      public static const EFFECT_TYPE_HIT_EXPLOSION:int = 3;
      
      public static const EFFECT_TYPE_BIG_EXPLOSION:int = 4;
      
      public static const EFFECT_TYPE_HIT_LIGHTNING:int = 5;
      
      public static const EFFECT_TYPE_LIGHTNING_BUBBLE:int = 6;
      
      public static const EFFECT_TYPE_POWER_UP_HEALTH_PACK:int = 7;
      
      public static const EFFECT_TYPE_POWER_UP_PARATROOPER:int = 8;
      
      public static const EFFECT_TYPE_POWER_UP_AIR_SUPPORT:int = 9;
       
      
      private var mActiveEffects:Array;
      
      public function EffectController()
      {
         super();
         this.mActiveEffects = new Array();
      }
      
      public static function getEffectLength(param1:int) : int
      {
         if(param1 == EFFECT_TYPE_HIT_EXPLOSION || param1 == EFFECT_TYPE_BIG_EXPLOSION)
         {
            return GameState.mConfig.GraphicSetup.Explosion.Length;
         }
         if(param1 == EFFECT_TYPE_HIT_LIGHTNING || param1 == EFFECT_TYPE_LIGHTNING_BUBBLE)
         {
            return GameState.mConfig.GraphicSetup.Lighting_hit.Length;
         }
         return GameState.mConfig.GraphicSetup.Shooting.Length;
      }
      
      public function startEffect(param1:IsometricScene, param2:MovieClip, param3:int, param4:int, param5:int) : Boolean
      {
         var _loc6_:int = 0;
         var _loc10_:FadeEffect = null;
         var _loc11_:String = null;
         var _loc12_:HitEffect = null;
         var _loc13_:PvPEffect = null;
         _loc6_ = -1;
         var _loc7_:int = 0;
         while(_loc7_ < this.mActiveEffects.length)
         {
            if(!this.mActiveEffects[_loc7_])
            {
               _loc6_ = _loc7_;
               break;
            }
            _loc7_++;
         }
         var _loc8_:Effect = null;
         var _loc9_:DCResourceManager = DCResourceManager.getInstance();
         switch(param3)
         {
            case EFFECT_TYPE_FADE_IN:
               (_loc10_ = new FadeEffect()).start(param2,param3);
               _loc8_ = _loc10_;
               break;
            case EFFECT_TYPE_FADE_OUT:
               (_loc10_ = new FadeEffect()).start(param2,param3);
               _loc8_ = _loc10_;
               break;
            case EFFECT_TYPE_HIT_BULLET:
            case EFFECT_TYPE_HIT_EXPLOSION:
            case EFFECT_TYPE_BIG_EXPLOSION:
            case EFFECT_TYPE_HIT_LIGHTNING:
            case EFFECT_TYPE_LIGHTNING_BUBBLE:
               _loc11_ = Config.SWF_EFFECTS_NAME;
               if(_loc9_.isLoaded(_loc11_))
               {
                  (_loc12_ = new HitEffect()).start(param2,param3);
                  _loc8_ = _loc12_;
               }
               else if(!_loc9_.isAddedToLoadingList(_loc11_))
               {
                  _loc9_.load(Config.DIR_DATA + _loc11_ + ".swf",_loc11_,null,false);
                  return false;
               }
               break;
            case EFFECT_TYPE_POWER_UP_HEALTH_PACK:
            case EFFECT_TYPE_POWER_UP_PARATROOPER:
            case EFFECT_TYPE_POWER_UP_AIR_SUPPORT:
               _loc11_ = "swf/pvp_effects";
               if(_loc9_.isLoaded(_loc11_))
               {
                  (_loc13_ = new PvPEffect()).start(param2,param3);
                  _loc8_ = _loc13_;
               }
               else if(!_loc9_.isAddedToLoadingList(_loc11_))
               {
                  _loc9_.load(Config.DIR_DATA + _loc11_ + ".swf",_loc11_,null,false);
                  return false;
               }
         }
         if(_loc8_)
         {
            _loc8_.mMC.x = param4;
            _loc8_.mMC.y = param5;
            param1.mSceneHud.addChild(_loc8_.mMC);
            if(_loc6_ == -1)
            {
               this.mActiveEffects.push(_loc8_);
            }
            else
            {
               this.mActiveEffects[_loc6_] = _loc8_;
            }
            return true;
         }
         return false;
      }
      
      public function update(param1:int) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < this.mActiveEffects.length)
         {
            if(this.mActiveEffects[_loc3_])
            {
               _loc2_ = false;
               if(_loc4_ = (this.mActiveEffects[_loc3_] as Effect).update(param1))
               {
                  this.mActiveEffects[_loc3_] = null;
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}
