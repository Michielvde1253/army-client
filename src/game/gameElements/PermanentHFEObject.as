package game.gameElements
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import game.actions.RecapturePlayerBuildingAction;
   import game.battlefield.MapData;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.ObjectLoader;
   import game.isometric.SceneLoader;
   import game.items.MapItem;
   import game.items.PermanentHFEItem;
   import game.magicBox.MagicBoxTracker;
   import game.net.ServiceIDs;
   import game.player.GamePlayerProfile;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   
   public class PermanentHFEObject extends PlayerBuildingObject
   {
      
      public static var mLiberationMovie:MovieClip;
       
      
      public const FRAME_PLAYER_PRODUCING:int = 3;
      
      public const FRAME_ENEMY_CONTROL:int = 2;
      
      public const FRAME_PLAYER_CONTROL:int = 1;
      
      public var mCloudedGraphicVersion:MovieClip;
      
      private var mFlagPole:MovieClip;
      
      private var mNameSign:MovieClip;
      
      private var mCityName:TextField;
      
      private var mLoadingCallbackEventType:String;
      
      public function PermanentHFEObject(param1:int, param2:IsometricScene, param3:MapItem, param4:Point, param5:DisplayObject = null, param6:String = null)
      {
         super(param1,param2,param3,param4,param5,param6);
         mHealth = 0;
         mWalkable = false;
         mMovable = false;
      }
      
      override public function graphicsLoaded(param1:Sprite) : void
      {
         var _loc3_:Matrix = null;
         super.graphicsLoaded(param1);
         (param1 as MovieClip).gotoAndStop(this.FRAME_ENEMY_CONTROL);
         this.mFlagPole = (param1 as MovieClip).getChildByName("Flagpole") as MovieClip;
         this.mFlagPole.visible = false;
         this.mNameSign = (param1 as MovieClip).getChildByName("City_Name_Sign") as MovieClip;
         this.mCityName = this.mNameSign.getChildByName("City_Name") as TextField;
         this.mCityName.autoSize = TextFieldAutoSize.CENTER;
         this.mCityName.text = mItem.mName;
         if(LocalizationUtils.languageHasSpecialCharacters())
         {
            _loc3_ = this.mNameSign.transform.matrix;
            _loc3_.a = 1;
            _loc3_.b = 0;
            _loc3_.c = 0;
            _loc3_.d = 1;
            this.mNameSign.transform.matrix = _loc3_;
            LocalizationUtils.replaceFont(this.mCityName);
         }
         var _loc2_:ObjectLoader = GameState.mInstance.mScene.getObjectLoader();
         this.mCloudedGraphicVersion = _loc2_[mItem.mLoader](PermanentHFEItem(mItem).mCloudedGraphicsFile,PermanentHFEItem(mItem).mCloudedGraphics);
         this.setHealth(mHealth);
         GameState.mInstance.mScene.mTilemapGraphic.updatePermanentHFEs();
      }
      
      override public function setHealth(param1:int) : void
      {
         var _loc3_:Array = null;
         var _loc4_:GridCell = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:GridCell = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:* = getHealth() == 0;
         super.setHealth(param1);
         if(getHealth() > 0)
         {
            if(_loc2_)
            {
               _loc3_ = GameState.mInstance.mScene.getTilesUnderObject(this);
               _loc5_ = int(_loc3_.length);
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  (_loc4_ = _loc3_[_loc6_] as GridCell).mOwner = MapData.TILE_OWNER_FRIENDLY;
                  _loc6_++;
               }
               GameState.mInstance.mMapData.mUpdateRequired = true;
            }
         }
         else
         {
            _loc9_ = int((_loc7_ = GameState.mInstance.mScene.getTilesUnderObject(this)).length);
            _loc10_ = 0;
            while(_loc10_ < _loc9_)
            {
               (_loc8_ = _loc7_[_loc10_] as GridCell).mOwner = MapData.TILE_OWNER_ENEMY;
               _loc10_++;
            }
            GameState.mInstance.mMapData.mUpdateRequired = true;
            removeProduction();
            mState = STATE_RUINS;
         }
         this.updateGraphics();
      }
      
      private function updateGraphics() : void
      {
         if(!mGraphicsLoaded)
         {
            return;
         }
         this.mFlagPole.gotoAndStop(int(this.mFlagPole.totalFrames * mHealth / mMaxHealth));
         var _loc1_:MovieClip = mContainer.getChildAt(0) as MovieClip;
         if(getHealth() > 0)
         {
            if(getHealth() == mMaxHealth)
            {
               GameState.mInstance.mMapData.mUpdateRequired = true;
               this.mFlagPole.visible = false;
               if(mProduction && !mProduction.isReady() && !mProduction.isWithered() && !GameState.mInstance.visitingFriend() && FeatureTuner.USE_CITY_PRODUCTION_SMOKE_EFFECT)
               {
                  _loc1_.gotoAndStop(this.FRAME_PLAYER_PRODUCING);
               }
               else
               {
                  _loc1_.gotoAndStop(this.FRAME_PLAYER_CONTROL);
               }
            }
            else
            {
               _loc1_.gotoAndStop(this.FRAME_ENEMY_CONTROL);
               this.mFlagPole.visible = true;
            }
         }
         else
         {
            this.mFlagPole.visible = false;
            _loc1_.gotoAndStop(this.FRAME_ENEMY_CONTROL);
         }
      }
      
      public function celebratLiberation() : void
      {
         var _loc1_:DCResourceManager = DCResourceManager.getInstance();
         var _loc2_:String = Config.SWF_EFFECTS_NAME;
         if(_loc1_.isLoaded(_loc2_))
         {
            this.startCelebration();
         }
         else
         {
            this.mLoadingCallbackEventType = _loc2_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
            _loc1_.addEventListener(this.mLoadingCallbackEventType,this.celebrationLoaded,false,0,true);
            if(!_loc1_.isAddedToLoadingList(_loc2_))
            {
               _loc1_.load(Config.DIR_DATA + _loc2_ + ".swf",_loc2_,null,false);
            }
         }
      }
      
      protected function celebrationLoaded(param1:Event) : void
      {
         DCResourceManager.getInstance().removeEventListener(param1.type,this.celebrationLoaded);
         this.mLoadingCallbackEventType = null;
         this.startCelebration();
      }
      
      private function startCelebration() : void
      {
         var _loc1_:MovieClip = null;
         GameState.mInstance.moveCameraToSeeRenderable(this,true);
         ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_CITY_LIBERATED);
         if(FeatureTuner.USE_CITY_CELEBRATION_EFFECTS && !FeatureTuner.USE_LOW_SWF)
         {
            _loc1_ = new (DCResourceManager.getInstance().getSWFClass(Config.SWF_EFFECTS_NAME,"City_Liberated_01"))();
            _loc1_.addEventListener(Event.ENTER_FRAME,this.checkMovie);
            getContainer().addChild(_loc1_);
            _loc1_.x = (getTileSize().x - 1) * SceneLoader.GRID_CELL_SIZE / 2;
            _loc1_.y = (getTileSize().x - 1) * SceneLoader.GRID_CELL_SIZE / 2;
            _loc1_.play();
            GameState.mInstance.mCityLiberationPlaying = true;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this.mLoadingCallbackEventType)
         {
            DCResourceManager.getInstance().removeEventListener(this.mLoadingCallbackEventType,LoadingFinished);
         }
      }
      
      private function checkMovie(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            GameState.mInstance.mCityLiberationPlaying = false;
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.checkMovie);
            _loc2_.stop();
            if(_loc2_.parent)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
            _loc2_ = null;
         }
      }
      
      override public function checkProductionState() : void
      {
         if(mProduction)
         {
            if(mProduction.isReady())
            {
               mState = STATE_PRODUCTION_READY;
            }
            else
            {
               mState = STATE_PRODUCING;
            }
         }
         else
         {
            mState = STATE_READY;
         }
         this.updateGraphics();
      }
      
      override public function logicUpdate(param1:int) : Boolean
      {
         super.logicUpdate(param1);
         return false;
      }
      
      override public function setProduction(param1:String) : void
      {
         super.setProduction(param1);
         mState = STATE_PRODUCING;
         var _loc2_:Object = MapItem(mItem).getCraftingObjectByID(param1);
         var _loc3_:int = int(_loc2_.CostSupplies);
         var _loc4_:GamePlayerProfile;
         (_loc4_ = GameState.mInstance.mPlayerProfile).addSupplies(-_loc3_,MagicBoxTracker.LABEL_CITY_SUPPLY_CONVERSION,MagicBoxTracker.paramsObj((mItem as MapItem).mType,(mItem as MapItem).mId));
         var _loc5_:GridCell = getCell();
         var _loc6_:Object = {
            "coord_x":_loc5_.mPosI,
            "coord_y":_loc5_.mPosJ,
            "item_type":mItem.mId,
            "produces":"HFEDrives." + param1,
            "cost_supplies":_loc3_
         };
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.START_HOME_FRONT_PRODUCTION,_loc6_,false);
         if(Config.DEBUG_MODE)
         {
         }
         this.updateGraphics();
      }
      
      override public function setupFromServer(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         super.setupFromServer(param1);
         if(param1.produces != null)
         {
            _loc2_ = param1.produces.split(".");
            _loc3_ = String(_loc2_[1]);
            mProduction = new Production(MapItem(mItem),_loc3_);
            mState = STATE_PRODUCING;
            mProduction.setRemainingProductionTime(param1.next_action_at);
         }
      }
      
      override public function isWalkable() : Boolean
      {
         return mHealth == mMaxHealth;
      }
      
      override public function handleProductionHarvested() : void
      {
         this.checkProductionState();
      }
      
      override public function handleProductionComplete() : void
      {
         this.checkProductionState();
      }
      
      override protected function getStateText() : String
      {
         if(GameState.mInstance.mVisitingFriend)
         {
            if(mState == STATE_PRODUCING)
            {
               return GameState.getText("BUILDING_STATUS_PRODUCING_VISITING");
            }
            if(mState == STATE_PRODUCTION_READY)
            {
               return GameState.getText("BUILDING_STATUS_PRODUCTION_READY_VISITING");
            }
            return GameState.getText("BUILDING_STATUS_NO_PRODUCTION_VISITING");
         }
         switch(mState)
         {
            case STATE_PRODUCING:
               return GameState.getText("BUILDING_STATUS_PRODUCING_TOWN",[getTimeLeftString()]);
            case STATE_IDLE:
            case STATE_READY:
               return GameState.getText("BUILDING_STATUS_IDLE_TOWN");
            case STATE_PRODUCTION_READY:
               return GameState.getText("BUILDING_STATUS_PRODUCTION_READY_TOWN");
            case STATE_BEING_HARVESTED:
               return GameState.getText("BUILDING_STATUS_BEING_HARVESTED_TOWN");
            default:
               return super.getStateText();
         }
      }
      
      override public function MousePressed(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         super.MousePressed(param1);
         if(GameState.mInstance.mState != GameState.STATE_VISITING_NEIGHBOUR)
         {
            if(!isFullHealth())
            {
               _loc2_ = GameState.mInstance.searchUnitsInRange(this);
               GameState.mInstance.queueAction(new RecapturePlayerBuildingAction(_loc2_,this));
            }
            else if(mState == STATE_READY)
            {
               GameState.mInstance.mHUD.openProductionDialog(this);
            }
         }
      }
      
      override public function isHarvestingOver() : Boolean
      {
         return super.isHarvestingOver() || mState == STATE_READY;
      }
   }
}
