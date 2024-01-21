package game.characters
{
   import game.actions.Action;
   import game.actions.ActionQueue;
   import game.actions.PvPEnemyMovingAction;
   import game.battlefield.MapData;
   import game.gui.TooltipHealth;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.boundingElements.BoundingCylinder;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.pathfinding.AStarPathfinder;
   import game.items.EnemyUnitItem;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class PvPEnemyUnit extends IsometricCharacter
   {
      
      public static const UNIT_ID_PVP_INFANTRY:String = "PvPInfantry";
      
      public static const UNIT_ID_PVP_APC:String = "PvPAPC";
      
      public static const UNIT_ID_PVP_ARTILLERY:String = "PvPArtillery";
      
      public static const UNIT_ID_PVP_ROCKET_BATTERY:String = "PvPRocketBattery";
      
      public static const UNIT_ID_PVP_SPECIAL_FORCES:String = "PVPSpecialForces";
      
      public static const UNIT_ID_PVP_ELITE_SNIPER:String = "PVPEliteSniper";
      
      public static const UNIT_ID_PVP_BATTLE_TANK:String = "PVPBattleTank";
      
      public static const UNIT_ID_PVP_COMMANDO:String = "PVPCommando";
      
      public static const UNIT_ID_PVP_ELITE_TANK:String = "PVPEliteTank";
      
      public static const UNIT_ID_PVP_ELITE_ROCKET_BATTERY:String = "PVPEliteRocketBattery";
       
      
      public var mUnitId:String;
      
      public var mMovementRange:int;
      
      public var mCurrentAction:Action;
      
      public var mActionQueue:ActionQueue;
      
      public var mHitRewardBadassXP:int;
      
      public var mKillRewardBadassXP:int;
      
      public function PvPEnemyUnit(param1:int, param2:IsometricScene, param3:EnemyUnitItem)
      {
         var _loc4_:Object = null;
         super(param1,param2,param3,null);
         mName = param3.mName;
         this.mUnitId = param3.mId;
         mHealth = param3.mHealth;
         mMaxHealth = mHealth;
         mPower = param3.mDamage;
         mHitRewardXP = param3.mHitRewardXP;
         mHitRewardMoney = param3.mHitRewardMoney;
         mHitRewardMaterial = param3.mHitRewardMaterial;
         mHitRewardSupplies = param3.mHitRewardSupplies;
         mHitRewardEnergy = param3.mHitRewardEnergy;
         mKillRewardXP = param3.mKillRewardXP;
         mKillRewardMoney = param3.mKillRewardMoney;
         mKillRewardMaterial = param3.mKillRewardMaterial;
         mKillRewardSupplies = param3.mKillRewardSupplies;
         mKillRewardEnergy = param3.mKillRewardEnergy;
         this.mHitRewardBadassXP = param3.mHitRewardBadassXP;
         this.mKillRewardBadassXP = param3.mKillRewardBadassXP;
         mAttackRange = param3.mAttackRange;
         this.mMovementRange = param3.mMovementRange;
         var _loc5_:Array = null;
         var _loc6_:int = int((_loc5_ = param3.mPassableGroups).length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc4_ = _loc5_[_loc7_] as Object;
            mMovementFlags |= 1 << MOVER_TYPE_PASSABILITY_OFFSET + MapData.TILE_PASSABILITY_STRING_TO_ID[_loc4_.ID];
            _loc7_++;
         }
         mWeaponType = param3.mWeaponType;
         if(mWeaponType == null)
         {
            mWeaponType = IsometricCharacter.WEAPON_TYPE_EXPLOSION;
         }
         mBoundingElement = new BoundingCylinder(0,0,50,100,25);
         mSpeed = 300;
         mContainer.mouseChildren = false;
         mContainer.mouseEnabled = false;
         initAnimations(param3.mGraphicsArray);
         setPos(500,500,0);
         updateAnimation(true,false);
         mVisible = false;
         mContainer.visible = false;
         updateMovement(0);
         this.mActionQueue = new ActionQueue();
         if(FeatureTuner.USE_SOUNDS)
         {
            this.initSounds();
         }
      }
      
      override protected function initSounds() : void
      {
         super.initSounds();
         mAttackSoundsSecondary = ArmySoundManager.SC_ENM_ATTACK_SECONDARY;
         if(this.mUnitId == UNIT_ID_PVP_INFANTRY)
         {
            mMoveSounds = ArmySoundManager.SC_GENERAL_INFANTRY_MOVING;
            mDieSounds = ArmySoundManager.SC_ENM_INF_DEATH;
            mAttackSounds = ArmySoundManager.SC_ENM_INF_ATTACK;
         }
         else if(this.mUnitId == UNIT_ID_PVP_APC)
         {
            mMoveSounds = ArmySoundManager.SC_APC_MOVING;
            mDieSounds = ArmySoundManager.SC_ENM_APC_DEATH;
            mAttackSounds = ArmySoundManager.SC_ENM_APC_ATTACK;
         }
         else if(this.mUnitId == UNIT_ID_PVP_COMMANDO || this.mUnitId == UNIT_ID_PVP_SPECIAL_FORCES)
         {
            mMoveSounds = ArmySoundManager.SC_GENERAL_INFANTRY_MOVING;
            mDieSounds = ArmySoundManager.SC_ENM_COMMANDO_DEATH;
            mAttackSounds = ArmySoundManager.SC_ENM_COMMANDO_ATTACK;
         }
         else if(this.mUnitId == UNIT_ID_PVP_ELITE_TANK || this.mUnitId == UNIT_ID_PVP_BATTLE_TANK)
         {
            mMoveSounds = ArmySoundManager.SC_TANK_MOVING;
            mDieSounds = ArmySoundManager.SC_ENM_TANK_DEATH;
            mAttackSounds = ArmySoundManager.SC_ENM_TANK_ATTACK;
         }
         else if(this.mUnitId == UNIT_ID_PVP_ARTILLERY)
         {
            mMoveSounds = ArmySoundManager.SC_ARTILLERY_MOVING;
            mDieSounds = ArmySoundManager.SC_ENM_ARTILLERY_DEATH;
            mAttackSounds = ArmySoundManager.SC_ENM_ARTILLERY_ATTACK;
         }
         else if(this.mUnitId == UNIT_ID_PVP_ELITE_ROCKET_BATTERY || this.mUnitId == UNIT_ID_PVP_ROCKET_BATTERY)
         {
            mMoveSounds = ArmySoundManager.SC_ROCKET_MOVING;
            mDieSounds = ArmySoundManager.SC_ROCKET_DEATH;
            mAttackSounds = ArmySoundManager.SC_ROCKET_ATTACK;
         }
         else
         {
            if(this.mUnitId != UNIT_ID_PVP_ELITE_SNIPER)
            {
               mMoveSounds = ArmySoundManager.SC_GENERAL_INFANTRY_MOVING;
               mDieSounds = ArmySoundManager.SC_ENM_INF_DEATH;
               mAttackSounds = ArmySoundManager.SC_ENM_INF_ATTACK;
               throw new Error("No sounds for EnemyUnit:" + mItem.mType + " id: " + mItem.mId);
            }
            mMoveSounds = ArmySoundManager.SC_GENERAL_INFANTRY_MOVING;
            mDieSounds = ArmySoundManager.SC_ENM_INF_DEATH;
            mAttackSounds = ArmySoundManager.SC_ENM_SNIPER_SHOOT;
         }
         mDieSounds.load();
         mAttackSounds.load();
         mAttackSoundsSecondary.load();
         mMoveSounds.load();
      }
      
      override public function update(param1:int) : void
      {
         super.update(param1);
         if(!isAlive())
         {
            return;
         }
         if(mState == STATE_SUPPRESS)
         {
            if(mActionDelayTimer <= 0)
            {
               mState = STATE_WALKING;
            }
         }
      }
      
      override public function die() : void
      {
         super.die();
         var _loc1_:* = Math.random() * 100 < GameState.mConfig.DebrisSetup.SpawnAfterEnemy.Probability;
         _loc1_ = false;
         if(_loc1_)
         {
            GameState.mInstance.spawnNewDebris(GameState.mConfig.DebrisSetup.SpawnAfterEnemy.DebrisObject.ID,GameState.mConfig.DebrisSetup.SpawnAfterEnemy.DebrisObject.Type,mX,mY);
         }
      }
      
      override public function updateActions(param1:int) : void
      {
         if(this.mCurrentAction != null)
         {
            this.mCurrentAction.update(param1);
            if(this.mCurrentAction)
            {
               if(this.mCurrentAction.isOver())
               {
                  this.mCurrentAction = null;
               }
            }
         }
         if(this.mCurrentAction == null)
         {
            if(this.mActionQueue.mActions.length > 0)
            {
               this.mCurrentAction = this.mActionQueue.mActions.shift();
               this.mCurrentAction.start();
            }
         }
      }
      
      override public function reduceHealth(param1:int, param2:int = 0) : void
      {
         super.reduceHealth(param1,param2);
      }
      
      public function queueAction(param1:Action, param2:Boolean = false) : void
      {
         if(param2)
         {
            this.mActionQueue.mActions.length = 0;
            this.mCurrentAction = null;
         }
         GameState.mInstance.queueAction(param1,true);
      }
      
      public function attackPlayerUnit(param1:PlayerUnit = null) : void
      {
         if(!isAlive())
         {
            return;
         }
         if(param1)
         {
            if(Math.abs(param1.getCell().mPosI - getCell().mPosI) > mAttackRange || Math.abs(param1.getCell().mPosJ - getCell().mPosJ) > mAttackRange)
            {
               return;
            }
         }
      }
      
      public function move(param1:GridCell = null) : void
      {
         this.queueAction(new PvPEnemyMovingAction(this,param1));
      }
      
      override public function updateTooltip(param1:int, param2:TooltipHealth) : void
      {
         super.updateTooltip(param1,param2);
         if(mState == STATE_SUPPRESS)
         {
            param2.setDetailsText(GameState.getText("UNIT_STATUS_SUPPRESS"));
         }
      }
      
      public function getPlayerInShootRange() : PlayerUnit
      {
         var _loc7_:PlayerUnit = null;
         var _loc9_:GridCell = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = getCell().mPosI - getAttackRange();
         var _loc3_:int = getCell().mPosI + getAttackRange();
         var _loc4_:int = getCell().mPosJ - getAttackRange();
         var _loc5_:int = getCell().mPosJ + getAttackRange();
         var _loc6_:Array = mScene.getPlayerAliveUnits();
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_.length)
         {
            if((_loc9_ = _loc7_.getCell()).mPosI >= _loc2_)
            {
               if(_loc9_.mPosI <= _loc3_)
               {
                  if(_loc9_.mPosJ >= _loc4_)
                  {
                     if(_loc9_.mPosJ <= _loc5_)
                     {
                        _loc1_.push(_loc7_);
                     }
                  }
               }
            }
            _loc8_++;
         }
         if(Boolean(_loc1_) && _loc1_.length > 0)
         {
            return _loc1_[Math.floor(Math.random() * _loc1_.length)];
         }
         return null;
      }
      
      override protected function updateHintHealth() : void
      {
         super.updateHintHealth();
      }
      
      public function getMovementRadius() : int
      {
         return this.mMovementRange;
      }
      
      public function canAttack(param1:PlayerUnit) : Boolean
      {
         return Math.abs(getCell().mPosI - param1.getCell().mPosI) <= getAttackRange() && Math.abs(getCell().mPosJ - param1.getCell().mPosJ) <= getAttackRange();
      }
      
      public function getStrikeKillCell(param1:PlayerUnit) : GridCell
      {
         if(getPower() <= 0)
         {
            return null;
         }
         var _loc2_:int = Math.ceil(param1.getHealth() / getPower());
         var _loc3_:int = GameState.mInstance.mPvPMatch.mActionsLeft - _loc2_;
         if(_loc3_ >= 0 && this.canAttack(param1))
         {
            return getCell();
         }
         if(_loc3_ < 0)
         {
            return null;
         }
         var _loc4_:Array = this.getWalkableCells(_loc3_ * this.getMovementRadius());
         var _loc5_:Array = new Array();
         mScene.getNeighboringCellsAtDistance(param1,getAttackRange(),_loc5_);
         var _loc6_:GridCell = mScene.chooseCellClosestToCell(_loc5_,getCell());
         if(_loc4_.indexOf(_loc6_) >= 0)
         {
            return _loc6_;
         }
         return null;
      }
      
      public function getWalkableCells(param1:int = -1) : Array
      {
         var _loc6_:GridCell = null;
         var _loc10_:GridCell = null;
         var _loc13_:GridCell = null;
         var _loc14_:Array = null;
         var _loc15_:GridCell = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:int = this.mMovementFlags;
         if(param1 < 0)
         {
            param1 = this.getMovementRadius();
         }
         var _loc4_:GridCell = mScene.getCellAtLocation(mX,mY);
         var _loc5_:Array = new Array();
         AStarPathfinder.getAllSurroundingCells(mScene,_loc4_,param1 + 1,_loc5_);
         var _loc7_:int = int(_loc5_.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            if(_loc6_ = _loc5_[_loc8_] as GridCell)
            {
               _loc6_.mParent = null;
               _loc6_.mG = 99999999;
            }
            _loc8_++;
         }
         var _loc9_:Array;
         (_loc9_ = new Array()).push(_loc4_);
         _loc4_.mParent = _loc4_;
         _loc4_.mG = 0;
         while(_loc9_.length > 0)
         {
            _loc13_ = _loc9_.shift();
            _loc14_ = new Array();
            AStarPathfinder.getAccesibleSurroundingCells(mScene,_loc13_,_loc14_,_loc3_);
            _loc16_ = int(_loc14_.length);
            _loc17_ = 0;
            while(_loc17_ < _loc16_)
            {
               _loc15_ = _loc14_[_loc17_] as GridCell;
               if(_loc13_.mG <= param1 - 0.5)
               {
                  if(_loc15_.mG > _loc13_.mG + _loc15_.mPathCost && _loc9_.indexOf(_loc15_) == -1 && _loc5_.indexOf(_loc15_) != -1)
                  {
                     _loc9_.push(_loc15_);
                     _loc15_.mG = _loc13_.mG + _loc15_.mPathCost;
                     _loc15_.mParent = _loc13_;
                  }
               }
               _loc17_++;
            }
         }
         var _loc11_:int = int(_loc5_.length);
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_)
         {
            if((Boolean(_loc10_ = _loc5_[_loc12_] as GridCell)) && _loc10_.mWalkable)
            {
               if(_loc10_ != _loc4_)
               {
                  if(!_loc10_.mCharacter)
                  {
                     if(!_loc10_.mObject || _loc10_.mObject.isWalkable())
                     {
                        if(_loc10_.mG < param1 + 0.5)
                        {
                           _loc2_.push(_loc10_);
                        }
                     }
                  }
               }
            }
            _loc12_++;
         }
         return _loc2_;
      }
      
      public function getAttackPriority(param1:IsometricCharacter, param2:Number = 0.5) : Number
      {
         var _loc3_:* = false;
         var _loc4_:Array = this.getWalkableCells();
         var _loc5_:Array = new Array();
         mScene.getNeighboringCellsAtDistance(param1,getAttackRange(),_loc5_);
         var _loc6_:GridCell = mScene.chooseCellClosestToCell(_loc5_,getCell());
         _loc3_ = _loc4_.indexOf(_loc6_) >= 0;
         var _loc7_:Number = (_loc7_ = getActorPriority() + param1.getTargetPriority()) / 2;
         if(!_loc3_)
         {
            _loc7_ *= 0.8 - 0.6 * param2;
         }
         return _loc7_;
      }
   }
}
