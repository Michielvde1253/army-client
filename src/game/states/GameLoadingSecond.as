package game.states
{
   import com.dchoc.graphics.DCResourceManager;
   import com.dchoc.utils.Cookie;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   import game.magicBox.FlurryEvents;
   import game.magicBox.MagicBoxTracker;
   import game.missions.MissionManager;
   import game.net.MyServer;
   import game.net.ServerCall;
   import game.net.ServiceIDs;
   import game.sound.ArmySoundManager;
   
   public class GameLoadingSecond extends LoadingState
   {
       
      
      private var mGameState:GameState;
      
      private var mFileCountToLoad:int;
      
      private var env:int;
      
      private var app_id:int;
      
      private var log_level:int;
      
      public function GameLoadingSecond(param1:StateMachine, param2:Stage, param3:GameState)
      {
         super(param1,param3,new GameLoadingFirst.LoadingScreen());
         this.mGameState = param3;
      }
      
      override public function enter() : void
      {
         var _loc4_:TextField = null;
         var _loc5_:TextFormat = null;
         super.enter();
         var _loc1_:* = {"map_id":this.mGameState.mCurrentMapId};
         this.mGameState.mServer.serverCallServiceWithParameters(ServiceIDs.GET_MAP_DATA,_loc1_,true);
         mServerResponsesNeeded.push(ServiceIDs.GET_MAP_DATA);
         this.initResources();
         this.mGameState.startMusic();
         var _loc2_:DCResourceManager = DCResourceManager.getInstance();
         this.mFileCountToLoad = _loc2_.getFileCountToLoad();
         var _loc3_:MovieClip = mLoadingClip.getChildByName("Fill_Bar") as MovieClip;
         (_loc4_ = _loc3_.getChildByName("Text_Description") as TextField).text = Config.smLoadingDescription;
         LocalizationUtils.replaceFont(_loc4_);
         if(Config.FOR_IPHONE_PLATFORM)
         {
            (_loc5_ = _loc4_.getTextFormat()).size = 17;
            _loc4_.defaultTextFormat = _loc5_;
            _loc4_.setTextFormat(_loc5_);
         }
      }
      
      override public function logicUpdate(param1:int) : void
      {
         var _loc4_:DCResourceManager = null;
         var _loc2_:int = 0;
         super.logicUpdate(param1);
         if(mPercent >= 100)
         {
            this.loadingFinished();
            return;
         }
         var _loc3_:MyServer = this.mGameState.mServer;
         if(_loc3_.getNumberOfBlockingCalls() > 0 && !_loc3_.isConnectionError() && !_loc3_.isServerCommError())
         {
            _loc2_ = 100 * (1 - _loc3_.getNumberOfBlockingCalls());
         }
         else
         {
            _loc2_ = 100;
         }
         var _loc5_:int = (_loc4_ = DCResourceManager.getInstance()).getFileCountToLoad();
         var _loc6_:int = mPercent;
         if(this.mFileCountToLoad > 0)
         {
            _loc6_ = 100 - _loc5_ * 100 / this.mFileCountToLoad;
         }
         else
         {
            _loc6_ = 100;
         }
         if((_loc2_ + _loc6_) / 2 > mPercent)
         {
            setPercent((_loc2_ + _loc6_) / 2);
         }
      }
      
      override public function exit() : void
      {
         super.exit();
         var _loc1_:MovieClip = mLoadingClip.getChildByName("Fill_Bar") as MovieClip;
         var _loc2_:TextField = _loc1_.getChildByName("Text_Description") as TextField;
      }
      
      private function loadingFinished() : void
      {
         var _loc5_:* = undefined;
         var _loc2_:Boolean = false;
         var _loc8_:* = null;
         var _loc1_:ServerCall = this.mGameState.mServer.fetchResponseFromBuffer(ServiceIDs.GET_MAP_DATA);
         this.mGameState.initMap(_loc1_);
         this.mGameState.initObjects(_loc1_);
         this.mGameState.initialize();
         MissionManager.setupFromServer(_loc1_);
         MissionManager.findNewActiveMissions();
         this.mGameState.mShowWelcome = MissionManager.isTutorialCompleted();
         this.mGameState.updateGrid();
         this.mGameState.mScene.mFog.init();
         if(MissionManager.isTutorialCompleted())
         {
            if((_loc8_ = Cookie.readCookieVariable(Config.COOKIE_SESSION_NAME,Config.COOKIE_SESSION_NAME_ZOOM_INDEX)) != null && int(_loc8_) < this.mGameState.mZoomLevels.length && int(_loc8_) >= 0)
            {
               this.mGameState.setZoomIndex(int(_loc8_));
            }
            else
            {
               this.mGameState.setZoomIndex(0);
            }
         }
         if(Config.FOR_IPHONE_PLATFORM)
         {
            this.mGameState.setZoomIndex(this.mGameState.mZoomLevels.length - 1);
         }
         MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_LEVEL,MagicBoxTracker.TYPE_SESSION_STARTED,MagicBoxTracker.LABEL_ON_FLASH);
         if(FeatureTuner.USE_FEDERAL_TRACKING && !Config.IS_FED_INITIALLIZED)
         {
            FederalInterface.startUserSessionInFed();
            Config.IS_FED_INITIALLIZED = true;
         }
         var _loc3_:String = Cookie.readCookieVariable(Config.COOKIE_SETTINGS_NAME,Config.COOKIE_SETTINGS_NAME_APPLAUNCH);
         if(_loc3_ == "false")
         {
            _loc2_ = false;
         }
         else
         {
            _loc2_ = true;
         }
         if(_loc2_)
         {
            Cookie.saveCookieVariable(Config.COOKIE_SETTINGS_NAME,Config.COOKIE_SETTINGS_NAME_APPLAUNCH,!_loc2_);
         }
         var _loc4_:* = getTimer() / 1000;
         if(Config.DEBUG_MODE)
         {
         }
         (_loc5_ = MagicBoxTracker.paramsObj())["session_accumulated_time"] = Math.round(_loc4_);
         var _loc6_:String = MagicBoxTracker.LABEL_LOADING_TIME;
         if(_loc4_ < MagicBoxTracker.LOADING_GROUP_10)
         {
            _loc6_ += MagicBoxTracker.LOADING_GROUP_10;
         }
         else if(_loc4_ < MagicBoxTracker.LOADING_GROUP_20)
         {
            _loc6_ += MagicBoxTracker.LOADING_GROUP_20;
         }
         else if(_loc4_ < MagicBoxTracker.LOADING_GROUP_40)
         {
            _loc6_ += MagicBoxTracker.LOADING_GROUP_40;
         }
         else if(_loc4_ < MagicBoxTracker.LOADING_GROUP_80)
         {
            _loc6_ += MagicBoxTracker.LOADING_GROUP_80;
         }
         else if(_loc4_ < MagicBoxTracker.LOADING_GROUP_160)
         {
            _loc6_ += MagicBoxTracker.LOADING_GROUP_160;
         }
         else if(_loc4_ < MagicBoxTracker.LOADING_GROUP_320)
         {
            _loc6_ += MagicBoxTracker.LOADING_GROUP_320;
         }
         else
         {
            _loc6_ = _loc6_ + "Over_" + MagicBoxTracker.LOADING_GROUP_320;
         }
         MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_GAME,MagicBoxTracker.TYPE_LOADING,_loc6_,_loc5_);
         var _loc7_:Array = FeatureTuner.USE_LOW_SWF ? AssetManager.NON_BLOCKING_SWF_LOW_IDS : AssetManager.NON_BLOCKING_SWF_IDS;
         if(Config.FOR_IPHONE_PLATFORM)
         {
            _loc7_ = FeatureTuner.USE_LOW_SWF ? AssetManager.NON_BLOCKING_SWF_IPHONE_LOW_IDS : AssetManager.NON_BLOCKING_SWF_IPHONE_IDS;
         }
         Utils.addSwfToResourceManager(_loc7_,false,false);
         this.mGameState.mLoadingStatesOver = true;
         this.mGameState.initInboxChecker();
         goToNextState();
      }
      
      override protected function setLoadingBarPercent(param1:int) : void
      {
         var _loc3_:TextFormat = null;
         param1 = Math.max(0,param1);
         mLoadingFillBar.setValueWithoutBarAnimation(90 + param1 * 10 / 100);
         var _loc2_:TextField = DisplayObjectContainer(mLoadingClip.getChildByName("Fill_Bar")).getChildByName("Progress") as TextField;
         _loc2_.text = int(90 + param1 * 10 / 100) + "%";
         if(Config.FOR_IPHONE_PLATFORM)
         {
            _loc3_ = _loc2_.getTextFormat();
            _loc3_.size = 24;
            _loc2_.defaultTextFormat = _loc3_;
            _loc2_.setTextFormat(_loc3_);
         }
      }
      
      public function getLoadingPercent() : int
      {
         return mPercent;
      }
      
      private function initResources() : void
      {
         var _loc2_:Array = null;
         ArmySoundManager.loadMusic(this.mGameState.getMapMusic());
         var _loc1_:String = String((GameState.mConfig.MapSetup[this.mGameState.mCurrentMapId] as Object).SWFFile);
         if(_loc1_.indexOf(",") >= 0)
         {
            _loc2_ = _loc1_.split(",");
         }
         else
         {
            _loc2_ = [_loc1_];
         }
         Utils.addSwfToResourceManager(_loc2_);
         if(!MissionManager.isTutorialCompleted())
         {
            Utils.addSwfToResourceManager(AssetManager.TUTORIAL_SWF_IDS);
            ArmySoundManager.getInstance().addExternalSound(Config.DIR_DATA + ArmySoundManager.MUSIC_INTRO,ArmySoundManager.MUSIC_INTRO,ArmySoundManager.TYPE_MUSIC);
         }
      }
   }
}
