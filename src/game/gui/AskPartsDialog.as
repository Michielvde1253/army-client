package game.gui
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gameElements.ConstructionObject;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.gui.button.ResizingIconButton;
   import game.gui.popups.PopUpWindow;
   import game.items.ConstructionItem;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.ShopItem;
   import game.net.GameFeedPublisher;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   
   public class AskPartsDialog extends PopUpWindow
   {
      
      protected static var PANEL_COUNT:int;
       
      
      protected var mPlayer:GamePlayerProfile;
      
      protected var mConstructionObject:ConstructionObject;
      
      protected var mButtonFinish:ResizingButton;
      
      protected var mButtonCancel:ArmyButton;
      
      protected var mGame:GameState;
      
      protected var mButtonClose:ResizingButton;
      
      protected var mButtonInstantBuild:ResizingIconButton;
      
      protected var mMoneyPanel:MovieClip;
      
      protected var mPanels:Array;
      
      protected var mTextDescription:TextField;
      
      public function AskPartsDialog(param1:MovieClip, param2:Boolean)
      {
         this.mPanels = new Array();
         super(param1,param2);
      }
      
      public function Activate(param1:ConstructionObject, param2:Function) : void
      {
         mDoneCallback = param2;
         this.mConstructionObject = param1;
         this.refresh();
         doOpeningTransition();
      }
      
      protected function setScreen() : void
      {
         var _loc8_:AskPartsItemPanel = null;
         var _loc9_:Object = null;
         var _loc10_:ShopItem = null;
         var _loc11_:int = 0;
         var _loc1_:ConstructionItem = this.mConstructionObject.mItem as ConstructionItem;
         this.mConstructionObject.checkConstructionState();
         var _loc2_:Array = this.mConstructionObject.getItemCount();
         var _loc3_:Array = _loc1_.mIngredientRequiredTypes;
         var _loc4_:Array = _loc1_.mIngredientRequiredAmounts;
         var _loc5_:Boolean = true;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < PANEL_COUNT)
         {
            _loc8_ = this.mPanels[_loc7_] as AskPartsItemPanel;
            if(_loc7_ < _loc3_.length)
            {
               _loc9_ = _loc3_[_loc7_] as Object;
               _loc10_ = ItemManager.getItem(_loc9_.ID,_loc9_.Type) as ShopItem;
               _loc8_.mBasePanel.visible = true;
               _loc8_.setData(_loc10_,_loc2_[_loc7_],_loc4_[_loc7_]);
               _loc11_ = _loc4_[_loc7_] - _loc2_[_loc7_];
               _loc6_ += _loc10_.getCostPremium() * _loc11_;
               if(_loc2_.length == 0 || _loc2_[_loc7_] < _loc4_[_loc7_])
               {
                  _loc5_ = false;
               }
            }
            else
            {
               _loc8_.mBasePanel.visible = false;
            }
            _loc7_++;
         }
         this.mButtonCancel.setVisible(true);
         this.mButtonFinish.setEnabled(_loc5_);
         this.mButtonInstantBuild.setVisible(!_loc5_);
         this.mButtonInstantBuild.setText(GameState.getText("BUTTON_INSTANT_BUILD",[_loc6_]));
      }
      
      public function refresh() : void
      {
         this.setScreen();
      }
      
      public function askItem(param1:Item) : void
      {
         GameFeedPublisher.launchGiftRequest(this.mConstructionObject.mItem.mId,param1.mId);
      }
      
      public function completePressed(param1:MouseEvent) : void
      {
         this.mConstructionObject.finishConstruction();
         this.closeDialog();
      }
      
      public function instaCompletePressed(param1:MouseEvent) : void
      {
         this.mConstructionObject.checkConstructionState();
         this.mGame.executeCompleteConstructionWithPremium(this.mConstructionObject);
         this.mButtonInstantBuild.setVisible(false);
      }
      
      protected function closedPressed(param1:MouseEvent) : void
      {
         this.closeDialog();
      }
      
      public function closeDialog() : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
