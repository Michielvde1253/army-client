package game.items
{
   public class ConstructionItem extends RepairableItem
   {
       
      
      public var mIngredientRequiredTypes:Array;
      
      public var mIngredientRequiredAmounts:Array;
      
      public var mBuildSteps:int;
      
      public var mMaterialPerStep:int;
      
      public var mRewardXPPerStep:int;
      
      public var mUnitCapIncrements:Object;
      
      public var mRewardXP:int;
      
      public var mRewardMoney:int;
      
      public var mRewardSupplies:int;
      
      public var mRewardMaterial:int;
      
      public var mRewardEnergy:int;
      
      public var mConstructionAsset:String;
      
      public function ConstructionItem(param1:Object)
      {
         var _loc2_:Object = null;
         super(param1);
         this.mBuildSteps = param1.BuildSteps;
         this.mMaterialPerStep = param1.MaterialPerStep;
         this.mRewardXPPerStep = param1.XPPerStep;
         this.mUnitCapIncrements = new Object();
         this.mUnitCapIncrements.Infantry = int(param1.UnitCapIncrementInfantry);
         this.mUnitCapIncrements.Armor = int(param1.UnitCapIncrementArmor);
         this.mUnitCapIncrements.Artilery = int(param1.UnitCapIncrementArtillery);
         this.mIngredientRequiredTypes = new Array();
         this.mIngredientRequiredAmounts = new Array();
         this.mRewardXP = param1.RewardXP;
         this.mRewardMoney = param1.RewardMoney;
         this.mRewardSupplies = param1.RewardSupplies;
         this.mRewardMaterial = param1.RewardMaterial;
         this.mRewardEnergy = param1.RewardEnergy;
         for each(_loc2_ in param1.Ingredients)
         {
            this.mIngredientRequiredTypes.push(_loc2_.Type);
            this.mIngredientRequiredAmounts.push(_loc2_.Amount);
         }
         this.mConstructionAsset = param1.ConstructionSiteGraphics;
      }
   }
}
