package game.missions
{
   import game.gameElements.LootReward;
   import game.isometric.IsometricScene;
   import game.states.GameState;
   
   public class CollectIntel extends Objective
   {
       
      
      public function CollectIntel(param1:Object)
      {
         super(param1);
      }
      
      override public function initialize(param1:String, param2:Object) : void
      {
         super.initialize(param1,param2);
         if(param1 == Mission.TYPE_INTEL)
         {
            GameState.mInstance.mScene.addIntel(mParameter[0],mParameter[1]);
         }
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         if(isDone())
         {
            return false;
         }
         var _loc3_:IsometricScene = GameState.mInstance.mScene;
         var _loc4_:LootReward = param1 as LootReward;
         var _loc5_:int = _loc3_.findGridLocationX(_loc4_.x);
         var _loc6_:int = _loc3_.findGridLocationY(_loc4_.y);
         if(mParameter[0] == _loc5_)
         {
            if(mParameter[1] == _loc6_)
            {
               mCounter += param2;
               return true;
            }
         }
         return false;
      }
   }
}
