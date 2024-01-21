package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingIconButton;
   import game.items.ItemManager;
   import game.items.ShopItem;
   import game.states.GameState;
   
   public class UnlockItemByLevelWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonUnlock:ResizingIconButton;
      
      private var mItem:ShopItem;
      
      public function UnlockItemByLevelWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_item_locked_level");
         super(new _loc1_(),true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.skipClicked);
         this.mButtonUnlock = Utils.createResizingIconButton(mClip,"Button_Submit",this.unlockClicked);
      }
      
      public function Activate(param1:Function, param2:ShopItem) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc4_:TextField = null;
         var _loc7_:TextFormat = null;
         mDoneCallback = param1;
         this.mItem = param2;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,param2.mName);
         (_loc4_ = mClip.getChildByName("Text_Description") as TextField).text = GameState.getText("MENU_DESC_UNLOCK_ITEM_LEVEL",[param2.mRequiredLevel]);
         if(Config.FOR_IPHONE_PLATFORM)
         {
            (_loc7_ = _loc4_.getTextFormat()).size = 17;
            _loc4_.defaultTextFormat = _loc7_;
         }
         this.mButtonUnlock.setText(GameState.getText("BUTTON_UNLOCK",[param2.getUnlockCost()]));
         this.mButtonUnlock.setIcon(ItemManager.getItem("Premium","Resource"));
         var _loc5_:MovieClip = mClip.getChildByName("Icon_Target") as MovieClip;
         IconLoader.addIcon(_loc5_,param2,this.iconLoaded);
         var _loc6_:MovieClip;
         (_loc4_ = (_loc6_ = mClip.getChildByName("Counter_Level") as MovieClip).getChildByName("Text_Amount") as TextField).text = "" + param2.mRequiredLevel;
      }
      
      private function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,150,150);
      }
      
      private function unlockClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
         GameState.mInstance.externalCallBuyUnlock(this.mItem);
      }
      
      private function skipClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
