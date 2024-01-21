package game.isometric
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import game.isometric.elements.StaticObject;
   import game.items.MapItem;
   
   public class ImportedObject extends StaticObject
   {
       
      
      private var mLoadingCallbackEvent:Object;
      
      private var mLoadingCallbackEventType:String;
      
      private var tempX:int;
      
      private var tempY:int;
      
      private var mTempcontainer:Sprite = null;
      
      public function ImportedObject(param1:int, param2:IsometricScene, param3:MapItem, param4:Point, param5:DisplayObject = null, param6:String = null)
      {
         var _loc9_:ObjectLoader = null;
         super(param1,param2,param3,param6);
         this.tempX = 2 * param4.x * param2.mGridDimX >> 1;
         this.tempY = 2 * param4.y * param2.mGridDimY >> 1;
         var _loc7_:DCResourceManager = DCResourceManager.getInstance();
         var _loc8_:String = param3.getIconGraphicsFile();
         if(_loc7_.isLoaded(_loc8_))
         {
            mGraphicsLoaded = true;
            _loc9_ = mScene.getObjectLoader();
            this.mTempcontainer = _loc9_[param3.mLoader](param3.getIconGraphicsFile(),param3.getIconGraphics());
         }
         else
         {
            mGraphicsLoaded = false;
            this.mLoadingCallbackEvent = new Object();
            this.mLoadingCallbackEvent.type = _loc8_ + DCResourceManager.EVENT_COMPLETE_SINGLE_FILE;
            this.mLoadingCallbackEvent.resName = _loc8_;
            _loc7_.addEventListener(this.mLoadingCallbackEvent.type,this.LoadingFinished,false,0,true);
            if(!_loc7_.isAddedToLoadingList(_loc8_))
            {
               _loc7_.load(Config.DIR_DATA + _loc8_ + ".swf",_loc8_,null,false);
            }
         }
      }
      
      public function active() : Boolean
      {
         return false;
      }
      
      public function getInternalGraphicsLoaded() : void
      {
         if(this.mTempcontainer != null)
         {
            this.graphicsLoaded(this.mTempcontainer);
         }
      }
      
      public function setPositionInternally() : void
      {
         setPos(this.tempX,this.tempY,0);
      }
      
      public function LoadingFinished(param1:Event) : void
      {
         DCResourceManager.getInstance().removeEventListener(param1.type,this.LoadingFinished);
         this.mLoadingCallbackEventType = null;
         mGraphicsLoaded = true;
         var _loc2_:ObjectLoader = mScene.getObjectLoader();
         var _loc3_:Sprite = _loc2_[mItem.mLoader](mItem.getIconGraphicsFile(),mItem.getIconGraphics());
         this.graphicsLoaded(_loc3_);
      }
      
      override public function graphicsLoaded(param1:Sprite) : void
      {
         super.graphicsLoaded(param1);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this.mLoadingCallbackEvent)
         {
            DCResourceManager.getInstance().removeEventListener(this.mLoadingCallbackEvent.type,this.LoadingFinished);
         }
      }
   }
}
