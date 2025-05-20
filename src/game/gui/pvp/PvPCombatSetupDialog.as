package game.gui.pvp
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import game.gui.AutoTextField;
   import game.gui.IconLoader;
   import game.gui.ShopDialog;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.popups.PopUpWindow;
   import game.items.EnemyUnitItem;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.PlayerUnitItem;
   import game.net.Friend;
   import game.net.FriendsCollection;
   import game.net.PvPMatch;
   import game.net.PvPOpponent;
   import game.net.PvPOpponentCollection;
   import game.player.GamePlayerProfile;
   import game.states.GameState;
   import game.environment.EnvEffectManager;
   
   public class PvPCombatSetupDialog extends PopUpWindow
   {
      
      private static const UNIT_PANEL_COUNT:int = 4;
      
      private static const SELECTED_UNIT_PANEL_COUNT:int = 4;
      
      private static const OPPONENT_UNIT_PANEL_COUNT:int = 4;
      
      private static var smSelectedUnits:Array;
      
      private static const INSUFFICIENT_RESOURCES_FILTER:Array = [];
      
      private static const INSUFFICIENT_RESOURCES_MOD:ColorTransform = new ColorTransform(5,0.7,0.7,1,127,-127,-127,0);
      
      private static var mDefaultFilters:Array;
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonBack:ArmyButton;
      
      private var mButtonFight:ArmyButton;
      
      private var mButtonBuy:ArmyButton;
      
      private var mPlayerArmy:MovieClip;
      
      private var mPlayerCard:MovieClip;
      
      private var mOpponentArmy:MovieClip;
      
      private var mOpponentCard:MovieClip;
      
      private var mInfoPanel:MovieClip;
      
      private var mMatchUpCallback:Function;
      
      private var mStartPvPCallback:Function;
      
      private var mButtonSelectionScrollUp:ArmyButton;
      
      private var mButtonSelectionScrollDown:ArmyButton;
      
      private var mUnitPanels:Array;
      
      private var mPlayerUnits:Array;
      
      private var mPlayerUnitCounts:Array;
      
      private var mSelectedUnitPanels:Array;
      
      private var mOpponentUnitPanels:Array;
      
      private var mOpponentUnits:Array;
      
      private var mPage:int = 0;
      
      private var mPageMax:int = 0;
      
      private var mHeader:StylizedHeaderClip;
      
      public function PvPCombatSetupDialog()
      {
         var _loc4_:TextField = null;
         var _loc5_:AutoTextField = null;
         var _loc10_:MovieClip = null;
         this.mUnitPanels = new Array();
         this.mPlayerUnits = new Array();
         this.mPlayerUnitCounts = new Array();
         this.mSelectedUnitPanels = new Array();
         this.mOpponentUnitPanels = new Array();
         this.mOpponentUnits = new Array();
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass("swf/popups_pvp","popup_pvp_armies");
         super(new _loc1_(),true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
         this.mPlayerArmy = mClip.getChildByName("Player_Army") as MovieClip;
         this.mPlayerCard = this.mPlayerArmy.getChildByName("Player_Card") as MovieClip;
         this.mOpponentArmy = mClip.getChildByName("Opponent_Army") as MovieClip;
         this.mOpponentCard = this.mOpponentArmy.getChildByName("Player_Card") as MovieClip;
         this.mInfoPanel = mClip.getChildByName("Info_Panel") as MovieClip;
         var _loc2_:MovieClip = this.mInfoPanel.getChildByName("Toolbox") as MovieClip;
         this.mButtonBack = Utils.createBasicButton(_loc2_,"Button_Back",this.backClicked);
         this.mButtonFight = Utils.createBasicButton(_loc2_,"Button_Fight",this.fightClicked);
         this.mButtonBuy = Utils.createBasicButton(_loc2_,"Button_Buy",this.buyClicked);
         var _loc3_:Friend = FriendsCollection.smFriends.GetThePlayer();
         (_loc4_ = this.mPlayerCard.getChildByName("Text_Name") as TextField).text = _loc3_.mName;
         this.mHeader = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip);
         this.mHeader.setText(GameState.getText("PVP_SETUP_TITLE"));
         (_loc4_ = this.mInfoPanel.getChildByName("Text_Costs") as TextField).text = GameState.getText("PVP_SETUP_COST_TITLE");
         (_loc4_ = this.mInfoPanel.getChildByName("Text_Rewards") as TextField).text = GameState.getText("PVP_SETUP_REWARDS_TITLE");
         (_loc4_ = this.mInfoPanel.getChildByName("Text_Chances") as TextField).text = GameState.getText("PVP_SETUP_TITLE");
         (_loc4_ = this.mInfoPanel.getChildByName("Text_Chances") as TextField).text = GameState.getText("PVP_SETUP_CHANCE_TITLE");
         (_loc5_ = new AutoTextField(this.mPlayerArmy.getChildByName("Text_Description") as TextField)).setText(GameState.getText("PVP_SETUP_DESC"));
         (_loc4_ = _loc2_.getChildByName("Text_Button_Back") as TextField).text = GameState.getText("PVP_SETUP_BACK");
         (_loc4_ = _loc2_.getChildByName("Text_Button_Fight") as TextField).text = GameState.getText("PVP_SETUP_FIGHT");
         (_loc4_ = _loc2_.getChildByName("Text_Button_Buy") as TextField).text = GameState.getText("PVP_SETUP_SHOP");
         var _loc6_:Sprite = this.mPlayerCard.getChildByName("Thumb") as Sprite;
         if(_loc3_ && _loc3_.mPicID != null && _loc3_.mPicID != "")
         {
            IconLoader.addIconPicture(_loc6_,_loc3_.mPicID);
         }
         this.removeChildClip(this.mPlayerArmy,"Button_Scroll_Up");
         this.removeChildClip(this.mPlayerArmy,"Button_Scroll_Down");
         this.removeChildClip(this.mPlayerArmy,"Scrollbar");
         this.removeChildClip(this.mOpponentArmy,"Button_Scroll_Up");
         this.removeChildClip(this.mOpponentArmy,"Button_Scroll_Down");
         this.removeChildClip(this.mOpponentArmy,"Scrollbar");
         this.mButtonSelectionScrollUp = Utils.createBasicButton(this.mPlayerArmy,"Selection_Scroll_Up",this.selectionUpClicked);
         this.mButtonSelectionScrollDown = Utils.createBasicButton(this.mPlayerArmy,"Selection_Scroll_Down",this.selectionDownClicked);
         var _loc7_:int = 0;
         while(_loc7_ < UNIT_PANEL_COUNT)
         {
            _loc10_ = this.mPlayerArmy.getChildByName("Army_Slot_0" + (_loc7_ + 1)) as MovieClip;
            this.mUnitPanels[_loc7_] = new PvPUnitPanel(_loc10_,this.mPlayerArmy,this);
            _loc7_++;
         }
         var _loc8_:int = 0;
         while(_loc8_ < SELECTED_UNIT_PANEL_COUNT)
         {
            _loc10_ = this.mPlayerArmy.getChildByName("Army_Slot_Empty_0" + (_loc8_ + 1)) as MovieClip;
            this.mSelectedUnitPanels[_loc8_] = new PvPSelectedUnitPanel(_loc10_,this.mPlayerArmy,this);
            _loc8_++;
         }
         var _loc9_:int = 0;
         while(_loc9_ < OPPONENT_UNIT_PANEL_COUNT)
         {
            _loc10_ = this.mOpponentArmy.getChildByName("Army_Slot_Opponent_Active_0" + (_loc9_ + 1)) as MovieClip;
            this.mOpponentUnitPanels[_loc9_] = new PvPOpponentUnitPanel(_loc10_,this.mOpponentArmy);
            _loc9_++;
         }
      }
      
      private function removeChildClip(param1:DisplayObjectContainer, param2:String) : void
      {
         var _loc3_:DisplayObjectContainer = param1.getChildByName(param2) as DisplayObjectContainer;
         if(_loc3_.parent)
         {
            _loc3_.parent.removeChild(_loc3_);
         }
      }
      
      public function Activate(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc7_:TextField = null;
         var _loc10_:String = null;
         var _loc11_:Item = null;
         var _loc12_:int = 0;
         var _loc13_:Item = null;
         var _loc14_:PvPOpponentUnitPanel = null;
         var _loc15_:int = 0;
         mDoneCallback = param1;
         this.mMatchUpCallback = param2;
         this.mStartPvPCallback = param3;
         var _loc4_:PvPOpponent = GameState.mInstance.mPvPMatch.mOpponent;
         this.mOpponentUnits = GameState.mInstance.mPvPMatch.mOpponentUnits;
         var _loc5_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         var _loc6_:MovieClip;
         (_loc7_ = (_loc6_ = this.mPlayerCard.getChildByName("Rank_Icon") as MovieClip).getChildByName("Text_PvP_Rank") as TextField).text = _loc5_.mBadassLevel.toString();
         (_loc7_ = this.mPlayerCard.getChildByName("Text_Rank") as TextField).text = _loc5_.getBadassName();
         (_loc7_ = this.mOpponentCard.getChildByName("Text_Rank") as TextField).text = _loc4_.getBadassName();
         (_loc7_ = this.mOpponentCard.getChildByName("Text_Name") as TextField).text = _loc4_.mName;
         var _loc8_:Sprite = this.mOpponentCard.getChildByName("Thumb") as Sprite;
         if(_loc4_ && _loc4_.mPicID != null && _loc4_.mPicID != "")
         {
            IconLoader.addIconPicture(_loc8_,_loc4_.mPicID);
         }
         (_loc7_ = (_loc6_ = this.mOpponentCard.getChildByName("Rank_Icon") as MovieClip).getChildByName("Text_PvP_Rank") as TextField).text = _loc4_.mBadassLevel.toString();
         (_loc7_ = this.mInfoPanel.getChildByName("Text_Cost_Energy") as TextField).text = GameState.mConfig.PlayerStartValues.Default.PvPCostEnergy;
		 if(_loc5_.mEnergy < GameState.mConfig.PlayerStartValues.Default.PvPCostEnergy)
         {
            _loc7_.filters = INSUFFICIENT_RESOURCES_FILTER;
            _loc7_.transform.colorTransform = INSUFFICIENT_RESOURCES_MOD;
         }
         var _loc9_:Object = _loc5_.mGlobalUnitCounts;
         for(_loc10_ in _loc9_)
         {
            if(_loc9_[_loc10_] != null && _loc9_[_loc10_] > 0)
            {
               _loc13_ = ItemManager.getItemByTableName(_loc10_,"PlayerUnit");
               this.mPlayerUnits.push(_loc13_);
            }
         }
         this.mPlayerUnits.sort(this.sortUnits);
         for each(_loc11_ in this.mPlayerUnits)
         {
            this.mPlayerUnitCounts.push(_loc9_[_loc11_.mId]);
         }
         _loc12_ = 0;
         while(_loc12_ < OPPONENT_UNIT_PANEL_COUNT)
         {
            _loc14_ = PvPOpponentUnitPanel(this.mOpponentUnitPanels[_loc12_]);
            if(_loc12_ < this.mOpponentUnits.length)
            {
               _loc14_.show();
               _loc14_.setData(this.mOpponentUnits[_loc12_]);
            }
            else
            {
               _loc14_.hide();
            }
            _loc12_++;
         }
         if(smSelectedUnits == null)
         {
            smSelectedUnits = new Array();
            _loc15_ = 0;
            while(_loc15_ < this.mPlayerUnits.length)
            {
               while(this.mPlayerUnitCounts[_loc15_] > 0 && smSelectedUnits.length < 4)
               {
                  this.addUnit(_loc15_);
               }
               _loc15_++;
            }
         }
         this.updateWinRewards();
         this.updateChanceToWin();
         this.refresh();
         doOpeningTransition();
      }
      
      private function sortUnits(param1:PlayerUnitItem, param2:PlayerUnitItem) : Number
      {
         if(param1.mPvPCostSupplies > param2.mPvPCostSupplies)
         {
            return -1;
         }
         if(param1.mPvPCostSupplies < param2.mPvPCostSupplies)
         {
            return 1;
         }
         return 0;
      }
      
      private function backClicked(param1:MouseEvent) : void
      {
         this.closeDialog();
         this.mMatchUpCallback();
      }
      
      private function fightClicked(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:PlayerUnitItem = null;
         var _loc5_:PvPMatch = null;
         var _loc2_:GamePlayerProfile = GameState.mInstance.mPlayerProfile;
         if(_loc2_.mEnergy < GameState.mConfig.PlayerStartValues.Default.PvPCostEnergy)
         {
            GameState.mInstance.getHud().openOutOfEnergyWindow();
         }
         else
         {
            _loc3_ = 0;
            for each(_loc4_ in smSelectedUnits)
            {
               _loc3_ += _loc4_.mPvPCostSupplies;
            }
            if(_loc3_ > _loc2_.mSupplies)
            {
               GameState.mInstance.getHud().openOutOfSuppliesTextBox([_loc3_,_loc2_.mSupplies]);
            }
            else
            {
               (_loc5_ = GameState.mInstance.mPvPMatch).mPlayerUnits = smSelectedUnits;
               _loc5_.mEnergyCost = GameState.mConfig.PlayerStartValues.Default.PvPCostEnergy;
               _loc5_.mSupplyCost = _loc3_;
               PvPOpponentCollection.smCollection.removeRecentAttack(_loc5_.mOpponent.mFacebookID);
               this.closeDialog();
			   EnvEffectManager.destroy();
			   GameState.mInstance.mScene.mFog.destroy();
               this.mStartPvPCallback();
            }
         }
      }
      
      private function buyClicked(param1:MouseEvent) : void
      {
         GameState.mInstance.getHud().triggerShopOpening(ShopDialog.TAB_BOOSTERS,"pvp");
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         this.closeDialog();
         GameState.mInstance.endPvP();
      }
      
      protected function closeDialog(param1:Boolean = true) : void
      {
         if(param1)
         {
            mDoneCallback((this as Object).constructor);
         }
      }
      
      private function selectionUpClicked(param1:MouseEvent) : void
      {
         this.mPage = Math.max(0,this.mPage - 1);
         this.setScreen();
         this.setScrollButtons();
      }
      
      private function selectionDownClicked(param1:MouseEvent) : void
      {
         this.mPage = Math.min(this.mPageMax - 1,this.mPage + 1);
         this.setScreen();
         this.setScrollButtons();
      }
      
      public function refresh() : void
      {
         this.mPage = 0;
         this.mPageMax = (this.mPlayerUnits.length + UNIT_PANEL_COUNT - 1) / UNIT_PANEL_COUNT;
         this.setScreen();
         this.setScrollButtons();
         this.updateSuppliesCost();
      }
      
      private function setScreen() : void
      {
         var _loc4_:PvPUnitPanel = null;
         var _loc5_:int = 0;
         var _loc6_:PvPSelectedUnitPanel = null;
         var _loc1_:int = this.mPage * UNIT_PANEL_COUNT;
         var _loc2_:int = 0;
         while(_loc2_ < UNIT_PANEL_COUNT)
         {
            _loc4_ = PvPUnitPanel(this.mUnitPanels[_loc2_]);
            if((_loc5_ = _loc2_ + _loc1_) < this.mPlayerUnits.length)
            {
               _loc4_.show();
               _loc4_.setData(this.mPlayerUnits[_loc5_],this.mPlayerUnitCounts[_loc5_],_loc5_,smSelectedUnits.length < SELECTED_UNIT_PANEL_COUNT);
            }
            else
            {
               _loc4_.hide();
            }
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < SELECTED_UNIT_PANEL_COUNT)
         {
            _loc6_ = PvPSelectedUnitPanel(this.mSelectedUnitPanels[_loc3_]);
            if(_loc3_ < smSelectedUnits.length)
            {
               _loc6_.show();
               _loc6_.setData(smSelectedUnits[_loc3_],_loc3_);
            }
            else
            {
               _loc6_.hide();
            }
            _loc3_++;
         }
         this.mButtonFight.setEnabled(smSelectedUnits.length > 0);
      }
      
      private function setScrollButtons() : void
      {
         this.mButtonSelectionScrollDown.setEnabled(this.mPage < this.mPageMax - 1);
         this.mButtonSelectionScrollUp.setEnabled(this.mPage > 0);
      }
      
      public function addUnit(param1:int) : void
      {
         --this.mPlayerUnitCounts[param1];
         smSelectedUnits.push(this.mPlayerUnits[param1]);
         this.setScreen();
         this.updateSuppliesCost();
         this.updateChanceToWin();
      }
      
      public function removeUnit(param1:int) : void
      {
         var _loc4_:PlayerUnitItem = null;
         var _loc2_:PlayerUnitItem = smSelectedUnits.splice(param1,1)[0];
         var _loc3_:int = 0;
         while(_loc3_ < this.mPlayerUnits.length)
         {
            _loc4_ = this.mPlayerUnits[_loc3_];
            if(_loc2_.mId == _loc4_.mId && _loc2_.mType == _loc4_.mType)
            {
               ++this.mPlayerUnitCounts[_loc3_];
               break;
            }
            _loc3_++;
         }
         this.setScreen();
         this.updateSuppliesCost();
         this.updateChanceToWin();
      }
      
      private function updateSuppliesCost() : void
      {
         var _loc2_:PlayerUnitItem = null;
         var _loc3_:TextField = null;
         var _loc1_:int = 0;
         for each(_loc2_ in smSelectedUnits)
         {
            _loc1_ += _loc2_.mPvPCostSupplies;
         }
         _loc3_ = this.mInfoPanel.getChildByName("Text_Cost_Supplies") as TextField;
         _loc3_.text = _loc1_.toString();
         if(!mDefaultFilters)
         {
            mDefaultFilters = _loc3_.filters;
         }
         var _loc4_:GamePlayerProfile;
         if((_loc4_ = GameState.mInstance.mPlayerProfile).mSupplies < _loc1_)
         {
            _loc3_.filters = INSUFFICIENT_RESOURCES_FILTER;
            _loc3_.transform.colorTransform = INSUFFICIENT_RESOURCES_MOD;
         }
         else
         {
            _loc3_.filters = mDefaultFilters;
            _loc3_.transform.colorTransform = new ColorTransform();
         }
      }
      
      private function updateWinRewards() : void
      {
         var _loc3_:EnemyUnitItem = null;
         var _loc4_:TextField = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         for each(_loc3_ in this.mOpponentUnits)
         {
            _loc1_ += _loc3_.mWinRewardMoney;
            _loc2_ += _loc3_.mWinRewardBadass;
         }
         GameState.mInstance.mPvPMatch.mWinRewardMoney = _loc1_;
         GameState.mInstance.mPvPMatch.mWinRewardBadassXp = _loc2_;
         (_loc4_ = this.mInfoPanel.getChildByName("Text_Rewards_Money") as TextField).text = _loc1_.toString();
         (_loc4_ = this.mInfoPanel.getChildByName("Text_Rewards_Rank_Points") as TextField).text = _loc2_.toString();
      }
      
      private function updateChanceToWin() : void
      {
         var _loc3_:PlayerUnitItem = null;
         var _loc4_:EnemyUnitItem = null;
         var _loc5_:TextField = null;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         for each(_loc3_ in smSelectedUnits)
         {
            _loc1_ += _loc3_.getDefaultActorPriority();
         }
         for each(_loc4_ in this.mOpponentUnits)
         {
            _loc2_ += _loc4_.getDefaultActorPriority();
         }
         (_loc5_ = this.mInfoPanel.getChildByName("Text_Chances") as TextField).text = "" + (_loc1_ - _loc2_);
      }
   }
}
