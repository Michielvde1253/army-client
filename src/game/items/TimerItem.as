package game.items
{
   public class TimerItem extends Item
   {
       
      
      public var mDuration:int;
      
      public var mProbability:int;
      
      public function TimerItem(param1:Object)
      {
         super(param1);
         this.mDuration = param1.Time;
         this.mProbability = param1.Probability;
      }
   }
}
