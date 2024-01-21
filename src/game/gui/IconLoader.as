package game.gui
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class IconLoader
   {
       
      
      private var mPlaceholder:Sprite;
      
      private var mIcon:IconInterface;
      
      private var mCallback:Function;
      
      private var mPicURL:String;
      
      public function IconLoader(param1:Sprite, param2:IconInterface, param3:Function)
      {
         super();
         this.mPlaceholder = param1;
         this.mIcon = param2;
         this.mCallback = param3;
         param3 = null;
      }
      
      private static function fixSprite(param1:DisplayObject) : void
      {
         if(param1 is InteractiveObject)
         {
            InteractiveObject(param1).mouseEnabled = false;
         }
         else if(param1 is DisplayObjectContainer)
         {
            DisplayObjectContainer(param1).mouseChildren = false;
         }
         param1.scaleX = 1;
         param1.scaleY = 1;
         param1.x = -param1.width / 2;
         param1.y = -param1.height / 2;
      }
      
      public static function addIconPicture(param1:DisplayObjectContainer, param2:String, param3:Function = null, param4:Boolean = true) : MovieClip
      {
         var _loc6_:Sprite = null;
         var _loc7_:Class = null;
         var _loc8_:MovieClip = null;
         var _loc9_:IconLoader = null;
         var _loc5_:DCResourceManager = DCResourceManager.getInstance();
         if(param4)
         {
            Utils.removeAllChildren(param1);
         }
         if(_loc5_.isLoaded(param2))
         {
            _loc6_ = _loc5_.get(param2);
            fixSprite(_loc6_);
            param1.addChild(_loc6_);
            if(param3 != null)
            {
               param3(_loc6_);
            }
            return null;
         }
         _loc8_ = new (_loc7_ = _loc5_.getSWFClass(Config.SWF_INTERFACE_NAME,"icon_progress"))();
         if(param3 != null)
         {
            param3(_loc8_);
         }
         if(param1)
         {
            param1.addChild(_loc8_);
         }
         if(!_loc5_.isAddedToLoadingList(param2))
         {
            _loc5_.load(param2,param2,"Sprite",false);
         }
         _loc9_ = new IconLoader(_loc8_,null,param3);
         _loc5_.addEventListener(param2 + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE,_loc9_.IconPictureLoaded);
         _loc9_.mPicURL = param2;
         return _loc8_;
      }
      
      public static function addIcon(param1:DisplayObjectContainer, param2:IconInterface, param3:Function = null, param4:Boolean = true) : MovieClip
      {
         var _loc8_:MovieClip = null;
         var _loc9_:Class = null;
         var _loc10_:MovieClip = null;
         var _loc11_:IconLoader = null;
         var _loc5_:String = param2.getIconGraphics();
         var _loc6_:String;
         if(!(_loc6_ = param2.getIconGraphicsFile()))
         {
            return null;
         }
         if(_loc5_.indexOf(".png") >= 0)
         {
            return addIconPicture(param1,Config.DIR_DATA + _loc6_ + "/" + _loc5_,param3,param4);
         }
         var _loc7_:DCResourceManager = DCResourceManager.getInstance();
         if(param4)
         {
            Utils.removeAllChildren(param1);
         }
         if(_loc7_.isLoaded(_loc6_))
         {
            if(_loc8_ = param2.getIconMovieClip())
            {
               if(param1)
               {
                  param1.addChild(_loc8_);
               }
               if(param3 != null)
               {
                  param3(_loc8_);
               }
               return _loc8_;
            }
            return null;
         }
         _loc10_ = new (_loc9_ = _loc7_.getSWFClass(Config.SWF_INTERFACE_NAME,"icon_progress"))();
         if(param3 != null)
         {
            param3(_loc10_);
         }
         if(param1)
         {
            param1.addChild(_loc10_);
         }
         if(!_loc7_.isAddedToLoadingList(_loc6_))
         {
            _loc7_.load(Config.DIR_DATA + _loc6_ + ".swf",_loc6_,null,false);
         }
         _loc11_ = new IconLoader(_loc10_,param2,param3);
         _loc7_.addEventListener(_loc6_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE,_loc11_.IconFileLoaded);
         return _loc10_;
      }
      
      public function IconPictureLoaded(param1:Event) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc2_:DCResourceManager = DCResourceManager.getInstance();
         _loc2_.removeEventListener(param1.type,this.IconPictureLoaded);
         var _loc3_:DisplayObjectContainer = this.mPlaceholder.parent;
         if(_loc3_)
         {
            _loc3_.removeChild(this.mPlaceholder);
            if(_loc4_ = _loc2_.get(this.mPicURL))
            {
               if(_loc4_ is Sprite)
               {
                  fixSprite(_loc4_);
               }
               _loc3_.addChild(_loc4_);
               if(this.mCallback != null)
               {
                  this.mCallback(_loc4_);
               }
            }
         }
         this.mCallback = null;
         this.mPlaceholder = null;
      }
      
      public function IconFileLoaded(param1:Event) : void
      {
         var _loc3_:MovieClip = null;
         DCResourceManager.getInstance().removeEventListener(param1.type,this.IconFileLoaded);
         var _loc2_:DisplayObjectContainer = this.mPlaceholder.parent;
         if(_loc2_)
         {
            _loc2_.removeChild(this.mPlaceholder);
            _loc3_ = this.mIcon.getIconMovieClip();
            if(_loc3_)
            {
               _loc3_.x = this.mPlaceholder.x;
               _loc3_.y = this.mPlaceholder.y;
               _loc2_.addChild(_loc3_);
               if(this.mCallback != null)
               {
                  this.mCallback(_loc3_);
               }
            }
         }
         this.mCallback = null;
         this.mPlaceholder = null;
      }
   }
}
