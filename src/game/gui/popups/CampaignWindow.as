package game.gui.popups
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ResizingButton;
   import game.missions.Mission;
   import game.missions.Objective;
   import game.states.GameState;
   
   public class CampaignWindow extends PopUpWindow
   {
      
      private static const MAX_OBJECTIVES:int = 5;
      
      private static const VIR_SRC:String = "vir_CampaignWindow_button";
       
      
      private var mBuyObjectiveButtons:Array;
      
      private var mButtonCancel:DCButton;
      
      private var mButtonInvite:ResizingButton;
      
      private var mPanel:MovieClip;
      
      private var mMission:Mission;
      
      private var mCompletedTextField:TextField = null;
      
      private var mObjectiveWasJustCompleted:String;
      
      private var mFillFramesOneStep:int;
      
      private var mObjectivesCount:int;
      
      private var mCompletedObjectivesCount:int;
      
      private var completedMovieClip:MovieClip;
      
      public function CampaignWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_01_NAME,"popup_campaign");
         super(new _loc1_(),true);
      }
      
      public function Activate(param1:Function, param2:Mission, param3:String) : void
      {
         var _loc4_:MovieClip = null;
         var _loc6_:StylizedHeaderClip = null;
         var _loc7_:TextField = null;
         var _loc8_:TextFormat = null;
         mDoneCallback = param1;
         this.mMission = param2;
         this.mObjectivesCount = param2.getNumObjectives();
         this.mObjectiveWasJustCompleted = param3;
         var _loc5_:int = this.mObjectivesCount + 1;
         while(_loc5_ <= MAX_OBJECTIVES)
         {
            (_loc4_ = mClip.getChildByName("Frame_Objective_" + _loc5_) as MovieClip).visible = false;
            (_loc4_ = mClip.getChildByName("Frame_Objective_Complete_" + _loc5_) as MovieClip).visible = false;
            _loc5_++;
         }
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonInvite = Utils.createResizingButton(mClip,"Button_Skip",this.invitePressed);
         this.mButtonInvite.setText(GameState.getText("BUTTON_INVITE"));
         _loc6_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("CAMPAIGN_WINDOW_TITLE"));
         _loc7_ = mClip.getChildByName("Text_Title") as TextField;
         _loc7_.defaultTextFormat = _loc7_.getTextFormat();
         _loc7_.text = param2.mTitle;
         _loc7_.mouseEnabled = false;
         _loc7_ = mClip.getChildByName("Text_Description") as TextField;
         _loc7_.defaultTextFormat = _loc7_.getTextFormat();
         _loc7_.text = param2.mDescription;
         _loc7_.mouseEnabled = false;
         _loc7_.visible = false;
         _loc8_ = (_loc7_ = mClip.getChildByName("Text_Progress") as TextField).getTextFormat();
         if(Config.FOR_IPHONE_PLATFORM)
         {
            _loc8_.size = 21;
         }
         _loc7_.defaultTextFormat = _loc8_;
         _loc7_.text = GameState.getText("CAMPAIGN_WINDOW_PROGRESS_BAR_TITLE");
         _loc7_.mouseEnabled = false;
         _loc7_ = mClip.getChildByName("Text_Hint") as TextField;
         _loc7_.defaultTextFormat = _loc7_.getTextFormat();
         _loc7_.text = GameState.getText("CAMPAIGN_WINDOW_INVITE_TIP");
         _loc7_.mouseEnabled = false;
         _loc7_.visible = false;
         this.completedMovieClip = mClip.getChildByName("Completed") as MovieClip;
         this.completedMovieClip.visible = false;
         this.completedMovieClip.addEventListener(Event.FRAME_CONSTRUCTED,this.updateCompletedText,false,0,true);
         this.updateObjectives();
         doOpeningTransition();
      }
      
      private function updateCompletedText(param1:Event) : void
      {
         var _loc3_:TextField = null;
         var _loc2_:MovieClip = param1.target as MovieClip;
         _loc2_.removeEventListener(Event.FRAME_CONSTRUCTED,this.updateCompletedText);
         if(_loc2_.visible)
         {
            if(LocalizationUtils.languageHasSpecialCharacters())
            {
               _loc2_.stop();
            }
            _loc3_ = _loc2_.getChildByName("Text_Completed") as TextField;
            if(_loc3_)
            {
               if(_loc3_ != this.mCompletedTextField)
               {
                  this.mCompletedTextField = _loc3_;
                  _loc3_.defaultTextFormat = _loc3_.getTextFormat();
                  _loc3_.text = GameState.getText("CAMPAIGN_WINDOW_COMPLETED");
                  LocalizationUtils.replaceFont(_loc3_);
               }
            }
         }
      }
      
      public function updateObjectives() : void
      {
         var _loc1_:TextField = null;
         var _loc2_:TextField = null;
         var _loc7_:Objective = null;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         var _loc10_:int = 0;
         var _loc11_:MovieClip = null;
         this.mBuyObjectiveButtons = new Array();
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this.mObjectivesCount)
         {
            _loc7_ = this.mMission.getObjectiveByIndex(_loc5_);
            _loc2_ = null;
            if(_loc7_.isDone())
            {
               (_loc8_ = mClip.getChildByName("Frame_Objective_" + (_loc5_ + 1)) as MovieClip).visible = false;
               _loc8_ = mClip.getChildByName("Frame_Objective_Complete_" + (_loc5_ + 1)) as MovieClip;
               if(_loc7_.mId != this.mObjectiveWasJustCompleted)
               {
                  (_loc8_.getChildByName("Checkmark") as MovieClip).gotoAndStop(1);
               }
            }
            else
            {
               (_loc8_ = mClip.getChildByName("Frame_Objective_Complete_" + (_loc5_ + 1)) as MovieClip).visible = false;
               _loc2_ = (_loc8_ = mClip.getChildByName("Frame_Objective_" + (_loc5_ + 1)) as MovieClip).getChildByName("Text_Amount") as TextField;
               _loc2_.defaultTextFormat = _loc2_.getTextFormat();
               _loc2_.text = _loc7_.mCounter.toString() + "/" + _loc7_.mGoal;
               _loc2_.mouseEnabled = false;
               _loc2_.autoSize = TextFieldAutoSize.LEFT;
            }
            _loc1_ = _loc8_.getChildByName("Text_Title") as TextField;
            _loc1_.defaultTextFormat = _loc1_.getTextFormat();
            _loc1_.text = _loc7_.mTitle;
            _loc1_.mouseEnabled = false;
            _loc1_.wordWrap = true;
            _loc1_.autoSize = TextFieldAutoSize.LEFT;
            if(_loc5_ == 0)
            {
               _loc3_ = _loc1_.y;
            }
            _loc8_.y = _loc3_ + _loc4_;
            _loc1_.y = _loc8_.y;
            if(_loc2_)
            {
               _loc2_.y = _loc8_.y;
            }
            if(_loc8_.getChildByName("Checkmark"))
            {
               _loc8_.getChildByName("Checkmark").y = _loc8_.y;
            }
            (_loc9_ = _loc8_.getChildByName("Icon") as MovieClip).y = _loc8_.y;
            IconLoader.addIcon(_loc9_,_loc7_,this.iconLoaded);
            if(_loc7_.isDone())
            {
               ++this.mCompletedObjectivesCount;
            }
            _loc4_ += _loc1_.height;
            (_loc8_.getChildByName("Line") as MovieClip).y = _loc3_ + _loc4_;
            _loc5_++;
         }
         _loc8_ = mClip.getChildByName("Progress") as MovieClip;
         this.mFillFramesOneStep = (_loc8_.getChildByName("Fill") as MovieClip).totalFrames / this.mObjectivesCount;
         var _loc6_:int = this.mCompletedObjectivesCount / this.mObjectivesCount * 100;
         _loc1_ = mClip.getChildByName("Text_Amount") as TextField;
         _loc1_.defaultTextFormat = _loc1_.getTextFormat();
         _loc1_.mouseEnabled = false;
         if(!this.mObjectiveWasJustCompleted)
         {
            _loc10_ = (_loc8_.getChildByName("Fill") as MovieClip).totalFrames * (_loc6_ / 100);
            _loc1_.text = _loc6_ + "%";
            (_loc8_.getChildByName("Fill") as MovieClip).gotoAndStop(_loc10_);
            if(_loc6_ == 100)
            {
               (_loc11_ = mClip.getChildByName("Completed") as MovieClip).visible = true;
               (mClip.getChildByName("Text_Amount") as TextField).visible = false;
            }
         }
         else
         {
            if(this.mCompletedObjectivesCount > 0)
            {
               _loc6_ = (this.mCompletedObjectivesCount - 1) / this.mObjectivesCount * 100;
            }
            _loc1_.text = _loc6_ + "%";
            _loc8_.getChildByName("Fill").addEventListener(Event.ENTER_FRAME,this.fillTheBarGraphic);
         }
         this.mObjectiveWasJustCompleted = null;
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,45,45);
         param1.y += param1.height >> 2;
      }
      
      private function fillTheBarGraphic(param1:Event) : void
      {
         var _loc6_:MovieClip = null;
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:int = 0;
         var _loc4_:int = this.mFillFramesOneStep * this.mCompletedObjectivesCount;
         if(this.mCompletedObjectivesCount > 0)
         {
            _loc3_ = this.mFillFramesOneStep * (this.mCompletedObjectivesCount - 1);
         }
         var _loc5_:int = _loc2_.currentFrame / _loc2_.totalFrames * 100;
         if(_loc2_.currentFrame < _loc3_)
         {
            _loc2_.gotoAndPlay(_loc3_);
         }
         else if(_loc2_.currentFrame >= _loc4_)
         {
            if(this.mCompletedObjectivesCount == this.mObjectivesCount)
            {
               _loc2_.gotoAndStop(_loc2_.totalFrames);
            }
            else
            {
               _loc2_.stop();
            }
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.fillTheBarGraphic);
            if((_loc5_ = this.mCompletedObjectivesCount / this.mObjectivesCount * 100) == 100)
            {
               (_loc6_ = mClip.getChildByName("Completed") as MovieClip).visible = true;
               _loc6_.addEventListener(Event.ENTER_FRAME,this.fadeIn);
               _loc6_.alpha = 0;
               (mClip.getChildByName("Text_Amount") as TextField).visible = false;
            }
         }
         (mClip.getChildByName("Text_Amount") as TextField).text = _loc5_ + "%";
      }
      
      private function fadeIn(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         _loc2_.alpha += 0.02;
         if(_loc2_.alpha >= 1)
         {
            _loc2_.alpha = 1;
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.fadeIn);
         }
      }
      
      public function getClip() : DisplayObjectContainer
      {
         return mClip;
      }
      
      private function buyObjectiveButtonPressed(param1:Event) : void
      {
         var _loc3_:ResizingButton = null;
         var _loc6_:int = 0;
         var _loc7_:Objective = null;
         var _loc2_:GameState = GameState.mInstance;
         var _loc4_:int = int(this.mBuyObjectiveButtons.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = this.mBuyObjectiveButtons[_loc5_] as ResizingButton;
            if(_loc3_.getClip() == param1.target)
            {
               _loc6_ = this.mBuyObjectiveButtons.indexOf(_loc3_);
               _loc7_ = this.mMission.getObjectiveByIndex(_loc6_);
               _loc2_.externalCallUnlockObjective(_loc7_);
               break;
            }
            _loc5_++;
         }
         if(this.mMission.allObjectivesDone())
         {
            mDoneCallback((this as Object).constructor);
         }
      }
      
      private function invitePressed(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
         GameState.mInstance.mHUD.toggleSocialDialog(param1);
      }
      
      private function closeClicked(param1:Event) : void
      {
         this.completedMovieClip.removeEventListener(Event.FRAME_CONSTRUCTED,this.updateCompletedText);
         mDoneCallback((this as Object).constructor);
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < this.mObjectivesCount)
         {
            if(!this.mMission.getObjectiveByIndex(_loc3_).isDone())
            {
               _loc2_ = false;
               break;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            if(this.mMission.mCampaignCompletionText)
            {
               GameState.mInstance.mHUD.openCampaignProgressWindow(this.mMission,this.mMission.mCampaignCompletionText,true);
            }
         }
      }
   }
}
