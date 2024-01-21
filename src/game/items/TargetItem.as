package game.items
{
   import game.magicBox.MagicBoxTracker;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class TargetItem extends MapItem
   {
       
      
      public var mHitRewardXP:int;
      
      public var mHitRewardMoney:int;
      
      public var mHitRewardSupplies:int;
      
      public var mHitRewardEnergy:int;
      
      public var mHitRewardMaterial:int;
      
      public var mKillRewardXP:int;
      
      public var mKillRewardMoney:int;
      
      public var mKillRewardSupplies:int;
      
      public var mKillRewardEnergy:int;
      
      public var mKillRewardMaterial:int;
      
      public var mKillRewardUnit:Object;
      
      private var mCollectibleItems:Array;
      
      private var mCollectibleLevels:Array;
      
      private var mCollectibleProbabilities:Array;
      
      private var mRandom:RandomGenerator;
      
      public function TargetItem(param1:Object)
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         this.mRandom = new RandomGenerator();
         super(param1);
         this.mHitRewardXP = param1.HitRewardXP;
         this.mHitRewardMoney = param1.HitRewardMoney;
         this.mHitRewardSupplies = param1.HitRewardSupplies;
         this.mHitRewardMaterial = param1.HitRewardMaterial;
         this.mHitRewardEnergy = param1.HitRewardEnergy;
         this.mKillRewardXP = param1.KillRewardXP;
         this.mKillRewardMoney = param1.KillRewardMoney;
         this.mKillRewardSupplies = param1.KillRewardSupplies;
         this.mKillRewardMaterial = param1.HitRewardMaterial;
         this.mKillRewardEnergy = param1.KillRewardEnergy;
         this.mKillRewardUnit = param1.KillRewardUnit;
         if(param1.Item0 != null)
         {
            this.mCollectibleItems = new Array();
            this.mCollectibleLevels = new Array();
            this.mCollectibleProbabilities = new Array();
            _loc2_ = 0;
            while(_loc2_ < 15)
            {
               _loc3_ = param1["Item" + _loc2_];
               _loc4_ = param1["OccurItem" + _loc2_];
               if(_loc3_ != null)
               {
                  this.mCollectibleItems.push(_loc3_);
                  if(_loc4_ is Array)
                  {
                     _loc5_ = _loc4_ as Array;
                  }
                  else
                  {
                     (_loc5_ = new Array()).push(_loc4_);
                  }
                  this.mCollectibleLevels[_loc2_] = new Array();
                  this.mCollectibleProbabilities[_loc2_] = new Array();
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_.length)
                  {
                     _loc8_ = (_loc7_ = String(_loc5_[_loc6_])).split(":");
                     _loc9_ = JsonParser.trim(_loc8_[0] as String);
                     _loc10_ = parseInt(_loc9_.slice(_loc9_.indexOf("L") + 1));
                     (this.mCollectibleLevels[_loc2_] as Array).push(_loc10_);
                     _loc9_ = JsonParser.trim(_loc8_[1] as String);
                     _loc11_ = parseInt(_loc9_.slice(0,_loc9_.indexOf("%")));
                     (this.mCollectibleProbabilities[_loc2_] as Array).push(_loc11_);
                     _loc6_++;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function getRandomItemDrop() : Item
      {
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         if(this.mCollectibleItems == null)
         {
            return null;
         }
         var _loc1_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         var _loc2_:int = _loc1_.mLevel;
         var _loc3_:int = this.mRandom.d100(_loc1_.mRewardDropSeedTerm,_loc1_.getRewardDropsCounter());
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this.mCollectibleItems.length)
         {
            _loc6_ = this.getItemProbabilityForLevel(_loc5_,_loc2_);
            _loc4_ += _loc6_;
            if(_loc3_ < _loc4_)
            {
               _loc7_ = this.mCollectibleItems[_loc5_];
               MagicBoxTracker.generateEvent(MagicBoxTracker.GROUP_ECONOMY,MagicBoxTracker.TYPE_GAIN_ITEM,MagicBoxTracker.PS_RANDOM_ITEM + "_" + _loc7_.ID,MagicBoxTracker.paramsObj(_loc7_.Type,_loc7_.ID));
               return ItemManager.getItem(_loc7_.ID,_loc7_.Type);
            }
            _loc5_++;
         }
         return null;
      }
      
      private function getItemProbabilityForLevel(param1:int, param2:int) : int
      {
         var _loc3_:Array = this.mCollectibleLevels[param1];
         var _loc4_:int = int(_loc3_.length - 1);
         while(_loc4_ >= 0)
         {
            if(param2 >= _loc3_[_loc4_])
            {
               return this.mCollectibleProbabilities[param1][_loc4_];
            }
            _loc4_--;
         }
         return 0;
      }
   }
}
