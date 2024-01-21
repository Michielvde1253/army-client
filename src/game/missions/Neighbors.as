package game.missions
{
   import game.net.FriendsCollection;
   
   public class Neighbors extends Objective
   {
       
      
      public function Neighbors(param1:Object)
      {
         super(param1);
      }
      
      override public function initialize(param1:String, param2:Object) : void
      {
         super.initialize(param1,param2);
         mCounter = Math.min(FriendsCollection.smFriends.getPlayingFriendCount(),mGoal);
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         if(isDone())
         {
            return false;
         }
         mCounter = Math.min(FriendsCollection.smFriends.getPlayingFriendCount(),mGoal);
         if(isDone())
         {
            return true;
         }
         return false;
      }
   }
}
