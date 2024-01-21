package game.particles
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class SmokeEmitter
   {
       
      
      private var mParticles:Array;
      
      public var mX:int;
      
      public var mY:int;
      
      public var mMaxConcurrentParticles:int;
      
      public var mMaxLifetimeParticles:int;
      
      public var mLifetimeParticles:int;
      
      public var mDepleted:Boolean;
      
      public var mReadyToRemove:Boolean;
      
      public var mAddParticlesInterval:int;
      
      private var mGraphicsLoaded:Boolean;
      
      private var mLoadingCallbackEventType:Object;
      
      private var mIntervalCounter:int;
      
      public function SmokeEmitter(param1:int = 1)
      {
         this.mParticles = new Array();
         super();
         this.mAddParticlesInterval = param1;
         this.mMaxConcurrentParticles = 40;
         var _loc2_:DCResourceManager = DCResourceManager.getInstance();
         var _loc3_:String = Config.SWF_EFFECTS_NAME;
         if(_loc2_.isLoaded(_loc3_))
         {
            this.mGraphicsLoaded = true;
         }
         else
         {
            this.mGraphicsLoaded = false;
            this.mLoadingCallbackEventType = new Object();
            this.mLoadingCallbackEventType.type = _loc3_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
            this.mLoadingCallbackEventType.resName = _loc3_;
            _loc2_.addEventListener(this.mLoadingCallbackEventType.type,this.LoadingFinished,false,0,true);
            if(!_loc2_.isAddedToLoadingList(_loc3_))
            {
               _loc2_.load(Config.DIR_DATA + _loc3_ + ".swf",_loc3_,null,false);
            }
         }
      }
      
      protected function LoadingFinished(param1:Event) : void
      {
         DCResourceManager.getInstance().removeEventListener(param1.type,this.LoadingFinished);
         this.mLoadingCallbackEventType = null;
         this.mGraphicsLoaded = true;
      }
      
      public function canEmit() : Boolean
      {
         return this.mIntervalCounter % this.mAddParticlesInterval == 0;
      }
      
      public function addParticle(param1:String, param2:DisplayObjectContainer, param3:Boolean) : SmokeParticle
      {
         var _loc5_:SmokeParticle = null;
         if(!this.mGraphicsLoaded)
         {
            return null;
         }
         var _loc4_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_EFFECTS_NAME,param1);
         _loc5_ = new SmokeParticle(_loc4_,param2,0,0,param3);
         this.mParticles.push(_loc5_);
         _loc5_.clip.x = this.mX;
         _loc5_.clip.y = this.mY;
         ++this.mLifetimeParticles;
         if(this.mMaxLifetimeParticles != 0)
         {
            if(this.mLifetimeParticles == this.mMaxLifetimeParticles)
            {
               this.mDepleted = true;
            }
         }
         return _loc5_;
      }
      
      public function destroy() : void
      {
         var _loc1_:SmokeParticle = null;
         while(this.mParticles.length > 0)
         {
            _loc1_ = this.mParticles.shift();
            _loc1_.destroy();
         }
         if(this.mLoadingCallbackEventType)
         {
            DCResourceManager.getInstance().removeEventListener(this.mLoadingCallbackEventType.type,this.LoadingFinished);
         }
      }
      
      public function updateParticles() : void
      {
         var _loc1_:SmokeParticle = null;
         ++this.mIntervalCounter;
         if(this.mDepleted)
         {
            if(this.mParticles.length == 0)
            {
               this.mReadyToRemove = true;
               return;
            }
         }
         else
         {
            while(this.mParticles.length > this.mMaxConcurrentParticles)
            {
               _loc1_ = this.mParticles.shift();
               _loc1_.destroy();
            }
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.mParticles.length)
         {
            _loc1_ = this.mParticles[_loc2_];
            if(_loc1_.clip.alpha > 0.05)
            {
               _loc1_.update();
            }
            else
            {
               _loc1_.destroy();
               this.mParticles.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
   }
}
