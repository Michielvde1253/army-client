package game.gui
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gameElements.ConstructionObject;
   import game.gameElements.PlayerBuildingObject;
   import game.gameElements.ResourceBuildingObject;
   import game.gui.button.ResizingButton;
   import game.gui.button.ResizingIconButton;
   import game.gui.popups.PopUpWindow;
   import game.items.ItemManager;
   import game.missions.MissionManager;
   import game.net.Friend;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class HireFriendProductionDialog extends PopUpWindow
   {
      
      private static const PANEL_COUNT:int = 6;
       
      
      private var mProducer:ConstructionObject;
      
      private var mPlayer:GamePlayerProfile;
      
      private var mBuilding:PlayerBuildingObject;
      
      private var mGame:GameState;
      
      private var mMoneyPanel:MovieClip;
      
      private var mButtonCancel:DCButton;
      
      private var mButtonHire:ResizingButton;
      
      private var mButtonBuy:ResizingIconButton;
      
      private var mProductionTimer:MovieClip;
      
      private var mProductionAmount:TextField;
      
      private var mFriendBoosterAmount:int;
      
      public function HireFriendProductionDialog()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_FULLSCREEN_NAME,"popup_hire_friends");
         super(new _loc1_(),true);
         this.mGame = GameState.mInstance;
         this.mPlayer = this.mGame.mPlayerProfile;
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closedPressed);
         this.mButtonHire = Utils.createResizingButton(mClip,"Button_Hire",this.hirePressed);
         this.mButtonHire.setText(GameState.getText("BUTTON_HIRE"));
         this.mButtonBuy = Utils.createResizingIconButton(mClip,"Button_Buy",this.buyPressed);
         this.mButtonBuy.setIcon(ItemManager.getItem("Premium","Resource"));
         var _loc2_:AutoTextField = new AutoTextField(mClip.getChildByName("Text_Description") as TextField);
         _loc2_.setText(GameState.getText("HIRE_FRIEND_WP_DESCRIPTION"));
         _loc2_ = new AutoTextField(mClip.getChildByName("Text_Title") as TextField);
         _loc2_.setText(GameState.getText("HIRE_FRIEND_WP_TITLE"));
         mouseEnabled = true;
      }
      
      public function Activate(param1:PlayerBuildingObject, param2:Function) : void
      {
         var _loc5_:StylizedHeaderClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:Boolean = false;
         var _loc10_:Friend = null;
         var _loc11_:MovieClip = null;
         var _loc12_:MovieClip = null;
         mDoneCallback = param2;
         this.mBuilding = param1;
         var _loc3_:Array = (this.mBuilding as ResourceBuildingObject).getHelpingFriends();
         this.mFriendBoosterAmount = 0;
         var _loc4_:int = this.mBuilding.getProduction().getRewardWater();
         _loc5_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,this.mBuilding.mItem.mName);
         this.mProductionTimer = mClip.getChildByName("Prodution_Timer") as MovieClip;
         var _loc6_:TextField;
         (_loc6_ = this.mProductionTimer.getChildByName("Timer") as TextField).text = this.mBuilding.getTimeLeftCountdown();
         _loc6_.addEventListener(Event.ENTER_FRAME,this.checkTimer);
         this.mButtonBuy.setText(GameState.replaceParameters(GameState.getText("BUTTON_HIRE_PREMIUM"),[this.mBuilding.getProduction().getHireCostPremium()]));
         var _loc7_:int = 0;
         while(_loc7_ < PANEL_COUNT)
         {
            _loc8_ = mClip.getChildByName("Hire_Friend_Slot_0" + (_loc7_ + 1)) as MovieClip;
            _loc9_ = true;
            if(_loc3_)
            {
               if(_loc7_ < _loc3_.length)
               {
                  if(_loc10_ = _loc3_[_loc7_])
                  {
                     (_loc6_ = _loc8_.getChildByName("Text_Description") as TextField).text = _loc10_.mName;
                     _loc11_ = _loc8_.getChildByName("Icon_Thumbnail") as MovieClip;
                     IconLoader.addIconPicture(_loc11_,_loc10_.mPicID,this.centerImage);
                     _loc9_ = false;
                     ++this.mFriendBoosterAmount;
                  }
               }
            }
            if(_loc9_)
            {
               _loc8_.visible = false;
               (_loc6_ = (_loc12_ = mClip.getChildByName("Hire_Friend_Slot_Inactive_0" + (_loc7_ + 1)) as MovieClip).getChildByName("Text_Title") as TextField).text = GameState.getText("HIRE_FRIEND_WP_SLOT_TITLE_" + (_loc7_ + 1));
               (_loc6_ = _loc12_.getChildByName("Item_Value") as TextField).text = "+" + _loc4_;
               (_loc6_ = _loc12_.getChildByName("Text_Description") as TextField).text = GameState.getText("HIRE_FRIEND_SLOT_DESC");
            }
            else
            {
               (_loc6_ = _loc8_.getChildByName("Text_Title") as TextField).text = GameState.getText("HIRE_FRIEND_WP_SLOT_TITLE_" + (_loc7_ + 1));
               (_loc6_ = _loc8_.getChildByName("Item_Value") as TextField).text = "+" + _loc4_;
               _loc8_.visible = true;
            }
            _loc7_++;
         }
         this.mProductionAmount = this.mProductionTimer.getChildByName("Amount") as TextField;
         this.mProductionAmount.text = "" + (_loc4_ + _loc4_ * this.mFriendBoosterAmount);
         if(Boolean(_loc3_) && _loc3_.length < PANEL_COUNT)
         {
            this.mButtonHire.setEnabled(true);
            this.mButtonBuy.setEnabled(false);
         }
         else
         {
            this.mButtonHire.setEnabled(false);
            this.mButtonBuy.setEnabled(false);
         }
         doOpeningTransition();
      }
      
      public function centerImage(param1:Sprite) : void
      {
      }
      
      private function hirePressed(param1:MouseEvent) : void
      {
         this.closeDialog();
      }
      
      private function buyPressed(param1:MouseEvent) : void
      {
      }
      
      private function checkTimer(param1:Event) : void
      {
         var _loc2_:TextField = param1.target as TextField;
         _loc2_.text = this.mBuilding.getTimeLeftCountdown();
      }
      
      private function closedPressed(param1:MouseEvent) : void
      {
         if(MissionManager.modalMissionActive())
         {
            return;
         }
         this.closeDialog();
      }
      
      protected function closeDialog() : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
