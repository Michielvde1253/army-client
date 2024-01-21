package game.gui.popups
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.IconLoader;
   import game.gui.StylizedHeaderClip;
   import game.gui.button.ArmyButton;
   import game.gui.button.ResizingButton;
   import game.items.AreaItem;
   import game.items.ItemManager;
   import game.states.GameState;
   
   public class AreaLockedWindow extends PopUpWindow
   {
       
      
      private var mConditionIcon:MovieClip;
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonSubmit:ResizingButton;
      
      private var mOpenAreaShopCallback:Function;
      
      public function AreaLockedWindow()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_POPUPS_WARNINGS_NAME,"popup_item_locked");
         super(new _loc1_() as MovieClip,true);
         this.mButtonCancel = Utils.createBasicButton(mClip,"Button_Cancel",this.skipClicked);
         this.mButtonSubmit = Utils.createResizingButton(mClip,"Button_Submit",this.areaShopClicked);
         this.mButtonSubmit.setText(GameState.getText("EXPAND_AREA_SUBMIT_BUTTON"));
      }
      
      public function Activate(param1:Function, param2:Function, param3:AreaItem) : void
      {
         var _loc4_:StylizedHeaderClip = null;
         var _loc5_:TextField = null;
         var _loc6_:MovieClip = null;
         mDoneCallback = param2;
         this.mOpenAreaShopCallback = param1;
         _loc4_ = new StylizedHeaderClip(mClip.getChildByName("Header") as MovieClip,param3.mName);
         (_loc5_ = mClip.getChildByName("Text_Description") as TextField).text = GameState.getText("EXPAND_AREA_DESCRIPTION");
         _loc5_.y -= 10;
         _loc6_ = mClip.getChildByName("Icon_Target") as MovieClip;
         _loc6_.x += 20;
         _loc6_.y += 5;
         IconLoader.addIcon(_loc6_,param3,this.iconLoaded1);
         if(this.mConditionIcon)
         {
            if(this.mConditionIcon.parent)
            {
               this.mConditionIcon.parent.removeChild(this.mConditionIcon);
            }
         }
         _loc6_ = mClip.getChildByName("Icon_Condition") as MovieClip;
         _loc6_.x -= 20;
         _loc6_.y += 5;
         IconLoader.addIcon(_loc6_,ItemManager.getItem("Intel","Intel"),this.iconLoaded);
         doOpeningTransition();
      }
      
      private function skipClicked(param1:MouseEvent) : void
      {
         mDoneCallback((this as Object).constructor);
      }
      
      public function iconLoaded(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,80,80);
      }
      
      public function iconLoaded1(param1:Sprite) : void
      {
         Utils.scaleIcon(param1,80,80);
      }
      
      private function areaShopClicked(param1:MouseEvent) : void
      {
         var _loc2_:Function = this.mOpenAreaShopCallback;
         mDoneCallback((this as Object).constructor);
         _loc2_();
         _loc2_ = null;
      }
      
      override public function close() : void
      {
         super.close();
         this.mOpenAreaShopCallback = null;
      }
   }
}
