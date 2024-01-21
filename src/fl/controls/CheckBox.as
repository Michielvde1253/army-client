package fl.controls
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   
   public class CheckBox extends LabelButton
   {
      
      private static var defaultStyles:Object = {
         "icon":null,
         "upIcon":"CheckBox_upIcon",
         "downIcon":"CheckBox_downIcon",
         "overIcon":"CheckBox_overIcon",
         "disabledIcon":"CheckBox_disabledIcon",
         "selectedDisabledIcon":"CheckBox_selectedDisabledIcon",
         "focusRectSkin":null,
         "focusRectPadding":null,
         "selectedUpIcon":"CheckBox_selectedUpIcon",
         "selectedDownIcon":"CheckBox_selectedDownIcon",
         "selectedOverIcon":"CheckBox_selectedOverIcon",
         "textFormat":null,
         "disabledTextFormat":null,
         "embedFonts":null,
         "textPadding":5
      };
      
      public static var createAccessibilityImplementation:Function;
       
      
      public function CheckBox()
      {
         super();
      }
      
      public static function getStyleDefinition() : Object
      {
         return defaultStyles;
      }
      
      override public function get toggle() : Boolean
      {
         return true;
      }
      
      override public function set toggle(param1:Boolean) : void
      {
         throw new Error("Warning: You cannot change a CheckBox\'s toggle.");
      }
      
      override public function get autoRepeat() : Boolean
      {
         return false;
      }
      
      override public function set autoRepeat(param1:Boolean) : void
      {
      }
      
      override protected function drawLayout() : void
      {
         super.drawLayout();
         var _loc1_:Number = Number(getStyleValue("textPadding"));
         switch(_labelPlacement)
         {
            case ButtonLabelPlacement.RIGHT:
               icon.x = _loc1_;
               textField.x = icon.x + (icon.width + _loc1_);
               background.width = textField.x + textField.width + _loc1_;
               background.height = Math.max(textField.height,icon.height) + _loc1_ * 2;
               break;
            case ButtonLabelPlacement.LEFT:
               icon.x = width - icon.width - _loc1_;
               textField.x = width - icon.width - _loc1_ * 2 - textField.width;
               background.width = textField.width + icon.width + _loc1_ * 3;
               background.height = Math.max(textField.height,icon.height) + _loc1_ * 2;
               break;
            case ButtonLabelPlacement.TOP:
            case ButtonLabelPlacement.BOTTOM:
               background.width = Math.max(textField.width,icon.width) + _loc1_ * 2;
               background.height = textField.height + icon.height + _loc1_ * 3;
         }
         background.x = Math.min(icon.x - _loc1_,textField.x - _loc1_);
         background.y = Math.min(icon.y - _loc1_,textField.y - _loc1_);
      }
      
      override protected function drawBackground() : void
      {
      }
      
      override public function drawFocus(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         super.drawFocus(param1);
         if(param1)
         {
            _loc2_ = Number(getStyleValue("focusRectPadding"));
            uiFocusRect.x = background.x - _loc2_;
            uiFocusRect.y = background.y - _loc2_;
            uiFocusRect.width = background.width + (_loc2_ << 1);
            uiFocusRect.height = background.height + (_loc2_ << 1);
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(CheckBox.createAccessibilityImplementation != null)
         {
            CheckBox.createAccessibilityImplementation(this);
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         super.toggle = true;
         var _loc1_:Shape = new Shape();
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.beginFill(0,0);
         _loc2_.drawRect(0,0,100,100);
         _loc2_.endFill();
         background = _loc1_ as DisplayObject;
         addChildAt(background,0);
      }
   }
}
