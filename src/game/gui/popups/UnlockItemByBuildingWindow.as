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
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.ShopItem;
   import game.states.GameState;
   
   public class UnlockItemByBuildingWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonUnlock:ResizingIconButton;
      
      private var mItem:ShopItem;
      
      public function UnlockItemByBuildingWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_item_locked");
         super(new _loc1_(),true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.skipClicked);
         this.mButtonUnlock = Utils.createResizingIconButton(mClip,"Button_Submit",this.unlockClicked);
      }
      
      public function Activate(param1:Function, param2:ShopItem) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         mDoneCallback = param1;
         this.mItem = param2;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,param2.mName);
         var _loc5_:TextFormat;
         var _loc4_:TextField;
         (_loc5_ = (_loc4_ = mClip.getChildByName("Text_Description") as TextField).defaultTextFormat).size = int(_loc5_.size) + 5;
         _loc4_.defaultTextFormat = _loc5_;
         _loc4_.text = GameState.getText("MENU_DESC_UNLOCK_ITEM_BUILDING",[param2.mRequiredBuilding.Name]);
         this.mButtonUnlock.setText(GameState.getText("BUTTON_UNLOCK",[param2.getUnlockCost()]));
         this.mButtonUnlock.setIcon(ItemManager.getItem("Premium","Resource"));
         var _loc6_:MovieClip = mClip.getChildByName("Icon_Target") as MovieClip;
         IconLoader.addIcon(_loc6_,param2,this.iconLoaded);
         _loc6_ = mClip.getChildByName("Icon_Condition") as MovieClip;
         var _loc7_:Item = ItemManager.getItem(param2.mRequiredBuilding.ID,param2.mRequiredBuilding.Type);
         IconLoader.addIcon(_loc6_,_loc7_,this.iconLoaded);
      }
      
      private function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,70,70);
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
