package game.net
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.Sprite;
   import game.player.Wishlist;
   import game.states.GameState;
   
   public class Friend extends PvPOpponent
   {
       
      
      public var mXp:int;
      
      public var mLevel:int;
      
      public var mSocialLevel:int;
      
      private var mRankLevel:int;
      
      public var mGender:String = "";
      
      public var mUserID:String;
      
      public var mIsPlayer:Boolean;
      
      public var mIsPlaying:Boolean;
      
      public var mIsTutor:Boolean;
      
      public var mIsVisited:Boolean;
      
      public var mHasFlares:Boolean;
      
      private var mWishlist:Wishlist;
      
      public var mActiveMapID:String;
      
      public function Friend(param1:String, param2:String, param3:String, param4:String, param5:int, param6:int, param7:int, param8:int, param9:Boolean, param10:Object, param11:String, param12:Boolean, param13:Boolean, param14:Boolean)
      {
         super(param3,0,1,0);
         mName = param1;
         this.mUserID = param2;
         this.mXp = param5;
         this.mLevel = param6;
         this.mRankLevel = param7;
         this.mSocialLevel = param8;
         this.mIsPlayer = param9;
         this.mActiveMapID = param11;
         this.mIsTutor = param14;
         this.mIsVisited = false;
         mBadassXp = 0;
         mBadassLevel = 1;
         mPvPWins = 0;
         this.mWishlist = new Wishlist();
         this.mWishlist.setupFromServer(param10);
         this.mIsPlaying = param13;
         this.mHasFlares = param12;
         if(param4 == "")
         {
            mPicID = Config.DIR_DATA + "icons/default_avatar.png";
         }
         else
         {
            mPicID = param4;
         }
      }
      
      public function getWishlist() : Wishlist
      {
         if(this == FriendsCollection.smFriends.GetThePlayer())
         {
            return GameState.mInstance.mPlayerProfile.mWishList;
         }
         return this.mWishlist;
      }
      
      public function getRank() : int
      {
         if(this == FriendsCollection.smFriends.GetThePlayer())
         {
            return GameState.mInstance.mPlayerProfile.mRankIdx;
         }
         return this.mRankLevel;
      }
      
      public function getFirstName() : String
      {
         if(mName == null || mName == "")
         {
            return GameState.getText("YOUR_FRIEND");
         }
         var _loc1_:String = mName.substring(0,mName.indexOf(" "));
         if(_loc1_ == "")
         {
            _loc1_ = mName;
         }
         return _loc1_;
      }
      
      public function getPic() : Sprite
      {
         return DCResourceManager.getInstance().get(mPicID) as Sprite;
      }
      
      public function toString() : String
      {
         return "Friend Name=" + mName + " userID=" + this.mUserID + " fbID=" + mFacebookID + " pic=" + mPicID + " score=" + this.mXp;
      }
   }
}
