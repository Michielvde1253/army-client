package game.items
{
   public class PowerUpItem extends MapItem
   {
       
      
      public var mPowerUpUnit:PlayerUnitItem;
      
      public var mPowerUpItem:Item;
      
      public var mPowerUpFireMissionItem:FireMissionItem;
      
      public var mIncreasedHealth:int = 0;
      
      public var mIncreasedActions:int = 0;
      
      public function PowerUpItem(param1:Object)
      {
         super(param1);
         this.mPowerUpUnit = null;
         if(param1.Item)
         {
            this.mPowerUpItem = ItemManager.getItem(param1.Item.ID,param1.Item.Type);
         }
         if(param1.FireMission)
         {
            this.mPowerUpFireMissionItem = ItemManager.getItem(param1.FireMission.ID,param1.FireMission.Type) as FireMissionItem;
         }
         this.mIncreasedHealth = param1.IncreasedHealth;
         this.mIncreasedActions = param1.IncreasedActions;
         mWalkable = true;
      }
   }
}
