package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.gui.button.ResizingButtonSelected;
   import game.items.*;
   import game.net.GameFeedPublisher;
   import game.net.ServiceIDs;
   import game.states.GameState;
   
   public class DailyRewardWindow extends PopUpWindow
   {
      
      private static const DAY_COUNT:int = 5;
      
      private static const DAILY_ITEM_CHOICE_COUNT:int = 3;
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonShare1:ResizingButton;
      
      private var mButtonShare2:ResizingButton;
      
      private var mButtonShare3:ResizingButton;
      
      private var mProgressBar:MovieClip;
      
      private var mButtonRewardSelect1:ResizingButtonSelected;
      
      private var mButtonRewardSelect2:ResizingButtonSelected;
      
      private var mButtonRewardSelect3:ResizingButtonSelected;
      
      private var mCompletedTextField:TextField = null;
      
      private var mCurrentDay:int;
      
      private var mCurrentRewards:Array;
      
      private var mFirstFeedOption:Boolean;
      
      public function DailyRewardWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME,"popup_daily_rewards");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mFirstFeedOption = true;
      }
      
      public function Activate(param1:Function, param2:int, param3:Boolean) : void
      {
         var _loc4_:StylizedHeaderClip = null;
         var _loc6_:TextField = null;
         var _loc7_:MovieClip = null;
         this.mCurrentRewards = new Array();
         mDoneCallback = param1;
         this.mCurrentDay = param2;
         _loc4_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("DAILY_REWARD_HEADER"));
         this.activateCurrentDay();
         this.mProgressBar = mClip.getChildByName("Daily_Reward_Progress_Bar") as MovieClip;
         var _loc5_:MovieClip;
         (_loc5_ = this.mProgressBar.getChildByName("Progress") as MovieClip).getChildByName("Fill").addEventListener(Event.ENTER_FRAME,this.fillTheBarGraphic);
         (_loc6_ = this.mProgressBar.getChildByName("Text_Description") as TextField).text = GameState.getText("DAILY_REWARD_DESC_2");
         (_loc6_ = mClip.getChildByName("Text_Title") as TextField).autoSize = TextFieldAutoSize.LEFT;
         _loc6_.wordWrap = false;
         _loc6_.text = GameState.getText("DAILY_REWARD_SELECTION_TITLE");
         (_loc6_ = mClip.getChildByName("Text_Description") as TextField).autoSize = TextFieldAutoSize.LEFT;
         _loc6_.wordWrap = false;
         _loc6_.text = GameState.getText("DAILY_REWARD_SELECTION_DESC");
         this.setDailyItemChoices();
         this.setUpcomingItemChoices();
         (_loc7_ = this.mProgressBar.getChildByName("Completed") as MovieClip).visible = false;
         _loc7_.addEventListener(Event.FRAME_CONSTRUCTED,this.updateCompletedText,false,0,true);
      }
      
      private function activateCurrentDay() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:TextField = null;
         var _loc1_:MovieClip = mClip.getChildByName("Daily_Reward_Tabs") as MovieClip;
         var _loc4_:int = 1;
         while(_loc4_ <= DAY_COUNT)
         {
            _loc2_ = _loc1_.getChildByName("Daily_Reward_Tab_Active_0" + _loc4_) as MovieClip;
            if(_loc4_ == this.mCurrentDay)
            {
               _loc2_.visible = true;
            }
            else
            {
               _loc2_.visible = false;
               _loc2_ = _loc1_.getChildByName("Daily_Reward_Tab_Inactive_0" + _loc4_) as MovieClip;
            }
            _loc3_ = _loc2_.getChildByName("Text_Day") as TextField;
            _loc3_.defaultTextFormat = _loc3_.getTextFormat();
            _loc3_.text = GameState.getText("DAILY_REWARD_DAY") + " " + _loc4_;
            _loc3_.mouseEnabled = false;
            _loc4_++;
         }
      }
      
      private function setDailyItemChoices() : void
      {
         var _loc1_:TextField = null;
         var _loc3_:MovieClip = null;
         var _loc2_:int = 1;
         while(_loc2_ <= DAILY_ITEM_CHOICE_COUNT)
         {
            _loc3_ = mClip.getChildByName("Daily_Reward_Slot_Select_0" + _loc2_) as MovieClip;
            _loc3_.visible = true;
            if(_loc2_ == 1)
            {
               this.mButtonRewardSelect1 = Utils.createResizingButtonSelected(_loc3_,"Button_Select",this.dailyItemSelected);
               this.mButtonRewardSelect1.setText(GameState.getText("BUTTON_SELECT"));
            }
            else if(_loc2_ == 2)
            {
               this.mButtonRewardSelect2 = Utils.createResizingButtonSelected(_loc3_,"Button_Select",this.dailyItemSelected);
               this.mButtonRewardSelect2.setText(GameState.getText("BUTTON_SELECT"));
            }
            else
            {
               this.mButtonRewardSelect3 = Utils.createResizingButtonSelected(_loc3_,"Button_Select",this.dailyItemSelected);
               this.mButtonRewardSelect3.setText(GameState.getText("BUTTON_SELECT"));
            }
            this.mCurrentRewards[_loc2_ - 1] = this.getRewardItem(this.mCurrentDay,_loc2_ - 1);
            this.setSlotRewardInfo(_loc3_,_loc2_ - 1);
            _loc3_ = mClip.getChildByName("Daily_Reward_Slot_Selected_0" + _loc2_) as MovieClip;
            _loc3_.visible = false;
            _loc3_ = mClip.getChildByName("Daily_Reward_Slot_Share_Item_0" + _loc2_) as MovieClip;
            _loc3_.visible = false;
            _loc3_ = mClip.getChildByName("Daily_Reward_Slot_Faded_0" + _loc2_) as MovieClip;
            _loc3_.visible = false;
            _loc2_++;
         }
      }
      
      private function setUpcomingItemChoices() : void
      {
         var _loc1_:TextField = null;
         var _loc3_:Item = null;
         var _loc4_:MovieClip = null;
         var _loc2_:int = 1;
         while(_loc2_ <= DAILY_ITEM_CHOICE_COUNT)
         {
            _loc3_ = this.getRewardItem(this.mCurrentDay + 1,_loc2_ - 1);
            _loc4_ = this.mProgressBar.getChildByName("Item_0" + _loc2_) as MovieClip;
            IconLoader.addIcon(_loc4_,_loc3_,this.iconLoaded);
            _loc2_++;
         }
      }
      
      private function setSlotRewardInfo(param1:MovieClip, param2:int) : void
      {
         var _loc3_:TextField = param1.getChildByName("Text_Title") as TextField;
         _loc3_.autoSize = TextFieldAutoSize.CENTER;
         _loc3_.text = (this.mCurrentRewards[param2] as Item).mName;
         var _loc4_:MovieClip = param1.getChildByName("Icon") as MovieClip;
         IconLoader.addIcon(_loc4_,this.mCurrentRewards[param2] as Item,this.currentDayIconLoaded);
      }
      
      private function dailyItemSelected(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:TextField = null;
         if(param1.target == this.mButtonRewardSelect1.getClip())
         {
            _loc2_ = 1;
         }
         else if(param1.target == this.mButtonRewardSelect2.getClip())
         {
            _loc2_ = 2;
         }
         else
         {
            _loc2_ = 3;
         }
         var _loc3_:int = 1;
         while(_loc3_ <= DAILY_ITEM_CHOICE_COUNT)
         {
            (_loc5_ = mClip.getChildByName("Daily_Reward_Slot_Select_0" + _loc3_) as MovieClip).visible = false;
            if(_loc3_ == _loc2_)
            {
               (_loc5_ = mClip.getChildByName("Daily_Reward_Slot_Selected_0" + _loc3_) as MovieClip).visible = true;
               (_loc6_ = _loc5_.getChildByName("Text_Description") as TextField).autoSize = TextFieldAutoSize.CENTER;
               _loc6_.wordWrap = false;
               _loc6_.text = GameState.getText("DAILY_REWARD_SELECTED");
               this.setSlotRewardInfo(_loc5_,_loc3_ - 1);
               (_loc5_ = mClip.getChildByName("Daily_Reward_Slot_Share_Item_0" + _loc3_) as MovieClip).visible = false;
               (_loc5_ = mClip.getChildByName("Daily_Reward_Slot_Faded_0" + _loc3_) as MovieClip).visible = false;
            }
            else
            {
               (_loc5_ = mClip.getChildByName("Daily_Reward_Slot_Share_Item_0" + _loc3_) as MovieClip).visible = true;
               this.setSlotRewardInfo(_loc5_,_loc3_ - 1);
               if(_loc3_ == 1)
               {
                  this.mButtonShare1 = Utils.createFBIconResizingButton(_loc5_,"Button_Share",this.shareClicked);
                  this.mButtonShare1.setText(GameState.getText("BUTTON_SHARE"));
               }
               else if(_loc3_ == 2)
               {
                  this.mButtonShare2 = Utils.createFBIconResizingButton(_loc5_,"Button_Share",this.shareClicked);
                  this.mButtonShare2.setText(GameState.getText("BUTTON_SHARE"));
               }
               else
               {
                  this.mButtonShare3 = Utils.createFBIconResizingButton(_loc5_,"Button_Share",this.shareClicked);
                  this.mButtonShare3.setText(GameState.getText("BUTTON_SHARE"));
               }
               (_loc5_ = mClip.getChildByName("Daily_Reward_Slot_Selected_0" + _loc3_) as MovieClip).visible = false;
               (_loc5_ = mClip.getChildByName("Daily_Reward_Slot_Faded_0" + _loc3_) as MovieClip).visible = false;
            }
            _loc3_++;
         }
         var _loc4_:Object = {"reward_item":_loc2_};
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.CLAIM_DAILY_REWARD,_loc4_,false);
         GameState.mInstance.mPlayerProfile.mInventory.addItems(this.mCurrentRewards[_loc2_ - 1],1);
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      private function getRewardItem(param1:int, param2:int) : Item
      {
         if(param1 > DAY_COUNT)
         {
            param1 = 1;
         }
         var _loc3_:Object = GameState.mConfig.DailyReward["Day" + param1];
         if(param2 == 0)
         {
            return ItemManager.getItem(_loc3_.Item1.Item.ID,_loc3_.Item1.Item.Type);
         }
         if(param2 == 1)
         {
            return ItemManager.getItem(_loc3_.Item2.Item.ID,_loc3_.Item2.Item.Type);
         }
         return ItemManager.getItem(_loc3_.Item3.Item.ID,_loc3_.Item3.Item.Type);
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
      
      private function shareClicked(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         if(Boolean(this.mButtonShare1) && param1.target == this.mButtonShare1.getClip())
         {
            this.mButtonShare1.getClip().parent.removeChild(this.mButtonShare1.getClip());
            _loc2_ = mClip.getChildByName("Daily_Reward_Slot_Share_Item_01") as MovieClip;
            _loc2_.visible = false;
            _loc2_ = mClip.getChildByName("Daily_Reward_Slot_Faded_01") as MovieClip;
            _loc2_.visible = true;
            this.setSlotRewardInfo(_loc2_,0);
            _loc3_ = 1;
         }
         else if(Boolean(this.mButtonShare2) && param1.target == this.mButtonShare2.getClip())
         {
            this.mButtonShare2.getClip().parent.removeChild(this.mButtonShare2.getClip());
            _loc2_ = mClip.getChildByName("Daily_Reward_Slot_Share_Item_02") as MovieClip;
            _loc2_.visible = false;
            _loc2_ = mClip.getChildByName("Daily_Reward_Slot_Faded_02") as MovieClip;
            _loc2_.visible = true;
            this.setSlotRewardInfo(_loc2_,1);
            _loc3_ = 2;
         }
         else if(Boolean(this.mButtonShare3) && param1.target == this.mButtonShare3.getClip())
         {
            this.mButtonShare3.getClip().parent.removeChild(this.mButtonShare3.getClip());
            _loc2_ = mClip.getChildByName("Daily_Reward_Slot_Share_Item_03") as MovieClip;
            _loc2_.visible = false;
            _loc2_ = mClip.getChildByName("Daily_Reward_Slot_Faded_03") as MovieClip;
            _loc2_.visible = true;
            this.setSlotRewardInfo(_loc2_,2);
            _loc3_ = 3;
         }
         var _loc4_:String = "Day" + this.mCurrentDay + "Gift" + _loc3_;
         if(this.mFirstFeedOption)
         {
            GameFeedPublisher.publishMessage(_loc4_,null,null,null);
            this.mFirstFeedOption = false;
         }
         else
         {
            GameFeedPublisher.publishMessage(_loc4_,null,null,this.closeDialog);
         }
      }
      
      protected function closeDialog(param1:Boolean = true) : void
      {
         if(param1)
         {
            mDoneCallback((this as Object).constructor);
         }
      }
      
      public function currentDayIconLoaded(param1:Sprite) : void
      {
         this.iconLoaded(param1,120,120);
      }
      
      public function iconLoaded(param1:Sprite, param2:int = 70, param3:int = 60) : void
      {
         Utils.scaleIcon(param1,param2,param3);
      }
      
      private function fillTheBarGraphic(param1:Event) : void
      {
         var _loc6_:MovieClip = null;
         var _loc2_:MovieClip = param1.target as MovieClip;
         var _loc3_:int = _loc2_.totalFrames * (this.mCurrentDay - 1) / DAY_COUNT;
         var _loc4_:int = _loc2_.totalFrames * this.mCurrentDay / DAY_COUNT;
         var _loc5_:int = _loc2_.currentFrame / _loc2_.totalFrames * 100;
         if(_loc2_.currentFrame < _loc3_)
         {
            _loc2_.gotoAndPlay(_loc3_);
         }
         else if(_loc2_.currentFrame >= _loc4_)
         {
            if(this.mCurrentDay == DAY_COUNT)
            {
               _loc2_.gotoAndStop(_loc2_.totalFrames);
            }
            else
            {
               _loc2_.stop();
            }
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.fillTheBarGraphic);
            if((_loc5_ = this.mCurrentDay * 100 / DAY_COUNT) == 100)
            {
               (_loc6_ = this.mProgressBar.getChildByName("Completed") as MovieClip).visible = true;
               _loc6_.addEventListener(Event.ENTER_FRAME,this.fadeIn);
               _loc6_.alpha = 0;
               (this.mProgressBar.getChildByName("Text_Amount") as TextField).visible = false;
            }
         }
         (this.mProgressBar.getChildByName("Text_Amount") as TextField).text = _loc5_ + "%";
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
            if(_loc3_ != this.mCompletedTextField)
            {
               this.mCompletedTextField = _loc3_;
               _loc3_.defaultTextFormat = _loc3_.getTextFormat();
               _loc3_.text = GameState.getText("CAMPAIGN_WINDOW_COMPLETED");
               LocalizationUtils.replaceFont(_loc3_);
            }
         }
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
      
      private function playOnce(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            _loc2_.stop();
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.playOnce);
         }
      }
   }
}
