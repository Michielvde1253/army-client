package game.gui.pvp
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import game.gui.IconLoader;
   import game.gui.button.ArmyButton;
   import game.gui.popups.PopUpWindow;
   import game.items.PlayerUnitItem;
   
   public class PvPSelectedUnitPanel
   {
       
      
      private var mDialog:PopUpWindow;
      
      private var mBasePanel:MovieClip;
      
      private var mParentClip:MovieClip;
      
      private var mButtonRemove:ArmyButton;
      
      private var mIconBase:MovieClip;
      
      private var mUnit:PlayerUnitItem;
      
      private var mPanelIndex:int;
      
      public function PvPSelectedUnitPanel(param1:MovieClip, param2:MovieClip, param3:PopUpWindow)
      {
		 trace("praying 1");
         super();
		 trace("praying 2");
         this.mBasePanel = param1;
         this.mParentClip = param2;
         this.mDialog = param3;
		 trace("praying 3");
         this.mButtonRemove = Utils.createBasicButton(this.mBasePanel,"Button_Remove",this.removeClicked);
		 trace("praying 4");
         this.mIconBase = this.mBasePanel.getChildByName("Icon") as MovieClip;
		 trace("praying 5");
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
      
      public function setData(param1:PlayerUnitItem, param2:int) : void
      {
         this.mUnit = param1;
         this.mPanelIndex = param2;
         IconLoader.addIcon(this.mIconBase,param1,this.iconLoaded);
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,80,80);
      }
      
      private function removeClicked(param1:MouseEvent) : void
      {
         (this.mDialog as PvPCombatSetupDialog).removeUnit(this.mPanelIndex);
      }
   }
}
