package game.gui.pvp
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import game.gui.IconLoader;
   import game.items.EnemyUnitItem;
   
   public class PvPOpponentUnitPanel
   {
       
      
      private var mBasePanel:MovieClip;
      
      private var mParentClip:MovieClip;
      
      private var mIconBase:MovieClip;
      
      private var mUnit:EnemyUnitItem;
      
      public function PvPOpponentUnitPanel(param1:MovieClip, param2:MovieClip)
      {
         super();
         this.mBasePanel = param1;
         this.mParentClip = param2;
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
      
      public function setData(param1:EnemyUnitItem) : void
      {
         this.mUnit = param1;
         IconLoader.addIcon(this.mIconBase,param1,this.iconLoaded);
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,80,80);
      }
   }
}
