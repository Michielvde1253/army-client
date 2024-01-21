package game.gui
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class DisplayObjectTransition
   {
      
      public static const SAFETY_MARGIN:int = 70;
      
      public static const TYPE_NORMAL:int = 0;
      
      public static const TYPE_APPEAR:int = 1;
      
      public static const TYPE_DISAPPEAR:int = 2;
      
      public static const ATTENTION:String = "attention";
      
      public static const ATTENTION_UP:String = "attention_up";
      
      public static const FADE_APPEAR:String = "fade_appear";
      
      public static const FADE_DISAPPEAR:String = "fade_disappear";
      
      public static const APPEAR:String = "appear";
      
      public static const DISAPPEAR:String = "disappear";
      
      public static const DISAPPEAR_UP:String = "disappear_down";
      
      public static const APPEAR_UP:String = "appear_up";
       
      
      private var mTimelineClip:MovieClip;
      
      private var mTransitingClip:MovieClip;
      
      private var mComponent:DisplayObject;
      
      private var mAfterTransitionCallback:Function;
      
      private var mBufferBitmap:Bitmap;
      
      private var mChildIndex:int;
      
      private var mType:int;
      
      public function DisplayObjectTransition(param1:String, param2:DisplayObject, param3:int, param4:Function = null)
      {
         var _loc5_:Rectangle = null;
         super();
         if(!param2.parent)
         {
            Utils.LogError("ERROR - component must be added as a child before it can be trasitioned");
            return;
         }
         this.mType = param3;
         this.mComponent = param2;
         this.mChildIndex = param2.parent.getChildIndex(param2);
         this.mBufferBitmap = new Bitmap(new BitmapData(this.mComponent.width + SAFETY_MARGIN,this.mComponent.height + SAFETY_MARGIN,true,16711680));
         _loc5_ = param2.getBounds(param2);
         this.mBufferBitmap.bitmapData.draw(param2,new Matrix(1,0,0,1,-_loc5_.left + SAFETY_MARGIN / 2,-_loc5_.top + SAFETY_MARGIN / 2));
         var _loc6_:Class = DCResourceManager.getInstance().getSWFClass("swf/transitions",param1);
         this.mTimelineClip = new _loc6_();
         this.mTimelineClip.mouseEnabled = false;
         this.mTimelineClip.mouseChildren = false;
         this.mTransitingClip = this.mTimelineClip.getChildByName("Object") as MovieClip;
         this.mTransitingClip.mouseChildren = false;
         this.mTransitingClip.removeChildAt(0);
         this.mTimelineClip.mouseEnabled = false;
         param2.parent.addChildAt(this.mTimelineClip,this.mChildIndex);
         this.mTimelineClip.x = param2.x - SAFETY_MARGIN / 2;
         this.mTimelineClip.y = param2.y - SAFETY_MARGIN / 2;
         param2.visible = false;
         this.mBufferBitmap.x = _loc5_.left;
         this.mBufferBitmap.y = _loc5_.top;
         this.mTransitingClip.addChild(this.mBufferBitmap);
         if(param4 is Function)
         {
            this.mAfterTransitionCallback = param4;
         }
         param4 = null;
         this.mTimelineClip.addEventListener(Event.ENTER_FRAME,this.checkFrame);
      }
      
      private function checkFrame(param1:Event) : void
      {
         var exampleName:String = null;
         var exampleType:Class = null;
         var e:Event = param1;
         if(this.mTimelineClip.currentFrame == this.mTimelineClip.totalFrames)
         {
            this.mComponent.visible = this.mType != TYPE_DISAPPEAR;
            this.mTimelineClip.removeEventListener(Event.ENTER_FRAME,this.checkFrame);
            this.mTimelineClip.stop();
            this.mChildIndex = this.mTimelineClip.parent.getChildIndex(this.mTimelineClip);
            if(this.mComponent.parent)
            {
               this.mComponent.parent.setChildIndex(this.mComponent,this.mChildIndex);
            }
            this.mTimelineClip.parent.removeChild(this.mTimelineClip);
            if(this.mAfterTransitionCallback is Function)
            {
               exampleName = null;
               exampleType = null;
               try
               {
                  exampleName = getQualifiedClassName(this.mComponent);
                  exampleType = getDefinitionByName(exampleName) as Class;
               }
               catch(e:Error)
               {
                  Utils.LogError("Transition callBack error");
               }
               this.mAfterTransitionCallback();
            }
            this.mTimelineClip = null;
            this.mTransitingClip = null;
            this.mComponent = null;
            this.mAfterTransitionCallback = null;
            this.mBufferBitmap.bitmapData.dispose();
            this.mBufferBitmap = null;
         }
      }
   }
}
