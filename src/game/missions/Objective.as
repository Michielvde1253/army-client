package game.missions
{
   import com.dchoc.graphics.DCResourceManager;
   import flash.display.MovieClip;
   import game.gui.IconInterface;
   import game.isometric.IsometricScene;
   import game.states.GameState;
   
   public class Objective implements IconInterface
   {
       
      
      public var mId:String;
      
      public var mMapId:String;
      
      public var mType:String;
      
      public var mParameter:Object;
      
      public var mGoal:int;
      
      public var mTitle:String;
      
      public var mDescription:String;
      
      public var mCounter:int;
      
      public var mCostFinish:int;
      
      public var mPurchased:Boolean = false;
      
      private var mIconGraphicsFile:String;
      
      private var mIconGraphics:String;
      
      private var mMissionType:String;
      
      public function Objective(param1:Object)
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         super();
         this.mId = param1.ID;
         this.mType = param1.Type.ID;
         if(param1.Coordinates)
         {
            _loc2_ = param1.Coordinates.split("_");
            if(_loc2_.length > 2)
            {
               this.mParameter = new Array();
               if(_loc2_.length == 4)
               {
                  _loc3_ = 0;
                  while(_loc3_ < _loc2_[2])
                  {
                     if(_loc3_ == 0)
                     {
                        this.mParameter.push(new Array(_loc2_[0],_loc2_[1]));
                     }
                     else
                     {
                        this.mParameter.push(new Array(int(_loc2_[0]) + _loc3_,int(_loc2_[1])));
                        this.mParameter.push(new Array(int(_loc2_[0]),int(_loc2_[1]) + _loc3_));
                        this.mParameter.push(new Array(int(_loc2_[0]) + int(_loc2_[2]) - 1,int(_loc2_[1]) + _loc3_));
                        if(_loc3_ < int(_loc2_[2]) - 1)
                        {
                           this.mParameter.push(new Array(int(_loc2_[0]) + _loc3_,int(_loc2_[1]) + int(_loc2_[2]) - 1));
                        }
                     }
                     _loc3_++;
                  }
               }
               else
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc2_[2])
                  {
                     _loc5_ = 0;
                     while(_loc5_ < _loc2_[2])
                     {
                        this.mParameter.push(new Array(int(_loc2_[0]) + _loc5_,int(_loc2_[1]) + _loc4_));
                        _loc5_++;
                     }
                     _loc4_++;
                  }
               }
            }
            else
            {
               this.mParameter = _loc2_;
            }
         }
         else
         {
            this.mParameter = param1.Parameter;
         }
         this.mGoal = param1.Goal;
         this.mTitle = param1.Title;
         this.mDescription = param1.Description;
         this.mCostFinish = param1.CostFinish;
         if(param1.Icon)
         {
            _loc6_ = int(param1.Icon.lastIndexOf("/"));
            this.mIconGraphics = param1.Icon.substring(_loc6_ + 1);
            this.mIconGraphicsFile = param1.Icon.substring(0,_loc6_);
         }
      }
      
      public function setMapId(param1:String) : void
      {
         this.mMapId = param1;
      }
      
      public function isDone() : Boolean
      {
         return this.mCounter >= this.mGoal;
      }
      
      public function initialize(param1:String, param2:Object) : void
      {
         var _loc3_:IsometricScene = null;
         var _loc4_:int = 0;
         this.mMissionType = param1;
         if(param2)
         {
            this.mGoal = param2.goal - param2.startValue;
            this.mCounter = Math.min(param2.counterValue - param2.startValue,this.mGoal);
            this.mPurchased = param2.purchased == "true";
            if(this.mPurchased)
            {
               this.mCounter = this.mGoal;
            }
         }
         else
         {
            this.mCounter = 0;
         }
         if((param1 == Mission.TYPE_MODAL_ARROW || param1 == Mission.TYPE_INTEL) && this.mParameter is Array)
         {
            _loc3_ = GameState.mInstance.mScene;
            switch(this.mType)
            {
               case "DestroyTarget":
                  _loc4_ = IsometricScene.TUTORIAL_HIGHLIGHT_TARGET;
                  break;
               case "Conquer":
                  _loc4_ = IsometricScene.TUTORIAL_HIGHLIGHT_MOVE;
                  break;
               default:
                  _loc4_ = IsometricScene.TUTORIAL_HIGHLIGHT_CIRCLE;
            }
            _loc3_.setTutorialHighlight(_loc4_,this.mParameter[0],this.mParameter[1]);
            _loc3_.disableMouse(this.mParameter[0],this.mParameter[1],param1 == Mission.TYPE_INTEL);
         }
      }
      
      public function clean() : void
      {
         var _loc1_:IsometricScene = null;
         if((this.mMissionType == Mission.TYPE_MODAL_ARROW || this.mMissionType == Mission.TYPE_INTEL) && this.mParameter is Array)
         {
            _loc1_ = GameState.mInstance.mScene;
            _loc1_.removeTutorialHighlight();
            _loc1_.enableMouse();
         }
      }
      
      public function increase(param1:Object, param2:int) : Boolean
      {
         if(this.isDone())
         {
            return false;
         }
         if(this.mParameter == null || param1 == null || param1 == this.mParameter)
         {
			if(GameState.mInstance.mLoadingStatesOver){
               this.mCounter += param2;
               this.mCounter = Math.min(this.mCounter,this.mGoal);
               return true;
			}
         }
         return false;
      }
      
      public function buy() : void
      {
         this.mPurchased = true;
         this.mCounter = this.mGoal;
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
