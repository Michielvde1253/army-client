package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.gui.button.ResizingIconButton;
   import game.items.ItemManager;
   import game.items.ShopItem;
   import game.states.GameState;
   import game.utils.WebUtils;
   
   public class UnlockItemByAlliesWindow extends PopUpWindow
   {
      
      private static const VIR_SRC:String = "vir_unlockItemByAlliesWindow_action";
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonUnlock:ResizingButton;
      
      private var mButtonBuyPremium:ResizingIconButton;
      
      private var mItem:ShopItem;
      
      public function UnlockItemByAlliesWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_item_locked_allies");
         super(new _loc1_(),true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.skipClicked);
         this.mButtonUnlock = Utils.createResizingButton(mClip,"Button_Submit",this.unlockClicked);
         this.mButtonBuyPremium = Utils.createResizingIconButton(mClip,"Button_Buy",this.unlockPremiumClicked);
         this.mButtonBuyPremium.setIcon(ItemManager.getItem("Premium","Resource"));
      }
      
      public function Activate(param1:Function, param2:ShopItem) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc4_:TextField = null;
         mDoneCallback = param1;
         this.mItem = param2;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,param2.mName);
         (_loc4_ = mClip.getChildByName("Text_Description") as TextField).text = GameState.getText("MENU_DESC_UNLOCK_ITEM_NEIGHBORS",[param2.mRequiredAllies]);
         this.mButtonUnlock.setText(GameState.getText("BUTTON_INVITE"));
         if(this.mItem.getUnlockCost() > 0)
         {
            this.mButtonBuyPremium.setText(GameState.getText("BUTTON_UNLOCK",[this.mItem.getUnlockCost()]));
            this.mButtonBuyPremium.getClip().visible = true;
         }
         else
         {
            this.mButtonBuyPremium.getClip().visible = false;
         }
         var _loc5_:MovieClip = mClip.getChildByName("Icon_Target") as MovieClip;
         IconLoader.addIcon(_loc5_,param2,this.iconLoaded);
      }
      
      private function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,100,100);
      }
      
      private function unlockClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
         WebUtils.externalInterfaceCallWrapper("charlieFunctions.showNeighborsPage",VIR_SRC);
      }
      
      private function unlockPremiumClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
         GameState.mInstance.externalCallBuyUnlock(this.mItem);
      }
      
      private function skipClicked(param1:MouseEvent = null) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
