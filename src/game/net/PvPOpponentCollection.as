package game.net
{
   public class PvPOpponentCollection
   {
      
      public static var smCollection:PvPOpponentCollection = new PvPOpponentCollection();
       
      
      public var mOpponents:Array;
      
      public var mRecentAttacks:Array;
      
      private var mFBIDToOpponent:Array;
      
      private var mFBIDToRecentAttack:Array;
      
      public function PvPOpponentCollection()
      {
         super();
         this.mOpponents = new Array();
         this.mRecentAttacks = new Array();
         this.mFBIDToOpponent = new Array();
         this.mFBIDToRecentAttack = new Array();
      }
      
      public function addOpponent(param1:String, param2:int, param3:int, param4:int, param5:String, param6:String) : void
      {
         var _loc5_:PvPOpponent = new PvPOpponent(param1,param2,param3,param4,param5,param6);
         this.mOpponents.push(_loc5_);
         this.mFBIDToOpponent[param1] = _loc5_;
      }
      
      public function addRecentAttack(param1:String, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:PvPOpponent = new PvPOpponent(param1,param2,param3,param4,"test","test");
         this.mRecentAttacks.push(_loc5_);
         this.mFBIDToRecentAttack[param1] = _loc5_;
      }
      
      public function removeRecentAttack(param1:String) : void
      {
         var _loc3_:PvPOpponent = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.mRecentAttacks.length)
         {
            _loc3_ = this.mRecentAttacks[_loc2_];
            if(_loc3_.mFacebookID == param1)
            {
               this.mRecentAttacks.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function getOpponent(param1:String) : PvPOpponent
      {
         return this.mFBIDToOpponent[param1] as PvPOpponent;
      }
      
      public function getRecentAttack(param1:String) : PvPOpponent
      {
         return this.mFBIDToRecentAttack[param1] as PvPOpponent;
      }
      
      public function addToScreen() : void
      {
      }
   }
}
