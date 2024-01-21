package game.gui.popups
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ResizingButton;
   import game.states.GameState;
   
   public class BuyMoneyWindow extends PopUpWindow
   {
       
      
      private var mButtonContinue:ResizingButton;
      
      private var mButtonCancel:DCButton;
      
      private var mPricePoints:Array;
      
      private var mSelectedPricePoint:int;
      
      private var mPricePointPanels:Array;
      
      public function BuyMoneyWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME,"popup_exchange_cash");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonContinue = Utils.createFBIconResizingButton(mClip,"Button_Share",this.continueClicked);
         this.mButtonContinue.setText(GameState.getText("BUTTON_CONTINUE"));
      }
      
      public function Activate(param1:Function, param2:Array) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc4_:TextField = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MoneyPricePointPanel = null;
         mDoneCallback = param1;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("MENU_HEADER_BUY_MONEY"));
         (_loc4_ = mClip.getChildByName("Text_Description") as TextField).text = GameState.getText("MENU_DESC_BUY_MONEY");
         (_loc4_ = mClip.getChildByName("Text_Disclaimer") as TextField).text = GameState.getText("MONEY_DISCLAIMER");
         this.mSelectedPricePoint = 0;
         var _loc5_:Array = new Array();
         this.mPricePointPanels = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < this.mPricePoints.length)
         {
            _loc7_ = mClip.getChildByName("Frame_Option_" + (_loc6_ + 1)) as MovieClip;
            _loc8_ = new MoneyPricePointPanel(_loc7_,this.mPricePoints[_loc6_],_loc6_,_loc5_,this.selectClicked);
            this.mPricePointPanels.push(_loc8_);
            _loc6_++;
         }
         doOpeningTransition();
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
      
      private function continueClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
         GameState.mInstance.externalCallBuyMoney(this.mPricePoints[this.mSelectedPricePoint]);
      }
      
      private function selectClicked(param1:int) : void
      {
         this.mSelectedPricePoint = param1;
      }
   }
}
