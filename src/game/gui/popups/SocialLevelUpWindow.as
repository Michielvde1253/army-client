package game.gui.popups
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ResizingButton;
   import game.net.GameFeedPublisher;
   import game.states.GameState;
   
   public class SocialLevelUpWindow extends PopUpWindow
   {
       
      
      private var mGame:GameState;
      
      private var mButtonShare:ResizingButton;
      
      private var mRewardsClip:MovieClip;
      
      private var mButtonCancel:DCButton;
      
      private var mPriceClips:Array;
      
      public function SocialLevelUpWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME,"popup_honor_levelup");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.skipClicked);
         this.mButtonShare = Utils.createFBIconResizingButton(mClip,"Button_Share",this.shareClicked);
         this.mButtonShare.setText(GameState.getText("BUTTON_SHARE"));
         this.mRewardsClip = mClip.getChildByName("Rewards") as MovieClip;
         this.mGame = GameState.mInstance;
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc4_:StylizedHeaderClip = null;
         var _loc5_:TextField = null;
         mDoneCallback = param1;
         var _loc2_:int = this.mGame.mPlayerProfile.mSocialLevel;
         var _loc3_:TextField = (mClip.getChildByName("Counter_Level") as MovieClip).getChildByName("Text_Amount") as TextField;
         _loc3_.text = String(_loc2_);
         _loc4_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("SOCIAL_LEVELUP_HEADER"));
         (_loc5_ = mClip.getChildByName("Text_Title") as TextField).autoSize = TextFieldAutoSize.CENTER;
         _loc5_.text = GameState.getText("SOCIAL_LEVELUP_LEVEL_INFO");
         (_loc5_ = mClip.getChildByName("Text_Description") as TextField).text = "\n" + GameState.getText("SOCIAL_LEVELUP_SHARE");
         _loc5_.autoSize = TextFieldAutoSize.CENTER;
         this.setItemCounterValues(new Array());
         (_loc5_ = mClip.getChildByName("Text_Hint") as TextField).text = GameState.getText("CAMPAIGN_WINDOW_INVITE_TIP");
      }
      
      private function setItemCounterValues(param1:Array) : void
      {
         this.mPriceClips = new Array();
         this.mPriceClips.push(mClip.getChildByName("Counter_Rewards_1") as MovieClip);
         this.mPriceClips.push(mClip.getChildByName("Counter_Rewards_2") as MovieClip);
         this.mPriceClips.push(mClip.getChildByName("Counter_Rewards_3") as MovieClip);
         var _loc2_:int = (param1.length - 2) / 2;
         var _loc3_:MovieClip = this.mPriceClips[_loc2_];
         var _loc4_:int = 0;
         while(_loc4_ < this.mPriceClips.length)
         {
            _loc4_++;
         }
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         param1.scaleX = 1 / (param1.width / 30);
         param1.scaleY = 1 / (param1.width / 30);
      }
      
      private function skipClicked(param1:MouseEvent) : void
      {
         this.closeDialog();
      }
      
      private function shareClicked(param1:MouseEvent) : void
      {
         GameFeedPublisher.publishMessage(GameFeedPublisher.FEED_HONOR_LEVEL_UP,String(GameState.mInstance.mPlayerProfile.mSocialLevel),null,this.closeDialog);
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
