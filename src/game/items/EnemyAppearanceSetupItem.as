package game.items
{
   public class EnemyAppearanceSetupItem extends Item
   {
       
      
      public var mActivationTime:int;
      
      public var mProbability:int;
      
      public var mNumberOfUnits:int;
      
      public var mEnemyUnits:Array;
      
      public var mEnemyUnitsP:Array;
      
      public function EnemyAppearanceSetupItem(param1:Object)
      {
         super(param1);
         this.mActivationTime = param1.ActivationTime;
         this.mProbability = param1.Probability;
         this.mNumberOfUnits = param1.NumberOfUnits;
         if(param1.EnemyUnits is Array)
         {
            this.mEnemyUnits = param1.EnemyUnits;
         }
         else
         {
            this.mEnemyUnits = [param1.EnemyUnits];
         }
         if(param1.EnemyUnitsP is Array)
         {
            this.mEnemyUnitsP = param1.EnemyUnitsP;
         }
         else
         {
            this.mEnemyUnitsP = [param1.EnemyUnitsP];
         }
      }
   }
}
