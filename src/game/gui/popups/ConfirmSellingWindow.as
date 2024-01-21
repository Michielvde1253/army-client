package game.gui.popups
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import game.gameElements.HFEObject;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ResizingButton;
   import game.isometric.elements.Renderable;
   import game.items.ItemManager;
   import game.items.MapItem;
   import game.states.GameState;
   
   public class ConfirmSellingWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:DCButton;
      
      private var mButtonYes:ResizingButton;
      
      private var mButtonNo:ResizingButton;
      
      private var mSellCallback:Function;
      
      private var mTarget:Renderable;
      
      public function ConfirmSellingWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_confirm_selling");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.noClicked);
         this.mButtonNo = Utils.createResizingButton(mClip,"Button_Skip",this.noClicked);
         this.mButtonYes = Utils.createResizingButton(mClip,"Button_Submit",this.yesClicked);
         this.mButtonNo.setText(GameState.getText("BUTTON_NO"));
         this.mButtonYes.setText(GameState.getText("BUTTON_YES"));
      }
      
      public function Activate(param1:Function, param2:Function, param3:Renderable) : void
      {
         var _loc4_:StylizedHeaderClip = null;
         var _loc6_:TextField = null;
         mDoneCallback = param1;
         this.mSellCallback = param2;
         this.mTarget = param3;
         _loc4_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("SELL_TITLE"));
         var _loc5_:MapItem = param3.mItem as MapItem;
         if(param3 is HFEObject)
         {
            _loc5_ = ItemManager.getItem("Plot","HFEPlot") as MapItem;
         }
         var _loc7_:TextFormat;
         (_loc7_ = (_loc6_ = mClip.getChildByName("Text_Description") as TextField).defaultTextFormat).size = int(_loc7_.size) + 5;
         _loc6_.defaultTextFormat = _loc7_;
         _loc6_.text = GameState.replaceParameters(GameState.getText("MENU_DESC_CONFIRM_SELLING"),[_loc5_.mName,_loc5_.mDisbandRewardMoney]);
         var _loc8_:MovieClip = mClip.getChildByName("icon_placeholder") as MovieClip;
         IconLoader.addIcon(_loc8_,_loc5_,this.iconLoaded);
         _loc8_.x = _loc6_.x + _loc6_.width / 2;
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,120,120);
      }
      
      override public function close() : void
      {
         super.close();
         this.mSellCallback = null;
      }
      
      private function yesClicked(param1:MouseEvent) : void
      {
         var _loc2_:Function = this.mSellCallback;
         mDoneCallback((this as Object).constructor);
         _loc2_(this.mTarget);
         _loc2_ = null;
      }
      
      private function noClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
         this.mSellCallback = null;
      }
   }
}
