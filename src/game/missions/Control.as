package game.missions
{
   import game.states.GameState;
   
   public class Control extends Objective
   {
       
      
      public function Control(param1:Object)
      {
         super(param1);
      }
      
      override public function initialize(param1:String, param2:Object) : void
      {
         super.initialize(param1,param2);
         mCounter = Math.min(GameState.mInstance.mMapData.mNumberOfFriendlyTiles,mGoal);
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         var _loc3_:Boolean = isDone();
         if(!mPurchased)
         {
            mCounter = Math.min(GameState.mInstance.mMapData.mNumberOfFriendlyTiles,mGoal);
         }
         if(!_loc3_ && isDone())
         {
            return true;
         }
         return false;
      }
   }
}
