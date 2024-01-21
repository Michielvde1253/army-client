package game.gameElements
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import game.battlefield.MapData;
   import game.characters.PlayerUnit;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.SceneLoader;
   import game.items.DecorationItem;
   import game.items.FireMissionItem;
   import game.sound.ArmySoundManager;
   import game.sound.SoundCollection;
   import game.states.GameState;
   import game.utils.ColorFadeEffect;
   import game.utils.ScreenShakeEffect;
   
   public class FireMissionObject extends MovieClip
   {
      
      private static const DOOMSDAY_NAME:String = "Doomsday";
       
      
      private var mColorEffectField:ColorFadeEffect;
      
      private var mColorEffectScene:ColorFadeEffect;
      
      private var mShakeEffect:ScreenShakeEffect;
      
      private var mItem:FireMissionItem;
      
      private var mAnim:MovieClip;
      
      private var mGraphicsLoaded:Boolean;
      
      private var mLoadingCallbackEventType:String;
      
      private var mStarted:Boolean;
      
      private var mCells:Array;
      
      private var mSound:SoundCollection;
      
      private var mDebrises:Array;
      
      public function FireMissionObject(param1:FireMissionItem, param2:Array)
      {
         var _loc5_:Class = null;
         super();
         this.mItem = param1;
         this.mCells = param2;
         var _loc3_:DCResourceManager = DCResourceManager.getInstance();
         var _loc4_:String = param1.getIconGraphicsFile();
         if(_loc3_.isLoaded(_loc4_))
         {
            this.mGraphicsLoaded = true;
            if(FeatureTuner.USE_FIRE_CALL_EFFECTS)
            {
               _loc5_ = _loc3_.getSWFClass(_loc4_,param1.getIconGraphics());
               this.mAnim = new _loc5_();
               addChild(this.mAnim);
            }
         }
         else
         {
            this.mGraphicsLoaded = false;
            this.mLoadingCallbackEventType = _loc4_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
            _loc3_.addEventListener(this.mLoadingCallbackEventType,this.LoadingFinished,false,0,true);
            if(!_loc3_.isAddedToLoadingList(_loc4_))
            {
               _loc3_.load(Config.DIR_DATA + _loc4_ + ".swf",_loc4_,null,false);
            }
         }
         if(this.mItem.mId == DOOMSDAY_NAME)
         {
            this.mShakeEffect = new ScreenShakeEffect(GameState.mInstance.mScene.mTilemapGraphic.mFieldBmp,100,12,12);
         }
         this.initSound();
         this.mStarted = false;
      }
      
      public function initSound() : void
      {
         var _loc1_:String = null;
         if(FeatureTuner.USE_ALL_FIRE_CALL_SOUND)
         {
            _loc1_ = this.mItem.mId;
            if(_loc1_ == "Mortar")
            {
               this.mSound = ArmySoundManager.SC_FIRE_MISSION_MORTAR;
            }
            else if(_loc1_ == "Napalm")
            {
               this.mSound = ArmySoundManager.SC_FIRE_MISSION_NAPALM;
            }
            else if(_loc1_ == "Artillery")
            {
               this.mSound = ArmySoundManager.SC_FIRE_MISSION_ARTILLERY;
            }
            else if(_loc1_ == "Doomsday")
            {
               this.mSound = ArmySoundManager.SC_FIRE_MISSION_DOOMSDAY;
            }
            else
            {
               this.mSound = ArmySoundManager.SC_FIRE_MISSION_MORTAR;
            }
         }
         else
         {
            this.mSound = ArmySoundManager.SC_FIRE_MISSION_MORTAR;
         }
         this.mSound.load();
      }
      
      public function LoadingFinished(param1:Event) : void
      {
         var _loc3_:Class = null;
         var _loc2_:DCResourceManager = DCResourceManager.getInstance();
         _loc2_.removeEventListener(param1.type,this.LoadingFinished);
         this.mLoadingCallbackEventType = null;
         this.mGraphicsLoaded = true;
         if(FeatureTuner.USE_FIRE_CALL_EFFECTS)
         {
            _loc3_ = _loc2_.getSWFClass(this.mItem.getIconGraphicsFile(),this.mItem.getIconGraphics());
            this.mAnim = new _loc3_();
            addChild(this.mAnim);
         }
         if(this.mStarted)
         {
            this.start();
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:MovieLoop = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this.mLoadingCallbackEventType)
         {
            DCResourceManager.getInstance().removeEventListener(this.mLoadingCallbackEventType,this.LoadingFinished);
         }
         if(this.mColorEffectField)
         {
            this.mColorEffectField.destroy();
            this.mColorEffectField = null;
         }
         if(this.mColorEffectScene)
         {
            this.mColorEffectScene.destroy();
            this.mColorEffectScene = null;
         }
         if(this.mShakeEffect)
         {
            this.mShakeEffect.destroy();
            this.mShakeEffect = null;
         }
         if(this.mDebrises)
         {
            _loc2_ = int(this.mDebrises.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc1_ = this.mDebrises[_loc3_] as MovieLoop;
               _loc1_.destroy();
               _loc3_++;
            }
            this.mDebrises = null;
         }
      }
      
      public function start() : void
      {
         this.mStarted = true;
         if(!this.mGraphicsLoaded)
         {
            return;
         }
         if(FeatureTuner.USE_FIRE_CALL_EFFECTS)
         {
            this.mAnim.gotoAndStop(1);
         }
         ArmySoundManager.getInstance().playSound(this.mSound.getSound());
      }
      
      public function isOver() : Boolean
      {
         if(!this.mGraphicsLoaded)
         {
            return false;
         }
         if(!FeatureTuner.USE_FIRE_CALL_EFFECTS)
         {
            return true;
         }
         return this.mAnim.currentFrame >= this.mAnim.totalFrames;
      }
      
      public function update() : void
      {
         var _loc1_:Class = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:IsometricScene = null;
         var _loc6_:GridCell = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:MovieLoop = null;
         if(!this.mGraphicsLoaded)
         {
            return;
         }
         if(!FeatureTuner.USE_FIRE_CALL_EFFECTS)
         {
            return;
         }
         if(this.mAnim.currentFrame == this.mAnim.totalFrames)
         {
            if(this.mAnim.parent)
            {
               this.mAnim.parent.removeChild(this.mAnim);
            }
         }
         else
         {
            this.mAnim.nextFrame();
         }
         if(this.mColorEffectScene)
         {
            if(this.mAnim.currentFrameLabel == "start_flash" && !this.mColorEffectField.mStarted)
            {
               this.mColorEffectField.mStarted = true;
            }
            else
            {
               this.mColorEffectField.update();
            }
         }
         if(this.mAnim.currentFrameLabel == "debris")
         {
            if(!this.mDebrises)
            {
               _loc1_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_EFFECTS_NAME,"debris_animation");
               _loc2_ = SceneLoader.GRID_CELL_SIZE;
               _loc3_ = -_loc2_ / 2;
               _loc4_ = -_loc2_ / 2;
               _loc5_ = GameState.mInstance.mScene;
               this.mDebrises = new Array();
               _loc7_ = int(this.mCells.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  if(!((_loc6_ = this.mCells[_loc8_] as GridCell).hasFog() || !_loc5_.isInsideVisibleArea(_loc6_) || !MapData.isTilePassable(_loc6_.mType)))
                  {
                     if(!_loc6_.mObject && !_loc6_.mCharacter)
                     {
                        (_loc9_ = new MovieLoop(new _loc1_(),_loc6_.mPosI * _loc2_ - _loc3_,_loc6_.mPosJ * _loc2_ - _loc4_,GameState.mInstance.mScene.mContainer,1,0)).mRemoveInTheEnd = false;
                        this.mDebrises.push(_loc9_);
                     }
                     else if(_loc6_.mObject && (_loc6_.mObject is DecorationObject && (_loc6_.mObject as DecorationObject).getHealth() == 0 && !(_loc6_.mObject.mItem as DecorationItem).mLeaveRuins) || _loc6_.mObject is EnemyInstallationObject && (_loc6_.mObject as EnemyInstallationObject).getHealth() == 0 || _loc6_.mObject is HFEPlotObject && (_loc6_.mObject as HFEPlotObject).getHealth() == 0)
                     {
                        (_loc9_ = new MovieLoop(new _loc1_(),_loc6_.mPosI * _loc2_ - _loc3_,_loc6_.mPosJ * _loc2_ - _loc4_,GameState.mInstance.mScene.mContainer,1,0)).mRemoveInTheEnd = false;
                        this.mDebrises.push(_loc9_);
                     }
                     else if(Boolean(_loc6_.mCharacter) && (!(_loc6_.mCharacter is PlayerUnit) || _loc6_.mCharacter.getHealth() > 0))
                     {
                        (_loc9_ = new MovieLoop(new _loc1_(),_loc6_.mPosI * _loc2_ - _loc3_,_loc6_.mPosJ * _loc2_ - _loc4_,GameState.mInstance.mScene.mContainer,1,0)).mRemoveInTheEnd = false;
                        this.mDebrises.push(_loc9_);
                     }
                  }
                  _loc8_++;
               }
            }
         }
         if(this.mColorEffectScene)
         {
            if(this.mAnim.currentFrameLabel == "start_flash" && !this.mColorEffectScene.mStarted)
            {
               this.mColorEffectScene.mStarted = true;
            }
            else
            {
               this.mColorEffectScene.update();
            }
         }
         if(this.mShakeEffect)
         {
            if(this.mAnim.currentFrameLabel == "start_shake" && !this.mShakeEffect.mStarted)
            {
               this.mShakeEffect.mStarted = true;
            }
            else if(this.mAnim.currentFrameLabel == "end_shake")
            {
               this.mShakeEffect.destroy();
            }
            else
            {
               this.mShakeEffect.update();
            }
         }
         this.mAnim = null;
      }
   }
}
