package game.missions
{
   import game.items.Item;
   import game.items.ItemManager;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class Own extends Objective
   {
       
      
      public function Own(param1:Object)
      {
         super(param1);
      }
      
      override public function initialize(param1:String, param2:Object) : void
      {
         var _loc3_:GamePlayerProfile = null;
         var _loc4_:Item = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         super.initialize(param1,param2);
         _loc3_ = GameState.mInstance.mPlayerProfile;
         if(!mParameter.ID)
         {
            _loc5_ = 0;
            for each(_loc6_ in mParameter)
            {
               _loc4_ = ItemManager.getItem(_loc6_.ID,_loc6_.Type);
               _loc5_ += _loc3_.getItemCount(_loc4_);
            }
            mCounter = Math.min(_loc5_,mGoal);
         }
         else
         {
            _loc4_ = ItemManager.getItem(mParameter.ID,mParameter.Type);
            mCounter = Math.min(_loc3_.getItemCount(_loc4_),mGoal);
         }
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         var _loc4_:GamePlayerProfile = null;
         var _loc5_:Item = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc3_:Boolean = isDone();
         if(!mPurchased)
         {
            if(!mParameter.ID)
            {
               _loc4_ = GameState.mInstance.mPlayerProfile;
               _loc6_ = 0;
               for each(_loc7_ in mParameter)
               {
                  _loc5_ = ItemManager.getItem(_loc7_.ID,_loc7_.Type);
                  _loc6_ += _loc4_.getItemCount(_loc5_);
               }
               mCounter = Math.min(_loc6_,mGoal);
            }
            else if(param1.mId == mParameter.ID)
            {
               _loc4_ = GameState.mInstance.mPlayerProfile;
               mCounter = Math.min(_loc4_.getItemCount(Item(param1)),mGoal);
            }
         }
         if(!_loc3_)
         {
            if(isDone())
            {
               return true;
            }
         }
         return false;
      }
   }
}
