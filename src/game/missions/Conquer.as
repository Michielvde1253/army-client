package game.missions
{
   import game.battlefield.MapData;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.states.GameState;
   
   public class Conquer extends Objective
   {
       
      
      public function Conquer(param1:Object)
      {
         super(param1);
      }
      
      override public function initialize(param1:String, param2:Object) : void
      {
         var _loc3_:IsometricScene = null;
         var _loc4_:GridCell = null;
         var _loc5_:Array = null;
         super.initialize(param1,param2);
         if(mParameter is Array)
         {
            _loc3_ = GameState.mInstance.mScene;
            if(mParameter[0] is Array)
            {
               for each(_loc5_ in mParameter)
               {
                  if((_loc4_ = _loc3_.getCellAt(_loc5_[0],_loc5_[1])).mOwner == MapData.TILE_OWNER_FRIENDLY)
                  {
                     ++mCounter;
                  }
               }
            }
            else if((_loc4_ = _loc3_.getCellAt(mParameter[0],mParameter[1])).mOwner == MapData.TILE_OWNER_FRIENDLY)
            {
               mCounter = mGoal;
            }
         }
         if(param1 == Mission.TYPE_MODAL_ARROW && mParameter is Array)
         {
            GameState.mInstance.updateWalkableCellsForActiveCharacter(mParameter[0],mParameter[1]);
         }
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(isDone())
         {
            return false;
         }
         var _loc3_:* = mParameter == null;
         if(!_loc3_ && param1 is Array)
         {
            if(mParameter[0] is Array)
            {
               for each(_loc4_ in mParameter)
               {
                  _loc3_ = true;
                  _loc5_ = 0;
                  while(_loc5_ < 2)
                  {
                     if(param1[_loc5_] != _loc4_[_loc5_])
                     {
                        _loc3_ = false;
                        break;
                     }
                     _loc5_++;
                  }
                  if(_loc3_)
                  {
                     break;
                  }
               }
            }
            else
            {
               _loc3_ = true;
               _loc6_ = 0;
               while(_loc6_ < 2)
               {
                  if(param1[_loc6_] != mParameter[_loc6_])
                  {
                     _loc3_ = false;
                     break;
                  }
                  _loc6_++;
               }
            }
         }
         if(_loc3_)
         {
            mCounter += param2;
            if(param2 < 0)
            {
               return false;
            }
            return true;
         }
         return false;
      }
   }
}
