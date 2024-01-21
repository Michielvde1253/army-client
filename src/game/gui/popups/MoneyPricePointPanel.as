package game.gui.popups
{
   import com.dchoc.GUI.DCButton;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.gui.button.ArmyButtonSelected;
   
   public class MoneyPricePointPanel
   {
       
      
      private var mIndex:int;
      
      private var mButtonSelected:ArmyButtonSelected;
      
      private var mSelectCallback:Function;
      
      public function MoneyPricePointPanel(param1:MovieClip, param2:Object, param3:int, param4:Array, param5:Function)
      {
         var _loc6_:TextField = null;
         super();
         this.mIndex = param3;
         this.mSelectCallback = param5;
         (_loc6_ = param1.getChildByName("Text_Amount_Resource") as TextField).text = param2.FBCreditPriceRef.Amount;
         (_loc6_ = param1.getChildByName("Text_Amount_Cost") as TextField).autoSize = TextFieldAutoSize.LEFT;
         _loc6_.text = param2.FBCreditPriceRef.CreditsCost;
         var _loc7_:MovieClip = param1.getChildByName("Counter_Reduction") as MovieClip;
         if(param2.PricePercentage < 100)
         {
            (_loc6_ = _loc7_.getChildByName("Text_Amount") as TextField).autoSize = TextFieldAutoSize.CENTER;
            _loc6_.wordWrap = false;
            _loc6_.text = "-" + (100 - param2.PricePercentage) + "%";
            (_loc6_ = _loc7_.getChildByName("Text_Price") as TextField).text = param2.CreditsCostNew;
         }
         else
         {
            _loc7_.visible = false;
         }
         this.mButtonSelected = Utils.createSelectableButton(param1,"Button_Skip",this.selectClicked);
         this.mButtonSelected.setAllowDeselection(false);
         this.mButtonSelected.setPool(param4);
         if(param3 == 0)
         {
            this.mButtonSelected.select();
         }
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp,false,0,true);
         if(DCButton.TRIGGER_AT_MOUSE_UP)
         {
            param1.addEventListener(MouseEvent.CLICK,this.mouseClick,false,0,true);
         }
      }
      
      private function selectClicked(param1:MouseEvent) : void
      {
         this.mSelectCallback(this.mIndex);
      }
      
      protected function mouseDown(param1:MouseEvent) : void
      {
         this.mButtonSelected._mouseDown(param1);
      }
      
      protected function mouseUp(param1:MouseEvent) : void
      {
         this.mButtonSelected._mouseUp(param1);
      }
      
      protected function mouseOver(param1:MouseEvent) : void
      {
         this.mButtonSelected._mouseOver(param1);
      }
      
      protected function mouseOut(param1:MouseEvent) : void
      {
         this.mButtonSelected._mouseOut(param1);
      }
      
      protected function mouseClick(param1:MouseEvent) : void
      {
         this.mButtonSelected._mouseClick(param1);
      }
   }
}
