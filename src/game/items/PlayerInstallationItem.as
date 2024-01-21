package game.items
{
   import game.states.GameState;
   
   public class PlayerInstallationItem extends RepairableItem
   {
       
      
      public var mPlantRewardXP:int;
      
      public var mDamage:int;
      
      public var mAttackRange:int;
      
      private var mGraphicAssets:Array;
      
      public function PlayerInstallationItem(param1:Object)
      {
         super(param1);
         mName = param1.Name;
         this.mPlantRewardXP = param1.PlantRewardXP;
         this.mDamage = param1.Damage;
         this.mAttackRange = param1.AttackRange;
      }
      
      override public function initGraphics(param1:Object) : void
      {
         super.initGraphics(param1);
         var _loc2_:GameState = GameState.mInstance;
         this.mGraphicAssets = new Array();
         this.mGraphicAssets[0] = param1.Graphic_idle;
         this.mGraphicAssets[1] = param1.Graphic_shoot;
         this.mGraphicAssets[2] = param1.Graphic_hit;
         this.mGraphicAssets[3] = param1.Graphic_die;
      }
      
      public function getGraphicAssets() : Array
      {
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:Array = new Array();
         _loc2_.push(_loc1_.chooseCorrectGraphicFromArray(this.mGraphicAssets[0]));
         _loc2_.push(_loc1_.chooseCorrectGraphicFromArray(this.mGraphicAssets[1]));
         _loc2_.push(_loc1_.chooseCorrectGraphicFromArray(this.mGraphicAssets[2]));
         _loc2_.push(_loc1_.chooseCorrectGraphicFromArray(this.mGraphicAssets[3]));
         return _loc2_;
      }
   }
}
