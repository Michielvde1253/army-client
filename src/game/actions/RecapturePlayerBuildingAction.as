package game.actions
{
   import game.characters.AnimationController;
   import game.characters.EnemyUnit;
   import game.characters.PlayerUnit;
   import game.gameElements.ConstructionObject;
   import game.gameElements.DecorationObject;
   import game.gameElements.HFEObject;
   import game.gameElements.HFEPlotObject;
   import game.gameElements.PermanentHFEObject;
   import game.gameElements.PlayerBuildingObject;
   import game.gameElements.ResourceBuildingObject;
   import game.gui.GameHUD;
   import game.gui.TextEffect;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.Renderable;
   import game.items.ItemManager;
   import game.items.PermanentHFEItem;
   import game.magicBox.MagicBoxTracker;
   import game.missions.MissionManager;
   import game.net.MyServer;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class RecapturePlayerBuildingAction extends Action
   {
      
      private static const STATE_BEFORE_ATTACK:int = 0;
      
      private static const STATE_ATTACKING:int = 1;
      
      private static const STATE_OVER:int = 2;
       
      
      private var mTimer:int;
      
      private var mState:int;
      
      private var mNewState:int;
      
      private var mDamageOnPlayer:int;
      
      public function RecapturePlayerBuildingAction(param1:Array, param2:PlayerBuildingObject)
      {
         super("RecapturePlayerBuildingAction");
         mCharacterActors = param1;
         mTarget = param2;
         this.mState = -1;
         this.mNewState = -1;
      }
      
      override public function update(param1:int) : void
      {
         var _loc2_:Boolean = false;
         if(this.mState == STATE_OVER || mSkipped)
         {
            return;
         }
         if(this.mNewState != this.mState)
         {
            this.changeState(this.mNewState);
         }
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
               this.mTimer += param1;
               _loc2_ = false;
               if(this.mTimer < GameState.mConfig.GraphicSetup.Shooting.Length)
               {
                  _loc2_ = true;
               }
               if(!_loc2_)
               {
                  this.execute();
               }
         }
      }
      
      private function changeState(param1:int) : void
      {
         var _loc3_:IsometricCharacter = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         this.mTimer = 0;
         this.mState = param1;
         this.mNewState = param1;
         var _loc2_:IsometricScene = GameState.mInstance.mScene;
         var _loc4_:int = int(mCharacterActors.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = mCharacterActors[_loc5_] as IsometricCharacter;
            switch(this.mState)
            {
               case STATE_BEFORE_ATTACK:
                  this.mNewState = STATE_ATTACKING;
                  break;
               case STATE_ATTACKING:
                  _loc3_.shootTo(mTarget.mX,mTarget.mY);
                  mTarget.showActingHealthBar();
                  _loc6_ = mTarget.mX;
                  _loc7_ = mTarget.mY;
                  if(mTarget.getTileSize().x > 1)
                  {
                     _loc6_ += Math.random() * ((mTarget.getTileSize().x - 1) * _loc2_.mGridDimX);
                  }
                  if(mTarget.getTileSize().y > 1)
                  {
                     _loc7_ += Math.random() * ((mTarget.getTileSize().y - 1) * _loc2_.mGridDimY);
                  }
                  _loc2_.addEffect(null,_loc3_.getShootingEffect(),_loc6_,_loc7_);
                  break;
               case STATE_OVER:
                  _loc3_.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
                  if(_loc3_ is EnemyUnit)
                  {
                     (_loc3_ as EnemyUnit).changeReactionState(EnemyUnit.REACT_STATE_ACTION_COMPLETED);
                  }
                  break;
            }
            _loc5_++;
         }
         if(this.mState == STATE_ATTACKING)
         {
            playAttackSoundsForAttackers();
         }
      }
      
      override public function isOver() : Boolean
      {
         return this.mState == STATE_OVER || mSkipped;
      }
      
      override public function start() : void
      {
         var _loc5_:int = 0;
         if(mSkipped)
         {
            return;
         }
         if(!mTarget || !mTarget.mScene)
         {
            skip();
            return;
         }
         if(mTarget is ResourceBuildingObject)
         {
            skip();
            return;
         }
         var _loc1_:GameHUD = GameState.mInstance.mHUD;
         var _loc2_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         var _loc3_:IsometricScene = GameState.mInstance.mScene;
         var _loc4_:GridCell = (mTarget as PlayerBuildingObject).getCell();
         if(!_loc3_.isInsideOpenArea(_loc4_))
         {
            _loc1_.openAreaLockedWindow(_loc3_.getContainingArea(_loc4_));
            skip();
         }
         else if(_loc2_.mEnergy <= 0)
         {
            _loc1_.openOutOfEnergyWindow();
            skip();
         }
         else if(!_loc2_.hasEnoughMapResource(1))
         {
            _loc1_.openOutOfMapResourceWindow();
            skip();
         }
         else if(mCharacterActors != null && mCharacterActors.length == 0)
         {
            (mTarget as PlayerBuildingObject).addTextEffect(TextEffect.TYPE_LOSS,GameState.getText("CANNOT_ATTACK_TEXT"));
            skip();
         }
         else if(!this.isLegal())
         {
            skip();
         }
         else
         {
            _loc5_ = this.getCombinedDamage();
            if(mCharacterActors.length == 1 && _loc5_ > 0 && (mTarget as PlayerBuildingObject).getHealth() + _loc5_ < (mTarget as PlayerBuildingObject).getMaxHealth())
            {
               ++smSingleAttacksCount;
               if(smSingleAttacksCount >= 3)
               {
                  if(_loc1_.openSingleAttackWarningWindow())
                  {
                     skip();
                  }
               }
            }
            else
            {
               smSingleAttacksCount = 0;
            }
         }
         if(mSkipped)
         {
            this.mNewState = STATE_OVER;
            return;
         }
         this.mNewState = STATE_BEFORE_ATTACK;
         setDirection(mTarget.mX,mTarget.getTileSize().x);
      }
      
      private function isLegal() : Boolean
      {
         if(!mCharacterActors)
         {
            return true;
         }
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
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
         if(!_loc1_)
         {
            return false;
         }
         return mCharacterActors[0] is PlayerUnit && (mTarget as PlayerBuildingObject).getHealthPercentage() < 100 || mCharacterActors[0] is EnemyUnit && (mTarget as PlayerBuildingObject).getHealthPercentage() > 0;
      }
      
      private function getCombinedDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:IsometricCharacter = null;
         if(!mCharacterActors)
         {
            return (mTarget as PlayerBuildingObject).getMaxHealth();
         }
         var _loc3_:int = int(mCharacterActors.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = mCharacterActors[_loc4_] as IsometricCharacter;
            if(_loc2_ is PlayerUnit)
            {
               _loc1_ += _loc2_.getPower();
            }
            else
            {
               _loc1_ -= _loc2_.getPower();
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      private function execute() : void
      {
         var _loc4_:* = false;
         var _loc5_:PermanentHFEItem = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:IsometricScene = null;
         var _loc13_:GridCell = null;
         var _loc14_:Object = null;
         var _loc15_:GridCell = null;
         var _loc16_:String = null;
         var _loc17_:EnemyUnit = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         if(!mTarget || !mTarget.mScene)
         {
            this.mNewState = STATE_OVER;
            return;
         }
         if(this.mState != STATE_ATTACKING)
         {
            Utils.LogError("AttackPlayerBuilding: Illegal state");
            this.mNewState = STATE_OVER;
            return;
         }
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:GamePlayerProfile = _loc1_.mPlayerProfile;
         var _loc3_:int = this.getCombinedDamage();
         if(_loc3_ > 0)
         {
            _loc4_ = (mTarget as PlayerBuildingObject).getHealth() + _loc3_ >= (mTarget as PlayerBuildingObject).getMaxHealth();
            _loc6_ = (_loc5_ = (mTarget as PlayerBuildingObject).mItem as PermanentHFEItem).mHitRewardXP;
            _loc7_ = _loc5_.mHitRewardMoney;
            _loc8_ = _loc5_.mHitRewardMaterial;
            _loc9_ = _loc5_.mHitRewardSupplies;
            _loc10_ = _loc5_.mHitRewardEnergy;
            if(_loc4_)
            {
               _loc6_ += _loc5_.mKillRewardXP;
               _loc7_ += _loc5_.mKillRewardMoney;
               _loc8_ += _loc5_.mKillRewardMaterial;
               _loc9_ += _loc5_.mKillRewardSupplies;
               _loc10_ += _loc5_.mKillRewardEnergy;
            }
            if(mCharacterActors)
            {
               (mCharacterActors[0] as IsometricCharacter).addTextEffect(TextEffect.TYPE_LOSS,"-1",ItemManager.getItem("Energy","Resource"));
            }
            _loc2_.increaseEnergyRewardCounter(_loc10_);
            _loc11_ = _loc2_.getBonusEnergy();
            (_loc12_ = GameState.mInstance.mScene).addLootReward(ItemManager.getItem("XP","Resource"),_loc6_,mTarget.getContainer());
            _loc12_.addLootReward(ItemManager.getItem("Money","Resource"),_loc7_,mTarget.getContainer());
            _loc12_.addLootReward(ItemManager.getItem("Material","Resource"),_loc8_,mTarget.getContainer());
            _loc12_.addLootReward(ItemManager.getItem("Supplies","Resource"),_loc9_,mTarget.getContainer());
            _loc12_.addLootReward(ItemManager.getItem("Energy","Resource"),_loc11_,mTarget.getContainer());
            _loc1_.reduceEnergy(mName,1,MagicBoxTracker.paramsObj((mTarget as PlayerBuildingObject).mItem.mType,(mTarget as PlayerBuildingObject).mItem.mId));
            _loc1_.reduceMapResource(1);
            _loc13_ = mTarget.getCell();
            _loc14_ = {
               "coord_x":_loc13_.mPosI,
               "coord_y":_loc13_.mPosJ,
               "item_hit_points":_loc3_,
               "cost_energy":1,
               "reward_xp":_loc6_,
               "reward_money":_loc7_,
               "reward_material":_loc8_,
               "reward_supplies":_loc9_,
               "reward_energy":_loc10_
            };
            if(_loc1_.mMapData.mMapSetupData.Resource)
            {
               _loc14_[MyServer.MAP_RESOURCE_COST_NAMES[_loc1_.mMapData.mMapSetupData.Resource]] = 1;
            }
            GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.CAPTURE_HF,_loc14_,false);
            if(Config.DEBUG_MODE)
            {
            }
         }
         else if(_loc3_ < 0)
         {
            _loc15_ = (mCharacterActors[0] as IsometricCharacter).getCell();
            _loc13_ = mTarget.getCell();
            _loc14_ = {
               "enemy_coord_x":_loc15_.mPosI,
               "enemy_coord_y":_loc15_.mPosJ,
               "coord_x":_loc13_.mPosI,
               "coord_y":_loc13_.mPosJ,
               "item_hit_points":-_loc3_
            };
            _loc16_ = null;
            if(mTarget is HFEObject || mTarget is HFEPlotObject)
            {
               _loc16_ = ServiceIDs.ATTACK_PLAYER_HOME_FRONT_EFFORT;
            }
            else if(mTarget is DecorationObject)
            {
               _loc16_ = ServiceIDs.ATTACK_PLAYER_DECO;
            }
            else if(mTarget is ConstructionObject || mTarget is ResourceBuildingObject)
            {
               _loc16_ = ServiceIDs.ATTACK_PLAYER_BUILDING;
            }
            else if(mTarget is PermanentHFEObject)
            {
               _loc16_ = ServiceIDs.ATTACK_PLAYER_PERMANENT_HFE;
            }
            if(_loc16_)
            {
               GameState.mInstance.mServer.serverCallServiceWithParameters(_loc16_,_loc14_,false);
               if(Config.DEBUG_MODE)
               {
               }
            }
            else
            {
               Utils.LogError("RecapturePlayerBuilding: Invalid target");
            }
         }
         else
         {
            Utils.LogError("RecapturePlayerBuilding: Attack did no damage");
         }
         (mTarget as PlayerBuildingObject).addHealth(_loc3_);
         if(!(mTarget as PlayerBuildingObject).isAlive())
         {
            if(mCharacterActors)
            {
               _loc18_ = int(mCharacterActors.length);
               _loc19_ = 0;
               while(_loc19_ < _loc18_)
               {
                  if((_loc17_ = mCharacterActors[_loc19_] as EnemyUnit).destroysPermanently((mTarget as PlayerBuildingObject).mItem))
                  {
                     (mTarget as PlayerBuildingObject).destroyPermanently();
                  }
                  _loc19_++;
               }
            }
         }
         if((mTarget as PlayerBuildingObject).isFullHealth())
         {
            MissionManager.increaseCounter("Recapture",mTarget,1);
         }
         this.mNewState = STATE_OVER;
      }
   }
}
