package game.missions
{
   import game.isometric.IsometricScene;
   import game.isometric.elements.Renderable;
   import game.items.Item;
   import game.states.GameState;
   
   public class Repair extends Objective
   {
       
      
      public function Repair(param1:Object)
      {
         super(param1);
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         var _loc4_:Renderable = null;
         var _loc5_:IsometricScene = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Item = null;
         if(isDone())
         {
            return false;
         }
         var _loc3_:* = mParameter == null;
         if(!_loc3_)
         {
            if(mParameter is Array)
            {
               _loc4_ = param1 as Renderable;
               _loc6_ = (_loc5_ = GameState.mInstance.mScene).findGridLocationX(_loc4_.mX);
               _loc7_ = _loc5_.findGridLocationY(_loc4_.mY);
               _loc3_ = mParameter[0] == _loc6_ && mParameter[1] == _loc7_;
            }
            else
            {
               _loc8_ = Renderable(param1).mItem;
               if(mParameter.ID == null)
               {
                  _loc3_ = mParameter[_loc8_.mId] != null;
               }
               else
               {
                  _loc3_ = mParameter.ID == _loc8_.mId;
               }
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
