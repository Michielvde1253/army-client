package game.gui
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.text.TextField;
   import game.characters.PlayerUnit;
   import game.gameElements.ConstructionObject;
   import game.gameElements.DecorationObject;
   import game.gameElements.PlayerInstallationObject;
   import game.gameElements.ResourceBuildingObject;
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.items.PlayerUnitItem;
   import game.states.GameState;
   
   public class CursorManager
   {
      
      public static const CURSOR_TYPE_MOVE_UNIT:int = 0;
      
      public static const CURSOR_TYPE_ATTACK_1:int = 1;
      
      public static const CURSOR_TYPE_ATTACK_2:int = 2;
      
      public static const CURSOR_TYPE_ATTACK_3:int = 3;
      
      public static const CURSOR_TYPE_ATTACK_4:int = 4;
      
      public static const CURSOR_TYPE_SELL_1:int = 5;
      
      public static const CURSOR_TYPE_SELL_2:int = 6;
      
      public static const CURSOR_TYPE_SELL_3:int = 7;
      
      public static const CURSOR_TYPE_SELL_4:int = 8;
      
      public static const CURSOR_TYPE_RELOCATE_1:int = 9;
      
      public static const CURSOR_TYPE_RELOCATE_2:int = 10;
      
      public static const CURSOR_TYPE_RELOCATE_3:int = 11;
      
      public static const CURSOR_TYPE_RELOCATE_4:int = 12;
      
      public static const CURSOR_TYPE_SELECT_1:int = 13;
      
      public static const CURSOR_TYPE_SELECT_2:int = 14;
      
      public static const CURSOR_TYPE_SELECT_3:int = 15;
      
      public static const CURSOR_TYPE_SELECT_4:int = 16;
      
      public static const CURSOR_TYPE_REPAIR_1:int = 17;
      
      public static const CURSOR_TYPE_REPAIR_2:int = 18;
      
      public static const CURSOR_TYPE_REPAIR_3:int = 19;
      
      public static const CURSOR_TYPE_REPAIR_4:int = 20;
      
      public static const CURSOR_TYPE_FM_1:int = 21;
      
      public static const CURSOR_TYPE_FM_2:int = 22;
      
      public static const CURSOR_TYPE_FM_3:int = 23;
      
      public static const CURSOR_TYPE_FM_4:int = 24;
      
      public static const CURSOR_TYPE_FM_5:int = 25;
      
      public static const CURSOR_TYPE_RELOCATE_WITH_COST_1:int = 26;
      
      public static const CURSOR_TYPE_RELOCATE_WITH_COST_2:int = 27;
      
      public static const CURSOR_TYPE_RELOCATE_WITH_COST_3:int = 28;
      
      public static const CURSOR_TYPE_RELOCATE_WITH_COST_4:int = 29;
      
      public static const CURSOR_TYPE_REDEPLOY:int = 30;
      
      public static const CURSOR_TYPE_SELECT_SPECIAL_2X1:int = 31;
      
      public static const CURSOR_TYPE_SELECT_SPECIAL_4X1:int = 32;
      
      public static const CURSOR_TYPE_SELECT_SPECIAL_4X2:int = 33;
      
      public static const CURSOR_TYPE_SELECT_SPECIAL_3X2:int = 34;
      
      public static const CURSOR_TYPE_ATTACK_SPECIAL_2X1:int = 35;
      
      public static const CURSOR_TYPE_ATTACK_SPECIAL_4X1:int = 36;
      
      public static const CURSOR_TYPE_ATTACK_SPECIAL_4X2:int = 37;
      
      public static const CURSOR_TYPE_ATTACK_SPECIAL_3X2:int = 38;
      
      public static const CURSOR_TYPE_DISABLED:int = 39;
      
      private static var mInstance:CursorManager;
      
      private static var mAllowInstantiation:Boolean;
       
      
      private const CURSOR_TYPE_NAMES:Array = new Array("cursor_moveunits_1x1","cursor_attack_1x1","cursor_attack_2x2","cursor_attack_3x3","cursor_attack_4x4","cursor_sell_1x1","cursor_sell_2x2","cursor_sell_3x3","cursor_sell_4x4","cursor_place_1x1","cursor_place_2x2","cursor_place_3x3","cursor_place_4x4","cursor_select_1x1","cursor_select_2x2","cursor_select_3x3","cursor_select_4x4","cursor_repair_1x1","cursor_repair_2x2","cursor_repair_3x3","cursor_repair_4x4","cursor_powerup_01","cursor_powerup_02","cursor_powerup_03","cursor_powerup_04","cursor_powerup_06","cursor_place_1x1","cursor_place_2x2","cursor_place_3x3","cursor_place_4x4","cursor_redeploy_1x1","cursor_select_special_2x1","cursor_select_special_4x1","cursor_select_special_4x2","cursor_select_special_3x2","cursor_attack_special_2x1","cursor_attack_special_4x1","cursor_attack_special_4x2","cursor_attack_special_3x2","grid_disabled");
      
      private var mMouseCursorImage:MovieClip;
      
      private var mCursors:Array;
      
      private var mCurrentCursorType:int = -1;
      
      private var mPointTmp:Point;
      
      private var mCursorPosition:GridCell = null;
      
      public function CursorManager()
      {
         this.mPointTmp = new Point();
         super();
         if(!mAllowInstantiation)
         {
            throw new Error("ERROR: CursorManager Error: Instantiation failed: Use CursorManager.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : CursorManager
      {
         if(mInstance == null)
         {
            mAllowInstantiation = true;
            mInstance = new CursorManager();
            mAllowInstantiation = false;
         }
         return mInstance;
      }
      
      public function init() : void
      {
         this.mCurrentCursorType = CURSOR_TYPE_MOVE_UNIT;
      }
      
      public function initCursorImages() : void
      {
         var _loc2_:MovieClip = null;
         var _loc5_:Class = null;
         this.mCursors = new Array();
         var _loc1_:DCResourceManager = DCResourceManager.getInstance();
         var _loc3_:Sprite = GameState.mInstance.mScene.mSceneHud;
         var _loc4_:int = 0;
         while(_loc4_ < this.CURSOR_TYPE_NAMES.length)
         {
            if(_loc5_ = _loc1_.getSWFClass(Config.SWF_INTERFACE_NAME,this.CURSOR_TYPE_NAMES[_loc4_]))
            {
               _loc2_ = new _loc5_() as MovieClip;
               _loc2_.mouseEnabled = false;
               _loc2_.mouseChildren = false;
               this.mCursors.push(_loc2_);
            }
            _loc4_++;
         }
      }
      
      public function addCursorImage(param1:int, param2:Boolean, param3:int = 0) : void
      {
         var _loc4_:Sprite = null;
         var _loc7_:MovieClip = null;
         var _loc8_:TextField = null;
         var _loc9_:MovieClip = null;
         var _loc10_:MovieClip = null;
         var _loc11_:MovieClip = null;
         var _loc12_:TextField = null;
         var _loc13_:int = 0;
         var _loc14_:GridCell = null;
         var _loc15_:PlayerUnit = null;
         var _loc16_:PlayerInstallationObject = null;
         var _loc17_:ConstructionObject = null;
         var _loc18_:ResourceBuildingObject = null;
         var _loc19_:DecorationObject = null;
         var _loc20_:IsometricScene = null;
         var _loc21_:MovieClip = null;
         var _loc22_:TextField = null;
         var _loc23_:int = 0;
         var _loc24_:MovieClip = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         if(this.mCurrentCursorType == param1)
         {
            return;
         }
         this.mCurrentCursorType = param1;
         _loc4_ = GameState.mInstance.mScene.mMapGUIEffectsLayer.mTopLayer;
         var _loc5_:MovieClip = this.mCursors[this.mCurrentCursorType] as MovieClip;
         var _loc6_:Sprite;
         (_loc6_ = GameState.mInstance.mScene.mSceneHud).addChild(_loc5_);
         if(param1 == CURSOR_TYPE_SELECT_1)
         {
            _loc8_ = (_loc7_ = _loc5_.getChildByName("Movement_Cost_Energy") as MovieClip).getChildByName("Text_Field_Value") as TextField;
            if(param3 != 0)
            {
               _loc8_.text = String(param3);
               _loc7_.visible = true;
            }
            else
            {
               _loc7_.visible = false;
            }
         }
         else if(param1 >= CURSOR_TYPE_REPAIR_1 && param1 <= CURSOR_TYPE_REPAIR_4)
         {
            _loc9_ = _loc5_.getChildByName("Repair_Active") as MovieClip;
            _loc10_ = _loc5_.getChildByName("Repair_Disabled") as MovieClip;
            _loc9_.visible = !param2;
            _loc10_.visible = param2;
            _loc12_ = (_loc11_ = _loc5_.getChildByName("Supply_Cost") as MovieClip).getChildByName("Text_Amount") as TextField;
            if(param2)
            {
               _loc11_.visible = false;
            }
            else
            {
               _loc13_ = 0;
               if((_loc14_ = GameState.mInstance.mScene.getTileUnderMouse()).mCharacter)
               {
                  _loc11_.visible = true;
                  if((_loc13_ = (_loc15_ = _loc14_.mCharacter as PlayerUnit).getHealCostSupplies()) > 0)
                  {
                     _loc12_.text = _loc15_.getHealCostSupplies().toString();
                  }
                  else
                  {
                     _loc11_.visible = false;
                  }
               }
               else if(_loc14_.mObject)
               {
                  if(_loc14_.mObject is PlayerInstallationObject)
                  {
                     _loc13_ = (_loc16_ = _loc14_.mObject as PlayerInstallationObject).getHealCostSupplies();
                  }
                  else if(_loc14_.mObject is ConstructionObject)
                  {
                     _loc13_ = (_loc17_ = _loc14_.mObject as ConstructionObject).getHealCostSupplies();
                  }
                  else if(_loc14_.mObject is ResourceBuildingObject)
                  {
                     _loc13_ = (_loc18_ = _loc14_.mObject as ResourceBuildingObject).getHealCostSupplies();
                  }
                  else if(_loc14_.mObject is DecorationObject)
                  {
                     _loc13_ = (_loc19_ = _loc14_.mObject as DecorationObject).getHealCostSupplies();
                  }
                  if(_loc13_ > 0)
                  {
                     _loc12_.text = _loc13_.toString();
                     _loc11_.visible = true;
                  }
                  else
                  {
                     _loc11_.visible = false;
                  }
               }
            }
         }
         else if(param1 >= CURSOR_TYPE_RELOCATE_1 && param1 <= CURSOR_TYPE_RELOCATE_4)
         {
            (_loc11_ = _loc5_.getChildByName("Supply_Cost") as MovieClip).visible = false;
         }
         else if(param1 >= CURSOR_TYPE_RELOCATE_WITH_COST_1 && param1 <= CURSOR_TYPE_RELOCATE_WITH_COST_4)
         {
            _loc12_ = (_loc11_ = _loc5_.getChildByName("Supply_Cost") as MovieClip).getChildByName("Text_Amount") as TextField;
            if(param2)
            {
               _loc11_.visible = false;
            }
            else
            {
               _loc20_ = GameState.mInstance.mScene;
               _loc13_ = 0;
               if(_loc20_.mObjectBeingMoved)
               {
                  if(_loc20_.mObjectBeingMovedStartX != _loc20_.mObjectBeingMoved.mX || _loc20_.mObjectBeingMovedStartY != _loc20_.mObjectBeingMoved.mY)
                  {
                     _loc13_ = _loc20_.mObjectBeingMoved.getMoveCostSupplies();
                  }
               }
               else if((_loc14_ = _loc20_.getTileUnderMouse()).mObject)
               {
                  _loc13_ = _loc14_.mObject.getMoveCostSupplies();
               }
               if(_loc13_ > 0)
               {
                  _loc12_.text = _loc13_.toString();
                  _loc11_.visible = true;
               }
               else
               {
                  _loc11_.visible = false;
               }
            }
         }
         else if(param1 == CURSOR_TYPE_REDEPLOY)
         {
            _loc22_ = (_loc21_ = _loc5_.getChildByName("Supply_Cost") as MovieClip).getChildByName("Text_Amount") as TextField;
            _loc20_ = GameState.mInstance.mScene;
            _loc23_ = 0;
            if(Boolean((_loc14_ = _loc20_.getTileUnderMouse()).mCharacter) && _loc14_.mCharacter is PlayerUnit)
            {
               _loc23_ = PlayerUnitItem(PlayerUnit(_loc14_.mCharacter).mItem).mPickupCostSupplies;
            }
            if(_loc23_ > 0)
            {
               _loc22_.text = _loc23_.toString();
               _loc21_.visible = true;
            }
            else
            {
               _loc21_.visible = false;
            }
         }
         if(param2)
         {
            _loc24_ = this.mCursors[CURSOR_TYPE_DISABLED] as MovieClip;
            _loc25_ = (this.mCursors[this.mCurrentCursorType] as MovieClip).width / GameState.mInstance.mScene.mGridDimX;
            _loc26_ = GameState.mInstance.mScene.getLeftUpperXOfCell(this.mCursorPosition);
            _loc27_ = GameState.mInstance.mScene.getLeftUpperYOfCell(this.mCursorPosition);
            _loc24_.scaleX = 1;
            _loc24_.scaleY = 1;
            _loc24_.x = _loc26_ + _loc25_ / 2 * GameState.mInstance.mScene.mGridDimX;
            _loc24_.y = _loc27_ + _loc25_ / 2 * GameState.mInstance.mScene.mGridDimY;
            _loc24_.scaleX = _loc25_;
            _loc24_.scaleY = _loc25_;
            _loc4_.addChild(_loc24_);
         }
      }
      
      public function hideCursorImages(param1:Event = null) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:int = int(this.mCursors.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this.mCursors[_loc4_] as DisplayObject;
            if(_loc2_.parent)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
            _loc2_ = null;
            _loc4_++;
         }
         this.mCurrentCursorType = -1;
      }
      
      public function setPos(param1:GridCell) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         if(param1 == this.mCursorPosition)
         {
            return;
         }
         this.mCursorPosition = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.mCursors.length)
         {
            (this.mCursors[_loc2_] as MovieClip).x = GameState.mInstance.mScene.getCenterPointXOfCell(param1);
            (this.mCursors[_loc2_] as MovieClip).y = GameState.mInstance.mScene.getCenterPointYOfCell(param1);
            _loc2_++;
         }
         if(this.mCurrentCursorType != -1)
         {
            _loc3_ = this.mCursors[CURSOR_TYPE_DISABLED] as MovieClip;
            _loc4_ = (this.mCursors[this.mCurrentCursorType] as MovieClip).width / GameState.mInstance.mScene.mGridDimX;
            _loc3_.x += (_loc4_ - 1) / 2 * GameState.mInstance.mScene.mGridDimX;
            _loc3_.y += (_loc4_ - 1) / 2 * GameState.mInstance.mScene.mGridDimY;
         }
      }
      
      public function clean() : void
      {
         this.mCurrentCursorType = -1;
         var _loc1_:int = 0;
         while(_loc1_ < this.mCursors.length)
         {
            if((this.mCursors[_loc1_] as MovieClip).parent)
            {
               (this.mCursors[_loc1_] as MovieClip).parent.removeChild(this.mCursors[_loc1_]);
            }
            _loc1_++;
         }
         if(this.mMouseCursorImage)
         {
            if(this.mMouseCursorImage.parent)
            {
               this.mMouseCursorImage.parent.removeChild(this.mMouseCursorImage);
            }
         }
         this.mMouseCursorImage = null;
      }
   }
}
