package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.button.ResizingButton;
   import game.states.GameState;
   
   public class ExitConfirmWindow extends PopUpWindow
   {
       
      
      private var mButtonYes:ResizingButton;
      
      private var mButtonNo:ResizingButton;
      
      public function ExitConfirmWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_exit_msg");
         super(new _loc1_() as MovieClip,true);
         this.mButtonNo = Utils.createResizingButton(mClip,"Button_Skip",this.noClicked);
         this.mButtonYes = Utils.createResizingButton(mClip,"Button_Shop",this.yesClicked);
         this.mButtonNo.setText(GameState.getText("BUTTON_NO"));
         this.mButtonYes.setText(GameState.getText("BUTTON_YES"));
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc2_:TextField = null;
         mDoneCallback = param1;
         GameState.mInstance.isExitWindowOpen = true;
         (mClip.getChildByName("Header") as MovieClip).visible = false;
         _loc2_ = mClip.getChildByName("Text_Description") as TextField;
         _loc2_.text = "Do you really want to exit?";
      }
      
      private function yesClicked(param1:MouseEvent) : void
      {
         GameState.mInstance.isExitWindowOpen = false;
         mDoneCallback((this as Object).constructor);
         GameState.mInstance.mHUD.applicationExit();
      }
      
      private function noClicked(param1:MouseEvent) : void
      {
         GameState.mInstance.isExitWindowOpen = false;
         mDoneCallback((this as Object).constructor);
      }
   }
}
