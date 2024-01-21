package game.missions
{
   import game.gameElements.PlayerBuildingObject;
   import game.isometric.IsometricScene;
   import game.states.GameState;
   
   public class Collect extends Objective
   {
       
      
      public function Collect(param1:Object)
      {
         super(param1);
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         var _loc4_:IsometricScene = null;
         var _loc5_:PlayerBuildingObject = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         if(isDone())
         {
            return false;
         }
         var _loc3_:* = mParameter == null;
         if(!_loc3_)
         {
            if(mParameter is Array)
            {
               _loc4_ = GameState.mInstance.mScene;
               _loc5_ = param1 as PlayerBuildingObject;
               _loc6_ = _loc4_.findGridLocationX(_loc5_.mX);
               _loc7_ = _loc4_.findGridLocationY(_loc5_.mY);
               _loc3_ = mParameter[0] == _loc6_ && mParameter[1] == _loc7_;
            }
            else
            {
               _loc8_ = "";
               if(PlayerBuildingObject(param1).getProduction())
               {
                  _loc8_ = PlayerBuildingObject(param1).getProduction().getProductionID();
               }
               if(mParameter.ID == null)
               {
                  _loc3_ = mParameter[param1.mItem.mId] != null || mParameter[_loc8_] != null;
               }
               else
               {
                  _loc3_ = param1.mItem.mId == mParameter.ID || _loc8_ != "" && _loc8_ == mParameter.ID;
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
