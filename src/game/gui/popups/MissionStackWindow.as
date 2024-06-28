package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import game.gui.AutoTextField;
   import game.gui.IconLoader;
   import game.gui.ShopDialog;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.gui.button.ResizingButtonSelected;
   import game.gui.button.ResizingIconButton;
   import game.items.ItemManager;
   import game.missions.Mission;
   import game.missions.MissionManager;
   import game.missions.Objective;
   import game.states.GameState;
   
   public class MissionStackWindow extends PopUpWindow
   {
       
      
      private var mBuyObjectiveButtons:Vector.<ResizingIconButton>;
      
      private var mShopButtons:Vector.<ResizingIconButton>;
      
      private var mClickPrompt:AutoTextField;
      
      private var mPrevText:AutoTextField;
      
      private var mNextText:AutoTextField;
      
      private var mCounterText:TextField;
      
      private var mMissionList:Array;
      
      private var mMissionButtons:Vector.<ResizingButtonSelected>;
      
      private var mCurrentMission:Mission;
      
      private var mObjectivesCount:int;
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonNext:ArmyButton;
      
      private var mButtonPrevious:ArmyButton;
      
      private var mButtonSkip:ResizingButton;
      
      private var mCurrentIndex:int;
      
      private var mMissionTitle:Vector.<AutoTextField>;
      
      private var mMissionDesc:Vector.<AutoTextField>;
      
      private var mMissionAmount:Vector.<AutoTextField>;
      
      private var mMissionCompTitle:Vector.<AutoTextField>;
      
      private var mMissionCompDesc:Vector.<AutoTextField>;
      
      private var mMissionCompAmount:Vector.<AutoTextField>;
      
      private const VISIBLE_MISSIONS:int = 6;
      
      private const MAXIMUM_OBJECTIVES:int = 4;
      
      public function MissionStackWindow()
      {
         var _loc2_:MovieClip = null;
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_01_NAME,"popup_mission_stack");
         super(new _loc1_() as MovieClip,true);
         this.mClickPrompt = new AutoTextField(mClip.getChildByName("Text_Details") as TextField);
         _loc2_ = mClip.getChildByName("Button_Previous") as MovieClip;
         this.mPrevText = new AutoTextField(_loc2_.getChildByName("Text_Title") as TextField);
         _loc2_ = mClip.getChildByName("Button_Next") as MovieClip;
         this.mNextText = new AutoTextField(_loc2_.getChildByName("Text_Title") as TextField);
         this.mCounterText = mClip.getChildByName("Counter_Pages") as TextField;
         this.mClickPrompt.setText(GameState.getText("MENU_MISSIONSTACK_CLICK_TO_OPEN"));
         this.mPrevText.setText(GameState.getText("MENU_MISSIONSTACK_PREVIOUS"));
         this.mNextText.setText(GameState.getText("MENU_MISSIONSTACK_NEXT"));
         this.mButtonNext = Utils.createBasicButton(mClip,"Button_Next",this.nextClicked);
         this.mButtonPrevious = Utils.createBasicButton(mClip,"Button_Previous",this.previousClicked);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonSkip = Utils.createResizingButton(mClip,"Button_Skip",this.closeClicked);
         this.mButtonSkip.setText(GameState.getText("BUTTON_CONTINUE"));
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc2_:StylizedHeaderClip = null;
         var _loc5_:ResizingButtonSelected = null;
         mDoneCallback = param1;
         _loc2_ = new StylizedHeaderClip(mClip.getChildByName("Header_Stack") as MovieClip,GameState.getText("MENU_HEADER_MISSION_BROWSER"));
         this.mMissionButtons = new Vector.<ResizingButtonSelected>();
         var _loc3_:Array = new Array();
         var _loc4_:int = 1;
         while(_loc4_ <= this.VISIBLE_MISSIONS)
         {
            (_loc5_ = Utils.createResizingButtonSelected(mClip,"Mission_Stack_0" + _loc4_,this.missionButtonPressed)).setPool(_loc3_);
            _loc5_.setAllowDeselection(false);
            this.mMissionButtons.push(_loc5_);
            _loc4_++;
         }
         this.refreshMissionList();
         this.setCurrentMission(0);
         this.updateMissionButtons();
      }
      
      public function updateMissionButtons() : void
      {
         var _loc2_:ResizingButtonSelected = null;
         var _loc4_:Mission = null;
         var _loc1_:int = int(this.mMissionList.length);
         if(this.mMissionButtons.length > 0)
         {
            (this.mMissionButtons[0] as ResizingButtonSelected).unselectAllInPool();
         }
         var _loc3_:int = 0;
         while(_loc3_ + this.mCurrentIndex < _loc1_ && _loc3_ < this.VISIBLE_MISSIONS)
         {
            _loc4_ = this.mMissionList[_loc3_ + this.mCurrentIndex];
            _loc2_ = this.mMissionButtons[_loc3_];
            if(this.mMissionList.indexOf(this.mCurrentMission) == _loc3_ + this.mCurrentIndex)
            {
               _loc2_.select();
            }
            _loc2_.setText(GameState.getText("MENU_MISSIONSTACK_MISSION") + " " + (_loc3_ + this.mCurrentIndex + 1));
            _loc3_++;
         }
         while(_loc3_ < this.VISIBLE_MISSIONS)
         {
            _loc2_ = this.mMissionButtons[_loc3_];
            _loc2_.getMovieClip().visible = false;
            _loc3_++;
         }
         this.mCounterText.text = this.mCurrentIndex + 1 + "/" + Math.max(1,this.mMissionList.length - this.VISIBLE_MISSIONS + 1);
      }
      
      public function updateObjectives() : void
      {
         var _loc2_:Objective = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:ResizingIconButton = null;
         var _loc7_:ResizingIconButton = null;
         if(!this.mMissionTitle)
         {
            this.mMissionTitle = new Vector.<AutoTextField>(this.MAXIMUM_OBJECTIVES,true);
            this.mMissionDesc = new Vector.<AutoTextField>(this.MAXIMUM_OBJECTIVES,true);
            this.mMissionAmount = new Vector.<AutoTextField>(this.MAXIMUM_OBJECTIVES,true);
            this.mMissionCompTitle = new Vector.<AutoTextField>(this.MAXIMUM_OBJECTIVES,true);
            this.mMissionCompDesc = new Vector.<AutoTextField>(this.MAXIMUM_OBJECTIVES,true);
            this.mMissionCompAmount = new Vector.<AutoTextField>(this.MAXIMUM_OBJECTIVES,true);
         }
         this.mBuyObjectiveButtons = new Vector.<ResizingIconButton>();
         this.mShopButtons = new Vector.<ResizingIconButton>();
         var _loc1_:int = 0;
         while(_loc1_ < this.MAXIMUM_OBJECTIVES)
         {
            _loc2_ = this.mCurrentMission.getObjectiveByIndex(_loc1_);
            if(_loc1_ >= this.mObjectivesCount || !_loc2_.mTitle || !_loc2_.mDescription)
            {
               _loc3_ = mClip.getChildByName("Frame_Task_" + (_loc1_ + 1)) as MovieClip;
               _loc3_.visible = false;
               _loc3_ = mClip.getChildByName("Frame_Task_Complete_" + (_loc1_ + 1)) as MovieClip;
               _loc3_.visible = false;
            }
            else
            {
               if(_loc2_.isDone())
               {
                  _loc3_ = mClip.getChildByName("Frame_Task_" + (_loc1_ + 1)) as MovieClip;
                  _loc3_.visible = false;
                  _loc3_ = mClip.getChildByName("Frame_Task_Complete_" + (_loc1_ + 1)) as MovieClip;
                  _loc3_.visible = true;
                  this.mBuyObjectiveButtons.push(null);
                  this.mShopButtons.push(null);
                  if(!this.mMissionAmount[_loc1_])
                  {
                     this.mMissionAmount[_loc1_] = new AutoTextField(_loc3_.getChildByName("Text_Amount") as TextField);
                  }
                  (this.mMissionAmount[_loc1_] as AutoTextField).setText(GameState.getText("MISSION_COMPLETED"));
                  if(!this.mMissionTitle[_loc1_])
                  {
                     this.mMissionTitle[_loc1_] = new AutoTextField(_loc3_.getChildByName("Text_Title") as TextField);
                  }
                  (this.mMissionTitle[_loc1_] as AutoTextField).setText(_loc2_.mTitle);
                  if(!this.mMissionDesc[_loc1_])
                  {
                     this.mMissionDesc[_loc1_] = new AutoTextField(_loc3_.getChildByName("Text_Description") as TextField);
                  }
                  (this.mMissionDesc[_loc1_] as AutoTextField).setText(_loc2_.mDescription);
                  if(Config.FOR_IPHONE_PLATFORM)
                  {
                     (this.mMissionDesc[_loc1_] as AutoTextField).setVisible(false);
                  }
               }
               else
               {
                  _loc3_ = mClip.getChildByName("Frame_Task_Complete_" + (_loc1_ + 1)) as MovieClip;
                  _loc3_.visible = false;
                  _loc3_ = mClip.getChildByName("Frame_Task_" + (_loc1_ + 1)) as MovieClip;
                  _loc3_.visible = true;
                  this.mBuyObjectiveButtons.push(Utils.createResizingIconButton(_loc3_,"Button_Submit",this.buyObjectiveButtonPressed));
                  this.mShopButtons.push(Utils.createResizingIconButton(_loc3_,"Button_Shop",this.shopObjectiveButtonPressed));
                  _loc5_ = _loc3_.width / 2;
                  _loc6_ = this.mShopButtons[_loc1_];
                  _loc7_ = this.mBuyObjectiveButtons[_loc1_];
                  if(_loc2_.mType == "Buy" && !GameState.mInstance.visitingFriend())
                  {
                     _loc6_.setText(GameState.getText("BUTTON_TO_SHOP"));
                     _loc6_.getMovieClip().visible = true;
                     _loc6_.getMovieClip().x = _loc5_ - _loc6_.getWidth() / 2;
                  }
                  else
                  {
                     _loc6_.getMovieClip().visible = false;
                  }
                  if(_loc2_.mCostFinish > 0)
                  {
                     _loc7_.setIcon(ItemManager.getItem("Premium","Resource"));
                     _loc7_.setText(GameState.getText("BUTTON_BUY_OBJECTIVE",[_loc2_.mCostFinish]));
                     _loc7_.getMovieClip().visible = true;
                     if(_loc6_.getMovieClip().visible)
                     {
                        _loc7_.getMovieClip().x = _loc6_.getMovieClip().x - _loc6_.getWidth() / 2 - _loc7_.getWidth() / 2;
                     }
                     else
                     {
                        _loc7_.getMovieClip().x = _loc5_ - _loc7_.getWidth() / 2;
                     }
                  }
                  else
                  {
                     _loc7_.getMovieClip().visible = false;
                  }
                  if(!this.mMissionCompAmount[_loc1_])
                  {
                     this.mMissionCompAmount[_loc1_] = new AutoTextField(_loc3_.getChildByName("Text_Amount") as TextField);
                  }
                  (this.mMissionCompAmount[_loc1_] as AutoTextField).setText(_loc2_.mCounter.toString() + "/" + _loc2_.mGoal);
                  if(!this.mMissionCompTitle[_loc1_])
                  {
                     this.mMissionCompTitle[_loc1_] = new AutoTextField(_loc3_.getChildByName("Text_Title") as TextField);
                  }
                  (this.mMissionCompTitle[_loc1_] as AutoTextField).setText(_loc2_.mTitle);
                  if(!this.mMissionCompDesc[_loc1_])
                  {
                     this.mMissionCompDesc[_loc1_] = new AutoTextField(_loc3_.getChildByName("Text_Description") as TextField);
                  }
                  (this.mMissionCompDesc[_loc1_] as AutoTextField).setText(_loc2_.mDescription);
                  if(Config.FOR_IPHONE_PLATFORM)
                  {
                     (this.mMissionCompDesc[_loc1_] as AutoTextField).setVisible(false);
                  }
               }
               _loc4_ = _loc3_.getChildByName("Icon") as MovieClip;
               IconLoader.addIcon(_loc4_,_loc2_,this.iconLoaded);
            }
            _loc1_++;
         }
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,80,80);
      }
      
      private function refreshMissionList() : void
      {
         var _loc2_:Mission = null;
         this.mMissionList = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < MissionManager.getNumMissions())
         {
            _loc2_ = MissionManager.getMissionByIndex(_loc1_);
            if(_loc2_.mState == Mission.STATE_ACTIVE && (_loc2_.mType == Mission.TYPE_TIP || _loc2_.mType == Mission.TYPE_NORMAL || _loc2_.mType == Mission.TYPE_STORY || _loc2_.mType == Mission.TYPE_CAMPAIGN) && !_loc2_.allObjectivesDone() && _loc2_.mMapId == GameState.mInstance.mCurrentMapId)
            {
               this.mMissionList.push(MissionManager.getMissionByIndex(_loc1_));
            }
            _loc1_++;
         }
      }
      
      private function nextClicked(param1:MouseEvent) : void
      {
         if(this.mCurrentIndex < this.mMissionList.length - this.VISIBLE_MISSIONS)
         {
            ++this.mCurrentIndex;
         }
         if(this.mMissionList.indexOf(this.mCurrentMission) < this.mCurrentIndex)
         {
            this.setCurrentMission(0);
         }
         this.updateMissionButtons();
         this.mButtonNext.setEnabled(this.mCurrentIndex < this.mMissionList.length - this.VISIBLE_MISSIONS);
         this.mButtonPrevious.setEnabled(this.mCurrentIndex > 0);
      }
      
      private function previousClicked(param1:MouseEvent) : void
      {
         if(this.mCurrentIndex > 0)
         {
            --this.mCurrentIndex;
         }
         if(this.mMissionList.indexOf(this.mCurrentMission) >= this.mCurrentIndex + this.VISIBLE_MISSIONS)
         {
            this.setCurrentMission(this.VISIBLE_MISSIONS - 1);
         }
         this.updateMissionButtons();
         this.mButtonNext.setEnabled(this.mCurrentIndex < this.mMissionList.length - this.VISIBLE_MISSIONS);
         this.mButtonPrevious.setEnabled(this.mCurrentIndex > 0);
      }
      
      private function setCurrentMission(param1:int) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:TextFormat = null;
         if(param1 == -1 || param1 >= this.mMissionList.length)
         {
            return;
         }
         this.mCurrentMission = this.mMissionList[param1 + this.mCurrentIndex];
         this.mObjectivesCount = this.mCurrentMission.getNumObjectives();
         _loc2_ = mClip.getChildByName("Text_Title") as TextField;
         _loc2_.defaultTextFormat = _loc2_.getTextFormat();
         _loc2_.autoSize = TextFieldAutoSize.CENTER;
         _loc2_.text = this.mCurrentMission.mTitle;
         if(Config.FOR_IPHONE_PLATFORM)
         {
            _loc3_ = _loc2_.getTextFormat();
            _loc3_.size = 22;
            _loc2_.defaultTextFormat = _loc3_;
            _loc2_.setTextFormat(_loc3_);
         }
         _loc2_.mouseEnabled = false;
         _loc2_ = mClip.getChildByName("Text_Description") as TextField;
         _loc2_.defaultTextFormat = _loc2_.getTextFormat();
         _loc2_.text = this.mCurrentMission.mDescription;
         _loc2_.mouseEnabled = false;
         _loc2_.visible = false;
         this.updateObjectives();
         this.mButtonNext.setEnabled(this.mCurrentIndex < this.mMissionList.length - this.VISIBLE_MISSIONS);
         this.mButtonPrevious.setEnabled(this.mCurrentIndex > 0);
      }
      
      private function buyObjectiveButtonPressed(param1:Event) : void
      {
         var _loc3_:ResizingButton = null;
         var _loc4_:int = 0;
         var _loc5_:Objective = null;
         var _loc2_:GameState = GameState.mInstance;
         for each(_loc3_ in this.mBuyObjectiveButtons)
         {
            if(Boolean(_loc3_) && _loc3_.getClip() == param1.target)
            {
               _loc4_ = this.mBuyObjectiveButtons.indexOf(_loc3_);
               _loc5_ = this.mCurrentMission.getObjectiveByIndex(_loc4_);
               _loc2_.externalCallUnlockObjective(_loc5_);
               break;
            }
         }
         if(this.mCurrentMission.allObjectivesDone())
         {
            mDoneCallback((this as Object).constructor);
         }
      }
      
      private function missionButtonPressed(param1:MouseEvent) : void
      {
         var _loc3_:ResizingButtonSelected = null;
         var _loc2_:int = -1;
         for each(_loc3_ in this.mMissionButtons)
         {
            if(_loc3_.getClip() == param1.target)
            {
               _loc2_ = this.mMissionButtons.indexOf(_loc3_);
            }
         }
         this.setCurrentMission(_loc2_);
      }
      
      private function requestClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         if(mDoneCallback != null)
         {
            mDoneCallback((this as Object).constructor);
         }
      }
      
      private function shopObjectiveButtonPressed(param1:Event) : void
      {
         var _loc2_:ResizingButton = null;
         var _loc3_:int = 0;
         var _loc4_:Objective = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         for each(_loc2_ in this.mShopButtons)
         {
            if(Boolean(_loc2_) && _loc2_.getClip() == param1.target)
            {
               _loc3_ = this.mShopButtons.indexOf(_loc2_);
               _loc4_ = this.mCurrentMission.getObjectiveByIndex(_loc3_);
               _loc5_ = null;
               if(_loc4_.mParameter.ID == null)
               {
                  var _loc10_:int = 0;
                  var _loc11_:* = _loc4_.mParameter;
                  for each(_loc6_ in _loc11_)
                  {
                     _loc5_ = _loc6_;
                  }
               }
               else
               {
                  _loc5_ = _loc4_.mParameter;
               }
               if(_loc5_ != null)
               {
                  _loc7_ = null;
                  if(this.isItemInShopTab("ShopSupplies",_loc5_))
                  {
                     _loc7_ = ShopDialog.TAB_SUPPLIES;
                  }
                  else if(this.isItemInShopTab("ShopUnit",_loc5_))
                  {
                     _loc7_ = ShopDialog.TAB_UNITS;
                  }
                  else if(this.isItemInShopTab("ShopBuilding",_loc5_))
                  {
                     _loc7_ = ShopDialog.TAB_BUILDINGS;
                  }
                  else if(this.isItemInShopTab("ShopPacks",_loc5_))
                  {
                     _loc7_ = ShopDialog.TAB_PACKS;
                  }
                  else if(this.isItemInShopTab("ShopArea",_loc5_))
                  {
                     _loc7_ = ShopDialog.TAB_AREAS;
                  }
                  else if(this.isItemInShopTab("ShopDeco",_loc5_))
                  {
                     _loc7_ = ShopDialog.TAB_DECOS;
                  }
                  else if(this.isItemInShopTab("ShopStorage",_loc5_))
                  {
                     _loc7_ = ShopDialog.TAB_STORAGE;
                  }
                  else if(this.isItemInShopTab("ShopSpecials",_loc5_))
                  {
                     _loc7_ = ShopDialog.TAB_SPECIALS;
                  }
                  if(_loc7_ != null)
                  {
                     GameState.mInstance.mIndicatedShopItem = ItemManager.getItem(_loc5_.ID,_loc5_.Type);
                     GameState.mInstance.mHUD.triggerShopOpening(_loc7_);
                  }
               }
               break;
            }
         }
         if(mDoneCallback != null)
         {
            mDoneCallback((this as Object).constructor);
         }
      }
      
      private function isItemInShopTab(param1:String, param2:Object) : Boolean
      {
         var _loc3_:Object = null;
         for each(_loc3_ in GameState.mConfig[param1])
         {
            if(_loc3_.Item.ID == param2.ID && _loc3_.Item.Type == param2.Type)
            {
               return true;
            }
         }
         return false;
      }
   }
}
