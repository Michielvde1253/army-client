package game.actions
{
   import game.characters.AnimationController;
   import game.characters.EnemyUnit;
   import game.characters.PlayerUnit;
   import game.isometric.GridCell;
   import game.isometric.characters.IsometricCharacter;
   import game.net.ServiceIDs;
   import game.states.GameState;
   
   public class EnemyAttackingAction extends Action
   {
      
      protected static const STATE_BEFORE_ATTACK:int = 0;
      
      protected static const STATE_ATTACKING:int = 1;
      
      protected static const STATE_MOVE:int = 2;
      
      protected static const STATE_OVER:int = 3;
       
      
      protected var mState:int;
      
      protected var mNewState:int;
      
      protected var mSafetyTimer:int;
      
      public function EnemyAttackingAction(param1:IsometricCharacter, param2:PlayerUnit)
      {
         super("AttackPlayer");
         mActor = param1;
         mTarget = param2;
         this.mState = -1;
         this.mNewState = -1;
      }
      
      override public function update(param1:int) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:GridCell = null;
         var _loc6_:GridCell = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         if(mSkipped)
         {
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
                  _loc2_ = false;
                  if(GameState.mInstance.mScene.isInsideVisibleArea(mActor.getCell()))
                  {
                     if(!mTarget)
                     {
                        _loc3_ = GameState.mInstance.searchNearbyUnits(mActor.getCell(),(mActor as IsometricCharacter).getAttackRange());
                        if(_loc3_)
                        {
                           if(_loc3_.length > 0)
                           {
                              _loc4_ = Math.random() * _loc3_.length;
                              mTarget = _loc3_[_loc4_] as PlayerUnit;
                              _loc2_ = true;
                           }
                        }
                     }
                     else if(mTarget.isAlive())
                     {
                        _loc5_ = mTarget.getCell();
                        _loc6_ = mActor.getCell();
                        _loc7_ = (_loc5_.mPosI - _loc6_.mPosI) * (_loc5_.mPosI - _loc6_.mPosI);
                        _loc8_ = (_loc5_.mPosJ - _loc6_.mPosJ) * (_loc5_.mPosJ - _loc6_.mPosJ);
                        _loc9_ = Math.SQRT2 * (mActor as IsometricCharacter).getAttackRange();
                        if(_loc7_ + _loc8_ <= _loc9_ * _loc9_)
                        {
                           _loc2_ = true;
                        }
                        else
                        {
                           _loc2_ = false;
                        }
                     }
                     else
                     {
                        _loc2_ = false;
                     }
                  }
                  if(_loc2_)
                  {
                     this.mNewState = STATE_ATTACKING;
                     setDirection(mTarget.mX);
                  }
                  else
                  {
                     this.mNewState = STATE_MOVE;
                  }
                  break;
               case STATE_ATTACKING:
                  if(mActor.getCurrentAnimationFrameLabel() == "end" || this.mSafetyTimer >= GameState.mConfig.GraphicSetup.Shooting.Length)
                  {
                     this.mNewState = STATE_OVER;
                  }
                  this.mSafetyTimer += param1;
            }
         }
      }
      
      protected function changeState(param1:int) : void
      {
         this.mState = param1;
         this.mNewState = param1;
         this.mSafetyTimer = 0;
         switch(this.mState)
         {
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
               mTarget.setAnimationAction(AnimationController.CHARACTER_ANIMATION_HIT,false,true);
               mTarget.showActingHealthBar();
               GameState.mInstance.mScene.addEffect(null,(mActor as IsometricCharacter).getShootingEffect(),mTarget.mX,mTarget.mY);
               this.execute();
               break;
            case STATE_MOVE:
               GameState.mInstance.queueAction(new EnemyMovingAction(mActor as EnemyUnit),true);
               this.mNewState = STATE_OVER;
               break;
            case STATE_OVER:
               if(mTarget)
               {
                  if(mTarget.isAlive())
                  {
                     mTarget.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                     mTarget = null;
                  }
               }
               mActor.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
               GameState.mInstance.enemyMoveMade();
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
         if(mActor == null || !mActor.isAlive())
         {
            skip();
            return;
         }
         this.mNewState = STATE_BEFORE_ATTACK;
      }
      
      protected function execute() : void
      {
         var _loc1_:int = (mActor as IsometricCharacter).getPower();
         if(Config.DEBUG_MODE)
         {
         }
         if(!mTarget || !mTarget.isAlive())
         {
            Utils.LogError("EnemyAttackAction: Player unit not found");
            this.mNewState = STATE_OVER;
            return;
         }
         if(this.mState != STATE_ATTACKING)
         {
            Utils.LogError("EnemyAttackAction: Illegal state");
            this.mNewState = STATE_OVER;
            return;
         }
         (mTarget as IsometricCharacter).reduceHealth(_loc1_);
         if(!PlayerUnit(mTarget).isAlive())
         {
            if((mActor as EnemyUnit).destroysPermanently((mTarget as PlayerUnit).mItem))
            {
               (mTarget as PlayerUnit).destroyPermanently();
            }
         }
         var _loc2_:GridCell = mActor.getCell();
         var _loc3_:GridCell = mTarget.getCell();
         var _loc4_:Object = {
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
   }
}
