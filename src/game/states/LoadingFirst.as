package game.states
{
   import com.dchoc.graphics.DCResourceManager;
   import com.dchoc.utils.CursorManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   
   public class LoadingFirst extends LoadingState
   {
       
      
      protected var mStage:Stage;
      
      private var mTotalNumberResourcesToLoad:int;
      
      public function LoadingFirst(param1:StateMachine, param2:Stage, param3:FSMState, param4:DisplayObjectContainer)
      {
         super(param1,param3,param4);
         this.mStage = param2;
         Config.init();
      }
      
      override public function enter() : void
      {
         super.enter();
         this.initResourceManager();
         this.initCursorManager();
      }
      
      override public function logicUpdate(param1:int) : void
      {
         super.logicUpdate(param1);
         if(mPercent >= 100)
         {
            goToNextState();
            return;
         }
         setPercent(DCResourceManager.getInstance().getFileCountToLoad() / this.mTotalNumberResourcesToLoad * 100);
      }
      
      public function initResourceManager() : void
      {
         var _loc5_:String = null;
         var _loc1_:DCResourceManager = DCResourceManager.getInstance();
         var _loc2_:Array = FeatureTuner.USE_LOW_SWF ? AssetManager.SWF_IDS_LOW : AssetManager.SWF_IDS;
         if(Config.FOR_IPHONE_PLATFORM)
         {
            _loc2_ = FeatureTuner.USE_LOW_SWF ? AssetManager.SWF_IPHONE_LOW_IDS : AssetManager.SWF_IPHONE_IDS;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc5_ = String(_loc2_[_loc3_]);
            _loc1_.load(Config.DIR_DATA + _loc5_ + ".swf",_loc5_,null,false,false);
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < AssetManager.RES_IDS.length)
         {
            _loc1_.load(Config.DIR_PICS + AssetManager.RES_IDS[_loc4_] + ".png",AssetManager.RES_IDS[_loc4_],"Bitmap");
            _loc4_++;
         }
         this.mTotalNumberResourcesToLoad = _loc1_.getFileCountToLoad();
      }
      
      protected function initCursorManager() : void
      {
         var _loc1_:CursorManager = CursorManager.getInstance();
         _loc1_.init(this.mStage);
      }
   }
}
