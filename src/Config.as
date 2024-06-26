package
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.system.Capabilities;
   import flash.text.TextFormat;
   import game.states.GameState;
   import mx.utils.StringUtil;
   
   public class Config
   {
      
      public static var RESTART_STATUS:int = -1;
      
      public static var IS_FED_INITIALLIZED:Boolean = false;
      
      public static var IS_FB_INITIALLIZED:Boolean = true;
      
      public static var IS_PAYMENT_INITIALLIZED:Boolean = true;
      
      public static const EDITING_MODE:Boolean = false;
      
      public static const USE_WORLD_MAP:Boolean = false;
      
      public static const USE_LIVE_BUILD:Boolean = false;
      
      public static const USE_MAGIC_BOX_LIB:Boolean = false;
      
      public static var SERVER_URL:String = "http://server.armyattackreborn.com:16200/test/";
      
      public static var DIR_DATA:String = "../data/";
      
      public static var DIR_CONFIG:String = "../config/";
      
      public static var DIR_PICS:String = DIR_DATA + "graphics/";
      
      public static var DIR_SOUNDS:String = DIR_DATA + "sounds/";
      
      public static var APP_SECRET_KEY:String = "PreCr4c4";
      
      public static var ENABLE_SINGLE_BITMAP_FIELD_RENDERING:Boolean = true;
      
      public static const USE_FOG_DEFAULT_VALUE:Boolean = false;
      
      public static var DISABLE_FOG:Boolean = false;
      
      public static var USE_LOGIC_UPDATE_TRY_CATCH:Boolean = false;
      
      public static var DEBUG_MODE:Boolean = true;
      
      public static var DEBUG_MISSIONS:Boolean = false;
      
      public static var DISABLE_SORT:Boolean = false;
      
      public static const ENABLE_DAILY_REWARDS:Boolean = false;
      
      public static const DEBUG_VIEWERS:Boolean = false;
      
      public static const DEBUG_PATHFINDING:Boolean = false;
      
      public static const DEBUG_ENEMY_QUEUE_NUMBERS:Boolean = false;
      
      public static const DEBUG_SERVER_REQUEST:Boolean = false;
      
      public static const DEBUG_SERVER_DATA:Boolean = false;
      
      public static const CHEAT_ALLOWED:Boolean = false;
      
      public static const CHEAT_DISABLE_FOG:Boolean = false;
      
      public static const CHEAT_SKIP_TUTORIAL:Boolean = CHEAT_ALLOWED;
      
      public static const CHEAT_OPEN_ALL_MAPS:Boolean = CHEAT_ALLOWED;
      
      public static const CHEAT_GOD_MODE:Boolean = false;
      
      public static const CREATE_NEW_SESSION_IN_CLIENT:Boolean = false;
      
      public static var OFFLINE_MODE:Boolean = true;
      
      public static var OUTSIDE_FACEBOOK_MODE:Boolean;
      
      public static const DETAILED_ERROR_MSG_ENABLED:Boolean = true;
      
      public static const DETAILED_ERROR_MSG_CODE:String = "DETAILS";
      
      public static const DEBUG_ALLOWED:Boolean = true;
      
      public static const DEBUG_CODE:String = "DEBUG";
      
      public static const DEBUG_FPS:Boolean = false;
      
      public static const BUTTON_USE_HAND_CURSOR:Boolean = true;
      
      public static const CHECK_FOR_MISPLACED_DEBRIS:Boolean = true;
      
      public static const COOKIE_SETTINGS_NAME:String = "Settings";
      
      public static const COOKIE_SETTINGS_NAME_MUSIC:String = "Music";
      
      public static const COOKIE_SETTINGS_NAME_SFX:String = "Sfx";
      
      public static const COOKIE_SETTINGS_NAME_NOTIFICATION:String = "Notification";
      
      public static const COOKIE_SETTINGS_NAME_APPLAUNCH:String = "Applaunch";
      
      public static const COOKIE_SESSION_NAME:String = "Session";
      
      public static const COOKIE_SESSION_NAME_CAM_POS:String = "CameraPos";
      
      public static const COOKIE_SESSION_NAME_ZOOM_INDEX:String = "ZoomIndex";
      
      public static const COOKIE_SESSION_NAME_ASK_FLARE_ATTACK:String = "FlareAttack";
      
      public static const COOKIE_SESSION_NAME_ASK_FLARE_HEAL:String = "FlareHeal";
      
      public static const COOKIE_SESSION_NAME_ASK_FLARE_SUPPLIES:String = "FlareSupplies";
      
      public static const COOKIE_SESSION_NAME_ASK_ENERGY:String = "AskEnergy";
      
      public static const COOKIE_SESSION_NAME_ASK_SUPPLIES:String = "AskSupplies";
      
      public static const COOKIE_SESSION_NAME_ASK_MAP_RESOURCE:String = "AskMapResources";
      
      public static const COOKIE_SESSION_NAME_TUTOTRIAL_INDEX:String = "Tutorial";
      
      public static const COOKIE_APPRATER_NAME:String = "Apprater";
      
      public static const COOKIE_APPRATER_NAME_FIRST_LAUNCHED:String = "Firstlaunch";
      
      public static const COOKIE_APPRATER_NAME_LAUNCH_COUNT:String = "Launch_count";
      
      public static const COOKIE_APPRATER_NAME_DATE_FIRST_LAUNCHED:String = "Date_firstlaunch";
      
      public static const COOKIE_APPRATER_NAME_RATE_CLICKED:String = "Rateclicked";
      
      public static const COOKIE_APPRATER_NAME_REMINDER_PRESSED:String = "Remindclicked";
      
      public static const COOKIE_APPRATER_NAME_DATE_REMINDER_PRESSED:String = "Date_reminder_pressed";
      
      public static const COOKIE_APPRATER_NAME_APP_VERSION_CODE:String = "Versioncode";
      
      public static const COOKIE_APPRATER_NAME_REMINDER_COUNT:String = "Reminder_count";
      
      public static const COOKIE_APPRATER_NAME_DONT_SHOW:String = "Dontshow";
      
      public static var SCREEN_WIDTH:int = 0;
      
      public static var SCREEN_HEIGHT:int = 0;
      
      public static var SWF_INTERFACE_NAME:String = "swf/interface";
      
      public static var SWF_POPUPS_START_NAME:String = "swf/popups_start";
      
      public static var SWF_POPUPS_FULLSCREEN_NAME:String = "swf/popups_fullscreen";
      
      public static var SWF_POPUPS_01_NAME:String = "swf/popups_01";
      
      public static var SWF_POPUPS_WARNINGS_NAME:String = "swf/popups_warnings";
      
      public static var SWF_MAIN_MENU_NAME:String = "swf/main_menu";
      
      public static var SWF_EFFECTS_NAME:String = "swf/effects";
      
      public static const TEXT_FORMAT:TextFormat = new TextFormat("Arial",12,65535,true);
      
      public static var smLanguageCode:String;
      
      public static var smUserId:String;
      
      private static var mLoader:URLLoader;
      
      private static var mLoadingComplete:Boolean = true;
      
      public static var smSignedRequest:String;
      
      public static var smLoadingDescription:String = "Loading...";
      
      private static const DEFAULT_LANGUAGE:String = "en";
      
      private static const LANGUAGES:String = "en,de,fr,it,es";
      
      public static var FOR_IPHONE_PLATFORM:Boolean = false;
      
      public static var macAddress:String;
       
      
      public function Config()
      {
         super();
      }
      
      public static function getMacAddress() : void
      {
         macAddress = null;
      }
      
      public static function checkNetworkConnection() : void
      {
      }
      
      public static function getAppVersion() : String
      {
		return "1";
      }
      
      public static function init() : void
      {
         var _loc2_:Array = null;
         var _loc7_:String = null;
         if(DEBUG_MODE)
         {
         }
         getMacAddress();
         smUserId = null;
         smSignedRequest = null;
         SERVER_URL = "http://server.armyattackreborn.com:16200/test/";
         if(DEBUG_MODE)
         {
         }
         var _loc1_:String = LANGUAGES;
         var _loc3_:int = int((_loc2_ = _loc1_.split(",")).length);
         var _loc4_:String = Capabilities.language;
         var _loc8_:int = 0;
         while(_loc8_ < _loc3_)
         {
            if((_loc7_ = String(_loc2_[_loc8_])) == _loc4_)
            {
               smLanguageCode = _loc4_;
               break;
            }
            smLanguageCode = "en";
            _loc8_++;
         }
         SCREEN_WIDTH = GameState.mInstance.getStageWidth();
         SCREEN_HEIGHT = GameState.mInstance.getStageHeight();
         if(FeatureTuner.USE_LOW_SWF)
         {
            SWF_POPUPS_01_NAME = "swf/popups_01_low";
            SWF_POPUPS_START_NAME = "swf/popups_start_low";
            SWF_EFFECTS_NAME = "swf/effects_low";
            SWF_POPUPS_WARNINGS_NAME = "swf/popups_warnings_low";
         }
         if(FOR_IPHONE_PLATFORM)
         {
            SWF_INTERFACE_NAME = "swf/interface_iphone";
            SWF_POPUPS_START_NAME = "swf/popups_start_iphone";
            SWF_POPUPS_FULLSCREEN_NAME = "swf/popups_fullscreen_iphone";
            SWF_POPUPS_01_NAME = "swf/popups_01_iphone";
            SWF_POPUPS_WARNINGS_NAME = "swf/popups_warnings_iphone";
            SWF_MAIN_MENU_NAME = "swf/main menu_iphone";
            if(FeatureTuner.USE_LOW_SWF)
            {
               SWF_POPUPS_01_NAME = "swf/popups_01_iphone_low";
               SWF_POPUPS_START_NAME = "swf/popups_start_iphone_low";
            }
         }
         if(DEBUG_MODE)
         {
         }
         OUTSIDE_FACEBOOK_MODE = true;
         OFFLINE_MODE = true;
      }
      
      private static function loadConfigComplete(param1:Event) : void
      {
         smUserId = StringUtil.trim(mLoader.data["uid"]);
         DCResourceManager.getInstance().removeEventListener(Event.COMPLETE,loadConfigComplete);
         DCResourceManager.getInstance().removeEventListener(IOErrorEvent.IO_ERROR,configNotFound);
         mLoadingComplete = true;
      }
      
      private static function configNotFound(param1:Event) : void
      {
         DCResourceManager.getInstance().removeEventListener(Event.COMPLETE,loadConfigComplete);
         DCResourceManager.getInstance().removeEventListener(IOErrorEvent.IO_ERROR,configNotFound);
         if(!Config.OFFLINE_MODE)
         {
            throw new Error("config.txt is missing!");
         }
         mLoadingComplete = true;
      }
      
      public static function isLoadingcomplete() : Boolean
      {
         return mLoadingComplete;
      }
   }
}
