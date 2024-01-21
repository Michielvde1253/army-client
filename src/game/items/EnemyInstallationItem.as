package game.items
{
   import game.states.GameState;
   
   public class EnemyInstallationItem extends TargetItem
   {
       
      
      public var mDamage:int;
      
      public var mAttackRange:int;
      
      public var mReactionTime:int;
      
      public var mReactionTurns:int;
      
      protected var mGraphicAssets:Array;
      
      public var mSpawnItem:String;
      
      public var mSpawnTile:int;
      
      public var mLastAttackDamage:int;
      
      public var mProtectorMission:Object;
      
      public var mFiringType:String;
      
      public var mWeaponType:String;
      
      public var mSpawnSetupItem:EnemyAppearanceSetupItem;
      
      public function EnemyInstallationItem(param1:Object)
      {
         super(param1);
         this.mDamage = param1.Damage;
         this.mAttackRange = param1.AttackRange;
         this.mFiringType = param1.FiringType;
         this.mWeaponType = param1.WeaponType;
         if(!this.mFiringType)
         {
            this.mFiringType = "normal";
         }
         this.mReactionTime = param1.ReactionTime;
         this.mReactionTurns = param1.ReactionTurns;
         var _loc2_:Object = this.mSpawnItem = param1.SpawnEnemy;
         if(_loc2_)
         {
            this.mSpawnItem = _loc2_.ID;
         }
         else
         {
            this.mSpawnItem = null;
         }
         this.mSpawnTile = param1.SpawnTile;
         this.mLastAttackDamage = param1.LastAttackDamage;
         this.mProtectorMission = param1.ProtectorMission;
         if(param1.SpawnSetup)
         {
            if(param1.SpawnSetup.ID)
            {
               this.mSpawnSetupItem = ItemManager.getItemByTableName(param1.SpawnSetup.ID,"EnemyAppearanceSetup") as EnemyAppearanceSetupItem;
            }
         }
      }
      
      override public function initGraphics(param1:Object) : void
      {
         super.initGraphics(param1);
         var _loc2_:GameState = GameState.mInstance;
         this.mGraphicAssets = new Array();
         this.mGraphicAssets[0] = param1.Graphic_idle;
         this.mGraphicAssets[1] = param1.Graphic_shoot;
         this.mGraphicAssets[2] = param1.Graphic_hit;
         this.mGraphicAssets[3] = param1.Graphic_destroy;
         if(param1.Graphic_ready_for_action)
         {
            this.mGraphicAssets[4] = param1.Graphic_ready_for_action;
         }
         if(param1.Graphic_action)
         {
            this.mGraphicAssets[5] = param1.Graphic_action;
         }
         if(param1.Graphic_noaction)
         {
            this.mGraphicAssets[6] = param1.Graphic_noaction;
         }
      }
      
      public function getGraphicAssets() : Array
      {
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:Array = new Array();
         _loc2_.push(_loc1_.chooseCorrectGraphicFromArray(this.mGraphicAssets[0]));
         _loc2_.push(_loc1_.chooseCorrectGraphicFromArray(this.mGraphicAssets[1]));
         _loc2_.push(_loc1_.chooseCorrectGraphicFromArray(this.mGraphicAssets[2]));
         _loc2_.push(_loc1_.chooseCorrectGraphicFromArray(this.mGraphicAssets[3]));
         if(this.mGraphicAssets[4])
         {
            _loc2_.push(_loc1_.chooseCorrectGraphicFromArray(this.mGraphicAssets[4]));
         }
         if(this.mGraphicAssets[5])
         {
            _loc2_.push(_loc1_.chooseCorrectGraphicFromArray(this.mGraphicAssets[5]));
         }
         if(this.mGraphicAssets[6])
         {
            _loc2_.push(_loc1_.chooseCorrectGraphicFromArray(this.mGraphicAssets[6]));
         }
         return _loc2_;
      }
   }
}
