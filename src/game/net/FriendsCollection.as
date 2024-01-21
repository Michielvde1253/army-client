package game.net
{
   import game.states.GameState;
   
   public class FriendsCollection
   {
      
      public static var smFriends:FriendsCollection = new FriendsCollection();
       
      
      private var mPlayingFriends:Array;
      
      private var mNonPlayingFriends:Array;
      
      private var mUidToFriend:Object;
      
      private var mMe:Friend = null;
      
      public function FriendsCollection()
      {
         this.mPlayingFriends = new Array();
         this.mNonPlayingFriends = new Array();
         this.mUidToFriend = new Object();
         super();
      }
      
      public function reset() : void
      {
         this.mPlayingFriends = new Array();
         this.mNonPlayingFriends = new Array();
         this.mUidToFriend = new Object();
         this.mMe = null;
      }
      
      public function AddFriend(param1:String, param2:String, param3:int, param4:int, param5:int, param6:int, param7:Boolean, param8:Object, param9:String, param10:Boolean = false, param11:Boolean = true, param12:Boolean = false) : void
      {
         var _loc13_:Friend = new Friend("",param1,param2,"",param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         if(param7)
         {
            if(this.mMe != null)
            {
               Utils.LogError("isPlayer Error");
            }
            this.mMe = _loc13_;
         }
         else if(param11)
         {
            this.mPlayingFriends.push(_loc13_);
         }
         else
         {
            this.mNonPlayingFriends.push(_loc13_);
         }
         if(this.mUidToFriend[param1] != null)
         {
            Utils.LogError("UID already in collection " + param1);
         }
         this.mUidToFriend[param1] = _loc13_;
      }
      
      public function GetFriend(param1:String) : Friend
      {
         return Friend(this.mUidToFriend[param1]);
      }
      
      public function GetThePlayer() : Friend
      {
         return this.mMe;
      }
      
      public function UpdateMyScore(param1:int, param2:int) : void
      {
         this.mMe.mXp = param1;
         this.mMe.mLevel = param2;
      }
      
      public function getRandomNonPlayingFriend() : Friend
      {
         if(this.mNonPlayingFriends.length == 0)
         {
            return null;
         }
         var _loc1_:int = Math.floor(Math.random() * this.mNonPlayingFriends.length);
         return this.mNonPlayingFriends[_loc1_];
      }
      
      public function getRandomFriend() : Friend
      {
         if(this.mPlayingFriends.length == 0)
         {
            return null;
         }
         var _loc1_:int = Math.floor(Math.random() * this.mPlayingFriends.length);
         return this.mPlayingFriends[_loc1_];
      }
      
      public function AddToScreen() : void
      {
         if(!GameState.mInstance.mHUD)
         {
            return;
         }
      }
      
      public function getPlayingFriendCount() : int
      {
         return this.mPlayingFriends.length;
      }
      
      public function getPlayingFriends() : Array
      {
         return this.mPlayingFriends;
      }
      
      public function getNonPlayingFriendCount() : int
      {
         return this.mNonPlayingFriends.length;
      }
      
      public function getPlayingFriendsExcludingTutor() : Array
      {
         var _loc2_:Friend = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.mPlayingFriends)
         {
            if(!_loc2_.mIsTutor)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
   }
}
