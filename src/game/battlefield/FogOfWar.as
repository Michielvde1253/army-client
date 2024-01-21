package game.battlefield
{
   import flash.geom.Point;
   import game.characters.EnemyUnit;
   import game.characters.PlayerUnit;
   import game.gameElements.DebrisObject;
   import game.gameElements.PlayerBuildingObject;
   import game.gameElements.PlayerInstallationObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.elements.Renderable;
   import game.items.ItemManager;
   import game.items.MapItem;
   import game.states.GameState;
   
   public class FogOfWar
   {
       
      
      public var mUpdateRequired:Boolean;
      
      private var mMapData:MapData;
      
      private var mScene:IsometricScene;
      
      private var mGrid:Array;
      
      public function FogOfWar(param1:IsometricScene)
      {
         super();
         this.mMapData = GameState.mInstance.mMapData;
         this.mScene = param1;
         this.mGrid = this.mMapData.mGrid;
      }
      
      public function init(param1:Boolean = true) : void
      {
         var _loc2_:Renderable = null;
         var _loc5_:GridCell = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         param1 &&= !GameState.mInstance.visitingTutor();
         if(GameState.mInstance.isFogOfWarOn())
         {
            _loc6_ = int(this.mGrid.length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               (_loc5_ = this.mGrid[_loc7_] as GridCell).mViewers = 1;
               if(_loc5_.mCharacter)
               {
                  _loc5_.mCharacter.mVisible = true;
                  _loc5_.mCharacter.getContainer().visible = true;
               }
               if(_loc5_.mObject)
               {
                  _loc5_.mObject.mVisible = true;
                  _loc5_.mObject.getContainer().visible = true;
               }
               _loc7_++;
            }
         }
         else
         {
            _loc8_ = 0;
            while(_loc8_ < this.mGrid.length)
            {
               (this.mGrid[_loc8_] as GridCell).mViewers = 0;
               _loc8_++;
            }
         }
         var _loc3_:int = int(this.mScene.mAllElements.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mScene.mAllElements[_loc4_] as Renderable;
            if(_loc2_ is PlayerUnit)
            {
               this.incrementUnitSightArea(_loc2_ as PlayerUnit);
            }
            else if(_loc2_ is PlayerBuildingObject)
            {
               this.mScene.incrementViewersForBuilding(_loc2_ as PlayerBuildingObject,(_loc2_ as PlayerBuildingObject).getSightRangeAccordingToCondition());
            }
            else if(_loc2_ is PlayerInstallationObject)
            {
               this.mScene.incrementViewersForInstallation(_loc2_ as PlayerInstallationObject,(_loc2_ as PlayerInstallationObject).getSightRangeAccordingToCondition());
            }
            else if(_loc2_ is DebrisObject)
            {
               _loc2_.getContainer().visible = !_loc2_.getCell().hasFog();
               _loc2_.mVisible = !_loc2_.getCell().hasFog();
            }
            _loc4_++;
         }
         this.mUpdateRequired = true;
      }
      
      public function destroy() : void
      {
         this.mScene = null;
         this.mGrid = null;
         this.mMapData = null;
      }
      
      public function recalculateFogEdges() : void
      {
         var _loc3_:GridCell = null;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc7_:GridCell = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc1_:int = this.mMapData.mGridWidth;
         var _loc2_:int = this.mMapData.mGridHeight;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc3_ = this.mGrid[_loc5_ * _loc1_ + _loc4_];
               _loc6_ = 0;
               if(!_loc3_.hasFog())
               {
                  _loc8_ = (_loc5_ - 1) * _loc1_ + (_loc4_ - 1);
                  _loc10_ = 0;
                  while(_loc10_ < 9)
                  {
                     if((_loc9_ = _loc8_ + _loc10_ % 3 + (_loc10_ / 3 as int) * _loc1_) >= 0)
                     {
                        if(_loc9_ < this.mGrid.length)
                        {
                           if((this.mGrid[_loc9_] as GridCell).hasFog())
                           {
                              _loc6_ |= 1 << _loc10_;
                           }
                        }
                     }
                     _loc10_++;
                  }
               }
               _loc3_.mFogEdgeBits = _loc6_;
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      public function incrementUnitSightArea(param1:PlayerUnit, param2:Boolean = false) : void
      {
         var _loc5_:GridCell = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:Renderable = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc3_:Array = this.mScene.getTilesUnderObjectSightArea(param1,param1.getSightRadius());
         var _loc4_:int = int(GameState.mConfig.EnemyAppearanceSetup.Ambush.EnemyUnits.ActivationOrders);
         var _loc6_:int = int(_loc3_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_ = _loc3_[_loc7_] as GridCell;
            this.incrementViewersForCell(_loc5_);
            if(param2)
            {
               if(Math.random() * 100 < GameState.mConfig.EnemyAppearanceSetup.Ambush.Probability)
               {
                  if(_loc5_.mWalkable)
                  {
                     if(!_loc5_.mCharacterComingToThisTile)
                     {
                        if(!_loc5_.mCharacter)
                        {
                           if(!_loc5_.mObject)
                           {
                              _loc8_ = 0;
                              _loc9_ = Math.random() * 100;
                              _loc10_ = 0;
                              while(_loc10_ < (GameState.mConfig.EnemyAppearanceSetup.Ambush.EnemyUnits as Array).length)
                              {
                                 _loc8_ += GameState.mConfig.EnemyAppearanceSetup.Ambush.EnemyUnitsP[_loc10_] as int;
                                 if(_loc9_ < _loc8_)
                                 {
                                    _loc11_ = String(((GameState.mConfig.EnemyAppearanceSetup.Ambush.EnemyUnits as Array)[_loc10_] as Object).ID);
                                    _loc12_ = this.mScene.createObject(ItemManager.getItem(_loc11_,"EnemyUnit") as MapItem,new Point(0,0));
                                    _loc13_ = this.mScene.getCenterPointXAtIJ(_loc5_.mPosI,_loc5_.mPosJ);
                                    _loc14_ = this.mScene.getCenterPointYAtIJ(_loc5_.mPosI,_loc5_.mPosJ);
                                    _loc12_.setPos(_loc13_,_loc14_,0);
                                    _loc12_.getContainer().visible = true;
                                    _loc12_.mVisible = true;
                                    (_loc12_ as EnemyUnit).changeReactionState(EnemyUnit.REACT_STATE_WAIT_FOR_ORDERS);
                                    (_loc12_ as EnemyUnit).mReactionStateCounter = _loc4_;
                                    _loc4_++;
                                    break;
                                 }
                                 _loc10_++;
                              }
                           }
                        }
                     }
                  }
               }
            }
            _loc7_++;
         }
      }
      
      public function decrementUnitSightArea(param1:PlayerUnit, param2:GridCell = null, param3:Boolean = false) : void
      {
         var _loc7_:GridCell = null;
         var _loc10_:Boolean = false;
         var _loc11_:Array = null;
         var _loc12_:GridCell = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         if(Config.CHEAT_DISABLE_FOG)
         {
            return;
         }
         var _loc4_:GridCell = !!param2 ? param2 : this.mScene.getCellAtLocation(param1.mX,param1.mY);
         var _loc5_:int = param1.getSightRadius();
         var _loc6_:Array = MapArea.getAreaAroundCell(this.mScene,_loc4_,_loc5_).getCells();
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_.length)
         {
            if(_loc7_ = _loc6_[_loc8_])
            {
               if(this.mScene.isInsideVisibleArea(_loc7_))
               {
                  if(int(this.getCellDistance(_loc7_,_loc4_) + 0.5) <= _loc5_)
                  {
                     if(_loc7_.mViewers >= 1)
                     {
                        --_loc7_.mViewers;
                        if(_loc7_.mViewers <= 0)
                        {
                           _loc7_.mViewers = 0;
                           this.mUpdateRequired = true;
                           if(_loc7_.mCharacter)
                           {
                              _loc7_.mCharacter.mVisible = !_loc7_.hasFog();
                              _loc7_.mCharacter.getContainer().visible = !_loc7_.hasFog();
                           }
                        }
                     }
                  }
               }
            }
            _loc8_++;
         }
         var _loc9_:int = 0;
         while(_loc9_ < _loc6_.length)
         {
            if(_loc7_ = _loc6_[_loc9_])
            {
               if(this.mScene.isInsideVisibleArea(_loc7_))
               {
                  if(int(this.getCellDistance(_loc7_,_loc4_) + 0.5) <= _loc5_)
                  {
                     if(_loc7_.mObject)
                     {
                        if(_loc7_.mObject.mVisible)
                        {
                           _loc10_ = false;
                           _loc13_ = int((_loc11_ = this.mScene.getTilesUnderObject(_loc7_.mObject)).length);
                           _loc14_ = 0;
                           while(_loc14_ < _loc13_)
                           {
                              if(!(_loc12_ = _loc11_[_loc14_] as GridCell).hasFog())
                              {
                                 _loc10_ = true;
                                 break;
                              }
                              _loc14_++;
                           }
                           if(!_loc10_)
                           {
                              _loc7_.mObject.mVisible = false;
                              _loc7_.mObject.getContainer().visible = false;
                           }
                        }
                     }
                  }
               }
            }
            _loc9_++;
         }
      }
      
      public function incrementViewersForCell(param1:GridCell) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.mViewers == 0)
         {
            this.mUpdateRequired = true;
            if(param1.mCharacter)
            {
               param1.mCharacter.mVisible = true;
               param1.mCharacter.getContainer().visible = true;
            }
            if(param1.mObject)
            {
               param1.mObject.mVisible = true;
               param1.mObject.getContainer().visible = true;
            }
         }
         ++param1.mViewers;
      }
      
      public function decrementViewersForCell(param1:GridCell) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Array = null;
         var _loc4_:GridCell = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(Config.CHEAT_DISABLE_FOG || !param1)
         {
            return;
         }
         if(param1.mViewers >= 1)
         {
            --param1.mViewers;
            if(param1.mViewers <= 0)
            {
               param1.mViewers = 0;
               this.mUpdateRequired = true;
               if(param1.mCharacter)
               {
                  param1.mCharacter.mVisible = !param1.hasFog();
                  param1.mCharacter.getContainer().visible = !param1.hasFog();
               }
               if(param1.mObject)
               {
                  if(param1.mObject.mVisible)
                  {
                     _loc2_ = false;
                     _loc3_ = this.mScene.getTilesUnderObject(param1.mObject);
                     _loc5_ = int(_loc3_.length);
                     _loc6_ = 0;
                     while(_loc6_ < _loc5_)
                     {
                        if(!(_loc4_ = _loc3_[_loc6_] as GridCell).hasFog())
                        {
                           _loc2_ = true;
                           break;
                        }
                        _loc6_++;
                     }
                     if(!_loc2_)
                     {
                        param1.mObject.mVisible = false;
                        param1.mObject.getContainer().visible = false;
                     }
                  }
               }
            }
         }
      }
      
      public function getCellDistance(param1:GridCell, param2:GridCell) : Number
      {
         var _loc3_:int = param1.mPosI - param2.mPosI;
         var _loc4_:int = param1.mPosJ - param2.mPosJ;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
   }
}
