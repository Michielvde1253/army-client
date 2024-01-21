package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.items.ItemCollectionItem;
   import game.net.GameFeedPublisher;
   import game.states.GameState;
   
   public class CollectionTradedWindow extends PopUpWindow
   {
       
      
      private var mButtonShare:ResizingButton;
      
      private var mButtonCancel:ArmyButton;
      
      private var mCollection:ItemCollectionItem;
      
      public function CollectionTradedWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME,"popup_story");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonShare = Utils.createFBIconResizingButton(mClip,"Button_Share",this.requestClicked);
         this.mButtonShare.setText(GameState.getText("BUTTON_SHARE"));
      }
      
      public function Activate(param1:Function, param2:ItemCollectionItem) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc4_:TextField = null;
         mDoneCallback = param1;
         this.mCollection = param2;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("COLLECTION_TRADED_IN_HEADER"));
         (_loc4_ = mClip.getChildByName("Text_Description") as TextField).text = GameState.getText("COLLECTION_TRADED_IN_DESC",[param2.mName]);
      }
      
      private function closeClicked(param1:MouseEvent = null) : void
      {
         mDoneCallback((this as Object).constructor);
      }
      
      private function requestClicked(param1:MouseEvent) : void
      {
         GameFeedPublisher.publishMessage(GameFeedPublisher.FEED_COLLECTION_TRADED,null,[this.mCollection.mName],this.closeDialog);
      }
      
      protected function closeDialog(param1:Boolean = true) : void
      {
         if(param1)
         {
            mDoneCallback((this as Object).constructor);
         }
      }
   }
}
