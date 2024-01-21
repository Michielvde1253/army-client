package game.gui
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.items.Item;
   
   public class TextEffect
   {
      
      public static const TYPE_LOSS:int = 0;
      
      public static const TYPE_GAIN:int = 1;
      
      public static const TYPE_BONUS:int = 2;
      
      public static const TYPE_MULTIPLIER:int = 3;
       
      
      private var mClip:MovieClip;
      
      private var mText:String;
      
      private var mTextField:TextField;
      
      private var mType:int;
      
      private var mTextFieldName:String;
      
      public function TextEffect(param1:int, param2:String, param3:Item = null)
      {
         var _loc6_:MovieClip = null;
         super();
         this.mText = param2;
         this.mType = param1;
         var _loc4_:String = param1 == TYPE_LOSS ? "feedback_loss" : "feedback_gain";
         this.mTextFieldName = "Header";
         var _loc5_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,_loc4_);
         this.mClip = new _loc5_();
         this.mClip.mouseEnabled = false;
         this.mClip.mouseChildren = false;
         this.mTextField = (this.mClip.getChildByName("Header") as MovieClip).getChildByName("Text_Field") as TextField;
         this.mTextField.text = this.mText;
         this.mTextField.autoSize = TextFieldAutoSize.CENTER;
         LocalizationUtils.replaceFont(this.mTextField);
         if(param1 == TYPE_BONUS || param1 == TYPE_MULTIPLIER)
         {
            this.mClip.scaleX = 2;
            this.mClip.scaleY = 2;
         }
         if(param3)
         {
            _loc6_ = this.mClip.getChildByName("Icon") as MovieClip;
            IconLoader.addIcon(_loc6_,param3,this.scaleIcon);
            this.mText = param3.mName + " " + param2;
         }
         this.mClip.gotoAndStop(0);
      }
      
      public function scaleIcon(param1:Sprite) : void
      {
         param1.height = 30;
         param1.scaleX = param1.scaleY;
         param1.x = -this.mTextField.textWidth;
      }
      
      public function start() : void
      {
         this.mClip.addEventListener(Event.ENTER_FRAME,this.enterFrame);
      }
      
      public function getClip() : MovieClip
      {
         return this.mClip;
      }
      
      public function enterFrame(param1:Event) : void
      {
         this.mClip.nextFrame();
         var _loc2_:TextField = (this.mClip.getChildByName("Header") as MovieClip).getChildByName("Text_Field") as TextField;
         _loc2_.text = this.mText;
         _loc2_.autoSize = TextFieldAutoSize.CENTER;
         if(this.mClip.currentFrame == this.mClip.totalFrames)
         {
            this.mClip.stop();
            this.mClip.removeEventListener(Event.ENTER_FRAME,this.enterFrame);
            Utils.removeFromParent(this.mClip);
         }
      }
   }
}
