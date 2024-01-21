package game.isometric
{
   import flash.geom.Vector3D;
   import game.battlefield.MapData;
   import game.isometric.elements.Floor;
   import game.states.GameState;
   
   public class SceneLoader
   {
      
      public static const GRID_CELL_SIZE:int = 96;
       
      
      public function SceneLoader()
      {
         super();
      }
      
      public static function loadFromLevelFactor(param1:GameState, param2:MapData) : IsometricScene
      {
         var _loc3_:IsometricScene = null;
         var _loc11_:Vector3D = null;
         var _loc15_:Vector3D = null;
         _loc3_ = new IsometricScene(param1,GRID_CELL_SIZE,GRID_CELL_SIZE,GRID_CELL_SIZE);
         var _loc4_:IsoPlane;
         (_loc4_ = new IsoPlane(null,null,0,0)).x = 0;
         _loc4_.y = 0;
         _loc3_.mSizeX = param2.mGridWidth;
         _loc3_.mSizeY = param2.mGridHeight;
         var _loc5_:int = _loc3_.mGridDimX * _loc3_.mSizeX;
         var _loc6_:int = _loc3_.mGridDimY * _loc3_.mSizeY;
         ToScreen.init(_loc3_);
         _loc3_.initCamera();
         var _loc7_:Vector3D = new Vector3D(0,0,0);
         var _loc8_:Vector3D = new Vector3D(0,_loc6_,0);
         var _loc9_:Vector3D = new Vector3D(_loc5_,0,0);
         var _loc10_:Array;
         (_loc10_ = new Array()).push(_loc7_);
         _loc10_.push(_loc7_.add(_loc9_));
         _loc10_.push(_loc7_.add(_loc8_).add(_loc9_));
         _loc10_.push(_loc7_.add(_loc8_));
         var _loc12_:int = int(_loc10_.length);
         var _loc13_:int = 0;
         while(_loc13_ < _loc12_)
         {
            _loc15_ = (_loc11_ = _loc10_[_loc13_] as Vector3D).clone();
            ToScreen.transformVec(_loc11_,_loc15_);
            _loc13_++;
         }
         var _loc14_:Floor;
         (_loc14_ = new Floor(_loc3_,"ground")).setPos(0,0,0);
         _loc14_.setSize(_loc5_,_loc6_);
         _loc14_.addSprite(_loc4_);
         _loc3_.addFloor(_loc14_);
         return _loc3_;
      }
   }
}
