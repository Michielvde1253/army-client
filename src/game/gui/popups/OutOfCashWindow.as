package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.states.GameState;
   
   public class OutOfCashWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonExchange:ResizingButton;
      
      private var mExchangeCallback:Function;
      
      public function OutOfCashWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_not_enough_cash");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonExchange = Utils.createResizingButton(mClip,"Button_Shop",this.exchangeClicked);
         this.mButtonExchange.setText(GameState.getText("BUTTON_BUY"));
      }
      
      public function Activate(param1:Function, param2:Function, param3:Array) : void
      {
         var _loc4_:StylizedHeaderClip = null;
         var _loc5_:TextField = null;
         mDoneCallback = param1;
         this.mExchangeCallback = param2;
         _loc4_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("MENU_HEADER_OUT_OF_CASH"));
         (_loc5_ = mClip.getChildByName("Text_Description") as TextField).text = GameState.getText("MENU_DESC_OUT_OF_CASH");
         doOpeningTransition();
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         this.closeDialog();
      }
      
      private function exchangeClicked(param1:MouseEvent) : void
      {
         var _loc2_:Function = this.mExchangeCallback;
         mDoneCallback((this as Object).constructor);
         _loc2_(null);
         _loc2_ = null;
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
         this.mExchangeCallback = null;
      }
   }
}
