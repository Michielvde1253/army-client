package game.gui
{
   import com.dchoc.GUI.DCButton;
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.FileReference;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.permissions.PermissionStatus
   import game.gui.button.ArmyButton;
   import game.gui.popups.PopUpWindow;
   import game.magicBox.FlurryEvents;
   import game.missions.MissionManager;
   import game.net.ServerCall;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class PauseDialog extends PopUpWindow
   {
      
      public static var mPauseScreenState:int;
      
      public static var mPauseScreenPreviousState:int;
      
      public static const STATE_IN_GAME:int = 0;
      
      public static const STATE_UNDEFINED:int = 1;
      
      public static const STATE_CONTINUE:int = 2;
      
      public static const STATE_HELP_CLICK:int = 3;
      
      public static const STATE_SETTINGS_CLICK:int = 4;
       
      
      private var mButtonPlay:ArmyButton;
      
      private var mButtonResume:ArmyButton;
      
      private var mButtonSettings:ArmyButton;
      
      private var mButtonHelp:ArmyButton;
      
      private var mButtonLoad:ArmyButton;
      
      public function PauseDialog()
      {
         var _loc1_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_MAIN_MENU_NAME,"MainMenu");
         super(new _loc1_(),false);
         if(mPauseScreenState == STATE_CONTINUE)
         {
            this.mButtonPlay = this.addButton(mClip,"Button_play",this.tabPressed);
            this.mButtonPlay.resizeNeeded = false;
            this.mButtonResume = this.addButton(mClip,"Button_resume",this.tabPressed);
            this.mButtonResume.resizeNeeded = false;
            this.mButtonSettings = this.addButton(mClip,"Button_settings",this.tabPressed);
            this.mButtonSettings.resizeNeeded = false;
            this.mButtonHelp = this.addButton(mClip,"Button_how_to_play",this.tabPressed);
            this.mButtonHelp.resizeNeeded = false;
            this.mButtonLoad = this.addButton(mClip,"Button_loadsave",this.tabPressed);
            this.mButtonLoad.resizeNeeded = false;
            this.mButtonPlay.setText(GameState.getText("PLAY_BUTTON_TEXT"),"Text_Title");
            this.mButtonResume.setText(GameState.getText("RESUME_BUTTON_TEXT"),"Text_Title");
            this.mButtonSettings.setText(GameState.getText("SETTINGS_BUTTON_TEXT"),"Text_Title");
            this.mButtonHelp.setText(GameState.getText("HELP_BUTTON_TEXT"),"Text_Title");
            this.mButtonLoad.setText(GameState.getText("LOAD_BUTTON_TEXT"),"Text_Title");
            this.updatePlayResumeButton();
         }
      }
      
      public function Activate(param1:Function) : void
      {
         mDoneCallback = param1;
         doOpeningTransition();
      }
      
      public function startSelectingFile() : void
      {
		 trace("yes.");
		 var file:File = new File();
		 file.addEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
		 file.requestPermission();
      }
  
  	public function onPermission(e:PermissionEvent):void {
		trace("yesnt.");
		var file:File = e.target as File;
		file.removeEventListener(PermissionEvent.PERMISSION_STATUS, onPermission);
		if (e.status == PermissionStatus.GRANTED) {
			trace("yesntnt.");
			file.addEventListener(Event.SELECT, onFileSelected);
			file.browseForOpen("Select a file");							
		}
	}
      
      public function onFileSelected(evt:Event) : void
      {
		 trace("yesntntnt.");
		 var file:File = evt.target as File;
		 var stream:FileStream = new FileStream();
		 stream.open(file, FileMode.READ);
         var savedata:* = JSON.parse(stream.readUTFBytes(stream.bytesAvailable));
		 trace(savedata);
         loadProgress(savedata);
      }
      
      public function fixOldSave(savedata:*, version:int) : *
      {
         if(version < 3)
         {
            savedata["isFogOfWarOff"] = true;
         }
         return savedata;
      }
      
      public function loadProgress(savedata:*) : void
      {
         var saveversion:int = int(savedata["saveversion"]);
         savedata = fixOldSave(savedata,saveversion);
         var minus_rechargetime:int = 0;
         var energy_to_give:int = 0;
         var time_needed_for_energy:int = 0;
         var item:* = undefined;
         var cell:* = undefined;
         var dateobj:Date = new Date();
         var now:int = Math.round(dateobj.valueOf() / 1000);
         var then:int = Math.round(Number(savedata["time_of_last_save"]) / 1000);
         var time_diff:* = now - then;
         if(savedata["profile"]["resource_energy"] < savedata["profile"]["energy_cap"])
         {
            if(time_diff >= savedata["profile"]["secs_to_energy_gain"])
            {
               savedata["profile"]["resource_energy"]++;
               if(savedata["profile"]["resource_energy"] >= savedata["profile"]["energy_cap"])
               {
                  savedata["profile"]["resource_energy"] = savedata["profile"]["energy_cap"];
                  savedata["profile"]["secs_to_energy_gain"] = savedata["profile"]["energy_recharge_time"];
               }
               else
               {
                  minus_rechargetime = time_diff - Number(savedata["profile"]["secs_to_energy_gain"]);
                  energy_to_give = Math.floor(minus_rechargetime / Number(savedata["profile"]["energy_recharge_time"]));
                  savedata["profile"]["resource_energy"] += energy_to_give;
                  if(savedata["profile"]["resource_energy"] >= savedata["profile"]["energy_cap"])
                  {
                     savedata["profile"]["resource_energy"] = savedata["profile"]["energy_cap"];
                     savedata["profile"]["secs_to_energy_gain"] = savedata["profile"]["energy_recharge_time"];
                  }
                  else
                  {
                     time_needed_for_energy = energy_to_give * Number(savedata["profile"]["energy_recharge_time"]);
                     savedata["profile"]["secs_to_energy_gain"] = minus_rechargetime - time_needed_for_energy;
                  }
               }
            }
            else
            {
               savedata["profile"]["secs_to_energy_gain"] -= time_diff;
            }
         }
         else
         {
            savedata["profile"]["secs_to_energy_gain"] = savedata["profile"]["energy_recharge_time"];
         }
         var i:* = 0;
         for(i in savedata["gamefield_items"])
         {
            if(savedata["gamefield_items"][i]["next_action_at"] != null)
            {
               savedata["gamefield_items"][i]["next_action_at"] -= time_diff;
               if(savedata["gamefield_items"][i]["next_action_at"] < 0)
               {
                  savedata["gamefield_items"][i]["next_action_at"] = 0;
               }
            }
            if(savedata["gamefield_items"][i]["activation_time"] != 0)
            {
               savedata["gamefield_items"][i]["activation_time"] -= time_diff;
               if(savedata["gamefield_items"][i]["activation_time"] < 0)
               {
                  savedata["gamefield_items"][i]["activation_time"] = 0;
               }
            }
         }
         var fakeservercall:* = new ServerCall("GetMapData",null,null,null);
         var fakeservercall2:* = new ServerCall("GetUserData",null,null,null);
         fakeservercall["mData"] = savedata;
         fakeservercall2["mData"] = savedata["profile"];
         fakeservercall["mData"]["secs_since_last_enemy_spawn"] = savedata["profile"]["secs_since_last_enemy_spawn"];
         GameState.mInstance.restoreFogOfWar(savedata["isFogOfWarOff"]);
         GameState.mInstance.mLoadingStatesOver = false;
         GameState.mInstance.mCurrentMapId = "Home";
         GameState.mInstance.mCurrentMapGraphicsId = Math.max(GameState.GRAPHICS_MAP_ID_LIST.indexOf(GameState.mInstance.mCurrentMapId),0);
         GameState.mInstance.loadingFirstFinished();
         GameState.mInstance.initPlayerProfile(fakeservercall2);
         GameState.mInstance.mPlayerProfile.mInventory.getAreas();
         GameState.mInstance.changeState(0);
         GameState.mInstance.mMapData.destroy();
         GameState.mInstance.initMap(fakeservercall);
         GameState.mInstance.initObjects(fakeservercall);
         GameState.mInstance.updateGrid();
         GameState.mInstance.mScene.mFog.init();
         MissionManager.setupFromServer(fakeservercall);
         MissionManager.findNewActiveMissions();
         GameState.mInstance.mLoadingStatesOver = true;
      }
      
      private function tabPressed(param1:MouseEvent) : void
      {
         var fileRef:* = undefined;
         if(ArmySoundManager.getInstance().isSfxOn())
         {
            ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_CLICK);
         }
         switch(param1.target)
         {
            case this.mButtonPlay.getMovieClip():
            case this.mButtonResume.getMovieClip():
               GameHUD.isPauseButtonClicked = false;
               if(param1.target == this.mButtonPlay.getMovieClip())
               {
                  if(FeatureTuner.USE_RATEAPP_POPUP)
                  {
                     GameState.mInstance.checkRateApp();
                  }
               }
               if(MissionManager.isTutorialCompleted())
               {
                  GameState.mInstance.changeState(GameState.STATE_PLAY);
               }
               else
               {
                  ArmySoundManager.getInstance().stopSound(ArmySoundManager.MUSIC_HOME);
                  GameState.mInstance.mHUD.openIntroTextBox();
               }
               mDoneCallback((this as Object).constructor);
               break;
            case this.mButtonHelp.getMovieClip():
               GameState.mInstance.mHUD.openHelpScreen();
               break;
            case this.mButtonSettings.getMovieClip():
               GameState.mInstance.mHUD.openSettingsScreen();
               break;
            case this.mButtonLoad.getMovieClip():
               this.startSelectingFile();
         }
      }
      
      private function updatePlayResumeButton() : void
      {
         if(GameHUD.isPauseButtonClicked)
         {
            this.mButtonPlay.setVisible(false);
            this.mButtonResume.setVisible(true);
         }
         else
         {
            this.mButtonPlay.setVisible(true);
            this.mButtonResume.setVisible(false);
         }
      }
      
      private function addButton(param1:MovieClip, param2:String, param3:Function) : ArmyButton
      {
         var _loc4_:MovieClip = null;
         if((_loc4_ = param1.getChildByName(param2) as MovieClip) != null)
         {
            _loc4_.mouseEnabled = true;
            return new ArmyButton(param1,_loc4_,DCButton.BUTTON_TYPE_ICON,null,null,null,null,null,param3);
         }
         param3 = null;
         return null;
      }
      
      public function closePauseMenuAuto() : void
      {
         GameHUD.isPauseButtonClicked = false;
         if(MissionManager.isTutorialCompleted())
         {
            GameState.mInstance.changeState(GameState.STATE_PLAY);
         }
         else
         {
            ArmySoundManager.getInstance().stopSound(ArmySoundManager.MUSIC_HOME);
            GameState.mInstance.mHUD.openIntroTextBox();
         }
         mDoneCallback((this as Object).constructor);
      }
   }
}
