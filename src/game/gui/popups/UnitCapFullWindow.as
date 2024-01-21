package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.items.Item;
   import game.items.ItemManager;
   import game.items.ShopItem;
   import game.states.GameState;
   
   public class UnitCapFullWindow extends PopUpWindow
   {
       
      
      private var mButtonSkip:ResizingButton;
      
      private var mButtonCancel:ArmyButton;
      
      public function UnitCapFullWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_unit_cap_full");
         super(new _loc1_(),true);
         this.mButtonSkip = Utils.createResizingButton(mClip,"Button_Skip",this.closeClicked);
         this.mButtonSkip.setText(GameState.getText("BUTTON_CONTINUE"));
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.closeClicked);
      }
      
      public function Activate(param1:Function, param2:ShopItem) : void
      {
         var _loc3_:StylizedHeaderClip = null;
         var _loc4_:TextField = null;
         var _loc7_:Item = null;
         var _loc8_:Item = null;
         mDoneCallback = param1;
         _loc3_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,GameState.getText("MENU_HEADER_UNIT_CAP"));
         _loc4_ = mClip.getChildByName("Text_Description") as TextField;
         var _loc5_:MovieClip = mClip.getChildByName("Icon_Condition_1") as MovieClip;
         var _loc6_:MovieClip = mClip.getChildByName("Icon_Condition_2") as MovieClip;
         var _loc9_:TextFormat;
         (_loc9_ = _loc4_.defaultTextFormat).size = int(_loc9_.size) + 5;
         _loc4_.defaultTextFormat = _loc9_;
         if(param2.mType == "Infantry")
         {
            _loc4_.text = GameState.getText("MENU_DESC_UNIT_CAP");
            _loc7_ = ItemManager.getItem("BootCamp","Building");
            _loc8_ = ItemManager.getItem("Commando","Building");
         }
         else if(param2.mType == "Armor")
         {
            _loc4_.text = GameState.getText("MENU_DESC_UNIT_MECHANIZED");
            _loc7_ = ItemManager.getItem("MotorPool","Building");
            _loc8_ = ItemManager.getItem("Factory","Building");
         }
         else
         {
            _loc4_.text = GameState.getText("MENU_DESC_UNIT_ARTILLERY");
            _loc7_ = ItemManager.getItem("Arsenal","Building");
            _loc8_ = ItemManager.getItem("TestSite","Building");
         }
         IconLoader.addIcon(_loc5_,_loc7_,this.iconLoaded);
         IconLoader.addIcon(_loc6_,_loc8_,this.iconLoaded);
      }
      
      private function closeClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
      
      private function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,70,70);
      }
   }
}
