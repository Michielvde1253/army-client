package game.ai
{
   import game.actions.Action;
   import game.actions.PvPEnemyAttackingAction;
   import game.actions.PvPEnemyMovingAction;
   import game.characters.PlayerUnit;
   import game.characters.PvPEnemyUnit;
   import game.gameElements.PowerUpObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.SceneLoader;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.Element;
   import game.items.PowerUpItem;
   import game.net.PvPMatch;
   import game.states.GameState;
   
   public class PvPAI
   {
      
      public static const AI_DEBUG:Boolean = true;
       
      
      private var mModePreferFormat:Number = 0.5;
      
      private var mModePreferAttack:Number = 0.5;
      
      private var mGame:GameState;
      
      private var mScene:IsometricScene;
      
      private var mEnemyUnits:Array;
      
      private var mPlayerUnits:Array;
      
      private var mLeaderEnemy:PvPEnemyUnit;
      
      private var mArmyCoherence:Number;
      
      private var mStrikeKillPlayer:PlayerUnit;
      
      private var mStrikeKillEnemy:PvPEnemyUnit;
      
      private var mStrikeKillPreference:Number;
      
      private var mStrikeKillCell:GridCell;
      
      private var mStraightAttackAction:Action;
      
      private var mStraightAttackPreference:Number;
      
      private var mActionPriority:Number;
      
      private var mAction:Action;
      
      private var mIgnoreKillCheck:Boolean = false;
      
      private var mChooseRandomTarget:Boolean = false;
      
      private var mAttackWithWeakest:Boolean = false;
      
      private var mPowerUpFan:Boolean = false;
      
      private var mQuickAttack:Boolean = true;
      
      private var mRandomApproaching:Boolean = false;
      
      private var mDebugInfo:String;
      
      public function PvPAI(param1:GameState, param2:IsometricScene, param3:Object)
      {
         super();
         this.mGame = param1;
         this.mScene = param2;
         this.mIgnoreKillCheck = Math.random() * 100 < param3.IgnoreKillCheck;
         this.mChooseRandomTarget = Math.random() * 100 < param3.ChooseRandomTarget;
         this.mAttackWithWeakest = Math.random() * 100 < param3.AttackWithWeakest;
         this.mPowerUpFan = Math.random() * 100 < param3.PowerUpFan;
         this.mQuickAttack = Math.random() * 100 < param3.QuickAttack;
         this.mRandomApproaching = Math.random() * 100 < param3.RandomApproaching;
      }
      
      public function makeMove() : void
      {
         this.mEnemyUnits = this.mScene.getPvPEnemyAliveUnits();
         this.mPlayerUnits = this.mScene.getPlayerAliveUnits();
         if(this.mEnemyUnits.length <= 0 || this.mPlayerUnits.length <= 0)
         {
            return;
         }
         this.updateLeaderActor();
         if(AI_DEBUG)
         {
         }
         if(!this.mEnemyUnits || this.mEnemyUnits.length <= 0 || !this.mPlayerUnits || this.mPlayerUnits.length <= 0)
         {
            return;
         }
         if(AI_DEBUG)
         {
            this.mDebugInfo = "";
         }
         if(this.mPowerUpFan)
         {
            this.resetBestSuggestions();
            this.planCollectPowerUp();
            if(this.mActionPriority > 0 && Boolean(this.mAction))
            {
               if(AI_DEBUG)
               {
               }
               this.mGame.queueAction(this.mAction);
               return;
            }
         }
         this.planStrikeKill();
         if(AI_DEBUG)
         {
         }
         if(this.mStrikeKillPreference > 0.5 - (this.mModePreferAttack + (1 - this.mModePreferFormat)) / 4)
         {
            if(AI_DEBUG)
            {
            }
            if(this.mStrikeKillEnemy.getCell() == this.mStrikeKillCell)
            {
               this.mGame.queueAction(new PvPEnemyAttackingAction(null,this.mStrikeKillPlayer));
            }
            else
            {
               this.mGame.queueAction(new PvPEnemyMovingAction(this.mStrikeKillEnemy,this.mStrikeKillCell,true));
            }
            return;
         }
         this.resetBestSuggestions();
         this.planStraightAttack();
         if(AI_DEBUG)
         {
         }
         if(this.mActionPriority > 0 && Boolean(this.mAction))
         {
            if(AI_DEBUG)
            {
            }
            this.mGame.queueAction(this.mAction);
            return;
         }
         this.updateArmyCoherence();
         this.resetBestSuggestions();
         this.planAttack();
         if(!this.mQuickAttack)
         {
            this.planCollectPowerUp();
         }
         if(AI_DEBUG)
         {
         }
         if(this.mActionPriority > 0 && Boolean(this.mAction))
         {
            if(AI_DEBUG)
            {
            }
            this.mGame.queueAction(this.mAction);
            return;
         }
         var _loc1_:PvPEnemyUnit = this.mEnemyUnits[Math.floor(Math.random() * this.mEnemyUnits.length)] as PvPEnemyUnit;
         if(!_loc1_.isAlive())
         {
            return;
         }
         var _loc2_:PlayerUnit = _loc1_.getPlayerInShootRange();
         if(_loc2_)
         {
            this.mGame.queueAction(new PvPEnemyAttackingAction(null,_loc2_));
         }
         else
         {
            this.mGame.queueAction(new PvPEnemyMovingAction(_loc1_));
         }
      }
      
      private function resetBestSuggestions() : void
      {
         this.mAction = null;
         this.mActionPriority = 0;
      }
      
      private function updateLeaderActor() : void
      {
         var _loc2_:PvPEnemyUnit = null;
         var _loc3_:Number = NaN;
         this.mLeaderEnemy = null;
         var _loc1_:Number = this.mAttackWithWeakest ? 1.1 : 0;
         for each(_loc2_ in this.mEnemyUnits)
         {
            _loc3_ = _loc2_.getActorPriority();
            if(this.mQuickAttack)
            {
               _loc3_ = _loc2_.getMovementRadius() / 10;
            }
            if(this.mAttackWithWeakest && _loc3_ < _loc1_ || !this.mAttackWithWeakest && _loc3_ > _loc1_)
            {
               _loc1_ = _loc3_;
               this.mLeaderEnemy = _loc2_;
            }
         }
      }
      
      private function suggestAction(param1:Action, param2:Number) : void
      {
         if(this.mRandomApproaching)
         {
            if(Math.random() < 0.1 || this.mActionPriority <= 0)
            {
               this.mAction = param1;
               this.mActionPriority = param2;
            }
         }
         else if(param2 > this.mActionPriority)
         {
            this.mAction = param1;
            this.mActionPriority = param2;
         }
      }
      
      private function planStrikeKill() : void
      {
         var _loc1_:PvPEnemyUnit = null;
         var _loc2_:PlayerUnit = null;
         var _loc3_:GridCell = null;
         var _loc4_:Number = NaN;
         var _loc5_:PlayerUnit = null;
         var _loc6_:Number = NaN;
         this.mStrikeKillPreference = 0;
         this.mStrikeKillPlayer = null;
         this.mStrikeKillEnemy = null;
         this.mStrikeKillCell = null;
         if(!this.mIgnoreKillCheck)
         {
            for each(_loc1_ in this.mEnemyUnits)
            {
               for each(_loc2_ in this.mPlayerUnits)
               {
                  _loc3_ = _loc1_.getStrikeKillCell(_loc2_);
                  if(_loc3_)
                  {
                     this.mDebugInfo += "cell found, ";
                     if(_loc5_ = _loc2_.getClosestPlayerUnit())
                     {
                        _loc6_ = _loc5_.distanceToCell(_loc3_) / SceneLoader.GRID_CELL_SIZE - _loc5_.getAttackRange();
                        _loc4_ = Math.sqrt(1 - 1 / Math.max(1,_loc6_));
                     }
                     else
                     {
                        _loc4_ = 1;
                     }
                     if(_loc4_ > this.mStrikeKillPreference)
                     {
                        this.mStrikeKillPreference = _loc4_;
                        this.mStrikeKillPlayer = _loc2_;
                        this.mStrikeKillEnemy = _loc1_;
                        this.mStrikeKillCell = _loc3_;
                     }
                  }
               }
            }
         }
      }
      
      private function planStraightAttack() : void
      {
         var _loc2_:PlayerUnit = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Action = null;
         var _loc8_:IsometricCharacter = null;
         var _loc9_:int = 0;
         var _loc10_:PvPEnemyUnit = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:GridCell = null;
         this.mStraightAttackPreference = 0;
         this.mStraightAttackAction = null;
         var _loc1_:PvPMatch = this.mGame.mPvPMatch;
         for each(_loc2_ in this.mPlayerUnits)
         {
            _loc3_ = this.searchAttackablePvPEnemyUnits(_loc2_);
            if(_loc3_.length > 0)
            {
               this.mDebugInfo += "attackable pvpEnemy found, ";
               _loc4_ = 0;
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  _loc8_ = _loc3_[_loc5_] as IsometricCharacter;
                  _loc4_ += _loc8_.getPower();
                  _loc5_++;
               }
               _loc6_ = (_loc6_ = Math.min(1,_loc4_ / 10) + _loc2_.getTargetPriority()) / 2;
               if(_loc4_ * _loc1_.mActionsLeft >= _loc2_.getHealth() && this.mModePreferFormat < 0.5)
               {
                  _loc6_ = (_loc6_ + 1) * 0.5;
               }
               _loc7_ = new PvPEnemyAttackingAction(null,_loc2_);
               this.suggestAction(_loc7_,_loc6_);
               this.mDebugInfo += "attack priority " + _loc6_ + "(" + Math.min(1,_loc4_ / 10) + "," + _loc2_.getTargetPriority() + "), ";
               if(_loc1_.mActionsLeft > 1 && !this.mQuickAttack)
               {
                  _loc9_ = 0;
                  while(_loc9_ < this.mEnemyUnits.length)
                  {
                     if(_loc3_.indexOf(this.mEnemyUnits[_loc9_]) < 0)
                     {
                        _loc10_ = this.mEnemyUnits[_loc9_];
                        if(_loc4_ <= _loc10_.getPower() * (_loc1_.mActionsLeft - 1))
                        {
                           _loc11_ = _loc10_.getWalkableCells();
                           _loc12_ = this.mScene.getNeighboringAvailableCellsAtChessboardDistance(_loc2_.getCell(),_loc10_.getAttackRange());
                           _loc13_ = this.mScene.chooseCellClosestToCellAvoidingPlayers(_loc12_,_loc10_.getCell());
                           if(_loc11_.indexOf(_loc13_) >= 0)
                           {
                              _loc6_ = (_loc6_ = Math.min(1,_loc4_ / 10) + _loc2_.getTargetPriority() + 1) / 3;
                              _loc7_ = new PvPEnemyMovingAction(_loc10_,_loc13_,true);
                              this.suggestAction(_loc7_,_loc6_);
                              this.mDebugInfo += "move priority " + _loc6_ + "(" + Math.min(1,_loc4_ / 10) + "," + _loc2_.getTargetPriority() + "," + 1 + "), ";
                           }
                        }
                     }
                     _loc9_++;
                  }
               }
            }
         }
      }
      
      private function getEnemyUnitIncoherence(param1:PvPEnemyUnit) : int
      {
         var _loc2_:int = Math.round(Math.max(param1.mX - this.mLeaderEnemy.mX,param1.mY - this.mLeaderEnemy.mY) / SceneLoader.GRID_CELL_SIZE);
         if(_loc2_ <= 1)
         {
            return 0;
         }
         return Math.ceil((_loc2_ - 1) / param1.mMovementRange);
      }
      
      private function updateArmyCoherence() : void
      {
         var _loc4_:PvPEnemyUnit = null;
         var _loc1_:int = 0;
         var _loc2_:Array = this.mScene.getNeighboringAvailableCellsAtChessboardDistance(this.mLeaderEnemy.getCell(),1.5);
         var _loc3_:int = int(_loc2_.length);
         if(_loc3_ <= 0)
         {
            this.mArmyCoherence = 1;
            return;
         }
         for each(_loc4_ in this.mEnemyUnits)
         {
            if(_loc4_ != this.mLeaderEnemy)
            {
               _loc1_ += this.getEnemyUnitIncoherence(_loc4_);
            }
         }
         this.mArmyCoherence = Math.max(0,1 - _loc1_ / Math.max(this.mEnemyUnits.length - 1,1));
         if(_loc3_ == 1)
         {
            this.mArmyCoherence = Math.sqrt(this.mArmyCoherence);
         }
      }
      
      private function getIntersection(param1:Array, param2:Array) : Array
      {
         var _loc4_:GridCell = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1)
         {
            if(param2.indexOf(_loc4_) >= 0)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      private function planAttack() : void
      {
         var _loc3_:PlayerUnit = null;
         var _loc4_:Array = null;
         var _loc5_:GridCell = null;
         var _loc6_:Number = NaN;
         var _loc8_:PlayerUnit = null;
         var _loc9_:Number = NaN;
         var _loc10_:PvPEnemyUnit = null;
         var _loc11_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         if(!this.mLeaderEnemy)
         {
            return;
         }
         var _loc1_:PvPMatch = this.mGame.mPvPMatch;
         var _loc2_:Number = 0;
         if(this.mChooseRandomTarget)
         {
            _loc2_ = 0.6;
            _loc3_ = this.mPlayerUnits[Math.floor(Math.random() * this.mPlayerUnits.length)];
         }
         else
         {
            for each(_loc8_ in this.mPlayerUnits)
            {
               if((_loc9_ = this.mLeaderEnemy.getAttackPriority(_loc8_,this.mModePreferFormat)) > _loc2_)
               {
                  _loc2_ = _loc9_;
                  _loc3_ = _loc8_;
               }
            }
         }
         _loc4_ = this.mScene.getNeighboringAvailableCellsAtChessboardDistance(_loc3_.getCell(),this.mLeaderEnemy.getAttackRange());
         _loc5_ = this.mScene.chooseCellClosestToCellAvoidingPlayers(_loc4_,this.mLeaderEnemy.getCell());
         _loc6_ = (_loc6_ = _loc2_ + this.mModePreferAttack + this.mArmyCoherence + (1 - this.mModePreferFormat)) / 4;
         if(_loc1_.mActionsLeft == 2)
         {
            _loc6_ *= 0.6;
         }
         else if(_loc1_.mActionsLeft == 1)
         {
            _loc6_ *= 0.2;
         }
         var _loc7_:Action = new PvPEnemyMovingAction(this.mLeaderEnemy,_loc5_,true);
         this.mDebugInfo += "suggest attack " + _loc3_.mItem.mId + " priority " + _loc6_ + "(" + _loc2_ + "," + this.mModePreferAttack + "," + this.mArmyCoherence + "," + (1 - this.mModePreferFormat) + ")" + ", ";
         this.suggestAction(_loc7_,_loc6_);
         if(!this.mQuickAttack && this.mArmyCoherence < (_loc1_.mActionsLeft == PvPMatch.ACTIONS_PER_TURN ? this.mModePreferFormat : this.mModePreferFormat + 0.2))
         {
            this.mDebugInfo += "Coherence low: " + this.mArmyCoherence + " < " + this.mModePreferFormat + ", ";
            for each(_loc10_ in this.mEnemyUnits)
            {
               if(_loc10_ != this.mLeaderEnemy)
               {
                  if((_loc11_ = this.getEnemyUnitIncoherence(_loc10_)) > 0 && _loc10_.distanceToElement(_loc3_) > this.mLeaderEnemy.distanceToElement(_loc3_))
                  {
                     _loc4_ = this.mScene.getNeighboringAvailableCellsAtChessboardDistance(this.mLeaderEnemy.getCell(),1);
                     _loc12_ = _loc10_.getWalkableCells();
                     if((_loc13_ = this.getIntersection(_loc4_,_loc12_)).length > 0)
                     {
                        _loc4_ = _loc13_;
                     }
                     _loc5_ = this.mScene.chooseCellClosestToCellAvoidingPlayers(_loc4_,_loc3_.getCell());
                     _loc6_ = (_loc6_ = (_loc1_.mActionsLeft == PvPMatch.ACTIONS_PER_TURN ? 0 : 1) + this.mModePreferAttack + this.mModePreferFormat + (this.mAttackWithWeakest ? Math.random() : _loc10_.getActorPriority()) + Math.min(1,_loc11_ / 2)) / 5;
                     _loc7_ = new PvPEnemyMovingAction(_loc10_,_loc5_,true);
                     this.suggestAction(_loc7_,_loc6_);
                     this.mDebugInfo += "suggest move " + _loc10_.mUnitId + " priority " + _loc6_ + "(" + this.mModePreferAttack + "," + this.mModePreferFormat + "," + _loc10_.getActorPriority() + "," + Math.min(1,_loc11_ / 2) + "), ";
                  }
               }
            }
         }
      }
      
      private function planCollectPowerUp() : void
      {
         var _loc2_:Element = null;
         var _loc3_:PvPEnemyUnit = null;
         var _loc4_:Array = null;
         var _loc5_:PowerUpObject = null;
         var _loc6_:Number = NaN;
         var _loc7_:PowerUpObject = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Action = null;
         var _loc1_:Vector.<PowerUpObject> = new Vector.<PowerUpObject>();
         for each(_loc2_ in this.mScene.mAllElements)
         {
            if(_loc2_ is PowerUpObject)
            {
               _loc1_.push(_loc2_ as PowerUpObject);
            }
         }
         if(_loc1_.length <= 0 || this.mModePreferAttack <= 0)
         {
            return;
         }
         for each(_loc3_ in this.mEnemyUnits)
         {
            _loc4_ = _loc3_.getWalkableCells();
            _loc5_ = null;
            _loc6_ = Number.MAX_VALUE;
            for each(_loc7_ in _loc1_)
            {
               if((_loc8_ = _loc3_.distanceToElement(_loc7_)) < _loc6_)
               {
                  _loc6_ = _loc8_;
                  _loc5_ = _loc7_;
               }
            }
            if(this.mPowerUpFan || _loc4_.indexOf(_loc5_.getCell()) >= 0)
            {
               _loc9_ = (_loc9_ = 1 - this.mModePreferAttack + Math.min(1,_loc3_.mMovementRange / 10)) / 2;
               if((_loc5_.mItem as PowerUpItem).mIncreasedHealth > 0 && _loc3_.getHealth() >= _loc3_.mMaxHealth)
               {
                  _loc9_ /= 3;
               }
               _loc10_ = new PvPEnemyMovingAction(_loc3_,_loc5_.getCell(),true);
               this.mDebugInfo += "suggest pickup priority " + _loc9_ + "(" + (1 - this.mModePreferAttack) + "," + Math.min(1,_loc3_.mMovementRange / 10) + "), ";
               this.suggestAction(_loc10_,_loc9_);
            }
         }
      }
      
      public function searchCellAttackablePlayerUnits(param1:GridCell) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:PlayerUnit = null;
         var _loc2_:Array = new Array();
         var _loc7_:Array = this.mScene.getPlayerAliveUnits();
         for each(_loc8_ in _loc7_)
         {
            _loc3_ = _loc8_.getCell().mPosI - _loc8_.getAttackRange();
            _loc4_ = _loc8_.getCell().mPosI + _loc8_.getAttackRange();
            _loc5_ = _loc8_.getCell().mPosJ - _loc8_.getAttackRange();
            _loc6_ = _loc8_.getCell().mPosJ + _loc8_.getAttackRange();
            if(param1.mPosI >= _loc3_ && param1.mPosI <= _loc4_ && param1.mPosJ >= _loc5_ && param1.mPosJ <= _loc6_)
            {
               _loc2_.push(_loc8_);
            }
         }
         return _loc2_;
      }
      
      public function searchAttackablePvPEnemyUnits(param1:PlayerUnit) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:IsometricCharacter = null;
         var _loc9_:PvPEnemyUnit = null;
         var _loc10_:GridCell = null;
         var _loc2_:Array = new Array();
         var _loc7_:Array = this.mScene.getEnemyUnits();
         for each(_loc8_ in _loc7_)
         {
            if(_loc8_ is PvPEnemyUnit && _loc8_.getHealth() > 0)
            {
               _loc9_ = _loc8_ as PvPEnemyUnit;
               _loc3_ = param1.getCell().mPosI - _loc9_.getAttackRange();
               _loc4_ = param1.getCell().mPosI + (param1.getTileSize().x - 1) + _loc9_.getAttackRange();
               _loc5_ = param1.getCell().mPosJ - _loc9_.getAttackRange();
               _loc6_ = param1.getCell().mPosJ + (param1.getTileSize().y - 1) + _loc9_.getAttackRange();
               if(_loc9_.isStill() && _loc9_.getCell().mPosI >= _loc3_ && _loc9_.getCell().mPosI <= _loc4_ && _loc9_.getCell().mPosJ >= _loc5_ && _loc9_.getCell().mPosJ <= _loc6_)
               {
                  _loc2_.push(_loc9_);
               }
               else if((_loc10_ = _loc9_.getMovementTargetCell()) && _loc10_.mPosI >= _loc3_ && _loc10_.mPosI <= _loc4_ && _loc10_.mPosJ >= _loc5_ && _loc10_.mPosJ <= _loc6_)
               {
                  _loc2_.push(_loc9_);
               }
            }
         }
         return _loc2_;
      }
   }
}
