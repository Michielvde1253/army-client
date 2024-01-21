package game.missions
{
   import game.isometric.elements.Renderable;
   
   public class CompleteBuilding extends Objective
   {
       
      
      public function CompleteBuilding(param1:Object)
      {
         super(param1);
      }
      
      override public function initialize(param1:String, param2:Object) : void
      {
         super.initialize(param1,param2);
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
            _loc3_ = mParameter.ID == _loc4_.mItem.mId;
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
