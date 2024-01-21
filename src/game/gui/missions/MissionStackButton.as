package game.gui.missions
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.text.TextField;
   import game.gui.button.ArmyButton;
   
   public class MissionStackButton extends ArmyButton
   {
       
      
      private var buttonText:String;
      
      public function MissionStackButton(param1:DisplayObjectContainer, param2:MovieClip, param3:int, param4:String = null, param5:EventDispatcher = null, param6:Function = null, param7:Function = null, param8:Function = null, param9:Function = null, param10:Function = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      override public function setText(param1:String, param2:String = "Header") : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         super.setText(param1);
         if(param1 != null)
         {
            if(param1 != "")
            {
               _loc3_ = mButton.getChildByName("Mission_Stack_Hint") as MovieClip;
               if((_loc4_ = _loc3_.getChildByName("Text_Value") as TextField) != null)
               {
                  _loc4_.text = param1;
               }
            }
         }
         this.buttonText = param1;
      }
   }
}
