package game.gui
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.button.ResizingButtonSelected;
   import game.gui.popups.PopUpWindow;
   import game.items.*;
   import game.magicBox.MagicBoxTracker;
   import game.missions.MissionManager;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.player.Inventory;
   import game.states.GameState;
   
   public class ShopDialog extends PopUpWindow
   {
      
      public static const TAB_BUTTON_SPACING:int = 3;
      
      public static const TAB_BUTTON_AREA_W:int = 1030;
      
      public static const TAB_SUPPLIES:String = "Supplies";
      
      public static const TAB_AREAS:String = "Areas";
      
      public static const TAB_UNITS:String = "Units";
      
      public static const TAB_BUILDINGS:String = "Buildings";
      
      public static const TAB_PACKS:String = "Packs";
      
      public static const TAB_DECOS:String = "Decos";
      
      public static const TAB_SPECIALS:String = "Specials";
      
      public static const TAB_STORAGE:String = "Storage";
      
      public static const TAB_BUYGOLD:String = "Buygold";
      
      public static const TAB_BUYCASH:String = "Buycash";
      
      public static const TAB_BOOSTERS:String = "Boosters";
      
      private static const PANEL_COUNT:int = 8;
      
      private static const TAB_COUNT:int = 10;
      
      public static var mTutorialItem:Item;
       
      
      protected var mPlayer:GamePlayerProfile;
      
      protected var mGame:GameState;
      
      private var mButtonClose:DCButton;
      
      private var mButtonPrevious:DCButton;
      
      private var mButtonNext:DCButton;
      
      private var mPanels:Array;
      
      private var mAllItems:Object;
      
      private var mItemsForSell:Array;
      
      private var mHeader:StylizedHeaderClip;
      
      private var mProfileGold:AutoTextField;
      
      private var mProfileCash:AutoTextField;
      
      private var mShopType:String;
      
      private var mPage:int = 0;
      
      private var mPageMax:int = 0;
      
      private var mTabObjects:Array;
      
      private var mTabButtons:Array;
      
      private var mTabButtonsByName:Array;
      
      private var mTutorialArrow:MovieClip;
      
      private var mIndicatorArrow:MovieClip;
      
      public function ShopDialog()
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         this.mPanels = new Array();
         this.mItemsForSell = new Array();
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_FULLSCREEN_NAME,"New_shop_ipad");
         super(new _loc1_(),true,false);
         this.mGame = GameState.mInstance;
         this.mPlayer = this.mGame.mPlayerProfile;
         this.mHeader = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip);
         this.mHeader.setText(GameState.getText("SHOP_HEADER"));
         this.mProfileGold = new AutoTextField(mClip.getChildByName("Gold_text") as TextField);
         this.mProfileCash = new AutoTextField(mClip.getChildByName("cash_text") as TextField);
         this.mButtonClose = Utils.createBasicButton(mClip,"Button_Cancel",this.closedPressed);
         this.mButtonPrevious = Utils.createBasicButton(mClip,"left_arrow",this.previousPressed);
         this.mButtonNext = Utils.createBasicButton(mClip,"right_arrow",this.nextPressed);
         this.mTabObjects = new Array();
         var _loc2_:int = 1;
         if(GameState.mConfig.ShopSpecial != null)
         {
            this.mTabObjects[0] = GameState.mConfig.ShopTab[TAB_SPECIALS];
            _loc2_ = 0;
         }
         for each(_loc3_ in GameState.mConfig.ShopTab)
         {
            if(_loc3_.ID != TAB_SPECIALS)
            {
               this.mTabObjects[_loc3_.Order - _loc2_] = _loc3_;
            }
         }
         _loc4_ = 0;
         while(_loc4_ < PANEL_COUNT)
         {
            _loc5_ = MovieClip(mClip.getChildByName("icon_shop_item_" + (_loc4_ + 1)));
            this.mPanels[_loc4_] = new ShopItemPanel(_loc5_,this);
            _loc4_++;
         }
      }
      
      public function Activate(param1:Function, param2:String, param3:String) : void
      {
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:String = null;
         mDoneCallback = param1;
         this.mShopType = param3;
         this.mProfileGold.setText(this.mPlayer.mPremium.toString());
         this.mProfileCash.setText(this.mPlayer.mMoney.toString());
         var _loc4_:int = 0;
         while(_loc4_ < this.mTabObjects.length)
         {
            if((this.mTabObjects[_loc4_] as Object).TabType is Array)
            {
               _loc6_ = false;
               for each(_loc7_ in (this.mTabObjects[_loc4_] as Object).TabType)
               {
                  if(_loc7_ == this.mShopType)
                  {
                     _loc6_ = true;
                     break;
                  }
               }
               if(!_loc6_)
               {
                  this.mTabObjects.splice(_loc4_,1);
                  _loc4_--;
               }
            }
            else if((this.mTabObjects[_loc4_] as Object).TabType != this.mShopType)
            {
               this.mTabObjects.splice(_loc4_,1);
               _loc4_--;
            }
            _loc4_++;
         }
         this.activateShopTabButtons();
         if(!this.mAllItems)
         {
            this.updateItems();
         }
         for(_loc5_ in this.mTabButtonsByName)
         {
            if(_loc5_ != TAB_DECOS)
            {
               (this.mTabButtonsByName[_loc5_] as ResizingButtonSelected).setEnabled(!mTutorialItem);
            }
         }
         if(mTutorialItem)
         {
            this.setTab(TAB_DECOS);
            this.setTutorialArrow();
         }
         else if(param2)
         {
            this.setTab(param2);
         }
         else if(this.mTabButtonsByName[GameState.mInstance.getHud().getLastTab()])
         {
            this.setTab(GameState.mInstance.getHud().getLastTab());
         }
         else
         {
            for(_loc8_ in this.mTabButtonsByName)
            {
               if((this.mTabButtonsByName[_loc8_] as ResizingButtonSelected).isEnable())
               {
                  this.setTab(_loc8_);
                  break;
               }
            }
         }
         doOpeningTransition();
      }
      
      public function activateShopTabButtons() : void
      {
         var _loc3_:ResizingButtonSelected = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ResizingButtonSelected = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:ResizingButtonSelected = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         this.mTabButtonsByName = new Array();
         this.mTabButtons = new Array();
         var _loc1_:int = 1;
         while(_loc1_ <= TAB_COUNT)
         {
            _loc3_ = Utils.createResizingButtonSelected(mClip,"Button_Tab_" + _loc1_,this.tabButtonPressed);
            _loc3_.resizeNeeded = false;
            if(!_loc3_)
            {
               break;
            }
            if(_loc1_ <= this.mTabObjects.length)
            {
               _loc3_.setText((this.mTabObjects[_loc1_ - 1] as Object).Name);
               _loc3_.setPool(this.mTabButtons);
               _loc3_.setAllowDeselection(false);
               this.mTabButtonsByName[(this.mTabObjects[_loc1_ - 1] as Object).ID] = _loc3_;
            }
            else
            {
               _loc3_.setVisible(false);
            }
            _loc1_++;
         }
         var _loc2_:Boolean = true;
         while(_loc2_)
         {
            _loc4_ = 0;
            _loc5_ = 0;
            _loc7_ = int(this.mTabButtons.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc6_ = this.mTabButtons[_loc8_] as ResizingButtonSelected;
               _loc5_ += _loc6_.getWidth() + TAB_BUTTON_SPACING;
               if(_loc6_.mTextSize > _loc4_)
               {
                  _loc4_ = _loc6_.mTextSize;
               }
               _loc8_++;
            }
            if(_loc5_ > TAB_BUTTON_AREA_W && _loc4_ > 1)
            {
               _loc10_ = int(this.mTabButtons.length);
               _loc11_ = 0;
               while(_loc11_ < _loc10_)
               {
                  (_loc9_ = this.mTabButtons[_loc11_] as ResizingButtonSelected).setTextSize(_loc4_ - 1);
                  _loc11_++;
               }
            }
            else
            {
               _loc2_ = false;
            }
         }
      }
      
      public function updateItems() : void
      {
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc1_:Object = GameState.mConfig;
         var _loc2_:Object = _loc1_.ShopTab;
         var _loc3_:Array = new Array();
         this.mAllItems = new Object();
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = new Array();
            _loc6_ = _loc1_[_loc4_.ItemTable];
            for each(_loc7_ in _loc6_)
            {
               _loc5_[_loc7_.ID] = ItemManager.getItem(_loc7_.Item.ID,_loc7_.Item.Type);
               if(_loc4_.ID == TAB_SPECIALS)
               {
                  _loc3_.push(_loc5_[_loc7_.ID]);
               }
            }
            this.mAllItems[_loc4_.ID] = _loc5_;
         }
         this.mAllItems[TAB_SPECIALS] = _loc3_;
      }
      
      private function setTab(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Inventory = null;
         var _loc4_:int = 0;
         if(this.mTabButtonsByName[param1])
         {
            (this.mTabButtonsByName[param1] as ResizingButtonSelected).select();
         }
         if(param1 == TAB_AREAS || !this.mAllItems[param1] || (this.mAllItems[param1] as Array).length <= 0)
         {
            (this.mTabButtonsByName[TAB_AREAS] as ResizingButtonSelected).select();
            this.mItemsForSell = new Array();
            _loc2_ = this.mAllItems[TAB_AREAS] as Array;
            _loc3_ = this.mPlayer.mInventory;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(_loc3_.getNumberOfItems(_loc2_[_loc4_]) == 0 && this.mGame.mScene.isAreaReachable(_loc2_[_loc4_]))
               {
                  this.mItemsForSell.push(_loc2_[_loc4_]);
               }
               _loc4_++;
            }
         }
         else
         {
            this.mItemsForSell = this.mAllItems[param1];
         }
         GameState.mInstance.getHud().setLastTab(param1);
         this.refresh();
      }
      
      public function disableSpecialsButton() : void
      {
         if(this.mTabButtonsByName[TAB_SPECIALS])
         {
            (this.mTabButtonsByName[TAB_SPECIALS] as ResizingButtonSelected).setEnabled(false);
         }
      }
      
      public function setScreen() : void
      {
         var _loc3_:ShopItemPanel = null;
         var _loc4_:int = 0;
         var _loc1_:int = this.mPage * PANEL_COUNT;
         var _loc2_:int = 0;
         while(_loc2_ < PANEL_COUNT)
         {
            _loc3_ = ShopItemPanel(this.mPanels[_loc2_]);
            if((_loc4_ = _loc2_ + _loc1_) < this.mItemsForSell.length)
            {
               _loc3_.show();
               _loc3_.setData(this.mItemsForSell[_loc4_]);
            }
            else
            {
               _loc3_.hide();
            }
            _loc2_++;
         }
      }
      
      private function setPageNum() : void
      {
         this.mButtonNext.setEnabled(this.mPage < this.mPageMax - 1);
         this.mButtonPrevious.setEnabled(this.mPage > 0);
      }
      
      public function refresh() : void
      {
         this.mPage = 0;
         this.mPageMax = (this.mItemsForSell.length + PANEL_COUNT - 1) / PANEL_COUNT;
         this.setScreen();
         this.setPageNum();
         if(GameState.mInstance.mIndicatedShopItem != null)
         {
            this.setIndicatorArrow();
         }
         else
         {
            this.removeIndicatorArrow();
         }
      }
      
      private function tabButtonPressed(param1:MouseEvent) : void
      {
         GameState.mInstance.mIndicatedShopItem = null;
         this.removeIndicatorArrow();
         var _loc2_:int = 0;
         while(_loc2_ < this.mTabButtons.length)
         {
            if((this.mTabButtons[_loc2_] as ResizingButtonSelected).getMovieClip() == param1.target)
            {
               this.setTab((this.mTabObjects[_loc2_] as Object).ID);
               return;
            }
            _loc2_++;
         }
      }
      
      private function previousPressed(param1:MouseEvent) : void
      {
         GameState.mInstance.mIndicatedShopItem = null;
         this.removeIndicatorArrow();
         if(mTutorialItem)
         {
            return;
         }
         this.mPage = Math.max(0,this.mPage - 1);
         this.setScreen();
         this.setPageNum();
      }
      
      private function nextPressed(param1:MouseEvent) : void
      {
         if(GameState.mInstance.mIndicatedShopItem != null)
         {
            if((GameState.mInstance.mIndicatedShopItem as ShopItem).mId == "SpecialForces" || (GameState.mInstance.mIndicatedShopItem as ShopItem).mId == "MobileRocketBattery")
            {
               this.mIndicatorArrow.visible = true;
            }
            else
            {
               GameState.mInstance.mIndicatedShopItem = null;
               this.removeIndicatorArrow();
            }
         }
         if(mTutorialItem)
         {
            return;
         }
         this.mPage = Math.min(this.mPageMax - 1,this.mPage + 1);
         this.setScreen();
         this.setPageNum();
      }
      
      private function closedPressed(param1:MouseEvent) : void
      {
         if(mTutorialItem)
         {
            return;
         }
         this.closeDialog();
      }
      
      public function buyItem(param1:ShopItem) : void
      {
         var _loc2_:Object = null;
         if(param1.mType == "BuyGold" || param1.mType == "BuyCash")
         {
            if(Config.DEBUG_MODE)
            {
            }
            if(FeatureTuner.USE_GOOGLE_IN_APP_BILLING)
            {
               this.mGame.mAndroidPaymentManager.startPurchase(param1);
            }
            else
            {
               if(param1.mType == "BuyGold")
               {
                  _loc2_ = {
                     "gold":(param1 as BuyGoldItem).mGoldGain,
                     "ver":1
                  };
                  this.mGame.mPlayerProfile.addPremium((param1 as BuyGoldItem).mGoldGain,null,MagicBoxTracker.paramsObj(),param1);
               }
               else
               {
                  _loc2_ = {
                     "cash":(param1 as BuyCashItem).mCashGain,
                     "ver":1
                  };
                  this.mGame.mPlayerProfile.addMoney((param1 as BuyCashItem).mCashGain,null,MagicBoxTracker.paramsObj(),param1);
               }
               this.mGame.mServer.serverCallServiceWithParameters(ServiceIDs.ADD_GOLD_AND_CASH,_loc2_,false);
            }
            this.closeDialog();
         }
         else
         {
            if((!param1.canAffordItemWithResources() || !param1.capAvailable()) && !Config.EDITING_MODE)
            {
               if(Config.DEBUG_MODE)
               {
               }
               return;
            }
            if(param1 is MapItem)
            {
               if(this.mShopType == "pvp")
               {
                  this.mGame.mPlayerProfile.mInventory.addItems(MapItem(param1),1);
               }
               else
               {
                  this.mGame.addToWorld(MapItem(param1));
               }
               this.closeDialog();
               if(mTutorialItem)
               {
                  MissionManager.increaseCounter("OpenShop",mTutorialItem.mId,1);
                  this.removeTutorialArrow();
               }
            }
            else if(param1.getCostPremium() > 0)
            {
               GameState.mInstance.externalCallBuyItem(param1);
               this.closeDialog();
            }
            else
            {
               this.mGame.executeBuyItem(param1);
               this.closeDialog();
            }
         }
      }
      
      public function closeDialog() : void
      {
         this.removeIndicatorArrow();
         GameState.mInstance.mIndicatedShopItem = null;
         if(mDoneCallback != null)
         {
            mDoneCallback((this as Object).constructor);
         }
      }
      
      private function setTutorialArrow() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc5_:ShopItemPanel = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.mItemsForSell.length)
         {
            if((this.mItemsForSell[_loc3_] as ShopItem).mId == mTutorialItem.mId)
            {
               _loc1_ = (_loc5_ = ShopItemPanel(this.mPanels[_loc3_])).mBasePanel.x;
               _loc2_ = _loc5_.mBasePanel.y - _loc5_.mBasePanel.height / 2;
               break;
            }
            _loc3_++;
         }
         var _loc4_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"grid_highlighted");
         this.mTutorialArrow = new _loc4_();
         this.mTutorialArrow.mouseEnabled = false;
         this.mTutorialArrow.mouseChildren = false;
         this.mTutorialArrow.x = _loc1_;
         this.mTutorialArrow.y = _loc2_;
         addChild(this.mTutorialArrow);
      }
      
      private function removeTutorialArrow() : void
      {
         if(this.mTutorialArrow)
         {
            removeChild(this.mTutorialArrow);
            this.mTutorialArrow = null;
         }
      }
      
      private function setIndicatorArrow() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:ShopItemPanel = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.mItemsForSell.length)
         {
            if((this.mItemsForSell[_loc4_] as ShopItem).mId == GameState.mInstance.mIndicatedShopItem.mId)
            {
               _loc3_ = ShopItemPanel(this.mPanels[_loc4_]);
               if(_loc3_ != null)
               {
                  _loc1_ = _loc3_.mBasePanel.x + _loc3_.mBasePanel.width / 2;
                  _loc2_ = _loc3_.mBasePanel.y;
               }
               break;
            }
            _loc4_++;
         }
         var _loc5_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"T_arrow_LB");
         this.mIndicatorArrow = new _loc5_();
         this.mIndicatorArrow.mouseEnabled = false;
         this.mIndicatorArrow.mouseChildren = false;
         if(_loc3_ == null)
         {
            this.mIndicatorArrow.visible = false;
            if(GameState.mInstance.mIndicatedShopItem.mId == "SpecialForces")
            {
               _loc3_ = ShopItemPanel(this.mPanels[0]);
               _loc1_ = _loc3_.mBasePanel.x + _loc3_.mBasePanel.width / 2;
               _loc2_ = _loc3_.mBasePanel.y;
            }
            if(GameState.mInstance.mIndicatedShopItem.mId == "MobileRocketBattery")
            {
               _loc3_ = ShopItemPanel(this.mPanels[1]);
               _loc1_ = _loc3_.mBasePanel.x + _loc3_.mBasePanel.width / 2;
               _loc2_ = _loc3_.mBasePanel.y;
            }
         }
         this.mIndicatorArrow.x = _loc1_;
         this.mIndicatorArrow.y = _loc2_;
         addChild(this.mIndicatorArrow);
      }
      
      private function removeIndicatorArrow() : void
      {
         if(this.mIndicatorArrow)
         {
            removeChild(this.mIndicatorArrow);
            this.mIndicatorArrow = null;
         }
      }
   }
}
