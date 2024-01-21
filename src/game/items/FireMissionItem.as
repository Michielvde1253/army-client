package game.items
{
   public class FireMissionItem extends MapItem
   {
       
      
      public var mDamage:int;
      
      public var mRechargeTimeMin:int;
      
      public var mRequiredItemSet:FireMissionItemSetItem;
      
      public var mRequiredRank:int;
      
      public var mCursorOffset:int;
      
      public var mFireMissionIcon:String;
      
      public var mUnlockCost:int;
      
      public var mOrder:int;
      
      public var mlaunchWithGold:Boolean;
      
      public function FireMissionItem(param1:Object)
      {
         super(param1);
         this.mDamage = param1.Damage;
         this.mRechargeTimeMin = param1.RechargeTime;
         this.mRequiredRank = param1.RequiredRank;
         this.mCursorOffset = param1.Cursor;
         this.mOrder = param1.Order;
         this.mUnlockCost = param1.CostUnlock;
         this.mRequiredItemSet = new FireMissionItemSetItem(param1.RequiredCollection);
         this.mRequiredItemSet.initGraphics(param1.RequiredCollection);
         this.mlaunchWithGold = false;
      }
      
      override public function initGraphics(param1:Object) : void
      {
         super.initGraphics(param1);
         if(param1.Graphics)
         {
            if(!mIconGraphics)
            {
               mIconGraphics = new Array();
               mIconGraphicsFile = new Array();
            }
            mIconGraphics[0] = param1.Graphics as String;
            mIconGraphicsFile[0] = Config.SWF_EFFECTS_NAME;
         }
         if(param1.IconGraphics)
         {
            this.mFireMissionIcon = param1.IconGraphics as String;
         }
      }
   }
}
