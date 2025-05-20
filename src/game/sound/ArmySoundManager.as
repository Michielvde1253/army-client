package game.sound
{
   import com.dchoc.utils.Cookie;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundLoaderContext;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import game.states.GameState;
   
   public class ArmySoundManager
   {
      
      private static const SOUND_INITIAL_VOLUME:Number = 1;
      
      public static const TYPE_MUSIC:int = 0;
      
      public static const TYPE_SFX:int = 1;
      
      private static var mInstance:ArmySoundManager;
      
      private static var mAllowInstance:Boolean;
      
      public static var smLoadedSounds:Array = new Array();
      
      public static const MUSIC_HOME:String = "music/army_mus_bg1.mp3";
      
      public static const MUSIC_INTRO:String = "music/army_mus_intro.mp3";
      
      public static const SFX_UI_BUILDING_CONSTRUCT:String = "sound/Building_sounds/building_construction.mp3";
      
      public static const SFX_UI_NEW_UNIT_PLACED:String = "sound/PopUp_sounds/new_unit_placed.mp3";
      
      public static const SFX_UI_NEW_RANK:String = "sound/PopUp_sounds/new_rank.mp3";
      
      public static const SFX_UI_LEVEL_UP:String = "sound/PopUp_sounds/level_up.mp3";
      
      public static const SFX_UI_CITY_LIBERATED:String = "sound/PopUp_sounds/city_liberated.mp3";
      
      public static const SFX_UI_AREA_UNLOCK:String = "sound/PopUp_sounds/area_unlocked.mp3";
      
      public static const SFX_UI_CLICK:String = "sound/UI_sounds/button_press.mp3";
      
      public static const SFX_UI_HARVEST:String = "sound/UI_sounds/button_press.mp3";
      
      public static const SFX_UI_CLEAN:String = "sound/UI_sounds/button_press.mp3";
      
      public static const SFX_UI_ERROR:String = "sound/UI_sounds/error.mp3";
      
      public static const SFX_UI_COLLECT:String = "sound/UI_sounds/collect_1st_item.mp3";
      
      public static const SFX_UI_ENERGY_BOOST:String = "sound/UI_sounds/energy_boost.mp3";
      
      public static const SFX_UI_BUY_PREMIUM:String = "sound/UI_sounds/goldbars_bought.mp3";
      
      public static const SFX_UI_BUY_ITEM:String = "sound/UI_sounds/item_bought.mp3";
      
      public static const SFX_UI_PLACE_ITEM:String = "sound/UI_sounds/item_placed.mp3";
      
      public static const SFX_UI_SELL_ITEM:String = "sound/UI_sounds/item_sold.mp3";
      
      public static const SFX_UI_REPAIR:String = "sound/UI_sounds/unit_repair.mp3";
      
      private static const mMandatorySounds:Array = [SFX_UI_BUILDING_CONSTRUCT,SFX_UI_NEW_UNIT_PLACED,SFX_UI_NEW_RANK,SFX_UI_LEVEL_UP,SFX_UI_CITY_LIBERATED,SFX_UI_AREA_UNLOCK,SFX_UI_CLICK,SFX_UI_HARVEST,SFX_UI_CLEAN,SFX_UI_ERROR,SFX_UI_COLLECT,SFX_UI_ENERGY_BOOST,SFX_UI_BUY_PREMIUM,SFX_UI_BUY_ITEM,SFX_UI_PLACE_ITEM,SFX_UI_SELL_ITEM,SFX_UI_REPAIR];
      
      private static const SFX_FM_MORTAR:String = "sound/Units/firemission_friendlyattack.mp3";
      
      private static const SFX_FM_NAPALM:String = "sound/Units/firemission_napalmstrike.mp3";
      
      private static const SFX_FM_ARTILLERY:String = "sound/Units/firemission_artillerystrike.mp3";
      
      private static const SFX_FM_DOOMSDAY:String = "sound/Units/firemission_DOOMSDAY.mp3";
      
      private static const SFX_FRN_VEHICLE_SELECT_LONG_1:String = "sound/Units/Vehicle_General/vehicle_general_select_long1.mp3";
      
      private static const SFX_FRN_VEHICLE_SELECT_LONG_2:String = "sound/Units/Vehicle_General/vehicle_general_select_long2.mp3";
      
      private static const SFX_FRN_APC_ATTACK_1:String = "sound/Units/APC/APC_attack.mp3";
      
      private static const SFX_FRN_APC_DEATH_1:String = "sound/Units/APC/APC_death.mp3";
      
      private static const SFX_FRN_APC_MOVING_1:String = "sound/Units/APC/APC_moving.mp3";
      
      private static const SFX_ENM_APC_ATTACK_1:String = "sound/Units/APC_Enemy/APC_enemy_attack.mp3";
      
      private static const SFX_ENM_APC_DEATH_1:String = "sound/Units/APC_Enemy/APC_enemy_death.mp3";
      
      private static const SFX_FRN_ARTILLERY_ATTACK_1:String = "sound/Units/Artillery/artillery_attack.mp3";
      
      private static const SFX_FRN_ARTILLERY_DEATH_1:String = "sound/Units/Artillery/artillery_death.mp3";
      
      private static const SFX_FRN_ARTILLERY_MOVING_1:String = "sound/Units/Artillery/artillery_moving.mp3";
      
      private static const SFX_ENM_ARTILLERY_ATTACK_1:String = "sound/Units/Artillery_Enemy/artillery_enemy_attack.mp3";
      
      private static const SFX_ENM_ARTILLERY_DEATH_1:String = "sound/Units/Artillery_Enemy/artillery_enemy_death.mp3";
      
      private static const SFX_FRN_COMMANDO_ATTACK_1:String = "sound/Units/Commando/commando_attack.mp3";
      
      private static const SFX_FRN_COMMANDO_DEATH_1:String = "sound/Units/Commando/commando_death.mp3";
      
      private static const SFX_FRN_COMMANDO_SELECT_LONG_1:String = "sound/Units/Commando/commando_select_long.mp3";
      
      private static const SFX_FRN_COMMANDO_SELECT_SHORT_1:String = "sound/Units/Commando/commando_select_short1.mp3";
      
      private static const SFX_FRN_COMMANDO_SELECT_SHORT_2:String = "sound/Units/Commando/commando_select_short2.mp3";
      
      private static const SFX_FRN_COMMANDO_SELECT_SHORT_3:String = "sound/Units/Commando/commando_select_short3.mp3";
      
      private static const SFX_FRN_COMMANDO_SELECT_SHORT_4:String = "sound/Units/Commando/commando_select_short4.mp3";
      
      private static const SFX_ENM_COMMANDO_ATTACK_1:String = "sound/Units/Commando_Enemy/commando_enemy_attack.mp3";
      
      private static const SFX_ENM_COMMANDO_DEATH_1:String = "sound/Units/Commando_Enemy/commando_enemy_death.mp3";
      
      private static const SFX_FRN_INF_ATTACK_1A:String = "sound/Units/Infantry/infantry_attack_1a.mp3";
      
      private static const SFX_FRN_INF_ATTACK_2A:String = "sound/Units/Infantry/infantry_attack_2a.mp3";
      
      private static const SFX_FRN_INF_ATTACK_2B:String = "sound/Units/Infantry/infantry_attack_2b.mp3";
      
      private static const SFX_FRN_INF_MOVING:String = "sound/Units/Infantry/infantry_move.mp3";
      
      private static const SFX_FRN_INF_DEATH_1:String = "sound/Units/Infantry/infantry_death.mp3";
      
      private static const SFX_FRN_INF_SELECT_LONG_1:String = "sound/Units/Infantry/infantry_select_long.mp3";
      
      private static const SFX_FRN_INF_SELECT_SHORT_1:String = "sound/Units/Infantry/infantry_select_short1.mp3";
      
      private static const SFX_FRN_INF_SELECT_SHORT_2:String = "sound/Units/Infantry/infantry_select_short2.mp3";
      
      private static const SFX_FRN_INF_SELECT_SHORT_3:String = "sound/Units/Infantry/infantry_select_short3.mp3";
      
      private static const SFX_FRN_INF_SELECT_SHORT_4:String = "sound/Units/Infantry/infantry_select_short4.mp3";
      
      private static const SFX_FRN_INF_SELECT_SHORT_5:String = "sound/Units/Infantry/infantry_select_short5.mp3";
      
      private static const SFX_FRN_INF_SELECT_SHORT_6:String = "sound/Units/Infantry/infantry_select_short6.mp3";
      
      private static const SFX_FRN_INF_SELECT_SHORT_7:String = "sound/Units/Infantry/infantry_select_short7.mp3";
      
      private static const SFX_ENM_INF_ATTACK_1A:String = "sound/Units/Infantry_Enemy/infantry_enemy_attack_1a.mp3";
      
      private static const SFX_ENM_INF_ATTACK_2A:String = "sound/Units/Infantry_Enemy/infantry_enemy_attack_2a.mp3";
      
      private static const SFX_ENM_INF_ATTACK_2B:String = "sound/Units/Infantry_Enemy/infantry_enemy_attack_2b.mp3";
      
      private static const SFX_ENM_INF_DEATH_1:String = "sound/Units/Infantry_Enemy/infantry_enemy_death1.mp3";
      
      private static const SFX_ENM_INF_DEATH_2:String = "sound/Units/Infantry_Enemy/infantry_enemy_death2.mp3";
      
      private static const SFX_ENM_ALERT_1:String = "sound/UI_sounds/enemy_action_alert1.mp3";
      
      private static const SFX_ENM_ALERT_2:String = "sound/UI_sounds/enemy_action_alert2.mp3";
      
      private static const SFX_ENM_ALERT_3:String = "sound/UI_sounds/enemy_action_alert3.mp3";
      
      private static const SFX_ENM_ALERT_4:String = "sound/UI_sounds/enemy_action_alert4.mp3";
      
      private static const SFX_ENM_MISSILE_ATTACK_1:String = "sound/Units/Missile_Launcher_Enemy/missile_launcher_enemy_attack.mp3";
      
      private static const SFX_ENM_MISSILE_DEATH_1:String = "sound/Units/Missile_Launcher_Enemy/missile_launcher_enemy_death.mp3";
      
      private static const SFX_FRN_ROCKET_ATTACK_1:String = "sound/Units/Rocket_Battery/rocket_battery_attack.mp3";
      
      private static const SFX_FRN_ROCKET_DEATH_1:String = "sound/Units/Rocket_Battery/rocket_battery_death.mp3";
      
      private static const SFX_FRN_TANK_ATTACK_1:String = "sound/Units/Tank/tank_attack.mp3";
      
      private static const SFX_FRN_TANK_DEATH_1:String = "sound/Units/Tank/tank_death.mp3";
      
      private static const SFX_FRN_TANK_MOVING_1:String = "sound/Units/Tank/tank_moving.mp3";
      
      private static const SFX_ENM_TANK_ATTACK_1:String = "sound/Units/Tank_Enemy/tank_enemy_attack.mp3";
      
      private static const SFX_ENM_TANK_DEATH_1:String = "sound/Units/Tank_Enemy/tank_enemy_death.mp3";
      
      private static const SFX_ENM_SNIPER_SHOOT_1:String = "sound/Building_sounds/sniper_enemy1.mp3";
      
      private static const SFX_ENM_SNIPER_SHOOT_2:String = "sound/Building_sounds/sniper_enemy2.mp3";
      
      private static const SFX_FRN_BUILDING_EXPLODE_1:String = "sound/Building_sounds/building_destroyed.mp3";
      
      private static const SFX_ENM_BUILDING_EXPLODE_1:String = "sound/Building_sounds/enemy_building_destroyed.mp3";
      
      private static const SFX_HELI:String = "sound/Units/osprey_helicopter.mp3";
      
      private static const SFX_PLANE:String = "sound/Units/osprey_plane.mp3";
      
      private static const SFX_PLACEHOLDER_EXPLODE:String = SFX_ENM_BUILDING_EXPLODE_1;
      
      private static const SFX_PLACEHOLDER_ATTACK:String = SFX_FRN_INF_ATTACK_1A;
      
      private static const SFX_PLACEHOLDER_SELECT:String = SFX_FRN_INF_SELECT_SHORT_1;
      
      private static const SFX_PLACEHOLDER_DEATH:String = SFX_FRN_INF_DEATH_1;
      
      private static const SFX_PLACEHOLDER_VEHICLE_MOVING:String = SFX_FRN_APC_MOVING_1;
      
      public static const SC_ENM_SNIPER_SHOOT:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_ATTACK,[SFX_ENM_SNIPER_SHOOT_1,SFX_ENM_SNIPER_SHOOT_2]);
      
      public static const SC_ENM_BUILDING_EXPLOSION:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_EXPLODE,[SFX_ENM_BUILDING_EXPLODE_1]);
      
      public static const SC_FRN_BUILDING_EXPLOSION:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_EXPLODE,[SFX_FRN_BUILDING_EXPLODE_1]);
      
      public static const SC_EMPTY:SoundCollection = new SoundCollection(null,null);
      
      public static const SC_ENM_ALERT:SoundCollection = new SoundCollection(SFX_ENM_ALERT_1,[SFX_ENM_ALERT_1,SFX_ENM_ALERT_2,SFX_ENM_ALERT_3,SFX_ENM_ALERT_4]);
      
      public static const SC_ENM_ATTACK_SECONDARY:SoundCollection = new SoundCollection(SFX_FRN_INF_ATTACK_1A,[SFX_ENM_INF_ATTACK_2A,SFX_ENM_INF_ATTACK_2B]);
      
      public static const SC_FRN_ATTACK_SECONDARY:SoundCollection = new SoundCollection(SFX_FRN_INF_ATTACK_1A,[SFX_FRN_INF_ATTACK_2A,SFX_FRN_INF_ATTACK_2B]);
      
      public static const SC_GENERAL_VEHICLE_SELECT_LONG:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_SELECT,[SFX_FRN_VEHICLE_SELECT_LONG_1,SFX_FRN_VEHICLE_SELECT_LONG_2]);
      
      public static const SC_GENERAL_SELECT_SHORT:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_SELECT,[SFX_FRN_INF_SELECT_SHORT_1,SFX_FRN_INF_SELECT_SHORT_2,SFX_FRN_INF_SELECT_SHORT_3,SFX_FRN_INF_SELECT_SHORT_4,SFX_FRN_INF_SELECT_SHORT_5,SFX_FRN_INF_SELECT_SHORT_6,SFX_FRN_INF_SELECT_SHORT_7]);
      
      public static const SC_GENERAL_VEHICLE_MOVING:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_VEHICLE_MOVING,[SFX_PLACEHOLDER_VEHICLE_MOVING]);
      
      public static const SC_GENERAL_INFANTRY_MOVING:SoundCollection = new SoundCollection(SFX_FRN_INF_MOVING,[SFX_FRN_INF_MOVING]);
      
      public static const SC_FRN_APC_SELECT_LONG:SoundCollection = SC_GENERAL_VEHICLE_SELECT_LONG;
      
      public static const SC_FRN_APC_SELECT_SHORT:SoundCollection = SC_GENERAL_SELECT_SHORT;
      
      public static const SC_APC_MOVING:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_VEHICLE_MOVING,[SFX_FRN_APC_MOVING_1]);
      
      public static const SC_FRN_APC_ATTACK:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_ATTACK,[SFX_FRN_APC_ATTACK_1]);
      
      public static const SC_FRN_APC_DEATH:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_DEATH,[SFX_FRN_APC_DEATH_1]);
      
      public static const SC_ENM_APC_ATTACK:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_ATTACK,[SFX_ENM_APC_ATTACK_1]);
      
      public static const SC_ENM_APC_DEATH:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_DEATH,[SFX_ENM_APC_DEATH_1]);
      
      public static const SC_FRN_ARTILLERY_SELECT_LONG:SoundCollection = SC_GENERAL_VEHICLE_SELECT_LONG;
      
      public static const SC_FRN_ARTILLERY_SELECT_SHORT:SoundCollection = SC_GENERAL_SELECT_SHORT;
      
      public static const SC_ARTILLERY_MOVING:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_VEHICLE_MOVING,[SFX_FRN_ARTILLERY_MOVING_1]);
      
      public static const SC_FRN_ARTILLERY_ATTACK:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_ATTACK,[SFX_FRN_ARTILLERY_ATTACK_1]);
      
      public static const SC_FRN_ARTILLERY_DEATH:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_DEATH,[SFX_FRN_ARTILLERY_DEATH_1]);
      
      public static const SC_ENM_ARTILLERY_ATTACK:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_ATTACK,[SFX_ENM_ARTILLERY_ATTACK_1]);
      
      public static const SC_ENM_ARTILLERY_DEATH:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_DEATH,[SFX_ENM_ARTILLERY_DEATH_1]);
      
      public static const SC_FRN_COMMANDO_SELECT_LONG:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_SELECT,[SFX_FRN_COMMANDO_SELECT_LONG_1]);
      
      public static const SC_FRN_COMMANDO_SELECT_SHORT:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_SELECT,[SFX_FRN_COMMANDO_SELECT_SHORT_1,SFX_FRN_COMMANDO_SELECT_SHORT_2,SFX_FRN_COMMANDO_SELECT_SHORT_3,SFX_FRN_COMMANDO_SELECT_SHORT_4]);
      
      public static const SC_FRN_COMMANDO_ATTACK:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_ATTACK,[SFX_FRN_COMMANDO_ATTACK_1]);
      
      public static const SC_FRN_COMMANDO_DEATH:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_DEATH,[SFX_FRN_COMMANDO_DEATH_1]);
      
      public static const SC_ENM_COMMANDO_ATTACK:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_ATTACK,[SFX_ENM_COMMANDO_ATTACK_1]);
      
      public static const SC_ENM_COMMANDO_DEATH:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_DEATH,[SFX_ENM_COMMANDO_DEATH_1]);
      
      public static const SC_FRN_INF_SELECT_LONG:SoundCollection = new SoundCollection(SFX_FRN_INF_SELECT_SHORT_1,[SFX_FRN_INF_SELECT_LONG_1]);
      
      public static const SC_FRN_INF_SELECT_SHORT:SoundCollection = new SoundCollection(SFX_FRN_INF_SELECT_SHORT_1,[SFX_FRN_INF_SELECT_SHORT_1,SFX_FRN_INF_SELECT_SHORT_2,SFX_FRN_INF_SELECT_SHORT_3,SFX_FRN_INF_SELECT_SHORT_4,SFX_FRN_INF_SELECT_SHORT_5,SFX_FRN_INF_SELECT_SHORT_6,SFX_FRN_INF_SELECT_SHORT_7]);
      
      public static const SC_FRN_INF_DIE:SoundCollection = new SoundCollection(SFX_FRN_INF_DEATH_1,[SFX_FRN_INF_DEATH_1]);
      
      public static const SC_FRN_INF_ATTACK:SoundCollection = new SoundCollection(SFX_FRN_INF_ATTACK_1A,[SFX_FRN_INF_ATTACK_1A,SFX_FRN_INF_ATTACK_2A]);
      
      public static const SC_ENM_INF_DEATH:SoundCollection = new SoundCollection(SFX_FRN_INF_DEATH_1,[SFX_ENM_INF_DEATH_1,SFX_ENM_INF_DEATH_2]);
      
      public static const SC_ENM_INF_ATTACK:SoundCollection = new SoundCollection(SFX_FRN_INF_ATTACK_1A,[SFX_ENM_INF_ATTACK_1A,SFX_ENM_INF_ATTACK_2A]);
      
      public static const SC_MISSILE_MOVING:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_VEHICLE_MOVING,[SFX_PLACEHOLDER_VEHICLE_MOVING]);
      
      public static const SC_ENM_MISSILE_ATTACK:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_ATTACK,[SFX_ENM_MISSILE_ATTACK_1]);
      
      public static const SC_ENM_MISSILE_DEATH:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_DEATH,[SFX_ENM_MISSILE_DEATH_1]);
      
      public static const SC_ROCKET_SELECT_LONG:SoundCollection = SC_GENERAL_VEHICLE_SELECT_LONG;
      
      public static const SC_ROCKET_SELECT_SHORT:SoundCollection = SC_GENERAL_SELECT_SHORT;
      
      public static const SC_ROCKET_MOVING:SoundCollection = SC_GENERAL_VEHICLE_MOVING;
      
      public static var SC_ROCKET_ATTACK:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_ATTACK,[SFX_FRN_ROCKET_ATTACK_1]);
      
      public static var SC_ROCKET_DEATH:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_DEATH,[SFX_FRN_ROCKET_DEATH_1]);
      
      public static var SC_FRN_TANK_SELECT_LONG:SoundCollection = SC_GENERAL_VEHICLE_SELECT_LONG;
      
      public static var SC_FRN_TANK_SELECT_SHORT:SoundCollection = SC_GENERAL_SELECT_SHORT;
      
      public static var SC_TANK_MOVING:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_VEHICLE_MOVING,[SFX_FRN_TANK_MOVING_1]);
      
      public static var SC_FRN_TANK_ATTACK:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_ATTACK,[SFX_FRN_TANK_ATTACK_1]);
      
      public static var SC_FRN_TANK_DEATH:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_DEATH,[SFX_FRN_TANK_DEATH_1]);
      
      public static var SC_ENM_TANK_ATTACK:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_ATTACK,[SFX_ENM_TANK_ATTACK_1]);
      
      public static var SC_ENM_TANK_DEATH:SoundCollection = new SoundCollection(SFX_PLACEHOLDER_DEATH,[SFX_ENM_TANK_DEATH_1]);
      
      public static var SC_HELI:SoundCollection = new SoundCollection(SFX_HELI,[SFX_HELI]);
      
      public static var SC_PLANE:SoundCollection = new SoundCollection(SFX_PLANE,[SFX_PLANE]);
      
      public static var SC_FIRE_MISSION_ARTILLERY:SoundCollection = new SoundCollection(SFX_FM_MORTAR,[SFX_FM_ARTILLERY]);
      
      public static var SC_FIRE_MISSION_MORTAR:SoundCollection = new SoundCollection(SFX_FM_MORTAR,[SFX_FM_MORTAR]);
      
      public static var SC_FIRE_MISSION_NAPALM:SoundCollection = new SoundCollection(SFX_FM_MORTAR,[SFX_FM_NAPALM]);
      
      public static var SC_FIRE_MISSION_DOOMSDAY:SoundCollection = new SoundCollection(SFX_FM_MORTAR,[SFX_FM_DOOMSDAY]);
       
      
      private var mMusicOn:Boolean;
      
      private var mSfxOn:Boolean;
      
      private var mSoundsDictionary:Array;
      
      private var mSounds:Array;
      
      private var mEnableCookies:Boolean = true;
      
      public function ArmySoundManager()
      {
         super();
         if(!ArmySoundManager.mAllowInstance)
         {
            throw new Error("ERROR: ArmySoundManager Error: Instantiation failed: Use ArmySoundManager.getInstance() instead of new.");
         }
         this.restoreSettings();
         this.mSoundsDictionary = new Array();
         this.mSounds = new Array();
      }
      
      public static function load() : void
      {
         var _loc1_:String = null;
         mInstance.addExternalSound(Config.DIR_DATA + MUSIC_HOME,MUSIC_HOME,ArmySoundManager.TYPE_MUSIC);
         var _loc2_:int = int(mMandatorySounds.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = mMandatorySounds[_loc3_] as String;
            mInstance.addExternalSound(Config.DIR_DATA + _loc1_,_loc1_,ArmySoundManager.TYPE_SFX);
            _loc3_++;
         }
      }
      
      public static function loadMusic(param1:String) : void
      {
         mInstance.addExternalSound(Config.DIR_DATA + param1,param1,ArmySoundManager.TYPE_MUSIC,1000,false);
      }
      
      public static function getInstance() : ArmySoundManager
      {
         if(ArmySoundManager.mInstance == null)
         {
            ArmySoundManager.mAllowInstance = true;
            ArmySoundManager.mInstance = new ArmySoundManager();
            ArmySoundManager.mAllowInstance = false;
         }
         return ArmySoundManager.mInstance;
      }
      
      public function enableCookies(param1:Boolean) : void
      {
         this.mEnableCookies = param1;
      }
      
      private function restoreSettings() : void
      {
         var _loc1_:String = Cookie.readCookieVariable(Config.COOKIE_SETTINGS_NAME,Config.COOKIE_SETTINGS_NAME_MUSIC);
         if(_loc1_ == "false")
         {
            this.setMusicOn(false);
         }
         else
         {
            this.setMusicOn(true);
         }
         _loc1_ = Cookie.readCookieVariable(Config.COOKIE_SETTINGS_NAME,Config.COOKIE_SETTINGS_NAME_SFX);
         if(_loc1_ == "false")
         {
            this.setSfxOn(false);
         }
         else
         {
            this.setSfxOn(true);
         }
      }
      
      public function addLibrarySound(param1:*, param2:String, param3:int) : Boolean
      {
         if(this.soundExists(param2))
         {
            return false;
         }
         var _loc4_:Sound = new param1();
         this.createSound(_loc4_,param2,param3);
         return true;
      }
      
      public function addExternalSound(param1:String, param2:String, param3:int, param4:Number = 1000, param5:Boolean = false) : PlayableSoundObject
      {
         if(this.soundExists(param2))
         {
            return null;
         }
         if(Config.DEBUG_MODE)
         {
         }
         var _loc6_:Sound;
         (_loc6_ = new Sound(new URLRequest(param1),new SoundLoaderContext(param4,param5))).addEventListener(IOErrorEvent.IO_ERROR,this.sndError);
         if(Config.DEBUG_MODE)
         {
         }
         if(!_loc6_)
         {
            return null;
         }
         return this.createSound(_loc6_,param2,param3);
      }
      
      private function createSound(param1:Sound, param2:String, param3:int) : PlayableSoundObject
      {
         var _loc4_:PlayableSoundObject;
         (_loc4_ = new PlayableSoundObject()).addEventListener(Event.COMPLETE,this.soundObjectLoaded);
         _loc4_.mName = param2;
         _loc4_.setSound(param1);
         _loc4_.mChannel = new SoundChannel();
         _loc4_.mPosition = 0;
         _loc4_.mPaused = true;
         _loc4_.mVolume = SOUND_INITIAL_VOLUME;
         _loc4_.mStartTime = 0;
         _loc4_.mLoops = 0;
         _loc4_.mType = param3;
         this.mSoundsDictionary[param2] = _loc4_;
         this.mSounds.push(_loc4_);
         return _loc4_;
      }
      
      private function sndError(param1:IOErrorEvent) : void
      {
         Sound(param1.target).removeEventListener(IOErrorEvent.IO_ERROR,this.sndError);
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      private function soundObjectLoaded(param1:Event) : void
      {
         var _loc2_:PlayableSoundObject = param1.target as PlayableSoundObject;
         smLoadedSounds[_loc2_.mName] = true;
         _loc2_.removeEventListener(Event.COMPLETE,this.soundObjectLoaded);
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      private function soundCompleteHandler(param1:Event) : void
      {
         var _loc2_:PlayableSoundObject = null;
         var _loc3_:SoundChannel = null;
         var _loc4_:SoundChannel = null;
         for each(_loc2_ in this.mSoundsDictionary)
         {
            _loc3_ = _loc2_.mChannel;
            if((_loc4_ = param1.target as SoundChannel) == _loc3_)
            {
               _loc4_.removeEventListener(Event.SOUND_COMPLETE,this.soundCompleteHandler);
               _loc2_.mChannel = _loc2_.getSound().play(_loc2_.mPosition,_loc2_.mLoops,new SoundTransform(_loc2_.mVolume));
               _loc2_.mChannel.addEventListener(Event.SOUND_COMPLETE,this.soundCompleteHandler);
            }
         }
      }
      
      public function soundExists(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.mSounds.length)
         {
            if(this.mSounds[_loc2_].mName == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function removeSound(param1:String) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.mSounds.length)
         {
            if(this.mSounds[_loc2_].mName == param1)
            {
               this.mSounds[_loc2_] = null;
               this.mSounds.splice(_loc2_,1);
            }
            _loc2_++;
         }
         delete this.mSoundsDictionary[param1];
      }
      
      public function removeAll() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.mSounds.length)
         {
            this.mSounds[_loc1_] = null;
            _loc1_++;
         }
         this.mSounds = new Array();
         this.mSoundsDictionary = new Array();
      }
      
      public function playSound(param1:String, param2:Number = 1, param3:Number = 0, param4:int = 0) : PlayableSoundObject
      {
         if(!GameState.mInstance.mInitialized || param1 == null || this.mSoundsDictionary == null)
         {
            return null;
         }
         var _loc5_:PlayableSoundObject;
         if((_loc5_ = this.mSoundsDictionary[param1]) == null || _loc5_.getSound() == null || _loc5_.mChannel == null)
         {
            return null;
         }
         if(_loc5_.mType == TYPE_MUSIC)
         {
            if(!this.isMusicOn())
            {
               return null;
            }
         }
         else if(_loc5_.mType == TYPE_SFX)
         {
            if(!this.isSfxOn())
            {
               return null;
            }
         }
         _loc5_.mVolume = param2;
         _loc5_.mStartTime = param3;
         _loc5_.mLoops = param4;
         if(_loc5_.mPaused)
         {
            _loc5_.mChannel = _loc5_.getSound().play(_loc5_.mPosition,_loc5_.mLoops,new SoundTransform(_loc5_.mVolume));
         }
         else
         {
            _loc5_.mChannel = _loc5_.getSound().play(param3,_loc5_.mLoops,new SoundTransform(_loc5_.mVolume));
         }
         _loc5_.mPaused = false;
         if(param4 < 0 && _loc5_.mChannel != null)
         {
            _loc5_.mChannel.addEventListener(Event.SOUND_COMPLETE,this.soundCompleteHandler);
         }
         return _loc5_;
      }
      
      public function playSoundFromCollection(param1:SoundCollection, param2:Number = 1, param3:Number = 0, param4:int = 0) : PlayableSoundObject
      {
         var soundObject:PlayableSoundObject;
         var col:SoundCollection = param1;
         var volume:Number = param2;
         var startTime:Number = param3;
         var loops:int = param4;
         var name:String = col.getSound();
         if(name == null || this.mSoundsDictionary == null)
         {
            return null;
         }
         soundObject = this.mSoundsDictionary[name];
         if(soundObject == null || soundObject.getSound() == null || soundObject.mChannel == null)
         {
            return null;
         }
         if(soundObject.mType == TYPE_MUSIC)
         {
            if(!this.isMusicOn())
            {
               return null;
            }
         }
         else if(soundObject.mType == TYPE_SFX)
         {
            if(!this.isSfxOn())
            {
               return null;
            }
         }
         soundObject.mVolume = volume;
         soundObject.mStartTime = startTime;
         soundObject.mLoops = loops;
         try
         {
            if(soundObject.mPaused)
            {
               soundObject.mChannel = soundObject.getSound().play(soundObject.mPosition,soundObject.mLoops,new SoundTransform(soundObject.mVolume));
            }
            else
            {
               soundObject.mChannel = soundObject.getSound().play(startTime,soundObject.mLoops,new SoundTransform(soundObject.mVolume));
            }
         }
         catch(e:Error)
         {
            if(Config.DEBUG_MODE)
            {
            }
         }
         soundObject.mPaused = false;
         if(loops < 0 && soundObject.mChannel != null)
         {
            soundObject.mChannel.addEventListener(Event.SOUND_COMPLETE,this.soundCompleteHandler);
         }
         return soundObject;
      }
      
      public function stopSound(param1:String) : void
      {
         if(param1 == null || this.mSoundsDictionary == null || this.mSoundsDictionary[param1] == null)
         {
            return;
         }
         var _loc2_:PlayableSoundObject = this.mSoundsDictionary[param1];
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_.mPaused = true;
         if(_loc2_.mChannel != null)
         {
            _loc2_.mChannel.stop();
            _loc2_.mPosition = _loc2_.mChannel.position;
         }
      }
      
      public function pauseSound(param1:String) : void
      {
         var _loc2_:PlayableSoundObject = this.mSoundsDictionary[param1];
         _loc2_.mPaused = true;
         _loc2_.mPosition = _loc2_.mChannel.position;
         _loc2_.mChannel.stop();
      }
      
      public function stopAll(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         if(this.mSounds != null)
         {
            _loc3_ = 0;
            while(_loc3_ < this.mSounds.length)
            {
               if(!(param1 && this.mSounds[_loc3_].mType == TYPE_SFX))
               {
                  if(!(param2 && this.mSounds[_loc3_].mType == TYPE_MUSIC))
                  {
                     this.stopSound(this.mSounds[_loc3_].mName);
                  }
               }
               _loc3_++;
            }
         }
      }
      
      public function pauseAll() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.mSounds.length)
         {
            this.pauseSound(this.mSounds[_loc1_].mName);
            _loc1_++;
         }
      }
      
      public function fadeSound(param1:String, param2:Number = 0, param3:Number = 1) : void
      {
      }
      
      public function isMusicOn() : Boolean
      {
         return this.mMusicOn;
      }
      
      public function isSfxOn() : Boolean
      {
         return this.mSfxOn;
      }
      
      public function setMusicOn(param1:Boolean) : void
      {
         this.mMusicOn = param1;
         if(!this.mMusicOn)
         {
            this.stopAll(true,false);
         }
         if(this.mEnableCookies)
         {
            Cookie.saveCookieVariable(Config.COOKIE_SETTINGS_NAME,Config.COOKIE_SETTINGS_NAME_MUSIC,this.mMusicOn);
         }
      }
      
      public function setSfxOn(param1:Boolean) : void
      {
         this.mSfxOn = param1;
         if(!this.mSfxOn)
         {
            this.stopAll(false,true);
         }
         if(this.mEnableCookies)
         {
            Cookie.saveCookieVariable(Config.COOKIE_SETTINGS_NAME,Config.COOKIE_SETTINGS_NAME_SFX,this.mSfxOn);
         }
      }
      
      public function setSoundVolume(param1:String, param2:Number) : void
      {
         var _loc3_:PlayableSoundObject = this.mSoundsDictionary[param1];
         var _loc4_:SoundTransform;
         (_loc4_ = _loc3_.mChannel.soundTransform).volume = param2;
         _loc3_.mChannel.soundTransform = _loc4_;
      }
      
      public function getSoundVolume(param1:String) : Number
      {
         return this.mSoundsDictionary[param1].channel.soundTransform.volume;
      }
      
      public function getSoundPosition(param1:String) : Number
      {
         return this.mSoundsDictionary[param1].channel.position;
      }
      
      public function getSoundDuration(param1:String) : Number
      {
         return this.mSoundsDictionary[param1].sound.length;
      }
      
      public function getSoundObject(param1:String) : Sound
      {
         return this.mSoundsDictionary[param1].sound;
      }
      
      public function isSoundPaused(param1:String) : Boolean
      {
         return this.mSoundsDictionary[param1].paused;
      }
      
      public function get sounds() : Array
      {
         return this.mSounds;
      }
   }
}
