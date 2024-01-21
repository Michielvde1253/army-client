package game.battlefield
{
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   
   public class MapArea
   {
       
      
      private var mMapCells:Array;
      
      private var mStartX:int;
      
      private var mStartY:int;
      
      private var mWidth:int;
      
      private var mHeight:int;
      
      public function MapArea()
      {
         super();
      }
      
      public static function getArea(param1:IsometricScene, param2:int, param3:int, param4:int, param5:int) : MapArea
      {
         var _loc8_:int = 0;
         var _loc9_:GridCell = null;
         var _loc6_:MapArea;
         (_loc6_ = new MapArea()).mMapCells = new Array();
         _loc6_.mStartX = param2;
         _loc6_.mStartY = param3;
         _loc6_.mWidth = Math.min(param4,param1.mSizeX - param2);
         _loc6_.mHeight = Math.min(param5,param1.mSizeY - param3);
         var _loc7_:int = 0;
         while(_loc7_ < param5)
         {
            _loc8_ = 0;
            while(_loc8_ < param4)
            {
               if(_loc9_ = param1.getCellAt(param2 + _loc8_,param3 + _loc7_))
               {
                  _loc6_.mMapCells.push(_loc9_);
               }
               _loc8_++;
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      public static function getAreaAroundCell(param1:IsometricScene, param2:GridCell, param3:int) : MapArea
      {
         var _loc8_:int = 0;
         var _loc4_:MapArea;
         (_loc4_ = new MapArea()).mMapCells = new Array();
         _loc4_.mStartX = Math.max(param2.mPosI - param3,0);
         _loc4_.mStartY = Math.max(param2.mPosJ - param3,0);
         var _loc5_:int = Math.min(param1.mSizeX,_loc4_.mStartX + (2 * param3 + 1));
         var _loc6_:int = Math.min(param1.mSizeY,_loc4_.mStartY + (2 * param3 + 1));
         _loc4_.mWidth = _loc5_ - _loc4_.mStartX;
         _loc4_.mHeight = _loc6_ - _loc4_.mStartY;
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_.mWidth)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc4_.mHeight)
            {
               _loc4_.mMapCells.push(param1.getCellAt(_loc4_.mStartX + _loc7_,_loc4_.mStartY + _loc8_));
               _loc8_++;
            }
            _loc7_++;
         }
         return _loc4_;
      }
      
      public static function getAreaAroundObject(param1:IsometricScene, param2:GridCell, param3:int, param4:int) : MapArea
      {
         var _loc7_:int = 0;
         var _loc5_:MapArea;
         (_loc5_ = new MapArea()).mMapCells = new Array();
         _loc5_.mStartX = param2.mPosI - 1;
         _loc5_.mStartY = param2.mPosJ - 1;
         _loc5_.mWidth = param3 + 2;
         _loc5_.mHeight = param4 + 2;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.mHeight)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc5_.mWidth)
            {
               _loc5_.mMapCells.push(param1.getCellAt(_loc5_.mStartX + _loc7_,_loc5_.mStartY + _loc6_));
               _loc7_++;
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      public function getCells() : Array
      {
         return this.mMapCells;
      }
      
      public function getX() : int
      {
         return this.mStartX;
      }
      
      public function getY() : int
      {
         return this.mStartY;
      }
      
      public function getWidth() : int
      {
         return this.mWidth;
      }
      
      public function getHeight() : int
      {
         return this.mHeight;
      }
   }
}
