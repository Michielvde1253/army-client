package game.states
{
   import com.dchoc.GUI.DCFillBar;
   import com.dchoc.graphics.DCResourceManager;
   import com.dchoc.utils.DCUtils;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import game.net.MyServer;
   
   public class LoadingState extends FSMState
   {
       
      
      protected var mPercent:int;
      
      protected var mLoadingClip:DisplayObjectContainer;
      
      protected var mLoadingFillBar:DCFillBar;
      
      protected var mNextState:FSMState;
      
      protected var mResourcesToLoad:Array;
      
      protected var mServerResponsesNeeded:Array;
      
      public function LoadingState(param1:StateMachine, param2:FSMState, param3:DisplayObjectContainer)
      {
         var _loc5_:TextFormat = null;
         super(param1);
         this.mResourcesToLoad = new Array();
         this.mServerResponsesNeeded = new Array();
         this.mNextState = param2;
         this.mLoadingClip = param3;
         var _loc4_:TextField;
         if(_loc4_ = this.mLoadingClip.getChildByName("Text_Title") as TextField)
         {
            _loc4_.text = "Loading";
            if(Config.FOR_IPHONE_PLATFORM)
            {
               (_loc5_ = _loc4_.getTextFormat()).size = 17;
               _loc4_.defaultTextFormat = _loc5_;
               _loc4_.setTextFormat(_loc5_);
            }
         }
         this.mLoadingFillBar = new DCFillBar(this.mLoadingClip.getChildByName("Fill_Bar") as MovieClip,0,100);
      }
      
      protected function addClip() : void
      {
         mMainClip.addChild(this.mLoadingClip);
         DCUtils.centerClip(this.mLoadingClip);
      }
      
      protected function toggleDescription(param1:MouseEvent) : void
      {
         var _loc2_:DCResourceManager = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TextField = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:MyServer = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:TextFormat = null;
         if(param1.buttonDown)
         {
            _loc2_ = DCResourceManager.getInstance();
            _loc3_ = _loc2_.getFileCountToLoad();
            _loc4_ = "";
            if(_loc3_ > 0)
            {
               _loc4_ += _loc3_ + " files not loaded from\n";
               _loc8_ = int(this.mResourcesToLoad.length);
               _loc9_ = 0;
               while(_loc9_ < _loc8_)
               {
                  _loc7_ = this.mResourcesToLoad[_loc9_] as String;
                  _loc4_ += _loc7_ + ",\n";
                  _loc9_++;
               }
            }
            if(GameState.mInstance)
            {
               if(!GameState.mInstance.mServer)
               {
                  _loc4_ += "\n" + "NO SERVER CONNECTION ESTABLISHED";
               }
               else
               {
                  (_loc10_ = GameState.mInstance.mServer).getNumberOfBlockingCalls();
                  _loc4_ += "\n" + _loc10_.getNumberOfBlockingCalls() + " calls waiting for response \n Requests made:";
                  _loc12_ = int(this.mServerResponsesNeeded.length);
                  _loc13_ = 0;
                  while(_loc13_ < _loc12_)
                  {
                     _loc11_ = this.mServerResponsesNeeded[_loc13_] as String;
                     _loc4_ += _loc11_ + ",\n";
                     _loc13_++;
                  }
               }
            }
            (_loc6_ = (_loc5_ = this.mLoadingClip.getChildByName("Fill_Bar") as MovieClip).getChildByName("Text_Description") as TextField).selectable = true;
            _loc6_.wordWrap = true;
            _loc6_.autoSize = TextFieldAutoSize.LEFT;
            _loc6_.y = 50;
            _loc6_.width = 200;
            _loc6_.height = 150;
            _loc6_.text = _loc4_;
            if(Config.FOR_IPHONE_PLATFORM)
            {
               (_loc14_ = _loc6_.getTextFormat()).size = 24;
               _loc6_.defaultTextFormat = _loc14_;
               _loc6_.setTextFormat(_loc14_);
            }
         }
      }
      
      override public function enter() : void
      {
         super.enter();
         this.addClip();
         this.setPercent(0);
      }
      
      override public function exit() : void
      {
         super.exit();
         if(mMainClip.contains(this.mLoadingClip))
         {
            mMainClip.removeChild(this.mLoadingClip);
         }
      }
      
      override public function logicUpdate(param1:int) : void
      {
      }
      
      protected function goToNextState() : void
      {
         getStateMachine().setNextState(this.mNextState);
      }
      
      protected function setPercent(param1:int) : void
      {
         this.mPercent = param1;
         this.setLoadingBarPercent(param1);
      }
      
      protected function setLoadingBarPercent(param1:int) : void
      {
         this.mLoadingFillBar.setValueWithoutBarAnimation(param1);
      }
   }
}
