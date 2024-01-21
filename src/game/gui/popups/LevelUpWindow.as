package game.gui.popups
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ResizingButton;
   import game.items.ItemManager;
   import game.net.GameFeedPublisher;
   import game.states.GameState;
   
   public class LevelUpWindow extends PopUpWindow
   {
      
      private static const REWARD_ICON_SIZE:int = 50;
       
      
      private var mGame:GameState;
      
      private var mButtonCancel:DCButton;
      
      private var mButtonShare:ResizingButton;
      
      private var mRewardsClip:MovieClip;
      
      private var mOverlayClips:MovieClip;
      
      private var mPriceClips:Array;
      
      public function LevelUpWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME,"popup_levelup");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.skipClicked);
         this.mButtonShare = Utils.createFBIconResizingButton(mClip,"Button_Share",this.shareClicked);
         this.mButtonShare.setText(GameState.getText("BUTTON_SHARE"));
         if(!FeatureTuner.USE_LEVELUP_BACKGROUND_EFFECTS)
         {
            this.mOverlayClips = mClip.getChildByName("overlay_levelup") as MovieClip;
            if(this.mOverlayClips)
            {
               this.mOverlayClips.parent.removeChild(this.mOverlayClips);
            }
         }
         this.mRewardsClip = mClip.getChildByName("Rewards") as MovieClip;
         this.mGame = GameState.mInstance;
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc4_:StylizedHeaderClip = null;
         var _loc5_:TextField = null;
         var _loc7_:TextFormat = null;
         mDoneCallback = param1;
         var _loc2_:int = this.mGame.mPlayerProfile.mLevel;
         var _loc3_:TextField = (mClip.getChildByName("Counter_Level") as MovieClip).getChildByName("Text_Amount") as TextField;
         _loc3_.text = String(_loc2_);
         _loc4_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("LEVELUP_HEADER"));
         (_loc5_ = mClip.getChildByName("Text_Title") as TextField).autoSize = TextFieldAutoSize.CENTER;
         _loc5_.text = GameState.getText("LEVELUP_POPUP_TITLE");
         (_loc5_ = mClip.getChildByName("Text_Description") as TextField).visible = false;
         this.mPriceClips = new Array();
         this.mPriceClips.push(mClip.getChildByName("Counter_Rewards_Energy_Refill") as MovieClip);
         this.mPriceClips.push(mClip.getChildByName("Counter_Rewards_1") as MovieClip);
         this.mPriceClips.push(mClip.getChildByName("Counter_Rewards_2") as MovieClip);
         this.mPriceClips.push(mClip.getChildByName("Counter_Rewards_3") as MovieClip);
         (this.mPriceClips[1] as MovieClip).visible = false;
         (this.mPriceClips[2] as MovieClip).visible = false;
         (this.mPriceClips[3] as MovieClip).visible = false;
         (_loc5_ = (this.mPriceClips[0] as MovieClip).getChildByName("Text_Amount") as TextField).text = GameState.getText("LEVELUP_REWARDS_TEXT");
         _loc5_.autoSize = TextFieldAutoSize.LEFT;
         _loc5_.wordWrap = false;
         var _loc6_:MovieClip = (this.mPriceClips[0] as MovieClip).getChildByName("Icon") as MovieClip;
         IconLoader.addIcon(_loc6_,ItemManager.getItem("Energy","Resource"),this.iconLoaded);
         _loc5_.x = -_loc5_.width / 2 + REWARD_ICON_SIZE;
         _loc6_.x = _loc5_.x + 20 - REWARD_ICON_SIZE;
         (_loc5_ = mClip.getChildByName("Text_Hint") as TextField).text = GameState.getText("LEVELUP_SHARE");
         if(Config.FOR_IPHONE_PLATFORM)
         {
            (_loc7_ = _loc5_.getTextFormat()).size = 17;
            _loc5_.defaultTextFormat = _loc7_;
         }
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,REWARD_ICON_SIZE,REWARD_ICON_SIZE);
      }
      
      private function skipClicked(param1:MouseEvent) : void
      {
         this.closeDialog();
      }
      
      private function shareClicked(param1:MouseEvent) : void
      {
         GameFeedPublisher.publishMessage(GameFeedPublisher.FEED_LEVEL_UP,String(GameState.mInstance.mPlayerProfile.mLevel),null,this.closeDialog);
         this.closeDialog();
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
