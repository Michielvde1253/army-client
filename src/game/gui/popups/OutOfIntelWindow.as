package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.gui.button.ResizingIconButton;
   import game.items.AreaItem;
   import game.items.ItemManager;
   import game.items.ShopItem;
   import game.net.GameFeedPublisher;
   import game.states.GameState;
   
   public class OutOfIntelWindow extends PopUpWindow
   {
       
      
      private var mButtonAskHelp:ResizingButton;
      
      private var mButtonBuy:ResizingIconButton;
      
      private var mButtonCancel:ArmyButton;
      
      private var mArea:AreaItem;
      
      public function OutOfIntelWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_item_locked_intel");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonAskHelp = Utils.createFBIconResizingButton(mClip,"Button_Request",this.askHelpClicked);
         this.mButtonAskHelp.setText(GameState.getText("BUTTON_ASK_FOR_HELP"));
         this.mButtonAskHelp.getMovieClip().visible = false;
         this.mButtonBuy = Utils.createResizingIconButton(mClip,"Button_Submit",this.buyClicked);
      }
      
      public function Activate(param1:Function, param2:Array) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc4_:TextField = null;
         var _loc5_:MovieClip = null;
         mDoneCallback = param1;
         this.mArea = param2[0] as AreaItem;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("MENU_HEADER_OUT_OF_INTEL"));
         (_loc4_ = mClip.getChildByName("Text_Description") as TextField).text = GameState.getText("MENU_DESC_OUT_OF_INTEL",[this.mArea.mCostIntel]);
         _loc4_.autoSize = TextFieldAutoSize.CENTER;
         _loc4_.y -= 10;
         this.mButtonBuy.setText(GameState.getText("BUTTON_SPEND_PREMIUM_CURRENCY",[this.mArea.getUnlockCost()]));
         this.mButtonBuy.setIcon(ItemManager.getItem("Premium","Resource"));
         _loc5_ = mClip.getChildByName("Icon_Condition") as MovieClip;
         _loc5_.x -= 20;
         _loc5_.y += 5;
         IconLoader.addIcon(_loc5_,ItemManager.getItem("Intel","Intel"),this.iconLoaded);
         _loc5_ = mClip.getChildByName("Icon_Target") as MovieClip;
         _loc5_.x += 20;
         _loc5_.y += 5;
         IconLoader.addIcon(_loc5_,param2[0] as ShopItem,this.iconLoaded1);
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,80,80);
      }
      
      public function iconLoaded1(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,80,80);
      }
      
      private function askHelpClicked(param1:MouseEvent) : void
      {
         GameFeedPublisher.launchGiftRequest("OutOfIntel",ItemManager.getItem("Intel","Intel").mId);
         mDoneCallback((this as Object).constructor);
      }
      
      private function buyClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
         GameState.mInstance.externalCallBuyUnlock(this.mArea);
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
