package game.actions
{
   import game.gameElements.ConstructionObject;
   import game.gameElements.HFEObject;
   import game.gameElements.PermanentHFEObject;
   import game.gameElements.PlayerBuildingObject;
   import game.gameElements.Production;
   import game.gameElements.ResourceBuildingObject;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.items.ItemManager;
   import game.magicBox.MagicBoxTracker;
   import game.missions.MissionManager;
   import game.net.MyServer;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class HarvestProductionAction extends Action
   {
       
      
      public function HarvestProductionAction(param1:PlayerBuildingObject)
      {
         super("HarvestProductionAction");
         mTarget = param1;
         mSkipped = false;
      }
      
      override public function update(param1:int) : void
      {
         var _loc2_:PlayerBuildingObject = mTarget as PlayerBuildingObject;
         if(_loc2_.isHarvestingOver())
         {
            if(!mSkipped)
            {
               this.execute();
            }
         }
         if(mSkipped)
         {
            _loc2_.skipHarvest();
         }
      }
      
      override public function isOver() : Boolean
      {
         return (mTarget as PlayerBuildingObject).isHarvestingOver() || mSkipped;
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         var _loc1_:GameState = GameState.mInstance;
         if(_loc1_.mPlayerProfile.mEnergy <= 0)
         {
            _loc1_.mHUD.openOutOfEnergyWindow();
            skip();
            return;
         }
         if(!_loc1_.mPlayerProfile.hasEnoughMapResource(1))
         {
            _loc1_.mHUD.openOutOfMapResourceWindow();
            skip();
            return;
         }
         var _loc2_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         var _loc3_:PlayerBuildingObject = mTarget as PlayerBuildingObject;
         if(!_loc3_ || !_loc3_.mScene)
         {
            skip();
            return;
         }
         var _loc4_:Production;
         if(!(_loc4_ = _loc3_.getProduction()))
         {
            skip();
            return;
         }
         if(!(_loc3_ is PermanentHFEObject))
         {
            if(_loc4_.getRewardSupplies() > 0)
            {
               if(_loc4_.getRewardSupplies() + _loc2_.mSupplies + _loc1_.mScene.getUncollectedSupplies() > _loc2_.mSuppliesCap)
               {
                  _loc1_.mHUD.openSupplyCapTextBox(null);
                  skip();
                  return;
               }
            }
         }
         _loc3_.startHarvesting();
      }
      
      protected function execute() : void
      {
         var _loc6_:String = null;
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:IsometricScene = _loc1_.mScene;
         var _loc3_:PlayerBuildingObject = mTarget as PlayerBuildingObject;
         var _loc4_:Production = _loc3_.getProduction();
         _loc3_.addTextEffect(TextEffect.TYPE_LOSS,"-1",ItemManager.getItem("Energy","Resource"));
         _loc1_.reduceEnergy(mName,1,MagicBoxTracker.paramsObj(_loc3_.mItem.mType,_loc3_.mItem.mId));
         _loc1_.reduceMapResource(1);
         var _loc5_:GridCell = _loc3_.getCell();
         if(this.mTarget is ResourceBuildingObject)
         {
            _loc6_ = "ResourceBuilding";
         }
         else
         {
            _loc6_ = "Building";
         }
         var _loc7_:String = null;
         if(_loc3_ is HFEObject || _loc3_ is PermanentHFEObject)
         {
            _loc7_ = ServiceIDs.COLLECT_HF;
         }
         else if(_loc3_ is ConstructionObject)
         {
            _loc7_ = ServiceIDs.COLLECT_BUILDING;
         }
         else if(_loc3_ is ResourceBuildingObject)
         {
            _loc7_ = ServiceIDs.COLLECT_BUILDING;
            _loc6_ = "ResourceBuilding";
         }
         var _loc8_:Object = {
            "coord_x":_loc5_.mPosI,
            "coord_y":_loc5_.mPosJ,
            "cost_energy":1,
            "item_type":_loc6_
         };
         if(_loc1_.mMapData.mMapSetupData.Resource)
         {
            _loc8_[MyServer.MAP_RESOURCE_COST_NAMES[_loc1_.mMapData.mMapSetupData.Resource]] = 1;
         }
         _loc4_.addRewards(_loc3_.getContainer(),_loc8_);
         _loc3_.removeProduction();
         _loc3_.handleProductionHarvested();
         if(!_loc4_.isWithered())
         {
            MissionManager.increaseCounter("Collect",_loc3_,1);
         }
         _loc2_.castSaboteurs(_loc2_.getCellAtLocation(_loc3_.mX,_loc3_.mY));
         if(_loc7_)
         {
            GameState.mInstance.mServer.serverCallServiceWithParameters(_loc7_,_loc8_,false);
            if(Config.DEBUG_MODE)
            {
            }
         }
      }
   }
}
