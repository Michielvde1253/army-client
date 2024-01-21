package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.gui.AutoTextField;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.items.Item;
   import game.missions.Mission;
   import game.net.GameFeedPublisher;
   import game.states.GameState;
   
   public class MissionCompleteWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mMission:Mission;
      
      private var mButtonShare:ResizingButton;
      
      private var mPriceClips:Array;
      
      public function MissionCompleteWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_01_NAME,"popup_mission_complete");
         super(new _loc1_() as MovieClip,true);
      }
      
      public function Activate(param1:Function, param2:Mission) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc4_:TextField = null;
         mDoneCallback = param1;
         this.mMission = param2;
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.skipClicked);
         this.mButtonShare = Utils.createFBIconResizingButton(mClip,"Button_Share",this.shareClicked);
         this.mButtonShare.setText(GameState.getText("MISSION_SHARE_BUTTON"));
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("MISSION_HEADER_GENERIC"));
         _loc4_ = mClip.getChildByName("Text_Title") as TextField;
         _loc4_.defaultTextFormat = _loc4_.getTextFormat();
         _loc4_.text = param2.mTitle;
         _loc4_.mouseEnabled = false;
         (_loc4_ = mClip.getChildByName("Text_Description") as TextField).autoSize = TextFieldAutoSize.CENTER;
         _loc4_.text = this.mMission.mCompletionText;
         _loc4_.wordWrap = true;
         _loc4_ = mClip.getChildByName("Text_Hint") as TextField;
         _loc4_.defaultTextFormat = _loc4_.getTextFormat();
         if(this.mMission.mHintText != null && this.mMission.mHintText.length > 0)
         {
            _loc4_.text = this.mMission.mHintText;
         }
         else
         {
            _loc4_.text = GameState.getText("MISSION_HINT_TEXT");
         }
         _loc4_.autoSize = TextFieldAutoSize.CENTER;
         _loc4_.wordWrap = true;
         _loc4_.mouseEnabled = false;
         _loc4_.visible = false;
         this.initRewards();
         doOpeningTransition();
      }
      
      private function initRewards() : void
      {
         var _loc5_:int = 0;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         this.mPriceClips = new Array();
         this.mPriceClips.push(mClip.getChildByName("Counter_Rewards_1") as MovieClip);
         this.mPriceClips.push(mClip.getChildByName("Counter_Rewards_2") as MovieClip);
         this.mPriceClips.push(mClip.getChildByName("Counter_Rewards_3") as MovieClip);
         var _loc1_:Array = this.mMission.mRewardItems;
         var _loc2_:int = (_loc1_.length - 2) / 2;
         var _loc3_:MovieClip = this.mPriceClips[_loc2_];
         var _loc4_:int = 0;
         while(_loc4_ < this.mPriceClips.length)
         {
            if(_loc4_ == _loc2_)
            {
               (this.mPriceClips[_loc4_] as MovieClip).visible = true;
               _loc5_ = 0;
               while(_loc5_ < _loc1_.length / 2)
               {
                  _loc6_ = _loc3_.getChildByName("Counter_Rewards_" + (_loc5_ + 1)) as MovieClip;
                  new AutoTextField(_loc6_.getChildByName("Text_Title") as TextField).setText((_loc1_[_loc5_ * 2] as Object).mName);
                  (_loc6_.getChildByName("Text_Amount") as TextField).text = _loc1_[_loc5_ * 2 + 1];
                  _loc7_ = _loc6_.getChildByName("Icon") as MovieClip;
                  IconLoader.addIcon(_loc7_,_loc1_[_loc5_ * 2] as Item,this.iconLoaded);
                  _loc5_++;
               }
            }
            else
            {
               (this.mPriceClips[_loc4_] as MovieClip).visible = false;
            }
            _loc4_++;
         }
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,80,80);
      }
      
      private function shareClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = GameFeedPublisher.FEED_MISSION_COMPLETED;
         GameFeedPublisher.publishMessage(_loc2_,null,null,this.closeDialog,this.mMission.mTitle);
         this.closeDialog();
      }
      
      private function sendGiftCallback() : void
      {
         if(Config.DEBUG_MODE)
         {
         }
         this.closeDialog();
      }
      
      private function sendGiftError() : void
      {
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      private function skipClicked(param1:MouseEvent) : void
      {
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
