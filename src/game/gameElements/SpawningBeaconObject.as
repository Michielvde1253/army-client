package game.gameElements
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import game.actions.VisitNeighborSuppressEnemyInstallationAction;
   import game.battlefield.MapArea;
   import game.battlefield.MapData;
   import game.characters.EnemyUnit;
   import game.gui.TextEffect;
   import game.gui.TooltipHealth;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.items.EnemyAppearanceSetupItem;
   import game.items.EnemyInstallationItem;
   import game.items.ItemManager;
   import game.items.MapItem;
   import game.net.ServiceIDs;
   import game.sound.ArmySoundManager;
   import game.states.GameState;
   import game.utils.TimeUtils;
   
   public class SpawningBeaconObject extends EnemyInstallationObject
   {
      
      private static const SPAWNING_RADIUS:int = 2;
       
      
      private var mSetupItem:EnemyAppearanceSetupItem;
      
      public var mSpawnTimer:int;
      
      public var mSpawnDuration:int;
      
      public function SpawningBeaconObject(param1:int, param2:IsometricScene, param3:EnemyInstallationItem)
      {
         super(param1,param2,param3);
         this.mSetupItem = param3.mSpawnSetupItem;
         if(this.mSetupItem)
         {
            this.mSpawnDuration = param3.mReactionTime * 60000;
         }
         getContainer().mouseChildren = false;
      }
      
      override public function remove() : void
      {
         super.remove();
      }
      
      override public function setupFromServer(param1:Object) : void
      {
         super.setupFromServer(param1);
         this.mSpawnTimer = this.mSpawnDuration - param1.next_action_at * 1000;
      }
      
      override public function logicUpdate(param1:int) : Boolean
      {
         var _loc2_:GameState = null;
         var _loc3_:GridCell = null;
         var _loc4_:Object = null;
         var _loc5_:TextEffect = null;
         var _loc6_:MovieClip = null;
         if(mState != mNewState)
         {
            changeState(mNewState);
         }
         _loc2_ = GameState.mInstance;
         this.mSpawnTimer += param1;
         if(_loc2_.mState != GameState.STATE_VISITING_NEIGHBOUR)
         {
            if(!_loc2_.mVisitingFriend)
            {
               if(!mInQueueForAction)
               {
                  if(this.mSpawnTimer > this.mSpawnDuration)
                  {
                     if(isAlive())
                     {
                        if(_loc2_.mNeighborActionQueues)
                        {
                           if(_loc2_.mNeighborActionQueues.length == 0)
                           {
                              if(mScene.mNeighborAvatars == null || mScene.mNeighborAvatars.length == 0)
                              {
                                 this.spawnUnits();
                                 this.remove();
                                 _loc3_ = mScene.getCellAtLocation(mX,mY);
                                 _loc4_ = {
                                    "coord_x":_loc3_.mPosI,
                                    "coord_y":_loc3_.mPosJ,
                                    "item_type":ItemManager.getTableNameForItem(mItem)
                                 };
                                 _loc2_.mServer.serverCallServiceWithParameters(ServiceIDs.REMOVE_GAMEFIELD_ITEM,_loc4_,false);
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         mTextFXTimer -= param1;
         if(mTextFXQueue.length > 0 && mTextFXTimer <= 0)
         {
            _loc6_ = (_loc5_ = mTextFXQueue[0]).getClip();
            _loc6_.scaleX /= mScene.mContainer.scaleX;
            _loc6_.scaleY = _loc6_.scaleY;
            _loc6_.x = mContainer.x;
            _loc6_.y = mContainer.y + 50;
            _loc2_.mScene.mSceneHud.addChild(_loc6_);
            _loc5_.start();
            mTextFXQueue.splice(0,1);
            mTextFXTimer = 350;
         }
         switch(mState)
         {
            case STATE_WRECKING:
               if(getCurrentAnimationFrameLabel() == "end")
               {
                  mNewState = STATE_DESTROYED;
               }
               break;
            case STATE_DESTROYED:
               return true;
            case STATE_SUPPRESS:
               mActionDelayTimer -= param1;
               setLoadingBarPercent(1 - mActionDelayTimer / GENERIC_ACTION_DELAY_TIME);
               if(mActionDelayTimer <= 0)
               {
                  mActionDelayTimer = 0;
                  mNewState = STATE_IDLE;
                  hideLoadingBar();
               }
         }
         return false;
      }
      
      public function spawnUnits() : void
      {
         var _loc6_:GridCell = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:EnemyUnit = null;
         var _loc1_:GameState = GameState.mInstance;
         var _loc2_:GridCell = mScene.getCellAtLocation(mX,mY);
         var _loc3_:Array = MapArea.getAreaAroundCell(mScene,_loc2_,SPAWNING_RADIUS).getCells();
         _loc1_.moveCameraToSeeRenderable(this);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if((_loc6_ = _loc3_[_loc4_]).mObject && !(_loc6_.mObject is DebrisObject) || _loc6_.mCharacter || _loc6_.mCharacterComingToThisTile || !MapData.isTilePassable(_loc6_.mType))
            {
               _loc3_.splice(_loc4_,1);
               _loc4_--;
            }
            _loc4_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this.mSetupItem.mNumberOfUnits && _loc3_.length > 0)
         {
            _loc7_ = 0;
            _loc8_ = Math.random() * 100;
            _loc9_ = Math.random() * _loc3_.length;
            _loc2_ = _loc3_[_loc9_];
            _loc3_.splice(_loc9_,1);
            _loc10_ = 0;
            while(_loc10_ < this.mSetupItem.mEnemyUnits.length)
            {
               _loc7_ += this.mSetupItem.mEnemyUnitsP[_loc10_] as int;
               if(_loc8_ < _loc7_)
               {
                  _loc11_ = String((this.mSetupItem.mEnemyUnits[_loc10_] as Object).ID);
                  if(_loc12_ = _loc1_.spawnEnemy(ItemManager.getItem(_loc11_,"EnemyUnit") as MapItem,_loc2_,false))
                  {
                     _loc12_.startAirDrop();
                  }
                  break;
               }
               _loc10_++;
            }
            _loc5_++;
         }
      }
      
      override public function updateTooltip(param1:int, param2:TooltipHealth) : void
      {
         if(!isAlive())
         {
            return;
         }
         param2.setHealth(mHealth,mMaxHealth);
         param2.setTitleText(mName);
         if(GameState.mInstance.mState == GameState.STATE_VISITING_NEIGHBOUR)
         {
            param2.setDetailsText(GameState.getText("INSTALLATION_ENEMY_SMOKE_DESC_VISITING"));
         }
         else if(this.mSpawnDuration - this.mSpawnTimer > 0)
         {
            param2.setDetailsText(GameState.getText("INSTALLATION_ENEMY_SMOKE_DESC",[TimeUtils.milliSecondsToString(this.mSpawnDuration - this.mSpawnTimer)]));
         }
         else
         {
            param2.setDetailsText(GameState.getText("POPUP_ENEMY_SMOKE_EXPIRED"));
         }
      }
      
      override public function MousePressed(param1:MouseEvent) : void
      {
         var _loc2_:GameState = GameState.mInstance;
         if(mContainer.visible)
         {
            GameState.mInstance.moveCameraToSeeRenderable(this);
            if(_loc2_.mState == GameState.STATE_VISITING_NEIGHBOUR)
            {
               _loc2_.moveCameraToSeeRenderable(this);
               if(!mInQueueForAction)
               {
                  if(mNeighborActionAvailable)
                  {
                     if(mState != STATE_SUPPRESS)
                     {
                        mInQueueForAction = true;
                        _loc2_.queueAction(new VisitNeighborSuppressEnemyInstallationAction(this));
                     }
                  }
               }
            }
            else if(isAlive())
            {
               ArmySoundManager.getInstance().playSound(ArmySoundManager.SFX_UI_ERROR);
               GameState.mInstance.mHUD.openSpawningBeaconWindow();
            }
         }
      }
   }
}
