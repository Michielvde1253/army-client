package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import game.gui.AutoTextField;
   import game.gui.DisplayObjectTransition;
   import game.missions.Mission;
   
   public class ToasterWindow extends PopUpWindow
   {
       
      
      private var mMission:Mission;
      
      private var mTimer:Timer;
      
      public function ToasterWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_START_NAME,"popup_toaster_tip");
         super(new _loc1_());
         mClip.mouseEnabled = false;
         mClip.mouseChildren = false;
         this.mouseEnabled = false;
         this.mouseChildren = false;
         mOpenTransitionName = DisplayObjectTransition.ATTENTION_UP;
      }
      
      public function Activate(param1:Function, param2:Mission) : void
      {
         this.mMission = param2;
         var _loc3_:AutoTextField = new AutoTextField(mClip.getChildByName("Text_Title") as TextField);
         _loc3_.setText(param2.mTitle);
         var _loc4_:AutoTextField;
         (_loc4_ = new AutoTextField(mClip.getChildByName("Text_Description") as TextField)).setText(param2.mDescription);
         doOpeningTransition();
         this.mTimer = new Timer(4000);
         this.mTimer.addEventListener(TimerEvent.TIMER,this.drawAttention,false);
         this.mTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.removeListener,false);
         this.mTimer.start();
         setPos(x,Config.SCREEN_HEIGHT * 3 / 4);
      }
      
      private function drawAttention(param1:TimerEvent) : void
      {
         new DisplayObjectTransition(DisplayObjectTransition.ATTENTION_UP,this,DisplayObjectTransition.TYPE_NORMAL);
      }
      
      private function removeListener(param1:TimerEvent) : void
      {
         if(this.mTimer)
         {
            this.mTimer.stop();
            this.mTimer.removeEventListener(TimerEvent.TIMER,this.drawAttention);
            this.mTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.removeListener);
            this.mTimer = null;
         }
      }
      
      override public function close() : void
      {
         this.removeListener(null);
         super.close();
      }
   }
}
