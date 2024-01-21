package game.isometric.camera
{
   import com.dchoc.utils.Cookie;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.isometric.SceneLoader;
   import game.states.GameState;
   
   public class IsoCamera
   {
      
      public static const DEFAULT_SPEED:Number = 0.8;
      
      public static const CENTER_ON_ITEM_SPEED:Number = 0.5;
       
      
      private var mTargetSet:Boolean;
      
      private var mPosSet:Boolean;
      
      private var mCameraX:Number;
      
      private var mCameraY:Number;
      
      private var mTargetX:Number;
      
      private var mTargetY:Number;
      
      private var mBounds:Rectangle;
      
      private var mSpeed:Number;
      
      public function IsoCamera()
      {
         super();
         this.mSpeed = DEFAULT_SPEED;
         this.mCameraX = this.mCameraY = this.mTargetX = this.mTargetY = 0;
         this.mBounds = new Rectangle(-10000,-10000,20000,20000);
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         param1 = Math.min(this.mBounds.right,Math.max(this.mBounds.left,param1));
         param2 = Math.min(this.mBounds.bottom,Math.max(this.mBounds.top,param2));
         this.mTargetX = this.mCameraX = param1;
         this.mTargetY = this.mCameraY = param2;
         this.mPosSet = true;
      }
      
      public function setTargetTo(param1:Number, param2:Number, param3:Number = 0.8) : void
      {
         this.setSpeed(param3);
         param1 = Math.min(this.mBounds.right,Math.max(this.mBounds.left,param1));
         param2 = Math.min(this.mBounds.bottom,Math.max(this.mBounds.top,param2));
         this.mTargetX = param1;
         this.mTargetY = param2;
         this.mTargetSet = true;
      }
      
      public function getCameraX() : Number
      {
         return Math.floor(this.mCameraX);
      }
      
      public function getCameraY() : Number
      {
         return Math.floor(this.mCameraY);
      }
      
      public function getTargetX() : Number
      {
         return this.mTargetX;
      }
      
      public function getTargetY() : Number
      {
         return this.mTargetY;
      }
      
      public function getSpeed() : Number
      {
         return this.mSpeed;
      }
      
      public function setSpeed(param1:Number) : void
      {
         this.mSpeed = param1;
      }
      
      public function update(param1:Number) : void
      {
         if(Math.abs(this.mCameraX - this.mTargetX) < 0.5)
         {
            this.mCameraX = this.mTargetX;
         }
         else
         {
            this.mCameraX = this.mSpeed * this.mCameraX + (1 - this.mSpeed) * this.mTargetX;
         }
         if(Math.abs(this.mCameraY - this.mTargetY) < 0.5)
         {
            this.mCameraY = this.mTargetY;
         }
         else
         {
            this.mCameraY = this.mSpeed * this.mCameraY + (1 - this.mSpeed) * this.mTargetY;
         }
         var _loc2_:GameState = GameState.mInstance;
         if(this.mPosSet && !_loc2_.mScene.mMouseScrolling && !_loc2_.mScene.mAnyScrollKeyPressed || this.mTargetSet && this.mCameraX == this.mTargetX && this.mCameraY == this.mTargetY)
         {
            if(!_loc2_.visitingFriend() && _loc2_.mState != GameState.STATE_INTRO)
            {
               Cookie.saveCookieVariable(Config.COOKIE_SESSION_NAME,Config.COOKIE_SESSION_NAME_CAM_POS + "_" + GameState.mInstance.mCurrentMapId,new Point(this.mCameraX,this.mCameraY));
            }
            this.mPosSet = false;
            this.mTargetSet = false;
         }
      }
      
      public function getBounds() : Rectangle
      {
         return this.mBounds;
      }
      
      public function setMargins(param1:int, param2:int, param3:int, param4:int, param5:Number) : void
      {
         var _loc10_:Object = null;
         if(GameState.mInstance.visitingTutor() || GameState.mInstance.mState == GameState.STATE_PVP)
         {
            _loc10_ = GameState.mInstance.mMapData.mMapSetupData;
            param1 = 0;
            param2 = 0;
            param3 = int(_loc10_.Width);
            param4 = int(_loc10_.Height);
         }
         var _loc6_:Number = GameState.mInstance.getStageWidth();
         var _loc7_:Number = GameState.mInstance.getStageHeight();
         var _loc8_:Number = (_loc6_ / 2 - GameState.mInstance.mMapData.mMapSetupData.MarginX) / param5;
         var _loc9_:Number = (_loc7_ / 2 - GameState.mInstance.mMapData.mMapSetupData.MarginY) / param5;
         param1 *= SceneLoader.GRID_CELL_SIZE;
         param2 *= SceneLoader.GRID_CELL_SIZE;
         param3 *= SceneLoader.GRID_CELL_SIZE;
         param4 *= SceneLoader.GRID_CELL_SIZE;
         this.mBounds.left = param1 + _loc8_;
         this.mBounds.right = param3 - _loc8_;
         this.mBounds.top = param2 + _loc9_;
         this.mBounds.bottom = param4 - _loc9_;
         if(this.mBounds.left > this.mBounds.right)
         {
            this.mBounds.left = this.mBounds.right = this.mBounds.right + (this.mBounds.left - this.mBounds.right) / 2;
         }
         if(this.mBounds.top > this.mBounds.bottom)
         {
            this.mBounds.top = this.mBounds.bottom = this.mBounds.bottom + (this.mBounds.top - this.mBounds.bottom) / 2;
         }
         this.mCameraX = Math.min(this.mBounds.right,Math.max(this.mBounds.left,this.mCameraX));
         this.mCameraY = Math.min(this.mBounds.bottom,Math.max(this.mBounds.top,this.mCameraY));
         this.moveTo(this.mCameraX,this.mCameraY);
      }
   }
}
