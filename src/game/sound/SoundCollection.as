package game.sound
{
   import flash.events.Event;
   
   public class SoundCollection
   {
      
      public static const DEBUG_SOUND:Boolean = false;
       
      
      public var mInitialized:Boolean;
      
      public var mAllLoaded:Boolean;
      
      public var mPlaceHolder:String;
      
      public var mCollection:Array;
      
      private var mLoadedNames:Vector.<String>;
      
      private var mEmpty:Boolean;
      
      public function SoundCollection(param1:String, param2:Array)
      {
         super();
         if(!param1 && !param2)
         {
            this.mEmpty = true;
            return;
         }
         this.mPlaceHolder = param1;
         this.mCollection = param2;
         this.mLoadedNames = new Vector.<String>();
      }
      
      public function load() : void
      {
         if(this.mEmpty)
         {
            if(Config.DEBUG_MODE)
            {
            }
         }
         else if(!this.mInitialized && !this.mAllLoaded)
         {
            this.loadSound(this.mPlaceHolder,true);
            this.mInitialized = true;
         }
      }
      
      public function getSound() : String
      {
         var _loc2_:String = null;
         if(this.mEmpty)
         {
            if(Config.DEBUG_MODE)
            {
            }
            return "";
         }
         var _loc1_:String = null;
         if(Boolean(this.mLoadedNames) && this.mLoadedNames.length > 0)
         {
            if(this.mLoadedNames.length == 1)
            {
               _loc1_ = this.mLoadedNames[0];
            }
            else
            {
               _loc1_ = this.mLoadedNames[int(Math.random() * this.mLoadedNames.length)];
            }
         }
         else if(this.mPlaceHolder)
         {
            _loc1_ = this.mPlaceHolder;
         }
         if(DEBUG_SOUND)
         {
            for each(_loc2_ in this.mLoadedNames)
            {
            }
         }
         return _loc1_;
      }
      
      private function loadSound(param1:String, param2:Boolean = false) : void
      {
         var _loc4_:PlayableSoundObject = null;
         var _loc6_:int = 0;
         if(DEBUG_SOUND)
         {
         }
         var _loc3_:ArmySoundManager = ArmySoundManager.getInstance();
         var _loc5_:Array;
         if(!(_loc5_ = ArmySoundManager.smLoadedSounds)[param1])
         {
            if((Boolean(_loc4_ = _loc3_.addExternalSound(Config.DIR_DATA + param1,param1,ArmySoundManager.TYPE_SFX))) && !_loc4_.mLoaded)
            {
               if(param2)
               {
                  _loc4_.addEventListener(Event.COMPLETE,this.placeholderLoaded);
               }
               else
               {
                  _loc4_.addEventListener(Event.COMPLETE,this.soundLoaded);
               }
            }
         }
         if(_loc4_ && _loc4_.mLoaded || Boolean(_loc5_[param1]))
         {
            if(param2)
            {
               this.loadCollection();
            }
            else if((_loc6_ = this.mLoadedNames.indexOf(param1)) < 0)
            {
               this.mLoadedNames.push(param1);
               if(this.mLoadedNames.length >= this.mCollection.length)
               {
                  this.mAllLoaded = true;
               }
            }
         }
      }
      
      private function soundLoaded(param1:Event) : void
      {
         var _loc2_:PlayableSoundObject = param1.target as PlayableSoundObject;
         _loc2_.removeEventListener(Event.COMPLETE,this.soundLoaded);
         if(this.mLoadedNames.indexOf(_loc2_.mName) == -1)
         {
            this.mLoadedNames.push(_loc2_.mName);
            if(this.mLoadedNames.length >= this.mCollection.length)
            {
               this.mAllLoaded = true;
            }
         }
         if(DEBUG_SOUND)
         {
         }
      }
      
      private function placeholderLoaded(param1:Event) : void
      {
         if(DEBUG_SOUND)
         {
         }
         var _loc2_:PlayableSoundObject = param1.target as PlayableSoundObject;
         _loc2_.removeEventListener(Event.COMPLETE,this.soundLoaded);
         this.loadCollection();
      }
      
      private function loadCollection() : void
      {
         var _loc1_:String = null;
         if(this.mAllLoaded)
         {
            if(DEBUG_SOUND)
            {
            }
            return;
         }
         var _loc2_:int = int(this.mCollection.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mCollection[_loc3_] as String;
            this.loadSound(_loc1_);
            _loc3_++;
         }
      }
   }
}
