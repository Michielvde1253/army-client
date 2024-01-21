package game.items
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import game.gui.IconInterface;
   import game.states.GameState;
   
   public class Item implements IconInterface
   {
       
      
      public var mId:String;
      
      public var mType:String;
      
      public var mName:String;
      
      protected var mDescription:String;
      
      protected var mIconGraphicsFile:Array;
      
      protected var mIconGraphics:Array;
      
      public function Item(param1:Object)
      {
         super();
         this.mId = param1.ID;
         this.mType = param1.Type;
         this.mName = param1.Name;
         this.mDescription = param1.Description;
      }
      
      public function initGraphics(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1)
         {
            if(param1.IconGraphics)
            {
               this.mIconGraphics = new Array();
               this.mIconGraphicsFile = new Array();
               if(param1.IconGraphics is Array)
               {
                  _loc3_ = 0;
                  while(_loc3_ < param1.IconGraphics.length)
                  {
                     _loc2_ = (param1.IconGraphics[_loc3_] as String).lastIndexOf("/");
                     this.mIconGraphics[_loc3_] = (param1.IconGraphics[_loc3_] as String).substring(_loc2_ + 1);
                     this.mIconGraphicsFile[_loc3_] = (param1.IconGraphics[_loc3_] as String).substring(0,_loc2_);
                     _loc3_++;
                  }
               }
               else
               {
                  _loc2_ = (param1.IconGraphics as String).lastIndexOf("/");
                  this.mIconGraphics[0] = (param1.IconGraphics as String).substring(_loc2_ + 1);
                  this.mIconGraphicsFile[0] = (param1.IconGraphics as String).substring(0,_loc2_);
               }
            }
         }
      }
      
      public function getDescription() : String
      {
         return this.mDescription;
      }
      
      public function getIconGraphics() : String
      {
         if(GameState.mInstance.mCurrentMapGraphicsId >= this.mIconGraphics.length)
         {
            return this.mIconGraphics[0];
         }
         return this.mIconGraphics[GameState.mInstance.mCurrentMapGraphicsId];
      }
      
      public function getIconGraphicsFile() : String
      {
         if(GameState.mInstance.mCurrentMapGraphicsId >= this.mIconGraphicsFile.length)
         {
            return this.mIconGraphicsFile[0];
         }
         return this.mIconGraphicsFile[GameState.mInstance.mCurrentMapGraphicsId];
      }
      
      public function getIconMovieClip() : MovieClip
      {
         var _loc1_:Class = null;
         var _loc2_:DCResourceManager = DCResourceManager.getInstance();
         _loc1_ = _loc2_.getSWFClass(this.getIconGraphicsFile(),this.getIconGraphics());
         if(_loc1_)
         {
            return new _loc1_();
         }
         return null;
      }
   }
}
