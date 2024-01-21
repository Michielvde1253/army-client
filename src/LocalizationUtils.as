package
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flashx.textLayout.utils.CharacterUtil;
   
   public class LocalizationUtils
   {
      
      private static const ARIAL_UNICODE_FONT:String = "Arial Unicode MS";
      
      private static const SPECIAL_LANGUAGES:Array = ["ru","zt","zs","zh","ja","th","ar","el","sr","hi","ko"];
      
      private static const LINE_SPACE_ISSUE_LANGUAGES:Array = ["hi"];
       
      
      public function LocalizationUtils()
      {
         super();
      }
      
      public static function languageHasSpecialCharacters() : Boolean
      {
         return SPECIAL_LANGUAGES.indexOf(Config.smLanguageCode) != -1;
      }
      
      public static function languageHasLineSpaceIssues() : Boolean
      {
         return LINE_SPACE_ISSUE_LANGUAGES.indexOf(Config.smLanguageCode) != -1;
      }
      
      public static function replaceFonts(param1:DisplayObject) : void
      {
         if(languageHasSpecialCharacters())
         {
            CallForAllChildren(param1,replaceFont,null);
         }
      }
      
      public static function replaceFont(param1:DisplayObject, param2:Array = null) : void
      {
         var _loc3_:TextField = null;
         var _loc4_:String = null;
         var _loc5_:TextFormat = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TextFormat = null;
         if(languageHasSpecialCharacters())
         {
            _loc3_ = param1 as TextField;
            if(_loc3_)
            {
               if(_loc3_.defaultTextFormat.font != ARIAL_UNICODE_FONT)
               {
                  _loc4_ = _loc3_.text;
                  _loc5_ = _loc3_.defaultTextFormat;
                  _loc6_ = 2;
                  _loc7_ = int(_loc5_.size);
                  _loc8_ = new TextFormat(ARIAL_UNICODE_FONT,_loc7_ > 10 ? _loc7_ - _loc6_ : _loc7_,_loc5_.color,_loc5_.bold,_loc5_.italic,_loc5_.underline,_loc5_.url,_loc5_.target,_loc5_.align,_loc5_.leftMargin,_loc5_.rightMargin,_loc5_.indent,_loc5_.leading);
                  _loc3_.defaultTextFormat = _loc8_;
                  _loc3_.useRichTextClipboard = true;
                  _loc3_.embedFonts = false;
                  _loc3_.text = _loc4_;
               }
            }
         }
      }
      
      public static function CallForAllChildren(param1:DisplayObject, param2:Function, param3:Array) : void
      {
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:int = 0;
         var _loc6_:DisplayObject = null;
         if(param1 is DisplayObjectContainer)
         {
            _loc4_ = DisplayObjectContainer(param1);
            param2(param1,param3);
            _loc5_ = 0;
            while(_loc5_ < _loc4_.numChildren)
            {
               _loc6_ = _loc4_.getChildAt(_loc5_);
               CallForAllChildren(_loc6_,param2,param3);
               _loc5_++;
            }
         }
         else
         {
            param2(param1,param3);
         }
      }
      
      public static function fixLineSpacing(param1:TextField) : void
      {
         var _loc7_:int = 0;
         var _loc8_:* = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:Boolean = false;
         if(!languageHasLineSpaceIssues())
         {
            return;
         }
         var _loc2_:int = param1.numLines;
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:int = 0;
         var _loc6_:String = param1.text;
         if(param1.numLines > 1)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc2_)
            {
               _loc8_ = param1.getLineText(_loc7_);
               _loc8_ = _loc4_ + _loc8_;
               _loc5_ += _loc8_.length;
               _loc4_ = "";
               if(_loc7_ < _loc2_ - 1)
               {
                  _loc9_ = _loc6_.charCodeAt(_loc5_);
                  _loc10_ = _loc8_.substring(_loc8_.length - 1);
                  if(!(_loc11_ = CharacterUtil.isWhitespace(_loc9_) || _loc10_ == "\r" || _loc10_ == "\n"))
                  {
                     _loc4_ = _loc8_.substring(_loc8_.lastIndexOf(" ") + 1);
                     _loc8_ = (_loc8_ = _loc8_.substring(0,_loc8_.lastIndexOf(" "))) + "\r";
                  }
               }
               _loc3_ += _loc8_;
               _loc7_++;
            }
            if(_loc3_)
            {
               param1.text = _loc3_;
            }
         }
      }
   }
}
