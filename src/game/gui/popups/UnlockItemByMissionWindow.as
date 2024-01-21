package game.gui.popups
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.IconAdapter;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ResizingButton;
   import game.items.ShopItem;
   import game.missions.Mission;
   import game.missions.MissionManager;
   import game.states.GameState;
   
   public class UnlockItemByMissionWindow extends PopUpWindow
   {
       
      
      private var mButtonCancel:DCButton;
      
      private var mButtonSkip:ResizingButton;
      
      private var mItem:ShopItem;
      
      public function UnlockItemByMissionWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_item_locked_mission");
         super(new _loc1_(),true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.skipClicked);
         this.mButtonSkip = Utils.createResizingButton(mClip,"Button_Skip",this.skipClicked);
         this.mButtonSkip.setText(GameState.getText("BUTTON_CONTINUE"));
      }
      
      public function Activate(param1:Function, param2:ShopItem) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc4_:TextField = null;
         mDoneCallback = param1;
         this.mItem = param2;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,param2.mName);
         (_loc4_ = mClip.getChildByName("Text_Description") as TextField).text = GameState.getText("MENU_DESC_UNLOCK_ITEM_MISSION",[param2.mRequiredMission.Name]);
         var _loc5_:MovieClip = mClip.getChildByName("Icon_Target") as MovieClip;
         IconLoader.addIcon(_loc5_,param2,this.iconLoaded);
         _loc5_ = mClip.getChildByName("Icon_Condition") as MovieClip;
         var _loc6_:Mission = MissionManager.getMission(param2.mRequiredMission.ID);
         IconLoader.addIcon(_loc5_,new IconAdapter(_loc6_.getIconGraphics(),_loc6_.getIconGraphicsFile()),this.iconLoaded);
      }
      
      private function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,70,70);
      }
      
      private function skipClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
   }
}
