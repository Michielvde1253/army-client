package game.missions
{
   public class Buy extends Objective
   {
       
      
      private var mItem:Object;
      
      public function Buy(param1:Object)
      {
         super(param1);
         this.mItem = param1.Parameter;
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         if(isDone())
         {
            return false;
         }
         var _loc3_:* = this.mItem == null;
         if(!_loc3_)
         {
            if(this.mItem.ID == null)
            {
               _loc3_ = this.mItem[param1] != null;
            }
            else
            {
               _loc3_ = this.mItem.ID == param1;
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
