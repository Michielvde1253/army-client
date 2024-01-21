package game.items
{
   import flash.display.MovieClip;
   import game.states.GameState;
   
   public class PlayerUnitItem extends RepairableItem
   {
       
      
      public var mDamage:int;
      
      public var mAttackRange:int;
      
      public var mMovementRange:int;
      
      public var mPVPMovementRange:int;
      
      public var mMaxHealTime:int;
      
      public var mMovementRewardXP:int;
      
      public var mMovementRewardEnergy:int;
      
      public var mPickupCostSupplies:int;
      
      public var mProjectileClassStr:String;
      
      public var mMovementType:String;
      
      public var mWeaponType:String;
      
      public var mPassableGroups:Array;
      
      public var mPvPCostSupplies:int;
      
      public var mGraphicsArray:Array;
      
      public function PlayerUnitItem(param1:Object)
      {
         super(param1);
         this.mProjectileClassStr = param1.ProjectileClass;
         this.mDamage = param1.Damage;
         this.mAttackRange = param1.AttackRange;
         this.mMovementRange = param1.MovementRange;
         this.mPVPMovementRange = param1.PvpMovementRange;
         this.mMaxHealTime = param1.MaxHealTime;
         this.mMovementRewardXP = param1.MovementRewardXP;
         this.mMovementRewardEnergy = param1.MovementRewardEnergy;
         this.mPickupCostSupplies = param1.PickupCostSupplies;
         this.mMovementType = param1.MovementType;
         this.mWeaponType = param1.WeaponType;
         this.mPvPCostSupplies = param1.PvPCostSupplies;
         if(param1.PassableGroups is Array)
         {
            this.mPassableGroups = param1.PassableGroups;
         }
         else
         {
            this.mPassableGroups = new Array();
            this.mPassableGroups.push(param1.PassableGroups);
         }
         this.mGraphicsArray = new Array();
         this.mGraphicsArray.push(param1.Graphic_idle);
         this.mGraphicsArray.push(param1.Graphic_move);
         this.mGraphicsArray.push(param1.Graphic_aim);
         this.mGraphicsArray.push(param1.Graphic_shoot);
         this.mGraphicsArray.push(param1.Graphic_hit);
         this.mGraphicsArray.push(param1.Graphic_die);
         this.mGraphicsArray.push(param1.Graphic_aim_up);
         this.mGraphicsArray.push(param1.Graphic_shoot_up);
         this.mGraphicsArray.push(param1.Graphic_move_up);
         this.mGraphicsArray.push(param1.Graphic_idle);
         this.mGraphicsArray.push(param1.Graphic_explosion);
      }
      
      override public function initGraphics(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.initGraphics(param1);
         if(param1.IconGraphics)
         {
            mIconGraphics = new Array();
            mIconGraphicsFile = new Array();
            if(param1.IconGraphics is Array)
            {
               _loc3_ = 0;
               while(_loc3_ < param1.IconGraphics.length)
               {
                  _loc2_ = (param1.IconGraphics[_loc3_] as String).lastIndexOf("/");
                  mIconGraphics[_loc3_] = (param1.IconGraphics[_loc3_] as String).substring(_loc2_ + 1);
                  mIconGraphicsFile[_loc3_] = (param1.IconGraphics[_loc3_] as String).substring(0,_loc2_);
                  _loc3_++;
               }
            }
            else
            {
               _loc2_ = int(param1.IconGraphics.lastIndexOf("/"));
               mIconGraphics[0] = param1.IconGraphics.substring(_loc2_ + 1);
               mIconGraphicsFile[0] = param1.IconGraphics.substring(0,_loc2_);
            }
         }
      }
      
      override public function getIconMovieClip() : MovieClip
      {
         var _loc2_:MovieClip = null;
         var _loc1_:MovieClip = super.getIconMovieClip();
         if(_loc1_)
         {
            _loc2_ = _loc1_.getChildByName("Hint_Health_Friendly") as MovieClip;
            if(_loc2_)
            {
               _loc2_.visible = false;
            }
            _loc2_ = _loc1_.getChildByName("Hint_Health_Friendly_Attention") as MovieClip;
            if(_loc2_)
            {
               _loc2_.visible = false;
            }
         }
         return _loc1_;
      }
      
      override public function capAvailable() : Boolean
      {
         return GameState.mInstance.mPlayerProfile.capAvailable(mType);
      }
      
      public function getDefaultActorPriority() : Number
      {
         var _loc1_:Number = this.mDamage * 3 + this.mAttackRange + mHealth * 0.5;
         _loc1_ /= 20;
         return Math.min(1,_loc1_);
      }
   }
}
