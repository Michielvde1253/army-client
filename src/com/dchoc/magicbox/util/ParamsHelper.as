package com.dchoc.magicbox.util
{
   import flash.utils.Dictionary;
   
   public class ParamsHelper
   {
       
      
      private var additionalParams:Array;
      
      private var params:Dictionary;
      
      public function ParamsHelper()
      {
         this.additionalParams = new Array();
         this.params = new Dictionary();
         super();
      }
      
      public function addParam(param1:String, param2:Object) : void
      {
         this.additionalParams.push(new Pair(param1,param2));
      }
      
      public function build() : Array
      {
         return this.additionalParams;
      }
      
      public function returnKeys() : Array
      {
         var _loc2_:Pair = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.additionalParams)
         {
            _loc1_.push(_loc2_.getKey());
         }
         return _loc1_;
      }
      
      public function getValue(param1:String) : Object
      {
         var _loc2_:Pair = null;
         for each(_loc2_ in this.additionalParams)
         {
            if(_loc2_.getKey() == param1)
            {
               return _loc2_.getValue();
            }
         }
         return null;
      }
   }
}
