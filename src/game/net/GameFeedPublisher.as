package game.net
{
   import flash.external.ExternalInterface;
   import game.player.RankManager;
   import game.states.GameState;
   import game.utils.WebUtils;
   
   public class GameFeedPublisher
   {
      
      private static const VIR_SRC:String = "vir_";
      
      private static const VIR_REQUEST_GIFT:String = "gift_req_button";
      
      public static const FEED_FRIEND_VISITED:String = "FriendVisited";
      
      public static const FEED_COLLECTION_TRADED:String = "CollectionComplete";
      
      public static const FEED_WISHLIST:String = "WishList";
      
      public static const FEED_LEVEL_UP:String = "LevelUp";
      
      public static const FEED_RANK_UP:String = "RankUp";
      
      public static const FEED_HONOR_LEVEL_UP:String = "HonorLevelUp";
      
      public static const FEED_MISSION_COMPLETED:String = "MissionCompleted";
      
      public static const FEED_REQUEST_REVIVE:String = "RequestRevive";
      
      public static const FEED_REQUEST_SUPPLIES:String = "RequestSupplies";
      
      public static const FEED_REQUEST_ENERGY:String = "RequestEnergy";
      
      public static const FEED_REQUEST_REVIVE_DROP_ZONE:String = "RequestReviveDropZone";
      
      public static const FEED_FLARE_SET_HEAL:String = "FlareSetHeal";
      
      public static const FEED_FLARE_SET_ATTACK:String = "FlareSetAttack";
      
      public static const FEED_FLARE_SET_SUPPLIES:String = "FlareSetSupplies";
      
      public static const FEED_SPAWNING_BEACON:String = "EnemySmokeHelp";
      
      public static const FEED_PVP_WIN:String = "PvpWin";
      
      public static const FEED_PVP_LOSE:String = "PvpLose";
      
      private static var mNextPostId:uint = 0;
      
      private static var mDoneCallback:Function = null;
       
      
      public function GameFeedPublisher()
      {
         super();
      }
      
      public static function init(param1:ServerCall) : void
      {
         if(param1)
         {
            setNextPostId(param1.mData.stream_post_id);
         }
      }
      
      private static function getPlayerName() : String
      {
         return GameState.mInstance.mAndroidFBConnection.mUserName;
      }
      
      private static function getPlayerRank() : String
      {
         var _loc1_:Friend = FriendsCollection.smFriends.GetThePlayer();
         if(_loc1_)
         {
            return RankManager.getNameByIndex(_loc1_.getRank());
         }
         return "Commander";
      }
      
      private static function findNameForGift(param1:String) : String
      {
         var _loc3_:Object = null;
         var _loc2_:Object = GameState.mConfig.Gift;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.ID == param1)
            {
               return _loc3_.Name;
            }
         }
         return null;
      }
      
      private static function findNameForRequestReason(param1:String) : String
      {
         var _loc3_:Object = null;
         var _loc2_:Object = GameState.mConfig.Building;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.ID == param1)
            {
               return _loc3_.Name;
            }
         }
         return null;
      }
      
      private static function findRequestObject(param1:String, param2:String) : Object
      {
         var _loc5_:Object = null;
         if(Config.DEBUG_MODE)
         {
         }
         var _loc3_:Object = GameState.mConfig.RequestObjects;
         var _loc4_:Object = null;
         for each(_loc5_ in _loc3_)
         {
            if(Boolean(_loc5_.Reason) && _loc5_.Reason == param1)
            {
               if(!_loc5_.Item)
               {
                  if(Config.DEBUG_MODE)
                  {
                  }
                  _loc4_ = _loc5_;
               }
               else if(_loc5_.Item.ID == param2)
               {
                  if(Config.DEBUG_MODE)
                  {
                  }
                  _loc4_ = _loc5_;
                  break;
               }
            }
            else if(_loc5_.ID == "Generic" && !_loc4_)
            {
               if(Config.DEBUG_MODE)
               {
               }
               _loc4_ = _loc5_;
            }
         }
         return _loc4_;
      }
      
      public static function launchGiftRequest(param1:String, param2:String, param3:Function = null) : void
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc10_:String = null;
         _loc4_ = findRequestObject(param1,param2);
         _loc5_ = findNameForRequestReason(param1);
         _loc6_ = findNameForGift(param2);
         var _loc7_:String = replaceRequParameters(String(_loc4_.Caption),getPlayerName(),_loc5_,_loc6_);
         var _loc8_:Object;
         (_loc8_ = {}).gift_id = param2;
         var _loc9_:String = JSONWrapper.encode(_loc8_);
         if(ExternalInterface.available)
         {
            _loc10_ = VIR_SRC + VIR_REQUEST_GIFT;
            WebUtils.externalInterfaceCallWrapper("charlieFunctions.launchGiftRequestPopup",param2,_loc10_,_loc7_);
         }
         else if(Config.DEBUG_MODE)
         {
         }
      }
      
      public static function publishMessage(param1:String, param2:String = null, param3:Array = null, param4:Function = null, param5:String = null) : void
      {
         var _loc13_:String = null;
         var _loc14_:String = null;
         mDoneCallback = param4;
         var _loc6_:String = getPlayerName();
         var _loc7_:String = GameState.mInstance.mPlayerProfile.mLevel.toString();
         var _loc8_:String = !!param2 ? param1 + param2 : param1;
         var _loc9_:Object;
         if(!(_loc9_ = GameState.mConfig["FeedObjects"][_loc8_]))
         {
            _loc9_ = GameState.mConfig["FeedObjects"][param1];
            _loc8_ = param1;
         }
         if(!param3)
         {
            param3 = new Array();
         }
         var _loc10_:String = String(_loc9_.ClickerRewardItem.Name);
         var _loc11_:String = String(_loc9_.ClickerRewardAmount);
         var _loc12_:Object = {};
         if(param3["target_id"])
         {
            _loc14_ = String(param3["target_id"]);
         }
         var _loc15_:String = replaceFeedParameters(_loc9_.Title,_loc6_,_loc7_,param5,_loc10_,_loc11_,null,param3);
         var _loc16_:String = replaceFeedParameters(_loc9_.Caption,_loc6_,_loc7_,param5,_loc10_,_loc11_,null,param3);
         var _loc17_:String = replaceFeedParameters(_loc9_.ActionLinkText,_loc6_,_loc7_,param5,_loc10_,_loc11_,null,param3);
         if(_loc9_.Image)
         {
            _loc13_ = Config.DIR_DATA + _loc9_.Image;
         }
         _loc12_.id = _loc8_;
         if(param3["target_id"])
         {
            _loc12_.target_id = param3["target_id"];
         }
         _loc12_.title = replaceFeedParameters(_loc9_.Title,_loc6_,_loc7_,param5,_loc10_,_loc11_,null,param3);
         _loc12_.caption = replaceFeedParameters(_loc9_.Caption,_loc6_,_loc7_,param5,_loc10_,_loc11_,null,param3);
         _loc12_.description = replaceFeedParameters(_loc9_.Desc,_loc6_,_loc7_,param5,_loc10_,_loc11_,null,param3);
         _loc12_.action_link_text = replaceFeedParameters(_loc9_.ActionLinkText,_loc7_,_loc6_,param5,_loc10_,_loc11_,null,param3);
         if(_loc9_.Image)
         {
            _loc12_.image_file = Config.DIR_DATA + _loc9_.Image;
         }
         if(_loc9_.Ref)
         {
            _loc12_.ref = _loc9_.Ref;
         }
         else
         {
            _loc12_.ref = "";
         }
         _loc12_.stream_post_id = mNextPostId;
         GameState.mInstance.mAndroidFBConnection.publish(_loc12_.title,_loc12_.caption);
      }
      
      private static function replaceRequParameters(param1:String, param2:String, param3:String, param4:String) : String
      {
         param1 = StringReplaceAll(param1,"%NAME",param2);
         param1 = StringReplaceAll(param1,"%REASON",param3);
         return StringReplaceAll(param1,"%ITEM",param4);
      }
      
      public static function replaceFeedParameters(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:Array) : String
      {
         if(param1)
         {
            if(param2 != null)
            {
               param1 = StringReplaceAll(param1,"%NAME",param2);
            }
            param1 = StringReplaceAll(param1,"%REWARD_NAME",param5);
            param1 = StringReplaceAll(param1,"%REWARD_AMOUNT",param6);
            param1 = StringReplaceAll(param1,"%RANK",param7);
            param1 = StringReplaceAll(param1,"%LEVEL",param3);
            param1 = StringReplaceAll(param1,"%MISSION_ID",param4);
            return GameState.replaceParameters(param1,param8 as Array);
         }
         return "";
      }
      
      private static function StringReplaceAll(param1:String, param2:String, param3:String) : String
      {
         return param1.split(param2).join(param3);
      }
      
      private static function postFeed(param1:Object, param2:Object = null) : void
      {
         var jsonString:String;
         var s:String = null;
         var s1:String = null;
         var params:Object = param1;
         var serverCallParams:Object = param2;
         if(!params.action_link_text)
         {
            params.action_link_text = "Join the Army!";
         }
         jsonString = JSONWrapper.encode(params);
         if(Config.DEBUG_MODE)
         {
            for each(s in jsonString.split(",\""))
            {
               for each(s1 in s.split(":"))
               {
               }
            }
         }
         try
         {
            GameState.mInstance.getMainClip().mouseChildren = false;
            ExternalInterface.addCallback("facebookFeedCancelled",feedCancelled);
            ExternalInterface.addCallback("facebookFeedPosted",feedPosted);
            ExternalInterface.call("charlieFunctions.postToFeed",jsonString);
         }
         catch(e:Error)
         {
            feedCancelled(e.getStackTrace());
         }
      }
      
      public static function getNextPostId() : uint
      {
         return mNextPostId;
      }
      
      public static function setNextPostId(param1:uint) : void
      {
         mNextPostId = param1;
      }
      
      public static function feedCancelled(param1:String) : void
      {
         GameState.mInstance.getMainClip().mouseChildren = true;
         if(mDoneCallback != null)
         {
            mDoneCallback(false);
         }
         mDoneCallback = null;
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      public static function feedPosted(param1:String) : void
      {
         GameState.mInstance.getMainClip().mouseChildren = true;
         if(mDoneCallback != null)
         {
            mDoneCallback(true);
         }
         mDoneCallback = null;
         if(Config.DEBUG_MODE)
         {
         }
         ++mNextPostId;
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
