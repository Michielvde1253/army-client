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
   
   public class InviteFriendsWindow extends PopUpWindow
   {
      
      private static const VIR_SRC:String = "vir_invite_popup";
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonRequest:ResizingButton;
      
      public function InviteFriendsWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_invite_friends");
         super(new _loc1_() as MovieClip,true);
         this.mButtonRequest = Utils.createResizingButton(mClip,"Button_Share",this.requestClicked);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonRequest.setText(GameState.getText("BUTTON_INVITE"));
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc2_:StylizedHeaderClip = null;
         var _loc3_:TextField = null;
         mDoneCallback = param1;
         _loc2_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("INVITE_FRIENDS_TITLE"));
         _loc3_ = mClip.getChildByName("Text_Description") as TextField;
         _loc3_.text = GameState.getText("INVITE_FRIENDS_DESC");
      }
      
      private function requestClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
         GameState.mInstance.mHUD.toggleSocialDialog(param1);
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
