package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gameElements.HFEObject;
   import game.gameElements.PermanentHFEObject;
   import game.gameElements.PlayerBuildingObject;
   import game.gameElements.Production;
   import game.gameElements.ResourceBuildingObject;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingIconButton;
   import game.isometric.GridCell;
   import game.isometric.elements.WorldObject;
   import game.items.ItemManager;
   import game.items.MapItem;
   import game.magicBox.MagicBoxTracker;
   import game.net.ServiceIDs;
   import game.states.GameState;
   
   public class ImmediateSuppliesWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonUnlock:ResizingIconButton;
      
      private var instantSupplyCost:int;
      
      private var mItem:MapItem;
      
      public var mTarget:WorldObject;
      
      public function ImmediateSuppliesWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_buy_immidiate");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.skipClicked);
         this.mButtonUnlock = Utils.createResizingIconButton(mClip,"Button_Submit",this.unlockClicked);
      }
      
      public function Activate(param1:Function, param2:MapItem, param3:String, param4:int) : void
      {
         var _loc5_:StylizedHeaderClip = null;
         var _loc6_:TextField = null;
         mDoneCallback = param1;
         this.mItem = param2;
         _loc5_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,param2.mName);
         (_loc6_ = mClip.getChildByName("Text_Description") as TextField).text = param3;
         if(Config.DEBUG_MODE)
         {
         }
         var _loc7_:int;
         if((_loc7_ = param4 * 0.001 / 60) < 5)
         {
            this.instantSupplyCost = 5;
         }
         else
         {
            this.instantSupplyCost = Math.round(_loc7_ / 60 * 5);
         }
         this.mButtonUnlock.setText(GameState.getText("INSTANT_SUPPLY_BUTTON_TEXT",[this.instantSupplyCost]));
         this.mButtonUnlock.setIcon(ItemManager.getItem("Premium","Resource"));
         var _loc8_:MovieClip = mClip.getChildByName("Icon_Target") as MovieClip;
         IconLoader.addIcon(_loc8_,param2,this.iconLoaded);
      }
      
      private function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,250,250);
      }
      
      private function unlockClicked(param1:MouseEvent) : void
      {
         var _loc2_:Production = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:PlayerBuildingObject = null;
         var _loc6_:GridCell = null;
         var _loc7_:Object = null;
         if(GameState.mInstance.mPlayerProfile.getPremium() >= this.instantSupplyCost)
         {
            _loc4_ = null;
            _loc5_ = this.mTarget as PlayerBuildingObject;
            _loc6_ = PlayerBuildingObject.gc.mObject.getCell();
            if(this.mTarget is ResourceBuildingObject)
            {
               _loc3_ = "ResourceBuilding";
            }
            else
            {
               _loc3_ = "Building";
            }
            if(_loc5_ is HFEObject || _loc5_ is PermanentHFEObject)
            {
               _loc4_ = ServiceIDs.COLLECT_HF;
            }
            _loc7_ = {
               "coord_x":_loc6_.mPosI,
               "coord_y":_loc6_.mPosJ,
               "gold":this.instantSupplyCost,
               "item_type":_loc3_
            };
            GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.COLLECT_HF,_loc7_,false);
            GameState.mInstance.mPlayerProfile.addPremium(-this.instantSupplyCost,MagicBoxTracker.LABEL_BUY_ITEM,MagicBoxTracker.paramsObj(this.mItem.mType,this.mItem.mId));
            if(PlayerBuildingObject.gc.mObject as PlayerBuildingObject != null)
            {
               _loc2_ = (PlayerBuildingObject.gc.mObject as PlayerBuildingObject).getProduction();
               _loc2_.setRemainingProductionTime(0);
               mDoneCallback((this as Object).constructor);
            }
            return;
         }
         GameState.mInstance.mHUD.openBuyGoldScreen();
         mDoneCallback((this as Object).constructor);
      }
      
      private function skipClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
