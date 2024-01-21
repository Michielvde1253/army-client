package game.actions
{
   import flash.geom.Point;
   import game.battlefield.MapData;
   import game.characters.AnimationController;
   import game.characters.EnemyUnit;
   import game.characters.PlayerUnit;
   import game.gameElements.ConstructionObject;
   import game.gameElements.DebrisObject;
   import game.gameElements.PlayerInstallationObject;
   import game.isometric.GridCell;
   import game.isometric.characters.IsometricCharacter;
   import game.isometric.elements.Element;
   import game.isometric.elements.Renderable;
   import game.isometric.elements.WorldObject;
   import game.isometric.pathfinding.AStarPathfinder;
   import game.net.ServiceIDs;
   import game.states.GameState;
   
   public class EnemyMovingAction extends Action
   {
       
      
      protected var mTargetX:int;
      
      protected var mTargetY:int;
      
      protected var mOriginCell:GridCell;
      
      protected var mDestinationCell:GridCell;
      
      public function EnemyMovingAction(param1:IsometricCharacter, param2:GridCell = null, param3:String = "EnemyMove")
      {
         super(param3);
         mActor = param1;
         this.mDestinationCell = param2;
      }
      
      private function findClosestPlayerCell() : GridCell
      {
         var _loc9_:int = 0;
         var _loc10_:GridCell = null;
         var _loc11_:Array = null;
         var _loc12_:GridCell = null;
         var _loc13_:int = 0;
         var _loc14_:GridCell = null;
         var _loc15_:int = 0;
         var _loc16_:Renderable = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:GridCell = null;
         var _loc21_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:int = 1;
         var _loc3_:GridCell = mActor.getCell();
         var _loc4_:int = _loc3_.mPosI;
         var _loc5_:int = _loc3_.mPosJ;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:int = _loc4_ - _loc2_;
         while(_loc8_ <= _loc4_ + _loc2_)
         {
            _loc9_ = _loc5_ - _loc2_;
            while(_loc9_ <= _loc5_ + _loc2_)
            {
               _loc10_ = (mActor as Element).mScene.getCellAt(_loc8_,_loc9_);
               _loc7_ = true;
               if(_loc10_)
               {
                  if(_loc10_ != _loc3_)
                  {
                     if(_loc10_.mWalkable)
                     {
                        if((mActor as Element).mScene.isInsideVisibleArea(_loc10_))
                        {
                           if(_loc10_ == (mActor as IsometricCharacter).mPreviousTile)
                           {
                              _loc7_ = false;
                           }
                           else if(_loc10_.mCharacter)
                           {
                              _loc7_ = false;
                              if(_loc10_.mCharacter is PlayerUnit)
                              {
                                 if(_loc10_.mCharacter.isAlive())
                                 {
                                    _loc1_.length = 0;
                                    _loc6_ = true;
                                    break;
                                 }
                              }
                           }
                           else if(_loc10_.mCharacterComingToThisTile)
                           {
                              _loc7_ = false;
                           }
                           else if(_loc10_.mObject)
                           {
                              _loc7_ = false;
                              if(_loc10_.mObject is DebrisObject)
                              {
                                 _loc7_ = true;
                              }
                              else if(_loc10_.mObject is PlayerInstallationObject && (_loc10_.mObject as PlayerInstallationObject).isAlive() || _loc10_.mObject is ConstructionObject && (_loc10_.mObject as ConstructionObject).isAlive() && (_loc10_.mObject as ConstructionObject).mHasBeenCompleted)
                              {
                                 _loc1_.length = 0;
                                 _loc6_ = true;
                                 break;
                              }
                           }
                           if(_loc10_.mOwner == MapData.TILE_OWNER_FRIENDLY)
                           {
                              if(_loc10_.mPosI != _loc4_)
                              {
                                 if(_loc10_.mPosJ != _loc5_)
                                 {
                                    _loc7_ = false;
                                 }
                              }
                           }
                           if(_loc7_)
                           {
                              _loc1_.push(_loc10_);
                           }
                        }
                     }
                  }
               }
               _loc9_++;
            }
            if(_loc6_)
            {
               break;
            }
            _loc8_++;
         }
         if(_loc1_.length > 0)
         {
            _loc11_ = (mActor as Element).mScene.getPlayerUnitsAndObjects();
            _loc13_ = int.MAX_VALUE;
            _loc15_ = int(_loc1_.length);
            _loc17_ = int(_loc11_.length);
            _loc18_ = 0;
            while(_loc18_ < _loc15_)
            {
               _loc14_ = _loc1_[_loc18_] as GridCell;
               _loc19_ = 0;
               while(_loc19_ < _loc17_)
               {
                  _loc20_ = (_loc16_ = _loc11_[_loc19_] as Renderable).getCell();
                  if((_loc21_ = (_loc14_.mPosI - _loc20_.mPosI) * (_loc14_.mPosI - _loc20_.mPosI) + (_loc14_.mPosJ - _loc20_.mPosJ) * (_loc14_.mPosJ - _loc20_.mPosJ)) < _loc13_)
                  {
                     _loc13_ = _loc21_;
                     _loc12_ = _loc14_;
                     if(_loc13_ == 1)
                     {
                        return _loc12_;
                     }
                  }
                  _loc19_++;
               }
               _loc18_++;
            }
            return _loc12_;
         }
         return null;
      }
      
      private function headToThePlayerArea() : GridCell
      {
         var _loc11_:int = 0;
         var _loc12_:GridCell = null;
         var _loc13_:GridCell = null;
         var _loc14_:int = 0;
         var _loc15_:GridCell = null;
         var _loc16_:int = 0;
         var _loc17_:Renderable = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:GridCell = null;
         var _loc22_:int = 0;
         var _loc23_:Array = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = (mActor as EnemyUnit).mMovementRange;
         var _loc3_:GridCell = mActor.getCell();
         var _loc4_:int = _loc3_.mPosI;
         var _loc5_:int = _loc3_.mPosJ;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:int = _loc4_ - _loc2_;
         while(_loc9_ <= _loc4_ + _loc2_)
         {
            _loc11_ = _loc5_ - _loc2_;
            while(_loc11_ <= _loc5_ + _loc2_)
            {
               _loc8_ = Math.abs(_loc4_ - _loc9_) <= 1 && Math.abs(_loc5_ - _loc11_) <= 1;
               _loc12_ = (mActor as Element).mScene.getCellAt(_loc9_,_loc11_);
               _loc7_ = true;
               if(_loc12_)
               {
                  if(_loc12_ != _loc3_)
                  {
                     if(_loc12_.mWalkable)
                     {
                        if((mActor as Element).mScene.isInsideVisibleArea(_loc12_))
                        {
                           if(_loc8_)
                           {
                              _loc7_ = false;
                           }
                           else
                           {
                              if(Boolean(_loc12_.mCharacter) || Boolean(_loc12_.mCharacterComingToThisTile))
                              {
                                 _loc7_ = false;
                              }
                              else if(_loc12_.mObject)
                              {
                                 _loc7_ = false;
                                 if(_loc12_.mObject is DebrisObject)
                                 {
                                    _loc7_ = true;
                                 }
                              }
                              if(_loc7_)
                              {
                                 _loc1_.push(_loc12_);
                              }
                           }
                        }
                     }
                  }
               }
               _loc11_++;
            }
            if(_loc6_)
            {
               break;
            }
            _loc9_++;
         }
         var _loc10_:Array = (mActor as Element).mScene.getPlayerBuildingTargets();
         if(_loc1_.length > 0)
         {
            _loc14_ = int.MAX_VALUE;
            _loc16_ = int(_loc1_.length);
            _loc18_ = int(_loc10_.length);
            _loc19_ = 0;
            while(_loc19_ < _loc16_)
            {
               _loc15_ = _loc1_[_loc19_] as GridCell;
               _loc20_ = 0;
               while(_loc20_ < _loc18_)
               {
                  _loc21_ = (_loc17_ = _loc10_[_loc20_] as Renderable).getCell();
                  if((_loc22_ = (_loc15_.mPosI - _loc21_.mPosI) * (_loc15_.mPosI - _loc21_.mPosI) + (_loc15_.mPosJ - _loc21_.mPosJ) * (_loc15_.mPosJ - _loc21_.mPosJ)) < _loc14_)
                  {
                     _loc23_ = new Array();
                     if(AStarPathfinder.findPathAStar(_loc23_,GameState.mInstance.mScene,new Point(_loc4_,_loc5_),new Point(_loc15_.mPosI,_loc15_.mPosJ),(mActor as EnemyUnit).mMovementFlags))
                     {
                        if(_loc15_.mG <= (mActor as EnemyUnit).mMovementRange)
                        {
                           _loc14_ = _loc22_;
                           _loc13_ = _loc15_;
                           if(_loc14_ == 1)
                           {
                              return _loc13_;
                           }
                        }
                     }
                  }
                  _loc20_++;
               }
               _loc19_++;
            }
            return _loc13_;
         }
         return null;
      }
      
      override public function isOver() : Boolean
      {
         if(mSkipped)
         {
            (mActor as EnemyUnit).changeReactionState(EnemyUnit.REACT_STATE_ACTION_COMPLETED);
            return true;
         }
         if((mActor as IsometricCharacter).isStill())
         {
            if((mActor as IsometricCharacter).mDestinationCell)
            {
               if(this.mOriginCell)
               {
                  this.execute();
               }
            }
            (mActor as EnemyUnit).changeReactionState(EnemyUnit.REACT_STATE_ACTION_COMPLETED);
            return true;
         }
         return false;
      }
      
      override public function start() : void
      {
         if(mSkipped)
         {
            return;
         }
         if(mActor == null || !mActor.isAlive())
         {
            skip();
            return;
         }
         if(this.mDestinationCell == null)
         {
            if((mActor as IsometricCharacter).isStealth())
            {
               (mActor as IsometricCharacter).mDestinationCell = this.headToThePlayerArea();
               if((mActor as IsometricCharacter).mDestinationCell)
               {
                  (mActor as EnemyUnit).nullMovementCounter();
               }
               else
               {
                  (mActor as IsometricCharacter).mDestinationCell = this.findClosestPlayerCell();
               }
            }
            else
            {
               (mActor as IsometricCharacter).mDestinationCell = this.findClosestPlayerCell();
            }
         }
         else
         {
            (mActor as IsometricCharacter).mDestinationCell = this.mDestinationCell;
         }
         if((mActor as IsometricCharacter).mDestinationCell)
         {
            (mActor as IsometricCharacter).mDestinationCell.mCharacterComingToThisTile = mActor as IsometricCharacter;
            this.mTargetX = (mActor as WorldObject).mScene.getCenterPointXOfCell((mActor as IsometricCharacter).mDestinationCell);
            this.mTargetY = (mActor as WorldObject).mScene.getCenterPointYOfCell((mActor as IsometricCharacter).mDestinationCell);
            this.mOriginCell = mActor.getCell();
            (mActor as IsometricCharacter).moveTo(this.mTargetX,this.mTargetY);
            (mActor as IsometricCharacter).playCollectionSound((mActor as IsometricCharacter).mMoveSounds);
         }
         else
         {
            skip();
         }
      }
      
      protected function execute() : void
      {
         mActor.mScene.characterArrivedInCell(mActor as IsometricCharacter,mActor.getCell());
         mActor.getCell().mCharacterComingToThisTile = null;
         mActor.setAnimationAction(AnimationController.CHARACTER_ANIMATION_IDLE,false,true);
         var _loc1_:GridCell = mActor.getCell();
         var _loc2_:Object = {
            "coord_x":this.mOriginCell.mPosI,
            "coord_y":this.mOriginCell.mPosJ,
            "new_coord_x":_loc1_.mPosI,
            "new_coord_y":_loc1_.mPosJ
         };
         GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.MOVE_ENEMY,_loc2_,false);
         (mActor as IsometricCharacter).mPreviousTile = this.mOriginCell;
         if(Config.DEBUG_MODE)
         {
         }
         GameState.mInstance.enemyMoveMade();
      }
   }
}
