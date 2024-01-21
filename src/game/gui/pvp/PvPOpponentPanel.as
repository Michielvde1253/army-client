package game.gui.pvp
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.IconLoader;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.gui.popups.PopUpWindow;
   import game.net.PvPOpponent;
   import game.states.GameState;
   
   public class PvPOpponentPanel
   {
       
      
      public var mBasePanel:MovieClip;
      
      private var mDialog:PopUpWindow;
      
      private var mButtonRemove:ArmyButton;
      
      private var mButtonAttack:ResizingButton;
      
      private var mOpponent:PvPOpponent;
      
      public function PvPOpponentPanel(param1:MovieClip, param2:PopUpWindow)
      {
         var _loc3_:TextField = null;
         super();
         this.mBasePanel = param1;
         this.mDialog = param2;
         _loc3_ = this.mBasePanel.getChildByName("Text_Description") as TextField;
         _loc3_.text = GameState.getText("PVP_ATTACKED_BY");
         _loc3_ = this.mBasePanel.getChildByName("Text_Description") as TextField;
         _loc3_.visible = false;
         _loc3_ = this.mBasePanel.getChildByName("Text_Description_Wins") as TextField;
         _loc3_.text = GameState.getText("PVP_WINS");
         _loc3_ = this.mBasePanel.getChildByName("Text_Description_Remove") as TextField;
         _loc3_.visible = false;
         this.mButtonRemove = Utils.createBasicButton(this.mBasePanel,"Button_Remove",this.removeClicked);
         this.mButtonAttack = Utils.createResizingIconButton(this.mBasePanel,"Button_Attack",this.attackClicked);
      }
      
      public function hide() : void
      {
         if(this.mBasePanel.parent)
         {
            this.mBasePanel.parent.removeChild(this.mBasePanel);
         }
      }
      
      public function show() : void
      {
         this.mDialog.addChild(this.mBasePanel);
      }
      
      public function setData(param1:PvPOpponent, param2:Boolean) : void
      {
         var _loc3_:TextField = null;
         this.mOpponent = param1;
         _loc3_ = this.mBasePanel.getChildByName("Text_Name") as TextField;
         _loc3_.text = param1.mName;
         var _loc4_:MovieClip;
         _loc3_ = (_loc4_ = this.mBasePanel.getChildByName("Rank_Icon") as MovieClip).getChildByName("Text_PvP_Rank") as TextField;
         _loc3_.text = param1.mBadassLevel.toString();
         _loc3_ = this.mBasePanel.getChildByName("Text_Wins") as TextField;
         _loc3_.text = param1.mPvPWins.toString();
         _loc3_ = this.mBasePanel.getChildByName("Text_PvP_Rank") as TextField;
         _loc3_.text = param1.getBadassName();
         if(param2)
         {
            this.mButtonAttack.setText(GameState.getText("PVP_REVENGE"));
         }
         else
         {
            this.mButtonAttack.setText(GameState.getText("PVP_ATTACK"));
         }
         var _loc5_:Sprite = this.mBasePanel.getChildByName("Thumb") as Sprite;
         if(param1 && param1.mPicID != null && param1.mPicID != "")
         {
            IconLoader.addIconPicture(_loc5_,param1.mPicID);
         }
         this.mButtonRemove.setVisible(false);
      }
      
      private function removeClicked(param1:MouseEvent) : void
      {
      }
      
      private function attackClicked(param1:MouseEvent) : void
      {
         (this.mDialog as PvPMatchUpDialog).attackPlayer(this.mOpponent);
      }
   }
}
