package game.gameElements
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import game.sound.ArmySoundManager;
   import game.sound.SoundCollection;
   
   public class FriendSuppressObject extends MovieClip
   {
       
      
      private var mAnim:MovieClip;
      
      private var mGraphicsLoaded:Boolean;
      
      private var mLoadingCallbackEventType:String;
      
      private var mStarted:Boolean;
      
      private var mSound:SoundCollection;
      
      private var mSmokingDone:Boolean;
      
      public function FriendSuppressObject()
      {
         var _loc3_:Class = null;
         super();
         var _loc1_:DCResourceManager = DCResourceManager.getInstance();
         var _loc2_:String = Config.SWF_EFFECTS_NAME;
         if(_loc1_.isLoaded(_loc2_))
         {
            this.mGraphicsLoaded = true;
            _loc3_ = _loc1_.getSWFClass(_loc2_,"explosion_friend_artillery");
            this.mAnim = new _loc3_();
            addChild(this.mAnim);
         }
         else
         {
            this.mGraphicsLoaded = false;
            this.mLoadingCallbackEventType = _loc2_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
            _loc1_.addEventListener(this.mLoadingCallbackEventType,this.LoadingFinished,false,0,true);
            if(!_loc1_.isAddedToLoadingList(_loc2_))
            {
               _loc1_.load(Config.DIR_DATA + _loc2_ + ".swf",_loc2_,null,false);
            }
         }
         this.mSound = ArmySoundManager.SC_FIRE_MISSION_MORTAR;
         this.mSound.load();
         this.mStarted = false;
      }
      
      public function LoadingFinished(param1:Event) : void
      {
         var _loc2_:DCResourceManager = DCResourceManager.getInstance();
         _loc2_.removeEventListener(param1.type,this.LoadingFinished);
         this.mLoadingCallbackEventType = null;
         this.mGraphicsLoaded = true;
         var _loc3_:Class = _loc2_.getSWFClass(Config.SWF_EFFECTS_NAME,"explosion_friend_artillery");
         this.mAnim = new _loc3_();
         addChild(this.mAnim);
         if(this.mStarted)
         {
            this.start();
         }
      }
      
      public function destroy() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this.mLoadingCallbackEventType)
         {
            DCResourceManager.getInstance().removeEventListener(this.mLoadingCallbackEventType,this.LoadingFinished);
         }
      }
      
      public function start() : void
      {
         this.mStarted = true;
         if(!this.mGraphicsLoaded)
         {
            return;
         }
         this.mAnim.gotoAndPlay(1);
         this.mSmokingDone = false;
         ArmySoundManager.getInstance().playSound(this.mSound.getSound());
      }
      
      public function isOver() : Boolean
      {
         if(!this.mGraphicsLoaded)
         {
            return false;
         }
         if(this.mAnim.currentFrame >= this.mAnim.totalFrames)
         {
            this.mAnim.gotoAndStop(this.mAnim.totalFrames);
            return true;
         }
         return false;
      }
      
      public function update() : void
      {
         if(!this.mGraphicsLoaded)
         {
            return;
         }
      }
   }
}
