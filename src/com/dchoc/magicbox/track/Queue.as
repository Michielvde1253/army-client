package com.dchoc.magicbox.track
{
   public class Queue
   {
       
      
      private var queue:Array;
      
      public function Queue()
      {
         super();
         this.queue = new Array();
      }
      
      public function getSize() : int
      {
         return this.queue.length;
      }
      
      public function addMessage(param1:Tracking) : void
      {
         if(this.queue.indexOf(param1,0) < 0)
         {
            this.queue.push(param1);
         }
      }
      
      public function pop() : Tracking
      {
         return this.queue.shift();
      }
      
      public function isEqualToOldestElement(param1:Tracking) : Boolean
      {
         var _loc2_:Tracking = null;
         if(this.queue.length > 0)
         {
            _loc2_ = this.queue[0];
            if(param1 == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
   }
}
