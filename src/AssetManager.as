package
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   
   public class AssetManager
   {
      
      public static const SKU_GFX:int = 0;
      
      public static const SKU_GFX_SWF_FILE:int = 1;
      
      public static const SKU:Array = new Array();
      
      public static const RES_IDS:Array = [];
      
      public static const SWF_IDS:Array = ["swf/tiles_common","swf/transitions","swf/interface","swf/popups_start"];
      
      public static const SWF_IDS_LOW:Array = ["swf/tiles_common","swf/transitions","swf/interface","swf/popups_start_low"];
      
      public static const SWF_IPHONE_IDS:Array = ["swf/tiles_common","swf/transitions","swf/interface_iphone","swf/popups_start_iphone"];
      
      public static const SWF_IPHONE_LOW_IDS:Array = ["swf/tiles_common","swf/transitions","swf/interface_iphone","swf/popups_start_iphone_low"];
      
      public static const NON_BLOCKING_SWF_IDS:Array = ["swf/popups_fullscreen","swf/popups_01","swf/popups_warnings","swf/main menu"];
      
      public static const NON_BLOCKING_SWF_LOW_IDS:Array = ["swf/popups_fullscreen","swf/popups_01_low","swf/popups_warnings_low","swf/main menu"];
      
      public static const NON_BLOCKING_SWF_IPHONE_IDS:Array = ["swf/popups_fullscreen_iphone","swf/popups_01_iphone","swf/popups_warnings_iphone","swf/main menu_iphone"];
      
      public static const NON_BLOCKING_SWF_IPHONE_LOW_IDS:Array = ["swf/popups_fullscreen_iphone","swf/popups_01_iphone_low","swf/popups_warnings_iphone","swf/main menu_iphone"];
      
      public static const TUTORIAL_SWF_IDS:Array = ["swf/intro"];
      
      public static const JSON_FILES_TO_LOAD:Array = ["army_config_base"];
      
      public static const CVS_FILES_TO_LOAD:Array = ["tile_map","map_2", "tile_map_desert", "pvp_map_1_4valleys_11x11"];
      
      private static var instance:AssetManager;
       
      
      public function AssetManager()
      {
         super();
      }
      
      public static function getInstance() : AssetManager
      {
         if(instance == null)
         {
            instance = new AssetManager();
         }
         return instance;
      }
      
      public static function addSku(param1:String, param2:Array) : void
      {
         SKU[param1] = param2;
      }
      
      public function getAssetByName(param1:String) : *
      {
         return new (this.getClassByName(param1))();
      }
      
      public function getClassByName(param1:String) : Class
      {
         var _loc2_:String = describeType(this).@name.toXMLString();
         var _loc3_:String = _loc2_ + "_" + param1;
         return getDefinitionByName(_loc3_) as Class;
      }
      
      public function getDisplayObjectFromSku(param1:String) : DisplayObject
      {
         if(SKU[param1] == null)
         {
            if(Config.DEBUG_MODE)
            {
            }
            return null;
         }
         var _loc2_:String = String(SKU[param1][SKU_GFX_SWF_FILE]);
         var _loc3_:String = String(SKU[param1][SKU_GFX]);
         var _loc4_:DisplayObject = null;
         if(_loc2_ == null)
         {
            _loc4_ = DCResourceManager.getInstance().get(_loc3_) as Sprite;
         }
         else if(_loc2_ == "constructor")
         {
            _loc4_ = getInstance().getAssetByName(_loc3_);
         }
         else
         {
            _loc4_ = new (DCResourceManager.getInstance().getSWFClass(_loc2_,_loc3_))();
         }
         _loc4_.name = param1;
         return _loc4_;
      }
   }
}
