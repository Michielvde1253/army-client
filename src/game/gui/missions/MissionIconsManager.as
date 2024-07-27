package game.gui.missions
{
   import com.dchoc.GUI.DCButton;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import game.gui.GameHUD;
   import game.missions.Mission;
   import game.missions.MissionManager;
   import game.states.GameState;
   
   public class MissionIconsManager
   {
      
      public static var smHighlightedMissionAdded:Boolean;
      
      private static var ICON_SPACING:int = Config.FOR_IPHONE_PLATFORM ? 52 : 100;
      
      private static const NUMBER_OF_MISSION_BUTTONS:int = 3;
       
      
      private var mUnstable:Boolean;
      
      private var mHUD:GameHUD;
      
      private var mMissionFrames:Array;
      
      private var mMissionFrameTopY:int;
      
      private var mMissionStackFrame:MovieClip;
      
      private var mMissionStackButton:MissionStackButton;
      
      private var mParentClip:MovieClip;
      
      private var mMissionList:Array;
      
      private var keyCoordinates:Array;
      
      public function MissionIconsManager(param1:GameHUD)
      {
         var _loc4_:MovieClip = null;
         var _loc6_:MissionIconFrame = null;
         super();
         this.mHUD = param1;
         this.mParentClip = param1.getHUDClipBottom();
         var _loc2_:MovieClip = this.mParentClip.getChildByName("pullout_mission_frame") as MovieClip;
         var _loc3_:MovieClip = _loc2_.getChildByName("pullout_mission") as MovieClip;
         this.mMissionStackFrame = _loc3_.getChildByName("Frame_Mission_Stack") as MovieClip;
         if(this.mMissionStackFrame.parent)
         {
            this.mMissionStackFrame.parent.removeChild(this.mMissionStackFrame);
         }
         this.mMissionStackButton = this.addMissionStackButton(this.mMissionStackFrame,"Button_Mission",this.buttonMissionStackPressed);
         this.mMissionFrames = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < NUMBER_OF_MISSION_BUTTONS)
         {
            _loc4_ = _loc3_.getChildByName("Frame_Mission_" + (_loc5_ + 1)) as MovieClip;
            (_loc6_ = new MissionIconFrame(_loc4_)).removeFromParent();
            this.mMissionFrames[_loc5_] = _loc6_;
            _loc5_++;
         }
         if(Config.FOR_IPHONE_PLATFORM)
         {
            this.mMissionFrameTopY = (this.mMissionFrames[0] as MissionIconFrame).getY() - 20;
         }
         else
         {
            this.mMissionFrameTopY = (this.mMissionFrames[0] as MissionIconFrame).getY() - 10;
         }
         this.mMissionList = new Array();
         this.mUnstable = true;
      }
      
      private static function sortMissions(param1:Mission, param2:Mission) : int
      {
         if(param1.mType == Mission.TYPE_CAMPAIGN)
         {
            return -1;
         }
         if(param2.mType == Mission.TYPE_CAMPAIGN)
         {
            return 1;
         }
         return 0;
      }
      
      private function addMissionStackButton(param1:MovieClip, param2:String, param3:Function) : MissionStackButton
      {
         var _loc4_:MovieClip;
         if((_loc4_ = param1.getChildByName(param2) as MovieClip) != null)
         {
            _loc4_.mouseEnabled = true;
            return new MissionStackButton(param1,_loc4_,DCButton.BUTTON_TYPE_ICON,null,null,null,null,null,param3);
         }
         param3 = null;
         return null;
      }
      
      public function resize(param1:int, param2:int) : void
      {
         var _loc3_:MissionIconFrame = null;
         if(!this.keyCoordinates)
         {
            this.keyCoordinates = new Array();
            this.keyCoordinates.push((this.mMissionFrames[0] as MissionIconFrame).getX() + (this.mMissionFrames[0] as MissionIconFrame).getWidth() / 3);
            this.keyCoordinates.push(this.mMissionStackFrame.x);
         }
         for each(_loc3_ in this.mMissionFrames)
         {
            _loc3_.setX(this.keyCoordinates[0]);
         }
         this.mMissionStackFrame.x = this.keyCoordinates[1];
      }
      
      public function reset() : void
      {
         var _loc1_:MissionIconFrame = null;
         this.mMissionList.length = 0;
         for each(_loc1_ in this.mMissionFrames)
         {
            _loc1_.removeFromParent();
         }
         this.mUnstable = true;
      }
      
      public function updateMissionButtons() : void
      {
         var _loc3_:Mission = null;
         var _loc6_:Mission = null;
         var _loc7_:int = 0;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         var _loc10_:MissionIconFrame = null;
         var _loc11_:MissionButton = null;
         var _loc1_:int = MissionManager.getNumMissions();
         var _loc2_:int = NUMBER_OF_MISSION_BUTTONS;
         var _loc4_:int = 0;
		 var map_id:String = GameState.mInstance.mCurrentMapId;
         while(_loc4_ < _loc1_)
         {
            _loc6_ = MissionManager.getMissionByIndex(_loc4_);
            _loc7_ = this.mMissionList.indexOf(_loc6_);
            if(_loc6_.mState == Mission.STATE_ACTIVE && !_loc6_.allObjectivesDone())
            {
               if(_loc7_ == -1 && (_loc6_.mType == Mission.TYPE_NORMAL || _loc6_.mType == Mission.TYPE_STORY || _loc6_.mType == Mission.TYPE_TIP || _loc6_.mType == Mission.TYPE_CAMPAIGN))
               {
				  if (_loc6_.mMapId == map_id){
					trace("Hi, this is Michiel attempting to fix an annoying issue.");
					trace("First of all, the map id we're on is " + map_id);
					trace("Secondly, the map id the mission should appear on is " + _loc6_.mMapId);
					trace("The mission's ID actually is ")
					this.mMissionList.push(_loc6_);
				  }
               }
               else if(_loc6_.mType == Mission.TYPE_RANK)
               {
                  _loc3_ = _loc6_;
               }
            }
            else if(_loc7_ != -1)
            {
               this.mMissionList.splice(_loc7_,1);
            }
            _loc4_++;
         }
         this.mMissionList.sort(sortMissions);
         if(this.mMissionList.length > NUMBER_OF_MISSION_BUTTONS)
         {
            _loc2_--;
            this.mMissionStackButton.setText(String(this.mMissionList.length - _loc2_),"Header");
            (_loc9_ = (_loc8_ = this.mParentClip.getChildByName("pullout_mission_frame") as MovieClip).getChildByName("pullout_mission") as MovieClip).addChild(this.mMissionStackFrame);
         }
         else if(this.mMissionStackFrame.parent)
         {
            this.mMissionStackFrame.parent.removeChild(this.mMissionStackFrame);
         }
         var _loc5_:int = 0;
         while(_loc5_ < this.mMissionList.length && _loc5_ < _loc2_)
         {
            _loc6_ = this.mMissionList[_loc5_];
            if((_loc11_ = (_loc10_ = this.mMissionFrames[_loc5_] as MissionIconFrame).getButton()).getMission() != _loc6_)
            {
               if(!_loc11_.getMission())
               {
                  _loc10_.setY(this.getNewMissionSlideStartY(_loc10_));
                  this.mUnstable = true;
               }
               if(_loc6_.mId == "COMBAT_S_1")
               {
                  _loc11_.setMission(_loc6_,null);
               }
               else
               {
                  _loc11_.setMission(_loc6_,smHighlightedMissionAdded ? MissionButton.STATE_UNOPENED : null);
               }
               _loc10_.addToParent();
            }
            smHighlightedMissionAdded = smHighlightedMissionAdded || _loc11_.getState() == MissionButton.STATE_NEW;
            _loc5_++;
         }
         while(_loc4_ < NUMBER_OF_MISSION_BUTTONS)
         {
            (this.mMissionFrames[_loc4_] as MissionIconFrame).removeFromParent();
            _loc4_++;
         }
         if(!_loc3_)
         {
         }
      }
      
      private function getNewMissionSlideStartY(param1:MissionIconFrame) : int
      {
         var _loc2_:int = this.mMissionFrames.indexOf(param1);
         var _loc3_:int = GameState.mInstance.getStageHeight() + _loc2_ * ICON_SPACING;
         if(_loc2_ > 0)
         {
            _loc3_ = Math.max(_loc3_,(this.mMissionFrames[_loc2_ - 1] as MissionIconFrame).getY() + ICON_SPACING * 3);
         }
         return _loc3_;
      }
      
      private function buttonMissionStackPressed(param1:MouseEvent) : void
      {
         this.mHUD.openMissionStackWindow();
      }
      
      public function logicUpdate() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MissionIconFrame = null;
         var _loc3_:int = 0;
         if(this.mUnstable)
         {
            this.mUnstable = false;
            _loc1_ = 0;
            while(_loc1_ < this.mMissionFrames.length)
            {
               _loc2_ = this.mMissionFrames[_loc1_];
               _loc3_ = this.mMissionFrameTopY + _loc1_ * ICON_SPACING;
               if(_loc2_.getY() > _loc3_)
               {
                  this.mUnstable = true;
                  _loc2_.setY(_loc2_.getY() - (_loc2_.getY() - _loc3_) / 20 + 1);
                  if(_loc2_.getY() < _loc3_)
                  {
                     _loc2_.setY(_loc3_);
                  }
               }
               _loc1_++;
            }
         }
      }
      
      public function checkMissionProgress() : void
      {
         var _loc3_:MissionIconFrame = null;
         var _loc4_:MissionButton = null;
         var _loc5_:Mission = null;
         var _loc1_:int = int(this.mMissionFrames.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.mMissionFrames[_loc2_];
            if(_loc5_ = (_loc4_ = _loc3_.getButton()).getMission())
            {
               if(_loc5_.allObjectivesDone())
               {
                  this.mMissionFrames.push(_loc3_);
                  this.mMissionFrames.splice(_loc2_,1);
                  _loc1_--;
                  _loc4_.setState(MissionButton.STATE_COMPLETE);
                  _loc3_.setY(this.getNewMissionSlideStartY(_loc3_));
                  this.mUnstable = true;
               }
               else if(_loc5_.getProgressPending(true))
               {
                  _loc4_.setState(MissionButton.STATE_PROGRESSING);
               }
            }
            _loc2_++;
         }
      }
   }
}
