package game.missions
{
   import game.gameElements.PermanentHFEObject;
   
   public class Recapture extends Objective
   {
       
      
      public function Recapture(param1:Object)
      {
         super(param1);
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         var _loc3_:PermanentHFEObject = null;
         if(isDone())
         {
            return false;
         }
         _loc3_ = param1 as PermanentHFEObject;
         if(_loc3_)
         {
            if(_loc3_.mItem.mId == mParameter.ID)
            {
               mCounter += param2;
               if(isDone())
               {
                  _loc3_.celebratLiberation();
               }
               return true;
            }
         }
         return false;
      }
   }
}
