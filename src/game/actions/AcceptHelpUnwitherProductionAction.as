package game.actions
{
   import game.gameElements.PlayerBuildingObject;
   import game.net.ServiceIDs;
   import game.states.GameState;
   
   public class AcceptHelpUnwitherProductionAction extends Action
   {
       
      
      private var mNeighborActionID:String;
      
      public function AcceptHelpUnwitherProductionAction(param1:PlayerBuildingObject, param2:String)
      {
         super("Unwither Production");
         mTarget = param1;
         mSkipped = false;
         this.mNeighborActionID = param2;
      }
      
      override public function update(param1:int) : void
      {
         var _loc2_:PlayerBuildingObject = mTarget as PlayerBuildingObject;
         if(mSkipped)
         {
            _loc2_.skipUnwithering();
         }
         else if(_loc2_)
         {
            if(_loc2_.isUnwitheringOver())
            {
               this.execute();
            }
         }
      }
      
      override public function isOver() : Boolean
      {
         return mSkipped || (mTarget as PlayerBuildingObject).isUnwitheringOver();
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         (mTarget as PlayerBuildingObject).startUnwithering();
      }
      
      private function execute() : void
      {
         var _loc1_:PlayerBuildingObject = mTarget as PlayerBuildingObject;
         _loc1_.handleProductionUnwithered();
         var _loc2_:Object = {"neighbor_action_id":this.mNeighborActionID};
         var _loc3_:String = ServiceIDs.ACCEPT_HELP_REVIVE_HF;
         GameState.mInstance.mServer.serverCallServiceWithParameters(_loc3_,_loc2_,false);
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
