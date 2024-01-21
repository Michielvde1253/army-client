package game.gui
{
   import com.dchoc.GUI.DCButton;
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
   
   public class HelpDialogClass extends PopUpWindow
   {
       
      
      private var mButtonAbout:ArmyButton;
      
      private var mButtonBack:ArmyButton;
      
      private var helpTextField:TextField;
      
      private var scrollTab:MovieClip;
      
      private var scrollPane:MovieClip;
      
      private var bounds:Rectangle;
      
      private var scrolling:Boolean;
      
      private var helpHeader:TextField;
      
      public function HelpDialogClass()
      {
         var _loc2_:TextField = null;
         var _loc3_:TextField = null;
         var _loc4_:String = null;
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_MAIN_MENU_NAME,"HelpDialog");
         super(new _loc1_());
         if(PauseDialog.mPauseScreenState == PauseDialog.STATE_HELP_CLICK)
         {
            this.mButtonAbout = this.addButton(mClip,"Button_about_us",this.tabPressed);
            this.mButtonAbout.setVisible(true);
            this.mButtonBack = this.addButton(mClip,"Button_back",this.tabPressed);
            this.mButtonBack.setVisible(true);
            this.mButtonAbout.setText(GameState.getText("ABOUT_BUTTON_TEXT"),"Text_Title");
            this.mButtonBack.setText(GameState.getText("BACK_BUTTON_TEXT"),"Text_Title");
            this.helpHeader = mClip.getChildByName("Text_Title") as TextField;
            this.helpHeader.text = GameState.getText("HELP_HEADER_TEXT");
            _loc2_ = mClip.getChildByName("Text_Background_01") as TextField;
            _loc3_ = mClip.getChildByName("Text_Background_02") as TextField;
            if(_loc2_)
            {
               _loc2_.text = this.helpHeader.text;
            }
            if(_loc3_)
            {
               _loc3_.text = this.helpHeader.text;
            }
            this.scrollPane = mClip.getChildByName("Scrollbar") as MovieClip;
            this.scrollTab = this.scrollPane.getChildByName("scrollbar_slider") as MovieClip;
            this.helpTextField = mClip.getChildByName("Title_text") as TextField;
            this.bounds = new Rectangle(this.scrollTab.x,this.scrollTab.y,0,mClip.height - this.scrollTab.height);
            this.scrollTab.addEventListener(MouseEvent.MOUSE_DOWN,this.startScroll);
            mClip.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
            mClip.addEventListener(Event.ENTER_FRAME,this.enterHandler);
            this.scrolling = false;
            this.helpTextField.visible = true;
            this.helpTextField.mouseEnabled = true;
            this.helpTextField.selectable = false;
            this.helpTextField.multiline = true;
            this.helpTextField.wordWrap = true;
            _loc4_ = GameState.getText("HELP_TEXT");
            this.helpTextField.text = _loc4_;
            if(this.helpTextField.textHeight < this.helpTextField.height)
            {
               this.scrollPane.visible = false;
               this.scrollTab.visible = false;
            }
            this.helpTextField.addEventListener(MouseEvent.CLICK,this.jumpToDescription);
            this.helpTextField.addEventListener(MouseEvent.MOUSE_DOWN,this.startScroll);
            this.helpTextField.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         }
      }
      
      private function jumpToDescription(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(param1.type == MouseEvent.CLICK)
         {
            _loc2_ = this.helpTextField.getLineIndexAtPoint(this.helpTextField.mouseX,this.helpTextField.mouseY);
            if(_loc2_ <= 6)
            {
               _loc3_ = _loc2_ + 1;
               while(_loc3_ < this.helpTextField.numLines)
               {
                  if((_loc4_ = this.helpTextField.getLineText(_loc3_)) == this.helpTextField.getLineText(_loc2_))
                  {
                     this.helpTextField.scrollV = _loc3_;
                     _loc5_ = Math.round(this.helpTextField.scrollV * (mClip.height - this.scrollTab.height) / this.helpTextField.maxScrollV + this.bounds.y);
                     this.scrollTab.y = _loc5_;
                     break;
                  }
                  _loc3_++;
               }
            }
         }
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
         if(this.scrolling == true)
         {
            this.helpTextField.scrollV = Math.round((this.scrollTab.y - this.bounds.y) / (mClip.height - this.scrollTab.height) * this.helpTextField.maxScrollV);
         }
      }
      
      private function addButton(param1:MovieClip, param2:String, param3:Function) : ArmyButton
      {
         var _loc4_:MovieClip;
         if((_loc4_ = param1.getChildByName(param2) as MovieClip) != null)
         {
            _loc4_.mouseEnabled = true;
            return new ArmyButton(param1,_loc4_,DCButton.BUTTON_TYPE_ICON,null,null,null,null,null,param3);
         }
         param3 = null;
         return null;
      }
      
      public function Activate(param1:Function) : void
      {
         mDoneCallback = param1;
         doOpeningTransition();
      }
      
      private function tabPressed(param1:MouseEvent) : void
      {
         if(ArmySoundManager.getInstance().isSfxOn())
         {
            ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_CLICK);
         }
         if(param1.target == this.mButtonAbout.getMovieClip())
         {
            mDoneCallback((this as Object).constructor);
            GameState.mInstance.mHUD.openAboutScreen();
         }
         else if(param1.target == this.mButtonBack.getMovieClip())
         {
            this.scrollTab.removeEventListener(MouseEvent.MOUSE_DOWN,this.startScroll);
            mClip.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
            mClip.removeEventListener(Event.ENTER_FRAME,this.enterHandler);
            this.helpTextField.removeEventListener(MouseEvent.MOUSE_DOWN,this.startScroll);
            this.helpTextField.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
            this.helpTextField.removeEventListener(MouseEvent.CLICK,this.jumpToDescription);
            mDoneCallback((this as Object).constructor);
            PauseDialog.mPauseScreenPreviousState = PauseDialog.STATE_HELP_CLICK;
            GameState.mInstance.mHUD.openPauseScreen();
         }
      }
   }
}
