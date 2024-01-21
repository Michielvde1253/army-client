package game.gui
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.events.MouseEvent;
   import game.gui.button.ArmyButton;
   import game.gui.popups.PopUpWindow;
   
   public class ComingSoonDialog extends PopUpWindow
   {
       
      
      private var mButtonClose:ArmyButton;
      
      public function ComingSoonDialog()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_FULLSCREEN_NAME,"popup_comingsoon");
         super(new _loc1_(),true);
         this.mButtonClose = Utils.createBasicButton(mClip,"Button_Cancel",this.closedPressed);
         this.mButtonClose.setVisible(true);
      }
      
      public function Activate(param1:Function) : void
      {
         mDoneCallback = param1;
         doOpeningTransition();
      }
      
      private function closedPressed(param1:MouseEvent) : void
      {
         this.closeDialog();
      }
      
      protected function closeDialog() : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
