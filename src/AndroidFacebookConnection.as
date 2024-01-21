package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import game.net.GameFeedPublisher;
   import game.states.GameState;
   
   public class AndroidFacebookConnection
   {
       
      
      private const STATE_NONE:int = -1;
      
      private const STATE_GET_FRIENDS:int = 0;
      
      private const STATE_INVITE_FRIEND:int = 1;
      
      private const STATE_POST_TO_WALL:int = 2;
      
      private const FB_APP_KEY:String = "307790872660751";
      
      public var friendsArray:Array;
      
      private var mState:int;
      
      private var tempFriendsArray:Array;
      
      private var mTitle:String;
      
      private var mCaption:String;
      
      public var mUserName:String;
      
      private var emptyArray:Array;
      
      public function AndroidFacebookConnection()
      {
         super();
      }
      
      private function createSimpleButton(param1:String, param2:SimpleButton) : SimpleButton
      {
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         var _loc5_:TextFormat = null;
         var _loc6_:TextField = null;
         _loc3_ = new Sprite();
         _loc3_.graphics.beginFill(16777215);
         _loc3_.graphics.drawRoundRect(0,0,106,30,30,30);
         _loc3_.graphics.endFill();
         (_loc4_ = new Sprite()).graphics.beginFill(0);
         _loc4_.graphics.drawRoundRect(3,3,100,24,27,27);
         _loc4_.graphics.endFill();
         (_loc5_ = new TextFormat()).color = 16777215;
         _loc5_.font = "Verdana";
         _loc5_.size = 17;
         _loc5_.align = "center";
         (_loc6_ = new TextField()).text = param1;
         _loc6_.x = 0;
         _loc6_.y = 0;
         _loc6_.width = _loc3_.width;
         _loc6_.height = _loc3_.height;
         _loc6_.setTextFormat(_loc5_);
         var _loc7_:MovieClip;
         (_loc7_ = new MovieClip()).addChild(_loc3_);
         _loc7_.addChild(_loc4_);
         _loc7_.addChild(_loc6_);
         param2 = new SimpleButton();
         param2.upState = _loc7_;
         param2.overState = _loc7_;
         param2.downState = param2.upState;
         param2.hitTestState = param2.upState;
         return param2;
      }
      
      public function init() : void
      {
      }
      
      public function isSessionValid() : Boolean
      {
		  return false;
      }
      
      private function login() : void
      {
      }
      
      public function getFriends() : void
      {
      }
      
      private function getfriendsCallBack(param1:Object) : void
      {
      }
      
      private function getUserInfoCallBack(param1:Object) : void
      {
      }
      
      public function inviteFriend(param1:Array) : void
      {
      }
      
      private function inviteFriendCallback(param1:Object) : void
      {
      }
      
      public function publish(param1:String, param2:String) : void
      {
      }
      
      private function publishCallback(param1:Object) : void
      {
      }
      
      public function logout() : void
      {
      }
      
      private function logoutCallback(param1:Object) : void
      {
      }
   }
}
