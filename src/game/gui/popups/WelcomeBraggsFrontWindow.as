package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.gui.DisplayObjectTransition;
   import game.gui.IconAdapter;
   import game.gui.IconLoader;
   import game.gui.button.ResizingButton;
   import game.missions.Mission;
   import game.states.GameState;
   
   public class WelcomeBraggsFrontWindow extends PopUpWindow
   {
       
      
      private var mMission:Mission;
      
      private var mSpeechBubble:MovieClip;
      
      private var mCharacter:MovieClip;
      
      private var mButtonOk:ResizingButton;
      
      public function WelcomeBraggsFrontWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME,"popup_welcome");
         super(new _loc1_());
         mCloseTransitionName = DisplayObjectTransition.FADE_DISAPPEAR;
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc2_:TextField = mClip.getChildByName("Text_Title") as TextField;
         _loc2_.visible = false;
         mDoneCallback = param1;
         var _loc3_:TextField = mClip.getChildByName("Text_Description") as TextField;
         _loc3_.text = GameState.mInstance.mMapData.mMapSetupData.BraggFrontText;
         _loc3_.autoSize = TextFieldAutoSize.CENTER;
         this.mButtonOk = Utils.createResizingButton(mClip,"Button_Submit",this.okClicked);
         this.mButtonOk.setText(GameState.getText("BUTTON_CONTINUE"));
         this.installCharacter();
         doOpeningTransition();
      }
      
      override public function alignToScreen() : void
      {
         x = GameState.mInstance.getStageWidth() / 2;
         y = GameState.mInstance.getStageHeight() - Config.SCREEN_HEIGHT / 2;
      }
      
      private function installCharacter() : void
      {
         if(Boolean(this.mCharacter) && Boolean(this.mCharacter.parent))
         {
            this.mCharacter.parent.removeChild(this.mCharacter);
         }
         var _loc1_:MovieClip = mClip.getChildByName("Icon_Character") as MovieClip;
         var _loc2_:Array = (GameState.mConfig.Character.Mutton.Graphic as String).split("/");
         IconLoader.addIcon(_loc1_,new IconAdapter(_loc2_[2],_loc2_[0] + "/" + _loc2_[1]));
      }
      
      private function okClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
