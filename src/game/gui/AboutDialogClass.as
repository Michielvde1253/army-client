package game.gui
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import game.gui.button.ArmyButton;
   import game.gui.popups.PopUpWindow;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class AboutDialogClass extends PopUpWindow
   {
      
      public static var mInstance:AboutDialogClass;
       
      
      private var mButtonClose:ArmyButton;
      
      private var mButtonBack:ArmyButton;
      
      private var aboutTextField:TextField;
      
      private var scrollTab:MovieClip;
      
      private var scrollPane:MovieClip;
      
      private var bounds:Rectangle;
      
      private var scrolling:Boolean;
      
      private var aboutHeader:TextField;
      
      public function AboutDialogClass()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_MAIN_MENU_NAME,"AboutDialog");
         super(new _loc1_());
         mInstance = this;
         this.aboutHeader = mClip.getChildByName("Text_Title") as TextField;
         this.aboutHeader.text = GameState.getText("ABOUT_HEADER_TEXT");
         var _loc2_:TextField = mClip.getChildByName("Text_Background_01") as TextField;
         var _loc3_:TextField = mClip.getChildByName("Text_Background_02") as TextField;
         if(_loc2_)
         {
            _loc2_.text = this.aboutHeader.text;
         }
         if(_loc3_)
         {
            _loc3_.text = this.aboutHeader.text;
         }
         this.mButtonClose = Utils.createBasicButton(mClip,"Button_close",this.closePressed);
         this.mButtonClose.setVisible(false);
         this.mButtonBack = Utils.createBasicButton(mClip,"Button_back",this.closePressed);
         this.mButtonBack.setText(GameState.getText("BACK_BUTTON_TEXT"),"Text_Title");
         this.mButtonBack.setVisible(true);
         this.scrollPane = mClip.getChildByName("Scrollbar") as MovieClip;
         this.scrollTab = this.scrollPane.getChildByName("scrollbar_slider") as MovieClip;
         this.aboutTextField = mClip.getChildByName("Title_text") as TextField;
         this.bounds = new Rectangle(this.scrollTab.x,this.scrollTab.y,0,mClip.height - this.scrollTab.height);
         this.scrollTab.addEventListener(MouseEvent.MOUSE_DOWN,this.startScroll);
         mClip.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         this.scrolling = false;
         this.aboutTextField.visible = true;
         this.aboutTextField.mouseEnabled = true;
         this.aboutTextField.selectable = false;
         this.aboutTextField.x += 5;
         this.aboutTextField.y += 20;
         var _loc4_:String = GameState.getText("ABOUT_TEXT",[Config.getAppVersion()]);
         this.aboutTextField.multiline = true;
         this.aboutTextField.wordWrap = true;
         this.aboutTextField.text = _loc4_;
         if(this.aboutTextField.textHeight < this.aboutTextField.height)
         {
            this.scrollPane.visible = false;
            this.scrollTab.visible = false;
         }
      }
      
      public function Activate(param1:Function) : void
      {
         mDoneCallback = param1;
         doOpeningTransition();
      }
      
      private function startScroll(param1:Event) : void
      {
         this.scrolling = true;
         this.scrollTab.startDrag(false,this.bounds);
      }
      
      private function stopScroll(param1:Event) : void
      {
         this.scrolling = false;
         this.scrollTab.stopDrag();
      }
      
      private function enterHandler(param1:Event) : void
      {
      }
      
      public function closePressed(param1:MouseEvent) : void
      {
         if(ArmySoundManager.getInstance().isSfxOn())
         {
            ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_CLICK);
         }
         this.scrollTab.removeEventListener(MouseEvent.MOUSE_DOWN,this.startScroll);
         mClip.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         mDoneCallback((this as Object).constructor);
         GameState.mInstance.mHUD.openHelpScreen();
      }
   }
}
