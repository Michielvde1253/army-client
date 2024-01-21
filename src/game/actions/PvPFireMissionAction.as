package game.actions
{
   import game.actions.FireMissionAction
   import game.characters.PlayerUnit;
   import game.characters.PvPEnemyUnit;
   import game.gameElements.PlayerBuildingObject;
   import game.gameElements.PlayerInstallationObject;
   import game.gameElements.ResourceBuildingObject;
   import game.gameElements.SignalObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.elements.Renderable;
   import game.items.FireMissionItem;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.TargetItem;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class PvPFireMissionAction extends FireMissionAction
   {
       
      
      public function PvPFireMissionAction(param1:GridCell, param2:FireMissionItem)
      {
         super(param1,param2);
      }
      
      override protected function hasIngredients() : Boolean
      {
         return true;
      }
      
      override protected function execute() : void
      {
         var _loc2_:Renderable = null;
         var _loc1_:GameState = GameState.mInstance;
         for each(_loc2_ in mTargets)
         {
            if(_loc2_.mScene)
            {
               if(_loc2_ is PlayerUnit)
               {
                  damageOwnUnit(PlayerUnit(_loc2_));
               }
               else if(_loc2_ is PlayerBuildingObject)
               {
                  if(!(_loc2_ is ResourceBuildingObject || _loc2_ is SignalObject))
                  {
                     damageOwnBuilding(PlayerBuildingObject(_loc2_));
                  }
               }
               else if(_loc2_ is PlayerInstallationObject)
               {
                  damageOwnInstallation(_loc2_ as PlayerInstallationObject);
               }
               else if(_loc2_ is PvPEnemyUnit)
               {
                  this.attackUnit(_loc2_ as PvPEnemyUnit);
               }
            }
         }
         mObject.destroy();
         _loc1_.updateGrid();
      }
      
      private function attackUnit(param1:PvPEnemyUnit) : void
      {
         var _loc10_:Item = null;
         if(!param1 || !param1.isAlive())
         {
            Utils.LogError("Firemission: Enemy not found");
            return;
         }
         var _loc2_:GameState = GameState.mInstance;
         var _loc3_:IsometricScene = _loc2_.mScene;
         var _loc4_:GamePlayerProfile = _loc2_.mPlayerProfile;
         var _loc5_:* = param1.getHealth() - this.mItem.mDamage <= 0;
         var _loc6_:int = param1.mHitRewardXP;
         var _loc7_:int = param1.mHitRewardMoney;
         var _loc8_:int = param1.mHitRewardMaterial;
         var _loc9_:int = param1.mHitRewardSupplies;
         if(_loc5_)
         {
            _loc6_ += param1.mKillRewardXP;
            _loc7_ += param1.mKillRewardMoney;
            _loc9_ += param1.mKillRewardSupplies;
         }
         _loc2_.mScene.addLootReward(ItemManager.getItem("XP","Resource"),_loc6_,param1.getContainer());
         _loc2_.mScene.addLootReward(ItemManager.getItem("Money","Resource"),_loc7_,param1.getContainer());
         _loc2_.mScene.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc9_,param1.getContainer());
         if(_loc5_)
         {
            ++mKilledEnemyCount;
            _loc10_ = (param1.mItem as TargetItem).getRandomItemDrop();
            _loc2_.mScene.addLootReward(_loc10_,1,param1.getContainer());
         }
         param1.reduceHealth(this.mItem.mDamage);
      }
   }
}
