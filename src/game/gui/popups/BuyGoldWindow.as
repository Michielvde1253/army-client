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
   
   public class BuyGoldWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:DCButton;
      
      private var mButtonUnlock:ResizingButton;
      
      private var mButtonSkip:ResizingButton;
      
      public function BuyGoldWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_buy_gold");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.skipClicked);
         this.mButtonUnlock = Utils.createResizingButton(mClip,"Button_Shop",this.unlockClicked);
         this.mButtonSkip = Utils.createResizingButton(mClip,"Button_Skip",this.skipClicked);
         this.mButtonSkip.getClip().visible = false;
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc2_:StylizedHeaderClip = null;
         var _loc3_:TextField = null;
         mDoneCallback = param1;
         _loc2_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("BUY_GOLD_WARNING_HEADER"));
         _loc3_ = mClip.getChildByName("Text_Description") as TextField;
         _loc3_.text = GameState.getText("BUY_GOLD_WARNING_DESC");
         this.mButtonUnlock.setText(GameState.getText("BUY_GOLD_WARNING_BUTTON_TEXT"));
      }
      
      private function unlockClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
         GameState.mInstance.mHUD.triggerShopOpening(ShopDialog.TAB_BUYGOLD);
      }
      
      private function skipClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
