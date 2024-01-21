package game.actions
{
   import game.battlefield.MapArea;
   import game.battlefield.MapData;
   import game.characters.AnimationController;
   import game.characters.EnemyUnit;
   import game.characters.PlayerUnit;
   import game.gameElements.DecorationObject;
   import game.gameElements.EnemyInstallationObject;
   import game.gameElements.FireMissionObject;
   import game.gameElements.HFEPlotObject;
   import game.gameElements.PlayerBuildingObject;
   import game.gameElements.PlayerInstallationObject;
   import game.gameElements.ResourceBuildingObject;
   import game.gameElements.SignalObject;
   import game.gameElements.SpawningBeaconObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.elements.Renderable;
   import game.items.DecorationItem;
   import game.items.EnemyInstallationItem;
   import game.items.FireMissionItem;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.TargetItem;
   import game.magicBox.FlurryEvents;
   import game.magicBox.MagicBoxTracker;
   import game.missions.MissionManager;
   import game.net.MyServer;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.player.Inventory;
   import game.states.GameState;
   
   public class FireMissionAction extends Action
   {
      
      protected static const COORD_PAIR_DELIMITER_STR:String = ";";
      
      protected static const COORD_XY_DELIMITER_STR:String = ",";
       
      
      protected var mObject:FireMissionObject;
      
      protected var mGC:GridCell;
      
      protected var mItem:FireMissionItem;
      
      protected var mTargets:Array;
      
      protected var mKilledEnemyCount:int;
      
      private var mLastAttackDamageInstallations:Array;
      
      public function FireMissionAction(param1:GridCell, param2:FireMissionItem)
      {
         super("FireMission");
         this.mGC = param1;
         this.mItem = param2;
         this.mLastAttackDamageInstallations = new Array();
      }
      
      override public function update(param1:int) : void
      {
         if(this.mObject)
         {
            this.mObject.update();
            if(this.mObject.isOver())
            {
               if(!mSkipped)
               {
                  this.execute();
               }
            }
            if(this.mObject.isOver() || mSkipped)
            {
               this.mObject.destroy();
            }
         }
      }
      
      override public function isOver() : Boolean
      {
         return (!!this.mObject ? this.mObject.isOver() : true) || mSkipped;
      }
      
      protected function hasIngredients() : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:Item = null;
         var _loc1_:Inventory = GameState.mInstance.mPlayerProfile.mInventory;
         for(_loc2_ in this.mItem.mRequiredItemSet.mItems)
         {
            _loc3_ = this.mItem.mRequiredItemSet.mItems[_loc2_];
            if(_loc1_.getNumberOfItems(_loc3_) < this.mItem.mRequiredItemSet.mAmounts[_loc2_])
            {
               if(Config.DEBUG_MODE)
               {
               }
               return false;
            }
         }
         return true;
      }
      
      override public function start() : void
      {
         var _loc1_:GameState = null;
         var _loc4_:Renderable = null;
         var _loc7_:GridCell = null;
         if(!this.hasIngredients())
         {
            this.skip();
         }
         if(mSkipped)
         {
            return;
         }
         _loc1_ = GameState.mInstance;
         var _loc2_:Array = MapArea.getArea(_loc1_.mScene,this.mGC.mPosI,this.mGC.mPosJ,this.mItem.mSize.x,this.mItem.mSize.y).getCells();
         this.mObject = new FireMissionObject(this.mItem,_loc2_);
         this.mTargets = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if((_loc7_ = _loc2_[_loc3_]).mCharacter)
            {
               this.mTargets.push(_loc7_.mCharacter);
            }
            else if(_loc7_.mObject)
            {
               this.mTargets.push(_loc7_.mObject);
            }
            _loc3_++;
         }
         var _loc5_:int = int(this.mTargets.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if((_loc4_ = this.mTargets[_loc6_] as Renderable) is EnemyInstallationObject)
            {
               if((_loc4_ as EnemyInstallationObject).isForceFieldActivated())
               {
                  (_loc4_ as EnemyInstallationObject).setAnimationAction(AnimationController.INSTALLATION_ANIMATION_HIT,false,true);
               }
            }
            _loc6_++;
         }
         this.mObject.start();
         _loc1_.mScene.mSceneHud.addChild(this.mObject);
         this.mObject.x = _loc1_.mScene.mGridDimX * this.mGC.mPosI;
         this.mObject.y = _loc1_.mScene.mGridDimY * this.mGC.mPosJ;
      }
      
      protected function execute() : void
      {
         var _loc7_:Renderable = null;
         var _loc10_:Object = null;
         var _loc13_:GridCell = null;
         var _loc16_:Boolean = false;
         var _loc17_:Object = null;
         var _loc18_:Object = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Item = null;
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = [0,0,0,0];
         var _loc5_:int = _loc1_.mPlayerProfile.mRewardDropsCounter;
         this.mKilledEnemyCount = 0;
         var _loc6_:String = "";
         var _loc8_:int = int(this.mTargets.length);
         var _loc9_:int = 0;
         for(; _loc9_ < _loc8_; _loc9_++)
         {
            if((_loc7_ = this.mTargets[_loc9_] as Renderable).mScene)
            {
               _loc16_ = true;
               if(_loc7_ is PlayerUnit)
               {
                  this.damageOwnUnit(_loc7_ as PlayerUnit);
               }
               else if(_loc7_ is PlayerBuildingObject)
               {
                  if(_loc7_ is ResourceBuildingObject || _loc7_ is SignalObject)
                  {
                     continue;
                  }
                  this.damageOwnBuilding(_loc7_ as PlayerBuildingObject);
               }
               else if(_loc7_ is PlayerInstallationObject)
               {
                  this.damageOwnInstallation(_loc7_ as PlayerInstallationObject);
               }
               else if(_loc7_ is EnemyUnit)
               {
                  _loc16_ = this.attackUnit(_loc7_ as EnemyUnit,_loc2_,_loc3_,_loc4_);
               }
               else if(_loc7_ is EnemyInstallationObject)
               {
                  if(!(_loc7_ is SpawningBeaconObject))
                  {
                     if(!(_loc16_ = this.attackInstallation(_loc7_ as EnemyInstallationObject,_loc2_,_loc3_,_loc4_)))
                     {
                        if((_loc7_ as EnemyInstallationObject).isForceFieldActivated())
                        {
                           (_loc7_ as EnemyInstallationObject).setAnimationAction(AnimationController.INSTALLATION_ANIMATION_IDLE,false,true);
                        }
                     }
                  }
               }
               if(_loc16_)
               {
                  if(_loc6_.length > 0)
                  {
                     _loc6_ += COORD_PAIR_DELIMITER_STR;
                  }
                  _loc6_ = _loc6_ + _loc7_.getCell().mPosI + COORD_XY_DELIMITER_STR + _loc7_.getCell().mPosJ;
               }
            }
         }
         if(this.mItem.mlaunchWithGold)
         {
            _loc10_ = {
               "fire_mission_id":this.mItem.mId,
               "coords":_loc6_,
               "cost_energy":1,
               "gold":this.mItem.mUnlockCost,
               "reward_xp":_loc4_[0],
               "reward_money":_loc4_[1],
               "reward_supplies":_loc4_[2],
               "reward_energy":_loc4_[3]
            };
         }
         else
         {
            _loc10_ = {
               "fire_mission_id":this.mItem.mId,
               "coords":_loc6_,
               "cost_energy":1,
               "gold":0,
               "reward_xp":_loc4_[0],
               "reward_money":_loc4_[1],
               "reward_supplies":_loc4_[2],
               "reward_energy":_loc4_[3]
            };
         }
         if(_loc1_.mMapData.mMapSetupData.Resource)
         {
            _loc10_[MyServer.MAP_RESOURCE_COST_NAMES[_loc1_.mMapData.mMapSetupData.Resource]] = 1;
         }
         if(this.mKilledEnemyCount > 0)
         {
            _loc10_.reward_drop_seed_term = _loc1_.mPlayerProfile.mRewardDropSeedTerm;
            _loc10_.reward_drops_counter = _loc5_;
            _loc10_.reward_drops_counter_delta = this.mKilledEnemyCount;
         }
         if(_loc2_.length > 0)
         {
            _loc10_.reward_item_type = _loc2_.toString();
            _loc10_.reward_item_id = _loc3_.toString();
         }
         var _loc11_:String = null;
         if(_loc1_.visitingFriend())
         {
            _loc11_ = _loc1_.mVisitingFriend.mFacebookID;
         }
         MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_GAME,MagicBoxTracker.TYPE_FIRE_MISSION,this.mItem.mId,MagicBoxTracker.paramsObj(this.mItem.mId,_loc11_));
         if(this.mLastAttackDamageInstallations.length > 0)
         {
            _loc19_ = 0;
            while(_loc19_ < this.mLastAttackDamageInstallations.length)
            {
               if(_loc19_ == this.mLastAttackDamageInstallations.length - 1)
               {
                  GameState.mInstance.queueAction(new LastAttackAction(this.mLastAttackDamageInstallations[_loc20_],ServiceIDs.USE_FIRE_MISSION,_loc10_),true);
               }
               else
               {
                  GameState.mInstance.queueAction(new LastAttackAction(this.mLastAttackDamageInstallations[_loc20_],null,null),true);
               }
               if(Config.DEBUG_MODE)
               {
               }
               _loc19_++;
            }
         }
         else
         {
            _loc1_.mServer.serverCallServiceWithParameters(ServiceIDs.USE_FIRE_MISSION,_loc10_,false);
         }
         var _loc12_:Array;
         var _loc14_:int = int((_loc12_ = MapArea.getArea(_loc1_.mScene,this.mGC.mPosI,this.mGC.mPosJ,this.mItem.mSize.x,this.mItem.mSize.y).getCells()).length);
         var _loc15_:int = 0;
         while(_loc15_ < _loc14_)
         {
            _loc13_ = _loc12_[_loc15_] as GridCell;
            if(MapData.isTilePassable(_loc13_.mType))
            {
               if(!_loc13_.mObject && !_loc13_.mCharacter)
               {
                  _loc1_.spawnNewDebris("ScorchedGround","Debris",_loc1_.mScene.getCenterPointXOfCell(_loc13_),_loc1_.mScene.getCenterPointYOfCell(_loc13_));
               }
               else if(_loc13_.mObject && (_loc13_.mObject is DecorationObject && DecorationObject(_loc13_.mObject).getHealth() == 0 && !DecorationItem(_loc13_.mObject.mItem).mLeaveRuins) || _loc13_.mObject is EnemyInstallationObject && EnemyInstallationObject(_loc13_.mObject).getHealth() == 0 || _loc13_.mObject is HFEPlotObject && HFEPlotObject(_loc13_.mObject).getHealth() == 0)
               {
                  _loc13_.mObject.mKilledByFireMission = true;
               }
               else if(_loc13_.mCharacter)
               {
                  if(_loc13_.mCharacter.getHealth() > 0)
                  {
                     _loc1_.spawnNewDebris("ScorchedGround","Debris",_loc1_.mScene.getCenterPointXOfCell(_loc13_),_loc1_.mScene.getCenterPointYOfCell(_loc13_));
                  }
                  else if(!(_loc13_.mCharacter is PlayerUnit))
                  {
                     _loc13_.mCharacter.mKilledByFireMission = true;
                  }
               }
            }
            _loc15_++;
         }
         if(!this.mItem.mlaunchWithGold)
         {
            while(_loc20_ < this.mItem.mRequiredItemSet.mItems.length)
            {
               if(_loc21_ = this.mItem.mRequiredItemSet.mItems[_loc20_])
               {
                  _loc1_.mPlayerProfile.addItem(_loc21_,-this.mItem.mRequiredItemSet.mAmounts[_loc20_]);
               }
               _loc20_++;
            }
         }
         _loc1_.reduceEnergy(mName,1,MagicBoxTracker.paramsObj(this.mItem.mType,this.mItem.mId));
         _loc1_.reduceMapResource(1);
         this.mObject.destroy();
         _loc1_.updateGrid();
         _loc1_.playerMoveMade();
         if(this.mItem.mlaunchWithGold)
         {
            this.mItem.mlaunchWithGold = false;
         }
      }
      
      protected function damageOwnBuilding(param1:PlayerBuildingObject) : void
      {
         param1.addHealth(-this.mItem.mDamage);
      }
      
      protected function damageOwnInstallation(param1:PlayerInstallationObject) : void
      {
         param1.reduceHealth(this.mItem.mDamage);
      }
      
      protected function damageOwnUnit(param1:PlayerUnit) : void
      {
         param1.reduceHealth(this.mItem.mDamage);
      }
      
      private function attackUnit(param1:EnemyUnit, param2:Array, param3:Array, param4:Array) : Boolean
      {
         var _loc15_:Item = null;
         if(!param1 || !param1.isAlive())
         {
            Utils.LogError("Firemission: Enemy not found");
            return false;
         }
         var _loc5_:GameState;
         var _loc6_:IsometricScene = (_loc5_ = GameState.mInstance).mScene;
         var _loc7_:GamePlayerProfile = _loc5_.mPlayerProfile;
         var _loc8_:* = param1.getHealth() - this.mItem.mDamage <= 0;
         var _loc9_:int = param1.mHitRewardXP;
         var _loc10_:int = param1.mHitRewardMoney;
         var _loc11_:int = param1.mHitRewardMaterial;
         var _loc12_:int = param1.mHitRewardSupplies;
         var _loc13_:int = param1.mHitRewardEnergy;
         if(_loc8_)
         {
            _loc9_ += param1.mKillRewardXP;
            _loc10_ += param1.mKillRewardMoney;
            _loc12_ += param1.mKillRewardSupplies;
            _loc13_ += param1.mKillRewardEnergy;
            MissionManager.increaseCounter("KillWith",this.mItem,1);
         }
         param4[0] += _loc9_;
         param4[1] += _loc10_;
         param4[2] += _loc12_;
         param4[3] += _loc13_;
         _loc7_.increaseEnergyRewardCounter(_loc13_);
         var _loc14_:int = _loc7_.getBonusEnergy();
         _loc5_.mScene.addLootReward(ItemManager.getItem("XP","Resource"),_loc9_,param1.getContainer());
         _loc5_.mScene.addLootReward(ItemManager.getItem("Money","Resource"),_loc10_,param1.getContainer());
         _loc5_.mScene.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc12_,param1.getContainer());
         _loc5_.mScene.addLootReward(ItemManager.getItem("Energy","Resource"),_loc14_,param1.getContainer());
         if(_loc8_)
         {
            ++this.mKilledEnemyCount;
            _loc15_ = (param1.mItem as TargetItem).getRandomItemDrop();
            _loc5_.mScene.addLootReward(_loc15_,1,param1.getContainer());
         }
         if(_loc15_)
         {
            param2.push(ItemManager.getTableNameForItem(_loc15_));
            param3.push(_loc15_.mId);
         }
         param1.reduceHealth(this.mItem.mDamage);
         param1.changeReactionState(EnemyUnit.REACT_STATE_WAIT_FOR_TIMER);
         return true;
      }
      
      private function attackInstallation(param1:EnemyInstallationObject, param2:Array, param3:Array, param4:Array) : Boolean
      {
         var _loc11_:EnemyInstallationItem = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Item = null;
         if(!param1 || !param1.isAlive())
         {
            Utils.LogError("Firemission: Enemyinstallation not found");
            return false;
         }
         if(param1.isForceFieldActivated())
         {
            return false;
         }
         var _loc5_:GameState;
         var _loc6_:GamePlayerProfile = (_loc5_ = GameState.mInstance).mPlayerProfile;
         var _loc7_:IsometricScene = _loc5_.mScene;
         var _loc8_:int = this.mItem.mDamage;
         var _loc9_:*;
         var _loc10_:Boolean = !(_loc9_ = param1.getHealth() == 0) && param1.getHealth() - _loc8_ <= 0;
         if(!_loc9_)
         {
            _loc12_ = (_loc11_ = param1.mItem as EnemyInstallationItem).mHitRewardXP;
            _loc13_ = _loc11_.mHitRewardMoney;
            _loc14_ = _loc11_.mHitRewardMaterial;
            _loc15_ = _loc11_.mHitRewardSupplies;
            _loc16_ = _loc11_.mHitRewardEnergy;
            if(_loc10_)
            {
               _loc12_ += _loc11_.mKillRewardXP;
               _loc13_ += _loc11_.mKillRewardMoney;
               _loc15_ += _loc11_.mKillRewardSupplies;
               _loc16_ += _loc11_.mKillRewardEnergy;
               MissionManager.increaseCounter("KillWith",this.mItem,1);
            }
            param4[0] += _loc12_;
            param4[1] += _loc13_;
            param4[2] += _loc15_;
            param4[3] += _loc16_;
            _loc6_.increaseEnergyRewardCounter(_loc16_);
            _loc17_ = _loc6_.getBonusEnergy();
            _loc7_.addLootReward(ItemManager.getItem("XP","Resource"),_loc12_,param1.getContainer());
            _loc7_.addLootReward(ItemManager.getItem("Money","Resource"),_loc13_,param1.getContainer());
            _loc7_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc15_,param1.getContainer());
            _loc7_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc17_,param1.getContainer());
            if(_loc10_)
            {
               ++this.mKilledEnemyCount;
               _loc18_ = _loc11_.getRandomItemDrop();
               _loc7_.addLootReward(_loc18_,1,param1.getContainer());
               if(param1.mLastAttackDamage > 0)
               {
                  this.mLastAttackDamageInstallations.push(param1);
               }
            }
            if(_loc18_)
            {
               param2.push(ItemManager.getTableNameForItem(_loc18_));
               param3.push(_loc18_.mId);
            }
            param1.reduceHealth(_loc8_);
            param1.resetReactionTimer();
         }
         return true;
      }
      
      override public function skip() : void
      {
         if(!this.mItem.mlaunchWithGold)
         {
            super.skip();
         }
      }
   }
}
