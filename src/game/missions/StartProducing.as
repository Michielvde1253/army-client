package game.missions
{
   import game.items.Item;
   
   public class StartProducing extends Objective
   {
       
      
      public function StartProducing(param1:Object)
      {
         super(param1);
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         var _loc4_:Item = null;
         var _loc5_:Item = null;
         if(isDone())
         {
            return false;
         }
         var _loc3_:* = mParameter == null;
         if(!_loc3_)
         {
            _loc4_ = param1[0] as Item;
            _loc5_ = param1[1] as Item;
            if(mParameter.ID == null)
            {
               _loc3_ = mParameter[_loc4_.mId] != null || mParameter[_loc5_.mId] != null;
            }
            else
            {
               _loc3_ = _loc4_.mId == mParameter.ID || _loc5_.mId == mParameter.ID;
            }
         }
         if(_loc3_)
         {
            mCounter += param2;
            return true;
         }
         return false;
      }
   }
}
