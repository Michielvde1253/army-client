package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.actions.RepairPlayerUnitAction;
   import game.characters.PlayerUnit;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.gui.button.ResizingIconButton;
   import game.items.ItemManager;
   import game.net.GameFeedPublisher;
   import game.states.GameState;
   
   public class CorpseMarkerWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonRepair:ResizingIconButton;
      
      private var mButtonHelp:ResizingButton;
      
      private var mTargetUnit:PlayerUnit;
      
      public function CorpseMarkerWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_no_health");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.cancelClicked);
         this.mButtonRepair = Utils.createResizingIconButton(mClip,"Button_Use_Supplies",this.repairClicked);
         this.mButtonRepair.setIcon(ItemManager.getItem("Supplies","Resource"));
         this.mButtonRepair.setText(GameState.getText("BUTTON_REPAIR"));
         this.mButtonHelp = Utils.createFBIconResizingButton(mClip,"Button_Share",this.requestRevive);
         this.mButtonHelp.setText(GameState.getText("BUTTON_ASK_FOR_HELP"));
         this.mButtonHelp.getMovieClip().visible = false;
      }
      
      public function Activate(param1:Function, param2:PlayerUnit) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc4_:TextField = null;
         mDoneCallback = param1;
         this.mTargetUnit = param2;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("ACTION_NOTIFICATION_HEADER"));
         (_loc4_ = mClip.getChildByName("Text_Description") as TextField).text = GameState.getText("ACTION_FRIENDLY_UNIT_CORPSE_MARKER");
         this.mButtonRepair.setText(GameState.getText("HEAL_BUTTON_POPUP",[param2.getHealCostSupplies()]));
      }
      
      private function repairClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
         GameState.mInstance.queueAction(new RepairPlayerUnitAction(this.mTargetUnit));
      }
      
      private function cancelClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
      
      private function requestRevive(param1:MouseEvent) : void
      {
         GameFeedPublisher.publishMessage(GameFeedPublisher.FEED_REQUEST_REVIVE,null,null,this.closeDialog);
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
