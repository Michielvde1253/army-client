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
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ResizingButton;
   import game.items.Item;
   import game.items.ItemManager;
   import game.missions.Control;
   import game.missions.Mission;
   import game.missions.Objective;
   import game.missions.OwnItems;
   import game.net.GameFeedPublisher;
   import game.player.GamePlayerProfile;
   import game.player.RankManager;
   import game.states.GameState;
   
   public class RankMissionWindow extends PopUpWindow
   {
      
      private static const RANKS_VISIBLE:int = 5;
      
      private static const ICON_H:int = 70;
      
      private static const MAX_FRIENDS_VISIBLE_ON_RANK_TOOLTIP:int = 20;
      
      private static const PLAYERS_RANK_IN_COLUMN:int = 2;
       
      
      private var mMaxScrollIndex:int;
      
      private var mCurrentScrollIndex:int;
      
      private var mFrameNewRank:MovieClip;
      
      private var mFrameCurrentRank:MovieClip;
      
      private var mFrameNextRank:MovieClip;
      
      private var mFrameBrowseRanks:MovieClip;
      
      private var mMedalPlace:MovieClip;
      
      private var mRankNew:MovieClip;
      
      private var mRankCurrent:MovieClip;
      
      private var mRankNext:MovieClip;
      
      private var mScrollBar:MovieClip;
      
      private var mButtonPrevious:DCButton;
      
      private var mButtonNext:DCButton;
      
      private var mButtonCancel:DCButton;
      
      private var mButtonShare:ResizingButton;
      
      private var mButtonSkip:ResizingButton;
      
      private var mRanksCompleteOnTimeline:Array;
      
      private var mRanksIncompleteOnTimeline:Array;
      
      private var mPlayerRankIndex:int;
      
      public function RankMissionWindow()
      {
         var _loc2_:TextField = null;
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_01_NAME,"popup_ranks");
         super(new _loc1_(),true);
         this.mButtonPrevious = Utils.createBasicButton(mClip,"Button_Previous",this.previousClicked);
         this.mButtonNext = Utils.createBasicButton(mClip,"Button_Next",this.nextClicked);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mFrameNewRank = mClip.getChildByName("Frame_New_Rank") as MovieClip;
         this.mFrameCurrentRank = mClip.getChildByName("Frame_Current_Rank") as MovieClip;
         this.mFrameNextRank = mClip.getChildByName("Frame_Next_Rank") as MovieClip;
         this.mFrameBrowseRanks = mClip.getChildByName("Frame_Browse_Ranks") as MovieClip;
         _loc2_ = this.mFrameBrowseRanks.getChildByName("Text_Title") as TextField;
         _loc2_.text = GameState.getText("RANK_POPUP_ALLIES_RANKS");
         this.mButtonShare = Utils.createFBIconResizingButton(this.mFrameNewRank,"Button_Share",this.submitClicked);
         this.mButtonShare.setText(GameState.getText("BUTTON_SHARE"));
         this.mScrollBar = mClip.getChildByName("Scrollbar") as MovieClip;
         this.mRankNew = this.mFrameNewRank.getChildByName("Icon_Rank_Current") as MovieClip;
         this.mRankCurrent = this.mFrameCurrentRank.getChildByName("Icon_Rank_Current") as MovieClip;
         this.mRankNext = this.mFrameNextRank.getChildByName("Icon_Rank_Next") as MovieClip;
         this.mMedalPlace = this.mFrameNextRank.getChildByName("Icon_Medals") as MovieClip;
         this.mMedalPlace.scaleX = 0.5;
         this.mMedalPlace.scaleY = 0.5;
         this.mScrollBar.gotoAndStop(1);
      }
      
      public function Activate(param1:Function, param2:Mission, param3:Boolean = false) : void
      {
         var _loc4_:StylizedHeaderClip = null;
         var _loc5_:TextField = null;
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:GamePlayerProfile = null;
         var _loc10_:int = 0;
         var _loc11_:Item = null;
         var _loc12_:int = 0;
         var _loc13_:Mission = null;
         var _loc14_:int = 0;
         var _loc15_:Objective = null;
         var _loc16_:String = null;
         var _loc17_:int = 0;
         if(!this.mRanksCompleteOnTimeline)
         {
            this.mRanksCompleteOnTimeline = new Array(RANKS_VISIBLE);
            this.mRanksIncompleteOnTimeline = new Array(RANKS_VISIBLE);
            _loc6_ = 1;
            while(_loc6_ <= RANKS_VISIBLE)
            {
               this.mRanksCompleteOnTimeline[_loc6_ - 1] = this.mFrameBrowseRanks.getChildByName("Frame_Rank_" + _loc6_ + "_Complete") as MovieClip;
               this.mRanksIncompleteOnTimeline[_loc6_ - 1] = this.mFrameBrowseRanks.getChildByName("Frame_Rank_" + _loc6_ + "_Incomplete") as MovieClip;
               _loc7_ = this.mRanksCompleteOnTimeline[_loc6_ - 1];
               _loc8_ = this.mRanksIncompleteOnTimeline[_loc6_ - 1];
               _loc7_.mouseChildren = false;
               _loc8_.mouseChildren = false;
               _loc6_++;
            }
         }
         this.mMaxScrollIndex = RankManager.getRankCount() - RANKS_VISIBLE;
         this.mPlayerRankIndex = GameState.mInstance.mPlayerProfile.mRankIdx;
         this.initFriendRanks();
         this.setScrollIndex(this.mPlayerRankIndex - PLAYERS_RANK_IN_COLUMN);
         mDoneCallback = param1;
         IconLoader.addIcon(this.mRankCurrent,RankManager.getAdapterByIndex(this.mPlayerRankIndex),this.rankIconLoaded);
         if(this.mPlayerRankIndex + 1 < RankManager.getRankCount())
         {
            IconLoader.addIcon(this.mRankNext,RankManager.getAdapterByIndex(this.mPlayerRankIndex + 1),this.rankIconLoaded);
         }
         _loc4_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("RANK_POPUP_TITLE"));
         if(param3)
         {
            this.mFrameNewRank.visible = true;
            this.mFrameCurrentRank.visible = false;
            (_loc5_ = this.mFrameNewRank.getChildByName("Text_Current_Description") as TextField).text = GameState.getText("RANK_NEW_RANK");
            (_loc5_ = this.mFrameNewRank.getChildByName("Text_Current_Rank") as TextField).text = RankManager.getNameByIndex(this.mPlayerRankIndex);
            IconLoader.addIcon(this.mRankNew,RankManager.getAdapterByIndex(this.mPlayerRankIndex),this.rankIconLoaded);
         }
         else
         {
            this.mFrameNewRank.visible = false;
            this.mFrameCurrentRank.visible = true;
            (_loc5_ = this.mFrameCurrentRank.getChildByName("Text_Current_Description") as TextField).text = GameState.getText("RANK_CURRENT");
            (_loc5_ = this.mFrameCurrentRank.getChildByName("Text_Current_Rank") as TextField).text = RankManager.getNameByIndex(this.mPlayerRankIndex);
            IconLoader.addIcon(this.mRankCurrent,RankManager.getAdapterByIndex(this.mPlayerRankIndex),this.rankIconLoaded);
            (this.mFrameCurrentRank.getChildByName("Badge_Desert_Campaign_Enabled") as MovieClip).visible = false;
         }
         if(this.mPlayerRankIndex < RankManager.getRankCount() - 1)
         {
            (_loc5_ = this.mFrameNextRank.getChildByName("Text_Next_Objective") as TextField).text = GameState.getText("RANK_NEXT_OBJECTIVE");
            (_loc5_ = this.mFrameNextRank.getChildByName("Text_Next_Rank") as TextField).text = RankManager.getNameByIndex(this.mPlayerRankIndex + 1);
            (_loc5_ = this.mFrameNextRank.getChildByName("Text_Description") as TextField).text = GameState.getText("RANK_POPUP_DESCRIPTION");
            IconLoader.addIcon(this.mRankNext,RankManager.getAdapterByIndex(this.mPlayerRankIndex + 1),this.rankIconLoaded);
            _loc9_ = GameState.mInstance.mPlayerProfile;
            _loc13_ = param2;
            if(param3)
            {
               _loc13_ = RankManager.getMissionByIndex(RankManager.getIndexOfMission(param2) + 2);
            }
            _loc14_ = 0;
            while(_loc14_ < _loc13_.getNumObjectives())
            {
               _loc15_ = _loc13_.getObjectiveByIndex(_loc14_);
               _loc16_ = null;
               if(_loc15_.mParameter)
               {
                  _loc16_ = String(_loc15_.mParameter.Type);
               }
               if(_loc15_ is OwnItems && _loc16_ && _loc16_ == "Medal")
               {
                  _loc10_ = _loc15_.mGoal;
                  _loc11_ = ItemManager.getItem(_loc15_.mParameter.ID,_loc15_.mParameter.Type);
               }
               else if(_loc15_ is Control)
               {
                  _loc12_ += _loc15_.mGoal;
               }
               _loc14_++;
            }
            (_loc5_ = this.mFrameNextRank.getChildByName("Text_Amount_Tiles") as TextField).multiline = false;
            _loc5_.wordWrap = false;
            if(_loc12_ > 0)
            {
               _loc5_.defaultTextFormat = _loc5_.getTextFormat();
               _loc5_.text = GameState.mInstance.mMapData.mNumberOfFriendlyTiles + "/" + _loc12_;
               _loc5_.mouseEnabled = false;
               _loc5_.visible = true;
            }
            else
            {
               _loc5_.visible = false;
            }
            (_loc5_ = this.mFrameNextRank.getChildByName("Text_Amount_Medals") as TextField).multiline = false;
            _loc5_.wordWrap = false;
            if(_loc10_ > 0)
            {
               _loc17_ = _loc9_.getItemCount(_loc11_);
               IconLoader.addIcon(this.mMedalPlace,_loc11_,null,true);
               _loc5_.defaultTextFormat = _loc5_.getTextFormat();
               _loc5_.text = _loc17_ + "/" + _loc10_;
               _loc5_.mouseEnabled = false;
               _loc5_.visible = true;
            }
            else
            {
               _loc5_.visible = false;
            }
         }
         else
         {
            (_loc5_ = this.mFrameNextRank.getChildByName("Text_Next_Objective") as TextField).visible = false;
            (_loc5_ = this.mFrameNextRank.getChildByName("Text_Next_Rank") as TextField).visible = false;
            (_loc5_ = this.mFrameNextRank.getChildByName("Text_Description") as TextField).visible = false;
            (_loc5_ = this.mFrameNextRank.getChildByName("Text_Amount_Tiles") as TextField).visible = false;
            (_loc5_ = this.mFrameNextRank.getChildByName("Text_Amount_Medals") as TextField).visible = false;
         }
         doOpeningTransition();
      }
      
      private function setScrollIndex(param1:int) : void
      {
         this.mCurrentScrollIndex = Math.max(Math.min(param1,this.mMaxScrollIndex),0);
         this.populateRankTimeline();
         this.mScrollBar.gotoAndStop(int(this.mCurrentScrollIndex / this.mMaxScrollIndex * (this.mScrollBar.totalFrames - 1)) + 1);
         this.mButtonNext.setEnabled(this.mCurrentScrollIndex < this.mMaxScrollIndex);
         this.mButtonPrevious.setEnabled(this.mCurrentScrollIndex > 0);
      }
      
      private function initFriendRanks() : void
      {
      }
      
      private function populateRankTimeline() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         var _loc5_:TextField = null;
         var _loc1_:int = 0;
         while(_loc1_ < RANKS_VISIBLE)
         {
            (this.mRanksCompleteOnTimeline[_loc1_] as MovieClip).visible = false;
            (this.mRanksIncompleteOnTimeline[_loc1_] as MovieClip).visible = false;
            _loc2_ = this.mPlayerRankIndex >= this.mCurrentScrollIndex + _loc1_ ? this.mRanksCompleteOnTimeline[_loc1_] : this.mRanksIncompleteOnTimeline[_loc1_];
            _loc2_.visible = true;
            _loc3_ = _loc2_.getChildByName("Icon_Rank") as MovieClip;
            _loc4_ = _loc2_.getChildByName("Text_Title") as TextField;
            _loc5_ = _loc2_.getChildByName("Text_Friends") as TextField;
            IconLoader.addIcon(_loc3_,RankManager.getAdapterByIndex(this.mCurrentScrollIndex + _loc1_),this.rankIconLoaded);
            _loc4_.text = RankManager.getNameByIndex(this.mCurrentScrollIndex + _loc1_);
            _loc1_++;
         }
      }
      
      public function rankIconLoaded(param1:Sprite) : void
      {
         param1.height = ICON_H;
         param1.scaleX = param1.scaleY;
      }
      
      public function getClip() : DisplayObjectContainer
      {
         return mClip;
      }
      
      private function buyObjectiveButtonPressed(param1:Event) : void
      {
      }
      
      private function shopObjectiveButtonPressed(param1:Event) : void
      {
      }
      
      private function submitClicked(param1:Event) : void
      {
         GameFeedPublisher.publishMessage(GameFeedPublisher.FEED_RANK_UP,"" + this.mPlayerRankIndex,null,this.closeDialog);
      }
      
      private function previousClicked(param1:Event) : void
      {
         this.setScrollIndex(this.mCurrentScrollIndex - 1);
      }
      
      private function nextClicked(param1:Event) : void
      {
         this.setScrollIndex(this.mCurrentScrollIndex + 1);
      }
      
      private function closeClicked(param1:Event) : void
      {
         this.closeDialog();
      }
      
      private function setTooltipVisible(param1:Boolean, param2:MovieClip = null) : void
      {
      }
      
      private function mouseOverRank(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         this.setTooltipVisible(true,param1.target as MovieClip);
      }
      
      private function mouseOutRank(param1:MouseEvent) : void
      {
         this.setTooltipVisible(false);
      }
      
      protected function closeDialog(param1:Boolean = true) : void
      {
         if(param1)
         {
            mDoneCallback((this as Object).constructor);
         }
      }
   }
}
