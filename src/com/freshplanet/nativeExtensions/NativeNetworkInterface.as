package com.freshplanet.nativeExtensions
{
   public class NativeNetworkInterface
   {
       
      
      private var _name:String = "";
      
      private var _displayName:String = "";
      
      private var _mtu:int = -1;
      
      private var _hardwareAddress:String = "";
      
      private var _active:Boolean = false;
      
      public function NativeNetworkInterface(param1:String, param2:String, param3:int, param4:Boolean, param5:String, param6:Array)
      {
         super();
         this._name = param1;
         this._displayName = param2;
         this._mtu = param3;
         this._hardwareAddress = param5;
         this._active = param4;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get displayName() : String
      {
         return this._displayName;
      }
      
      public function get mtu() : int
      {
         return this._mtu;
      }
      
      public function get hardwareAddress() : String
      {
         return this._hardwareAddress;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
   }
}
