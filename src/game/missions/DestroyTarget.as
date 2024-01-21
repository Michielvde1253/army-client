package game.missions
{
   import game.isometric.GridCell;
   import game.isometric.IsometricScene;
   import game.isometric.elements.Renderable;
   import game.states.GameState;
   
   public class DestroyTarget extends Objective
   {
       
      
      private var mTarget:Object;
      
      public function DestroyTarget(param1:Object)
      {
         super(param1);
         this.mTarget = param1.Parameter;
      }
      
      override public function initialize(param1:String, param2:Object) : void
      {
         super.initialize(param1,param2);
         var _loc3_:IsometricScene = GameState.mInstance.mScene;
         var _loc5_:Renderable;
         var _loc4_:GridCell;
         if(!(_loc5_ = (_loc4_ = _loc3_.getCellAt(mParameter[0],mParameter[1])).mCharacter))
         {
            _loc5_ = _loc4_.mObject;
         }
         if(!_loc5_ || this.mTarget.Type != _loc5_.mItem.mType || this.mTarget.ID != _loc5_.mItem.mId)
         {
            mCounter = 1;
         }
      }
      
      override public function increase(param1:Object, param2:int) : Boolean
      {
         var _loc4_:Renderable = null;
         var _loc5_:IsometricScene = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(isDone())
         {
            return false;
         }
         var _loc3_:* = this.mTarget == null;
         if(!_loc3_)
         {
            _loc4_ = param1 as Renderable;
            _loc6_ = (_loc5_ = GameState.mInstance.mScene).findGridLocationX(_loc4_.mX);
            _loc7_ = _loc5_.findGridLocationY(_loc4_.mY);
            _loc3_ = mParameter[0] == _loc6_ && mParameter[1] == _loc7_ && this.mTarget.Type == _loc4_.mItem.mType && this.mTarget.ID == _loc4_.mItem.mId;
         }
         if(_loc3_)
         {
            mCounter += param2;
            return true;
         }
         return false;
      }
   }
}
