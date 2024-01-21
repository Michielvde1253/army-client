package game.actions
{
   import game.characters.AnimationController;
   import game.characters.PlayerUnit;
   import game.gameElements.EnemyInstallationObject;
   import game.isometric.GridCell;
   import game.net.ServiceIDs;
   import game.states.GameState;
   import game.utils.EffectController;
   
   public class EnemyInstallationAttackingAction extends Action
   {
      
      private static const STATE_BEFORE_ATTACK:int = 0;
      
      private static const STATE_ATTACKING:int = 1;
      
      private static const STATE_OVER:int = 2;
       
      
      private var mDurationAttack:int;
      
      public var mPlayerUnit:PlayerUnit;
      
      private var mTimer:int;
      
      private var mState:int;
      
      private var mNewState:int;
      
      public function EnemyInstallationAttackingAction(param1:EnemyInstallationObject, param2:PlayerUnit)
      {
         super("AttackPlayerByEnemyInstallation");
         mActor = param1;
         this.mPlayerUnit = param2;
         this.mTimer = 0;
         this.mState = -1;
         this.mNewState = -1;
      }
      
      override public function update(param1:int) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(mSkipped)
         {
            return;
         }
         if(this.mNewState != this.mState)
         {
            this.changeState(this.mNewState);
         }
         this.mTimer += param1;
         switch(this.mState)
         {
            case STATE_BEFORE_ATTACK:
               _loc2_ = false;
               if(this.mPlayerUnit)
               {
                  if(this.mPlayerUnit.isStill())
                  {
                     if(this.mPlayerUnit.isAlive())
                     {
                        _loc2_ = true;
                     }
                  }
               }
               else
               {
                  _loc3_ = GameState.mInstance.searchNearbyUnits(mActor.getCell(),(mActor as EnemyInstallationObject).mAttackRange,mActor.getTileSize().x,mActor.getTileSize().y);
                  if(_loc3_)
                  {
                     if(_loc3_.length > 0)
                     {
                        _loc4_ = Math.random() * _loc3_.length;
                        this.mPlayerUnit = _loc3_[_loc4_] as PlayerUnit;
                        _loc2_ = true;
                     }
                  }
               }
               if(_loc2_)
               {
                  this.mNewState = STATE_ATTACKING;
               }
               else
               {
                  this.mNewState = STATE_OVER;
               }
               break;
            case STATE_ATTACKING:
               if(this.mTimer > this.mDurationAttack)
               {
                  this.mNewState = STATE_OVER;
               }
         }
      }
      
      private function changeState(param1:int) : void
      {
         var _loc2_:int = 0;
         this.mTimer = 0;
         this.mState = param1;
         this.mNewState = param1;
         switch(this.mState)
         {
            case STATE_ATTACKING:
               mActor.playCollectionSound(mActor.mAttackSounds);
               mActor.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_SHOOT,false,true);
               this.mPlayerUnit.setAnimationAction(AnimationController.CHARACTER_ANIMATION_HIT,false,true);
               this.mPlayerUnit.showActingHealthBar();
               this.mDurationAttack = 0;
               _loc2_ = (mActor as EnemyInstallationObject).getShootingEffect();
               GameState.mInstance.mScene.addEffect(null,_loc2_,this.mPlayerUnit.mX,this.mPlayerUnit.mY);
               this.mDurationAttack = EffectController.getEffectLength(_loc2_);
               this.execute();
               break;
            case STATE_OVER:
               if(this.mPlayerUnit)
               {
                  if(this.mPlayerUnit.isAlive())
                  {
                     this.mPlayerUnit.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                     this.mPlayerUnit = null;
                  }
               }
               if(mActor.isAlive())
               {
                  mActor.setAnimationAction(AnimationController.INSTALLATION_ANIMATION_IDLE,false,true);
                  (mActor as EnemyInstallationObject).changeReactionState(EnemyInstallationObject.REACT_STATE_ACTION_COMPLETED);
               }
         }
      }
      
      override public function isOver() : Boolean
      {
         return this.mState == STATE_OVER || mSkipped;
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         if(Boolean(mActor) && mActor.isAlive())
         {
            this.mNewState = STATE_BEFORE_ATTACK;
         }
         else
         {
            skip();
         }
      }
      
      private function execute() : void
      {
         var _loc4_:Object = null;
         var _loc1_:int = (mActor as EnemyInstallationObject).getPower();
         if(Config.DEBUG_MODE)
         {
         }
         if(!this.mPlayerUnit || !this.mPlayerUnit.isAlive())
         {
            Utils.LogError("EnemyInstallationAttackAction: Player unit not found");
            this.mNewState = STATE_OVER;
            return;
         }
         if(this.mState != STATE_ATTACKING)
         {
            Utils.LogError("EnemyInstallationAttackAction: Illegal state");
            this.mNewState = STATE_OVER;
            return;
         }
         this.mPlayerUnit.reduceHealth(_loc1_);
         (mActor as EnemyInstallationObject).changeReactionState(EnemyInstallationObject.REACT_STATE_ACTION_COMPLETED);
         var _loc2_:GridCell = mActor.getCell();
         var _loc3_:GridCell = this.mPlayerUnit.getCell();
         if(!(mActor as EnemyInstallationObject).isTurnBased())
         {
            _loc4_ = {
               "enemy_coord_x":_loc2_.mPosI,
               "enemy_coord_y":_loc2_.mPosJ,
               "coord_x":_loc3_.mPosI,
               "coord_y":_loc3_.mPosJ,
               "item_hit_points":_loc1_
            };
            GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.ATTACK_PLAYER_UNIT,_loc4_,false);
            if(Config.DEBUG_MODE)
            {
            }
         }
         else
         {
            _loc4_ = {
               "enemy_coord_x":_loc2_.mPosI,
               "enemy_coord_y":_loc2_.mPosJ,
               "item_hit_points":_loc1_,
               "reward_xp":0,
               "reward_money":0,
               "reward_supplies":0,
               "reward_energy":0,
               "player_coords":_loc3_.mPosI + "," + _loc3_.mPosJ
            };
            GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.ACTIVATE_TURN_BASED_ENEMY,_loc4_,false);
            if(Config.DEBUG_MODE)
            {
            }
         }
      }
   }
}
