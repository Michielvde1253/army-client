package game.gameElements {
	import com.adobe.utils.StringUtil;
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.gui.TooltipHealth;
	import game.isometric.GridCell;
	import game.isometric.IsometricScene;
	import game.isometric.ObjectLoader;
	import game.items.MapItem;
	import game.items.ResourceBuildingItem;
	import game.magicBox.MagicBoxTracker;
	import game.net.Friend;
	import game.net.ServiceIDs;
	import game.player.GamePlayerProfile;
	import game.states.GameState;
	import game.characters.PlayerUnit;

	public class HospitalBuilding extends PlayerBuildingObject {


		private var mReadyToHeal: Boolean;

		public function HospitalBuilding(param1: int, param2: IsometricScene, param3: MapItem, param4: Point, param5: DisplayObject = null, param6: String = null) {
			super(param1, param2, param3, param4, param5, param6);
			mWalkable = false;
			mState = STATE_READY;
			this.mReadyToHeal = true;
		}

		public function readyToHeal(): Boolean {
			return this.mReadyToHeal;
		}
	
		public function checkNeighbours(){
			var neighbours:Array = GameState.mInstance.searchNearbyUnits(getCell(),1,2,2, false);
			var neighbour:PlayerUnit = null;
			var i;
			for(i in neighbours){
				neighbour = neighbours[i] as PlayerUnit;
				if(neighbour.getHealth() < neighbour.mMaxHealth){
					neighbour.healToMax();
					this.mReadyToHeal = false;
				}
			}
		}

		override public function graphicsLoaded(param1: Sprite): void {
			super.graphicsLoaded(param1);
			this.updateGraphics(mHealth);
		}

		override public function logicUpdate(param1: int): Boolean {
			super.logicUpdate(param1);
			/*
         if(mState == STATE_PRODUCING)
         {
            this.setSpeedUpIconVisibility(true);
         }
         else
         {
            this.setSpeedUpIconVisibility(false);
         }
         switch(mState)
         {
            case STATE_WORKING_ON_BUILDING:
               break;
            case STATE_PRODUCING:
               if(this.mGoToHireDialog)
               {
                  GameState.mInstance.mHUD.openHireFriendsForProductionDialog(this);
                  this.mGoToHireDialog = false;
               }
         }
         return false;
		 */
		 return false;
		}

		/*
      override public function setHealth(param1:int) : void
      {
         mHealth = mMaxHealth;
         var _loc2_:int = mHealth;
         this.updateGraphics(_loc2_);
      }
*/

		private function updateGraphics(param1: int): void {
			var _loc3_: Sprite = null;
			var _loc4_: String = null;
			var _loc5_: DCResourceManager = null;
			var _loc6_: String = null;
			var _loc7_: String = null;
			var _loc8_: Object = null;
			if (!mGraphicsLoaded) {
				return;
			}
			var _loc2_: ObjectLoader = new ObjectLoader();
			if (mHealth <= 0) {
				_loc4_ = "swf/buildings_player";
				if ((_loc5_ = DCResourceManager.getInstance()).isLoaded(_loc4_)) {
					removeSprite();
					_loc6_ = "building_destroyed_" + getTileSize().x + "x" + getTileSize().y;
					_loc7_ = "InnerMovieClip";
					_loc3_ = _loc2_[_loc7_]("swf/buildings_player", _loc6_);
					addSprite(_loc3_);
				} else {
					_loc5_.addEventListener(_loc4_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE, this.ruinsLoadingFinished, false, 0, true);
					if (!_loc5_.isAddedToLoadingList(_loc4_)) {
						_loc5_.load(Config.DIR_DATA + _loc4_ + ".swf", _loc4_, null, false);
					}
				}
			} else {
				_loc8_ = mContainer.getChildAt(0);
				if (param1 == 0) {
					_loc3_ = _loc2_[mItem.mLoader](mItem.getIconGraphicsFile(), mItem.getIconGraphics());
					removeSprite();
					addSprite(_loc3_);
				} else if (mHealth < mMaxHealth) {
					_loc8_.gotoAndStop(3);
				}
				//else if(mState == STATE_PRODUCING)
				//{
				//   _loc8_.gotoAndStop(2);
				//}
				else {
					_loc8_.gotoAndStop(1);
				}
			}
		}

		override public function updateTooltip(param1: int, param2: TooltipHealth): void {
			param2.setTitleText(mItem.mName);
			param2.setHealth(this.mHealth, this.mMaxHealth);
			if (!isFullHealth()) {
				if (mState == STATE_RUINS) {
					param2.setDetailsText(GameState.getText("BUILDING_STATUS_RUINS"));
				} else {
					param2.setDetailsText(GameState.getText("BUILDING_STATUS_DAMAGED"));
				}
			} else if(this.mReadyToHeal) {
				param2.setDetailsText(GameState.getText("BUILDING_HOSPITAL_READY"));
			} else {
				param2.setDetailsText(GameState.getText("BUILDING_HOSPITAL_NOT_READY"));
			}
		}
	
		override public function isMovable(): Boolean {
			if (mState == STATE_RUINS) {
				return false;
			}
			return mMovable;
		}

		/*
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
         this.updateGraphics(mHealth);
      }
	  */

		/*
      public function setSpeedUpIconVisibility(param1:Boolean) : void
      {
         if(!this.mSpeedUpIcon)
         {
            return;
         }
         var _loc2_:Point = getIconPosition();
         this.mSpeedUpIcon.x = _loc2_.x;
         this.mSpeedUpIcon.y = _loc2_.y;
         if(this.mSpeedUpIcon.visible == param1)
         {
            return;
         }
         if(param1)
         {
            this.mSpeedUpIcon.visible = true;
            mScene.mSceneHud.addChild(this.mSpeedUpIcon);
         }
         else
         {
            this.mSpeedUpIcon.visible = false;
            if(this.mSpeedUpIcon.parent)
            {
               this.mSpeedUpIcon.parent.removeChild(this.mSpeedUpIcon);
            }
         }
      }
	  */

		/*
      override public function setProduction(param1:String) : void
      {
         super.setProduction(param1);
         mState = STATE_PRODUCING;
         var _loc2_:Object = MapItem(mItem).getCraftingObjectByID(param1);
         var _loc3_:int = int(_loc2_.CostMoney);
         var _loc4_:GamePlayerProfile;
         (_loc4_ = GameState.mInstance.mPlayerProfile).addMoney(-_loc3_,MagicBoxTracker.LABEL_RESOURCE_PRODUCTION,MagicBoxTracker.paramsObj((mItem as MapItem).mType,(mItem as MapItem).mId,param1));
         var _loc5_:GridCell = getCell();
         var _loc6_:Object = {
            "coord_x":_loc5_.mPosI,
            "coord_y":_loc5_.mPosJ,
            "item_id":mItem.mId,
            "produces":"BuildingDrives." + param1,
            "cost_money":_loc3_,
            "item_type":"ResourceBuilding"
         };
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.START_BUILDING_PRODUCTION,_loc6_,false);
         if(Config.DEBUG_MODE)
         {
         }
         this.updateGraphics(mHealth);
         this.mGoToHireDialog = true;
      }
	  */

		override public function setupFromServer(param1: Object): void {
			var _loc2_: Array = null;
			var _loc3_: String = null;
			var _loc4_: String = null;
			var _loc5_: int = 0;
			super.setupFromServer(param1);
			//this.resetHelpingFriends();
			if (param1.produces != null) {
				_loc2_ = (param1.produces as String).split(".");
				_loc3_ = String(_loc2_[1]);
				mProduction = new Production(MapItem(mItem), _loc3_, Production.TIME_DEFAULT, Production.TIME_DEFAULT, this);
				mProduction.setRemainingProductionTime(param1.next_action_at);
				//this.checkProductionState();
				//if (_loc4_ = String(param1.helping_friend_ids)) {
				//	this.mFriendUIDs = _loc4_.split(",");
				//	_loc5_ = 0;
				//	while (_loc5_ < this.mFriendUIDs.length) {
				//		this.mFriendUIDs[_loc5_] = StringUtil.trim(this.mFriendUIDs[_loc5_]);
				//		_loc5_++;
				//	}
				//}
			}
		}

		/*
      public function refreshHelpingFriends() : void
      {
      }
      
      private function failHelpingFriendLoader(param1:Event) : void
      {
         this.createDummyHelpingFriend();
      }
      
      private function completeHelpingFriendLoader(param1:Event) : void
      {
         var event:Event = param1;
         try
         {
         }
         catch(error:Error)
         {
            createDummyHelpingFriend();
            return;
         }
         this.createDummyHelpingFriend();
      }
      
      private function sortFriends() : void
      {
         var _loc2_:Friend = null;
         var _loc3_:int = 0;
         var _loc4_:Friend = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.mFriends.length)
         {
            _loc2_ = this.mFriends[_loc1_];
            _loc3_ = this.mFriendUIDs.indexOf(_loc2_.mUserID);
            if(_loc3_ > 0)
            {
               if(_loc3_ != _loc1_)
               {
                  _loc4_ = this.mFriends[_loc3_];
                  this.mFriends[_loc3_] = _loc2_;
                  this.mFriends[_loc1_] = _loc4_;
               }
            }
            _loc1_++;
         }
      }
      
      private function createDummyHelpingFriend() : void
      {
         var _loc1_:Friend = new Friend(GameState.getText("YOUR_FRIEND"),"10","10",Config.DIR_DATA + "icons/default_avatar.png",0,0,0,0,true,null,null,false,false,false);
         this.mFriends.push(_loc1_);
      }
      
      public function getHelpingFriends() : Array
      {
         return this.mFriends;
      }
      
      public function resetHelpingFriends() : void
      {
         this.mFriends = new Array();
         this.mFriendUIDs = new Array();
      }
	  */

		/*
      override public function handleProductionHarvested() : void
      {
         this.checkProductionState();
      }
      
      override public function handleProductionComplete() : void
      {
         this.checkProductionState();
      }
*/

		override protected function getStateText(): String {
			if (GameState.mInstance.mVisitingFriend) {
				if (mState == STATE_PRODUCING) {
					return GameState.getText("BUILDING_STATUS_PRODUCING_VISITING");
				}
				if (mState == STATE_PRODUCTION_READY) {
					return GameState.getText("BUILDING_STATUS_PRODUCTION_READY_VISITING");
				}
				return mItem.getDescription();
			}
			switch (mState) {
				case STATE_PRODUCING:
					return GameState.getText("RESOURCE_BUILDING_STATUS_PRODUCING", [getTimeLeftCountdown()]);
				case STATE_IDLE:
				case STATE_READY:
					return GameState.getText("RESOURCE_BUILDING_STATUS_IDLE");
				case STATE_PRODUCTION_READY:
					return GameState.getText("RESOURCE_BUILDING_STATUS_PRODUCTION_READY");
				case STATE_BEING_HARVESTED:
					return GameState.getText("RESOURCE_BUILDING_STATUS_BEING_HARVESTED");
				default:
					return super.getStateText();
			}
		}

		public function getHealCostSupplies(): int {
			return (mItem as ResourceBuildingItem).mHealCostSupplies * (mMaxHealth - mHealth) / mMaxHealth;
		}

		/*
      override public function MousePressed(param1:MouseEvent) : void
      {
         super.MousePressed(param1);
         this.openProductionDialog();
      }
  */

		/*
      public function openProductionDialog() : void
      {
         if(GameState.mInstance.mState != GameState.STATE_VISITING_NEIGHBOUR)
         {
            if(isFullHealth())
            {
               if(mState == STATE_READY)
               {
                  GameState.mInstance.mHUD.openProductionDialog(this);
               }
               else if(mState == STATE_PRODUCING)
               {
                  this.mGoToHireDialog = true;
               }
            }
         }
      }
*/

		/*
      override public function isHarvestingOver() : Boolean
      {
         return super.isHarvestingOver() || mState == STATE_READY;
      }
	  */

		protected function ruinsLoadingFinished(param1: Event): void {
			DCResourceManager.getInstance().removeEventListener(param1.type, this.ruinsLoadingFinished);
			this.updateGraphics(mHealth);
		}

		override public function destroy(): void {
			super.destroy();
			/*
         if(this.mSpeedUpIcon.parent)
         {
            this.mSpeedUpIcon.parent.removeChild(this.mSpeedUpIcon);
         }
         this.mSpeedUpIcon = null;
		  */
		}
	}
}