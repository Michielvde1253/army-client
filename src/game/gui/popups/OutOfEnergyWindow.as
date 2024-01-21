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
   import game.net.GameFeedPublisher;
   import game.states.GameState;
   
   public class OutOfEnergyWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonShop:ResizingButton;
      
      private var mButtonRequest:ResizingButton;
      
      public function OutOfEnergyWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_out_of_energy");
         super(new _loc1_() as MovieClip,true);
         this.mButtonShop = Utils.createResizingButton(mClip,"Button_Shop",this.shopClicked);
         this.mButtonRequest = Utils.createFBIconResizingButton(mClip,"Button_Share",this.requestClicked);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonShop.setText(GameState.getText("BUTTON_TO_SHOP"));
         this.mButtonRequest.setText(GameState.getText("BUTTON_ASK_FOR_HELP"));
         this.mButtonRequest.getMovieClip().visible = false;
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc2_:StylizedHeaderClip = null;
         var _loc3_:TextField = null;
         var _loc5_:Date = null;
         var _loc6_:Number = NaN;
         mDoneCallback = param1;
         _loc2_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("OUT_OF_ORDERS_HEADER"));
         _loc3_ = mClip.getChildByName("Text_Description") as TextField;
         _loc3_.text = GameState.getText("OUT_OF_ORDERS_TEXT");
         var _loc4_:Object;
         if((Boolean(_loc4_ = Cookie.readCookieVariable(Config.COOKIE_SESSION_NAME,Config.COOKIE_SESSION_NAME_ASK_ENERGY))) && _loc4_ > 0)
         {
            if((_loc6_ = (_loc5_ = new Date()).getTime() - Number(_loc4_)) < 16 * 60 * 60 * 1000)
            {
               this.mButtonRequest.setEnabled(false);
            }
         }
      }
      
      private function requestClicked(param1:MouseEvent) : void
      {
         var _loc2_:Date = new Date();
         Cookie.saveCookieVariable(Config.COOKIE_SESSION_NAME,Config.COOKIE_SESSION_NAME_ASK_ENERGY,_loc2_.getTime());
         GameFeedPublisher.publishMessage(GameFeedPublisher.FEED_REQUEST_ENERGY,null,null,this.closeDialog);
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
      
      private function shopClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
         GameState.mInstance.getHud().triggerShopOpening(ShopDialog.TAB_PACKS,"normal");
      }
      
      protected function closeDialog(param1:Boolean = true) : void
      {
         if(param1)
         {
            mDoneCallback((this as Object).constructor);
         }
      }
   }
}
