package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.states.GameState;
   
   public class SingleAttackWarningWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:ArmyButton;
      
      public function SingleAttackWarningWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_attack_with_multiple");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc2_:StylizedHeaderClip = null;
         var _loc3_:TextField = null;
         mDoneCallback = param1;
         _loc2_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("POPUP_MULTIATTACK_TITLE"));
         _loc3_ = mClip.getChildByName("Text_Description") as TextField;
         _loc3_.text = GameState.getText("POPUP_MULTIATTACK_TEXT");
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
