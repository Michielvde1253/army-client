package game.gameElements
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import game.isometric.SceneLoader;
   import game.isometric.elements.Renderable;
   
   public class ArtilleryRound extends Projectile
   {
      
      private static const LAUNCH_DELAY_MS:int = 200;
       
      
      private var G:Number;
      
      private var mElevAngle:Number;
      
      private var mBearingAngle:Number;
      
      private var mVel:Number;
      
      private var mV:Vector3D;
      
      private var mPos:Vector3D;
      
      private var mTrail:Array;
      
      private var mTimer:int;
      
      public function ArtilleryRound(param1:Renderable, param2:Number, param3:Number)
      {
         var _loc7_:DCResourceManager = null;
         super(param1,param2,param3);
         this.mPos = new Vector3D();
         this.mTimer = 0;
         mouseEnabled = false;
         mouseChildren = false;
         var _loc4_:Number = param2 - this.x + Utils.randRange(-10,10);
         var _loc5_:Number = param3 - this.y + Utils.randRange(-10,10);
         var _loc6_:Point = new Point(_loc4_,_loc5_);
         this.G = 2 + (_loc6_.length / SceneLoader.GRID_CELL_SIZE - 1) * 0.3;
         this.mBearingAngle = Math.atan2(_loc4_,-_loc5_) - Math.PI / 2;
         this.mElevAngle = Math.PI / 10 * 4;
         this.mVel = Math.sqrt(this.G * _loc6_.length / Math.sin(2 * this.mElevAngle));
         this.mTrail = new Array();
         this.mV = new Vector3D();
         this.mPos = new Vector3D();
         this.mV.z = Math.sin(this.mElevAngle) * this.mVel;
         this.mV.x = Math.cos(this.mBearingAngle) * this.mVel * Math.cos(this.mElevAngle);
         this.mV.y = Math.sin(this.mBearingAngle) * this.mVel * Math.cos(this.mElevAngle);
         this.mTrail.push(0);
         this.mTrail.push(0);
         _loc7_ = DCResourceManager.getInstance();
         var _loc8_:String = Config.SWF_EFFECTS_NAME;
         if(FeatureTuner.USE_ROCKET_EFFECT)
         {
            if(_loc7_.isLoaded(_loc8_))
            {
               mGraphicsLoaded = true;
               this.addMissile();
            }
            else
            {
               mGraphicsLoaded = false;
               mLoadingCallbackEventType = _loc8_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
               _loc7_.addEventListener(mLoadingCallbackEventType,LoadingFinished,false,0,true);
               if(!_loc7_.isAddedToLoadingList(_loc8_))
               {
                  _loc7_.load(Config.DIR_DATA + _loc8_ + ".swf",_loc8_,null,false);
               }
            }
         }
      }
      
      override protected function addMissile() : void
      {
         var _loc1_:Class = null;
         if(FeatureTuner.USE_ROCKET_EFFECT)
         {
            _loc1_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_EFFECTS_NAME,"rocket");
            if(_loc1_ != null)
            {
               mProjectile = new _loc1_();
               this.addChild(mProjectile);
            }
         }
      }
      
      override public function update(param1:int) : Boolean
      {
         var _loc2_:Class = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(!mGraphicsLoaded || mProjectile == null)
         {
            return false;
         }
         if(this.mTimer < LAUNCH_DELAY_MS)
         {
            this.mTimer += param1;
            return false;
         }
         this.mV.z -= this.G;
         this.mPos.x += this.mV.x;
         this.mPos.y += this.mV.y;
         this.mPos.z += this.mV.z;
         mProjectile.x = this.mPos.x;
         mProjectile.y = this.mPos.y - 0.7 * this.mPos.z;
         if(this.mPos.z < 0)
         {
            if(!mAtTarget)
            {
               mAtTarget = true;
               this.mPos.z = 0;
               graphics.clear();
               if(mProjectile.parent)
               {
                  mProjectile.parent.removeChild(mProjectile);
               }
               _loc2_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_EFFECTS_NAME,"effect_explosion");
               _loc3_ = new _loc2_();
               _loc3_.x = this.mPos.x;
               _loc3_.y = this.mPos.y;
               _loc3_.scaleX = 0.25;
               _loc3_.scaleY = 0.25;
               _loc3_.addEventListener(Event.ENTER_FRAME,this.checkFrame,false,0,true);
               addChild(_loc3_);
            }
         }
         if(this.mTrail.length > 30 || mAtTarget)
         {
            this.mTrail.shift();
            this.mTrail.shift();
         }
         if(!mAtTarget)
         {
            this.mTrail.push(mProjectile.x);
            this.mTrail.push(mProjectile.y);
            _loc4_ = Number(this.mTrail[this.mTrail.length - 2]);
            _loc5_ = Number(this.mTrail[this.mTrail.length - 1]);
            _loc6_ = Number(this.mTrail[this.mTrail.length - 4]);
            _loc7_ = Number(this.mTrail[this.mTrail.length - 3]);
            mProjectile.rotation = Math.atan2(_loc4_ - _loc6_,-(_loc5_ - _loc7_)) / 2 / Math.PI * 360;
         }
         if(this.mTrail.length > 4)
         {
            graphics.clear();
            graphics.lineStyle(4,14540253);
            graphics.moveTo(this.mTrail[this.mTrail.length - 2],this.mTrail[this.mTrail.length - 1]);
            _loc8_ = this.mTrail.length - 3;
            while(_loc8_ > 0)
            {
               graphics.lineStyle(4,14540253,_loc8_ / (this.mTrail.length - 3));
               _loc9_ = Number(this.mTrail[_loc8_--]);
               _loc10_ = Number(this.mTrail[_loc8_--]);
               graphics.lineTo(_loc10_,_loc9_);
            }
         }
         return mFinished;
      }
      
      private function checkFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.stop();
            if(_loc2_.parent)
            {
               if(_loc2_.parent.parent)
               {
                  _loc2_.parent.parent.removeChild(_loc2_.parent);
               }
               _loc2_.parent.removeChild(_loc2_);
            }
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.checkFrame);
            destroy();
            _loc2_ = null;
         }
      }
      
      private function addParticle() : void
      {
      }
   }
}
