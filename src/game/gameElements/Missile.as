package game.gameElements
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import game.isometric.elements.Renderable;
   import game.particles.SmokeEmitter;
   import game.particles.SmokeParticle;
   
   public class Missile extends Projectile
   {
       
      
      private const DURATION:int = 1500;
      
      private var mSegment:int;
      
      private var mSegmentCount:int;
      
      private var mFire:SmokeParticle;
      
      private var mParticle:SmokeParticle;
      
      private var mSmoker:SmokeEmitter;
      
      private var mElapsedTime:int;
      
      private var mLengths:Array;
      
      private var mWaypoints:Array;
      
      private var mAngles:Array;
      
      protected var mCurrP:Point;
      
      public function Missile(param1:Renderable, param2:Number, param3:Number)
      {
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:Number = NaN;
         super(param1,param2,param3);
         var _loc4_:Point = new Point(param2 - this.x + Utils.randRange(-10,10),param3 - this.y + Utils.randRange(-10,10));
         this.mWaypoints = new Array();
         this.mCurrP = new Point();
         this.mWaypoints.push(new Point());
         this.mWaypoints.push(new Point(_loc4_.x * 0.7 + Utils.randRange(-10,10),_loc4_.y * 0.7 + Utils.randRange(-100,-130)));
         this.mWaypoints.push(_loc4_);
         this.mSegmentCount = this.mWaypoints.length - 1;
         this.mAngles = new Array();
         this.mLengths = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < this.mSegmentCount)
         {
            _loc8_ = this.mWaypoints[_loc5_];
            _loc9_ = this.mWaypoints[_loc5_ + 1];
            this.mLengths.push(_loc8_.length);
            _loc10_ = Math.atan2(_loc9_.x - _loc8_.x,-(_loc9_.y - _loc8_.y)) / Math.PI / 2 * 360;
            this.mAngles.push(_loc10_);
            _loc5_++;
         }
         mouseEnabled = false;
         mouseChildren = false;
         this.mSmoker = new SmokeEmitter();
         var _loc6_:DCResourceManager = DCResourceManager.getInstance();
         var _loc7_:String = Config.SWF_EFFECTS_NAME;
         if(FeatureTuner.USE_ROCKET_EFFECT)
         {
            if(_loc6_.isLoaded(_loc7_))
            {
               mGraphicsLoaded = true;
               this.addMissile();
            }
            else
            {
               mGraphicsLoaded = false;
               mLoadingCallbackEventType = _loc7_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
               _loc6_.addEventListener(mLoadingCallbackEventType,LoadingFinished,false,0,true);
               if(!_loc6_.isAddedToLoadingList(_loc7_))
               {
                  _loc6_.load(Config.DIR_DATA + _loc7_ + ".swf",_loc7_,null,false);
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
               if(!FeatureTuner.USE_LOW_SWF)
               {
                  mProjectile.rotation = this.mAngles[0];
               }
               this.addChild(mProjectile);
            }
         }
      }
      
      override public function update(param1:int) : Boolean
      {
         var _loc8_:Class = null;
         var _loc9_:MovieClip = null;
         if(!mGraphicsLoaded || !mProjectile)
         {
            return false;
         }
         this.mElapsedTime += param1;
         var _loc2_:int = Math.min(this.mSegmentCount,this.mSegment + 1);
         this.mSegment = Math.min(this.mSegmentCount,this.mSegment);
         var _loc3_:Point = this.mWaypoints[this.mSegment];
         var _loc4_:Point = this.mWaypoints[_loc2_];
         var _loc5_:Number = this.mElapsedTime / (this.DURATION / (_loc2_ * 1.5));
         this.mCurrP.x = _loc3_.x + _loc4_.subtract(_loc3_).x * _loc5_;
         this.mCurrP.y = _loc3_.y + _loc4_.subtract(_loc3_).y * _loc5_;
         this.mSmoker.updateParticles();
         mProjectile.x = this.mCurrP.x;
         mProjectile.y = this.mCurrP.y;
         if(!mAtTarget)
         {
            this.addParticle(1);
         }
         var _loc6_:Number = this.mCurrP.subtract(_loc3_).length;
         var _loc7_:Number = _loc4_.subtract(_loc3_).length;
         if(_loc6_ >= _loc7_)
         {
            this.mCurrP.x = _loc4_.x;
            this.mCurrP.y = _loc4_.y;
            this.mElapsedTime = 0;
            ++this.mSegment;
            if(this.mSegment == this.mSegmentCount)
            {
               mAtTarget = true;
               if(mProjectile.parent)
               {
                  mProjectile.parent.removeChild(mProjectile);
               }
               (_loc9_ = new (_loc8_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_EFFECTS_NAME,"effect_explosion"))()).x = (this.mWaypoints[this.mSegmentCount] as Point).x;
               _loc9_.y = (this.mWaypoints[this.mSegmentCount] as Point).y;
               _loc9_.scaleX = 0.25;
               _loc9_.scaleY = 0.25;
               _loc9_.addEventListener(Event.ENTER_FRAME,this.checkFrame,false,0,true);
               addChild(_loc9_);
            }
            else if(this.mSegment < this.mSegmentCount)
            {
               if(mProjectile)
               {
                  mProjectile.rotation = this.mAngles[this.mSegment];
               }
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
      
      private function addParticle(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Point = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            this.mParticle = this.mSmoker.addParticle("Smoke3",this,true);
            if(this.mParticle)
            {
               this.mParticle.clip.x = this.mCurrP.x + Utils.randRange(-6,6);
               this.mParticle.clip.y = this.mCurrP.y + Utils.randRange(-6,6);
               _loc3_ = Math.min(this.mSegmentCount,this.mSegment + 1);
               (_loc4_ = this.mCurrP.subtract(this.mWaypoints[_loc3_])).normalize(1);
               this.mParticle.setVel(Utils.randRange(-_loc4_.x - 0.5,-_loc4_.x + 0.5),Utils.randRange(-_loc4_.y - 0.5,-_loc4_.y + 0.5));
               this.mParticle.clip.scaleX = 3;
               this.mParticle.clip.scaleY = 3;
               this.mParticle.clip.alpha = 1;
               this.mParticle.drag = 0.9;
               this.mParticle.fade = 0.9;
               this.mParticle.shrink = 1.01;
               this.mParticle.gravity = -0.5;
            }
            this.mFire = this.mSmoker.addParticle("Smoke4",this,false);
            if(this.mFire)
            {
               this.mFire.clip.x = this.mCurrP.x + Utils.randRange(-3,3);
               this.mFire.clip.y = this.mCurrP.y + Utils.randRange(-3,3);
               (_loc4_ = this.mCurrP.subtract(this.mWaypoints[_loc3_])).normalize(1);
               this.mFire.setVel(Utils.randRange(-_loc4_.x - 0.3,-_loc4_.x + 0.3),Utils.randRange(-_loc4_.y - 0.3,-_loc4_.y + 0.3));
               this.mFire.clip.scaleX = Utils.randRange(1,2);
               this.mFire.clip.scaleY = Utils.randRange(1,2);
               this.mFire.clip.alpha = 0.8;
               this.mFire.drag = 0.6;
               this.mFire.fade = 0.7;
               this.mFire.shrink = 1.01;
               this.mFire.gravity = -0.5;
            }
            _loc2_++;
         }
      }
   }
}
