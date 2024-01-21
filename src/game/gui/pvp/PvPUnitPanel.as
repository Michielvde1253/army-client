package game.gui.pvp
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.IconLoader;
   import game.gui.button.ArmyButton;
   import game.gui.popups.PopUpWindow;
   import game.items.PlayerUnitItem;
   
   public class PvPUnitPanel
   {
       
      
      private var mDialog:PopUpWindow;
      
      private var mBasePanel:MovieClip;
      
      private var mParentClip:MovieClip;
      
      private var mButtonAdd:ArmyButton;
      
      private var mIconBase:MovieClip;
      
      private var mUnit:PlayerUnitItem;
      
      private var mUnitIndex:int;
      
      public function PvPUnitPanel(param1:MovieClip, param2:MovieClip, param3:PopUpWindow)
      {
         super();
         this.mBasePanel = param1;
         this.mParentClip = param2;
         this.mDialog = param3;
         this.mButtonAdd = Utils.createBasicButton(this.mBasePanel,"Button_Add",this.addClicked);
         this.mIconBase = this.mBasePanel.getChildByName("Icon") as MovieClip;
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
         this.mParentClip.addChild(this.mBasePanel);
      }
      
      public function setData(param1:PlayerUnitItem, param2:int, param3:int, param4:Boolean) : void
      {
         var _loc5_:TextField = null;
         this.mUnit = param1;
         this.mUnitIndex = param3;
         IconLoader.addIcon(this.mIconBase,param1,this.iconLoaded);
         (_loc5_ = this.mBasePanel.getChildByName("Text_Value") as TextField).text = param2.toString();
         (_loc5_ = this.mBasePanel.getChildByName("Text_Supplies") as TextField).text = param1.mPvPCostSupplies.toString();
         this.mButtonAdd.setEnabled(param2 > 0 && param4);
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,80,80);
      }
      
      private function addClicked(param1:MouseEvent) : void
      {
         (this.mDialog as PvPCombatSetupDialog).addUnit(this.mUnitIndex);
      }
   }
}
