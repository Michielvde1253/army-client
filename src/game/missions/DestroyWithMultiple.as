package game.missions
{
   import game.isometric.elements.Renderable;
   
   public class DestroyWithMultiple extends Objective
   {
       
      
      public function DestroyWithMultiple(param1:Object)
      {
         super(param1);
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         var _loc4_:Renderable = null;
         if(isDone())
         {
            return false;
         }
         var _loc3_:* = mParameter == null;
         if(!_loc3_)
         {
            _loc4_ = param1 as Renderable;
            if(mParameter.ID == null)
            {
               _loc3_ = mParameter[_loc4_.mItem.mId] != null;
            }
            else
            {
               _loc3_ = mParameter.ID == _loc4_.mItem.mId;
            }
         }
         if(_loc3_)
         {
            if(param2 > 1)
            {
               ++mCounter;
               return true;
            }
         }
         return false;
      }
   }
}
