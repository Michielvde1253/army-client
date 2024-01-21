package game.gui.popups
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.actions.RedeployPlayerUnitAction;
   import game.characters.PlayerUnit;
   import game.gui.button.ResizingButton;
   import game.isometric.elements.Renderable;
   import game.items.PlayerUnitItem;
   import game.states.GameState;
   
   public class ConfirmRedeploymentWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:DCButton;
      
      private var mButtonYes:ResizingButton;
      
      private var mButtonNo:ResizingButton;
      
      private var mTarget:Renderable;
      
      public function ConfirmRedeploymentWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_confirm_redeploy");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.noClicked);
         this.mButtonNo = Utils.createResizingButton(mClip,"Button_Skip",this.noClicked);
         this.mButtonYes = Utils.createResizingButton(mClip,"Button_Submit",this.yesClicked);
         this.mButtonNo.setText(GameState.getText("BUTTON_NO"));
         this.mButtonYes.setText(GameState.getText("BUTTON_YES"));
      }
      
      public function Activate(param1:Function, param2:Renderable) : void
      {
         var _loc3_:TextField = null;
         mDoneCallback = param1;
         this.mTarget = param2;
         (mClip.getChildByName("Header") as MovieClip).visible = false;
         _loc3_ = mClip.getChildByName("Text_Description") as TextField;
         _loc3_.text = GameState.replaceParameters(GameState.getText("POP_UP_REDEPLOY"),[(this.mTarget.mItem as PlayerUnitItem).mPickupCostSupplies]);
      }
      
      private function yesClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
         GameState.mInstance.queueAction(new RedeployPlayerUnitAction(this.mTarget as PlayerUnit));
      }
      
      private function noClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
