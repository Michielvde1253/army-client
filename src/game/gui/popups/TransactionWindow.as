package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ResizingButton;
   
   public class TransactionWindow extends PopUpWindow
   {
       
      
      private var mButtonExit:ResizingButton;
      
      public function TransactionWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_error_msg");
         super(new _loc1_() as MovieClip);
      }
      
      public function Activate(param1:Function, param2:String, param3:String) : void
      {
         var _loc4_:StylizedHeaderClip = null;
         var _loc8_:TextFormat = null;
         this.mButtonExit = Utils.createResizingButton(mClip,"Button_Skip",this.okClicked);
         this.mButtonExit.setText("OK");
         mDoneCallback = param1;
         (_loc4_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip)).setText(param2);
         var _loc5_:TextField;
         var _loc6_:int = (_loc5_ = mClip.getChildByName("Text_Description") as TextField).height;
         _loc5_.autoSize = TextFieldAutoSize.CENTER;
         _loc5_.text = param3;
         _loc5_.defaultTextFormat = _loc5_.getTextFormat();
         while(_loc5_.height > _loc6_ && _loc5_.defaultTextFormat.size > 6)
         {
            (_loc8_ = _loc5_.defaultTextFormat).size = int(_loc8_.size) - 1;
            _loc5_.defaultTextFormat = _loc8_;
            _loc5_.text = param3;
         }
         var _loc7_:TextFormat;
         (_loc7_ = _loc5_.getTextFormat()).size = 17;
         _loc5_.defaultTextFormat = _loc7_;
         _loc5_.setTextFormat(_loc7_);
         _loc5_.selectable = true;
      }
      
      private function okClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
