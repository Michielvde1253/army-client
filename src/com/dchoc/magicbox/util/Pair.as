package com.dchoc.magicbox.util
{
   public class Pair
   {
       
      
      private var key:String;
      
      private var value:Object;
      
      public function Pair(param1:String, param2:Object)
      {
         super();
         this.key = param1;
         this.value = param2;
      }
      
      public function getKey() : String
      {
         return this.key;
      }
      
      public function getValue() : Object
      {
         return this.value;
      }
   }
}
