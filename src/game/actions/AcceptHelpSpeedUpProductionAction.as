package game.actions
{
   import game.gameElements.HFEObject;
   import game.gameElements.PermanentHFEObject;
   import game.gameElements.PlayerBuildingObject;
   import game.net.ServiceIDs;
   import game.states.GameState;
   
   public class AcceptHelpSpeedUpProductionAction extends Action
   {
       
      
      private var mNeighborActionID:String;
      
      public function AcceptHelpSpeedUpProductionAction(param1:PlayerBuildingObject, param2:String)
      {
         super("Speed Up Production");
         mTarget = param1;
         mSkipped = false;
         this.mNeighborActionID = param2;
      }
      
      override public function update(param1:int) : void
      {
         if(mSkipped)
         {
            if(!mTarget)
            {
               return;
            }
            (mTarget as PlayerBuildingObject).skipSpeedUp();
         }
         else if(mTarget)
         {
            if((mTarget as PlayerBuildingObject).isSpeedUpOver())
            {
               this.execute();
            }
         }
      }
      
      override public function isOver() : Boolean
      {
         return mSkipped || (mTarget as PlayerBuildingObject).isSpeedUpOver();
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         (mTarget as PlayerBuildingObject).startSpeedUp();
      }
      
      private function execute() : void
      {
         var _loc1_:PlayerBuildingObject = mTarget as PlayerBuildingObject;
         _loc1_.handleProductionSpeedUp();
         var _loc2_:Object = {"neighbor_action_id":this.mNeighborActionID};
         var _loc3_:String = null;
         if(_loc1_ is HFEObject)
         {
            _loc3_ = ServiceIDs.ACCEPT_HELP_SPEED_UP_HF;
         }
         else if(_loc1_ is PermanentHFEObject)
         {
            _loc3_ = ServiceIDs.ACCEPT_HELP_SPEED_UP_PHF;
         }
         if(_loc3_)
         {
            GameState.mInstance.mServer.serverCallServiceWithParameters(_loc3_,_loc2_,false);
            if(Config.DEBUG_MODE)
            {
            }
         }
      }
   }
}
