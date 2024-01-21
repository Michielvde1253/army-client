package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import com.dchoc.utils.Cookie;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ResizingButton;
   import game.states.GameState;
   
   public class RateAppWindow extends PopUpWindow
   {
       
      
      private var mButtonRate:ResizingButton;
      
      private var mButtonLater:ResizingButton;
      
      private var mTitle:StylizedHeaderClip;
      
      public function RateAppWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_exit_msg");
         super(new _loc1_() as MovieClip,true);
         this.mTitle = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip);
         this.mTitle.setText(GameState.getText("RATEAPP_TITLE"));
         this.mButtonLater = Utils.createResizingButton(mClip,"Button_Skip",this.laterClicked);
         this.mButtonRate = Utils.createResizingButton(mClip,"Button_Shop",this.rateClicked);
         this.mButtonLater.setText(GameState.getText("RATEAPP_BUTTON_REMIND"));
         this.mButtonRate.setText(GameState.getText("RATEAPP_BUTTON_RATE"));
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc2_:TextField = null;
         mDoneCallback = param1;
         _loc2_ = mClip.getChildByName("Text_Description") as TextField;
         _loc2_.text = GameState.getText("RATEAPP_DESC");
      }
      
      private function rateClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
      
      private function laterClicked(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:Date = null;
         if(!FeatureTuner.USE_DEBUG_RATEAPP_POPUP)
         {
            _loc2_ = false;
            _loc2_ = Cookie.readCookieVariable(Config.COOKIE_APPRATER_NAME,Config.COOKIE_APPRATER_NAME_REMINDER_PRESSED);
            if(_loc2_ == true)
            {
               _loc3_ = Cookie.readCookieVariable(Config.COOKIE_APPRATER_NAME,Config.COOKIE_APPRATER_NAME_REMINDER_COUNT);
            }
            else
            {
               _loc3_ = 0;
            }
            Cookie.saveCookieVariable(Config.COOKIE_APPRATER_NAME,Config.COOKIE_APPRATER_NAME_REMINDER_PRESSED,true);
            _loc4_ = new Date();
            Cookie.saveCookieVariable(Config.COOKIE_APPRATER_NAME,Config.COOKIE_APPRATER_NAME_DATE_REMINDER_PRESSED,_loc4_.time);
            _loc3_++;
            Cookie.saveCookieVariable(Config.COOKIE_APPRATER_NAME,Config.COOKIE_APPRATER_NAME_REMINDER_COUNT,_loc3_);
            if(_loc3_ >= GameState.mInstance.MAX_NUMBER_OF_REMINDING_RATEAPP_PROMPT)
            {
               Cookie.saveCookieVariable(Config.COOKIE_APPRATER_NAME,Config.COOKIE_APPRATER_NAME_DONT_SHOW,true);
            }
         }
         mDoneCallback((this as Object).constructor);
      }
   }
}
