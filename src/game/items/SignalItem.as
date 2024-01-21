package game.items
{
   import game.states.GameState;
   import game.utils.TimeUtils;
   
   public class SignalItem extends DecorationItem
   {
       
      
      public var mBurnTimeInMinutes:int;
      
      public var mTooltipDescription:String;
      
      public function SignalItem(param1:Object)
      {
         super(param1);
         this.mBurnTimeInMinutes = param1.DurationMinutes;
         this.mTooltipDescription = param1.TooltipDescription;
      }
      
      override public function getDescription() : String
      {
         return GameState.replaceParameters(mDescription,[TimeUtils.secondsToString(this.mBurnTimeInMinutes * 60,2,true)]);
      }
   }
}
