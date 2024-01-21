package game.gui.fireMission
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.IconLoader;
   import game.gui.TooltipHUD;
   import game.gui.button.ResizingIconButton;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.ShopItem;
   import game.states.GameState;
   
   public class FireMissionItemSlot
   {
       
      
      private var mTooltip:TooltipHUD;
      
      private var mIconPlace:DisplayObjectContainer;
      
      private var mItem:Item;
      
      private var mClip:Sprite;
      
      private var mParent:DisplayObjectContainer;
      
      private var mValueText:TextField;
      
      private var mActionButton:ResizingIconButton;
      
      public function FireMissionItemSlot(param1:Sprite, param2:DisplayObjectContainer)
      {
         super();
         this.mClip = param1;
         this.mParent = param2;
         this.mValueText = param1.getChildByName("Item_Value") as TextField;
         this.mIconPlace = param1.getChildByName("Item_Container") as DisplayObjectContainer;
         this.mActionButton = Utils.createResizingIconButton(param1,"Button_Buy",this.buyPressed);
         this.mActionButton.setIcon(ItemManager.getItem("Premium","Resource"));
         this.mActionButton.setEnabled(false);
         this.mActionButton.setVisible(false);
         this.mIconPlace.mouseEnabled = true;
      }
      
      private function mouseMoved(param1:MouseEvent) : void
      {
         this.mTooltip.visible = false;
         this.mTooltip.x = this.mParent.x + this.mClip.x + this.mValueText.x - this.mTooltip.width / 2;
         this.mTooltip.y = this.mParent.y + this.mClip.y + this.mValueText.y - this.mValueText.height / 2 - this.mTooltip.height;
      }
      
      private function mouseExit(param1:Event) : void
      {
         this.mTooltip.visible = false;
      }
      
      public function hide() : void
      {
         if(this.mClip.parent)
         {
            this.mClip.parent.removeChild(this.mClip);
         }
      }
      
      public function show() : void
      {
         if(!this.mClip.parent)
         {
            this.mParent.addChild(this.mClip);
         }
      }
      
      private function buyPressed(param1:MouseEvent) : void
      {
         this.mTooltip.visible = false;
         GameState.mInstance.externalCallBuyItem(this.mItem as ShopItem);
      }
      
      public function setItem(param1:Item, param2:int) : Boolean
      {
         this.mItem = param1;
         var _loc3_:int = GameState.mInstance.mPlayerProfile.mInventory.getNumberOfItems(param1);
         this.mValueText.text = _loc3_ + "/" + param2;
         if(this.mIconPlace.numChildren > 0)
         {
            this.mIconPlace.removeChildAt(0);
         }
         IconLoader.addIcon(this.mIconPlace,param1,this.iconLoaded);
         this.mActionButton.getMovieClip().visible = this.mItem is ShopItem;
         this.mActionButton.setText(String(ShopItem(this.mItem).getCostPremium()));
         this.mActionButton.setEnabled(false);
         this.mActionButton.setVisible(false);
         if(!this.mTooltip)
         {
            this.mTooltip = new TooltipHUD(200);
         }
         else
         {
            this.mTooltip.visible = false;
         }
         if(!this.mTooltip.parent)
         {
            this.mParent.parent.addChild(this.mTooltip);
         }
         this.mTooltip.setTitleText(this.mItem.mName);
         this.mTooltip.setDescriptionText(this.mItem.getDescription());
         if(_loc3_ >= param2)
         {
            this.setupEnableSlot();
         }
         else
         {
            this.setupDisableSlot();
         }
         return _loc3_ >= param2;
      }
      
      public function setupDisableSlot() : void
      {
         this.mIconPlace.alpha = 0.5;
         this.mValueText.textColor = 16777215;
      }
      
      public function setupEnableSlot() : void
      {
         this.mIconPlace.alpha = 1;
         this.mValueText.textColor = 16763904;
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,90,90);
         param1.mouseChildren = false;
         param1.mouseEnabled = false;
      }
   }
}
