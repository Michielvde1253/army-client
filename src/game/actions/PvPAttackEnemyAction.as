package game.actions
{
   import game.characters.PvPEnemyUnit;
   import game.gameElements.PlayerInstallationObject;
   import game.isometric.IsometricScene;
   import game.isometric.characters.IsometricCharacter;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.TargetItem;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class PvPAttackEnemyAction extends AttackEnemyAction
   {
       
      
      public function PvPAttackEnemyAction(param1:Array, param2:PlayerInstallationObject, param3:PvPEnemyUnit, param4:Boolean = true)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function start() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         if(mSkipped)
         {
            return;
         }
         if(mTarget == null || !mTarget.isAlive() || (mTarget as PvPEnemyUnit).mCurrentAction || GameState.mInstance.mPvPMatch.mActionsLeft == 0)
         {
            skip();
            return;
         }
         if(mActor)
         {
            if(!(mActor as PlayerInstallationObject).canAttack())
            {
               skip();
               return;
            }
         }
         else if(mCharacterActors)
         {
            mCharacterActors = GameState.mInstance.searchAttackablePlayerUnits(mTarget as PvPEnemyUnit);
            _loc1_ = false;
            _loc2_ = 0;
            while(_loc2_ < mCharacterActors.length)
            {
               if((mCharacterActors[_loc2_] as IsometricCharacter).isAlive())
               {
                  _loc1_ = true;
               }
               else
               {
                  mCharacterActors.splice(_loc2_,1);
                  _loc2_--;
               }
               _loc2_++;
            }
            if(!_loc1_ || mCharacterActors.length == 0)
            {
               skip();
               return;
            }
         }
         setDirection(mTarget.mX);
         mNewState = STATE_BEFORE_ATTACK;
      }
      
      override protected function execute() : void
      {
         var _loc7_:Item = null;
         var _loc9_:Boolean = false;
         var _loc1_:PvPEnemyUnit = mTarget as PvPEnemyUnit;
         if(!_loc1_ || !_loc1_.isAlive())
         {
            Utils.LogError("PvPAttackEnemyAction: Enemy not found");
            mNewState = STATE_OVER;
            return;
         }
         if(mState != STATE_ATTACKING)
         {
            Utils.LogError("PvPAttackEnemyAction: Illegal state");
            mNewState = STATE_OVER;
            return;
         }
         var _loc2_:GameState = GameState.mInstance;
         var _loc3_:IsometricScene = _loc2_.mScene;
         var _loc4_:GamePlayerProfile = _loc2_.mPlayerProfile;
         var _loc5_:Boolean = _loc1_.getHealth() > 0 && _loc1_.getHealth() - getCombinedDamage() <= 0;
         var _loc6_:int = _loc1_.mHitRewardBadassXP;
         if(_loc5_)
         {
            _loc6_ += _loc1_.mKillRewardBadassXP;
         }
         _loc3_.addLootReward(ItemManager.getItem("BadAssXP","Resource"),_loc6_,_loc1_.getContainer());
         _loc2_.mPvPMatch.addIngameBaddassXp(_loc6_);
         if(_loc5_)
         {
            _loc7_ = (_loc1_.mItem as TargetItem).getRandomItemDrop();
            _loc3_.addLootReward(_loc7_,1,_loc1_.getContainer());
            _loc2_.mPvPMatch.addIngameCollectible(_loc7_);
         }
         var _loc8_:int = getCombinedDamage();
         if(!mActor && Boolean(mCharacterActors))
         {
            _loc9_ = false;
         }
         else
         {
            _loc9_ = true;
         }
         _loc1_.reduceHealth(_loc8_);
         mNewState = STATE_OVER;
         _loc2_.playerMoveMade();
      }
   }
}
