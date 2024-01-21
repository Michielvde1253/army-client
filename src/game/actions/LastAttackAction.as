package game.actions
{
   import game.characters.AnimationController;
   import game.characters.PlayerUnit;
   import game.gameElements.EnemyInstallationObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.characters.IsometricCharacter;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.TargetItem;
   import game.net.MyServer;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.sound.SoundCollection;
   import game.states.GameState;
   import game.utils.EffectController;
   
   public class LastAttackAction extends Action
   {
      
      private static const STATE_BEFORE_ATTACK:int = 0;
      
      private static const STATE_ATTACKING:int = 1;
      
      private static const STATE_OVER:int = 2;
       
      
      private var mCell:GridCell;
      
      private var mWidth:int;
      
      private var mHeight:int;
      
      private var mRange:int;
      
      private var mDamage:int;
      
      private var mAttackSounds:SoundCollection;
      
      private var mWeaponType:String;
      
      private var mTargets:Array;
      
      private var mDurationAttack:int;
      
      private var mTimer:int;
      
      private var mState:int;
      
      private var mNewState:int;
      
      private var mServiceCallAfterExecute:String;
      
      private var mServiceCallParameters:Object;
      
      public function LastAttackAction(param1:EnemyInstallationObject, param2:String, param3:Object)
      {
         super("LastAttackAction");
         this.mTimer = 0;
         this.mState = -1;
         this.mNewState = -1;
         mActor = param1;
         this.mServiceCallAfterExecute = param2;
         this.mServiceCallParameters = param3;
         this.mCell = mActor.getCell();
         this.mDamage = (mActor as EnemyInstallationObject).mLastAttackDamage;
         this.mWidth = mActor.getTileSize().x;
         this.mHeight = mActor.getTileSize().y;
         this.mRange = (mActor as EnemyInstallationObject).mAttackRange;
         this.mWeaponType = (mActor as EnemyInstallationObject).mWeaponType;
         this.mAttackSounds = (mActor as EnemyInstallationObject).mAttackSounds;
      }
      
      override public function update(param1:int) : void
      {
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
         var _loc2_:Boolean = false;
         var _loc3_:IsometricScene = null;
         var _loc4_:int = 0;
         var _loc5_:IsometricCharacter = null;
         var _loc6_:IsometricCharacter = null;
         this.mTimer = 0;
         this.mState = param1;
         this.mNewState = param1;
         switch(this.mState)
         {
            case STATE_BEFORE_ATTACK:
               _loc2_ = false;
               this.mTargets = GameState.mInstance.searchNearbyUnits(this.mCell,this.mRange,this.mWidth,this.mHeight,false);
               if(Boolean(this.mTargets) && this.mTargets.length > 0)
               {
                  this.mNewState = STATE_ATTACKING;
               }
               else
               {
                  this.mNewState = STATE_OVER;
               }
               break;
            case STATE_ATTACKING:
               _loc3_ = GameState.mInstance.mScene;
               _loc4_ = EffectController.EFFECT_TYPE_HIT_BULLET;
               if(this.mWeaponType == "lightning")
               {
                  _loc4_ = EffectController.EFFECT_TYPE_LIGHTNING_BUBBLE;
               }
               else
               {
                  _loc4_ = EffectController.EFFECT_TYPE_BIG_EXPLOSION;
               }
               _loc3_.addEffect(null,_loc4_,_loc3_.getLeftUpperXOfCell(this.mCell) + _loc3_.mGridDimX * this.mWidth / 2,_loc3_.getLeftUpperYOfCell(this.mCell) + _loc3_.mGridDimY * this.mHeight / 2);
               this.mDurationAttack = EffectController.getEffectLength(_loc4_);
               for each(_loc5_ in this.mTargets)
               {
                  _loc5_.setAnimationAction(AnimationController.CHARACTER_ANIMATION_HIT,false,true);
                  _loc5_.showActingHealthBar();
                  if(_loc4_ == EffectController.EFFECT_TYPE_LIGHTNING_BUBBLE)
                  {
                     _loc3_.addEffect(null,EffectController.EFFECT_TYPE_HIT_LIGHTNING,_loc5_.mX,_loc5_.mY);
                  }
                  else
                  {
                     _loc3_.addEffect(null,EffectController.EFFECT_TYPE_HIT_EXPLOSION,_loc5_.mX,_loc5_.mY);
                  }
               }
               this.execute();
               break;
            case STATE_OVER:
               for each(_loc6_ in this.mTargets)
               {
                  if(_loc6_.isAlive())
                  {
                     _loc6_.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                  }
               }
               this.mTargets = null;
               if(this.mServiceCallAfterExecute)
               {
                  GameState.mInstance.mServer.serverCallServiceWithParameters(this.mServiceCallAfterExecute,this.mServiceCallParameters,false);
                  if(Config.DEBUG_MODE)
                  {
                  }
               }
               else if(Config.DEBUG_MODE)
               {
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
         this.mNewState = STATE_BEFORE_ATTACK;
      }
      
      private function execute() : void
      {
         var _loc1_:GridCell = null;
         var _loc2_:Object = null;
         var _loc4_:IsometricCharacter = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:GamePlayerProfile = null;
         var _loc13_:int = 0;
         var _loc14_:IsometricScene = null;
         var _loc15_:Item = null;
         var _loc16_:int = 0;
         if(Config.DEBUG_MODE)
         {
         }
         if(this.mState != STATE_ATTACKING)
         {
            Utils.LogError("LastAttackAction: Illegal state");
            this.mNewState = STATE_OVER;
            return;
         }
         var _loc3_:GameState = GameState.mInstance;
         var _loc5_:int = int(this.mTargets.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            (_loc4_ = this.mTargets[_loc6_] as IsometricCharacter).reduceHealth(this.mDamage);
            _loc1_ = _loc4_.getCell();
            if(_loc4_ is PlayerUnit)
            {
               _loc2_ = {
                  "enemy_coord_x":this.mCell.mPosI,
                  "enemy_coord_y":this.mCell.mPosJ,
                  "coord_x":_loc1_.mPosI,
                  "coord_y":_loc1_.mPosJ,
                  "item_hit_points":this.mDamage
               };
               _loc3_.mServer.serverCallServiceWithParameters(ServiceIDs.ATTACK_PLAYER_UNIT,_loc2_,false);
               if(Config.DEBUG_MODE)
               {
               }
            }
            else
            {
               _loc7_ = _loc4_.getHealth() > 0 && _loc4_.getHealth() - this.mDamage <= 0;
               _loc8_ = _loc4_.mHitRewardXP;
               _loc9_ = _loc4_.mHitRewardMoney;
               _loc10_ = _loc4_.mHitRewardSupplies;
               _loc11_ = _loc4_.mHitRewardEnergy;
               if(_loc7_)
               {
                  _loc8_ += _loc4_.mKillRewardXP;
                  _loc9_ += _loc4_.mKillRewardMoney;
                  _loc10_ += _loc4_.mKillRewardSupplies;
                  _loc11_ += _loc4_.mKillRewardEnergy;
               }
               (_loc12_ = _loc3_.mPlayerProfile).increaseEnergyRewardCounter(_loc11_);
               _loc13_ = _loc12_.getBonusEnergy();
               (_loc14_ = _loc3_.mScene).addLootReward(ItemManager.getItem("XP","Resource"),_loc8_,_loc4_.getContainer());
               _loc14_.addLootReward(ItemManager.getItem("Money","Resource"),_loc9_,_loc4_.getContainer());
               _loc14_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc10_,_loc4_.getContainer());
               _loc14_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc13_,_loc4_.getContainer());
               _loc16_ = _loc12_.mRewardDropsCounter;
               if(_loc7_)
               {
                  _loc15_ = (_loc4_.mItem as TargetItem).getRandomItemDrop();
                  _loc14_.addLootReward(_loc15_,1,_loc4_.getContainer());
               }
               _loc1_ = _loc4_.getCell();
               _loc2_ = {
                  "coord_x":_loc1_.mPosI,
                  "coord_y":_loc1_.mPosJ,
                  "item_hit_points":this.mDamage,
                  "cost_energy":0,
                  "reward_xp":_loc8_,
                  "reward_money":_loc9_,
                  "reward_supplies":_loc10_,
                  "reward_energy":_loc11_,
                  "attacker_is_building":true
               };
               if(_loc3_.mMapData.mMapSetupData.Resource)
               {
                  _loc2_[MyServer.MAP_RESOURCE_COST_NAMES[_loc3_.mMapData.mMapSetupData.Resource]] = 0;
               }
               if(_loc7_)
               {
                  _loc2_.reward_drop_seed_term = _loc12_.mRewardDropSeedTerm;
                  _loc2_.reward_drops_counter = _loc16_;
               }
               if(_loc15_)
               {
                  _loc2_.reward_item_type = ItemManager.getTableNameForItem(_loc15_);
                  _loc2_.reward_item_id = _loc15_.mId;
               }
               _loc3_.mServer.serverCallServiceWithParameters(ServiceIDs.ATTACK_ENEMY_UNIT,_loc2_,false);
               if(Config.DEBUG_MODE)
               {
               }
            }
            _loc6_++;
         }
      }
   }
}
