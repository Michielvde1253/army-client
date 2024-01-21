package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import com.dchoc.utils.Cookie;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.ShopDialog;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.states.GameState;
   
   public class OutOfSuppliesWindow extends PopUpWindow
   {
       
      
      private var mButtonShop:ResizingButton;
      
      private var mButtonCancel:ArmyButton;
      
      private var mAskSuppliesCallBack:Function;
      
      public function OutOfSuppliesWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_not_enough_supplies");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonShop = Utils.createResizingButton(mClip,"Button_Shop",this.shopClicked);
         this.mButtonShop.setText(GameState.getText("BUTTON_TO_SHOP"));
      }
      
      public function Activate(param1:Function, param2:Function, param3:Function, param4:Array) : void
      {
         var _loc5_:StylizedHeaderClip = null;
         var _loc6_:TextField = null;
         mDoneCallback = param1;
         this.mAskSuppliesCallBack = param3;
         _loc5_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("MENU_HEADER_OUT_OF_SUPPLIES"));
         (_loc6_ = mClip.getChildByName("Text_Description") as TextField).text = GameState.getText("MENU_DESC_OUT_OF_SUPPLIES");
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         var _loc5_:Number = NaN;
         var _loc2_:Boolean = true;
         var _loc3_:Date = new Date();
         var _loc4_:Object;
         if((Boolean(_loc4_ = Cookie.readCookieVariable(Config.COOKIE_SESSION_NAME,Config.COOKIE_SESSION_NAME_ASK_SUPPLIES))) && _loc4_ > 0)
         {
            if((_loc5_ = _loc3_.getTime() - Number(_loc4_)) < 16 * 60 * 60 * 1000)
            {
               _loc2_ = false;
            }
         }
         if(_loc2_)
         {
            this.mAskSuppliesCallBack(null);
            mDoneCallback((this as Object).constructor);
         }
         else
         {
            mDoneCallback((this as Object).constructor);
         }
      }
      
      private function shopClicked(param1:MouseEvent) : void
      {
         GameState.mInstance.getHud().triggerShopOpening(ShopDialog.TAB_PACKS,"normal");
         mDoneCallback((this as Object).constructor);
      }
      
      protected function closeDialog(param1:Boolean = true) : void
      {
         if(param1)
         {
            mDoneCallback((this as Object).constructor);
         }
      }
      
      override public function close() : void
      {
         super.close();
         this.mAskSuppliesCallBack = null;
      }
   }
}
