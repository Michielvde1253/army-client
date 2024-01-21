package game.gameElements
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MovieLoop
   {
       
      
      public var mMovie:MovieClip;
      
      private var mParent:DisplayObjectContainer;
      
      public var mLoops:int;
      
      public var mRemoveInTheEnd:Boolean;
      
      public function MovieLoop(param1:MovieClip, param2:Number, param3:Number, param4:DisplayObjectContainer, param5:int = 1, param6:int = -1)
      {
         super();
         this.mMovie = param1;
         this.mParent = param4;
         this.mLoops = param5;
         this.mMovie.x = param2;
         this.mMovie.y = param3;
         this.mRemoveInTheEnd = true;
         if(param6 != -1)
         {
            this.mParent.addChildAt(this.mMovie,param6);
         }
         this.mMovie.addEventListener(Event.ENTER_FRAME,this.checkFrame);
      }
      
      private function checkFrame(param1:Event) : void
      {
         if(this.mMovie.totalFrames == this.mMovie.currentFrame)
         {
            if(--this.mLoops > 0)
            {
               this.mMovie.gotoAndPlay(1);
            }
            else if(this.mRemoveInTheEnd)
            {
               this.destroy();
            }
            else
            {
               this.mMovie.stop();
            }
         }
      }
      
      public function destroy() : void
      {
         this.mMovie.removeEventListener(Event.ENTER_FRAME,this.checkFrame);
         if(this.mMovie.parent)
         {
            this.mMovie.parent.removeChild(this.mMovie);
         }
         this.mParent = null;
         this.mMovie = null;
      }
   }
}
