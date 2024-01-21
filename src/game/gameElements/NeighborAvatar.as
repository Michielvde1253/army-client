package game.gameElements
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import game.actions.Action;
   import game.actions.NeighborActionQueue;
   import game.gui.IconLoader;
   import game.gui.button.ArmyButton;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.elements.Renderable;
   import game.net.Friend;
   import game.net.FriendsCollection;
   import game.net.ServiceIDs;
   import game.player.RankManager;
   import game.states.GameState;
   
   public class NeighborAvatar extends Sprite
   {
      
      private static const RANK_ICON_SIZE:int = 45;
      
      private static const STATE_WAIT:int = 0;
      
      private static const STATE_MOVING:int = 1;
      
      private static const STATE_HOLD_IN_TARGET:int = 2;
      
      private static const STATE_EXECUTE:int = 3;
      
      private static const STATE_OVER:int = 4;
      
      private static const DISAPPEAR_TIME:int = 3000;
      
      private static const HOLD_IN_TARGET_TIME:int = 1000;
      
      public static var smMouseOver:Boolean;
       
      
      private var mState:int;
      
      private var mActionQueue:NeighborActionQueue;
      
      private var mCurrentActions:Array;
      
      private var mMainClip:MovieClip;
      
      private var mRankSlot:MovieClip;
      
      private var mButtonCancel:ArmyButton;
      
      private var mButtonAccept:ArmyButton;
      
      private var mPhoto:Sprite;
      
      private var mFriend:Friend;
      
      private var mTimer:int;
      
      private var mDestLoc:Point;
      
      private var mBaseLoc:Point;
      
      private var mMovingTime:Number = 0;
      
      private var mActionsStarted:int = 0;
      
      private var mTimeToMoveOnScreen:Number;
      
      private var mTimeToHoldInTarget:int;
      
      private const MILLISECS_TO_MOVE_ONE_PIXEL:int = 10;
      
      public function NeighborAvatar(param1:NeighborActionQueue)
      {
         super();
         this.mState = STATE_WAIT;
         this.mActionQueue = param1;
         this.mCurrentActions = new Array();
         var _loc2_:Class = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"hud_visitor_card");
         this.mMainClip = new _loc2_();
         addChild(this.mMainClip);
         var _loc3_:IsometricScene = GameState.mInstance.mScene;
         var _loc4_:GridCell = (param1.mTargetObjects[0] as Renderable).getCell();
         x = _loc3_.getCenterPointXOfCell(_loc4_) - this.mMainClip.width / 2;
         y = _loc3_.getCenterPointYOfCell(_loc4_) - _loc3_.mGridDimY / 2 - this.mMainClip.height;
         this.mFriend = FriendsCollection.smFriends.GetFriend(this.mActionQueue.mUserID);
         this.mMainClip.gotoAndStop(1);
         this.mPhoto = this.mMainClip.getChildByName("Icon") as Sprite;
         this.mPhoto.mouseChildren = false;
         this.mPhoto.mouseEnabled = false;
         if(this.mFriend != null)
         {
            if(this.mFriend.mPicID != null)
            {
               if(this.mFriend.mPicID != "")
               {
                  IconLoader.addIconPicture(this.mPhoto,this.mFriend.mPicID,this.centerImage);
               }
            }
         }
         this.mRankSlot = this.mMainClip.getChildByName("Rank_Container") as MovieClip;
         this.mRankSlot.mouseChildren = false;
         this.mRankSlot.mouseEnabled = false;
         IconLoader.addIcon(this.mRankSlot,RankManager.getAdapterByIndex(this.mFriend.getRank()),this.rankLoaded);
      }
      
      public function rankLoaded(param1:Sprite) : void
      {
         param1.scaleX = RANK_ICON_SIZE / param1.height;
         param1.scaleY = RANK_ICON_SIZE / param1.height;
      }
      
      public function centerImage(param1:Sprite) : void
      {
         param1.mouseChildren = false;
         param1.mouseEnabled = false;
         param1.x = -param1.width / 2;
         param1.y = -param1.height / 2;
      }
      
      public function canBeRemoved() : Boolean
      {
         var _loc1_:int = 0;
         if(this.mState == STATE_OVER)
         {
            _loc1_ = 0;
            while(_loc1_ < this.mCurrentActions.length)
            {
               if(this.mCurrentActions[_loc1_])
               {
                  return false;
               }
               _loc1_++;
            }
            return true;
         }
         return false;
      }
      
      public function update(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Action = null;
         var _loc4_:TextField = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Action = null;
         var _loc10_:GridCell = null;
         var _loc11_:IsometricScene = null;
         if(this.mCurrentActions)
         {
            _loc2_ = 0;
            while(_loc2_ < this.mActionsStarted)
            {
               _loc3_ = this.mCurrentActions[_loc2_];
               if(_loc3_)
               {
                  _loc3_.update(param1);
                  if(_loc3_.isOver())
                  {
                     this.mCurrentActions[_loc2_] = null;
                  }
               }
               _loc2_++;
            }
         }
         if(this.mState == STATE_WAIT)
         {
            if(this.mMainClip.currentFrame > this.mMainClip.framesLoaded >> 1)
            {
               if(!this.mButtonAccept)
               {
                  this.mButtonAccept = Utils.createBasicButton(this.mMainClip,"Button_Accept",this.acceptClicked);
                  if(this.mButtonAccept)
                  {
                     this.mButtonAccept.setText(GameState.getText("BUTTON_ACCEPT"),"Text_Title");
                  }
               }
               if(!this.mButtonCancel)
               {
                  this.mButtonCancel = Utils.createBasicButton(this.mMainClip,"Button_Cancel",this.rejectClicked);
               }
               if(this.mMainClip.currentFrameLabel == "end")
               {
                  this.mMainClip.stop();
                  if(_loc4_ = this.mMainClip.getChildByName("Text_Title") as TextField)
                  {
                     _loc4_.text = this.mFriend.mName;
                  }
                  if(_loc4_ = this.mMainClip.getChildByName("Text_Amount") as TextField)
                  {
                     _loc4_.text = GameState.getText("TOOLTIP_HUD_FRIEND_HELP");
                  }
               }
            }
            if(this.mTimer > 0)
            {
               this.mTimer -= param1;
               if(this.mTimer <= 0)
               {
                  this.mTimer = 0;
                  this.mMainClip.gotoAndStop(1);
                  this.mButtonAccept = null;
                  this.mButtonCancel = null;
               }
            }
         }
         else if(this.mState == STATE_MOVING)
         {
            _loc5_ = 1 - this.mMovingTime / this.mTimeToMoveOnScreen;
            this.mMovingTime += (param1 << 1) + _loc5_ * (param1 << 2);
            _loc6_ = this.mMovingTime / this.mTimeToMoveOnScreen;
            if(this.mMovingTime >= this.mTimeToMoveOnScreen)
            {
               this.mMovingTime = 0;
               if(this.startCurrentAction())
               {
                  this.mState = STATE_HOLD_IN_TARGET;
               }
               else
               {
                  this.mState = STATE_EXECUTE;
               }
               x = this.mDestLoc.x;
               y = this.mDestLoc.y;
            }
            else
            {
               _loc7_ = this.mDestLoc.x - this.mBaseLoc.x;
               _loc8_ = this.mDestLoc.y - this.mBaseLoc.y;
               x = this.mBaseLoc.x + _loc6_ * _loc7_;
               y = this.mBaseLoc.y + _loc6_ * _loc8_;
            }
         }
         else if(this.mState == STATE_HOLD_IN_TARGET)
         {
            this.mMovingTime += param1;
            if(this.mMovingTime >= this.mTimeToHoldInTarget)
            {
               this.mMovingTime = 0;
               this.mState = STATE_EXECUTE;
            }
         }
         else if(this.mState == STATE_EXECUTE)
         {
            smMouseOver = false;
            if(_loc9_ = this.mActionQueue.getNextAction())
            {
               this.mCurrentActions.push(_loc9_);
               this.mDestLoc = new Point();
               this.mBaseLoc = new Point();
               _loc10_ = _loc9_.mTarget.getCell();
               _loc11_ = GameState.mInstance.mScene;
               this.mDestLoc.x = _loc11_.getCenterPointXOfCell(_loc10_) - this.mMainClip.width / 2;
               this.mDestLoc.y = _loc11_.getCenterPointYOfCell(_loc10_) - _loc11_.mGridDimY / 2 - this.mMainClip.height;
               this.mBaseLoc.x = x;
               this.mBaseLoc.y = y;
               this.mTimeToMoveOnScreen = (Math.abs(this.mDestLoc.x - this.mBaseLoc.x) + Math.abs(this.mDestLoc.y - this.mBaseLoc.y)) * this.MILLISECS_TO_MOVE_ONE_PIXEL;
               if(this.mTimeToMoveOnScreen < 100)
               {
                  this.mTimeToHoldInTarget = Renderable.GENERIC_ACTION_DELAY_TIME;
                  this.mTimeToMoveOnScreen = 1;
               }
               else
               {
                  this.mTimeToHoldInTarget = HOLD_IN_TARGET_TIME;
               }
               this.mState = STATE_MOVING;
               this.mMovingTime = 0;
            }
            else
            {
               this.mState = STATE_OVER;
            }
         }
      }
      
      private function startCurrentAction() : Boolean
      {
         var _loc2_:Action = null;
         var _loc1_:Boolean = false;
         if(this.mCurrentActions[this.mActionsStarted])
         {
            _loc2_ = this.mCurrentActions[this.mActionsStarted] as Action;
            _loc2_.start();
            if(_loc2_.isOver())
            {
               _loc1_ = false;
            }
            else
            {
               _loc1_ = true;
            }
            ++this.mActionsStarted;
         }
         return _loc1_;
      }
      
      private function removeListeners() : void
      {
      }
      
      private function acceptClicked(param1:MouseEvent) : void
      {
         this.mState = STATE_EXECUTE;
         this.mButtonAccept.setVisible(false);
         this.mButtonCancel.setVisible(false);
         this.mMainClip.gotoAndStop(1);
         smMouseOver = false;
         this.removeListeners();
      }
      
      private function rejectClicked(param1:MouseEvent) : void
      {
         this.mState = STATE_OVER;
         smMouseOver = false;
         var _loc2_:Object = {"neighbor_user_id":this.mFriend.mFacebookID};
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.REJECT_NEIGHBOR_HELP_ACTIONS,_loc2_,false);
         if(Config.DEBUG_MODE)
         {
         }
         this.removeListeners();
      }
      
      private function over(param1:MouseEvent) : void
      {
         var _loc2_:Renderable = null;
         smMouseOver = true;
         if(this.mMainClip.currentFrame == 1)
         {
            this.mMainClip.gotoAndPlay(1);
         }
         var _loc3_:int = int(this.mActionQueue.mTargetObjects.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mActionQueue.mTargetObjects[_loc4_] as Renderable;
            _loc2_.setSelected();
            _loc4_++;
         }
         this.mTimer = 0;
      }
      
      private function setTimer(param1:MouseEvent) : void
      {
         smMouseOver = false;
         this.mTimer = DISAPPEAR_TIME;
      }
   }
}
