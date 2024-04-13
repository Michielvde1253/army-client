package game.missions
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.StageDisplayState;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import game.characters.EnemyUnit;
   import game.characters.PlayerUnit;
   import game.gameElements.PlayerBuildingObject;
   import game.gui.DCWindow;
   import game.gui.IconInterface;
   import game.gui.popups.ToasterWindow;
   import game.gui.popups.TutorialWindow;
   import game.isometric.IsometricScene;
   import game.isometric.elements.Renderable;
   import game.items.*;
   import game.magicBox.FlurryEvents;
   import game.magicBox.MagicBoxTracker;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.player.RankManager;
   import game.states.GameState;
   
   public class Mission implements IconInterface
   {
      
      public static const STATE_INACTIVE:int = 0;
      
      public static const STATE_ACTIVE:int = 1;
      
      public static const STATE_COMPLETED:int = 2;
      
      public static const STATE_REWARDS_COLLECTED:int = 3;
      
      public static const TYPE_MODAL_ARROW:String = "ModalArrow";
      
      public static const TYPE_MODAL_DIALOG:String = "ModalDialog";
      
      public static const TYPE_NORMAL:String = "Normal";
      
      public static const TYPE_INTEL:String = "Intel";
      
      public static const TYPE_INTEL_DIALOG:String = "IntelDialog";
      
      public static const TYPE_TOASTER_MESSAGE:String = "ToasterMessage";
      
      public static const TYPE_STORY:String = "Story";
      
      public static const TYPE_RANK:String = "Rank";
      
      public static const TYPE_CAMPAIGN:String = "Campaign";
      
      public static const TYPE_TIP:String = "Tip";
      
      public static const TYPE_INSTANT_TIP:String = "InstantTip";
       
      
      public var mId:String;
      
      public var mType:String;
      
      public var mTitle:String;
      
      public var mHintText:String;
      
      public var mDescription:String;
      
      public var mCompletionText:String;
      
      public var mCampaignCompletionText:Array;
      
      private var mObjectives:Object;
      
      private var mOrderedObjectives:Array;
      
      public var mRequiredMissions:Array;
      
      private var mMissionSetup:Array;
      
      private var mRewardMoney:int;
      
      private var mRewardXp:int;
      
      public var mRewardItems:Array;
      
      private var mEnemySpawning:Array;
      
      public var mProgressPending:Boolean;
      
      public var mNarratorCharacter:Object;
      
      public var mTipGraphics:String;
      
      public var mMapId:String;
      
      public var mObsolete:Boolean;
      
      public var mFeedObject:Object;
      
      public var mCustomFeed:Boolean;
      
      public var mNew:Boolean;
      
      public var mOpened:Boolean;
      
      public var mState:int;
      
      private var mIconGraphicsFile:String;
      
      private var mIconGraphics:String;
      
      private var objectiveClass1:Collect;
      
      private var objectiveClass2:Conquer;
      
      private var objectiveClass3:Destroy;
      
      private var objectiveClass4:Buy;
      
      private var objectiveClass5:Build;
      
      private var objectiveClass6:Select;
      
      private var objectiveClass7:CollectIntel;
      
      private var objectiveClass8:Recapture;
      
      private var objectiveClass9:StartProducing;
      
      private var objectiveClass10:Stockpile;
      
      private var objectiveClass11:KillWith;
      
      private var objectiveClass12:Close;
      
      private var objectiveClass13:Repair;
      
      private var objectiveClass14:Clear;
      
      private var objectiveClass15:CompleteBuilding;
      
      private var objectiveClass16:Control;
      
      private var objectiveClass17:HelpNeighborClear;
      
      private var objectiveClass18:HelpNeighborCollect;
      
      private var objectiveClass19:HelpNeighborUnwither;
      
      private var objectiveClass20:HelpNeighborSpeedUp;
      
      private var objectiveClass21:HelpNeighborSuppress;
      
      private var objectiveClass22:HelpNeighborTrain;
      
      private var objectiveClass23:Neighbors;
      
      private var objectiveClass24:StockpileItems;
      
      private var objectiveClass25:OwnItems;
      
      private var objectiveClass26:DestroyTarget;
      
      private var objectiveClass27:ActivateRepair;
      
      private var objectiveClass28:OpenShop;
      
      private var objectiveClass29:DestroyWithMultiple;
      
      private var objectiveClass30:Place;
      
      private var objectiveClass31:FullScreen;
      
      private var objectiveClass32:Zoom;
      
      private var objectiveClass33:OpenMap;
      
      private var objectiveClass34:OpenSettings;
      
      private var objectiveClass35:OpenItemTab;
      
      private var objectiveClass36:OpenBuilding;
      
      private var objectiveClass37:OpenMission;
      
      public function Mission(param1:Object)
      {
         var _loc2_:Item = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         super();
         this.mState = STATE_INACTIVE;
         this.mNew = false;
         this.mOpened = false;
         this.mId = param1.ID;
         this.mType = param1.Type.ID;
         this.mTitle = param1.Name;
         this.mHintText = param1.HintText;
         this.mDescription = param1.Description;
         this.mCompletionText = param1.CompletionText;
         this.mCampaignCompletionText = param1.CampaignCompletionText;
         this.mNarratorCharacter = param1.Narrator;
         this.mTipGraphics = param1.TipGraphics;
         this.mObsolete = param1.Obsolete == 1;
         this.mFeedObject = param1.FeedObject;
         this.mMapId = param1.MapId;
         this.mCustomFeed = this.mFeedObject != null;
         this.mRewardItems = new Array();
         this.mRewardMoney = param1.RewardMoney;
         this.mRewardXp = param1.RewardXP;
         _loc2_ = ItemManager.getItem("Money","Resource");
         this.mRewardItems.push(_loc2_);
         this.mRewardItems.push(this.mRewardMoney);
         _loc2_ = ItemManager.getItem("XP","Resource");
         this.mRewardItems.push(_loc2_);
         this.mRewardItems.push(this.mRewardXp);
         if(param1.RewardItems is Array)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.RewardItems.length)
            {
               _loc4_ = param1.RewardItems[_loc3_] as Object;
               _loc2_ = ItemManager.getItem(_loc4_.Item.ID,_loc4_.Item.Type);
               this.mRewardItems.push(_loc2_);
               this.mRewardItems.push(_loc4_.Amount);
               _loc3_++;
            }
         }
         else if(param1.RewardItems != null)
         {
            _loc2_ = ItemManager.getItem(param1.RewardItems.Item.ID,param1.RewardItems.Item.Type);
            this.mRewardItems.push(_loc2_);
            this.mRewardItems.push(param1.RewardItems.Amount);
         }
         if(param1.RequiredMissions == null || param1.RequiredMissions is Array)
         {
            this.mRequiredMissions = param1.RequiredMissions;
         }
         else
         {
            this.mRequiredMissions = new Array();
            this.mRequiredMissions[0] = param1.RequiredMissions;
         }
         if(param1.SetupGroup != null)
         {
            _loc5_ = GameState.mConfig.MissionSetup;
            this.mMissionSetup = new Array();
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.Group == param1.SetupGroup)
               {
                  this.mMissionSetup.push(_loc6_);
               }
            }
         }
         this.initObjectives(param1);
         if(param1.EnemySpawning)
         {
            this.mEnemySpawning = new Array();
            for each(_loc7_ in param1.EnemySpawning.EnemyUnits)
            {
               this.mEnemySpawning.push(_loc7_.ID);
            }
         }
         if(param1.Icon)
         {
            _loc8_ = int(param1.Icon.lastIndexOf("/"));
            this.mIconGraphics = param1.Icon.substring(_loc8_ + 1);
            this.mIconGraphicsFile = param1.Icon.substring(0,_loc8_);
         }
      }
      
      private function initObjectives(param1:Object) : void
      {
         var objectivesConfig:Array = null;
         var objective:Object = null;
         var className:String = null;
         var objectiveClass:Class = null;
         var missionConfig:Object = param1;
         if(!(missionConfig.Objectives is Array))
         {
            objectivesConfig = new Array();
            objectivesConfig[0] = missionConfig.Objectives;
         }
         else
         {
            objectivesConfig = missionConfig.Objectives;
         }
         this.mObjectives = new Object();
         this.mOrderedObjectives = new Array();
         for each(objective in objectivesConfig)
         {
            if(objective)
            {
               className = "game.missions." + objective.Type.ID;
               if(objective.Type.ID == "Zoom" || objective.Type.ID == "FullScreen" || objective.Type.ID == "OpenMap")
               {
                  if(Config.DEBUG_MODE)
                  {
                  }
               }
               try
               {
                  objectiveClass = getDefinitionByName(className) as Class;
               }
               catch(errObject:Error)
               {
                  objectiveClass = Objective;
               }
               if(!objectiveClass)
               {
                  objectiveClass = Objective;
               }
               this.mObjectives[objective.ID] = new objectiveClass(objective);
               Objective(this.mObjectives[objective.ID]).setMapId(this.mMapId);
               this.mOrderedObjectives.push(this.mObjectives[objective.ID]);
            }
         }
      }
      
      public function activate() : void
      {
         var _loc1_:Objective = null;
         if(this.mState == STATE_INACTIVE)
         {
            this.mState = STATE_ACTIVE;
            if(Config.DEBUG_MISSIONS)
            {
            }
            if(this.mMissionSetup)
            {
               this.createGameObjects();
            }
            for each(_loc1_ in this.mObjectives)
            {
               _loc1_.initialize(this.mType,null);
            }
            if(this.mEnemySpawning)
            {
               GameState.mInstance.spawnNewEnemies(this.mEnemySpawning,this.mEnemySpawning.length);
            }
            if(this.checkExceptions())
            {
               this.setupPopups();
               this.setNew(true);
            }
            if(this.mType == TYPE_RANK)
            {
               GameState.mInstance.mPlayerProfile.mRankIdx = RankManager.getIndexOfMission(this);
            }
         }
         else
         {
            Utils.LogError("Trying to activate already active mission");
         }
      }
      
      private function checkExceptions() : Boolean
      {
         var _loc1_:Objective = null;
         if(this.mObjectives)
         {
            for each(_loc1_ in this.mObjectives)
            {
               if(_loc1_)
               {
                  if(GameState.mInstance.getMainClip().stage.displayState == StageDisplayState.FULL_SCREEN)
                  {
                     return false;
                  }
               }
            }
         }
         return true;
      }
      
      public function setup(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Objective = null;
         this.mState = STATE_ACTIVE;
         var _loc2_:Array = param1.objectives;
         if(_loc2_)
         {
            for each(_loc3_ in _loc2_)
            {
               if(_loc4_ = this.mObjectives[_loc3_.objectiveId])
               {
                  _loc4_.initialize(this.mType,_loc3_);
               }
               else if(Config.DEBUG_MODE)
               {
               }
            }
         }
         else
         {
            Utils.LogError("Objective setups missing for mission \"" + this.mId + "\"");
         }
         this.setupPopups();
      }
      
      private function setupPopups() : void
      {
         switch(this.mType)
         {
            case TYPE_MODAL_ARROW:
               GameState.mInstance.mHUD.openTutorialWindow(this);
               break;
            case TYPE_MODAL_DIALOG:
               GameState.mInstance.mHUD.openCharacterDialogWindow(this);
               break;
            case TYPE_INSTANT_TIP:
               GameState.mInstance.mHUD.openTipWindow(this);
               break;
            case TYPE_TOASTER_MESSAGE:
               GameState.mInstance.mHUD.openToasterTip(this);
               break;
            case TYPE_CAMPAIGN:
               if(GameState.mInstance.mLoadingStatesOver)
               {
                  if(GameState.mInstance.mState != GameState.STATE_LOADING_NEIGHBOUR)
                  {
                     GameState.mInstance.mHUD.openCampaignWindow(this);
                  }
               }
         }
      }
      
      public function setTargetPopup(param1:DCWindow) : void
      {
         var _loc2_:Objective = null;
         if(param1)
         {
            for each(_loc2_ in this.mObjectives)
            {
               if(_loc2_ is Close)
               {
                  Close(_loc2_).setPopup(param1);
               }
            }
         }
      }
      
      public function setNew(param1:Boolean) : void
      {
         this.mNew = param1;
      }
      
      public function setOpened(param1:Boolean) : void
      {
         this.mOpened = param1;
      }
      
      public function getNumObjectives() : int
      {
         return this.mOrderedObjectives.length;
      }
      
      public function getObjectiveByIndex(param1:int) : Objective
      {
         return this.mOrderedObjectives[param1];
      }
      
      public function collectRewards() : void
      {
         var _loc1_:GameState = null;
         var _loc2_:GamePlayerProfile = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Objective = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         if(this.mState == STATE_COMPLETED)
         {
            this.mState = STATE_REWARDS_COLLECTED;
            _loc1_ = GameState.mInstance;
            _loc2_ = _loc1_.mPlayerProfile;
            if(this.mType == TYPE_RANK)
            {
               ++_loc2_.mRankIdx;
            }
            _loc3_ = 0;
            while(_loc3_ < this.mRewardItems.length / 2)
            {
               _loc2_.addItem(this.mRewardItems[_loc3_ * 2],this.mRewardItems[_loc3_ * 2 + 1]);
               if(this.mRewardItems[_loc3_ * 2] is PlayerUnitItem)
               {
                  _loc6_ = 0;
                  while(_loc6_ < this.mRewardItems[_loc3_ * 2 + 1])
                  {
                     GameState.mInstance.mPlayerProfile.addUnit(this.mRewardItems[_loc3_ * 2] as PlayerUnitItem);
                     _loc6_++;
                  }
               }
               _loc3_++;
            }
            _loc4_ = {
               "mission_id":this.mId,
               "reward_money":this.mRewardMoney,
               "reward_xp":this.mRewardXp,
               "map_id":this.mMapId
            };
            for each(_loc5_ in this.mObjectives)
            {
               if(!_loc5_.mPurchased)
               {
                  if(_loc5_ is Stockpile || _loc5_ is StockpileItems)
                  {
                     _loc2_.addItem(ItemManager.getItem(_loc5_.mParameter.ID,_loc5_.mParameter.Type),-int(_loc5_.mGoal));
                  }
               }
            }
            _loc1_.mServer.serverCallServiceWithParameters(ServiceIDs.COMPLETE_MISSION,_loc4_,false);
            if(Config.DEBUG_MODE)
            {
            }
            MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_LEVEL,MagicBoxTracker.TYPE_MISSION_COMPLETED,this.mId);
         }
         else
         {
            Utils.LogError("Trying to collect reward for mission with incorrect state: " + this.mState);
         }
      }
      
      public function increaseCounter(param1:String, param2:Object, param3:int) : Boolean
      {
         var _loc5_:Objective = null;
         var _loc4_:Boolean = false;
         for each(_loc5_ in this.mObjectives)
         {
            if(_loc5_.mType == param1 && (_loc5_.mCounter < _loc5_.mGoal || _loc5_ is Stockpile || _loc5_ is Own || _loc5_ is StockpileItems || _loc5_ is OwnItems))
            {
               _loc4_ = _loc5_.increase(param2,param3) || _loc4_;
               if(Config.DEBUG_MISSIONS)
               {
               }
               if(_loc5_.isDone())
               {
                  if(_loc4_)
                  {
                     _loc5_.clean();
                     if(this.mType == TYPE_CAMPAIGN)
                     {
                        MissionManager.addCompleteCampaignObjective(this,_loc5_);
                     }
                  }
               }
            }
         }
         this.mProgressPending = _loc4_;
         return _loc4_;
      }
      
      public function getProgressPending(param1:Boolean = false) : Boolean
      {
         var _loc2_:Boolean = this.mProgressPending;
         if(param1)
         {
            this.mProgressPending = false;
         }
         return _loc2_;
      }
      
      public function allObjectivesDone() : Boolean
      {
         var _loc1_:Objective = null;
         for each(_loc1_ in this.mObjectives)
         {
            if(!_loc1_.isDone())
            {
               return false;
            }
         }
         if(this.mType == TYPE_MODAL_ARROW)
         {
            GameState.mInstance.mHUD.closeDialog(TutorialWindow);
         }
         else if(this.mType == TYPE_TOASTER_MESSAGE)
         {
            GameState.mInstance.mHUD.closeDialog(ToasterWindow);
         }
         return true;
      }
      
      public function createGameObjects() : void
      {
		 trace("creating game objects");
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:MapItem = null;
         var _loc8_:Renderable = null;
         var _loc9_:String = null;
         var _loc1_:IsometricScene = GameState.mInstance.mScene;
         for each(_loc2_ in this.mMissionSetup)
         {
            _loc3_ = int(_loc2_.AreaX);
            _loc4_ = int(_loc2_.AreaY);
            _loc5_ = _loc1_.getCenterPointXAtIJ(_loc3_,_loc4_);
            _loc6_ = _loc1_.getCenterPointYAtIJ(_loc3_,_loc4_);
            if((_loc7_ = ItemManager.getItem(_loc2_.Item.ID,_loc2_.Item.Type) as MapItem).mType != "HFEPlot")
            {
               (_loc8_ = _loc1_.createObject(_loc7_,new Point(0,0))).setPos(_loc5_,_loc6_,0);
               if((_loc9_ = _loc7_.mType) == "Infantry" || _loc9_ == "Armor" || _loc9_ == "Artillery")
               {
                  if(_loc2_.Health)
                  {
                     (_loc8_ as PlayerUnit).setHealth(_loc2_.Health);
                  }
                  GameState.mInstance.mPlayerProfile.updateUnitCaps();
                  GameState.mInstance.mPlayerProfile.addUnit(_loc7_ as PlayerUnitItem);
               }
               else if(_loc9_ == "EnemyUnit")
               {
                  if(_loc2_.Health)
                  {
                     (_loc8_ as EnemyUnit).setHealth(_loc2_.Health);
                  }
                  (_loc8_ as EnemyUnit).setActivationTime(_loc2_.ActivationDelay);
               }
               else if(_loc9_ == "HomeFrontEffort")
               {
                  (_loc8_ as PlayerBuildingObject).handlePlacedOnMap();
               }
            }
         }
         GameState.mInstance.updateGrid();
         GameState.mInstance.mScene.mFog.init();
      }
      
      public function getIconGraphics() : String
      {
         return this.mIconGraphics;
      }
      
      public function getIconGraphicsFile() : String
      {
         return this.mIconGraphicsFile;
      }
      
      public function getIconMovieClip() : MovieClip
      {
         var _loc1_:Class = null;
         var _loc2_:DCResourceManager = DCResourceManager.getInstance();
         _loc1_ = _loc2_.getSWFClass(this.mIconGraphicsFile,this.mIconGraphics);
         if(_loc1_)
         {
            return new _loc1_();
         }
         return null;
      }
      
      public function getObjectives() : Array
      {
         return this.mOrderedObjectives;
      }
   }
}
