package game.gui.pvp
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import game.gui.AutoTextField;
   import game.gui.IconLoader;
   import game.net.PvPOpponent;
   
   public class PvPFighterPanel
   {
       
      
      private var mBasePanel:Sprite;
      
      private var mRankName:TextField;
      
      private var mName:TextField;
      
      private var mBadAssLevel:AutoTextField;
      
      private var mThumbnail:Sprite;
      
      private var mYourTurnClip:MovieClip;
      
      public function PvPFighterPanel(param1:Sprite, param2:PvPOpponent = null, param3:String = "Turn Changed")
      {
         var _loc6_:TextField = null;
         super();
         this.mBasePanel = param1;
         this.mRankName = param1.getChildByName("Text_Rank") as TextField;
         this.mName = param1.getChildByName("Text_Name") as TextField;
         this.mThumbnail = param1.getChildByName("Thumb") as MovieClip;
         this.mYourTurnClip = param1.getChildByName("Turn_Switch_Anm") as MovieClip;
         var _loc5_:TextField;
         var _loc4_:MovieClip;
         (_loc5_ = (_loc4_ = this.mYourTurnClip.getChildByName("Card_Turn_Switch") as MovieClip).getChildByName("Text_Turn_Owner") as TextField).text = param3;
         this.mYourTurnClip.gotoAndStop(1);
         _loc6_ = (param1.getChildByName("Rank_Icon") as MovieClip).getChildByName("Text_PvP_Rank") as TextField;
         this.mBadAssLevel = new AutoTextField(_loc6_);
         this.setData(param2);
      }
      
      public function setData(param1:PvPOpponent) : void
      {
         if(!param1)
         {
            return;
         }
         this.mName.text = param1.mName;
         this.mRankName.text = param1.getBadassName();
         this.mBadAssLevel.setText(param1.mBadassLevel.toString());
         if(param1.mPicID != null && param1.mPicID != "")
         {
            IconLoader.addIconPicture(this.mThumbnail,param1.mPicID,this.centerImage);
         }
         else
         {
            Utils.removeAllChildren(this.mThumbnail);
         }
      }
      
      private function centerImage(param1:Sprite) : void
      {
         param1.x = -param1.width / 2;
         param1.y = -param1.height / 2;
         param1.mouseEnabled = false;
         param1.mouseChildren = false;
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this.mBasePanel.visible = param1;
      }
      
      public function playYourTurnAnimation() : void
      {
         this.mYourTurnClip.gotoAndPlay(1);
         this.mYourTurnClip.addEventListener(Event.FRAME_CONSTRUCTED,this.checkFrame);
      }
      
      private function checkFrame(param1:Event) : void
      {
         if(this.mYourTurnClip.currentFrame == this.mYourTurnClip.framesLoaded)
         {
            this.mYourTurnClip.removeEventListener(Event.FRAME_CONSTRUCTED,this.checkFrame);
            this.mYourTurnClip.gotoAndStop(1);
         }
      }
   }
}
