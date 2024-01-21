package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.net.GameFeedPublisher;
   import game.states.GameState;
   
   public class AskReviveWindow extends PopUpWindow
   {
       
      
      private var mButtonRequest:ResizingButton;
      
      private var mButtonCancel:ArmyButton;
      
      public function AskReviveWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_revive_crops");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonRequest = Utils.createFBIconResizingButton(mClip,"Button_Share",this.requestClicked);
         this.mButtonRequest.setText(GameState.getText("BUTTON_ASK_FOR_HELP"));
         this.mButtonRequest.getMovieClip().visible = false;
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc2_:StylizedHeaderClip = null;
         var _loc3_:TextField = null;
         mDoneCallback = param1;
         _loc2_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("WITHERED_FRIEND_TITLE"));
         _loc3_ = mClip.getChildByName("Text_Description") as TextField;
         _loc3_.text = GameState.getText("WITHERED_FRIEND_DESC");
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
      
      private function requestClicked(param1:MouseEvent) : void
      {
         GameFeedPublisher.publishMessage(GameFeedPublisher.FEED_REQUEST_REVIVE_DROP_ZONE,null,null,this.closeDialog);
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
