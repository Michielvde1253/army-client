package game.gui.popups
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.ShopDialog;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ResizingIconButton;
   import game.states.GameState;
   
   public class UnitDiedWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:DCButton;
      
      private var mButtonShop:ResizingIconButton;
      
      private var mOpenShopCallback:Function;
      
      public function UnitDiedWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_unit_destroyed");
         super(new _loc1_(),true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonShop = Utils.createResizingIconButton(mClip,"Button_Share",this.shopClicked);
         this.mButtonShop.setText(GameState.getText("BUTTON_TO_SHOP"));
      }
      
      public function Activate(param1:Function, param2:Function) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc4_:TextField = null;
         mDoneCallback = param1;
         this.mOpenShopCallback = param2;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("ACTION_FRIENDLY_UNIT_DYING_HEADER"));
         (_loc4_ = mClip.getChildByName("Text_Description") as TextField).text = GameState.getText("ACTION_FRIENDLY_UNIT_DYING");
      }
      
      private function shopClicked(param1:MouseEvent) : void
      {
         this.mOpenShopCallback(ShopDialog.TAB_UNITS);
         mDoneCallback((this as Object).constructor);
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
      
      override public function close() : void
      {
         super.close();
         this.mOpenShopCallback = null;
      }
   }
}
