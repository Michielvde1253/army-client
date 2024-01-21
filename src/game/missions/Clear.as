package game.missions
{
   import game.isometric.elements.Renderable;
   import game.items.Item;
   
   public class Clear extends Objective
   {
       
      
      public function Clear(param1:Object)
      {
         super(param1);
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         var _loc4_:Item = null;
         if(isDone())
         {
            return false;
         }
         var _loc3_:* = mParameter == null;
         if(!_loc3_)
         {
            _loc4_ = Renderable(param1).mItem;
            if(mParameter.ID == null)
            {
               _loc3_ = mParameter[_loc4_.mId] != null;
            }
            else
            {
               _loc3_ = mParameter.ID == _loc4_.mId;
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
