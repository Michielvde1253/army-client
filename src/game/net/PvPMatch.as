package game.net
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.geom.Point;
   import game.ai.PvPAI;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.elements.Renderable;
   import game.items.BoosterItem;
   import game.items.CollectibleItem;
   import game.items.EnemyUnitItem;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.MapItem;
   import game.items.PlayerUnitItem;
   import game.states.GameState;
   
   public class PvPMatch
   {
      
      public static const ACTIONS_PER_TURN:int = 3;
       
      
      private var mGame:GameState;
      
      public var mOpponent:PvPOpponent;
      
      public var mSupplyCost:int;
      
      public var mEnergyCost:int;
      
      public var mPlayerUnits:Array;
      
      public var mOpponentUnits:Array;
      
      public var mTimestamp:Number;
      
      public var mWin:Boolean;
      
      public var mWinRewardMoney:int;
      
      public var mWinRewardBadassXp:int;
      
      public var mIngameBadassXp:int;
      
      public var mIngameCollectibles:Array;
      
      public var mActionsLeft:int;
      
      public var mPlayerTurn:Boolean = true;
      
      public var mTurnCounter:int;
      
      public var mAI:PvPAI;
      
      public var mActivatedBooster:BoosterItem;
      
      private const TURN_DELAY:int = 2000;
      
      private var mTurnChangeTimer:int;
      
      public function PvPMatch()
      {
         super();
         this.mGame = GameState.mInstance;
      }
      
      public function addIngameBaddassXp(param1:int) : void
      {
         this.mIngameBadassXp += param1;
      }
      
      public function addIngameCollectible(param1:Item) : void
      {
         if(param1 != null)
         {
            this.mIngameCollectibles.push(param1);
         }
      }
      
      public function setResult(param1:Boolean) : void
      {
         this.mWin = param1;
         if(!param1)
         {
            this.mWinRewardBadassXp = 0;
            this.mWinRewardMoney = 0;
         }
      }
      
      public function randomizeOpponentUnits() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:Item = null;
         this.mOpponentUnits = new Array();
         var _loc1_:int = (this.mOpponent.mBadassLevel / 5 as int) * 5;
         var _loc2_:int = 0;
         while(_loc2_ < 4 || this.mOpponentUnits.length < 2)
         {
            _loc3_ = Math.random() * 100;
            _loc4_ = 1;
            while(_loc4_ <= 11)
            {
               if((Boolean(_loc5_ = GameState.mConfig.PvPEnemyList[_loc4_])) && _loc5_["Level" + _loc1_] != null)
               {
                  _loc6_ = int(_loc5_["Level" + _loc1_]);
                  if(_loc3_ < _loc6_)
                  {
                     _loc7_ = ItemManager.getItem(_loc5_.Unit.ID,_loc5_.Unit.Type);
                     this.mOpponentUnits.push(_loc7_);
                     break;
                  }
                  _loc3_ -= _loc6_;
               }
               _loc4_++;
            }
            _loc2_++;
         }
      }
      
      public function initMatch(param1:Object) : void
      {
         this.mTimestamp = param1.timestamp;
         this.mWin = false;
         this.mIngameBadassXp = 0;
         this.mIngameCollectibles = new Array();
         this.initObjects();
         this.mPlayerTurn = true;
         this.mActionsLeft = ACTIONS_PER_TURN;
         this.mTurnCounter = 0;
         var _loc2_:int = this.mOpponent.mBadassLevel;
         this.mAI = new PvPAI(this.mGame,this.mGame.mScene,GameState.mConfig.PvPAIWeakenings["" + Math.round(Math.min(50,Math.max(0,_loc2_)))]);
         this.mGame.mPvPHUD.turnChanged(true);
      }
      
      public function randomizeMap() : String
      {
         var _loc1_:String = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:DCResourceManager = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in GameState.mConfig.MapSetup)
         {
            _loc1_ = _loc3_.ID as String;
            if(_loc1_.indexOf("pvp") >= 0)
            {
               _loc2_.push(_loc1_);
            }
         }
         //_loc1_ = String(_loc2_[Math.random() * _loc2_.length as int]);
	     _loc1_ = String(_loc2_["0"]);
         _loc4_ = (_loc4_ = GameState.mConfig.MapSetup[_loc1_].TilemapFileName as String).substring(0,_loc4_.lastIndexOf("."));
         if(!(_loc5_ = DCResourceManager.getInstance()).isAddedToLoadingList(_loc4_))
         {
            _loc5_.load(Config.DIR_CONFIG + _loc4_ + ".csv",_loc4_,null,true);
         }
         return _loc1_;
      }
      
      public function getAttackUnitsString() : String
      {
		 if(this.mPlayerUnits){
         var _loc3_:PlayerUnitItem = null;
         var _loc1_:* = "";
         var _loc2_:int = 0;
         while(_loc2_ < this.mPlayerUnits.length)
         {
            _loc3_ = this.mPlayerUnits[_loc2_];
            _loc1_ += _loc3_.mId;
            if(_loc2_ < this.mPlayerUnits.length - 1)
            {
               _loc1_ += ",";
            }
            _loc2_++;
         }
         return _loc1_;
		 } else {
			 return null;
		 }
      }
      
      public function getDefensiveUnitsString() : String
      {
		 if(this.mOpponentUnits){
         var _loc3_:EnemyUnitItem = null;
         var _loc1_:* = "";
         var _loc2_:int = 0;
         while(_loc2_ < this.mOpponentUnits.length)
         {
            _loc3_ = this.mOpponentUnits[_loc2_];
            _loc1_ += _loc3_.mId;
            if(_loc2_ < this.mOpponentUnits.length - 1)
            {
               _loc1_ += ",";
            }
            _loc2_++;
         }
         return _loc1_;
		 } else {
			 return null;
		 }
      }
      
      public function getIngameCollectiblesString() : String
      {
         var _loc3_:CollectibleItem = null;
         var _loc1_:* = "";
         var _loc2_:int = 0;
         while(_loc2_ < this.mIngameCollectibles.length)
         {
            _loc3_ = this.mIngameCollectibles[_loc2_];
            _loc1_ += _loc3_.mId;
            if(_loc2_ < this.mIngameCollectibles.length - 1)
            {
               _loc1_ += ",";
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function updateTurn(param1:int) : void
      {
         var _loc2_:IsometricScene = this.mGame.mScene;
         if(this.mPlayerTurn)
         {
            if(_loc2_.getEnemyUnits().length > 0 && _loc2_.getPlayerAliveUnits().length > 0)
            {
               if(this.mActionsLeft <= 0)
               {
                  this.mTurnChangeTimer = this.TURN_DELAY;
                  this.changeTurn();
               }
            }
            else
            {
               this.mGame.openPvPDebriefing(_loc2_.getEnemyUnits().length == 0);
            }
         }
         else
         {
            this.mTurnChangeTimer -= param1;
            if(_loc2_.getPlayerAliveUnits().length == 0 || _loc2_.getEnemyUnits().length == 0)
            {
               this.mGame.openPvPDebriefing(_loc2_.getEnemyUnits().length == 0);
            }
            else if(this.mActionsLeft > 0)
            {
               if(this.mTurnChangeTimer <= 0)
               {
                  this.doEnemyAction();
                  this.mTurnChangeTimer = 0;
               }
            }
            else
            {
               ++this.mTurnCounter;
               this.changeTurn();
            }
         }
      }
      
      private function doEnemyAction() : void
      {
         if(!this.mAI)
         {
            this.mAI = new PvPAI(this.mGame,this.mGame.mScene,GameState.mConfig.PvPAIWeakenings["0"]);
         }
         this.mAI.makeMove();
      }
      
      private function changeTurn() : void
      {
         this.mActionsLeft = ACTIONS_PER_TURN;
         this.mPlayerTurn = !this.mPlayerTurn;
         this.mGame.mPvPHUD.mTextUpdateRequired = true;
         this.mGame.mPvPHUD.turnChanged(this.mPlayerTurn);
         if(PvPAI.AI_DEBUG)
         {
         }
      }
      
      public function initObjects() : void
      {
         var _loc2_:Renderable = null;
         var _loc3_:Object = null;
         var _loc4_:MapItem = null;
         var _loc5_:GridCell = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Object = null;
         var _loc16_:EnemyUnitItem = null;
         var _loc17_:Array = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:PlayerUnitItem = null;
         var _loc21_:Array = null;
         var _loc22_:int = 0;
         var _loc1_:IsometricScene = this.mGame.mScene;
         if(this.mGame.mMapData.mMapSetupData.SetupSet)
         {
            for each(_loc3_ in GameState.mConfig.PVPAreaSetup)
            {
               if(_loc3_.SetupSet == this.mGame.mMapData.mMapSetupData.SetupSet)
               {
                  _loc7_ = _loc1_.getFreeCellsInTheArea(_loc3_.X,_loc3_.Y,_loc3_.Width,_loc3_.Height);
                  if(_loc3_.SpawnObjects)
                  {
                     _loc8_ = _loc3_.SpawnObjects is Array ? _loc3_.SpawnObjects : new Array(_loc3_.SpawnObjects);
                     _loc9_ = _loc3_.SpawnObjectsPercentage is Array ? _loc3_.SpawnObjectsPercentage : new Array(_loc3_.SpawnObjectsPercentage);
                     _loc10_ = _loc3_.SpawnObjectsAmount is Array ? _loc3_.SpawnObjectsAmount : new Array(_loc3_.SpawnObjectsAmount);
                     _loc11_ = 0;
                     while(_loc11_ < _loc8_.length)
                     {
                        _loc12_ = _loc11_ < _loc9_.length ? int(_loc9_[_loc11_]) : 0;
                        _loc13_ = _loc11_ < _loc10_.length ? int(_loc10_[_loc11_]) : 0;
                        _loc14_ = 0;
                        while(_loc14_ < _loc13_)
                        {
                           if(_loc7_.length == 0)
                           {
                              break;
                           }
                           if(100 * Math.random() < _loc12_)
                           {
                              _loc6_ = _loc7_.length * Math.random();
                              _loc5_ = _loc7_[_loc6_];
                              _loc7_.splice(_loc6_,1);
                              _loc15_ = _loc8_[_loc11_] as Object;
                              if(_loc3_.SpawningAreaType == "ObstacleSpawning")
                              {
								 _loc4_ = ItemManager.getItem(_loc15_.ID,_loc15_.Type) as MapItem
                                 if(!_loc4_)
                                 {
                                    break;
                                 }
                                 _loc2_ = _loc1_.createObject(_loc4_,new Point(0,0));
                                 _loc2_.setPos(_loc1_.getCenterPointXOfCell(_loc5_),_loc1_.getCenterPointYOfCell(_loc5_),0);
                              }
                              else if(_loc3_.SpawningAreaType == "PowerUpSpawning")
                              {
                                 _loc1_.addPowerUpToMap(_loc15_.ID,_loc5_);
                              }
                           }
                           _loc14_++;
                        }
                        _loc11_++;
                     }
                  }
                  else if(_loc3_.SpawningAreaType == "EnemySpawning")
                  {
                     if(this.mOpponentUnits != null)
                     {
                        for each(_loc16_ in this.mOpponentUnits)
                        {
                           if(_loc7_.length == 0)
                           {
                              break;
                           }
                           _loc6_ = _loc7_.length * Math.random();
                           _loc5_ = _loc7_[_loc6_];
                           _loc7_.splice(_loc6_,1);
                           _loc2_ = _loc1_.createObject(_loc16_,new Point(0,0));
                           _loc2_.setPos(_loc1_.getCenterPointXOfCell(_loc5_),_loc1_.getCenterPointYOfCell(_loc5_),0);
                        }
                     }
                     else
                     {
                        (_loc17_ = new Array())[0] = "PvPInfantry";
                        _loc17_[1] = "PvPAPC";
                        _loc17_[2] = "PvPArtillery";
                        _loc17_[3] = "PvPRocketBattery";
                        _loc18_ = 0;
                        while(_loc18_ < 4)
                        {
                           if(_loc7_.length == 0)
                           {
                              break;
                           }
                           _loc6_ = _loc7_.length * Math.random();
                           _loc5_ = _loc7_[_loc6_];
                           _loc7_.splice(_loc6_,1);
                           _loc19_ = _loc17_.length * Math.random();
                           _loc4_ = ItemManager.getItem(_loc17_[_loc19_],"PvPEnemyUnit") as MapItem;
                           _loc2_ = _loc1_.createObject(_loc4_,new Point(0,0));
                           _loc2_.setPos(_loc1_.getCenterPointXOfCell(_loc5_),_loc1_.getCenterPointYOfCell(_loc5_),0);
                           _loc18_++;
                        }
                     }
                  }
                  else if(_loc3_.SpawningAreaType == "PlayerSpawning")
                  {
                     if(this.mPlayerUnits != null)
                     {
                        for each(_loc20_ in this.mPlayerUnits)
                        {
                           if(_loc7_.length == 0)
                           {
                              break;
                           }
                           _loc6_ = _loc7_.length * Math.random();
                           _loc5_ = _loc7_[_loc6_];
                           _loc7_.splice(_loc6_,1);
                           _loc2_ = _loc1_.createObject(_loc20_,new Point(0,0));
                           _loc2_.setPos(_loc1_.getCenterPointXOfCell(_loc5_),_loc1_.getCenterPointYOfCell(_loc5_),0);
                        }
                     }
                     else
                     {
                        (_loc21_ = new Array())[0] = "Infantry";
                        _loc21_[1] = "Infantry";
                        _loc21_[2] = "ArmoredCar";
                        _loc21_[3] = "Armor";
                        _loc21_[4] = "GunBattery";
                        _loc21_[5] = "Artillery";
                        _loc21_[6] = "MobileRocketBattery";
                        _loc21_[7] = "Artillery";
                        _loc22_ = 0;
                        while(_loc22_ < 4)
                        {
                           if(_loc7_.length == 0)
                           {
                              break;
                           }
                           _loc6_ = _loc7_.length * Math.random();
                           _loc5_ = _loc7_[_loc6_];
                           _loc7_.splice(_loc6_,1);
                           _loc19_ = (_loc19_ = 4 * Math.random()) * 2;
                           _loc4_ = ItemManager.getItem(_loc21_[_loc19_],_loc21_[_loc19_ + 1]) as MapItem;
                           _loc2_ = _loc1_.createObject(_loc4_,new Point(0,0));
                           _loc2_.setPos(_loc1_.getCenterPointXOfCell(_loc5_),_loc1_.getCenterPointYOfCell(_loc5_),0);
                           _loc22_++;
                        }
                     }
                  }
               }
            }
         }
      }
   }
}
