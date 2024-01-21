package game.items
{
   import game.states.GameState;
   
   public class DecorationItem extends RepairableItem
   {
       
      
      private var mPlantRewardXP:int;
      
      public var mSuppliesCapIncrement:int;
      
      public var mLeaveRuins:Boolean;
      
      public function DecorationItem(param1:Object)
      {
         super(param1);
         this.mPlantRewardXP = param1.PlantRewardXP;
         this.mSuppliesCapIncrement = param1.SuppliesCapIncrement;
         this.mLeaveRuins = param1.LostWhenDestroyed == 0;
      }
      
      override public function getDescription() : String
      {
         if(this.mSuppliesCapIncrement != 0)
         {
            return GameState.replaceParameters(mDescription,[this.mSuppliesCapIncrement]);
         }
         return mDescription;
      }
   }
}
