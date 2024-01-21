package game.items
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import game.gui.IconAdapter;
   import game.gui.IconLoader;
   import game.isometric.IsometricScene;
   import game.states.GameState;
   
   public class AreaItem extends ShopItem
   {
       
      
      public var mX:int;
      
      public var mY:int;
      
      public var mWidth:int;
      
      public var mHeight:int;
      
      public var mRightX:int;
      
      public var mBottomY:int;
      
      public var mAreaLockedIcon:Sprite;
      
      public var mMapId:String;
      
      private var mLockedIconX:int;
      
      private var mLockedIconY:int;
      
      public function AreaItem(param1:Object)
      {
         super(param1);
         this.mX = param1.AreaX;
         this.mY = param1.AreaY;
         this.mWidth = param1.AreaWidth;
         this.mHeight = param1.AreaHeight;
         this.mMapId = param1.MapID;
         this.mRightX = this.mX + this.mWidth;
         this.mBottomY = this.mY + this.mHeight;
      }
      
      public function addAreaLockedIcon(param1:DisplayObjectContainer, param2:int, param3:int) : void
      {
         if(GameState.mInstance.mCurrentMapId == this.mMapId)
         {
            this.mLockedIconX = param2;
            this.mLockedIconY = param3;
            if(!this.mAreaLockedIcon || !this.mAreaLockedIcon.parent)
            {
               IconLoader.addIcon(param1,new IconAdapter("area_locked","swf/objects_01"),this.lockedIconLoaded,false);
            }
            else
            {
               this.lockedIconLoaded(this.mAreaLockedIcon);
            }
         }
      }
      
      public function lockedIconLoaded(param1:Sprite) : void
      {
         this.mAreaLockedIcon = param1;
         if(this.mAreaLockedIcon.getChildByName("Text_Title") as TextField != null)
         {
            this.mAreaLockedIcon.x = this.mLockedIconX;
            this.mAreaLockedIcon.y = this.mLockedIconY;
            (this.mAreaLockedIcon.getChildByName("Text_Title") as TextField).text = mName;
            (this.mAreaLockedIcon.getChildByName("Text_Description") as TextField).text = GameState.getText("EXPAND_AREA_ICON_DESCRIPTION");
            this.mAreaLockedIcon.addEventListener(MouseEvent.CLICK,this.iconClicked);
            LocalizationUtils.replaceFonts(this.mAreaLockedIcon);
         }
      }
      
      public function checkLimits() : void
      {
         if(this.mMapId == GameState.mInstance.mCurrentMapId)
         {
            IsometricScene.mMinAreaX = Math.min(this.mX,IsometricScene.mMinAreaX);
            IsometricScene.mMinAreaY = Math.min(this.mY,IsometricScene.mMinAreaY);
            IsometricScene.mMaxAreaX = Math.max(this.mRightX,IsometricScene.mMaxAreaX);
            IsometricScene.mMaxAreaY = Math.max(this.mBottomY,IsometricScene.mMaxAreaY);
         }
      }
      
      private function iconClicked(param1:MouseEvent) : void
      {
         GameState.mInstance.mHUD.openAreaLockedWindow(this);
      }
      
      override public function isUnlocked() : Boolean
      {
         return super.isUnlocked() && mId != "AreaNorthW" && mId != "AreaNorthC" && mId != "AreaNorthE";
      }
   }
}
