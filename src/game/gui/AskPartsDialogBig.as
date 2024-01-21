package game.gui
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import game.items.ItemManager;
   import game.states.GameState;
   
   public class AskPartsDialogBig extends AskPartsDialog
   {
       
      
      public function AskPartsDialogBig()
      {
         var _loc2_:StylizedHeaderClip = null;
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_01_NAME,"popup_finish_building");
         super(new _loc1_(),true);
         PANEL_COUNT = 6;
         mGame = GameState.mInstance;
         mPlayer = mGame.mPlayerProfile;
         _loc2_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip);
         _loc2_.setText(GameState.getText("MENU_HEADER_FINISH_BUILDING"));
         mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",closedPressed);
         mButtonInstantBuild = Utils.createResizingIconButton(mClip,"Button_Buy",instaCompletePressed);
         mButtonInstantBuild.setIcon(ItemManager.getItem("Premium","Resource"));
         mButtonFinish = Utils.createResizingButton(mClip,"Button_Build",completePressed);
         mButtonFinish.setText(GameState.getText("BUTTON_FINISH"));
         mTextDescription = mClip.getChildByName("Text_Description") as TextField;
         mTextDescription.text = GameState.getText("MATERIALS_DESC_HINT");
         mouseEnabled = true;
         var _loc3_:int = 0;
         while(_loc3_ < PANEL_COUNT)
         {
            mPanels[_loc3_] = new AskPartsItemPanel(mClip.getChildByName("Frame_Ingredient_" + (_loc3_ + 1)) as MovieClip,this);
            _loc3_++;
         }
      }
   }
}
