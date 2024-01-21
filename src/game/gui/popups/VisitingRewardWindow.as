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
   import game.items.*;
   import game.states.GameState;
   
   public class VisitingRewardWindow extends PopUpWindow
   {
      
      private static const ITEM_TITLE_W:int = 85;
       
      
      private var mGame:GameState;
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonSkip:ResizingButton;
      
      private var ALLY_REPORTS_PER_DAY:int = 0;
      
      public function VisitingRewardWindow()
      {
         var _loc1_:Class = null;
         if(this.ALLY_REPORTS_PER_DAY > 0)
         {
            _loc1_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME,"popup_visiting_reward_special");
         }
         else
         {
            _loc1_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME,"popup_visiting_reward");
         }
         super(new _loc1_(),true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.skipClicked);
         this.mButtonSkip = Utils.createResizingButton(mClip,"Button_Skip",this.skipClicked);
         this.mButtonSkip.setText(GameState.getText("BUTTON_CONTINUE"));
         this.mGame = GameState.mInstance;
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc2_:StylizedHeaderClip = null;
         var _loc3_:TextField = null;
         mDoneCallback = param1;
         _loc2_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("VISIT_ALLY_REWARD_HEADER"));
         _loc3_ = mClip.getChildByName("Text_Description") as TextField;
         _loc3_.text = GameState.getText("VISIT_ALLY_REWARD_INFO",[this.mGame.mVisitingFriend.mName]);
         _loc3_.autoSize = TextFieldAutoSize.CENTER;
         this.setItemCounterValues(new Array());
      }
      
      private function setItemCounterValues(param1:Array) : void
      {
         var _loc2_:MovieClip = null;
         var _loc7_:AutoTextField = null;
         var _loc8_:TextField = null;
         var _loc9_:MovieClip = null;
         var _loc10_:MovieClip = null;
         var _loc3_:Object = GameState.mConfig.VisitAllyReward["0"];
         var _loc4_:Array = new Array();
         var _loc5_:Item = ItemManager.getItem("Energy","Resource");
         _loc4_.push(_loc5_);
         _loc4_.push(_loc3_.AmountEnergy);
         _loc5_ = ItemManager.getItem("SocialXP","Resource");
         _loc4_.push(_loc5_);
         _loc4_.push(_loc3_.AmountSocialXP);
         _loc5_ = ItemManager.getItem(_loc3_.Item.ID,_loc3_.Item.Type);
         _loc4_.push(_loc5_);
         _loc4_.push(_loc3_.ItemAmount);
         if(this.ALLY_REPORTS_PER_DAY > 0)
         {
            _loc2_ = mClip.getChildByName("Counter_Rewards_Special") as MovieClip;
            _loc5_ = ItemManager.getItem("AllyReport","Intel");
            (_loc7_ = new AutoTextField(_loc2_.getChildByName("Text_Title") as TextField)).setBoxWidth(ITEM_TITLE_W);
            _loc7_.setText(_loc5_.mName);
            (_loc8_ = _loc2_.getChildByName("Text_Amount") as TextField).text = _loc3_.ItemAmount;
            (_loc8_ = _loc2_.getChildByName("Text_Special_Reward") as TextField).text = "Special Reward:";
            _loc8_.autoSize = TextFieldAutoSize.LEFT;
            _loc8_.wordWrap = false;
            if((_loc9_ = _loc2_.getChildByName("Icon") as MovieClip).numChildren != 0)
            {
               _loc9_.removeChildAt(0);
            }
            IconLoader.addIcon(_loc9_,_loc5_,this.iconLoaded);
         }
         _loc2_ = mClip.getChildByName("Counter_Rewards_3") as MovieClip;
         var _loc6_:int = 0;
         while(_loc6_ < 3)
         {
            _loc10_ = _loc2_.getChildByName("Counter_Rewards_" + (_loc6_ + 1)) as MovieClip;
            _loc5_ = _loc4_[_loc6_ * 2] as Item;
            (_loc7_ = new AutoTextField(_loc10_.getChildByName("Text_Title") as TextField)).setBoxWidth(ITEM_TITLE_W);
            _loc7_.setText(_loc5_.mName);
            (_loc8_ = _loc10_.getChildByName("Text_Amount") as TextField).text = _loc4_[_loc6_ * 2 + 1];
            if((_loc9_ = _loc10_.getChildByName("Icon") as MovieClip).numChildren != 0)
            {
               _loc9_.removeChildAt(0);
            }
            IconLoader.addIcon(_loc9_,_loc5_,this.iconLoaded);
            _loc6_++;
         }
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,60,60);
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
