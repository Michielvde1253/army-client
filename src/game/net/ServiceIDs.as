package game.net
{
   public class ServiceIDs
   {
      
      public static const CREATE_NEW_SESSION:String = "CreateNewSession";
      
      public static const ADD_GOLD_AND_CASH:String = "AddGoldAndCash";
      
      public static const GET_GOLD_AND_CASH:String = "GetGoldAndCash";
      
      public static const DEDUCT_GOLD_AND_CASH:String = "DeductGoldAndCash";
      
      public static const GET_USER_DATA:String = "GetUserData";
      
      public static const GET_MAP_DATA:String = "GetMapData";
      
      public static const GET_INVENTORY:String = "GetInventory";
      
      public static const ACCEPT_MISSION:String = "AcceptMission";
      
      public static const COMPLETE_MISSION:String = "CompleteMission";
      
      public static const BUY_AND_PLACE_UNIT:String = "BuyAndPlacePlayerUnit";
      
      public static const BUY_AND_PLACE_HFE:String = "BuyAndPlaceHomeFrontEffort";
      
      public static const BUY_AND_PLACE_DECO:String = "BuyAndPlaceDeco";
      
      public static const BUY_AND_PLACE_BUILDING:String = "BuyAndPlaceBuilding";
      
      public static const BUY_AND_PLACE_INSTALLATION:String = "BuyAndPlacePlayerInstallation";
      
      public static const BUY_ENERGY:String = "BuyEnergy";
      
      public static const BUY_SUPPLIES:String = "BuySupplies";
      
      public static const BUY_MAP_AREA:String = "BuyMapArea";
      
      public static const PLACE_ENEMY_UNIT:String = "PlaceEnemyUnit";
      
      public static const PLACE_ENEMY_INSTALLATION:String = "PlaceEnemyInstallation";
      
      public static const REMOVE_GAMEFIELD_ITEM:String = "RemoveGamefieldItem";
      
      public static const MOVE_UNIT:String = "MoveUnit";
      
      public static const MOVE_ENEMY:String = "MoveEnemy";
      
      public static const MOVE_STRUCTURE:String = "MoveStructure";
      
      public static const SELL_ITEM:String = "SellItem";
      
      public static const USE_FIRE_MISSION:String = "UseFireMission";
      
      public static const ATTACK_ENEMY_UNIT:String = "AttackEnemyUnit";
      
      public static const ATTACK_ENEMY_INSTALLATION:String = "AttackEnemyInstallation";
      
      public static const CAPTURE_HF:String = "CaptureHF";
      
      public static const ATTACK_PLAYER_UNIT:String = "AttackPlayerUnit";
      
      public static const ACTIVATE_TURN_BASED_ENEMY:String = "ActivateTurnBasedEnemy";
      
      public static const ATTACK_PLAYER_INSTALLATION:String = "AttackPlayerInstallation";
      
      public static const ATTACK_PLAYER_HOME_FRONT_EFFORT:String = "AttackPlayerHomeFrontEffort";
      
      public static const ATTACK_PLAYER_DECO:String = "AttackPlayerDeco";
      
      public static const ATTACK_PLAYER_BUILDING:String = "AttackPlayerBuilding";
      
      public static const ATTACK_PLAYER_PERMANENT_HFE:String = "AttackPlayerPermanentHFE";
      
      public static const INCREMENT_TURN_COUNTERS:String = "IncrementTurnCounters";
      
      public static const REPAIR_PLAYER_UNIT:String = "RepairPlayerUnit";
      
      public static const REPAIR_PLAYER_INSTALLATION:String = "RepairPlayerInstallation";
      
      public static const REPAIR_PLAYER_BUILDING:String = "RepairPlayerBuilding";
      
      public static const REPAIR_PLAYER_DECORATION:String = "RepairDeco";
      
      public static const REMOVE_EXPIRED_UNIT:String = "RemoveExpiredUnit";
      
      public static const CLEAN_DEBRIS:String = "CleanDebris";
      
      public static const PLACE_DEBRIS:String = "PlaceDebris";
      
      public static const START_HOME_FRONT_PRODUCTION:String = "StartHomeFrontProduction";
      
      public static const START_BUILDING_PRODUCTION:String = "StartBuildingProduction";
      
      public static const COLLECT_HF:String = "CollectHF";
      
      public static const COLLECT_BUILDING:String = "CollectBuilding";
      
      public static const WHACK_BUILDING:String = "WhackBuilding";
      
      public static const COMPLETE_BUILDING:String = "CompleteBuilding";
      
      public static const BUY_INGREDIENTS:String = "BuyIngredients";
      
      public static const GET_NEIGHBORS:String = "GetNeighbors";
      
      public static const GET_NEIGHBOR_DATA:String = "GetNeighborData";
      
      public static const SCHEDULE_ACTION_AT_NEIGHBOR:String = "ScheduleActionAtNeighbor";
      
      public static const GET_PENDING_NEIGHBOR_ACTIONS:String = "GetPendingNeighborActions";
      
      public static const ACCEPT_HELP_CLEAR_DEBRIS:String = "AcceptHelpClearDebris";
      
      public static const ACCEPT_HELP_COLLECT_HF:String = "AcceptHelpCollectHF";
      
      public static const ACCEPT_HELP_COLLECT_PHF:String = "AcceptHelpCollectPHF";
      
      public static const ACCEPT_HELP_REVIVE_HF:String = "AcceptHelpReviveHF";
      
      public static const ACCEPT_HELP_SPEED_UP_HF:String = "AcceptHelpSpeedUpHF";
      
      public static const ACCEPT_HELP_SPEED_UP_PHF:String = "AcceptHelpSpeedUpPHF";
      
      public static const ACCEPT_HELP_SUPPRESS_ENEMY:String = "AcceptHelpSuppressEnemy";
      
      public static const ACCEPT_HELP_TRAIN_UNIT:String = "AcceptHelpTrainUnit";
      
      public static const ACCEPT_HELP_SUPPRESS_ENEMY_INSTALLATION:String = "AcceptHelpSuppressEnemyInstallation";
      
      public static const REJECT_NEIGHBOR_HELP_ACTIONS:String = "RejectNeighborHelpActions";
      
      public static const GET_WCRM_DATA:String = "GetWCRMPopups";
      
      public static const REPORT_CLIENT_ERROR:String = "ReportClientError";
      
      public static const UNLOCK_ITEM:String = "UnlockItem";
      
      public static const UNLOCK_MISSION_OBJECTIVE:String = "UnlockMissionObjective";
      
      public static const CLAIM_ALL_GIFTS:String = "ClaimAllGifts";
      
      public static const USE_POWER_UP_FROM_INVENTORY:String = "UsePowerupFromInventory";
      
      public static const PLACE_DECO:String = "PlaceDeco";
      
      public static const PLACE_UNIT_FROM_INVENTORY:String = "PlaceUnitFromInventory";
      
      public static const GET_DAILY_REWARD:String = "GetDailyReward";
      
      public static const CLAIM_DAILY_REWARD:String = "ClaimDailyReward";
      
      public static const TRADE_IN_COLLECTION:String = "TradeInCollection";
      
      public static const SET_WISHLIST:String = "SetWishlist";
      
      public static const GET_TUTOR_DATA:String = "GetTutorData";
      
      public static const PICK_UP_UNIT:String = "PickupUnit";
      
      public static const GET_PVP_DATA:String = "GetPvpData";
      
      public static const START_PVP_MATCH:String = "StartPvpMatch";
      
      public static const END_PVP_MATCH:String = "EndPvpMatch";
      
      public static const START_TIMER:String = "StartTimer";
      
      public static const FEDERAL_PROXY:String = "FederalProxy";
       
      
      public function ServiceIDs()
      {
         super();
      }
   }
}
