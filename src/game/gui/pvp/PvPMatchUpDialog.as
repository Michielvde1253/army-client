package game.gui.pvp
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.gui.button.ResizingButtonSelected;
   import game.gui.popups.PopUpWindow;
   import game.net.Friend;
   import game.net.FriendsCollection;
   import game.net.PvPOpponent;
   import game.net.PvPOpponentCollection;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class PvPMatchUpDialog extends PopUpWindow
   {
	  // Allies + recent tab have been hidden, refer to earlier version for the original code
      
      private static const PANEL_COUNT:int = 1;
      
      private static const TAB_BUTTON_SPACING:int = 3;
      
      //private static const TAB_ALLIES:int = 0;
      
      private static const TAB_PLAYERS:int = 0;
      
      //private static const TAB_RECENT:int = 2;
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mTabButtons:Array;
      
      private var mButtonLeaderboard:ResizingButton;
      
      private var mButtonScrollUp:ArmyButton;
      
      private var mButtonScrollDown:ArmyButton;
      
      private var mStatus:MovieClip;
      
      private var mPanels:Array;
      
      private var mTab:int;
      
      private var mPage:int = 0;
      
      private var mPageMax:int = 0;
      
      private var mAllTabs:Array;
      
      private var mCurrentTab:Array;
      
      private var mScrollbar:MovieClip;
      
      private var mScrollbarBg:MovieClip;
      
      private var mScrollSlider:MovieClip;
      
      private var mScrollSliderDefaultX:int;
      
      private var mMouseY:Number = 0;
      
      private var mCombatSetupCallBack:Function;
      
      private var mHeader:StylizedHeaderClip;
      
      public function PvPMatchUpDialog()
      {
         var _loc3_:TextField = null;
         var _loc7_:ResizingButtonSelected = null;
         var _loc8_:MovieClip = null;
         this.mPanels = new Array();
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass("swf/popups_pvp","popup_pvp");
         super(new _loc1_(),true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonScrollUp = Utils.createBasicButton(mClip,"Button_Scroll_Up",this.upPressed);
         this.mButtonScrollDown = Utils.createBasicButton(mClip,"Button_Scroll_Down",this.downPressed);
         var _loc2_:Friend = FriendsCollection.smFriends.GetThePlayer();
         this.mStatus = mClip.getChildByName("PvP_Status") as MovieClip;
         _loc3_ = this.mStatus.getChildByName("Text_Description") as TextField;
         _loc3_.text = GameState.getText("PVP_BADASS_STATUS");
         _loc3_ = this.mStatus.getChildByName("Text_Description_Wins") as TextField;
         _loc3_.text = GameState.getText("PVP_WINS");
         _loc3_ = this.mStatus.getChildByName("Text_Name") as TextField;
         _loc3_.text = _loc2_.mName;
         this.mHeader = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,"",TextFieldAutoSize.LEFT);
         this.mHeader.setText(GameState.getText("PVP_MATCHUP_TITLE"));
         this.mTabButtons = new Array();
         var _loc4_:int = 1;
         while(_loc4_ <= 5)
         {
            _loc7_ = Utils.createResizingButtonSelected(mClip,"PvP_Tab_0" + _loc4_,this.tabButtonPressed);
            if(_loc4_ <= 1)
            {
               _loc7_.setPool(this.mTabButtons);
               _loc7_.setAllowDeselection(false);
            }
            else
            {
               _loc7_.setVisible(false);
            }
            _loc4_++;
         }
         var _loc5_:Sprite = this.mStatus.getChildByName("Thumb") as Sprite;
         if(_loc2_ && _loc2_.mPicID != null && _loc2_.mPicID != "")
         {
            IconLoader.addIconPicture(_loc5_,_loc2_.mPicID);
         }
         this.mButtonLeaderboard = Utils.createResizingIconButton(this.mStatus,"Button_Leaderboard",null);
         this.mButtonLeaderboard.setVisible(false);
         //(this.mTabButtons[0] as ResizingButtonSelected).setText(GameState.getText("PVP_ALLIES"));
         (this.mTabButtons[0] as ResizingButtonSelected).setText(GameState.getText("PVP_PLAYER"));
         //(this.mTabButtons[2] as ResizingButtonSelected).setText(GameState.getText("PVP_RECENT"));
         (this.mTabButtons[0] as ResizingButtonSelected).select();
         var _loc6_:int = 0;
         while(_loc6_ < PANEL_COUNT)
         {
            _loc8_ = mClip.getChildByName("Slot_PvP_0" + (_loc6_ + 1)) as MovieClip;
            this.mPanels[_loc6_] = new PvPOpponentPanel(_loc8_,this);
            _loc6_++;
         }
         this.mScrollbar = mClip.getChildByName("Scrollbar") as MovieClip;
         this.mScrollbarBg = this.mScrollbar.getChildByName("Scrollbar_Bg") as MovieClip;
         this.mScrollSlider = this.mScrollbar.getChildByName("Scrollbar_Slider") as MovieClip;
         this.mScrollSliderDefaultX = this.mScrollSlider.x;
         this.mScrollSlider.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown,false,0,true);
         this.mScrollSlider.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove,false,0,true);
      }
      
      public function Activate(param1:Function, param2:Function) : void
      {
         var _loc5_:TextField = null;
         mDoneCallback = param1;
         this.mCombatSetupCallBack = param2;
         var _loc3_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         var _loc4_:MovieClip;
         (_loc5_ = (_loc4_ = this.mStatus.getChildByName("Rank_Icon") as MovieClip).getChildByName("Text_PvP_Rank") as TextField).text = _loc3_.mBadassLevel.toString();
         (_loc5_ = this.mStatus.getChildByName("Text_PvP_Rank") as TextField).text = _loc3_.getBadassName();
         (_loc5_ = this.mStatus.getChildByName("Text_Wins") as TextField).text = _loc3_.mBadassWins.toString();
         var _loc6_:int = 1;
         while(_loc6_ < this.mTabButtons.length)
         {
            (this.mTabButtons[_loc6_] as ResizingButtonSelected).setX(TAB_BUTTON_SPACING + (this.mTabButtons[_loc6_ - 1] as ResizingButtonSelected).getX() + ((this.mTabButtons[_loc6_ - 1] as ResizingButtonSelected).getWidth() + (this.mTabButtons[_loc6_] as ResizingButtonSelected).getWidth()) / 2);
            _loc6_++;
         }
         this.mAllTabs = new Array();
         //this.mAllTabs.push(FriendsCollection.smFriends.getPlayingFriendsExcludingTutor());
         this.mAllTabs.push(PvPOpponentCollection.smCollection.mOpponents);
         this.mAllTabs.push(PvPOpponentCollection.smCollection.mRecentAttacks);
         //(this.mAllTabs[TAB_ALLIES] as Array).sort(this.sortOpponents);
         (this.mAllTabs[TAB_PLAYERS] as Array).sort(this.sortOpponents);
         //(this.mAllTabs[TAB_RECENT] as Array).sort(this.sortOpponents);
         this.setTab(TAB_PLAYERS);
         doOpeningTransition();
      }
      
      private function sortOpponents(param1:PvPOpponent, param2:PvPOpponent) : Number
      {
         if(param1.mBadassXp > param2.mBadassXp)
         {
            return -1;
         }
         if(param1.mBadassXp < param2.mBadassXp)
         {
            return 1;
         }
         return 0;
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         this.closeDialog();
         GameState.mInstance.endPvP();
      }
      
      protected function closeDialog(param1:Boolean = true) : void
      {
         if(param1)
         {
            mDoneCallback((this as Object).constructor);
         }
      }
      
      private function tabButtonPressed(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.mTabButtons.length)
         {
            if((this.mTabButtons[_loc2_] as ResizingButtonSelected).getMovieClip() == param1.target)
            {
               this.setTab(_loc2_);
               return;
            }
            _loc2_++;
         }
      }
      
      private function upPressed(param1:MouseEvent) : void
      {
         this.mPage = Math.max(0,this.mPage - 1);
         this.setScreen();
         this.setScrollButtons();
         this.setScrollSlider();
      }
      
      private function downPressed(param1:MouseEvent) : void
      {
         this.mPage = Math.min(this.mPageMax - 1,this.mPage + 1);
         this.setScreen();
         this.setScrollButtons();
         this.setScrollSlider();
      }
      
      private function setTab(param1:int) : void
      {
         this.mTab = param1;
         if(this.mTabButtons[param1])
         {
            (this.mTabButtons[param1] as ResizingButtonSelected).select();
         }
         this.mCurrentTab = this.mAllTabs[param1];
         this.refresh();
      }
      
      private function setScreen() : void
      {
         var _loc3_:PvPOpponentPanel = null;
         var _loc4_:int = 0;
         var _loc1_:int = this.mPage * PANEL_COUNT;
         var _loc2_:int = 0;
         while(_loc2_ < PANEL_COUNT)
         {
            _loc3_ = PvPOpponentPanel(this.mPanels[_loc2_]);
            if((_loc4_ = _loc2_ + _loc1_) < this.mCurrentTab.length)
            {
               _loc3_.show();
               _loc3_.setData(this.mCurrentTab[_loc4_],false);
            }
            else
            {
               _loc3_.hide();
            }
            _loc2_++;
         }
      }
      
      private function refresh() : void
      {
         this.mPage = 0;
         this.mPageMax = (this.mCurrentTab.length + PANEL_COUNT - 1) / PANEL_COUNT;
         this.setScreen();
         this.setScrollButtons();
         this.setScrollSlider();
      }
      
      private function setScrollButtons() : void
      {
         this.mButtonScrollDown.setVisible(this.mPageMax > 1);
         this.mButtonScrollUp.setVisible(this.mPageMax > 1);
         this.mScrollbar.visible = this.mPageMax > 1;
         if(this.mPageMax > 1)
         {
            this.mButtonScrollDown.setEnabled(this.mPage < this.mPageMax - 1);
            this.mButtonScrollUp.setEnabled(this.mPage > 0);
         }
      }
      
      private function setScrollSlider() : void
      {
         var _loc1_:int = this.mScrollbarBg.width - this.mScrollSlider.width;
         this.mScrollSlider.x = this.mScrollSliderDefaultX + _loc1_ * this.mPage / (this.mPageMax - 1);
      }
      
      protected function mouseDown(param1:MouseEvent) : void
      {
         this.setMousePos(param1);
      }
      
      protected function mouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1.buttonDown)
         {
            _loc2_ = this.mouseY - this.mMouseY;
            _loc3_ = this.mScrollbarBg.width - this.mScrollSlider.width;
            this.mScrollSlider.x += _loc2_;
            this.mScrollSlider.x = Math.max(this.mScrollSliderDefaultX,this.mScrollSlider.x);
            this.mScrollSlider.x = Math.min(this.mScrollSliderDefaultX + _loc3_,this.mScrollSlider.x);
            if((_loc4_ = (this.mScrollSlider.x - this.mScrollSliderDefaultX + (this.mScrollSlider.width >> 1)) * (this.mPageMax - 1) / _loc3_) != this.mPage)
            {
               this.mPage = _loc4_;
               this.setScreen();
               this.setScrollButtons();
            }
            this.setMousePos(param1);
         }
      }
      
      public function setMousePos(param1:MouseEvent) : void
      {
         this.mMouseY = this.mouseY;
      }
      
      public function attackPlayer(param1:PvPOpponent) : void
      {
		 trace("DOES IT?????????")
         this.closeDialog();
		 trace("bruh c'mon")
         GameState.mInstance.mPvPMatch.mOpponent = param1;
		 trace("yes pls")
         this.mCombatSetupCallBack();
		 trace("JUST DO IT")
      }
      
      public function updateOpponents() : void
      {
         this.setScreen();
      }
   }
}
