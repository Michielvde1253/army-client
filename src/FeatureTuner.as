package
{
   public class FeatureTuner
   {
      
      private static const DROP_ALL_OPTIONAL_FEATURES:Boolean = false;
      
      public static const USE_RIVER_TILE_EFFECTS:Boolean = !DROP_ALL_OPTIONAL_FEATURES;
      
      public static const USE_CLOUD_EFFECTS:Boolean = !DROP_ALL_OPTIONAL_FEATURES;
      
      public static const USE_AIRPLANE_WEDGE_EFFECTS:Boolean = !DROP_ALL_OPTIONAL_FEATURES;
      
      public static const USE_SEA_WAVES_EFFECT:Boolean = !DROP_ALL_OPTIONAL_FEATURES;
      
      public static const USE_ALL_FIRE_CALL_SOUND:Boolean = !DROP_ALL_OPTIONAL_FEATURES;
      
      public static const USE_HARVEST_READY_ICON_EFFECT:Boolean = !DROP_ALL_OPTIONAL_FEATURES;
      
      public static const USE_MINE_EFFECTS:Boolean = !DROP_ALL_OPTIONAL_FEATURES;
      
      public static const USE_CHARACTER_DIALOQUE:Boolean = true;
      
      public static const USE_CHARACTER_DIALOQUE_EFFECTS:Boolean = !DROP_ALL_OPTIONAL_FEATURES;
      
      public static const USE_POPUP_OPENING_TRANSITION_EFFECT:Boolean = !DROP_ALL_OPTIONAL_FEATURES;
      
      public static const USE_POPUP_CLOSING_TRANSITION_EFFECT:Boolean = false;
      
      public static const USE_CITY_CELEBRATION_EFFECTS:Boolean = !DROP_ALL_OPTIONAL_FEATURES;
      
      public static const USE_LEVELUP_BACKGROUND_EFFECTS:Boolean = !DROP_ALL_OPTIONAL_FEATURES;
      
      public static const USE_CITY_PRODUCTION_SMOKE_EFFECT:Boolean = !DROP_ALL_OPTIONAL_FEATURES;
      
      public static const USE_PVP_MATCH:Boolean = !DROP_ALL_OPTIONAL_FEATURES;
      
      public static const USE_ROCKET_EFFECT:Boolean = true;
      
      public static const USE_SOUNDS:Boolean = true;
      
      public static const USE_LOW_SWF:Boolean = true;
      
      public static const USE_HARVEST_ANIMATION:Boolean = !DROP_ALL_OPTIONAL_FEATURES && !USE_LOW_SWF;
      
      public static const USE_FIRE_CALL_EFFECTS:Boolean = !DROP_ALL_OPTIONAL_FEATURES && !USE_LOW_SWF;
      
      public static const LOAD_TILE_MAP_CSV:Boolean = true;
      
      public static const USE_CAMERA_TRANSITION:Boolean = true;
      
      public static const USE_LIVE_BUILD_PRODUCTION:Boolean = Config.USE_LIVE_BUILD;
      
      public static const USE_GOOGLE_IN_APP_BILLING:Boolean = false;
      
      public static const USE_DEBUG_IN_APP_BILLING:Boolean = !USE_LIVE_BUILD_PRODUCTION;
      
      public static const USE_FACEBOOK_CONNECT:Boolean = false;
      
      public static const USE_FACEBOOK_DEBUG:Boolean = false;
      
      public static const USE_LOCAL_NOTIFICATION:Boolean = false;
      
      public static const USE_FLURRY_ANALYTICS:Boolean = false;
      
      public static const USE_FEDERAL_TRACKING:Boolean = false;
      
      public static const USE_RATEAPP_POPUP:Boolean = false;
      
      public static const USE_DEBUG_RATEAPP_POPUP:Boolean = false;
      
      public static const USE_COLLECTION_CARD:Boolean = false;
      
      public static const USE_ZOOM_IN_OUT:Boolean = true;
      
      public static const USE_MOUSE_FOR_PLACE_ITEMS:Boolean = true;
       
      
      public function FeatureTuner()
      {
         super();
      }
   }
}
