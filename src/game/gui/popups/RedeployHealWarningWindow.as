package game.gui.popups
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.gui.button.ResizingButton;
   import game.states.GameState;
   
   public class RedeployHealWarningWindow extends PopUpWindow
   {
       
      
      private var mButtonClose:ResizingButton;
      
      private var mButtonCancel:DCButton;
      
      public function RedeployHealWarningWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_redeploy_heal_unit");
         super(new _loc1_(),true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonClose = Utils.createResizingButton(mClip,"Button_Skip",this.closeClicked);
         this.mButtonClose.setText(GameState.getText("BUTTON_CONTINUE"));
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc2_:TextField = null;
         mDoneCallback = param1;
         (mClip.getChildByName("Header") as MovieClip).visible = false;
         _loc2_ = mClip.getChildByName("Text_Description") as TextField;
         _loc2_.autoSize = TextFieldAutoSize.CENTER;
         _loc2_.text = GameState.getText("POP_UP_CANNOT_REDEPLOY");
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
