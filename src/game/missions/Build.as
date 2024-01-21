package game.missions
{
   public class Build extends Objective
   {
       
      
      public function Build(param1:Object)
      {
         super(param1);
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         if(isDone())
         {
            return false;
         }
         if(param1 == mParameter.ID)
         {
            mCounter += param2;
            return true;
         }
         return false;
      }
   }
}
