package game.gui
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.gui.button.ArmyButton;
   import game.gui.popups.PopUpWindow;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class NotificationDialogClass extends PopUpWindow
   {
      
      public static var mInstance:NotificationDialogClass;
       
      
      private var mButtonClose:ArmyButton;
      
      private var mButtonBack:ArmyButton;
      
      private var notificationTextField:TextField;
      
      private var scrollTab:MovieClip;
      
      private var scrollPane:MovieClip;
      
      private var bounds:Rectangle;
      
      private var scrolling:Boolean;
      
      private var notificationHeader:TextField;
      
      public function NotificationDialogClass()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_MAIN_MENU_NAME,"NotificationDialog");
         super(new _loc1_());
         mInstance = this;
         this.notificationHeader = mClip.getChildByName("Text_Title") as TextField;
         this.notificationHeader.autoSize = TextFieldAutoSize.CENTER;
         this.notificationHeader.text = GameState.getText("NOTIFICATIONS_HEADER_TEXT");
         var _loc2_:TextField = mClip.getChildByName("Text_Background_01") as TextField;
         var _loc3_:TextField = mClip.getChildByName("Text_Background_02") as TextField;
         if(_loc2_)
         {
            _loc2_.autoSize = TextFieldAutoSize.CENTER;
            _loc2_.text = this.notificationHeader.text;
         }
         if(_loc3_)
         {
            _loc3_.autoSize = TextFieldAutoSize.CENTER;
            _loc3_.text = this.notificationHeader.text;
         }
         this.mButtonClose = Utils.createBasicButton(mClip,"Button_close",this.closePressed);
         this.mButtonClose.setVisible(false);
         this.mButtonBack = Utils.createBasicButton(mClip,"Button_back",this.closePressed);
         this.mButtonBack.setVisible(true);
         this.scrollPane = mClip.getChildByName("Scrollbar") as MovieClip;
         this.scrollTab = this.scrollPane.getChildByName("scrollbar_slider") as MovieClip;
         this.notificationTextField = mClip.getChildByName("Title_text") as TextField;
         this.bounds = new Rectangle(this.scrollTab.x,this.scrollTab.y,0,mClip.height - this.scrollTab.height);
         this.scrollTab.addEventListener(MouseEvent.MOUSE_DOWN,this.startScroll);
         mClip.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         this.scrolling = false;
         this.notificationTextField.visible = true;
         this.notificationTextField.mouseEnabled = true;
         this.notificationTextField.selectable = false;
         var _loc4_:String = GameState.getText("NOTIFICATION_TEXT");
         this.notificationTextField.multiline = true;
         this.notificationTextField.wordWrap = true;
         this.notificationTextField.text = _loc4_;
         if(this.notificationTextField.textHeight < this.notificationTextField.height)
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
         GameState.mInstance.mHUD.openSettingsScreen();
      }
   }
}
