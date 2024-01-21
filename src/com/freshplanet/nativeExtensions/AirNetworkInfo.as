package com.freshplanet.nativeExtensions
{
   
   public class AirNetworkInfo
   {
      
      
      private static var _instance:AirNetworkInfo = null;
       
      
      public function AirNetworkInfo()
      {
         super();
      }
      
      public static function get networkInfo() : AirNetworkInfo
      {
         return _instance != null ? _instance : new AirNetworkInfo();
      }
      
      public function isConnected() : Boolean
      {
         if(this.useNativeExtension())
         {
            return this.hasNativeActiveConnection();
         }
         return this.hasActiveConnection();
      }
      
      public function isConnectedWithWIFI() : Boolean
      {
         if(this.useNativeExtension())
         {
            return this.isNativeConnectedWithWIFI();
         }
         return this.isNotNativeConnectedWithWIFI();
      }
      
      private function isNativeConnectedWithWIFI() : Boolean
      {
         return false;
      }
      
      private function isNotNativeConnectedWithWIFI() : Boolean
      {
         return false;
      }
      
      private function hasNativeActiveConnection() : Boolean
      {
         return false;
      }
      
      private function hasActiveConnection() : Boolean
      {

         return false;
      }
      
      public function findInterfaces() : Boolean
      {
		return false;
      }
      
      private function useNativeExtension() : Boolean
      {
         return false;
      }
   }
}
