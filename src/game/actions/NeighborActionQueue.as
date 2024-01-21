package game.actions
{
   import game.characters.EnemyUnit;
   import game.characters.PlayerUnit;
   import game.gameElements.DebrisObject;
   import game.gameElements.EnemyInstallationObject;
   import game.gameElements.HFEObject;
   import game.gameElements.PermanentHFEObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.elements.Renderable;
   import game.states.GameState;
   
   public class NeighborActionQueue
   {
       
      
      public var mUserID:String;
      
      public var mTargetObjects:Vector.<Renderable>;
      
      private var mActionIDs:Vector.<String>;
      
      private var mActionQueueData:Array;
      
      public function NeighborActionQueue(param1:Array)
      {
         super();
         this.mActionQueueData = param1;
      }
      
      public function mapObjects() : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:GridCell = null;
         var _loc1_:IsometricScene = GameState.mInstance.mScene;
         this.mTargetObjects = new Vector.<Renderable>();
         this.mActionIDs = new Vector.<String>();
         var _loc2_:int = 0;
         while(_loc2_ < this.mActionQueueData.length)
         {
            _loc3_ = this.mActionQueueData[_loc2_];
            this.mUserID = _loc3_.neighbor_user_id;
            _loc4_ = int(_loc3_.coord_x);
            _loc5_ = int(_loc3_.coord_y);
            if((_loc6_ = _loc1_.getCellAt(_loc4_,_loc5_)).mCharacter is PlayerUnit || _loc6_.mCharacter is EnemyUnit)
            {
               this.mTargetObjects.push(_loc6_.mCharacter);
               this.mActionIDs.push(_loc3_.neighbor_action_id);
            }
            else if(_loc6_.mObject is DebrisObject || _loc6_.mObject is HFEObject || _loc6_.mObject is PermanentHFEObject || _loc6_.mObject is EnemyInstallationObject)
            {
               this.mTargetObjects.push(_loc6_.mObject);
               this.mActionIDs.push(_loc3_.neighbor_action_id);
            }
            else if(Config.DEBUG_MODE)
            {
            }
            _loc2_++;
         }
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      public function getNextAction() : Action
      {
         var _loc2_:Renderable = null;
         var _loc3_:String = null;
         var _loc4_:Action = null;
         var _loc1_:IsometricScene = GameState.mInstance.mScene;
         while(this.mTargetObjects.length > 0)
         {
            _loc2_ = this.mTargetObjects.shift();
            _loc3_ = this.mActionIDs.shift();
            if(_loc2_.mScene != null)
            {
               if(_loc4_ = _loc2_.neighborClicked(_loc3_))
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
   }
}
