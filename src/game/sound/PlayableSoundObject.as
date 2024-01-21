package game.sound
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   
   public class PlayableSoundObject extends EventDispatcher
   {
       
      
      public var mName:String;
      
      public var mType:int;
      
      public var mChannel:SoundChannel;
      
      public var mVolume:Number;
      
      private var mSound:Sound;
      
      public var mPosition:Number;
      
      public var mStartTime:Number;
      
      public var mLoops:int;
      
      public var mPaused:Boolean;
      
      public var mLoaded:Boolean;
      
      public function PlayableSoundObject()
      {
         super();
      }
      
      public function getSound() : Sound
      {
         return this.mSound;
      }
      
      public function setSound(param1:Sound) : void
      {
         this.mSound = param1;
         if(this.mSound.bytesLoaded == this.mSound.bytesTotal)
         {
            this.mLoaded = true;
            dispatchEvent(new Event(Event.COMPLETE));
         }
         else
         {
            this.mSound.addEventListener(Event.COMPLETE,this.loaded);
            this.mSound.addEventListener(IOErrorEvent.IO_ERROR,this.error);
            this.mSound.addEventListener(IOErrorEvent.NETWORK_ERROR,this.error);
         }
      }
      
      private function error(param1:Event) : void
      {
         this.mSound.removeEventListener(Event.COMPLETE,this.loaded);
         this.mSound.removeEventListener(IOErrorEvent.IO_ERROR,this.error);
         this.mSound.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.error);
         this.mLoaded = true;
         dispatchEvent(new Event(ErrorEvent.ERROR));
      }
      
      private function loaded(param1:Event) : void
      {
         this.mSound.removeEventListener(Event.COMPLETE,this.loaded);
         this.mSound.removeEventListener(IOErrorEvent.IO_ERROR,this.error);
         this.mSound.removeEventListener(IOErrorEvent.NETWORK_ERROR,this.error);
         this.mLoaded = true;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
