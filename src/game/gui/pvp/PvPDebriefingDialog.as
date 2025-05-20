package game.gui.pvp
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.gui.button.ResizingButtonSelected;
   import game.gui.popups.PopUpWindow;
   import game.items.CollectibleItem;
   import game.net.GameFeedPublisher;
   import game.net.PvPOpponent;
   import game.states.GameState;
   
   public class PvPDebriefingDialog extends PopUpWindow
   {
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonBrag:ResizingButton;
      
      private var mButtonMatchupScreen:ResizingButtonSelected;
      
      private var mPlayerCard:MovieClip;
      
      private var mOpponentCard:MovieClip;
      
      private var mStatus:MovieClip;
      
      private var mLoot:MovieClip;
      
      private var mPlayer:PvPOpponent;
      
      private var mOpponent:PvPOpponent;
      
      private var mMatchUpCallback:Function;
      
      private var mHeader:StylizedHeaderClip;
      
      public function PvPDebriefingDialog()
      {
         var _loc2_:TextField = null;
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass("swf/popups_pvp","popup_pvp_loot");
         super(new _loc1_(),true);
         this.mPlayerCard = mClip.getChildByName("Player_Card") as MovieClip;
         this.mOpponentCard = mClip.getChildByName("Opponent_Card") as MovieClip;
         this.mStatus = mClip.getChildByName("PvP_Battle_Status") as MovieClip;
         this.mLoot = mClip.getChildByName("PvP_Loot") as MovieClip;
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonMatchupScreen = Utils.createResizingButtonSelected(mClip,"PvP_Button_Backtolist",this.newMach);
         this.mButtonBrag = Utils.createResizingButton(this.mStatus,"Button_Share",this.postPvpBragFeed);
         this.mButtonMatchupScreen.setText(GameState.getText("PVP_BUTTON_DEBRIEFING_NEW_PVP_MACH"));
         this.mButtonBrag.setText(GameState.getText("PVP_BUTTON_DEBRIEFING_POST_FEED"));
         this.mHeader = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip);
         this.mHeader.setText(GameState.getText("PVP_DEBRIEFING_TITLE"));
         _loc2_ = this.mLoot.getChildByName("Text_Description") as TextField;
         _loc2_.text = GameState.getText("PVP_DEBRIEFING_LOOT");
         _loc2_ = this.mLoot.getChildByName("Text_Instruction") as TextField;
         _loc2_.text = GameState.getText("PVP_DEBRIEFING_INSTRUCTION");
         _loc2_ = this.mStatus.getChildByName("Text_Description") as TextField;
         _loc2_.text = GameState.getText("PVP_DEBRIEFING_STATUS");
      }
      
      public function Activate(param1:Function, param2:Function) : void
      {
         this.mButtonBrag.setEnabled(true);
         mDoneCallback = param1;
         this.mMatchUpCallback = param2;
         this.mPlayer = new PvPOpponent(GameState.mInstance.mPlayerProfile.mUid,GameState.mInstance.mPlayerProfile.mBadassXp,GameState.mInstance.mPlayerProfile.mBadassLevel,GameState.mInstance.mPlayerProfile.mBadassWins, "", "");
         this.setCard(this.mPlayerCard,this.mPlayer);
         this.mOpponent = GameState.mInstance.mPvPMatch.mOpponent;
         this.setCard(this.mOpponentCard,this.mOpponent);
         var _loc3_:MovieClip = this.mStatus.getChildByName("Icon") as MovieClip;
         var _loc4_:TextField = this.mStatus.getChildByName("Text_PvP_Battle_Status") as TextField;
         if(GameState.mInstance.mPvPMatch.mWin)
         {
            IconLoader.addIconPicture(_loc3_,Config.DIR_DATA + "icons/pvp_ui_icons/win.png",this.iconLoaded);
            _loc4_.text = GameState.getText("PVP_DEBRIEFING_WIN");
         }
         else
         {
            IconLoader.addIconPicture(_loc3_,Config.DIR_DATA + "icons/pvp_ui_icons/lose.png",this.iconLoaded);
            _loc4_.text = GameState.getText("PVP_DEBRIEFING_LOSS");
         }
         var _loc5_:TextField = this.mLoot.getChildByName("Text_Money") as TextField;
         var _loc6_:TextField = this.mLoot.getChildByName("Text_Rank_Points") as TextField;
         _loc5_.text = "" + GameState.mInstance.mPvPMatch.mWinRewardMoney;
         _loc6_.text = "" + (GameState.mInstance.mPvPMatch.mWinRewardBadassXp + GameState.mInstance.mPvPMatch.mIngameBadassXp);
         this.setLootItems(GameState.mInstance.mPvPMatch.mIngameCollectibles);
         doOpeningTransition();
      }
      
      private function setLootItems(param1:Array) : void
      {
         var _loc3_:CollectibleItem = null;
         var _loc4_:MovieClip = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = 1;
         for each(_loc3_ in param1)
         {
            _loc4_ = this.mLoot.getChildByName("Item_0" + _loc2_) as MovieClip;
            IconLoader.addIcon(_loc4_,_loc3_,this.iconLoaded);
            _loc2_++;
            if(_loc2_ > 4)
            {
               break;
            }
         }
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,85,85);
         param1.mouseChildren = false;
         param1.mouseEnabled = false;
      }
      
      private function setCard(param1:MovieClip, param2:PvPOpponent) : void
      {
         var _loc3_:TextField = null;
         if(param1 == null || param2 == null)
         {
            if(Config.DEBUG_MODE)
            {
            }
            return;
         }
         _loc3_ = param1.getChildByName("Text_Rank") as TextField;
         _loc3_.text = param2.getBadassName();
         _loc3_ = param1.getChildByName("Text_Name") as TextField;
         _loc3_.text = param2.mName;
         var _loc4_:Sprite = param1.getChildByName("Thumb") as Sprite;
         if(param2 && param2.mPicID != null && param2.mPicID != "")
         {
            IconLoader.addIconPicture(_loc4_,param2.mPicID);
         }
         var _loc5_:MovieClip;
         _loc3_ = (_loc5_ = param1.getChildByName("Rank_Icon") as MovieClip).getChildByName("Text_PvP_Rank") as TextField;
         _loc3_.text = "" + param2.mBadassLevel;
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         this.closeDialog();
         GameState.mInstance.endPvP();
      }
      
      private function postPvpBragFeed(param1:MouseEvent) : void
      {
         GameFeedPublisher.publishMessage(this.getFeedName(),null,null,this.disableFeedButton);
      }
      
      private function getFeedName() : String
      {
         return GameState.mInstance.mPvPMatch.mWin ? GameFeedPublisher.FEED_PVP_WIN : GameFeedPublisher.FEED_PVP_LOSE;
      }
      
      private function disableFeedButton(param1:Boolean = true) : void
      {
         if(Boolean(this.mButtonBrag) && param1)
         {
            this.mButtonBrag.setEnabled(false);
         }
      }
      
      protected function closeDialog(param1:Boolean = true) : void
      {
         if(param1)
         {
            mDoneCallback((this as Object).constructor);
         }
      }
      
      private function newMach(param1:MouseEvent) : void
      {
         GameState.mInstance.getHud().openPvPMatchUpDialog();
         this.closeDialog();
      }
      
      protected function mouseDown(param1:MouseEvent) : void
      {
      }
      
      protected function mouseMove(param1:MouseEvent) : void
      {
      }
   }
}
