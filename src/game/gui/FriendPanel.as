package game.gui
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import game.gui.button.ArmyButton;
   import game.items.Item;
   import game.missions.MissionManager;
   import game.net.Friend;
   import game.player.GamePlayerProfile;
   import game.player.RankManager;
   import game.states.GameState;
   
   public class FriendPanel
   {
      
      public static const FRICTIONLESS_GIFT_SUPPLIES:String = "SupplyPack";
      
      public static const FRICTIONLESS_GIFT_ENERGY:String = "Energy";
       
      
      private const RANK_ICON_SIZE:int = 45;
      
      private const STATE_OPEN:String = "Open";
      
      private const STATE_CLOSED:String = "Closed";
      
      private var mState:String;
      
      private var mBasePanel:MovieClip;
      
      private var mBaseVisitPanel:MovieClip;
      
      private var mCurrentVisitPanel:MovieClip;
      
      private var mFriendCard:MovieClip;
      
      private var mSlotVisit:MovieClip;
      
      private var mButtonVisit:ArmyButton;
      
      private var mCurrentLabel:String = "Close";
      
      private var mCurrentWishlistLength:int;
      
      private var mFlareIcon:MovieClip;
      
      private var mName:TextField;
      
      private var mNameTextFieldFormat:TextFormat = null;
      
      private var mNameTextFieldWidth:int;
      
      private var mNameTextFieldX:int;
      
      private var mXPLevelText:AutoTextField;
      
      private var mSocialXPLevelText:TextField;
      
      private var mXPLevelIcon:MovieClip;
      
      private var mSocialXPLevelIcon:MovieClip;
      
      private var mRankSlot:MovieClip;
      
      private var mPhoto:MovieClip;
      
      private var mFriend:Friend = null;
      
      private var mSendButtons:Array;
      
      private var mSendEnergyButton:ArmyButton;
      
      private var mSendSuppliesButton:ArmyButton;
      
      private var mPvpAttackButton:ArmyButton;
      
      private var mIconWidth:int;
      
      private var mIconHeight:int;
      
      private var mLists:Array;
      
      private var mNormalFrame:int;
      
      public function FriendPanel(param1:MovieClip, param2:MovieClip)
      {
         var _loc4_:MovieClip = null;
         super();
         this.mBasePanel = param1;
         this.mBasePanel.visible = false;
         this.mBasePanel.mouseEnabled = false;
         this.mBasePanel.mouseChildren = false;
         this.mBaseVisitPanel = param2;
         this.mBaseVisitPanel.visible = false;
         this.mBaseVisitPanel.mouseEnabled = false;
         this.mBaseVisitPanel.mouseChildren = false;
         this.mFriendCard = this.mBasePanel.getChildByName("Card") as MovieClip;
         this.mFlareIcon = this.mFriendCard.getChildByName("Counter_Flare") as MovieClip;
         this.mFlareIcon.visible = false;
         this.mName = TextField(this.mFriendCard.getChildByName("Text_Title"));
         LocalizationUtils.replaceFonts(this.mName);
         this.mNameTextFieldFormat = this.mName.getTextFormat();
         this.mNameTextFieldWidth = this.mName.width;
         this.mNameTextFieldX = this.mName.x;
         this.mXPLevelIcon = this.mFriendCard.getChildByName("Counter_Level") as MovieClip;
         this.mXPLevelText = new AutoTextField(this.mXPLevelIcon.getChildByName("Text_Amount") as TextField);
         this.mSocialXPLevelIcon = this.mFriendCard.getChildByName("Counter_Honor_Level") as MovieClip;
         this.mSocialXPLevelText = this.mSocialXPLevelIcon.getChildByName("Text_Amount") as TextField;
         this.mRankSlot = this.mFriendCard.getChildByName("Rank_Container") as MovieClip;
         this.mPhoto = this.mFriendCard.getChildByName("Icon") as MovieClip;
         this.mLists = new Array();
         var _loc3_:int = 0;
         while(this.mBaseVisitPanel.getChildByName("Visit_Wishlist_x" + _loc3_))
         {
            this.mLists.push(this.mBaseVisitPanel.getChildByName("Visit_Wishlist_x" + _loc3_) as MovieClip);
            if((_loc4_ = this.mLists[_loc3_] as MovieClip).parent)
            {
               _loc4_.parent.removeChild(_loc4_);
            }
            _loc3_++;
         }
      }
      
      public function refresh() : void
      {
         if(this.mFriend)
         {
            this.setFriend(this.mFriend,true);
         }
      }
      
      private function open() : void
      {
         var _loc1_:int = 0;
         if(this.mState == this.STATE_OPEN)
         {
            return;
         }
         if(this.mState == this.STATE_CLOSED && this.mCurrentVisitPanel.currentFrame > 1)
         {
            _loc1_ = Math.min(this.mCurrentVisitPanel.totalFrames - this.mCurrentVisitPanel.currentFrame,this.mNormalFrame - 1);
            this.mCurrentVisitPanel.gotoAndPlay(_loc1_);
         }
         else
         {
            this.mCurrentVisitPanel.gotoAndPlay("Open");
         }
         this.mCurrentVisitPanel.addEventListener(Event.FRAME_CONSTRUCTED,this.enterFrame);
         this.mState = this.STATE_OPEN;
      }
      
      private function close() : void
      {
         var _loc1_:int = 0;
         if(this.mState == this.STATE_CLOSED)
         {
            return;
         }
         if(this.mState == this.STATE_OPEN && this.mCurrentVisitPanel.currentFrameLabel != "Normal")
         {
            _loc1_ = Math.max(this.mCurrentVisitPanel.totalFrames - this.mCurrentVisitPanel.currentFrame,this.mNormalFrame + 1);
            this.mCurrentVisitPanel.gotoAndPlay(_loc1_);
         }
         else
         {
            this.mCurrentVisitPanel.gotoAndPlay("Close");
         }
         this.mCurrentVisitPanel.addEventListener(Event.FRAME_CONSTRUCTED,this.enterFrame);
         this.mState = this.STATE_CLOSED;
         this.mSendButtons = null;
      }
      
      private function enterFrame(param1:Event) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:AutoTextField = null;
         var _loc5_:int = 0;
         var _loc6_:ArmyButton = null;
         var _loc7_:MovieClip = null;
         var _loc8_:Item = null;
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_ != this.mCurrentVisitPanel || this.mState == this.STATE_CLOSED && _loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.removeEventListener(Event.FRAME_CONSTRUCTED,this.enterFrame);
            _loc2_.gotoAndStop(1);
         }
         else if(this.mState == this.STATE_OPEN && _loc2_.currentFrameLabel == "Normal")
         {
            _loc2_.removeEventListener(Event.FRAME_CONSTRUCTED,this.enterFrame);
            _loc2_.stop();
            this.mSendButtons = new Array();
            if(this.mCurrentWishlistLength > 0)
            {
               _loc3_ = _loc2_.getChildByName("Buttons_Wishlist_x" + this.mCurrentWishlistLength) as MovieClip;
               (_loc4_ = new AutoTextField(_loc2_.getChildByName("Text_Wishlist") as TextField)).setText(GameState.getText("MENU_HEADER_WISHLIST"));
               LocalizationUtils.replaceFont(_loc4_.getTextField());
               _loc5_ = 0;
               while(_loc5_ < this.mCurrentWishlistLength)
               {
                  _loc7_ = (_loc6_ = Utils.createBasicButton(_loc3_,"Button_Item_0" + (_loc5_ + 1),this.buttonSendPressed)).getMovieClip().getChildByName("Icon_Item") as MovieClip;
                  this.mIconWidth = _loc7_.width;
                  this.mIconHeight = _loc7_.height;
                  _loc8_ = this.mFriend.getWishlist().mItems[_loc5_];
                  IconLoader.addIcon(_loc7_,_loc8_,this.iconLoaded);
                  if(this.mFriend.mIsPlayer)
                  {
                     _loc6_.setEnabled(false);
                  }
                  else
                  {
                     _loc6_.setEnabled(GameState.mInstance.mPlayerProfile.mInventory.getNumberOfItems(_loc8_) > 0);
                  }
                  this.mSendButtons.push(_loc6_);
                  _loc5_++;
               }
            }
         }
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,this.mIconWidth,this.mIconHeight);
      }
      
      private function mouseUp(param1:MouseEvent) : void
      {
         if(MissionManager.modalMissionActive() || !MissionManager.isTutorialCompleted())
         {
            return;
         }
         if(this.mFriend != null)
         {
            if(this.mFriend.mIsPlayer)
            {
               GameState.mInstance.executeReturnHome();
            }
            else
            {
               GameState.mInstance.executeVisitFriend(this.mFriend);
            }
         }
      }
      
      private function mouseRollOut(param1:MouseEvent) : void
      {
         if(MissionManager.modalMissionActive() || !MissionManager.isTutorialCompleted())
         {
            return;
         }
         this.close();
      }
      
      private function mouseRollOver(param1:MouseEvent) : void
      {
         if(MissionManager.modalMissionActive() || !MissionManager.isTutorialCompleted())
         {
            return;
         }
         this.open();
      }
      
      public function getFriend() : Friend
      {
         return this.mFriend;
      }
      
      public function rankLoaded(param1:Sprite) : void
      {
         param1.scaleX = this.RANK_ICON_SIZE / param1.height;
         param1.scaleY = param1.scaleX;
      }
      
      public function setFriend(param1:Friend, param2:Boolean = false) : void
      {
         this.mFriend = param1;
         this.mName = this.mFriendCard.getChildByName("Text_Title") as TextField;
         this.mName.setTextFormat(this.mNameTextFieldFormat);
         this.mName.width = this.mNameTextFieldWidth;
         this.mName.x = this.mNameTextFieldX;
         this.mFlareIcon.visible = param1.mHasFlares;
         Utils.setText(this.mName,param1.getFirstName());
         Utils.lowerFontToMatchTextField(this.mName);
         this.mXPLevelText.setText("" + param1.mLevel);
         this.mSocialXPLevelText.text = "" + param1.mSocialLevel;
         this.mXPLevelIcon.visible = !GameState.mInstance.visitingFriend();
         this.mSocialXPLevelIcon.visible = GameState.mInstance.visitingFriend();
         IconLoader.addIcon(this.mRankSlot,RankManager.getAdapterByIndex(param1.getRank()),this.rankLoaded);
         var _loc3_:int = int(param1.getWishlist().mItems.length);
         if(this.mCurrentVisitPanel == null || this.mCurrentWishlistLength != _loc3_ || param2)
         {
            if(this.mCurrentVisitPanel)
            {
               if(this.mCurrentVisitPanel.parent)
               {
                  this.mCurrentVisitPanel.parent.removeChild(this.mCurrentVisitPanel);
               }
            }
            this.mCurrentWishlistLength = _loc3_;
            this.mCurrentVisitPanel = this.mLists[this.mCurrentWishlistLength];
            this.mCurrentVisitPanel.gotoAndStop("Normal");
            this.mNormalFrame = this.mCurrentVisitPanel.currentFrame;
            this.mCurrentVisitPanel.gotoAndStop(1);
            this.mSlotVisit = this.mCurrentVisitPanel.getChildByName("Slot_Visit") as MovieClip;
            this.mButtonVisit = Utils.createBasicButton(this.mSlotVisit,"Button_Visit",this.mouseUp);
            this.mSendEnergyButton = Utils.createBasicButton(this.mSlotVisit,"Button_Send_Energy",this.buttonGiftEnergyPressed);
            this.mSendSuppliesButton = Utils.createBasicButton(this.mSlotVisit,"Button_Send_Supplies",this.buttonGiftSupplyPressed);
            this.mPvpAttackButton = Utils.createBasicButton(this.mSlotVisit,"Button_Attack",this.buttonPvpAttackPressed);
            if(!this.mCurrentVisitPanel.parent)
            {
               this.mBaseVisitPanel.addChild(this.mCurrentVisitPanel);
            }
            this.mCurrentVisitPanel.mouseEnabled = true;
            this.mBaseVisitPanel.mouseChildren = true;
            this.mBaseVisitPanel.visible = true;
            this.mBasePanel.visible = true;
         }
         this.mSendEnergyButton.setEnabled(this.frictionlessEnergyAllowed());
         this.mSendSuppliesButton.setEnabled(this.frictionlessSuppliesAllowed());
         this.mPvpAttackButton.setEnabled(!param1.mIsPlayer);
         this.mButtonVisit.setText(GameState.getText(param1.mIsPlayer ? "BUTTON_RETURN" : "BUTTON_VISIT"),"Text_Title");
         if(param1.mIsPlayer)
         {
            this.mButtonVisit.setEnabled(GameState.mInstance.visitingFriend());
         }
         else if(param1 == GameState.mInstance.mVisitingFriend)
         {
            this.mButtonVisit.setEnabled(false);
         }
         else
         {
            this.mButtonVisit.setEnabled(true);
         }
         if(param1.mPicID != null && param1.mPicID != "")
         {
            IconLoader.addIconPicture(this.mPhoto,param1.mPicID,this.centerImage);
         }
         else
         {
            Utils.removeAllChildren(this.mPhoto);
         }
      }
      
      private function frictionlessEnergyAllowed() : Boolean
      {
         var _loc1_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         return _loc1_.canGiftEnergyTo(this.mFriend.mFacebookID) && !this.mFriend.mIsPlayer && !this.mFriend.mIsTutor;
      }
      
      private function frictionlessSuppliesAllowed() : Boolean
      {
         var _loc1_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         return _loc1_.canGiftSuppliesTo(this.mFriend.mFacebookID) && !this.mFriend.mIsPlayer && !this.mFriend.mIsTutor;
      }
      
      public function centerImage(param1:MovieClip) : void
      {
         param1.x = -param1.width / 2;
         param1.y = -param1.height / 2;
         param1.mouseEnabled = false;
         param1.mouseChildren = false;
      }
      
      public function getPanel() : MovieClip
      {
         return this.mBasePanel;
      }
      
      private function buttonGiftSupplyPressed(param1:MouseEvent) : void
      {
         if(this.mFriend)
         {
            GameState.mInstance.externalCallSendFrictionless(this.mFriend,FRICTIONLESS_GIFT_SUPPLIES);
         }
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      private function buttonGiftEnergyPressed(param1:MouseEvent) : void
      {
         if(this.mFriend)
         {
            GameState.mInstance.externalCallSendFrictionless(this.mFriend,FRICTIONLESS_GIFT_ENERGY);
         }
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      private function buttonPvpAttackPressed(param1:MouseEvent) : void
      {
         if(this.mFriend)
         {
            GameState.mInstance.mPvPMatch.mOpponent = this.mFriend;
            GameState.mInstance.openPvPMatchUpDialog();
         }
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      private function buttonSendPressed(param1:MouseEvent) : void
      {
         var _loc2_:ArmyButton = null;
         var _loc3_:int = 0;
         for each(_loc2_ in this.mSendButtons)
         {
            if(_loc2_.getMovieClip() == param1.target)
            {
               _loc3_ = this.mSendButtons.indexOf(_loc2_);
               GameState.mInstance.externalCallSendWishlistItem(this.mFriend,this.mFriend.getWishlist().mItems[_loc3_]);
            }
         }
         if(this.mCurrentVisitPanel)
         {
            this.mCurrentVisitPanel.removeEventListener(Event.FRAME_CONSTRUCTED,this.enterFrame);
            this.mCurrentVisitPanel.gotoAndStop(1);
            this.close();
         }
      }
   }
}
