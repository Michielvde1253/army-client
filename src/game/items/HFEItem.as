package game.items
{
   import flash.display.MovieClip;
   import game.states.GameState;
   
   public class HFEItem extends MapItem
   {
       
      
      public var mPlantRewardXP:int;
      
      public var mHarvestAnimation:String;
      
      public var mRewardXP:int;
      
      public var mRewardMoney:int;
      
      public var mRewardSupplies:int;
      
      public var mRewardMaterial:int;
      
      public var mRewardEnergy:int;
      
      public function HFEItem(param1:Object)
      {
         super(param1);
         this.mPlantRewardXP = param1.PlantRewardXP;
         this.mRewardXP = param1.RewardXP;
         this.mRewardMoney = param1.RewardMoney;
         this.mRewardSupplies = param1.RewardSupplies;
         this.mRewardMaterial = param1.RewardMaterial;
         this.mRewardEnergy = param1.RewardEnergy;
         this.mHarvestAnimation = param1.HarvestAnimation;
      }
      
      override public function getDescription() : String
      {
         return GameState.replaceParameters(this.mDescription,[this.mRewardSupplies]);
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
