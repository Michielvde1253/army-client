package com.dchoc.utils
{
   import flash.events.EventDispatcher;
   
   public class CollectionItem extends EventDispatcher
   {
       
      
      private var mID:int;
      
      protected var mSku:String;
      
      public function CollectionItem(param1:String, param2:int)
      {
         super();
         this.mSku = param1;
         this.mID = param2;
      }
      
      public function getID() : int
      {
         return this.mID;
      }
      
      public function setID(param1:int) : void
      {
         this.mID = param1;
      }
      
      public function getSku() : String
      {
         return this.mSku;
      }
      
      public function getWithFunction(param1:String) : String
      {
         var _loc2_:Object = this[param1]();
         return !!_loc2_ ? String(_loc2_.toString()) : null;
      }
      
      override public function toString() : String
      {
         return "Sku=" + this.mSku + " id=" + this.mID;
      }
   }
}
