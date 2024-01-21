package game.gui.missions
{
   import com.dchoc.GUI.DCButton;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import game.gui.DCWindow;
   import game.gui.IconLoader;
   import game.gui.button.ArmyButton;
   import game.gui.popups.CampaignWindow;
   import game.gui.popups.MissionProgressWindow;
   import game.gui.popups.MissionStackWindow;
   import game.gui.popups.PopUpManager;
   import game.gui.popups.RankMissionWindow;
   import game.missions.Mission;
   import game.missions.MissionManager;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class MissionButton extends ArmyButton
   {
      
      public static const STATE_NEW:String = "New";
      
      public static const STATE_UNOPENED:String = "Unopened";
      
      public static const STATE_OPENED:String = "Opened";
      
      public static const STATE_PROGRESSING:String = "Progressing";
      
      public static const STATE_COMPLETE:String = "Complete";
      
      public static const RANK_ICON_HEIGHT:int = 50;
      
      public static const RANK_ICON_WIDTH:int = 35;
       
      
      private var mMission:Mission;
      
      private var mProgressTitle:TextField;
      
      private var mProgressDesc:TextField;
      
      private var mNewText:TextField;
      
      private var mAppearText:TextField;
      
      private var mIcon:DisplayObjectContainer;
      
      private var mFrame:MovieClip;
      
      private var mState:String;
      
      private var mLastState:String;
      
      public function MissionButton(param1:MovieClip, param2:String)
      {
         super(param1,this.getMC(param1,param2),DCButton.BUTTON_TYPE_ICON,null,null,null,null,null,null);
         this.mFrame = param1;
         this.mFrame.mouseEnabled = true;
         this.mFrame.mouseChildren = true;
         this.mFrame.buttonMode = true;
         this.mFrame.addEventListener(MouseEvent.CLICK,this.mouseClick);
         this.mIcon = this.getMC(this.mFrame,param2).getChildByName("Icon") as DisplayObjectContainer;
         this.setState(STATE_OPENED);
         mClickSound = ArmySoundManager.SFX_UI_CLICK;
      }
      
      private function getMC(param1:MovieClip, param2:String) : MovieClip
      {
         var _loc3_:MovieClip = param1.getChildByName(param2) as MovieClip;
         if(_loc3_ != null)
         {
            _loc3_.mouseEnabled = true;
         }
         return _loc3_;
      }
      
      private function enterFrameMission(param1:Event) : void
      {
         if(GameState.mInstance.mHUD.mPullOutMissionFrame.currentFrameLabel == "Normal")
         {
            GameState.mInstance.mHUD.mPullOutMissionFrame.visible = true;
            GameState.mInstance.mHUD.mPullOutMissionFrame.stop();
            GameState.mInstance.mHUD.mPullOutMissionFrame.removeEventListener(Event.ENTER_FRAME,this.enterFrameMission);
         }
         else if(GameState.mInstance.mHUD.mPullOutMissionFrame.currentFrame == GameState.mInstance.mHUD.mPullOutMissionFrame.totalFrames)
         {
            GameState.mInstance.mHUD.mPullOutMissionFrame.gotoAndStop(1);
            GameState.mInstance.mHUD.mPullOutMissionFrame.removeEventListener(Event.ENTER_FRAME,this.enterFrameMission);
            GameState.mInstance.mHUD.mPullOutMissionFrame.visible = false;
         }
      }
      
      override public function enterFrame(param1:Event) : void
      {
         var _loc3_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TextFormat = null;
         var _loc7_:TextFormat = null;
         if(this.mFrame.currentFrame == this.mFrame.totalFrames)
         {
            this.mFrame.stop();
            this.mFrame.removeEventListener(Event.ENTER_FRAME,this.enterFrame);
            this.mFrame.visible = false;
            return;
         }
         super.enterFrame(param1);
         if(this.mFrame.currentLabel != this.mState)
         {
            this.mFrame.removeEventListener(Event.ENTER_FRAME,this.enterFrame);
            if(this.mState == STATE_PROGRESSING && this.mLastState != STATE_PROGRESSING)
            {
               this.setState(this.mLastState);
            }
            else
            {
               this.mFrame.prevFrame();
            }
         }
         var _loc2_:int = 80;
         var _loc4_:String;
         if((_loc4_ = this.mFrame.currentLabel) == STATE_NEW)
         {
            if(this.mMission.mType == Mission.TYPE_RANK)
            {
               _loc3_ = this.mFrame.getChildByName("Header_Progress") as MovieClip;
            }
            else
            {
               _loc3_ = this.mFrame.getChildByName("Header_New") as MovieClip;
            }
            _loc5_ = _loc3_.getChildAt(0) as MovieClip;
            if(_loc3_)
            {
               _loc3_.mouseEnabled = false;
               _loc3_.mouseChildren = false;
            }
            this.mAppearText = _loc3_.getChildByName("Text_Title") as TextField;
            this.mAppearText.defaultTextFormat = this.mAppearText.getTextFormat();
            this.mAppearText.autoSize = TextFieldAutoSize.CENTER;
            this.mAppearText.text = GameState.getText("MISSION_CLICK_ME");
            _loc5_.width = this.mAppearText.width + _loc2_;
            if(this.mMission.mId == "COMBAT_S_1" || this.mMission.mId == "COMBAT_S_3")
            {
               this.mAppearText.visible = true;
               _loc5_.visible = true;
            }
            else
            {
               this.mAppearText.visible = false;
               _loc5_.visible = false;
            }
            if(GameState.mInstance.mHUD.mPullOutMissionMenuState == GameState.mInstance.mHUD.STATE_MISSIONS_MENU_CLOSED && MissionManager.isShowMissionButtonCompleted())
            {
               GameState.mInstance.mHUD.newMissionNotificationPogressButton.mouseEnabled = false;
               GameState.mInstance.mHUD.newMissionNotificationPogressButton.visible = false;
               GameState.mInstance.mHUD.mButtonPullOutMission.setVisible(true);
               GameState.mInstance.mHUD.mPullOutMissionFrame.gotoAndPlay("Open");
               GameState.mInstance.mHUD.mPullOutMissionMenuState = GameState.mInstance.mHUD.STATE_MISSIONS_MENU_OPEN;
               GameState.mInstance.mHUD.mPullOutMissionFrame.visible = true;
               GameState.mInstance.mHUD.mPullOutMissionFrame.addEventListener(Event.ENTER_FRAME,this.enterFrameMission);
            }
            _loc3_ = this.mFrame.getChildByName("Header") as MovieClip;
            if(_loc3_)
            {
               _loc3_.mouseEnabled = false;
               _loc3_.mouseChildren = false;
               this.mNewText = _loc3_.getChildByName("Text_Field") as TextField;
            }
            if(this.mNewText)
            {
               this.mNewText.autoSize = TextFieldAutoSize.CENTER;
               this.mNewText.text = GameState.getText("MISSION_NEW");
               LocalizationUtils.replaceFont(this.mNewText);
            }
            if(Config.FOR_IPHONE_PLATFORM)
            {
               (_loc6_ = this.mNewText.getTextFormat()).size = 25;
               this.mNewText.defaultTextFormat = _loc6_;
            }
         }
         else if(_loc4_ == STATE_UNOPENED)
         {
            _loc3_ = this.mFrame.getChildByName("Header") as MovieClip;
            if(_loc3_)
            {
               _loc3_.mouseEnabled = false;
               _loc3_.mouseChildren = false;
               this.mNewText = _loc3_.getChildByName("Text_Field") as TextField;
            }
            if(this.mNewText)
            {
               this.mNewText.autoSize = TextFieldAutoSize.CENTER;
               this.mNewText.text = GameState.getText("MISSION_NEW");
               LocalizationUtils.replaceFont(this.mNewText);
            }
            if(Config.FOR_IPHONE_PLATFORM)
            {
               (_loc7_ = this.mNewText.getTextFormat()).size = 25;
               this.mNewText.defaultTextFormat = _loc7_;
            }
         }
         else if(_loc4_ == STATE_PROGRESSING)
         {
            if(GameState.mInstance.mHUD.mPullOutMissionMenuState == GameState.mInstance.mHUD.STATE_MISSIONS_MENU_CLOSED)
            {
               GameState.mInstance.mHUD.newMissionNotificationPogressButton.addEventListener(MouseEvent.CLICK,GameState.mInstance.mHUD.buttonPullOutMissionPressed);
               GameState.mInstance.mHUD.newMissionNotificationPogressButton.mouseEnabled = true;
               GameState.mInstance.mHUD.mButtonPullOutMission.setVisible(false);
               GameState.mInstance.mHUD.newMissionNotificationPogressButton.visible = true;
            }
            _loc3_ = this.mFrame.getChildByName("Header_Progress") as MovieClip;
            if(_loc3_)
            {
               _loc3_.mouseEnabled = false;
               _loc3_.mouseChildren = false;
               this.mProgressTitle = _loc3_.getChildByName("Text_Title") as TextField;
               this.mProgressDesc = _loc3_.getChildByName("Text_Description") as TextField;
            }
            if(this.mProgressTitle)
            {
               this.mProgressTitle.text = GameState.getText("MISSION_PROGRESS");
            }
            if(this.mProgressDesc)
            {
               this.mProgressDesc.autoSize = TextFieldAutoSize.LEFT;
               this.mProgressDesc.text = this.mMission.mTitle;
            }
            if(GameState.mInstance.mHUD.mPullOutMissionMenuState == GameState.mInstance.mHUD.STATE_MISSIONS_MENU_CLOSED)
            {
               if(_loc3_)
               {
                  _loc3_.visible = false;
               }
               if(this.mProgressTitle)
               {
                  this.mProgressTitle.visible = false;
               }
               if(this.mProgressDesc)
               {
                  this.mProgressDesc.visible = false;
               }
            }
            if(_loc3_)
            {
               LocalizationUtils.replaceFonts(_loc3_);
            }
         }
      }
      
      public function getMission() : Mission
      {
         return this.mMission;
      }
      
      public function setMission(param1:Mission, param2:String = null) : void
      {
         this.mMission = param1;
         setVisible(true);
         if(param2)
         {
            this.setState(param2);
         }
         else if(param1.mNew)
         {
            this.setState(STATE_NEW);
         }
         else if(!param1.mOpened)
         {
            this.setState(STATE_UNOPENED);
         }
         else
         {
            this.setState(STATE_OPENED);
         }
         this.mMission.setNew(false);
         if(this.mIcon.numChildren != 0)
         {
            this.mIcon.removeChildAt(0);
         }
         IconLoader.addIcon(this.mIcon,param1,this.iconLoaded);
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         if(this.mMission.mType == Mission.TYPE_RANK)
         {
            Utils.scaleIcon(param1,RANK_ICON_WIDTH,RANK_ICON_HEIGHT);
         }
         else
         {
            Utils.scaleIcon(param1,75,75);
         }
      }
      
      public function getState() : String
      {
         return this.mState;
      }
      
      public function setState(param1:String) : void
      {
         if(this.mState == param1)
         {
            return;
         }
         if(this.mState == STATE_NEW)
         {
            MissionIconsManager.smHighlightedMissionAdded = false;
         }
         if(param1 == STATE_PROGRESSING)
         {
            if(this.mState == STATE_NEW)
            {
               this.mLastState = STATE_UNOPENED;
            }
            else
            {
               this.mLastState = this.mState;
            }
         }
         this.mState = param1;
         this.mFrame.gotoAndPlay(param1);
         this.mFrame.addEventListener(Event.ENTER_FRAME,this.enterFrame);
         this.enterFrame(null);
      }
      
      override protected function mouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Class = null;
         var _loc4_:DCWindow = null;
         if(this.mMission)
         {
            if(mClickSound)
            {
               ArmySoundManager.getInstance().playSound(mClickSound);
            }
            _loc2_ = [MissionProgressWindow,MissionStackWindow,CampaignWindow,RankMissionWindow];
            for each(_loc3_ in _loc2_)
            {
               if(PopUpManager.isPopUpCreated(_loc3_))
               {
                  (_loc4_ = PopUpManager.getPopUp(_loc3_)).close();
                  PopUpManager.releasePopUp(_loc3_);
               }
            }
            if(this.mMission.mType == Mission.TYPE_STORY)
            {
               GameState.mInstance.mHUD.openCharacterDialogWindow(this.mMission);
            }
            else if(this.mMission.mType == Mission.TYPE_TIP)
            {
               GameState.mInstance.mHUD.openTipWindow(this.mMission);
            }
            else if(this.mMission.mType == Mission.TYPE_CAMPAIGN)
            {
               GameState.mInstance.mHUD.openCampaignWindow(this.mMission);
            }
            else if(this.mMission.mType == Mission.TYPE_RANK)
            {
               GameState.mInstance.mHUD.openRankWindow(this.mMission);
            }
            else
            {
               GameState.mInstance.mHUD.openMissionProgressWindow(this.mMission);
            }
            this.mMission.setOpened(true);
            this.setState(STATE_OPENED);
         }
         param1.stopPropagation();
      }
      
      public function getClip() : MovieClip
      {
         return mButton;
      }
   }
}
