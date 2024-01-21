package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import game.gui.AutoTextField;
   import game.gui.IconLoader;
   import game.gui.ShopDialog;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.gui.button.ResizingIconButton;
   import game.items.ItemManager;
   import game.missions.Mission;
   import game.missions.Objective;
   import game.states.GameState;
   
   public class MissionProgressWindow extends PopUpWindow
   {
      
      private static const MAX_OBJECTIVES:int = 3;
       
      
      private var mBuyObjectiveButtons:Array;
      
      private var mShopButtons:Array;
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonOK:ResizingButton;
      
      private var mObjectivesCount:int;
      
      private var mPanel:MovieClip;
      
      private var mMission:Mission;
      
      private var mPanelClips:Array;
      
      public function MissionProgressWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_01_NAME,"popup_mission");
         super(new _loc1_(),true);
      }
      
      public function Activate(param1:Function, param2:Mission) : void
      {
         var _loc4_:StylizedHeaderClip = null;
         var _loc5_:AutoTextField = null;
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         if(!this.mPanelClips)
         {
            this.mPanelClips = new Array();
            _loc6_ = 1;
            while(_loc6_ <= MAX_OBJECTIVES)
            {
               this.mPanelClips[_loc6_] = mClip.getChildByName("Popup_Regular_Mission_" + _loc6_) as MovieClip;
               _loc6_++;
            }
         }
         mDoneCallback = param1;
         this.mMission = param2;
         this.mObjectivesCount = param2.getNumObjectives();
         var _loc3_:int = 1;
         while(_loc3_ <= MAX_OBJECTIVES)
         {
            _loc7_ = this.mPanelClips[_loc3_];
            if(_loc3_ != this.mObjectivesCount)
            {
               if(_loc7_.parent)
               {
                  _loc7_.parent.removeChild(_loc7_);
               }
            }
            else
            {
               if(!_loc7_.parent)
               {
                  mClip.addChild(_loc7_);
               }
               this.mPanel = _loc7_;
            }
            _loc3_++;
         }
         this.mButtonCancel = Utils.createBasicButton(this.mPanel,"Button_Cancel",this.closeClicked);
         this.mButtonOK = Utils.createResizingButton(this.mPanel,"Button_Skip",this.closeClicked);
         this.mButtonOK.setText(GameState.getText("BUTTON_CONTINUE"));
         _loc4_ = new StylizedHeaderClip(this.mPanel.getChildByName("Header") as MovieClip,GameState.getText("MISSION_TITLE"));
         (_loc5_ = new AutoTextField(this.mPanel.getChildByName("Text_Title") as TextField)).setText(param2.mTitle);
         (_loc5_ = new AutoTextField(this.mPanel.getChildByName("Text_Description") as TextField)).setText(param2.mDescription);
         this.updateObjectives();
         doOpeningTransition();
      }
      
      public function updateObjectives() : void
      {
         var _loc1_:AutoTextField = null;
         var _loc3_:Objective = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:ResizingIconButton = null;
         var _loc8_:ResizingIconButton = null;
         this.mBuyObjectiveButtons = new Array();
         this.mShopButtons = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.mObjectivesCount)
         {
            _loc3_ = this.mMission.getObjectiveByIndex(_loc2_);
            if(_loc3_.isDone())
            {
               (_loc4_ = this.mPanel.getChildByName("Frame_Task_" + (_loc2_ + 1)) as MovieClip).visible = false;
               (_loc4_ = this.mPanel.getChildByName("Frame_Task_Complete_" + (_loc2_ + 1)) as MovieClip).visible = true;
               _loc1_ = new AutoTextField(_loc4_.getChildByName("Text_Amount") as TextField);
               _loc1_.setText(GameState.getText("MISSION_COMPLETED"));
               this.mBuyObjectiveButtons.push(null);
               this.mShopButtons.push(null);
            }
            else
            {
               (_loc4_ = this.mPanel.getChildByName("Frame_Task_Complete_" + (_loc2_ + 1)) as MovieClip).visible = false;
               (_loc4_ = this.mPanel.getChildByName("Frame_Task_" + (_loc2_ + 1)) as MovieClip).visible = true;
               this.mBuyObjectiveButtons.push(Utils.createResizingIconButton(_loc4_,"Button_Submit",this.buyObjectiveButtonPressed));
               this.mShopButtons.push(Utils.createResizingIconButton(_loc4_,"Button_Shop",this.shopObjectiveButtonPressed));
               _loc6_ = _loc4_.width / 2;
               _loc7_ = this.mShopButtons[_loc2_];
               _loc8_ = this.mBuyObjectiveButtons[_loc2_];
               if(_loc3_.mType == "Buy" && !GameState.mInstance.visitingFriend())
               {
                  (this.mShopButtons[_loc2_] as ResizingIconButton).setText(GameState.getText("BUTTON_TO_SHOP"));
                  _loc7_.getMovieClip().visible = true;
                  _loc7_.getMovieClip().x = _loc6_ - _loc7_.getWidth() / 2;
               }
               else
               {
                  _loc7_.getMovieClip().visible = false;
               }
               if(_loc3_.mCostFinish > 0)
               {
                  (this.mBuyObjectiveButtons[_loc2_] as ResizingIconButton).setIcon(ItemManager.getItem("Premium","Resource"));
                  (this.mBuyObjectiveButtons[_loc2_] as ResizingIconButton).setText(GameState.getText("BUTTON_BUY_OBJECTIVE",[_loc3_.mCostFinish]));
                  if(_loc7_.getMovieClip().visible)
                  {
                     _loc8_.getMovieClip().x = _loc7_.getMovieClip().x - _loc7_.getWidth() / 2 - _loc8_.getWidth() / 2;
                  }
                  else
                  {
                     _loc8_.getMovieClip().x = _loc6_ - _loc8_.getWidth() / 2;
                  }
               }
               else
               {
                  _loc8_.getMovieClip().visible = false;
               }
               _loc1_ = new AutoTextField(_loc4_.getChildByName("Text_Amount") as TextField);
               _loc1_.setText(_loc3_.mCounter.toString() + "/" + _loc3_.mGoal);
            }
            if(_loc3_.mTitle)
            {
               _loc1_ = new AutoTextField(_loc4_.getChildByName("Text_Title") as TextField);
               _loc1_.setText(_loc3_.mTitle);
            }
            if(_loc3_.mDescription)
            {
               _loc1_ = new AutoTextField(_loc4_.getChildByName("Text_Description") as TextField);
               _loc1_.setText(_loc3_.mDescription);
            }
            _loc5_ = _loc4_.getChildByName("Icon") as MovieClip;
            IconLoader.addIcon(_loc5_,_loc3_,this.iconLoaded);
            _loc2_++;
         }
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,80,80);
      }
      
      public function getClip() : DisplayObjectContainer
      {
         return mClip;
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
               _loc5_ = this.mMission.getObjectiveByIndex(_loc4_);
               _loc2_.externalCallUnlockObjective(_loc5_);
               break;
            }
         }
         if(this.mMission.allObjectivesDone())
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
               _loc4_ = this.mMission.getObjectiveByIndex(_loc3_);
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
         mDoneCallback((this as Object).constructor);
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
      
      private function closeClicked(param1:Event) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
