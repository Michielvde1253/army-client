package game.gui
{
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   
   public class AutoTextField
   {
      
      public static const ALIGNMENT_TOP:int = 0;
      
      public static const ALIGNMENT_VCENTER:int = 1;
      
      public static const ALIGNMENT_BOTTOM:int = 2;
       
      
      private var mTextField:TextField;
      
      private var mBoxHeight:Number;
      
      private var mBoxWidth:Number;
      
      private var mTextFieldX:Number;
      
      private var mTextFieldY:Number;
      
      private var mTextFieldScaleX:Number;
      
      private var mTextFieldScaleY:Number;
      
      private var mTextFieldText:String;
      
      private var mMinimumScale:Number = 0.3;
      
      private var mScalingStep:Number = 0.05;
      
      private var mMultiline:Boolean;
      
      private var mVerticalAlignment:int;
      
      private var mHorizontalAlignment:String;
      
      public function AutoTextField(param1:TextField)
      {
         super();
         param1.mouseEnabled = false;
         this.mBoxHeight = param1.height;
         this.mBoxWidth = param1.width;
         this.mTextFieldX = param1.x;
         this.mTextFieldY = param1.y;
         this.mTextFieldScaleX = param1.scaleX;
         this.mTextFieldScaleY = param1.scaleY;
         this.mTextField = param1;
         this.mVerticalAlignment = ALIGNMENT_VCENTER;
         this.mMultiline = param1.multiline;
         this.mHorizontalAlignment = param1.getTextFormat().align;
         param1.defaultTextFormat = param1.getTextFormat();
         this.setText(param1.text);
      }
      
      public function setVerticalAlignment(param1:int) : void
      {
         this.mVerticalAlignment = param1;
      }
      
      public function setMutliline(param1:Boolean) : void
      {
         this.mMultiline = param1;
      }
      
      public function getTextField() : TextField
      {
         return this.mTextField;
      }
      
      public function setText(param1:String) : void
      {
         var _loc3_:Number = NaN;
         if(this.mTextFieldText == param1)
         {
            return;
         }
         this.mTextFieldText = param1;
         var _loc2_:Number = 1;
         this.mTextField.text = param1;
         this.mTextField.autoSize = TextFieldAutoSize.NONE;
         if(!Config.FOR_IPHONE_PLATFORM)
         {
            this.mTextField.width = this.mBoxWidth;
         }
         this.mTextField.height = this.mBoxHeight;
         this.mTextField.x = this.mTextFieldX;
         this.mTextField.y = this.mTextFieldY;
         this.mTextField.scaleX = this.mTextFieldScaleX;
         this.mTextField.scaleY = this.mTextFieldScaleY;
         if(this.mMultiline)
         {
            while(this.mTextField.textHeight * _loc2_ > this.mBoxHeight && _loc2_ >= this.mMinimumScale)
            {
               _loc2_ -= this.mScalingStep;
               _loc3_ = this.mBoxWidth * (1 / _loc2_);
               this.mTextField.scaleX = _loc2_;
               this.mTextField.scaleY = this.mTextFieldScaleX * _loc2_ / this.mTextFieldScaleY;
               this.mTextField.width = _loc3_;
            }
            switch(this.mHorizontalAlignment)
            {
               case TextFormatAlign.LEFT:
                  this.mTextField.autoSize = TextFieldAutoSize.LEFT;
                  break;
               case TextFormatAlign.RIGHT:
                  this.mTextField.autoSize = TextFieldAutoSize.RIGHT;
                  break;
               default:
                  this.mTextField.autoSize = TextFieldAutoSize.CENTER;
            }
         }
         else
         {
            while(this.mTextField.textWidth * _loc2_ > this.mBoxWidth && _loc2_ >= this.mMinimumScale)
            {
               _loc2_ -= this.mScalingStep;
               _loc3_ = this.mBoxWidth * (1 / _loc2_);
               this.mTextField.scaleX = _loc2_;
               this.mTextField.scaleY = this.mTextFieldScaleY * this.mTextField.scaleX / this.mTextFieldScaleX;
               this.mTextField.width = _loc3_;
            }
            this.mTextField.autoSize = TextFieldAutoSize.CENTER;
            if(this.mHorizontalAlignment == TextFormatAlign.LEFT)
            {
               this.mTextField.x = this.mTextFieldX;
            }
            else if(this.mHorizontalAlignment == TextFormatAlign.RIGHT)
            {
               this.mTextField.x = this.mTextFieldX + this.mBoxWidth - this.mTextField.width;
            }
            else
            {
               this.mTextField.x = this.mTextFieldX + 0.5 * (this.mBoxWidth - this.mTextField.width);
            }
         }
         if(this.mVerticalAlignment == ALIGNMENT_VCENTER)
         {
            this.mTextField.y = this.mTextFieldY + 0.5 * (this.mBoxHeight - this.mTextField.height);
         }
         else if(this.mVerticalAlignment == ALIGNMENT_BOTTOM)
         {
            this.mTextField.y = this.mTextFieldY + (this.mBoxHeight - this.mTextField.height);
         }
         else
         {
            this.mTextField.y = this.mTextFieldY;
         }
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this.mTextField.visible = param1;
      }
      
      public function getText() : String
      {
         return this.mTextField.text;
      }
      
      public function getBoxHeight() : Number
      {
         return this.mBoxHeight;
      }
      
      public function getBoxWidth() : Number
      {
         return this.mBoxWidth;
      }
      
      public function setBoxHeight(param1:Number) : void
      {
         this.mBoxHeight = param1;
      }
      
      public function setBoxWidth(param1:Number) : void
      {
         this.mBoxWidth = param1;
      }
      
      public function setBoxX(param1:Number) : void
      {
         this.mTextFieldX = param1;
      }
      
      public function setBoxY(param1:Number) : void
      {
         this.mTextFieldY = param1;
      }
   }
}
