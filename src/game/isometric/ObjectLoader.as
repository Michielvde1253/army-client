package game.isometric
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   
   public class ObjectLoader
   {
       
      
      private var mHitAreaChanged:Boolean;
      
      public function ObjectLoader()
      {
         super();
      }
      
      public function SimpleObject(param1:String) : MovieClip
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:String = String(_loc2_[_loc2_.length * Math.random() as int]);
         var _loc4_:Class;
         var _loc5_:MovieClip = new (_loc4_ = DCResourceManager.getInstance().getSWFClass("swf/objects_01",_loc3_))();
         this.mHitAreaChanged = false;
         return _loc5_;
      }
      
      public function TileObject(param1:String) : MovieClip
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:String = String(_loc2_[_loc2_.length * Math.random() as int]);
         var _loc4_:Class;
         var _loc5_:MovieClip = new (_loc4_ = DCResourceManager.getInstance().getSWFClass("swf/new_backgroud_01",_loc3_))();
         this.mHitAreaChanged = false;
         return _loc5_;
      }
      
      public function MultiplePartObject(param1:String) : MovieClip
      {
         var _loc2_:Array = null;
         var _loc3_:MovieClip = null;
         var _loc4_:String = null;
         var _loc7_:Class = null;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         _loc2_ = param1.split(",");
         _loc3_ = new MovieClip();
         _loc3_.mouseEnabled = false;
         _loc3_.mouseChildren = true;
         var _loc5_:int = int(_loc2_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = _loc2_[_loc6_] as String;
            (_loc8_ = new (_loc7_ = DCResourceManager.getInstance().getSWFClass("swf/objects_01",_loc4_))()).gotoAndStop(int(_loc8_.totalFrames * Math.random()));
            (_loc9_ = MovieClip(_loc8_.getChildAt(0)).getChildByName("Hit_Area") as MovieClip).mouseEnabled = false;
            _loc8_.hitArea = _loc9_;
            _loc8_.mouseChildren = false;
            _loc3_.addChild(_loc8_);
            _loc6_++;
         }
         this.mHitAreaChanged = true;
         return _loc3_;
      }
      
      public function InnerMovieClip(param1:String, param2:String) : MovieClip
      {
         var _loc3_:Class = DCResourceManager.getInstance().getSWFClass(param1,param2);
         var _loc4_:MovieClip;
         (_loc4_ = new _loc3_()).mouseChildren = false;
         this.mHitAreaChanged = false;
         return _loc4_;
      }
      
      public function isHitAreaChanged() : Boolean
      {
         return this.mHitAreaChanged;
      }
   }
}
