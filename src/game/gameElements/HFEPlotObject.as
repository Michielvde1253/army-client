package game.gameElements
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.isometric.IsometricScene;
   import game.items.MapItem;
   import game.states.GameState;
   import game.utils.EffectController;
   
   public class HFEPlotObject extends PlayerBuildingObject
   {
       
      
      public function HFEPlotObject(param1:int, param2:IsometricScene, param3:MapItem, param4:Point, param5:DisplayObject = null, param6:String = null)
      {
         super(param1,param2,param3,param4,param5,param6);
      }
      
      override public function setHealth(param1:int) : void
      {
         mHealth = Math.max(0,Math.min(mMaxHealth,param1));
         if(mHealth == 0)
         {
            remove();
            mScene.addEffect(null,EffectController.EFFECT_TYPE_BIG_EXPLOSION,mX,mY);
         }
      }
      
      override protected function getStateText() : String
      {
         var _loc1_:String = null;
         switch(mState)
         {
            case STATE_IDLE:
               if(GameState.mInstance.mVisitingFriend)
               {
                  return GameState.getText("BUILDING_STATUS_IDLE_HFE_PLOT_VISITING");
               }
               return GameState.getText("BUILDING_STATUS_IDLE_HFE_PLOT");
               break;
            default:
               return super.getStateText();
         }
      }
      
      override public function MousePressed(param1:MouseEvent) : void
      {
         GameState.mInstance.mHUD.openProductionDialog(this);
      }
   }
}
