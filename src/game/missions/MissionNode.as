package game.missions
{
   public class MissionNode
   {
       
      
      public var mParentNodes:Array;
      
      public var mMission:Mission;
      
      public var mIsProcessed:Boolean;
      
      public function MissionNode(param1:Mission)
      {
         super();
         this.mIsProcessed = false;
         this.mMission = param1;
         this.mParentNodes = new Array();
      }
      
      public function markParentsCompleted() : void
      {
         var _loc1_:MissionNode = null;
         for each(_loc1_ in this.mParentNodes)
         {
            if(!_loc1_.mIsProcessed)
            {
               _loc1_.markCompleted();
            }
         }
      }
      
      private function markCompleted() : void
      {
         this.mIsProcessed = true;
         if(this.mMission.mState == Mission.STATE_INACTIVE)
         {
            this.mMission.mState = Mission.STATE_REWARDS_COLLECTED;
         }
         this.markParentsCompleted();
      }
   }
}
