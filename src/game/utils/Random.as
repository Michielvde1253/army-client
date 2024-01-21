package game.utils
{
   public class Random
   {
       
      
      private var smRandomSeed:int;
      
      public function Random(param1:int = 0)
      {
         super();
         this.smRandomSeed = param1;
      }
      
      public function setRandomSeed(param1:int) : void
      {
         this.smRandomSeed = param1;
      }
      
      public function nextInt(param1:int) : int
      {
         var _loc3_:* = 0;
         if(param1 == 0)
         {
            return 0;
         }
         var _loc2_:* = this.smRandomSeed;
         if(_loc2_ == 0)
         {
            _loc2_ = -1;
         }
         _loc3_ = _loc2_ << 13;
         _loc2_ ^= _loc3_;
         _loc3_ = _loc2_ >> 17;
         _loc2_ ^= _loc3_;
         _loc3_ = _loc2_ << 5;
         _loc2_ ^= _loc3_;
         this.smRandomSeed = _loc2_;
         return (this.smRandomSeed < 0 ? this.smRandomSeed * -1 : this.smRandomSeed) % param1;
      }
   }
}
