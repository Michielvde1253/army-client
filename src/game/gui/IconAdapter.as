package game.gui
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   
   public class IconAdapter implements IconInterface
   {
       
      
      protected var mIconGraphicsFile:String;
      
      protected var mIconGraphics:String;
      
      public function IconAdapter(param1:String, param2:String)
      {
         super();
         this.mIconGraphics = param1;
         this.mIconGraphicsFile = param2;
      }
      
      public function getIconGraphics() : String
      {
         return this.mIconGraphics;
      }
      
      public function getIconGraphicsFile() : String
      {
         return this.mIconGraphicsFile;
      }
      
      public function getIconMovieClip() : MovieClip
      {
         var _loc1_:Class = null;
         var _loc2_:DCResourceManager = DCResourceManager.getInstance();
         _loc1_ = _loc2_.getSWFClass(this.mIconGraphicsFile,this.mIconGraphics);
         if(_loc1_)
         {
            return new _loc1_();
         }
         return null;
      }
   }
}
