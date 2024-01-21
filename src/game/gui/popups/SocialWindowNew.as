package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ArmyButtonSelected;
   import game.gui.button.ResizingButton;
   import game.gui.button.ResizingButtonSelected;
   import game.states.GameState;
   
   public class SocialWindowNew extends PopUpWindow
   {
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonFBConnect:ResizingButtonSelected;
      
      private var mButtonRequest:ResizingButton;
      
      private var mHeader:StylizedHeaderClip;
      
      private const XINIT:Number = -480;
      
      private const YINIT:Number = -165;
      
      private const WIDTH:Number = 889;
      
      private const YOFFSET:Number = 46.65;
      
      private const XOFFSET:Number = 142;
      
      private var mSelectAllBox:MovieClip;
      
      private var mText:MovieClip;
      
      private var mFriendsNames:TextField;
      
      private var selectAllButton:ArmyButtonSelected;
      
      public var socialWindowClip:MovieClip;
      
      private var sourceSocialFriendsListHandler:SocialFriendsListHandler;
      
      private var destinationSocialFriendsListHandler:SocialFriendsListHandler;
      
      private var friendsListJson:Array;
      
      public function SocialWindowNew()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_FULLSCREEN_NAME,"popup_invite");
         this.socialWindowClip = new _loc1_() as MovieClip;
         super(this.socialWindowClip,true);
         this.mButtonRequest = Utils.createResizingButton(mClip,"Button_send",this.sendrequestClicked);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mButtonFBConnect = Utils.createResizingButtonSelected(mClip,"Button_select_all",this.connectFBClicked);
         this.mButtonRequest.setText(GameState.getText("BUTTON_INVITE"));
         this.mButtonFBConnect.setText("Logout");
         if(FeatureTuner.USE_FACEBOOK_CONNECT && FeatureTuner.USE_FACEBOOK_DEBUG)
         {
            this.mButtonFBConnect.setVisible(true);
         }
         else
         {
            this.mButtonFBConnect.setVisible(false);
         }
         this.sourceSocialFriendsListHandler = new SocialFriendsListHandler();
         this.destinationSocialFriendsListHandler = new SocialFriendsListHandler();
         this.createAllButton();
         this.createList();
         this.initiallizeFriendListClips();
      }
      
      public function Activate(param1:Function) : void
      {
         mDoneCallback = param1;
         this.mHeader = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip);
         this.mHeader.setText(GameState.getText("SOCIAL_HEADER"));
      }
      
      public function initiallizeFriendListClips() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Sprite = null;
         this.sourceSocialFriendsListHandler.initiallize(!!this.friendsListJson ? this.friendsListJson : new Array(),this.destinationSocialFriendsListHandler,this.socialWindowClip.sourceClip,6,this.socialWindowClip,0);
         _loc1_ = new Sprite();
         _loc1_.graphics.beginFill(0);
         _loc1_.graphics.drawRect(0,0,428.75,6 * 40 + 8);
         _loc1_.graphics.endFill();
         this.addChild(_loc1_);
         _loc1_.x = this.socialWindowClip.sourceClip.x;
         _loc1_.y = this.socialWindowClip.sourceClip.y;
         this.socialWindowClip.sourceClip.mask = _loc1_;
         this.destinationSocialFriendsListHandler.initiallize(new Array(),this.sourceSocialFriendsListHandler,this.socialWindowClip.destClip,3,this.socialWindowClip,1);
         _loc2_ = new Sprite();
         _loc2_.graphics.beginFill(0);
         _loc2_.graphics.drawRect(0,0,428.75,3 * 40 + 10);
         _loc2_.graphics.endFill();
         this.addChild(_loc2_);
         _loc2_.x = this.socialWindowClip.destClip.x;
         _loc2_.y = this.socialWindowClip.destClip.y;
         this.socialWindowClip.destClip.mask = _loc2_;
      }
      
      private function createAllButton() : void
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_FULLSCREEN_NAME,"Row_Friend");
         this.mSelectAllBox = new _loc1_() as MovieClip;
         this.mText = this.mSelectAllBox.getChildByName("Button_Row") as MovieClip;
         this.mFriendsNames = this.mText.getChildByName("Text_Amount_Resource") as TextField;
         this.mFriendsNames.text = "Select All";
         this.mFriendsNames.textColor = 11184810;
         this.selectAllButton = Utils.createSelectableButton(this.mSelectAllBox,"Button_Row",this.buttonClickHandler);
         this.mSelectAllBox.x = this.XINIT + 3 * this.XOFFSET + 27;
         this.mSelectAllBox.y = this.YINIT - 30;
         addChild(this.mSelectAllBox);
         if(!FeatureTuner.USE_FACEBOOK_CONNECT)
         {
            this.mSelectAllBox.visible = false;
            return;
         }
         if(GameState.mInstance.mAndroidFBConnection.friendsArray == null || GameState.mInstance.mAndroidFBConnection.friendsArray.length == 0)
         {
            this.mSelectAllBox.visible = false;
         }
      }
      
      private function buttonClickHandler(param1:Event) : void
      {
         if(!this.selectAllButton.isSelected())
         {
            this.sourceSocialFriendsListHandler.selectDeselectAllFriends();
         }
         else
         {
            this.destinationSocialFriendsListHandler.selectDeselectAllFriends();
         }
      }
      
      public function createList() : void
      {
         if(!FeatureTuner.USE_FACEBOOK_CONNECT)
         {
            return;
         }
         this.friendsListJson = GameState.mInstance.mAndroidFBConnection.friendsArray;
         if(this.friendsListJson == null || this.friendsListJson.length == 0)
         {
            return;
         }
      }
      
      private function sendrequestClicked(param1:MouseEvent) : void
      {
         this.sourceSocialFriendsListHandler.sendInvitaion();
         mDoneCallback((this as Object).constructor);
      }
      
      private function connectFBClicked(param1:MouseEvent) : void
      {
         GameState.mInstance.mAndroidFBConnection.logout();
         mDoneCallback((this as Object).constructor);
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
