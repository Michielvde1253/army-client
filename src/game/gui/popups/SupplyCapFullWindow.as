package game.gui.popups
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.ShopDialog;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ResizingButton;
   import game.states.GameState;
   
   public class SupplyCapFullWindow extends PopUpWindow
   {
       
      
      private var mButtonShop:ResizingButton;
      
      private var mButtonCancel:DCButton;
      
      public function SupplyCapFullWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_supply_cap_full");
         super(new _loc1_(),true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonShop = Utils.createResizingButton(mClip,"Button_Shop",this.shopClicked);
         this.mButtonShop.setText(GameState.getText("BUTTON_TO_SHOP"));
      }
      
      public function Activate(param1:Function, param2:Array) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc4_:TextField = null;
         mDoneCallback = param1;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("MENU_HEADER_SUPPLY_CAP"));
         (_loc4_ = mClip.getChildByName("Text_Description") as TextField).text = GameState.getText("MENU_DESC_SUPPLY_CAP");
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
      
      private function shopClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
         GameState.mInstance.mHUD.triggerShopOpening(ShopDialog.TAB_STORAGE);
      }
   }
}
