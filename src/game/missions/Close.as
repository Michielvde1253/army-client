package game.missions
{
   import game.gui.DCWindow;
   
   public class Close extends Objective
   {
       
      
      private var mPopup:DCWindow;
      
      public function Close(param1:Object)
      {
         super(param1);
      }
      
      public function setPopup(param1:DCWindow) : void
      {
         this.mPopup = param1;
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         if(isDone())
         {
            return false;
         }
         if(param1 == this.mPopup)
         {
            mCounter += param2;
            mCounter = Math.min(mCounter,mGoal);
            return true;
         }
         return false;
      }
   }
}
