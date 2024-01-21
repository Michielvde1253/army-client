package game.actions
{
   import game.gameElements.ConstructionObject;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.items.ConstructionItem;
   import game.items.ItemManager;
   import game.magicBox.MagicBoxTracker;
   import game.missions.MissionManager;
   import game.net.MyServer;
   import game.net.ServiceIDs;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class WorkOnBuildingAction extends Action
   {
       
      
      public function WorkOnBuildingAction(param1:ConstructionObject)
      {
         super("Clean");
         mTarget = param1;
         mSkipped = false;
      }
      
      override public function update(param1:int) : void
      {
         if((mTarget as ConstructionObject).isWorkingTaskFinished())
         {
            if(!mSkipped)
            {
               this.execute();
            }
         }
         if(mSkipped)
         {
            (mTarget as ConstructionObject).skipWorkingTask();
         }
      }
      
      override public function isOver() : Boolean
      {
         return (mTarget as ConstructionObject).isWorkingTaskFinished() || mSkipped;
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         var _loc1_:ConstructionObject = mTarget as ConstructionObject;
         if(GameState.mInstance.mPlayerProfile.mEnergy <= 0)
         {
            GameState.mInstance.mHUD.openOutOfEnergyWindow();
            skip();
            return;
         }
         if(!GameState.mInstance.mPlayerProfile.hasEnoughMapResource(1))
         {
            GameState.mInstance.mHUD.openOutOfMapResourceWindow();
            skip();
            return;
         }
         _loc1_.playSound(ArmySoundManager.SFX_UI_BUILDING_CONSTRUCT);
         _loc1_.startWorkingTask();
      }
      
      private function execute() : void
      {
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:IsometricScene = _loc1_.mScene;
         var _loc3_:ConstructionObject = mTarget as ConstructionObject;
         var _loc4_:ConstructionItem;
         var _loc5_:int = (_loc4_ = _loc3_.mItem as ConstructionItem).mMaterialPerStep;
         var _loc6_:int = _loc4_.mRewardXPPerStep;
         _loc3_.addTextEffect(TextEffect.TYPE_LOSS,"-1",ItemManager.getItem("Energy","Resource"));
         _loc2_.addLootReward(ItemManager.getItem("XP","Resource"),_loc6_,_loc3_.getContainer());
         _loc1_.mPlayerProfile.addMaterial(-_loc5_);
         _loc1_.reduceEnergy(mName,1,MagicBoxTracker.paramsObj(_loc3_.mItem.mType,_loc3_.mItem.mId));
         _loc1_.reduceMapResource(1);
         var _loc7_:GridCell = _loc3_.getCell();
         var _loc8_:Object = {
            "coord_x":_loc7_.mPosI,
            "coord_y":_loc7_.mPosJ,
            "cost_material":_loc5_,
            "cost_energy":1,
            "reward_xp":_loc6_
         };
         if(_loc1_.mMapData.mMapSetupData.Resource)
         {
            _loc8_[MyServer.MAP_RESOURCE_COST_NAMES[_loc1_.mMapData.mMapSetupData.Resource]] = 1;
         }
         _loc1_.mServer.serverCallServiceWithParameters(ServiceIDs.WHACK_BUILDING,_loc8_,false);
         if(Config.DEBUG_MODE)
         {
         }
         MissionManager.increaseCounter("Build",_loc3_.mItem.mId,1);
      }
   }
}
