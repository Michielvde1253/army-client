package game.actions
{
   import game.characters.AnimationController;
   import game.characters.PlayerUnit;
   import game.characters.PvPEnemyUnit;
   import game.gameElements.EnemyInstallationObject;
   import game.isometric.GridCell;
   import game.isometric.characters.IsometricCharacter;
   import game.states.GameState;
   
   public class PvPEnemyAttackingAction extends EnemyAttackingAction
   {
       
      
      public function PvPEnemyAttackingAction(param1:PvPEnemyUnit, param2:PlayerUnit)
      {
         super(param1,param2);
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         mNewState = STATE_BEFORE_ATTACK;
      }
      
      override public function update(param1:int) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:GridCell = null;
         var _loc7_:GridCell = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:IsometricCharacter = null;
         if(mSkipped)
         {
            return;
         }
         if(mNewState != mState)
         {
            this.changeState(mNewState);
         }
         else
         {
            switch(mState)
            {
               case STATE_BEFORE_ATTACK:
                  if(!mActor)
                  {
                     mCharacterActors = GameState.mInstance.mPvPMatch.mAI.searchAttackablePvPEnemyUnits(mTarget as PlayerUnit);
                  }
                  if(!mCharacterActors)
                  {
                     if(mActor == null || !mActor.isAlive())
                     {
                        skip();
                        return;
                     }
                  }
                  _loc2_ = false;
                  if(mActor)
                  {
                     if(!mTarget)
                     {
                        if(_loc4_ = GameState.mInstance.searchNearbyUnits(mActor.getCell(),(mActor as IsometricCharacter).getAttackRange()))
                        {
                           if(_loc4_.length > 0)
                           {
                              _loc5_ = Math.random() * _loc4_.length;
                              mTarget = _loc4_[_loc5_] as PlayerUnit;
                              _loc2_ = true;
                           }
                        }
                     }
                     else if(mTarget.isAlive())
                     {
                        _loc6_ = mTarget.getCell();
                        _loc7_ = mActor.getCell();
                        _loc8_ = (_loc6_.mPosI - _loc7_.mPosI) * (_loc6_.mPosI - _loc7_.mPosI);
                        _loc9_ = (_loc6_.mPosJ - _loc7_.mPosJ) * (_loc6_.mPosJ - _loc7_.mPosJ);
                        _loc10_ = Math.SQRT2 * (mActor as IsometricCharacter).getAttackRange();
                        if(_loc8_ + _loc9_ <= _loc10_ * _loc10_)
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
                  else if(Boolean(mCharacterActors) && mCharacterActors.length > 0)
                  {
                     _loc2_ = true;
                  }
                  if(_loc2_)
                  {
                     mNewState = STATE_ATTACKING;
                     setDirection(mTarget.mX);
                  }
                  else
                  {
                     mNewState = STATE_MOVE;
                  }
                  break;
               case STATE_ATTACKING:
                  _loc3_ = true;
                  if(mCharacterActors)
                  {
                     for each(_loc11_ in mCharacterActors)
                     {
                        if(_loc11_.getCurrentAnimationFrameLabel() == "end")
                        {
                           _loc3_ = false;
                           break;
                        }
                     }
                  }
                  if(mActor)
                  {
                     if(mActor.getCurrentAnimationFrameLabel() == "end")
                     {
                        _loc3_ = false;
                     }
                  }
                  if(!_loc3_ || mSafetyTimer >= GameState.mConfig.GraphicSetup.Shooting.Length)
                  {
                     mNewState = STATE_OVER;
                  }
                  mSafetyTimer += param1;
            }
         }
      }
      
      override protected function changeState(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:IsometricCharacter = null;
         var _loc4_:int = 0;
         mState = param1;
         mNewState = param1;
         mSafetyTimer = 0;
         switch(mState)
         {
            case STATE_ATTACKING:
               if(mActor)
               {
                  mActor.playCollectionSound(mActor.mAttackSounds);
                  (mActor as IsometricCharacter).shootTo(mTarget.mX,mTarget.mY);
                  GameState.mInstance.mScene.addEffect(null,(mActor as IsometricCharacter).getShootingEffect(),mTarget.mX,mTarget.mY);
               }
               else if(mCharacterActors)
               {
                  playAttackSoundsForAttackers();
                  _loc2_ = 0;
                  while(_loc2_ < mCharacterActors.length)
                  {
                     _loc3_ = mCharacterActors[_loc2_];
                     _loc3_.shootTo(mTarget.mX,mTarget.mY);
                     GameState.mInstance.mScene.addEffect(null,_loc3_.getShootingEffect(),mTarget.mX,mTarget.mY);
                     _loc2_++;
                  }
               }
               mTarget.setAnimationAction(AnimationController.CHARACTER_ANIMATION_HIT,false,true);
               mTarget.showActingHealthBar();
               this.execute();
               break;
            case STATE_MOVE:
               if(mActor)
               {
                  GameState.mInstance.queueAction(new PvPEnemyMovingAction(mActor as PvPEnemyUnit),true);
               }
               mNewState = STATE_OVER;
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
               if(mActor)
               {
                  mActor.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
               }
               else if(mCharacterActors)
               {
                  _loc4_ = 0;
                  while(_loc4_ < mCharacterActors.length)
                  {
                     _loc3_ = mCharacterActors[_loc4_] as IsometricCharacter;
                     _loc3_.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                     _loc4_++;
                  }
               }
               GameState.mInstance.enemyMoveMade();
         }
      }
      
      override protected function execute() : void
      {
         var _loc2_:int = 0;
         var _loc3_:IsometricCharacter = null;
         var _loc1_:int = 0;
         if(mActor)
         {
            _loc1_ += (mActor as PvPEnemyUnit).getPower();
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < mCharacterActors.length)
            {
               _loc3_ = mCharacterActors[_loc2_] as IsometricCharacter;
               _loc1_ += _loc3_.getPower();
               _loc2_++;
            }
         }
         if(Config.DEBUG_MODE)
         {
         }
         if(!mTarget || !mTarget.isAlive())
         {
            Utils.LogError("PvPEnemyAttackAction: Player unit not found");
            mNewState = STATE_OVER;
            return;
         }
         if(mState != STATE_ATTACKING)
         {
            Utils.LogError("PvPEnemyAttackAction: Illegal state");
            mNewState = STATE_OVER;
            return;
         }
         (mTarget as IsometricCharacter).reduceHealth(_loc1_);
         if(!(mTarget as PlayerUnit).isAlive())
         {
            (mTarget as PlayerUnit).destroyPermanently();
         }
      }
   }
}
