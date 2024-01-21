package game.missions
{
   import game.isometric.IsometricScene;
   import game.isometric.elements.Renderable;
   import game.items.FireMissionItem;
   import game.states.GameState;
   
   public class KillWith extends Objective
   {
       
      
      public function KillWith(param1:Object)
      {
         super(param1);
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         var _loc4_:Renderable = null;
         var _loc5_:FireMissionItem = null;
         var _loc6_:IsometricScene = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(isDone())
         {
            return false;
         }
         var _loc3_:* = mParameter == null;
         if(!_loc3_)
         {
            _loc4_ = param1 as Renderable;
            _loc5_ = param1 as FireMissionItem;
            if(mParameter is Array)
            {
               _loc7_ = (_loc6_ = GameState.mInstance.mScene).findGridLocationX(_loc4_.mX);
               _loc8_ = _loc6_.findGridLocationY(_loc4_.mY);
               _loc3_ = mParameter[0] == _loc7_ && mParameter[1] == _loc8_;
            }
            else if(_loc4_)
            {
               if(mParameter.ID == null)
               {
                  _loc3_ = mParameter[_loc4_.mItem.mId] != null;
               }
               else
               {
                  _loc3_ = mParameter.ID == _loc4_.mItem.mId;
               }
            }
            else if(mParameter.ID == null)
            {
               _loc3_ = mParameter[_loc5_.mId] != null;
            }
            else
            {
               _loc3_ = mParameter.ID == _loc5_.mId;
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
