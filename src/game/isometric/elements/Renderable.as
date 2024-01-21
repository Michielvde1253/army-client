package game.isometric.elements
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import game.actions.Action;
   import game.characters.AnimationController;
   import game.characters.EnemyUnit;
   import game.gameElements.PermanentHFEObject;
   import game.gui.TooltipHealth;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.ToScreen;
   import game.items.MapItem;
   import game.sound.ArmySoundManager;
   import game.sound.PlayableSoundObject;
   import game.sound.SoundCollection;
   import game.states.GameState;
   
   public class Renderable extends Element
   {
      
      public static const GENERIC_ACTION_DELAY_TIME:int = 2500;
      
      private static var tmpPoint:Point = new Point();
      
      private static var mPointTmp:Point = new Point();
       
      
      protected var mContainer:DisplayContainer;
      
      protected var mTileSize:Vector3D;
      
      protected var mAnimationController:AnimationController;
      
      protected var mSoundTrasform:SoundTransform;
      
      public var mItem:MapItem;
      
      public var mSortIdx:int = 0;
      
      public var mSorted:Boolean;
      
      public var mVisible:Boolean;
      
      protected var mMovable:Boolean;
      
      protected var mRotatable:Boolean;
      
      public var mKilledByFireMission:Boolean;
      
      protected var mWalkable:Boolean;
      
      private var mPlaceableOnAllTiles:Boolean;
      
      public var mHealthWarningVisible:Boolean;
      
      public var mLowHealthIcon:MovieClip;
      
      private var mActionDelayIcon:MovieClip;
      
      public var mActionDelayTimer:int = 0;
      
      public var mNeighborActionAvailable:Boolean;
      
      protected var mSoundChannels:Array;
      
      public var mAttackSounds:SoundCollection;
      
      public var mAttackSoundsSecondary:SoundCollection;
      
      protected var mDieSounds:SoundCollection;
      
      public var mMoveSounds:SoundCollection;
      
      protected var mGraphicsLoaded:Boolean;
      
      private var mListenerObjectClicked:Function;
      
      private var mListenerObjectMouseOut:Function;
      
      private var mListenerObjectMouseOver:Function;
      
      private var mListenerObjectMousePressed:Function;
      
      private var mListenerObjectMouseReleased:Function;
      
      private var mListenerObjectRollOver:Function;
      
      private var mListenerObjectRollOut:Function;
      
      public function Renderable(param1:int, param2:IsometricScene, param3:MapItem, param4:String = null)
      {
         this.mTileSize = new Vector3D(1,1,1);
         super(param1,param2,param4);
         this.mContainer = new DisplayContainer(this);
         this.mGraphicsLoaded = true;
         this.mMovable = false;
         this.mRotatable = false;
         this.mWalkable = false;
         this.mItem = param3;
         this.mHealthWarningVisible = false;
         this.mNeighborActionAvailable = true;
         this.mSoundTrasform = new SoundTransform();
         this.mSoundChannels = new Array();
         this.showHealthWarning(false);
      }
      
      public function setTileSize(param1:Vector3D) : void
      {
         this.mTileSize = param1;
      }
      
      public function getTileSize() : Vector3D
      {
         return this.mTileSize;
      }
      
      public function getIconPosition() : Point
      {
         var _loc1_:Point = new Point();
         _loc1_.x = mScene.getLeftUpperXOfCell(this.getCell()) + this.getTileSize().x * (mScene.mGridDimX >> 1);
         _loc1_.y = mScene.getLeftUpperYOfCell(this.getCell()) + mScene.mGridDimY - 20;
         return _loc1_;
      }
      
      public function reactToZoom(param1:Number) : void
      {
         var _loc2_:MovieClip = null;
         if(this.mLowHealthIcon)
         {
            this.mLowHealthIcon.scaleX = 1 / param1;
            this.mLowHealthIcon.scaleY = 1 / param1;
         }
         if(this.mActionDelayIcon)
         {
            this.mActionDelayIcon.scaleX = 1 / param1;
            this.mActionDelayIcon.scaleY = 1 / param1;
         }
         if(this is EnemyUnit)
         {
            _loc2_ = EnemyUnit(this).mActivationIcon;
            if(_loc2_)
            {
               _loc2_.scaleX = 1 / param1;
               _loc2_.scaleY = 1 / param1;
            }
         }
      }
      
      protected function initSounds() : void
      {
         this.mDieSounds = ArmySoundManager.SC_EMPTY;
         this.mAttackSounds = ArmySoundManager.SC_EMPTY;
         this.mAttackSoundsSecondary = ArmySoundManager.SC_EMPTY;
         this.mMoveSounds = ArmySoundManager.SC_EMPTY;
      }
      
      public function addSprite(param1:DisplayObject) : void
      {
         this.removeSprite();
         this.mContainer.addChildAt(param1,0);
      }
      
      public function graphicsLoaded(param1:Sprite) : void
      {
         this.addSprite(param1);
      }
      
      public function removeSprite() : void
      {
         if(this.mContainer.numChildren > 0)
         {
            this.mContainer.removeChildAt(0);
         }
      }
      
      public function isMovable() : Boolean
      {
         return this.mMovable && this.isAlive();
      }
      
      public function isRotatable() : Boolean
      {
         return this.mRotatable;
      }
      
      public function isWalkable() : Boolean
      {
         return this.mWalkable;
      }
      
      public function setWalkable(param1:Boolean) : void
      {
         this.mWalkable = param1;
      }
      
      public function isPlaceableOnAllTiles() : Boolean
      {
         return this.mPlaceableOnAllTiles;
      }
      
      public function setPlaceableOnAllTiles(param1:Boolean) : void
      {
         this.mPlaceableOnAllTiles = param1;
      }
      
      override public function getContainer() : DisplayContainer
      {
         return this.mContainer;
      }
      
      public function MousePressed(param1:MouseEvent) : void
      {
      }
      
      public function neighborClicked(param1:String) : Action
      {
         return null;
      }
      
      public function MouseOver(param1:MouseEvent) : void
      {
      }
      
      public function MouseOut(param1:MouseEvent) : void
      {
      }
      
      public function addedToActionQueue() : void
      {
         this.mContainer.alpha = 0.5;
      }
      
      public function removedFromActionQueue() : void
      {
         this.mContainer.alpha = 1;
      }
      
      public function setSelected() : void
      {
      }
      
      public function spendNeighborAction() : void
      {
         if(GameState.mInstance.mState == GameState.STATE_VISITING_NEIGHBOUR)
         {
            this.mNeighborActionAvailable = false;
            this.mContainer.alpha = 0.5;
         }
      }
      
      public function addListenerObjectMouseOver(param1:Function) : void
      {
      }
      
      public function addListenerObjectMouseOut(param1:Function) : void
      {
      }
      
      public function addListenerObjectRollOver(param1:Function) : void
      {
      }
      
      public function addListenerObjectRollOut(param1:Function) : void
      {
      }
      
      public function addListenerObjectClicked(param1:Function) : void
      {
         if(this.mListenerObjectClicked == null)
         {
            this.mContainer.addEventListener(MouseEvent.CLICK,this.reportMouseClick,false);
         }
         this.mListenerObjectClicked = param1;
      }
      
      public function addListenerObjectMousePressed(param1:Function) : void
      {
         if(this.mListenerObjectMousePressed == null)
         {
            this.mContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.reportMousePressed,false);
         }
         this.mListenerObjectMousePressed = param1;
      }
      
      public function addListenerObjectMouseReleased(param1:Function) : void
      {
         if(this.mListenerObjectMouseReleased == null)
         {
            this.mContainer.addEventListener(MouseEvent.MOUSE_UP,this.reportMouseReleased,false);
         }
         this.mListenerObjectMouseReleased = param1;
      }
      
      public function removeListenerObjectMouseReleased() : void
      {
         if(this.mListenerObjectMouseReleased != null)
         {
            this.mContainer.removeEventListener(MouseEvent.MOUSE_UP,this.reportMouseReleased);
            this.mListenerObjectMouseReleased = null;
         }
      }
      
      public function removeListenerObjectMouseOver() : void
      {
      }
      
      public function removeListenerObjectMouseOut() : void
      {
      }
      
      public function removeListenerObjectRollOut() : void
      {
      }
      
      public function removeListenerObjectRollOver() : void
      {
      }
      
      public function removeListenerObjectClicked() : void
      {
         if(this.mListenerObjectClicked != null)
         {
            this.mContainer.removeEventListener(MouseEvent.CLICK,this.reportMouseClick);
            this.mListenerObjectClicked = null;
         }
      }
      
      public function removeListenerObjectPressed() : void
      {
         if(this.mListenerObjectMousePressed != null)
         {
            this.mContainer.removeEventListener(MouseEvent.MOUSE_DOWN,this.reportMousePressed);
            this.mListenerObjectMousePressed = null;
         }
      }
      
      protected function reportMouseClick(param1:MouseEvent) : void
      {
         if(mEnabled)
         {
            if(this.mListenerObjectClicked != null)
            {
               this.mListenerObjectClicked(param1);
            }
         }
      }
      
      protected function reportMousePressed(param1:MouseEvent) : void
      {
         if(mEnabled)
         {
            if(this.mListenerObjectMousePressed != null)
            {
               this.mListenerObjectMousePressed(param1);
            }
         }
      }
      
      protected function reportMouseReleased(param1:MouseEvent) : void
      {
         if(mEnabled)
         {
            if(!mScene.mMouseScrolling && !mScene.mTickCrossActive)
            {
               if(!mScene.mAnyScrollKeyPressed)
               {
                  if(this.mListenerObjectMouseReleased != null)
                  {
                     this.mListenerObjectMouseReleased(param1);
                  }
               }
            }
         }
      }
      
      public function reportMouseOver(param1:MouseEvent) : void
      {
         if(mEnabled)
         {
            if(this.mListenerObjectMouseOver != null)
            {
               this.mListenerObjectMouseOver(param1);
            }
         }
      }
      
      public function reportMouseOut(param1:MouseEvent) : void
      {
         if(mEnabled)
         {
            if(this.mListenerObjectMouseOut != null)
            {
               this.mListenerObjectMouseOut(param1);
            }
         }
      }
      
      public function reportRollOut(param1:MouseEvent) : void
      {
         if(mEnabled)
         {
            if(this.mListenerObjectRollOut != null)
            {
               this.mListenerObjectRollOut(param1);
            }
         }
      }
      
      public function playSound(param1:String, param2:Function = null, param3:Number = 1, param4:Number = 0) : Object
      {
         var _loc5_:Object;
         if(!(_loc5_ = ArmySoundManager.getInstance().playSound(param1,param3,param4)))
         {
            return null;
         }
         return null;
      }
      
      public function playCollectionSound(param1:SoundCollection, param2:Function = null, param3:Function = null, param4:Number = 1, param5:Number = 0) : PlayableSoundObject
      {
         if(!FeatureTuner.USE_SOUNDS)
         {
            return null;
         }
         var _loc6_:PlayableSoundObject;
         if(!(_loc6_ = ArmySoundManager.getInstance().playSoundFromCollection(param1,param4,param5)) || !_loc6_.mChannel)
         {
            return null;
         }
         var _loc7_:SoundChannel = _loc6_.mChannel;
         if(param2 != null)
         {
            _loc7_.addEventListener(Event.SOUND_COMPLETE,param2);
         }
         _loc7_.addEventListener(Event.SOUND_COMPLETE,this.removeSoundChannelFromRenderable);
         this.mSoundChannels.push(_loc7_);
         if(mScene.mSoundMakers.indexOf(this) == -1)
         {
            mScene.mSoundMakers.push(this);
         }
         return _loc6_;
      }
      
      public function updateSoundtransform() : void
      {
         var _loc5_:SoundChannel = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(!GameState.mInstance.mScene)
         {
            return;
         }
         var _loc1_:Number = mX - GameState.mInstance.mScene.mCamera.getCameraX();
         var _loc2_:Number = GameState.mInstance.getStageWidth() >> 1;
         var _loc3_:Number = Math.max(Math.min(_loc1_ / _loc2_,1),-1);
         var _loc4_:Number = Math.min(1,Math.abs(_loc2_ / _loc1_));
         if(this.mSoundChannels != null)
         {
            _loc6_ = int(this.mSoundChannels.length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               (_loc5_ = this.mSoundChannels[_loc7_] as SoundChannel).soundTransform = this.mSoundTrasform;
               _loc7_++;
            }
         }
      }
      
      public function isPlayingSounds() : Boolean
      {
         return this.mSoundChannels.length > 0;
      }
      
      protected function removeSoundChannelFromRenderable(param1:Event) : void
      {
         param1.target.stop();
         var _loc2_:int = this.mSoundChannels.indexOf(param1.target);
         if(_loc2_ >= 0)
         {
            this.mSoundChannels.splice(_loc2_,1);
         }
         SoundChannel(param1.target).removeEventListener(Event.SOUND_COMPLETE,this.removeSoundChannelFromRenderable);
         if(this.mSoundChannels.length == 0)
         {
            GameState.mInstance.mScene.mSoundMakers.splice(this);
         }
      }
      
      private function removeAllSoundChannels() : void
      {
         var _loc1_:SoundChannel = null;
         for each(_loc1_ in this.mSoundChannels)
         {
            if(_loc1_)
            {
               _loc1_.stop();
               _loc1_.removeEventListener(Event.SOUND_COMPLETE,this.removeSoundChannelFromRenderable);
               _loc1_ = null;
            }
         }
         this.mSoundChannels = null;
         this.mSoundTrasform = null;
      }
      
      public function reportRollOver(param1:MouseEvent) : void
      {
         if(mEnabled)
         {
            if(this.mListenerObjectRollOver != null)
            {
               this.mListenerObjectRollOver(param1);
            }
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeListenerObjectPressed();
         this.removeListenerObjectClicked();
         this.removeListenerObjectMouseReleased();
         this.removeAllSoundChannels();
         while(this.mContainer.numChildren > 0)
         {
            this.mContainer.removeChildAt(0);
         }
         if(this.mLowHealthIcon)
         {
            if(this.mLowHealthIcon.parent)
            {
               this.mLowHealthIcon.parent.removeChild(this.mLowHealthIcon);
            }
            this.mLowHealthIcon = null;
         }
         this.mContainer.graphics.clear();
         if(this.mAnimationController)
         {
            this.mAnimationController.destroy();
            this.mAnimationController = null;
         }
         this.mListenerObjectClicked = null;
         this.mListenerObjectMouseOut = null;
         this.mListenerObjectMouseOver = null;
         this.mListenerObjectMousePressed = null;
         this.mListenerObjectMouseReleased = null;
         this.mListenerObjectRollOver = null;
         this.mListenerObjectRollOut = null;
      }
      
      override public function setPos(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         super.setPos(param1,param2,param3);
         if(this.mContainer != null)
         {
            ToScreen.transform(tmpPoint,param1,param2,param3);
            this.mContainer.x = tmpPoint.x;
            this.mContainer.y = tmpPoint.y;
            if(this.mLowHealthIcon)
            {
               _loc4_ = mScene.mGridDimX * this.getTileSize().x / 2;
               _loc5_ = mScene.mGridDimY * this.getTileSize().y - this.mLowHealthIcon.height / 2;
               this.mLowHealthIcon.x = mScene.getLeftUpperXOfCell(this.getCell()) + _loc4_;
               this.mLowHealthIcon.y = mScene.getLeftUpperYOfCell(this.getCell()) + _loc5_;
            }
         }
         this.updateSoundtransform();
      }
      
      public function drawOnGC(param1:Graphics, param2:int, param3:Boolean = false) : void
      {
         param1.clear();
         var _loc4_:Number = 20;
         var _loc5_:Number = 0.3;
         var _loc6_:Number = 0.3;
         var _loc7_:Number = this.mTileSize.x * mScene.mGridDimX;
         var _loc8_:Number = this.mTileSize.y * mScene.mGridDimY;
         ToScreen.transform(mPointTmp,mX - _loc4_,mY - _loc4_,0);
         var _loc9_:Number = mPointTmp.x;
         var _loc10_:Number = mPointTmp.y;
         ToScreen.transform(mPointTmp,mX + _loc7_ + _loc4_,mY - _loc4_,0);
         var _loc11_:Number = mPointTmp.x;
         var _loc12_:Number = mPointTmp.y;
         ToScreen.transform(mPointTmp,mX + _loc7_ + _loc4_,mY + _loc8_ + _loc4_,0);
         var _loc13_:Number = mPointTmp.x;
         var _loc14_:Number = mPointTmp.y;
         ToScreen.transform(mPointTmp,mX - _loc4_,mY + _loc8_ + _loc4_,0);
         var _loc15_:Number = mPointTmp.x;
         var _loc16_:Number = mPointTmp.y;
         param1.lineStyle(_loc5_,param2,_loc6_);
         param1.moveTo(_loc9_,_loc10_);
         if(param3)
         {
            param1.beginFill(param2);
         }
         param1.lineTo(_loc11_,_loc12_);
         param1.lineTo(_loc13_,_loc14_);
         param1.lineTo(_loc15_,_loc16_);
         param1.lineTo(_loc9_,_loc10_);
         if(param3)
         {
            param1.endFill();
         }
      }
      
      public function getCell() : GridCell
      {
         if(mScene)
         {
            return mScene.getCellAtLocation(mX,mY);
         }
         return null;
      }
      
      protected function initAnimations(param1:Array) : void
      {
         this.mAnimationController = new AnimationController(this);
         this.mAnimationController.loadAnimations(param1);
      }
      
      public function startAction() : void
      {
      }
      
      public function stopAction() : void
      {
      }
      
      public function setAnimationAction(param1:int, param2:Boolean = true, param3:Boolean = false) : Boolean
      {
         if(this.mAnimationController.setAnimation(param1))
         {
            this.updateAnimation(param2,param3);
            return true;
         }
         return false;
      }
      
      public function setAnimationDirection(param1:int) : void
      {
         this.mAnimationController.setDirection(param1);
      }
      
      public function getCurrentAnimationIndex() : int
      {
         return this.mAnimationController.getCurrentAnimationIndex();
      }
      
      protected function updateAnimation(param1:Boolean, param2:Boolean) : void
      {
         if(this.mContainer.numChildren > 0)
         {
            this.mContainer.removeChildAt(0);
         }
         this.mContainer.addChildAt(this.mAnimationController.getAnimation(),0);
         if(param1)
         {
            this.mAnimationController.stopCurrentAnimation();
         }
         else if(param2)
         {
            this.mAnimationController.playCurrentAnimation();
         }
      }
      
      public function stopAnimation() : void
      {
         this.mAnimationController.stopCurrentAnimation();
      }
      
      public function getCurrentAnimationFrameLabel() : String
      {
         return this.mAnimationController.getCurrentAnimationFrameLabel();
      }
      
      public function updateTooltip(param1:int, param2:TooltipHealth) : void
      {
      }
      
      public function showHealthWarning(param1:Boolean) : void
      {
         var _loc2_:Class = null;
         var _loc3_:Point = null;
         if(param1 && !(this is PermanentHFEObject) && !GameState.mInstance.visitingFriend())
         {
            if(!this.mLowHealthIcon)
            {
               _loc2_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"icon_status_low_health");
               this.mLowHealthIcon = new _loc2_();
               this.mLowHealthIcon.visible = false;
               this.mLowHealthIcon.mouseChildren = false;
               this.mLowHealthIcon.mouseEnabled = false;
            }
            if(!this.mLowHealthIcon.visible)
            {
               _loc3_ = this.getIconPosition();
               this.mLowHealthIcon.x = _loc3_.x;
               this.mLowHealthIcon.y = _loc3_.y;
               this.mLowHealthIcon.visible = true;
               mScene.mSceneHud.addChild(this.mLowHealthIcon);
            }
            this.reactToZoom(mScene.mContainer.scaleX);
         }
         else if(this.mLowHealthIcon)
         {
            if(this.mLowHealthIcon.visible)
            {
               this.mLowHealthIcon.visible = false;
               if(this.mLowHealthIcon.parent)
               {
                  this.mLowHealthIcon.parent.removeChild(this.mLowHealthIcon);
               }
               this.mLowHealthIcon = null;
            }
         }
      }
      
      public function setupFromServer(param1:Object) : void
      {
         var _loc2_:int = int(param1.coord_x);
         var _loc3_:int = int(param1.coord_y);
         var _loc4_:Number = mScene.getCenterPointXAtIJ(_loc2_,_loc3_);
         var _loc5_:Number = mScene.getCenterPointYAtIJ(_loc2_,_loc3_);
         this.setPos(_loc4_,_loc5_,0);
      }
      
      public function isLoadingBarVisible() : Boolean
      {
         return Boolean(this.mActionDelayIcon) && this.mActionDelayIcon.visible;
      }
      
      public function setLoadingBarPercent(param1:Number) : void
      {
         var _loc2_:MovieClip = null;
         if(this.mActionDelayIcon)
         {
            _loc2_ = this.mActionDelayIcon.getChildAt(1) as MovieClip;
            _loc2_.gotoAndStop(int(param1 * _loc2_.totalFrames));
         }
      }
      
      public function showLoadingBar(param1:int = 2500) : void
      {
         var _loc3_:Class = null;
         this.mActionDelayTimer = param1;
         if(!this.mActionDelayIcon)
         {
            _loc3_ = DCResourceManager.getInstance().getSWFClass(Config.SWF_INTERFACE_NAME,"icon_delay");
            this.mActionDelayIcon = new _loc3_();
            this.mActionDelayIcon.visible = false;
            this.mActionDelayIcon.mouseEnabled = false;
            this.mActionDelayIcon.gotoAndStop(1);
         }
         this.mActionDelayIcon.visible = true;
         var _loc2_:Point = this.getIconPosition();
         this.mActionDelayIcon.x = _loc2_.x;
         this.mActionDelayIcon.y = _loc2_.y;
         this.mActionDelayIcon.scaleX = 1 / mScene.mContainer.scaleX;
         this.mActionDelayIcon.scaleY = 1 / mScene.mContainer.scaleX;
         mScene.mSceneHud.addChild(this.mActionDelayIcon);
      }
      
      public function hideLoadingBar() : void
      {
         if(this.mActionDelayIcon)
         {
            if(this.mActionDelayIcon.parent)
            {
               this.mActionDelayIcon.parent.removeChild(this.mActionDelayIcon);
            }
            this.mActionDelayIcon = null;
         }
      }
      
      public function showActingHealthBar() : void
      {
      }
      
      public function hideActingHealthBar() : void
      {
      }
      
      public function isAlive() : Boolean
      {
         return true;
      }
      
      public function getMoveCostSupplies() : int
      {
         return 0;
      }
      
      public function getX() : int
      {
         return mX;
      }
      
      public function getY() : int
      {
         return mY;
      }
   }
}
