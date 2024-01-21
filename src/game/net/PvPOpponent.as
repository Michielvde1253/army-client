package game.net
{
   import game.states.GameState;
   
   public class PvPOpponent
   {
       
      
      public var mFacebookID:String;
      
      public var mBadassXp:int;
      
      public var mBadassLevel:int;
      
      public var mPvPWins:int;
      
      public var mName:String;
      
      public var mPicID:String;
      
      public function PvPOpponent(param1:String, param2:int, param3:int, param4:int)
      {
         super();
         this.mFacebookID = param1;
         this.mBadassXp = param2;
         this.mBadassLevel = param3;
         this.mPvPWins = param4;
         this.mName = "";
         this.mPicID = Config.DIR_DATA + "icons/default_avatar.png";
      }
      
      public function getBadassName() : String
      {
         return (GameState.mConfig.BadassLevels[this.mBadassLevel] as Object).BadassName as String;
      }
   }
}
