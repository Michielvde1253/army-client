package game.gui.popups
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.gui.StylizedHeaderClip;
   import game.states.GameState;
   
   public class EnemyOutOfRangeWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:DCButton;
      
      public function EnemyOutOfRangeWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_enemy_too_far");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
      }
      
      public function Activate(param1:Function) : void
      {
         var _loc2_:StylizedHeaderClip = null;
         var _loc3_:TextField = null;
         mDoneCallback = param1;
         _loc2_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("CANNOT_ATTACK_HEADER"));
         _loc3_ = mClip.getChildByName("Text_Description") as TextField;
         _loc3_.autoSize = TextFieldAutoSize.CENTER;
         _loc3_.text = GameState.getText("CANNOT_ATTACK_TEXT");
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
