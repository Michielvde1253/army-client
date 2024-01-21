package game.items
{
   public class RepairableItem extends MapItem
   {
       
      
      public var mHealCostEnergy:int;
      
      public var mHealCostSupplies:int;
      
      public var mReviveCostSupplies:int;
      
      public var mHealRewardMoney:int;
      
      public var mHealRewardXP:int;
      
      public var mHealRewardEnergy:int;
      
      public function RepairableItem(param1:Object)
      {
         super(param1);
         this.mHealCostEnergy = param1.HealCostEnergy;
         this.mHealCostSupplies = param1.HealCostSupplies;
         this.mReviveCostSupplies = param1.ReviveCostSupplies;
         this.mHealRewardMoney = param1.HealRewardMoney;
         this.mHealRewardXP = param1.HealRewardXP;
         this.mHealRewardEnergy = param1.HealRewardEnergy;
      }
   }
}
