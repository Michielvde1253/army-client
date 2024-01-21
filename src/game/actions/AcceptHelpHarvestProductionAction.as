package game.actions
{
   import game.gameElements.HFEObject;
   import game.gameElements.PermanentHFEObject;
   import game.gameElements.PlayerBuildingObject;
   import game.gameElements.Production;
   import game.isometric.IsometricScene;
   import game.missions.MissionManager;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class AcceptHelpHarvestProductionAction extends HarvestProductionAction
   {
       
      
      private var mNeighborActionID:String;
      
      public function AcceptHelpHarvestProductionAction(param1:PlayerBuildingObject, param2:String)
      {
         super(param1);
         this.mNeighborActionID = param2;
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         var _loc1_:IsometricScene = GameState.mInstance.mScene;
         var _loc2_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         var _loc3_:PlayerBuildingObject = mTarget as PlayerBuildingObject;
         var _loc4_:Production;
         if((_loc4_ = _loc3_.getProduction()).getRewardSupplies() > 0)
         {
            if(_loc4_.getRewardSupplies() + _loc2_.mSupplies + _loc1_.getUncollectedSupplies() > _loc2_.mSuppliesCap)
            {
               skip();
               return;
            }
         }
         (mTarget as PlayerBuildingObject).startHarvesting();
      }
      
      override protected function execute() : void
      {
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:IsometricScene = _loc1_.mScene;
         var _loc3_:PlayerBuildingObject = mTarget as PlayerBuildingObject;
         var _loc4_:Production = _loc3_.getProduction();
         var _loc5_:Object = {"neighbor_action_id":this.mNeighborActionID};
         _loc4_.addRewards(_loc3_.getContainer(),_loc5_);
         _loc3_.removeProduction();
         _loc3_.handleProductionHarvested();
         if(!_loc4_.isWithered())
         {
            MissionManager.increaseCounter("Collect",_loc3_,1);
         }
         _loc2_.castSaboteurs(_loc2_.getCellAtLocation(_loc3_.mX,_loc3_.mY));
         var _loc6_:String = null;
         if(_loc3_ is HFEObject)
         {
            _loc6_ = ServiceIDs.ACCEPT_HELP_COLLECT_HF;
         }
         else if(_loc3_ is PermanentHFEObject)
         {
            _loc6_ = ServiceIDs.ACCEPT_HELP_COLLECT_PHF;
         }
         if(_loc6_)
         {
            _loc1_.mServer.serverCallServiceWithParameters(_loc6_,_loc5_,false);
            if(Config.DEBUG_MODE)
            {
            }
         }
      }
   }
}
