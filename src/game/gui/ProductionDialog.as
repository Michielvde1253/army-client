package game.gui
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import game.gameElements.ConstructionObject;
   import game.gameElements.HFEPlotObject;
   import game.gameElements.PlayerBuildingObject;
   import game.gameElements.ResourceBuildingObject;
   import game.gui.button.ResizingButton;
   import game.gui.popups.PopUpWindow;
   import game.isometric.IsometricScene;
   import game.items.BuildingDriveItem;
   import game.items.HFEDriveItem;
   import game.items.HFEItem;
   import game.items.ItemManager;
   import game.items.MapItem;
   import game.items.ShopItem;
   import game.missions.MissionManager;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class ProductionDialog extends PopUpWindow
   {
      
      private static const PANEL_COUNT:int = 3;
      
      private static var mLastProductionShopPage:int = 0;
       
      
      private var mProducer:ConstructionObject;
      
      private var mPlayer:GamePlayerProfile;
      
      private var mBuilding:PlayerBuildingObject;
      
      private var mCraftingOptions:Vector.<HFEItem>;
      
      private var mCraftingOptionsBuildingDrive:Vector.<BuildingDriveItem>;
      
      private var mGame:GameState;
      
      private var mDescriptionText:TextField;
      
      private var mButtonCancel:DCButton;
      
      private var mButtonClose:ResizingButton;
      
      private var mButtonUp:DCButton;
      
      private var mButtonDown:DCButton;
      
      private var mPanels:Vector.<ProductionItemPanel>;
      
      private var mScrollBar:MovieClip;
      
      private var mPage:int = 0;
      
      private var mPageMax:int = 0;
      
      public function ProductionDialog()
      {
         this.mPanels = new Vector.<ProductionItemPanel>();
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_01_NAME,"popup_set_production");
         super(new _loc1_(),true);
         this.mGame = GameState.mInstance;
         this.mPlayer = this.mGame.mPlayerProfile;
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closedPressed);
         this.mButtonClose = Utils.createResizingButton(mClip,"Button_Skip",this.closedPressed);
         this.mButtonClose.setText(GameState.getText("BUTTON_BACK"));
         this.mButtonUp = Utils.createBasicButton(mClip,"Button_Previous",this.upPressed);
         this.mButtonDown = Utils.createBasicButton(mClip,"Button_Next",this.downPressed);
         this.mScrollBar = mClip.getChildByName("Scrollbar") as MovieClip;
         this.mScrollBar.gotoAndStop(1);
         this.mDescriptionText = mClip.getChildByName("Text_Description") as TextField;
         mouseEnabled = true;
      }
      
      public function Activate(param1:PlayerBuildingObject, param2:Function) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc6_:int = 0;
         var _loc7_:BuildingDriveItem = null;
         var _loc8_:int = 0;
         var _loc9_:HFEItem = null;
         var _loc10_:TextFormat = null;
         var _loc11_:MovieClip = null;
         var _loc12_:MovieClip = null;
         mDoneCallback = param2;
         this.mBuilding = param1;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,this.mBuilding.mItem.mName);
         var _loc4_:Array = MapItem(param1.mItem).mCrafting as Array;
         if(this.mBuilding is ResourceBuildingObject)
         {
            this.mCraftingOptionsBuildingDrive = new Vector.<BuildingDriveItem>();
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc7_ = ItemManager.getItem((_loc4_[_loc6_] as Object).ID,(_loc4_[_loc6_] as Object).Type) as BuildingDriveItem;
               this.mCraftingOptionsBuildingDrive.push(_loc7_);
               _loc6_++;
            }
         }
         else
         {
            this.mCraftingOptions = new Vector.<HFEItem>();
            _loc8_ = 0;
            while(_loc8_ < _loc4_.length)
            {
               _loc9_ = ItemManager.getItem((_loc4_[_loc8_] as Object).ID,(_loc4_[_loc8_] as Object).Type) as HFEItem;
               this.mCraftingOptions.push(_loc9_);
               _loc8_++;
            }
         }
         if(this.mBuilding is HFEPlotObject)
         {
            this.mDescriptionText.text = GameState.getText("HFE_PLOT_LONG_DESC");
         }
         else
         {
            this.mDescriptionText.text = param1.mItem.getDescription();
         }
         if(Config.FOR_IPHONE_PLATFORM)
         {
            (_loc10_ = this.mDescriptionText.getTextFormat()).size = 17;
            this.mDescriptionText.defaultTextFormat = _loc10_;
         }
         var _loc5_:int = 0;
         while(_loc5_ < PANEL_COUNT)
         {
            _loc11_ = mClip.getChildByName("Frame_Item_Locked_" + (_loc5_ + 1)) as MovieClip;
            _loc12_ = mClip.getChildByName("Frame_Item_" + (_loc5_ + 1)) as MovieClip;
            this.mPanels[_loc5_] = new ProductionItemPanel(_loc12_,_loc11_,mClip,this);
            _loc5_++;
         }
         this.refresh();
         doOpeningTransition();
      }
      
      public function setScreen() : void
      {
         var _loc3_:ProductionItemPanel = null;
         var _loc4_:int = 0;
         var _loc1_:int = this.mPage * PANEL_COUNT;
         var _loc2_:int = 0;
         while(_loc2_ < PANEL_COUNT)
         {
            _loc3_ = this.mPanels[_loc2_];
            _loc4_ = _loc2_ + _loc1_;
            if(this.mCraftingOptions)
            {
               if(_loc4_ < this.mCraftingOptions.length)
               {
                  _loc3_.show();
                  _loc3_.setData(this.mCraftingOptions[_loc4_]);
               }
               else
               {
                  _loc3_.hide();
               }
            }
            else if(_loc4_ < this.mCraftingOptionsBuildingDrive.length)
            {
               _loc3_.show();
               _loc3_.setData(this.mCraftingOptionsBuildingDrive[_loc4_]);
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
         if(this.mPageMax > 1)
         {
            this.mScrollBar.visible = true;
            this.mScrollBar.gotoAndStop(int(this.mScrollBar.totalFrames * this.mPage / (this.mPageMax - 1)));
         }
         else
         {
            this.mScrollBar.visible = false;
         }
         this.mButtonDown.setEnabled(this.mPage < this.mPageMax - 1);
         this.mButtonUp.setEnabled(this.mPage > 0);
         if(this.mBuilding is HFEPlotObject)
         {
            mLastProductionShopPage = this.mPage;
         }
      }
      
      private function upPressed(param1:MouseEvent) : void
      {
         this.mPage = Math.max(0,this.mPage - 1);
         this.setScreen();
         this.setPageNum();
      }
      
      private function downPressed(param1:MouseEvent) : void
      {
         this.mPage = Math.min(this.mPageMax - 1,this.mPage + 1);
         this.setScreen();
         this.setPageNum();
      }
      
      public function refresh() : void
      {
         if(this.mBuilding is HFEPlotObject)
         {
            this.mPage = mLastProductionShopPage;
         }
         else
         {
            this.mPage = 0;
         }
         if(this.mCraftingOptions)
         {
            this.mPageMax = (this.mCraftingOptions.length + PANEL_COUNT - 1) / PANEL_COUNT;
         }
         else
         {
            this.mPageMax = (this.mCraftingOptionsBuildingDrive.length + PANEL_COUNT - 1) / PANEL_COUNT;
         }
         this.setScreen();
         this.setPageNum();
      }
      
      public function startProduction(param1:ShopItem) : void
      {
         var _loc2_:IsometricScene = null;
         var _loc3_:PlayerBuildingObject = null;
         if(param1.getCostSupplies() > this.mPlayer.mSupplies)
         {
            this.mGame.mHUD.openOutOfSuppliesTextBox(null);
            return;
         }
         if(param1.getCostMoney() > this.mPlayer.mMoney)
         {
            this.mGame.mHUD.openOutOfCashTextBox(null);
            return;
         }
         if(param1 is HFEDriveItem)
         {
            this.mBuilding.setProduction(param1.mId);
            MissionManager.increaseCounter("StartProducing",[this.mBuilding.mItem,param1],1);
         }
         else if(param1 is BuildingDriveItem)
         {
            this.mBuilding.setProduction(param1.mId);
            MissionManager.increaseCounter("StartProducing",[this.mBuilding.mItem,param1],1);
         }
         else
         {
            _loc2_ = this.mGame.mScene;
            _loc3_ = _loc2_.createObject(param1 as MapItem,new Point(0,0)) as PlayerBuildingObject;
            _loc3_.setPos(_loc2_.getCenterPointXOfCell(this.mBuilding.getCell()),_loc2_.getCenterPointYOfCell(this.mBuilding.getCell()),0);
            _loc2_.removeObject(this.mBuilding,false,false);
            _loc2_.incrementViewersForBuilding(_loc3_,_loc3_.getSightRangeAccordingToCondition());
            this.mGame.mObjectToBePlaced = _loc3_;
            this.mGame.executeBuyItemWithLoc(param1);
            _loc2_.updateGridInformation();
            _loc2_.updateGridCharacterInfo();
         }
         MissionManager.increaseCounter("OpenHFEShop",null,1);
         this.closeDialog();
      }
      
      private function closedPressed(param1:MouseEvent) : void
      {
         if(MissionManager.modalMissionActive())
         {
            return;
         }
         this.closeDialog();
      }
      
      protected function closeDialog() : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
