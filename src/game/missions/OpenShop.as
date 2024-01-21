package game.missions
{
   import game.gui.ShopDialog;
   import game.items.ItemManager;
   import game.states.GameState;
   
   public class OpenShop extends Objective
   {
       
      
      public function OpenShop(param1:Object)
      {
         super(param1);
      }
      
      override public function initialize(param1:String, param2:Object) : void
      {
         if(param2)
         {
            mGoal = param2.goal - param2.startValue;
            mCounter = Math.min(param2.counterValue - param2.startValue,mGoal);
            mPurchased = param2.purchased as Boolean;
         }
         else
         {
            mCounter = 0;
         }
         if(param1 == Mission.TYPE_MODAL_ARROW)
         {
            GameState.mInstance.mHUD.setShopButtonHighlight();
            GameState.mInstance.mScene.disableMouse(-1,-1);
            ShopDialog.mTutorialItem = ItemManager.getItem(mParameter.ID,mParameter.Type);
         }
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         if(isDone())
         {
            return false;
         }
         if(mParameter == null || mParameter.ID == param1)
         {
            mCounter += param2;
            mCounter = Math.min(mCounter,mGoal);
            return true;
         }
         return false;
      }
      
      override public function clean() : void
      {
         GameState.mInstance.mHUD.removeTutorialHighlight();
         GameState.mInstance.mScene.enableMouse();
         ShopDialog.mTutorialItem = null;
      }
   }
}
