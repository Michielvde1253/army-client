package game.gui
{
   import com.dchoc.GUI.DCButton;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingIconButton;
   import game.gui.popups.PopUpWindow;
   import game.items.AreaItem;
   import game.items.ConstructionItem;
   import game.items.DecorationItem;
   import game.items.HFEPlotItem;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.MapItem;
   import game.items.PlayerInstallationItem;
   import game.items.PlayerUnitItem;
   import game.items.ShopItem;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   import game.utils.TimeUtils;
   
   public class ProductionItemPanel
   {
       
      
      private var mItemActionButton:ResizingIconButton;
      
      private var mItemAction:Function;
      
      private var mName:TextField;
      
      private var mIconBase:MovieClip;
      
      private var mLockIcon:MovieClip;
      
      private var mGroupIcon:MovieClip;
      
      private var mIcon:MovieClip;
      
      private var mItem:ShopItem;
      
      public var mBasePanelLocked:MovieClip;
      
      public var mBasePanelUnLocked:MovieClip;
      
      public var mBasePanel:MovieClip;
      
      public var mDescription:TextField;
      
      public var mItemDescription:TextField;
      
      public var mItemDescriptionSecondary:TextField;
      
      public var mItemHealth:TextField;
      
      public var mItemDamage:TextField;
      
      public var mItemRange:TextField;
      
      public var mItemSize:TextField;
      
      private var mDialog:MovieClip;
      
      private var mPopUpTextField:TooltipHUD;
      
      private var mdialogpopup:PopUpWindow;
      
      private var mInfoButton:ArmyButton;
      
      private var mInfoButtonLock:ArmyButton;
      
      public function ProductionItemPanel(param1:MovieClip, param2:MovieClip, param3:MovieClip, param4:PopUpWindow)
      {
         super();
         this.mBasePanelLocked = param2;
         this.mBasePanelUnLocked = param1;
         this.mDialog = param3;
         this.mdialogpopup = param4;
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         this.mPopUpTextField.visible = true;
         this.mPopUpTextField.x = this.mBasePanel.x - this.mPopUpTextField.width / 2;
         this.mPopUpTextField.y = this.mBasePanel.y - this.mBasePanel.height / 2 - this.mPopUpTextField.height;
      }
      
      private function mouseUp(param1:Event) : void
      {
         this.mPopUpTextField.visible = false;
      }
      
      public function hide() : void
      {
         if(this.mBasePanelLocked.parent)
         {
            this.mBasePanelLocked.parent.removeChild(this.mBasePanelLocked);
         }
         if(this.mBasePanelUnLocked.parent)
         {
            this.mBasePanelUnLocked.parent.removeChild(this.mBasePanelUnLocked);
         }
      }
      
      public function show() : void
      {
         this.mDialog.addChild(this.mBasePanelLocked);
         this.mDialog.addChild(this.mBasePanelUnLocked);
      }
      
      public function setData(param1:ShopItem) : void
      {
         var _loc3_:ResizingIconButton = null;
         var _loc4_:ResizingIconButton = null;
         var _loc5_:MovieClip = null;
         var _loc6_:GamePlayerProfile = null;
         var _loc7_:TextField = null;
         var _loc8_:TextField = null;
         var _loc9_:TextFormat = null;
         var _loc10_:PlayerUnitItem = null;
         var _loc11_:TextFormat = null;
         var _loc12_:TextFormat = null;
         var _loc13_:ConstructionItem = null;
         var _loc14_:DecorationItem = null;
         var _loc15_:PlayerInstallationItem = null;
         var _loc16_:HFEPlotItem = null;
         this.mItem = param1;
         if(param1.isUnlocked())
         {
            this.mBasePanel = this.mBasePanelUnLocked;
            this.mBasePanelLocked.parent.removeChild(this.mBasePanelLocked);
            _loc3_ = Utils.createResizingIconButton(this.mBasePanel,"Button_Buy",null);
            _loc4_ = Utils.createResizingIconButton(this.mBasePanel,"Button_Unlock",null);
            this.mInfoButton = new ArmyButton(this.mBasePanel,this.mBasePanel.getChildByName("production_info") as MovieClip,DCButton.BUTTON_TYPE_OK,null,null,this.mouseDown,null,null,this.mouseUp);
            this.mInfoButton.setVisible(true);
            _loc3_.setVisible(true);
            _loc4_.setVisible(true);
            if(param1.canAffordItemWithResources() && param1.capAvailable())
            {
               this.mItemActionButton = _loc3_;
               this.mItemAction = this.buyPressed;
               _loc4_.setVisible(false);
            }
            else
            {
               this.mItemActionButton = _loc4_;
               this.mItemAction = this.buyPressedNoResources;
               _loc3_.setVisible(false);
            }
         }
         else
         {
            this.mBasePanel = this.mBasePanelLocked;
            this.mBasePanelUnLocked.parent.removeChild(this.mBasePanelUnLocked);
            _loc5_ = this.mBasePanel.getChildByName("Counter_Unlock") as MovieClip;
            this.mItemActionButton = Utils.createResizingIconButton(this.mBasePanel,"Button_Unlock",null);
            this.mInfoButtonLock = new ArmyButton(this.mBasePanel,this.mBasePanel.getChildByName("production_info_lock") as MovieClip,DCButton.BUTTON_TYPE_OK,null,null,this.mouseDown,null,null,this.mouseUp);
            this.mInfoButtonLock.setVisible(true);
            this.mItemAction = this.unlockPressed;
            _loc6_ = GameState.mInstance.mPlayerProfile;
            _loc5_.visible = true;
            _loc7_ = _loc5_.getChildByName("Text_Title") as TextField;
            _loc8_ = _loc5_.getChildByName("Text_Amount") as TextField;
            if(!param1.hasRequiredLevel())
            {
               _loc7_.text = GameState.getText("SHOP_REQUIRES_LEVEL");
               _loc8_.text = String(param1.mRequiredLevel);
            }
            else if(!param1.hasRequiredAllies())
            {
               _loc7_.text = GameState.getText("SHOP_REQUIRES_ALLIES");
               _loc8_.text = String(param1.mRequiredAllies);
            }
            else if(!param1.hasRequiredMission())
            {
               _loc7_.text = "";
               _loc8_.text = "X";
            }
            else if(!param1.hasRequiredBuilding())
            {
               _loc7_.text = "";
               _loc8_.text = "X";
            }
            else if(!param1.hasRequiredIntel())
            {
               _loc7_.text = "";
               _loc8_.text = "X";
            }
            else
            {
               _loc7_.text = "";
               _loc8_.text = "X";
            }
         }
         this.mIconBase = this.mBasePanel.getChildByName("Icon") as MovieClip;
         this.mName = this.mBasePanel.getChildByName("Text_Title") as TextField;
         this.mName.text = param1.mName;
         if(Config.FOR_IPHONE_PLATFORM)
         {
            (_loc9_ = this.mName.getTextFormat()).size = 23;
            this.mName.defaultTextFormat = _loc9_;
         }
         this.setPriceCounterValues(param1);
         if(this.mIcon != null && Boolean(this.mIcon.parent))
         {
            this.mIcon.parent.removeChild(this.mIcon);
            this.mIcon = null;
         }
         if(param1 is MapItem && Boolean((param1 as MapItem).getShopIconGraphics()))
         {
            IconLoader.addIcon(this.mIconBase,new IconAdapter((param1 as MapItem).getShopIconGraphics(),(param1 as MapItem).getShopIconGraphicsFile()),this.iconLoaded);
         }
         else
         {
            IconLoader.addIcon(this.mIconBase,param1,this.iconLoaded);
         }
         this.mItemActionButton.getMovieClip().mouseEnabled = true;
         this.mItemActionButton.getMovieClip().addEventListener(MouseEvent.CLICK,this.mItemAction,false);
         if(this.mPopUpTextField)
         {
            if(this.mPopUpTextField.parent)
            {
               this.mPopUpTextField.parent.removeChild(this.mPopUpTextField);
            }
            this.mPopUpTextField = null;
         }
         this.mPopUpTextField = new TooltipHUD(210);
         this.mDialog.parent.addChild(this.mPopUpTextField);
         if(!(this.mdialogpopup is ProductionDialog))
         {
            this.mItemDescription = this.mBasePanel.getChildByName("Text") as TextField;
            this.mItemDescription.autoSize = TextFieldAutoSize.LEFT;
            this.mItemDescription.wordWrap = true;
            this.mItemDescriptionSecondary = this.mBasePanel.getChildByName("Text_secondary") as TextField;
            this.mItemDescriptionSecondary.autoSize = TextFieldAutoSize.LEFT;
            this.mItemDescriptionSecondary.wordWrap = true;
            if(Config.FOR_IPHONE_PLATFORM)
            {
               (_loc11_ = this.mItemDescription.getTextFormat()).size = 17;
               this.mItemDescription.defaultTextFormat = _loc11_;
               (_loc11_ = this.mItemDescriptionSecondary.getTextFormat()).size = 17;
               this.mItemDescriptionSecondary.defaultTextFormat = _loc11_;
               this.mItemDescriptionSecondary.setTextFormat(_loc11_);
            }
            this.mItemHealth = this.mBasePanel.getChildByName("Text_health") as TextField;
            this.mItemDamage = this.mBasePanel.getChildByName("Text_damage") as TextField;
            this.mItemRange = this.mBasePanel.getChildByName("Text_range") as TextField;
            this.mItemSize = this.mBasePanel.getChildByName("Text_size") as TextField;
            this.mItemHealth.visible = true;
            this.mItemHealth.autoSize = TextFieldAutoSize.LEFT;
            this.mItemHealth.wordWrap = true;
            this.mItemDamage.visible = true;
            this.mItemDamage.autoSize = TextFieldAutoSize.LEFT;
            this.mItemDamage.wordWrap = true;
            this.mItemRange.visible = true;
            this.mItemRange.autoSize = TextFieldAutoSize.LEFT;
            this.mItemRange.wordWrap = true;
            this.mItemSize.visible = true;
            this.mItemSize.autoSize = TextFieldAutoSize.LEFT;
            this.mItemSize.wordWrap = true;
            if(Config.FOR_IPHONE_PLATFORM)
            {
               (_loc12_ = this.mItemHealth.getTextFormat()).size = 17;
               this.mItemHealth.defaultTextFormat = _loc12_;
               (_loc12_ = this.mItemDamage.getTextFormat()).size = 17;
               this.mItemDamage.defaultTextFormat = _loc12_;
               (_loc12_ = this.mItemRange.getTextFormat()).size = 17;
               this.mItemRange.defaultTextFormat = _loc12_;
               (_loc12_ = this.mItemSize.getTextFormat()).size = 17;
               this.mItemSize.defaultTextFormat = _loc12_;
            }
            _loc10_ = null;
            switch(param1.mType)
            {
               case "Infantry":
                  this.mItemHealth.visible = true;
                  this.mItemDamage.visible = true;
                  this.mItemRange.visible = false;
                  this.mItemSize.visible = false;
                  _loc10_ = this.mItem as PlayerUnitItem;
                  this.mItemHealth.text = GameState.getText("SHOP_PANEL_ITEM_HEALTH") + " : " + _loc10_.mHealth;
                  this.mItemDamage.text = GameState.getText("SHOP_PANEL_ITEM_DAMAGE") + " : " + _loc10_.mDamage;
                  break;
               case "Armor":
                  this.mItemHealth.visible = true;
                  this.mItemDamage.visible = true;
                  this.mItemRange.visible = false;
                  this.mItemSize.visible = false;
                  _loc10_ = this.mItem as PlayerUnitItem;
                  this.mItemHealth.text = GameState.getText("SHOP_PANEL_ITEM_HEALTH") + " : " + _loc10_.mHealth;
                  this.mItemDamage.text = GameState.getText("SHOP_PANEL_ITEM_DAMAGE") + " : " + _loc10_.mDamage;
                  break;
               case "Artillery":
                  this.mItemHealth.visible = true;
                  this.mItemDamage.visible = true;
                  this.mItemRange.visible = true;
                  this.mItemSize.visible = false;
                  _loc10_ = this.mItem as PlayerUnitItem;
                  this.mItemHealth.text = GameState.getText("SHOP_PANEL_ITEM_HEALTH") + " : " + _loc10_.mHealth;
                  this.mItemDamage.text = GameState.getText("SHOP_PANEL_ITEM_DAMAGE") + " : " + _loc10_.mDamage;
                  this.mItemRange.text = GameState.getText("SHOP_PANEL_ITEM_RANGE") + " : " + _loc10_.mAttackRange;
                  break;
               case "Building":
                  this.mItemHealth.visible = false;
                  this.mItemDamage.visible = false;
                  this.mItemRange.visible = false;
                  this.mItemSize.visible = true;
                  _loc13_ = this.mItem as ConstructionItem;
                  this.mItemSize.text = GameState.getText("SHOP_PANEL_ITEM_SIZE") + " : " + _loc13_.getItemSizeString();
                  break;
               case "NonFunctionalDeco":
                  this.mItemHealth.visible = false;
                  this.mItemDamage.visible = false;
                  this.mItemRange.visible = false;
                  this.mItemSize.visible = true;
                  _loc14_ = this.mItem as DecorationItem;
                  this.mItemSize.text = GameState.getText("SHOP_PANEL_ITEM_SIZE") + " : " + _loc14_.getItemSizeString();
                  break;
               case "CounterAttack":
                  this.mItemHealth.visible = true;
                  this.mItemDamage.visible = true;
                  this.mItemRange.visible = true;
                  this.mItemRange.visible = true;
                  _loc15_ = this.mItem as PlayerInstallationItem;
                  this.mItemHealth.text = GameState.getText("SHOP_PANEL_ITEM_HEALTH") + " : " + _loc15_.mHealth;
                  this.mItemDamage.text = GameState.getText("SHOP_PANEL_ITEM_DAMAGE") + " : " + _loc15_.mDamage;
                  this.mItemRange.text = GameState.getText("SHOP_PANEL_ITEM_RANGE") + " : " + _loc15_.mAttackRange;
                  this.mItemSize.text = GameState.getText("SHOP_PANEL_ITEM_SIZE") + " : " + _loc15_.getItemSizeString();
                  break;
               case "EnergyRefill":
               case "BuyGold":
               case "BuyCash":
               case "SupplyPack":
               case "HomeFrontEffort":
               case "Signal":
               case "Area":
                  this.mItemHealth.visible = false;
                  this.mItemDamage.visible = false;
                  this.mItemRange.visible = false;
                  this.mItemSize.visible = false;
                  break;
               case "HFEPlot":
                  this.mItemHealth.visible = false;
                  this.mItemDamage.visible = false;
                  this.mItemRange.visible = false;
                  this.mItemSize.visible = true;
                  _loc16_ = this.mItem as HFEPlotItem;
                  this.mItemSize.text = GameState.getText("SHOP_PANEL_ITEM_SIZE") + " : " + _loc16_.getItemSizeString();
            }
         }
         var _loc2_:int = 10;
         if(param1.isUnlocked())
         {
            this.mPopUpTextField.setTitleText(param1.mName);
            this.mPopUpTextField.setDescriptionText(param1.getDescription());
            if(!(this.mdialogpopup is ProductionDialog))
            {
               this.mItemDescription.text = param1.getDescription();
               if(param1.getDescriptionSecondary())
               {
                  this.mItemDescriptionSecondary.y = this.mItemDescription.y + this.mItemDescription.height + _loc2_;
                  this.mItemDescriptionSecondary.text = param1.getDescriptionSecondary();
               }
               else
               {
                  this.mItemDescriptionSecondary.text = "";
               }
            }
         }
         else
         {
            this.mPopUpTextField.setTitleText(param1.mName);
            if(param1 is AreaItem)
            {
               this.mPopUpTextField.setDescriptionText(param1.getDescription());
               if(!(this.mdialogpopup is ProductionDialog))
               {
                  this.mItemDescription.text = param1.getDescription();
               }
            }
            if(param1.isAlreadyAdded())
            {
               this.mPopUpTextField.setDescriptionText(param1.getUnlockText());
               if(!(this.mdialogpopup is ProductionDialog))
               {
                  this.mItemDescription.text = param1.getUnlockText();
               }
            }
            else
            {
               this.mPopUpTextField.setDescriptionText(param1.getDescription() + "\n\n" + GameState.getText("SHOP_REQUIRES_PREFIX") + "\n" + param1.getUnlockText() + "\n" + param1.getUnlockCostText());
               if(!(this.mdialogpopup is ProductionDialog))
               {
                  this.mItemDescription.text = param1.getDescription();
                  this.mItemDescriptionSecondary.y = this.mItemDescription.y + this.mItemDescription.height + _loc2_;
                  this.mItemDescriptionSecondary.text = GameState.getText("SHOP_REQUIRES_PREFIX") + "\n" + param1.getUnlockText() + "\n" + param1.getUnlockCostText();
               }
            }
         }
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,90,90);
      }
      
      private function setPriceCounterValues(param1:ShopItem) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.mItemActionButton.setDefaultWidth(true);
         this.mItemActionButton.setText(this.getTextForBuyButton(param1));
         this.mItemActionButton.setIcon(this.getResourceForBuyButton(param1));
         this.mDescription = this.mBasePanel.getChildByName("Text_Description") as TextField;
         this.mDescription.text = "";
         this.mDescription.visible = true;
         this.mDescription.autoSize = TextFieldAutoSize.NONE;
         this.mDescription.wordWrap = false;
         if(param1 is MapItem)
         {
            _loc3_ = int((param1 as MapItem).mCrafting.Time);
            if(_loc3_ > 0 && !(param1 is ConstructionItem))
            {
               this.mDescription.text = GameState.getText("SHOP_PRODUCTION_TIME",[TimeUtils.secondsToString(_loc3_ * 60,2,true)]);
            }
            else
            {
               this.mDescription.visible = false;
            }
         }
         else if(param1.mType == "Area" && !param1.mEarlyUnlockBought)
         {
            _loc4_ = (param1 as AreaItem).mCostIntel;
            this.mDescription.text = GameState.getText("SHOP_REQUIRES_PREFIX") + " " + _loc4_ + " " + GameState.getText("SHOP_REQUIRES_INTEL");
         }
         var _loc2_:TextFormat = this.mDescription.getTextFormat();
         if(Config.FOR_IPHONE_PLATFORM)
         {
            if(!(this.mdialogpopup is ProductionDialog))
            {
               _loc2_.size = 16;
               this.mDescription.defaultTextFormat = _loc2_;
               this.mDescription.setTextFormat(_loc2_);
            }
         }
         while(this.mDescription.textWidth + 3 > this.mDescription.width && _loc2_.size as int > 1)
         {
            _loc2_.size = (_loc2_.size as int) - 1;
            this.mDescription.defaultTextFormat = _loc2_;
            this.mDescription.setTextFormat(_loc2_);
         }
      }
      
      private function getResourceForBuyButton(param1:ShopItem) : Item
      {
         if(param1.mType == "BuyGold" || param1.mType == "BuyCash")
         {
            return ItemManager.getItem("Dollar","Resource");
         }
         if(param1.getCostMoney() > 0)
         {
            return ItemManager.getItem("Money","Resource");
         }
         if(param1.getCostSupplies() > 0)
         {
            return ItemManager.getItem("Supplies","Resource");
         }
         if(param1.getCostMaterial() > 0)
         {
            return ItemManager.getItem("Material","Resource");
         }
         if(param1.getCostPremium() > 0)
         {
            return ItemManager.getItem("Premium","Resource");
         }
         return null;
      }
      
      private function getTextForBuyButton(param1:ShopItem, param2:Boolean = false) : String
      {
         if(param1.getCostMoney() > 0)
         {
            return String(param1.getCostMoney(param2));
         }
         if(param1.getCostSupplies() > 0)
         {
            return String(param1.getCostSupplies(param2));
         }
         if(param1.getCostMaterial() > 0)
         {
            return String(param1.getCostMaterial(param2));
         }
         if(param1.getCostPremium() > 0)
         {
            return String(param1.getCostPremium(param2));
         }
         return "";
      }
      
      private function buyPressedNoResources(param1:MouseEvent) : void
      {
         var _loc2_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         var _loc3_:GameHUD = GameState.mInstance.mHUD;
         if(!this.mItem.hasRequiredIntel())
         {
            _loc3_.openOutOfIntelTextBox([this.mItem]);
         }
         else if(!this.mItem.capAvailable())
         {
            if(this.mItem.mType == "Infantry")
            {
               _loc3_.openInfantryCapTextBox();
            }
            else
            {
               _loc3_.openUnitCapTextBox(this.mItem);
            }
         }
         else if(this.mItem.getCostSupplies() > _loc2_.mSupplies)
         {
            if(this.mdialogpopup is ProductionDialog)
            {
               _loc3_.openOutOfSuppliesTextBox(null);
            }
         }
         else if(this.mItem.getCostMoney() > _loc2_.mMoney)
         {
            _loc3_.openOutOfCashTextBox(null);
         }
         if(this.mdialogpopup is ShopDialog)
         {
            ShopDialog(this.mdialogpopup).closeDialog();
         }
      }
      
      private function buyPressed(param1:MouseEvent) : void
      {
         if(this.mdialogpopup is ShopDialog)
         {
            ShopDialog(this.mdialogpopup).buyItem(this.mItem);
         }
         else if(this.mdialogpopup is ProductionDialog)
         {
            ProductionDialog(this.mdialogpopup).startProduction(this.mItem);
         }
      }
      
      private function unlockPressed(param1:MouseEvent) : void
      {
         var _loc2_:GameHUD = GameState.mInstance.mHUD;
         if(!this.mItem.hasRequiredMission())
         {
            _loc2_.openUnlockItemByMissionTextBox(this.mItem);
         }
         else if(!this.mItem.hasRequiredLevel())
         {
            _loc2_.openUnlockItemByLevelTextBox(this.mItem);
         }
         else if(!this.mItem.hasRequiredBuilding())
         {
            _loc2_.openUnlockItemByBuildingTextBox(this.mItem);
         }
         else if(!this.mItem.hasRequiredAllies())
         {
            _loc2_.openUnlockItemByAlliesTextBox(this.mItem);
         }
         if(this.mdialogpopup is ShopDialog)
         {
            ShopDialog(this.mdialogpopup).closeDialog();
         }
      }
   }
}
