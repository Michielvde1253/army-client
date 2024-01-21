package game.player
{
   import game.gui.IconAdapter;
   import game.missions.Mission;
   import game.states.GameState;
   
   public class RankManager
   {
      
      private static var smRankMissions:Array;
      
      private static var smRankIconAdapters:Array;
      
      private static var smRankNames:Array;
      
      private static var smRankCount:int;
       
      
      public function RankManager()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         if(!smRankMissions)
         {
            smRankCount = 0;
            _loc1_ = GameState.mConfig.RankList;
            for each(_loc2_ in _loc1_)
            {
               ++smRankCount;
            }
            smRankMissions = new Array(smRankCount);
            smRankIconAdapters = new Array(smRankCount);
            smRankNames = new Array(smRankCount);
            for each(_loc3_ in _loc1_)
            {
               _loc4_ = int(_loc3_.ID);
               if(_loc3_.RankMission)
               {
                  smRankMissions[_loc4_] = new Mission(_loc3_.RankMission);
               }
               smRankIconAdapters[_loc4_] = new IconAdapter(_loc3_.Icon,"swf/objects_01");
               smRankNames[_loc4_] = _loc3_.Name;
            }
         }
      }
      
      private static function clamp(param1:int) : int
      {
         return Math.min(smRankCount - 1,Math.max(param1,0));
      }
      
      public static function getRankCount() : int
      {
         return smRankCount;
      }
      
      public static function getAdapterByIndex(param1:int) : IconAdapter
      {
         return smRankIconAdapters[clamp(param1)];
      }
      
      public static function getNameByIndex(param1:int) : String
      {
         return smRankNames[clamp(param1)];
      }
      
      public static function getIndexOfMission(param1:Mission) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < smRankMissions.length)
         {
            if(Boolean(smRankMissions[_loc2_]) && (smRankMissions[_loc2_] as Mission).mId == param1.mId)
            {
               return _loc2_ - 1;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public static function getMissionByIndex(param1:int) : Mission
      {
         init();
         return smRankMissions[clamp(param1)];
      }
   }
}
