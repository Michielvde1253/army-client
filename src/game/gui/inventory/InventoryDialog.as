package game.gui.inventory
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.popups.PopUpWindow;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.MapItem;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.player.Inventory;
   import game.states.GameState;
   
   public class InventoryDialog extends PopUpWindow
   {
      
      private static const STATE_INVENTORY:int = 0;
      
      private static const STATE_COLLECTIONS:int = 1;
      
      private static var mState:int;
      
      private static const PANEL_COUNT:int = 8;
       
      
      private var mPlayer:GamePlayerProfile;
      
      private var mGame:GameState;
      
      private var mHeader:StylizedHeaderClip;
      
      private var mButtonClose:ArmyButton;
      
      private var mButtonPrev:ArmyButton;
      
      private var mButtonNext:ArmyButton;
      
      private var mPanels:Array;
      
      private var mPage:int = 0;
      
      private var mPageMax:int = 0;
      
      private var mInventoryItems:Array;
      
      private var mIndicatorArrow:MovieClip;
      
      public function InventoryDialog()
      {
         var _loc3_:MovieClip = null;
         this.mPanels = new Array();
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_FULLSCREEN_NAME,"New_inventory_ipad");
         mClip = new _loc1_();
         super(mClip,false,false);
         this.mGame = GameState.mInstance;
         this.mPlayer = this.mGame.mPlayerProfile;
         mState = STATE_INVENTORY;
         this.mHeader = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip);
         this.mHeader.setText(GameState.getText("INVENTORY_HEADER"));
         this.mButtonPrev = Utils.createBasicButton(mClip,"left_arrow",this.prevPressed);
         this.mButtonNext = Utils.createBasicButton(mClip,"right_arrow",this.nextPressed);
         this.mButtonClose = Utils.createBasicButton(mClip,"Button_Cancel",this.closedPressed);
         var _loc2_:int = 0;
         while(_loc2_ < PANEL_COUNT)
         {
            _loc3_ = MovieClip(mClip.getChildByName("icon_inventory_item_" + (_loc2_ + 1)));
            this.mPanels[_loc2_] = new InventoryItemPanel(_loc3_,this);
            _loc2_++;
         }
      }
      
      public function Activate(param1:Function) : void
      {
         mDoneCallback = param1;
         this.refresh();
         doOpeningTransition();
      }
      
      private function getItems() : Array
      {
         var _loc1_:Inventory = this.mPlayer.mInventory;
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat(_loc1_.getEnergyRefills());
         _loc2_ = _loc2_.concat(_loc1_.getSupplyPacks());
         _loc2_ = _loc2_.concat(_loc1_.getPowerUps());
         _loc2_ = _loc2_.concat(_loc1_.getMisc());
         _loc2_ = _loc2_.concat(_loc1_.getIntels());
         _loc2_ = _loc2_.concat(_loc1_.getIngredients());
         _loc2_ = _loc2_.concat(_loc1_.getMedals());
         return _loc2_.concat(_loc1_.getBoosters());
      }
      
      private function setScreen() : void
      {
         if(mState == STATE_INVENTORY)
         {
            this.show();
         }
         else
         {
            this.hide();
         }
      }
      
      private function hide() : void
      {
         var _loc1_:InventoryItemPanel = null;
         var _loc2_:int = int(this.mPanels.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mPanels[_loc3_] as InventoryItemPanel;
            _loc1_.hide();
            _loc3_++;
         }
      }
      
      private function show() : void
      {
         var _loc3_:InventoryItemPanel = null;
         var _loc4_:int = 0;
         var _loc1_:int = this.mPage * PANEL_COUNT;
         var _loc2_:int = 0;
         while(_loc2_ < PANEL_COUNT)
         {
            _loc3_ = InventoryItemPanel(this.mPanels[_loc2_]);
            if((_loc4_ = _loc2_ + _loc1_) < this.mInventoryItems.length / 2)
            {
               _loc3_.show();
               _loc3_.setData(this.mInventoryItems[_loc4_ * 2],this.mInventoryItems[_loc4_ * 2 + 1]);
            }
            else
            {
               _loc3_.hide();
            }
            _loc2_++;
         }
      }
      
      public function setPageNum() : void
      {
         if(mState == STATE_INVENTORY)
         {
            this.mButtonNext.setEnabled(this.mPage < this.mPageMax - 1);
            this.mButtonPrev.setEnabled(this.mPage > 0);
         }
      }
      
      public function refresh() : void
      {
         this.mInventoryItems = this.getItems();
         this.mPage = 0;
         this.mPageMax = Math.max(1,Math.ceil(this.mInventoryItems.length / 2 / PANEL_COUNT));
         this.setScreen();
         this.setPageNum();
         if(GameState.mInstance.mIndicateInventoryItem == true)
         {
            this.setIndicatorArrow();
         }
         else
         {
            this.removeIndicatorArrow();
         }
      }
      
      public function useItem(param1:Item) : void
      {
         var _loc2_:Object = null;
         if(Config.DEBUG_MODE)
         {
         }
         if(param1 is MapItem)
         {
            this.mGame.setFromInventory(param1 as MapItem);
            this.closeDialog();
         }
         else
         {
            this.mPlayer.mInventory.addItems(param1,-1);
            this.mPlayer.useItem(param1);
            _loc2_ = {
               "item_id":param1.mId,
               "item_type":ItemManager.getTableNameForItem(param1)
            };
            this.mGame.mServer.serverCallServiceWithParameters(ServiceIDs.USE_POWER_UP_FROM_INVENTORY,_loc2_,false);
            this.removeIndicatorArrow();
            GameState.mInstance.mIndicateInventoryItem = false;
            this.refresh();
         }
      }
      
      public function sellItem(param1:Item) : void
      {
         this.mPlayer.mInventory.addItems(param1,-1);
         this.refresh();
      }
      
      private function prevPressed(param1:MouseEvent) : void
      {
         if(mState == STATE_INVENTORY)
         {
            this.removeIndicatorArrow();
            GameState.mInstance.mIndicateInventoryItem = false;
            this.mPage = Math.max(0,this.mPage - 1);
            this.setScreen();
            this.setPageNum();
         }
      }
      
      private function nextPressed(param1:MouseEvent) : void
      {
         if(mState == STATE_INVENTORY)
         {
            this.removeIndicatorArrow();
            GameState.mInstance.mIndicateInventoryItem = false;
            this.mPage = Math.min(this.mPageMax - 1,this.mPage + 1);
            this.setScreen();
            this.setPageNum();
         }
      }
      
      private function closedPressed(param1:MouseEvent) : void
      {
         this.closeDialog();
      }
      
      public function closeDialog() : void
      {
         this.removeIndicatorArrow();
         GameState.mInstance.mIndicateInventoryItem = false;
         mDoneCallback((this as Object).constructor);
      }
      
      override public function close() : void
      {
         super.close();
         this.mGame = null;
         this.mPlayer = null;
      }
      
      private function setIndicatorArrow() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:InventoryItemPanel = InventoryItemPanel(this.mPanels[0]);
         _loc1_ = _loc3_.mBasePanel.x + _loc3_.mBasePanel.width / 2;
         _loc2_ = _loc3_.mBasePanel.y;
         var _loc4_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"T_arrow_LB");
         this.mIndicatorArrow = new _loc4_();
         this.mIndicatorArrow.mouseEnabled = false;
         this.mIndicatorArrow.mouseChildren = false;
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
