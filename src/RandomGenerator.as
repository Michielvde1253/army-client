package
{
   public class RandomGenerator
   {
      
      private static const DEFAULT_SEED_1:int = 123456789;
      
      private static const DEFAULT_SEED_2:int = 362436069;
      
      private static const DEFAULT_SEED_3:int = 521288629;
      
      private static const DEFAULT_SEED_4:int = 88675123;
       
      
      private var s1:int = 123456789;
      
      private var s2:int = 362436069;
      
      private var s3:int = 521288629;
      
      private var s4:int = 88675123;
      
      public function RandomGenerator()
      {
         super();
      }
      
      public function d100(param1:int, param2:int) : int
      {
         this.seedTwo(param1,param2);
         return this.randomIntMaxValue(100);
      }
      
      public function seed(param1:int) : void
      {
         this.seedFour(param1,0,0,0);
      }
      
      public function seedTwo(param1:int, param2:int) : void
      {
         this.seedFour(param1,param2,0,0);
      }
      
      public function seedThree(param1:int, param2:int, param3:int) : void
      {
         this.seedFour(param1,param2,param3,0);
      }
      
      public function seedFour(param1:int, param2:int, param3:int, param4:int) : void
      {
         this.s1 = param1 == 0 ? DEFAULT_SEED_1 : param1;
         this.s2 = param2 == 0 ? DEFAULT_SEED_2 : param2;
         this.s3 = param3 == 0 ? DEFAULT_SEED_3 : param3;
         this.s4 = param4 == 0 ? DEFAULT_SEED_4 : param4;
         var _loc5_:int = 0;
         while(_loc5_ < 8)
         {
            this.randomInt();
            _loc5_++;
         }
      }
      
      public function randomIntMaxValue(param1:int) : int
      {
         return Math.abs(this.randomInt() % param1);
      }
      
      public function randomInt() : int
      {
         var _loc1_:* = this.s1 ^ this.s1 << 11;
         this.s1 = this.s2;
         this.s2 = this.s3;
         this.s3 = this.s4;
         this.s4 = this.s4 ^ this.s4 >>> 19 ^ (_loc1_ ^ _loc1_ >>> 8);
         return this.s4;
      }
   }
}
