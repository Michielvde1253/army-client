package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.states.GameState;
   
   public class FreeUnitReceivedWindow extends PopUpWindow
   {
       
      
      private var mButtonInventory:ResizingButton;
      
      private var mButtonCancel:ArmyButton;
      
      private var mInventoryCallBack:Function;
      
      public function FreeUnitReceivedWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_free_units_reward");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonInventory = Utils.createResizingButton(mClip,"Button_Shop",this.inventoryClicked);
         this.mButtonInventory.setText(GameState.getText("FREE_UNITS_POPUP_BUTTON"));
      }
      
      public function Activate(param1:Function, param2:Function) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc4_:TextField = null;
         mDoneCallback = param1;
         this.mInventoryCallBack = param2;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("FREE_UNITS_POPUP_TITLE"));
         (_loc4_ = mClip.getChildByName("Text_Description") as TextField).text = GameState.getText("FREE_UNITS_POPUP_DESC");
      }
      
      private function inventoryClicked(param1:MouseEvent) : void
      {
         this.mInventoryCallBack(null);
         mDoneCallback((this as Object).constructor);
      }
      
      private function closeClicked(param1:MouseEvent) : void
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
