package game.gameElements
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import game.isometric.IsometricScene;
   import game.items.HFEItem;
   import game.items.ItemManager;
   import game.items.MapItem;
   import game.missions.MissionManager;
   import game.sound.ArmySoundManager;
   import game.sound.SoundCollection;
   import game.states.GameState;
   import game.utils.EffectController;
   
   public class HFEObject extends PlayerBuildingObject
   {
      
      protected static const MAX_HFEOBJECTS_ANIMATED:int = 10;
      
      protected static var smAnimationsOn:Boolean = true;
       
      
      private var mLoadingCallbackEventType:String;
      
      private var mHarvestSound:SoundCollection;
      
      private var mHarvestAnimation:MovieClip;
      
      public function HFEObject(param1:int, param2:IsometricScene, param3:MapItem, param4:Point, param5:DisplayObject = null, param6:String = null)
      {
         super(param1,param2,param3,param4,param5,param6);
      }
      
      public static function calculateHFEObjectsAnimated() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = false;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(GameState.mInstance.mScene)
         {
            _loc1_ = 0;
            _loc4_ = null;
            _loc5_ = int((_loc4_ = GameState.mInstance.mScene.mAllElements).length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc3_ = _loc4_[_loc6_] as Object;
               if(_loc3_ is HFEObject)
               {
                  if((_loc7_ = (_loc3_ as HFEObject).getState()) == STATE_PRODUCTION_READY || _loc7_ == STATE_PLAY_HARVEST_ANIMATION || _loc7_ == STATE_WITHERED)
                  {
                     _loc1_++;
                  }
               }
               _loc6_++;
            }
            _loc2_ = _loc1_ < MAX_HFEOBJECTS_ANIMATED;
            if(_loc2_ != smAnimationsOn)
            {
               smAnimationsOn = _loc2_;
               _loc9_ = null;
               _loc10_ = int((_loc9_ = GameState.mInstance.mScene.mAllElements).length);
               _loc11_ = 0;
               while(_loc11_ < _loc10_)
               {
                  if((_loc8_ = _loc9_[_loc11_] as Object) is HFEObject)
                  {
                     if((_loc8_ as HFEObject).mProgressCompletedIcon.visible)
                     {
                        if(_loc2_)
                        {
                           (_loc8_ as HFEObject).mProgressCompletedIcon.gotoAndPlay(0);
                        }
                        else
                        {
                           (_loc8_ as HFEObject).mProgressCompletedIcon.gotoAndStop(0);
                        }
                     }
                  }
                  _loc11_++;
               }
            }
         }
      }
      
      override public function graphicsLoaded(param1:Sprite) : void
      {
         super.graphicsLoaded(param1);
         this.updateGraphics();
      }
      
      private function updateGraphics() : void
      {
         if(!mGraphicsLoaded)
         {
            return;
         }
         if(mState == STATE_PRODUCTION_READY && this.mHarvestAnimation == null)
         {
            (getContainer().getChildAt(0) as MovieClip).gotoAndStop(2);
         }
         else if(mState == STATE_WITHERED)
         {
            (getContainer().getChildAt(0) as MovieClip).gotoAndStop(3);
         }
         else
         {
            (getContainer().getChildAt(0) as MovieClip).gotoAndStop(1);
         }
      }
      
      override public function setHealth(param1:int) : void
      {
         var _loc2_:int = Math.max(0,Math.min(mMaxHealth,param1));
         mHealth = _loc2_;
         if(!isFullHealth())
         {
            removeProduction();
         }
         else
         {
            checkProductionState();
         }
         if(mHealth == 0)
         {
            this.remove();
            mScene.addEffect(null,EffectController.EFFECT_TYPE_BIG_EXPLOSION,mX,mY);
         }
      }
      
      override public function remove() : void
      {
         var _loc1_:HFEPlotObject = null;
         if(mHealth > 0)
         {
            _loc1_ = mScene.createObject(ItemManager.getItem("Plot","HFEPlot") as MapItem,new Point()) as HFEPlotObject;
            _loc1_.setPos(mX,mY,0);
            mScene.incrementViewersForBuilding(_loc1_,getSightRange());
         }
         mState = STATE_REMOVE;
      }
      
      override public function handleProductionUnwithered() : void
      {
         super.handleProductionUnwithered();
         this.updateGraphics();
      }
      
      override public function handlePlacedOnMap() : void
      {
         super.handlePlacedOnMap();
         if(!mProduction)
         {
            setProduction(mItem.mId);
            MissionManager.increaseCounter("StartProducing",[mItem,mItem],1);
         }
         mState = STATE_PRODUCING;
      }
      
      override public function setupFromServer(param1:Object) : void
      {
         super.setupFromServer(param1);
         this.handlePlacedOnMap();
         if(param1.crop_state == "growing")
         {
            mState = STATE_PRODUCING;
            mProduction.setRemainingProductionTime(param1.next_action_at);
         }
         else if(param1.crop_state == "ready")
         {
            mState = STATE_PRODUCTION_READY;
            mProduction.setRemainingWitheringTime(param1.next_action_at);
			 
			// If withering started while offline
			// time_into_wither is customly added in OfflineSave, shouldn't be sent by server
			if (param1.time_into_wither != -1){
				mProduction.setRemainingWitheringTime(mProduction.getTotalTimeToWither() - param1.time_into_wither)
			}
         }
         else
         {
            mState = STATE_WITHERED;
            mProduction.setWithered();
         }
         this.updateGraphics();
      }
      
      override public function handleProductionComplete() : void
      {
         var _loc1_:DCResourceManager = null;
         var _loc2_:String = null;
         calculateHFEObjectsAnimated();
         if(!smAnimationsOn)
         {
            super.handleProductionComplete();
            this.updateGraphics();
         }
         else if(mItem is HFEItem && Boolean((mItem as HFEItem).mHarvestAnimation))
         {
            if(FeatureTuner.USE_SOUNDS)
            {
               this.initSounds();
            }
            _loc1_ = DCResourceManager.getInstance();
            _loc2_ = Config.SWF_EFFECTS_NAME;
            if(_loc1_.isLoaded(_loc2_))
            {
               this.addHarvestAnimaion();
            }
            else if(FeatureTuner.USE_HARVEST_ANIMATION)
            {
               this.mLoadingCallbackEventType = _loc2_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
               _loc1_.addEventListener(this.mLoadingCallbackEventType,this.harvestAnimationLoaded,false,0,true);
               if(!_loc1_.isAddedToLoadingList(_loc2_))
               {
                  _loc1_.load(Config.DIR_DATA + _loc2_ + ".swf",_loc2_,null,false);
               }
            }
            else
            {
               this.addHarvestAnimaion();
            }
         }
      }
      
      override protected function initSounds() : void
      {
         //this.mHarvestSound = ArmySoundManager.SC_HELI;
		 this.mHarvestSound = ArmySoundManager[(mItem as HFEItem).mHarvestSound]
		 this.mHarvestSound.load();
      }
      
      protected function harvestAnimationLoaded(param1:Event) : void
      {
         DCResourceManager.getInstance().removeEventListener(param1.type,this.harvestAnimationLoaded);
         this.mLoadingCallbackEventType = null;
         this.addHarvestAnimaion();
      }
      
      private function addHarvestAnimaion() : void
      {
         var _loc1_:Class = null;
         if(FeatureTuner.USE_HARVEST_ANIMATION)
         {
            _loc1_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_EFFECTS_NAME,HFEItem(mItem).mHarvestAnimation);
            this.mHarvestAnimation = new _loc1_();
            this.mHarvestAnimation.addEventListener(Event.ENTER_FRAME,this.checkHarvestFrame);
            this.mHarvestAnimation.x = mX;
            this.mHarvestAnimation.y = mY;
            this.mHarvestAnimation.mouseChildren = false;
            this.mHarvestAnimation.mouseEnabled = false;
            mScene.mSceneHud.addChild(this.mHarvestAnimation);
            playCollectionSound(this.mHarvestSound);
            mState = STATE_PLAY_HARVEST_ANIMATION;
         }
         else
         {
            this.mHarvestAnimation = null;
            mState = STATE_PRODUCTION_READY;
            this.updateGraphics();
         }
      }
      
      private function checkHarvestFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.totalFrames == _loc2_.currentFrame)
         {
            this.removeHarvestClip();
         }
      }
      
      private function removeHarvestClip() : void
      {
         if(this.mHarvestAnimation)
         {
            this.mHarvestAnimation.removeEventListener(Event.ENTER_FRAME,this.checkHarvestFrame);
            this.mHarvestAnimation.stop();
            if(this.mHarvestAnimation.parent)
            {
               this.mHarvestAnimation.parent.removeChild(this.mHarvestAnimation);
            }
            this.mHarvestAnimation = null;
         }
         super.handleProductionComplete();
         this.updateGraphics();
      }
      
      override public function handleProductionHarvested() : void
      {
         this.removeHarvestClip();
         this.remove();
      }
      
      override protected function getStateText() : String
      {
         var _loc2_:String = null;
         var _loc1_:Boolean = GameState.mInstance.visitingFriend();
         switch(mState)
         {
            case STATE_PRODUCING:
               if(_loc1_)
               {
                  return GameState.getText("BUILDING_STATUS_PRODUCING_HFE_VISITING");
               }
               return GameState.getText("BUILDING_STATUS_PRODUCING_HFE",[getTimeLeftString()]);
               break;
            case STATE_IDLE:
               return GameState.getText("BUILDING_STATUS_IDLE_HFE");
            case STATE_PLAY_HARVEST_ANIMATION:
            case STATE_PRODUCTION_READY:
               return GameState.getText("BUILDING_STATUS_PRODUCTION_READY_HFE");
            case STATE_BEING_HARVESTED:
               return GameState.getText("BUILDING_STATUS_BEING_HARVESTED_HFE");
            case STATE_WITHERED:
               if(_loc1_)
               {
                  return GameState.getText("BUILDING_STATUS_WHITERED_VISITING");
               }
               return GameState.getText("BUILDING_STATUS_WHITERED",[getCurrentPoductionName()]);
               break;
            default:
               return super.getStateText();
         }
      }
      
      override public function logicUpdate(param1:int) : Boolean
      {
         if(super.logicUpdate(param1))
         {
            return true;
         }
         switch(mState)
         {
            case STATE_PRODUCTION_READY:
               if(getProduction().isWithered())
               {
                  mState = STATE_WITHERED;
                  this.updateGraphics();
               }
         }
         return false;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this.mHarvestAnimation)
         {
            this.mHarvestAnimation.removeEventListener(Event.ENTER_FRAME,this.checkHarvestFrame);
            this.mHarvestAnimation.stop();
            if(this.mHarvestAnimation.parent)
            {
               this.mHarvestAnimation.parent.removeChild(this.mHarvestAnimation);
            }
            this.mHarvestAnimation = null;
         }
         if(this.mLoadingCallbackEventType)
         {
            DCResourceManager.getInstance().removeEventListener(this.mLoadingCallbackEventType,LoadingFinished);
         }
      }
      
      override public function setProgressIconVisibility(param1:Boolean) : void
      {
         super.setProgressIconVisibility(param1);
         calculateHFEObjectsAnimated();
      }
   }
}
