package game.actions
{
   import game.characters.AnimationController;
   import game.characters.EnemyUnit;
   import game.gameElements.PlayerInstallationObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.Renderable;
   import game.net.ServiceIDs;
   import game.states.GameState;
   
   public class EnemyAttackingPlayerInstallationAction extends Action
   {
      
      private static const STATE_BEFORE_ATTACK:int = 0;
      
      private static const STATE_ATTACKING:int = 1;
      
      private static const STATE_MOVE:int = 2;
      
      private static const STATE_OVER:int = 3;
       
      
      private var mTimer:int;
      
      private var mState:int;
      
      private var mNewState:int;
      
      public function EnemyAttackingPlayerInstallationAction(param1:EnemyUnit, param2:PlayerInstallationObject)
      {
         super("EnemyAttackingPlayerInstallationAction");
         mActor = param1;
         mTarget = param2;
         this.mTimer = 0;
         this.mState = -1;
         this.mNewState = -1;
      }
      
      override public function update(param1:int) : void
      {
         if(this.mState == STATE_OVER || mSkipped)
         {
            return;
         }
         if(mActor == null || !mActor.isAlive())
         {
            skip();
            return;
         }
         if(this.mNewState != this.mState)
         {
            this.changeState(this.mNewState);
         }
         else
         {
            switch(this.mState)
            {
               case STATE_BEFORE_ATTACK:
                  this.mTimer += param1;
                  if(this.mTimer >= Renderable.GENERIC_ACTION_DELAY_TIME)
                  {
                     this.mNewState = STATE_ATTACKING;
                  }
                  break;
               case STATE_ATTACKING:
                  if(mActor.getCurrentAnimationFrameLabel() == "end" || this.mTimer >= GameState.mConfig.GraphicSetup.Shooting.Length)
                  {
                     this.mNewState = STATE_OVER;
                  }
                  this.mTimer += param1;
            }
         }
      }
      
      private function changeState(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:IsometricScene = null;
         var _loc5_:PlayerInstallationObject = null;
         var _loc6_:EnemyUnit = null;
         var _loc7_:GridCell = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         this.mTimer = 0;
         this.mState = param1;
         this.mNewState = param1;
         switch(this.mState)
         {
            case STATE_BEFORE_ATTACK:
               if(GameState.mInstance.mScene.isInsideVisibleArea(mActor.getCell()))
               {
                  mActor.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                  mActor.showLoadingBar();
               }
               else
               {
                  this.mNewState = STATE_MOVE;
               }
               break;
            case STATE_MOVE:
               GameState.mInstance.queueAction(new EnemyMovingAction(mActor as EnemyUnit),true);
               this.mNewState = STATE_OVER;
               break;
            case STATE_ATTACKING:
               if(mActor)
               {
                  mActor.playCollectionSound(mActor.mAttackSounds);
               }
               else
               {
                  playAttackSoundsForAttackers();
               }
               (mActor as IsometricCharacter).shootTo(mTarget.mX,mTarget.mY);
               mTarget.showActingHealthBar();
               _loc2_ = mTarget.mX;
               _loc3_ = mTarget.mY;
               _loc4_ = GameState.mInstance.mScene;
               if(mTarget.getTileSize().x > 1)
               {
                  _loc2_ += Math.random() * ((mTarget.getTileSize().x - 1) * _loc4_.mGridDimX);
               }
               if(mTarget.getTileSize().y > 1)
               {
                  _loc3_ += Math.random() * ((mTarget.getTileSize().y - 1) * _loc4_.mGridDimY);
               }
               _loc4_.addEffect(null,(mActor as IsometricCharacter).getShootingEffect(),_loc2_,_loc3_);
               this.execute();
               break;
            case STATE_OVER:
               mActor.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
               if((_loc5_ = mTarget as PlayerInstallationObject).canAttack())
               {
                  if(!_loc5_.hasAttackActionInQueue())
                  {
                     _loc7_ = (_loc6_ = mActor as EnemyUnit).getCell();
                     _loc8_ = _loc5_.mAttackRange;
                     _loc9_ = _loc5_.getCell().mPosI;
                     _loc10_ = _loc5_.getTileSize().x;
                     if(_loc7_.mPosI >= _loc9_ - _loc8_)
                     {
                        if(_loc7_.mPosI < _loc9_ + _loc10_ + _loc8_)
                        {
                           _loc11_ = _loc5_.getCell().mPosJ;
                           _loc12_ = _loc5_.getTileSize().y;
                           if(_loc7_.mPosJ >= _loc11_ - _loc8_)
                           {
                              if(_loc7_.mPosJ < _loc11_ + _loc12_ + _loc8_)
                              {
                                 GameState.mInstance.queueAction(new AttackEnemyAction(null,_loc5_,_loc6_,false));
                              }
                           }
                        }
                     }
                  }
               }
               (mActor as EnemyUnit).changeReactionState(EnemyUnit.REACT_STATE_ACTION_COMPLETED);
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
         if(this.isLegal())
         {
            this.mNewState = STATE_ATTACKING;
            setDirection(mTarget.mX);
         }
         else
         {
            skip();
            this.mNewState = STATE_OVER;
         }
      }
      
      private function isLegal() : Boolean
      {
         var _loc1_:GridCell = null;
         var _loc2_:GridCell = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         if(Boolean(mActor) && mActor.isAlive())
         {
            _loc1_ = mTarget.getCell();
            _loc2_ = mActor.getCell();
            _loc3_ = (_loc1_.mPosI - _loc2_.mPosI) * (_loc1_.mPosI - _loc2_.mPosI);
            _loc4_ = (_loc1_.mPosJ - _loc2_.mPosJ) * (_loc1_.mPosJ - _loc2_.mPosJ);
            _loc5_ = Math.SQRT2 * (mActor as IsometricCharacter).getAttackRange();
            if(_loc3_ + _loc4_ <= _loc5_ * _loc5_)
            {
               if((mTarget as PlayerInstallationObject).getHealthPercentage() > 0)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function execute() : void
      {
         if(!mTarget)
         {
            Utils.LogError("EnemyAttackingPlayerInstallation: Target not found");
            this.mNewState = STATE_OVER;
            return;
         }
         if(this.mState != STATE_ATTACKING)
         {
            Utils.LogError("EnemyAttackingPlayerInstallation: Illegal state");
            this.mNewState = STATE_OVER;
            return;
         }
         var _loc1_:int = (mActor as IsometricCharacter).getPower();
         var _loc2_:PlayerInstallationObject = mTarget as PlayerInstallationObject;
         _loc2_.reduceHealth(_loc1_);
         if(!_loc2_.isAlive())
         {
            if((mActor as EnemyUnit).destroysPermanently(_loc2_.mItem))
            {
               _loc2_.destroyPermanently();
            }
         }
         var _loc3_:GridCell = mActor.getCell();
         var _loc4_:GridCell = mTarget.getCell();
         var _loc5_:Object = {
            "enemy_coord_x":_loc3_.mPosI,
            "enemy_coord_y":_loc3_.mPosJ,
            "coord_x":_loc4_.mPosI,
            "coord_y":_loc4_.mPosJ,
            "item_hit_points":_loc1_
         };
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.ATTACK_PLAYER_INSTALLATION,_loc5_,false);
         if(Config.DEBUG_MODE)
         {
         }
      }
   }
}
