package game.gui.popups
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ResizingButton;
   import game.missions.Mission;
   import game.states.GameState;
   
   public class TipWindow extends PopUpWindow
   {
       
      
      private var mMission:Mission;
      
      private var mButtonCancel:DCButton;
      
      private var mButtonSkip:ResizingButton;
      
      private var mTipImage:MovieClip;
      
      public function TipWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME,"popup_ad");
         super(new _loc1_());
      }
      
      public function Activate(param1:Function, param2:Mission) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc4_:MovieClip = null;
         mDoneCallback = param1;
         this.mMission = param2;
         param2.setTargetPopup(this);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.okClicked);
         this.mButtonSkip = Utils.createResizingButton(mClip,"Button_Skip",this.okClicked);
         this.mButtonSkip.setText(GameState.getText("BUTTON_CONTINUE"));
         x = GameState.mInstance.getStageWidth() / 2;
         y = GameState.mInstance.getStageHeight() / 2;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip);
         _loc3_.setText(param2.mTitle);
         (mClip.getChildByName("Text_Description") as TextField).autoSize = TextFieldAutoSize.CENTER;
         (mClip.getChildByName("Text_Description") as TextField).text = param2.mDescription;
         if(param2.mTipGraphics)
         {
            _loc4_ = mClip.getChildByName("Image") as MovieClip;
            IconLoader.addIconPicture(_loc4_,Config.DIR_DATA + param2.mTipGraphics);
         }
      }
      
      private function okClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
