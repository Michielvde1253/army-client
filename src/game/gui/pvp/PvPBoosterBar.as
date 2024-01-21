package game.gui.pvp
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.AutoTextField;
   import game.gui.IconLoader;
   import game.gui.button.ArmyButton;
   import game.items.ShopItem;
   import game.states.GameState;
   
   public class PvPBoosterBar
   {
      
      private static const PANEL_COUNT:int = 5;
       
      
      private var mBasePanel:MovieClip;
      
      private var mButtonLeft:ArmyButton;
      
      private var mButtonRight:ArmyButton;
      
      private var mButtonLeftFull:ArmyButton;
      
      private var mButtonRightFull:ArmyButton;
      
      private var mCursorPos:int = 0;
      
      private var mBoosterButtons:Array;
      
      private var mBoosterFrames:Array;
      
      private var mBoosterInventory:Array;
      
      private var mIconSize:int = 20;
      
      private var mCancelActionButton:ArmyButton;
      
      public function PvPBoosterBar(param1:MovieClip)
      {
         var _loc4_:MovieClip = null;
         var _loc5_:ArmyButton = null;
         this.mBoosterButtons = new Array();
         this.mBoosterFrames = new Array();
         super();
         this.mBasePanel = param1;
         this.mCancelActionButton = Utils.createBasicButton(this.mBasePanel,"Button_Cancel",this.cancelPressed);
         var _loc2_:AutoTextField = new AutoTextField(this.mBasePanel.getChildByName("Text_Cancel_Action") as TextField);
         _loc2_.setText(GameState.getText("PVP_CANCEL_ACTION"));
         this.initScrollButtons();
         var _loc3_:int = 0;
         while(_loc3_ < PANEL_COUNT)
         {
            _loc4_ = this.mBasePanel.getChildByName("Powerup_0" + (_loc3_ + 1)) as MovieClip;
            (_loc5_ = Utils.createBasicButton(_loc4_,"Button_Use",this.usePressed)).setText(GameState.getText("PVP_USE"),"Text_Title");
            _loc5_.setEnabled(false);
            this.mBoosterButtons.push(_loc5_);
            this.mBoosterFrames.push(_loc4_.getChildAt(1) as MovieClip);
            _loc3_++;
         }
         this.mIconSize = (this.mBoosterFrames[0] as MovieClip).width;
         this.addToScreen();
         this.updateArrowStates();
      }
      
      private function initScrollButtons() : void
      {
         this.mButtonLeft = Utils.createBasicButton(this.mBasePanel,"Button_Previous",this.leftPressed);
         this.mButtonLeftFull = Utils.createBasicButton(this.mBasePanel,"Button_First",this.leftPressedFull);
         this.mButtonRight = Utils.createBasicButton(this.mBasePanel,"Button_Next",this.rightPressed);
         this.mButtonRightFull = Utils.createBasicButton(this.mBasePanel,"Button_Last",this.rightPressedFull);
      }
      
      private function usePressed(param1:MouseEvent) : void
      {
         var _loc2_:int = this.mCursorPos - Math.max(0,PANEL_COUNT - this.mBoosterInventory.length / 2);
         var _loc3_:int = 0;
         while(_loc3_ < PANEL_COUNT)
         {
            if(param1.target == (this.mBoosterButtons[_loc3_] as ArmyButton).getMovieClip())
            {
               if(_loc2_ >= 0 && _loc2_ < this.mBoosterInventory.length / 2)
               {
                  GameState.mInstance.mPvPMatch.mActivatedBooster = this.mBoosterInventory[_loc2_ * 2];
               }
            }
            _loc2_++;
            _loc3_++;
         }
         this.addToScreen();
      }
      
      private function cancelPressed(param1:MouseEvent) : void
      {
      }
      
      private function leftPressed(param1:MouseEvent) : void
      {
         this.mCursorPos = Math.max(this.mCursorPos - 1,0);
         this.addToScreen();
         this.updateArrowStates();
      }
      
      private function leftPressedFull(param1:MouseEvent) : void
      {
         this.mCursorPos = 0;
         this.addToScreen();
         this.updateArrowStates();
      }
      
      private function rightPressed(param1:MouseEvent) : void
      {
         this.mCursorPos = Math.min(this.mCursorPos + 1,Math.max(0,this.mBoosterInventory.length / 2 - PANEL_COUNT));
         this.addToScreen();
         this.updateArrowStates();
      }
      
      private function rightPressedFull(param1:MouseEvent) : void
      {
         this.mCursorPos = Math.max(0,this.mBoosterInventory.length / 2 - PANEL_COUNT);
         this.addToScreen();
         this.updateArrowStates();
      }
      
      private function updateArrowStates() : void
      {
         var _loc1_:* = this.mCursorPos > 0;
         var _loc2_:* = this.mCursorPos < Math.max(0,this.mBoosterInventory.length / 2 - PANEL_COUNT);
         this.mButtonLeft.setEnabled(_loc1_);
         this.mButtonLeftFull.setEnabled(_loc1_);
         this.mButtonRight.setEnabled(_loc2_);
         this.mButtonRightFull.setEnabled(_loc2_);
      }
      
      public function addToScreen() : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:ArmyButton = null;
         var _loc5_:ShopItem = null;
         this.mBoosterInventory = GameState.mInstance.mPlayerProfile.mInventory.getBoosters();
         var _loc1_:int = this.mCursorPos - Math.max(0,PANEL_COUNT - this.mBoosterInventory.length / 2);
         var _loc2_:int = 0;
         while(_loc2_ < PANEL_COUNT)
         {
            _loc3_ = this.mBoosterFrames[_loc2_];
            _loc4_ = this.mBoosterButtons[_loc2_];
            if(_loc1_ < this.mBoosterInventory.length / 2 && _loc1_ >= 0)
            {
               _loc5_ = this.mBoosterInventory[_loc1_ * 2];
               IconLoader.addIcon(_loc3_,_loc5_,this.iconLoaded);
               _loc4_.setEnabled(true);
            }
            else
            {
               Utils.removeAllChildren(_loc3_);
               _loc4_.setEnabled(false);
            }
            _loc1_++;
            _loc2_++;
         }
      }
      
      private function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,this.mIconSize,this.mIconSize);
      }
   }
}
