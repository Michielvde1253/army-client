package game.gui
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class StylizedHeaderClip
   {
       
      
      private var mClip:DisplayObjectContainer;
      
      private var mTextForeGround:TextField;
      
      private var mTextBackGround_01:TextField;
      
      private var mTextBackGround_02:TextField;
      
      private var mIcon:MovieClip;
      
      public function StylizedHeaderClip(param1:DisplayObjectContainer, param2:String = "Title", param3:String = "center")
      {
         super();
         this.mClip = param1;
         this.mTextForeGround = param1.getChildByName("Text_Title") as TextField;
         this.mTextForeGround.rotation = 0;
         this.mTextBackGround_01 = param1.getChildByName("Text_Background_01") as TextField;
         if(this.mTextBackGround_01)
         {
            this.mTextBackGround_01.rotation = 0;
         }
         this.mTextBackGround_02 = param1.getChildByName("Text_Background_02") as TextField;
         if(this.mTextBackGround_02)
         {
            this.mTextBackGround_02.rotation = 0;
         }
         param1.mouseChildren = false;
         param1.mouseEnabled = false;
         if(param1.getChildByName("Icon"))
         {
            this.mIcon = param1.getChildByName("Icon") as MovieClip;
         }
         this.mTextForeGround.autoSize = param3;
         this.mTextForeGround.defaultTextFormat = this.mTextForeGround.getTextFormat();
         if(this.mTextBackGround_01)
         {
            this.mTextBackGround_01.autoSize = param3;
            this.mTextBackGround_01.defaultTextFormat = this.mTextBackGround_01.getTextFormat();
         }
         if(this.mTextBackGround_02)
         {
            this.mTextBackGround_02.autoSize = param3;
            this.mTextBackGround_02.defaultTextFormat = this.mTextBackGround_02.getTextFormat();
         }
         this.setText(param2);
      }
      
      private function resizeHeader() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Number = NaN;
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Number = NaN;
         if(this.mClip.parent)
         {
            _loc1_ = this.mClip.parent.getChildByName("Button_Cancel") as MovieClip;
         }
         if(_loc1_)
         {
            _loc2_ = this.mClip.scaleX;
            _loc3_ = this.mClip.transform.pixelBounds;
            _loc4_ = _loc1_.transform.pixelBounds;
            if((_loc5_ = (_loc3_.right - _loc4_.left) * 2) > 0)
            {
               this.mClip.scaleY = _loc2_ * (_loc3_.width - _loc5_) / _loc3_.width;
               this.mClip.scaleX = _loc2_ * (_loc3_.width - _loc5_) / _loc3_.width;
            }
         }
      }
      
      public function setText(param1:String) : void
      {
         this.mTextForeGround.visible = param1 != "";
         this.mTextForeGround.text = param1;
         if(this.mTextBackGround_01)
         {
            this.mTextBackGround_01.text = param1;
         }
         if(this.mTextBackGround_02)
         {
            this.mTextBackGround_02.text = param1;
         }
         this.resizeHeader();
         if(this.mIcon)
         {
            this.mIcon.visible = param1 == "";
            this.mIcon.x = this.mTextForeGround.x + this.mTextForeGround.textWidth / 2;
         }
      }
   }
}
