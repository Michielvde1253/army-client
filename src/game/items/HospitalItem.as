package game.items
{
   import flash.display.MovieClip;
   import game.states.GameState;
   
   public class HospitalItem extends RepairableItem
   {
	   
	  public var mCooldown:int;
	   
	  public var mHealPower:int;
	   
	  public var mAttackRange:int; // Called AttackRange because then MapGUIEffectsLayer will show the range
	   
	  public var mPower:int = 1; // Fake the power so that MapGUIEffectsLayer thinks it can do damage lol
	   
	  public var mReadyText:String;
	   
	  public var mNotReadyText:String;
      
      public function HospitalItem(param1:Object)
      {
         super(param1);
         mCooldown = param1.CooldownTime;
		 mHealPower = param1.HealPower;
		 mAttackRange = param1.AttackRange;
		 mReadyText = param1.DescriptionReady;
		 mNotReadyText = param1.DescriptionNotReady;
		 
      }
   }
}
