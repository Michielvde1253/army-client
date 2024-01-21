package game.items
{
   import flash.display.MovieClip;
   import game.states.GameState;
   
   public class BuildingDriveItem extends MapItem
   {
       
      
      public var mPlantRewardXP:int;
      
      public var mRewardXP:int;
      
      public var mRewardMoney:int;
      
      public var mRewardSupplies:int;
      
      public var mRewardWater:int;
      
      public var mRewardEnergy:int;
      
      public var mHireCostPremium:int;
      
      public function BuildingDriveItem(param1:Object)
      {
         super(param1);
         this.mRewardWater = param1.RewardWater;
         this.mRewardXP = param1.RewardXP;
         this.mRewardMoney = param1.RewardMoney;
         this.mRewardSupplies = param1.RewardSupplies;
         this.mRewardEnergy = param1.RewardEnergy;
         this.mPlantRewardXP = param1.PlantRewardXP;
         this.mHireCostPremium = param1.HireCostPremium;
      }
      
      override public function getDescription() : String
      {
         return GameState.replaceParameters(this.mDescription,[this.mRewardWater]);
      }
      
      override public function getIconMovieClip() : MovieClip
      {
         var _loc1_:MovieClip = super.getIconMovieClip();
         if(_loc1_)
         {
            _loc1_.gotoAndStop(2);
         }
         return _loc1_;
      }
   }
}
