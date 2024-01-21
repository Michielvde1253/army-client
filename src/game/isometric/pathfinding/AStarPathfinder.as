package game.isometric.pathfinding
{
   import flash.geom.Point;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   
   public class AStarPathfinder
   {
      
      public static const MAXSEARCHDEPTH:Number = 1500;
      
      private static var open:Array = new Array();
      
      private static var closed:Array = new Array();
      
      private static var accessible:Array = new Array();
      
      private static var criteria:PathfindCriteria = new PathfindCriteria();
      
      public static var mGridCollisionInfo:GridCollisionInfo = new GridCollisionInfo();
      
      public static var mMoveDiagonally:Boolean = true;
      
      public static var mOptimizeStraightPaths:Boolean = true;
      
      public static var mConsiderCharacters:Boolean = true;
      
      public static var mRayHeight:Number = 0;
       
      
      public function AStarPathfinder()
      {
         super();
      }
      
      public static function setDefaultOptionValues() : void
      {
         mMoveDiagonally = true;
         mOptimizeStraightPaths = true;
         mConsiderCharacters = true;
         mRayHeight = 0;
      }
      
      private static function compareCellCosts(param1:GridCell, param2:GridCell) : Number
      {
         return param1.mG + param1.mHeuristic - param2.mG - param2.mHeuristic;
      }
      
      public static function findPathAStar(param1:Array, param2:IsometricScene, param3:Point, param4:Point, param5:int) : Boolean
      {
         var _loc11_:GridCell = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         criteria.setOptions(param2,param3,param4,mMoveDiagonally,mConsiderCharacters,param5);
         var _loc6_:GridCell = criteria.getOriginCell();
         param1.length = 0;
         var _loc7_:GridCell;
         if(!(_loc7_ = criteria.getDestinyCell()) || !_loc6_)
         {
            return false;
         }
         AStarPathfinder.mRayHeight = 0;
         if(_loc7_ == _loc6_ || mOptimizeStraightPaths && !checkRayCircleIntersection(param2,param3.x,param3.y,param4.x,param4.y,mGridCollisionInfo))
         {
            param1.push(criteria.getDestiny().x);
            param1.push(criteria.getDestiny().y);
            return true;
         }
         open.length = 0;
         closed.length = 0;
         var _loc8_:GridCell;
         (_loc8_ = _loc6_).mG = 0;
         _loc8_.mHeuristic = criteria.getHeuristic(_loc8_);
         open[open.length] = _loc8_;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         while(!_loc9_)
         {
            if(_loc10_++ > MAXSEARCHDEPTH)
            {
               Utils.LogError("FindPath reached its depth limit without a solution");
               return false;
            }
            open.sort(AStarPathfinder.compareCellCosts);
            if(open.length <= 0)
            {
               break;
            }
            _loc8_ = open.shift();
            closed[closed.length] = _loc8_;
            if(_loc8_ == _loc7_)
            {
               _loc9_ = true;
               break;
            }
            criteria.getAccessibleFrom(_loc8_,accessible);
            _loc12_ = int(accessible.length);
            _loc13_ = 0;
            while(_loc13_ < _loc12_)
            {
               _loc11_ = accessible[_loc13_] as GridCell;
               if(open.indexOf(_loc11_) < 0 && closed.indexOf(_loc11_) < 0)
               {
                  open[open.length] = _loc11_;
                  _loc11_.mParent = _loc8_;
                  _loc11_.mHeuristic = criteria.getHeuristic(_loc11_);
                  _loc11_.mG = _loc8_.mG + _loc11_.mPathCost;
               }
               else if((_loc14_ = _loc11_.mPathCost + _loc8_.mG + _loc11_.mHeuristic) < _loc11_.mG + _loc11_.mHeuristic)
               {
                  _loc11_.mParent = _loc8_;
                  _loc11_.mG = _loc11_.mPathCost + _loc8_.mG;
               }
               _loc13_++;
            }
         }
         if(_loc9_)
         {
            param1.push(criteria.getDestiny().x);
            param1.push(criteria.getDestiny().y);
            while(Boolean(_loc8_.mParent) && _loc8_.mParent != _loc6_)
            {
               _loc8_ = _loc8_.mParent;
               param1.push(criteria.getScene().getCenterPointXOfCell(_loc8_));
               param1.push(criteria.getScene().getCenterPointYOfCell(_loc8_));
            }
            return true;
         }
         return false;
      }
      
      public static function checkRayCircleIntersectionOld(param1:IsometricScene, param2:Number, param3:Number, param4:Number, param5:Number, param6:GridCollisionInfo, param7:Boolean = true) : Boolean
      {
         var _loc14_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:Number = NaN;
         var _loc24_:GridCell = null;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         param2 /= param1.mGridDimX;
         param4 /= param1.mGridDimX;
         param3 /= param1.mGridDimY;
         param5 /= param1.mGridDimY;
         var _loc8_:int = Math.floor(param2);
         var _loc9_:int = Math.floor(param3);
         var _loc10_:int = Math.floor(param4);
         var _loc11_:int = Math.floor(param5);
         var _loc12_:int = 1;
         var _loc13_:int = 1;
         if(_loc8_ > _loc10_)
         {
            _loc12_ = -1;
         }
         if(_loc9_ > _loc11_)
         {
            _loc13_ = -1;
         }
         var _loc15_:Point;
         var _loc16_:Number = (_loc15_ = new Point(param4 - param2,param5 - param3)).y;
         var _loc17_:Number = -_loc15_.x;
         var _loc18_:Number = -(param2 * _loc16_ + param3 * _loc17_);
         var _loc19_:Number = Math.sqrt(_loc16_ * _loc16_ + _loc17_ * _loc17_);
         var _loc20_:Number = _loc15_.length;
         _loc15_.x /= _loc20_;
         _loc15_.y /= _loc20_;
         var _loc21_:int = _loc8_;
         while(_loc21_ != _loc10_ + _loc12_)
         {
            _loc22_ = _loc9_;
            for(; _loc22_ != _loc11_ + _loc13_; _loc22_ += _loc13_)
            {
               if(_loc21_ == _loc8_)
               {
                  if(_loc22_ == _loc9_)
                  {
                     continue;
                  }
               }
               _loc23_ = 0.5;
               if(!(_loc24_ = param1.getCellAt(_loc21_,_loc22_)).mWalkable || _loc24_.mCharacter != null)
               {
                  _loc25_ = _loc24_.mPosI + 0.5;
                  _loc26_ = _loc24_.mPosJ + 0.5;
                  if((_loc27_ = Math.abs(_loc16_ * _loc25_ + _loc17_ * _loc26_ + _loc18_) / _loc19_) < _loc23_)
                  {
                     if(param6)
                     {
                        param6.mCollisionCell = _loc24_;
                        param6.mWallCollision = false;
                        _loc28_ = _loc15_.x * (_loc25_ - param2) + _loc15_.y * (_loc26_ - param3);
                        param6.mCollisionPoint.x = param2 + _loc15_.x * _loc28_;
                        param6.mCollisionPoint.y = param3 + _loc15_.y * _loc28_;
                        param6.mCollisionPoint.x *= param1.mGridDimX;
                        param6.mCollisionPoint.y *= param1.mGridDimY;
                        param6.mCollisionCharacter = _loc24_.mCharacter;
                     }
                     return true;
                  }
               }
            }
            _loc21_ += _loc12_;
         }
         return false;
      }
      
      public static function checkRayCircleIntersection(param1:IsometricScene, param2:Number, param3:Number, param4:Number, param5:Number, param6:GridCollisionInfo) : Boolean
      {
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc25_:GridCell = null;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         param2 /= param1.mGridDimX;
         param4 /= param1.mGridDimX;
         param3 /= param1.mGridDimY;
         param5 /= param1.mGridDimY;
         var _loc7_:Number = Math.abs(param4 - param2);
         var _loc8_:Number = Math.abs(param5 - param3);
         var _loc9_:int = int(Math.floor(param2));
         var _loc10_:int = int(Math.floor(param3));
         var _loc11_:Number = 1 / _loc7_;
         var _loc12_:Number = 1 / _loc8_;
         var _loc13_:Number = 0;
         var _loc14_:int = 0;
         if(_loc7_ == 0)
         {
            _loc15_ = 0;
            _loc18_ = _loc11_;
         }
         else if(param4 > param2)
         {
            _loc15_ = 1;
            _loc14_ += int(Math.floor(param4)) - _loc9_;
            _loc18_ = (Math.floor(param2) + 1 - param2) * _loc11_;
         }
         else
         {
            _loc15_ = -1;
            _loc14_ += _loc9_ - int(Math.floor(param4));
            _loc18_ = (param2 - Math.floor(param2)) * _loc11_;
         }
         if(_loc8_ == 0)
         {
            _loc16_ = 0;
            _loc17_ = _loc12_;
         }
         else if(param5 > param3)
         {
            _loc16_ = 1;
            _loc14_ += int(Math.floor(param5)) - _loc10_;
            _loc17_ = (Math.floor(param3) + 1 - param3) * _loc12_;
         }
         else
         {
            _loc16_ = -1;
            _loc14_ += _loc10_ - int(Math.floor(param5));
            _loc17_ = (param3 - Math.floor(param3)) * _loc12_;
         }
         var _loc19_:Point;
         var _loc20_:Number = (_loc19_ = new Point(param4 - param2,param5 - param3)).y;
         var _loc21_:Number = -_loc19_.x;
         var _loc22_:Number = -(param2 * _loc20_ + param3 * _loc21_);
         var _loc23_:Number = Math.sqrt(_loc20_ * _loc20_ + _loc21_ * _loc21_);
         var _loc24_:Number = _loc19_.length;
         _loc19_.x /= _loc24_;
         _loc19_.y /= _loc24_;
         while(_loc14_ > 0)
         {
            if(_loc17_ < _loc18_)
            {
               _loc10_ += _loc16_;
               _loc13_ = _loc17_;
               _loc17_ += _loc12_;
            }
            else
            {
               _loc9_ += _loc15_;
               _loc13_ = _loc18_;
               _loc18_ += _loc11_;
            }
            _loc25_ = param1.getCellAt(_loc9_,_loc10_);
            if(mConsiderCharacters && _loc25_.mCharacter != null || !_loc25_.mWalkable)
            {
               _loc26_ = 0.5;
               _loc27_ = _loc25_.mPosI + 0.5;
               _loc28_ = _loc25_.mPosJ + 0.5;
               if((_loc29_ = Math.abs(_loc20_ * _loc27_ + _loc21_ * _loc28_ + _loc22_) / _loc23_) < _loc26_)
               {
                  param6.mCollisionCharacter = _loc25_.mCharacter;
                  param6.mWallCollision = _loc25_.mCharacter == null;
                  param6.mCollisionCell = _loc25_;
                  _loc30_ = (_loc30_ = _loc19_.x * (_loc27_ - param2) + _loc19_.y * (_loc28_ - param3)) - Math.sqrt(_loc26_ * _loc26_ - _loc29_ * _loc29_);
                  param6.mCollisionPoint.x = param2 + _loc19_.x * _loc30_;
                  param6.mCollisionPoint.y = param3 + _loc19_.y * _loc30_;
                  param6.mCollisionNormal.x = param6.mCollisionPoint.x - _loc27_;
                  param6.mCollisionNormal.y = param6.mCollisionPoint.y - _loc28_;
                  param6.mCollisionPoint.x *= param1.mGridDimX;
                  param6.mCollisionPoint.y *= param1.mGridDimY;
                  param6.mCollisionPoint.z = 0;
                  param6.mCollisionNormal.z = 0;
                  return true;
               }
            }
            _loc14_--;
         }
         return false;
      }
      
      public static function getAccesibleSurroundingCells(param1:IsometricScene, param2:GridCell, param3:Array, param4:int) : void
      {
         criteria.setOptions(param1,null,null,true,mConsiderCharacters,param4);
         criteria.getAccessibleFrom(param2,param3);
      }
      
      public static function getAllSurroundingCells(param1:IsometricScene, param2:GridCell, param3:Number, param4:Array) : void
      {
         var _loc8_:int = 0;
         var _loc9_:GridCell = null;
         param4.length = 0;
         var _loc5_:Number = param2.mPosI;
         var _loc6_:Number = param2.mPosJ;
         var _loc7_:int = _loc5_ - param3;
         while(_loc7_ <= _loc5_ + param3)
         {
            _loc8_ = _loc6_ - param3;
            while(_loc8_ <= _loc6_ + param3)
            {
               _loc9_ = param1.getCellAt(_loc7_,_loc8_);
               param4.push(_loc9_);
               _loc8_++;
            }
            _loc7_++;
         }
      }
   }
}
