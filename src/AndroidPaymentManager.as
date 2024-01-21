package
{
   import com.milkmangames.nativeextensions.android.*;
   import com.milkmangames.nativeextensions.android.events.*;
   import game.items.BuyCashItem;
   import game.items.BuyGoldItem;
   import game.items.ShopItem;
   import game.magicBox.FlurryEvents;
   import game.magicBox.MagicBoxTracker;
   import game.net.ServiceIDs;
   import game.states.GameState;
   
   public class AndroidPaymentManager
   {
      
      private static const PUBLIC_KEY:String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmZaYYCJ64mnG+jcDQq11fEJ5sTLwaAPHBLBBDoBBEIIpW3Jbg60xHI9ILWlQvBLyKxwJeFwzH/n0cP+FcGqcArjphDWBvAB2U303ph0maWXJDZPtSo9GS7+TDGkAqoXyO+/38FEm3xhWulWkBOjWCYQEXVN/HxhiRMLYETUqUsdslafwPEPAHnh1XAlDSPig8MSaxAFvC85qgTbLVpdYYIXTbp5FhcHUkxMLamc3JTtJU4NeV/MHpHuJViZMEyNUlGUKvf5giDsQcdLEjB2gxdRH1L9U36tyocvf8/X8xRjarKCA8CZYSCxcDxdRikPgTlgt9JAArBQyYvxghK9IkQIDAQAB";
       
      
      private var purchasedShopItem:ShopItem;
      
      public function AndroidPaymentManager()
      {
         super();
      }
      
      public function startBillingService() : void
      {
      }
      
      public function stopBillingService() : void
      {
      }
      
      public function startPurchase(param1:ShopItem) : void
      {
      }
      
      public function testPurchase() : void
      {
      }
      
      public function testRefund() : void
      {
      }
      
      public function purchaseManagedItem(param1:String) : void
      {
      }
      
      public function purchaseItem(param1:String) : void
      {
      }
      
      public function purchaseSubscriptionItem(param1:String) : void
      {
      }
      
      public function restoreManagedTransactions() : void
      {
      }
   }
}
