package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.net.Friend;
   import game.net.GameFeedPublisher;
   import game.states.GameState;
   
   public class OutOfSocialEnergyWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonRequest:ResizingButton;
      
      public function OutOfSocialEnergyWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_out_of_social_energy");
         super(new _loc1_() as MovieClip,true);
         this.mButtonRequest = Utils.createFBIconResizingButton(mClip,"Button_Share",this.requestClicked);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonRequest.setText(GameState.getText("BUTTON_SHARE_VISIT"));
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc2_:StylizedHeaderClip = null;
         var _loc3_:TextField = null;
         mDoneCallback = param1;
         _loc2_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("SOCIAL_ENERGY_BOX_TITLE"));
         _loc3_ = mClip.getChildByName("Text_Description") as TextField;
         _loc3_.text = GameState.getText("SOCIAL_ENERGY_BOX_DESC");
      }
      
      private function requestClicked(param1:MouseEvent) : void
      {
         var _loc2_:Array = new Array();
         var _loc3_:Friend = GameState.mInstance.mVisitingFriend;
         if(_loc3_)
         {
            _loc2_["target_id"] = _loc3_.mFacebookID;
         }
         GameFeedPublisher.publishMessage(GameFeedPublisher.FEED_FRIEND_VISITED,null,_loc2_,this.closeDialog);
      }
      
      private function closeClicked(param1:MouseEvent = null) : void
      {
         mDoneCallback((this as Object).constructor);
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
