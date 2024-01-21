package
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import game.gui.IconAdapter;
   import game.gui.button.ArmyButton;
   import game.gui.button.ArmyButtonSelected;
   import game.gui.button.ResizingButton;
   import game.gui.button.ResizingButtonSelected;
   import game.gui.button.ResizingIconButton;
   import game.isometric.elements.WorldObject;
   
   public class Utils
   {
       
      
      public function Utils()
      {
         super();
      }
      
      public static function randRange(param1:Number, param2:Number) : Number
      {
         return Math.random() * (param2 - param1) + param1;
      }
      
      public static function createBasicButton(param1:DisplayObjectContainer, param2:String, param3:Function) : ArmyButton
      {
         var _loc4_:MovieClip;
         if(!(_loc4_ = param1.getChildByName(param2) as MovieClip))
         {
            return null;
         }
         _loc4_.mouseEnabled = true;
         return new ArmyButton(param1,_loc4_,DCButton.BUTTON_TYPE_OK,null,null,null,null,null,param3);
      }
      
      public static function createSelectableButton(param1:DisplayObjectContainer, param2:String, param3:Function) : ArmyButtonSelected
      {
         var _loc4_:MovieClip = null;
         (_loc4_ = param1.getChildByName(param2) as MovieClip).mouseEnabled = true;
         return new ArmyButtonSelected(param1,_loc4_,DCButton.BUTTON_TYPE_OK,null,null,param3,null,null,null);
      }
      
      public static function createResizingButton(param1:DisplayObjectContainer, param2:String, param3:Function) : ResizingButton
      {
         var _loc4_:MovieClip;
         (_loc4_ = param1.getChildByName(param2) as MovieClip).mouseEnabled = true;
         return new ResizingButton(param1,_loc4_,DCButton.BUTTON_TYPE_OK,null,null,null,null,null,param3);
      }
      
      public static function createFBIconResizingButton(param1:DisplayObjectContainer, param2:String, param3:Function) : ResizingIconButton
      {
         var _loc4_:MovieClip = null;
         (_loc4_ = param1.getChildByName(param2) as MovieClip).mouseEnabled = true;
         var _loc5_:IconAdapter = new IconAdapter("icon_share","swf/objects_01");
         var _loc6_:ResizingIconButton;
         (_loc6_ = new ResizingIconButton(param1,_loc4_,DCButton.BUTTON_TYPE_OK,null,null,null,null,null,param3)).setIcon(_loc5_);
         return _loc6_;
      }
      
      public static function createResizingIconButton(param1:DisplayObjectContainer, param2:String, param3:Function) : ResizingIconButton
      {
         var _loc4_:MovieClip = null;
         (_loc4_ = param1.getChildByName(param2) as MovieClip).mouseEnabled = true;
         return new ResizingIconButton(param1,_loc4_,DCButton.BUTTON_TYPE_OK,null,null,null,null,null,param3);
      }
      
      public static function createResizingButtonSelected(param1:DisplayObjectContainer, param2:String, param3:Function) : ResizingButtonSelected
      {
         var _loc4_:MovieClip;
         (_loc4_ = param1.getChildByName(param2) as MovieClip).mouseEnabled = true;
         return new ResizingButtonSelected(param1,_loc4_,DCButton.BUTTON_TYPE_OK,null,null,null,null,null,param3);
      }
      
      public static function createResizingButtonSelectedForNewUI(param1:DisplayObjectContainer, param2:String, param3:Function) : ResizingButtonSelected
      {
         var _loc4_:MovieClip;
         (_loc4_ = param1.getChildByName(param2) as MovieClip).mouseEnabled = false;
         return new ResizingButtonSelected(param1,_loc4_,DCButton.BUTTON_TYPE_OK,null,null,null,null,null,param3);
      }
      
      public static function getRandVec(param1:Vector3D) : Vector3D
      {
         return new Vector3D((Math.random() - 0.5) * param1.x,(Math.random() - 0.5) * param1.y,(Math.random() - 0.5) * param1.z,(Math.random() - 0.5) * param1.w);
      }
      
      public static function sq(param1:Number) : Number
      {
         return param1 * param1;
      }
      
      public static function getTileDistSq(param1:WorldObject, param2:WorldObject) : Number
      {
         return sq(param1.mX - param2.mX) / sq(param1.mScene.mGridDimX) + sq(param1.mY - param2.mY) / sq(param1.mScene.mGridDimY);
      }
      
      public static function DrawBitmap(param1:MovieClip, param2:BitmapData, param3:Point, param4:Number = 1, param5:Boolean = false) : void
      {
         var _loc6_:Matrix;
         (_loc6_ = new Matrix(param4,0,0,param4)).tx = param3.x * param4;
         _loc6_.ty = param3.y * param4;
         if(param5)
         {
            _loc6_.a *= -1;
            _loc6_.tx *= -1;
         }
         param1.graphics.beginBitmapFill(param2,_loc6_,false,false);
         param1.graphics.drawRect(param3.x * param4,param3.y * param4,param2.width * param4,param2.height * param4);
         param1.graphics.endFill();
      }
      
      public static function PrintLabels(param1:MovieClip) : void
      {
         var _loc3_:Object = null;
         var _loc2_:int = int(param1.currentLabels.length);
         if(_loc2_ == 0)
         {
            return;
         }
         var _loc4_:int = int(param1.currentLabels.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = param1.currentLabels[_loc5_] as Object;
            _loc5_++;
         }
      }
      
      public static function RotatePoint(param1:Point, param2:int) : void
      {
         var _loc3_:int = 0;
         switch(param2)
         {
            case 0:
               break;
            case 1:
               _loc3_ = param1.x;
               param1.x = param1.y;
               param1.y = _loc3_;
               break;
            case 2:
               param1.x = -param1.x + 1;
               param1.y = param1.y;
               break;
            case 3:
               _loc3_ = -param1.x;
               param1.x = param1.y;
               param1.y = _loc3_ + 1;
         }
      }
      
      public static function PrintHierarchy(param1:DisplayObject, param2:Object = null, param3:int = 0) : void
      {
         var _loc6_:int = 0;
         var _loc7_:DisplayObjectContainer = null;
         var _loc8_:int = 0;
         var _loc9_:DisplayObject = null;
         var _loc4_:* = "";
         if(param1 == null)
         {
            _loc6_ = 0;
            while(_loc6_ < param3)
            {
               _loc4_ += "\t";
               _loc6_++;
            }
            return;
         }
         var _loc5_:int = 0;
         while(_loc5_ < param3)
         {
            _loc4_ += "\t";
            _loc5_++;
         }
         _loc4_ = _loc4_ + param1 + " " + param1.name;
         if(param1 is DisplayObjectContainer)
         {
            _loc7_ = param1 as DisplayObjectContainer;
            _loc4_ = _loc4_ + " ME: " + _loc7_.mouseEnabled + " MC: " + _loc7_.mouseChildren;
            if(param2 != null)
            {
               _loc4_ = _loc4_ + " " + param2 + ": " + _loc7_[param2];
            }
            if(_loc7_ is MovieClip)
            {
               _loc4_ = _loc4_ + " HitArea: " + (_loc7_ as MovieClip).hitArea;
            }
            _loc8_ = 0;
            while(_loc8_ < _loc7_.numChildren)
            {
               _loc9_ = _loc7_.getChildAt(_loc8_);
               PrintHierarchy(_loc9_,param2,param3 + 1);
               _loc8_++;
            }
         }
      }
      
      public static function HasLabel(param1:MovieClip, param2:String) : Boolean
      {
         var _loc3_:Object = null;
         var _loc4_:int = int(param1.currentLabels.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = param1.currentLabels[_loc5_] as Object;
            if(_loc3_.name == param2)
            {
               return true;
            }
            _loc5_++;
         }
         return false;
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
      
      public static function stopMovieClip(param1:DisplayObject, param2:Array) : void
      {
         if(param1 is MovieClip)
         {
            (param1 as MovieClip).gotoAndStop(0);
         }
      }
      
      public static function disableMouse(param1:DisplayObject, param2:Array) : void
      {
         if(param1 is DisplayObjectContainer)
         {
            (param1 as DisplayObjectContainer).mouseEnabled = false;
         }
      }
      
      public static function LogError(param1:String) : void
      {
         var _loc2_:* = "\n----------------------------------------------------------------------\n";
         var _loc3_:Error = new Error();
         _loc2_ += _loc3_.getStackTrace();
         _loc2_ += "\n\n\t";
         _loc2_ += param1;
         _loc2_ += "\n----------------------------------------------------------------------\n";
      }
      
      public static function SortPoints(param1:Array, param2:Number, param3:Number) : Array
      {
         var _loc5_:Point = null;
         var _loc8_:Point = null;
         var _loc4_:Array = new Array();
         var _loc6_:int = int(param1.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_ = param1[_loc7_] as Point;
            _loc4_.push(new Point(_loc5_.x - param2,_loc5_.y - param3));
            _loc7_++;
         }
         var _loc9_:int = int((_loc4_ = _loc4_.sortOn("length",Array.NUMERIC)).length);
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            _loc8_ = _loc4_[_loc10_] as Point;
            _loc8_.x += param2;
            _loc8_.y += param3;
            _loc10_++;
         }
         return _loc4_;
      }
      
      public static function UnitTests() : void
      {
         var _loc1_:Array = new Array();
         _loc1_.push(new Point(10,20));
         _loc1_.push(new Point(50,20));
         _loc1_.push(new Point(20,20));
         var _loc2_:Array = SortPoints(_loc1_,10,20);
      }
      
      public static function removeFromParent(param1:DisplayObject) : void
      {
         if(Boolean(param1) && Boolean(param1.parent))
         {
            param1.parent.removeChild(param1);
            param1 = null;
         }
      }
      
      public static function setText(param1:TextField, param2:String) : void
      {
         var _loc3_:int = param1.text.length;
         param1.appendText(param2);
         param1.replaceText(0,_loc3_,"");
      }
      
      public static function removeAllChildren(param1:DisplayObjectContainer) : void
      {
         if(param1)
         {
            while(param1.numChildren > 0)
            {
               param1.removeChildAt(0);
            }
            param1 = null;
         }
      }
      
      public static function addSwfToResourceManager(param1:Array, param2:Boolean = false, param3:Boolean = true) : void
      {
         var _loc4_:DCResourceManager = DCResourceManager.getInstance();
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc4_.load(Config.DIR_DATA + param1[_loc5_] + ".swf",param1[_loc5_],null,param3,param2);
            _loc5_++;
         }
      }
      
      public static function scaleIcon(param1:Sprite, param2:int, param3:int) : void
      {
         var _loc4_:Rectangle = null;
         var _loc5_:Bitmap = null;
         if(param1)
         {
            if(param1.numChildren >= 0 && param1.getChildAt(0) is Bitmap)
            {
               (_loc5_ = param1.getChildAt(0) as Bitmap).smoothing = true;
            }
            if(param1.width > param2 || param1.height > param3)
            {
               param1.width = param2;
               param1.height = param3;
               param1.scaleY = Math.min(param1.scaleX,param1.scaleY);
               param1.scaleX = param1.scaleX;
            }
            _loc4_ = param1.getBounds(param1);
            param1.x = -(_loc4_.left + _loc4_.right) * param1.scaleX / 2;
            param1.y = -(_loc4_.bottom + _loc4_.top) * param1.scaleY / 2;
         }
      }
      
      public static function lowerFontToMatchTextField(param1:TextField) : void
      {
         var _loc2_:TextFormat = null;
         if(param1)
         {
            _loc2_ = param1.getTextFormat();
            param1.wordWrap = false;
            while(param1.textWidth > param1.width)
            {
               _loc2_.size = (_loc2_.size as int) - 1;
               param1.defaultTextFormat = _loc2_;
            }
            if(_loc2_.align == TextFormatAlign.CENTER)
            {
               param1.x -= 5;
            }
            else if(_loc2_.align == TextFormatAlign.RIGHT)
            {
               param1.x -= 10;
            }
            param1.width += 10;
         }
      }
   }
}
