package game.items
{
   public class EnemyUnitItem extends TargetItem
   {
       
      
      public var mProjectileClassStr:String;
      
      public var mDamage:int;
      
      public var mAttackRange:int;
      
      public var mMovementRange:int;
      
      public var mMaxHealTime:int;
      
      public var mReactionTime:int;
      
      public var mGraphicsArray:Array;
      
      public var mCloudShadow:String;
      
      public var mMovementType:String;
      
      public var mWeaponType:String;
      
      public var mPassableGroups:Array;
      
      public var mPermanentDestroyArray:Array;
      
      public var mWinRewardMoney:int;
      
      public var mWinRewardBadass:int;
      
      public var mHitRewardBadassXP:int;
      
      public var mKillRewardBadassXP:int;
      
      public function EnemyUnitItem(param1:Object)
      {
         super(param1);
         this.mProjectileClassStr = param1.ProjectileClass;
         this.mDamage = param1.Damage;
         this.mAttackRange = param1.AttackRange;
         this.mMovementRange = param1.MovementRange;
         this.mMaxHealTime = param1.MaxHealTime;
         this.mReactionTime = param1.ReactionTime;
         this.mCloudShadow = param1.CloudShadow;
         this.mMovementType = param1.MovementType;
         this.mWeaponType = param1.WeaponType;
         this.mWinRewardMoney = param1.WinRewardMoney;
         this.mWinRewardBadass = param1.WinRewardBadAss;
         this.mHitRewardBadassXP = param1.HitRewardBadAss;
         this.mKillRewardBadassXP = param1.KillRewardBadAss;
         this.mPermanentDestroyArray = null;
         if(param1.PermanentDestroyArray)
         {
            if(param1.PermanentDestroyArray is Array)
            {
               this.mPermanentDestroyArray = param1.PermanentDestroyArray;
            }
            else
            {
               this.mPermanentDestroyArray = new Array();
               this.mPermanentDestroyArray.push(param1.PermanentDestroyArray);
            }
         }
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
         this.mGraphicsArray.push(param1.Graphic_air_drop);
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
      
      public function getDefaultActorPriority() : Number
      {
         var _loc1_:Number = this.mDamage * 3 + this.mAttackRange + mHealth * 0.5;
         _loc1_ /= 20;
         return Math.min(1,_loc1_);
      }
   }
}
