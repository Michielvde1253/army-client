package game.missions
{
   public class Select extends Objective
   {
       
      
      public function Select(param1:Object)
      {
         super(param1);
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         if(isDone())
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 2)
         {
            if(param1[_loc3_] != mParameter[_loc3_])
            {
               return false;
            }
            _loc3_++;
         }
         mCounter += param2;
         return true;
      }
   }
}
