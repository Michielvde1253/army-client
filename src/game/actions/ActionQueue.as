package game.actions
{
   public class ActionQueue
   {
       
      
      public var mActions:Array;
      
      public function ActionQueue()
      {
         super();
         this.mActions = new Array();
      }
      
      public function skipAll() : void
      {
         var _loc1_:Action = null;
         var _loc2_:int = int(this.mActions.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.mActions[_loc3_] as Action;
            _loc1_.skip();
            _loc3_++;
         }
      }
   }
}
