package
{
   import com.adobe.crypto.MD5;
   import flash.utils.getTimer;
   import game.net.ServiceIDs;
   import game.states.GameState;
   import mx.rpc.http.HTTPService;
   
   public class FederalInterface
   {
      
      private static const GAME_SECRET_KEY:String = "9WNNP7AZCCOVHM54NZ6PYMX88";
      
      private static const FEDERAL_GAME_ID:String = "Army_Android";
      
      public static const ARMY_CASH_CURRENCY_ID:int = 155;
      
      public static const ARMY_GOLD_CURRENCY_ID:int = 154;
      
      private static const FEDERAL_DEV_SERVER_TRACK_START_URL:String = "http://federaldev.digitalchocolate.com/account/track_start_mobile_session";
      
      private static const FEDERAL_LIVE_SERVER_TRACK_START_URL:String = "http://federal.digitalchocolate.com/account/track_start_mobile_session";
      
      private static const FEDERAL_STAGE_SERVER_TRACK_START_URL:String = "http://federalstage.digitalchocolate.com/account/track_start_mobile_session";
      
      private static var FEDERAL_CURRENT_SERVER_TRACK_START_URL:String = FeatureTuner.USE_LIVE_BUILD_PRODUCTION ? FEDERAL_LIVE_SERVER_TRACK_START_URL : FEDERAL_STAGE_SERVER_TRACK_START_URL;
      
      private static const FEDERAL_STAGE_SERVER_TRACK_PURCHASE_URL:String = "http://federalstage.digitalchocolate.com/payment/track_mobile_purchase";
      
      private static const FEDERAL_DEV_SERVER_TRACK_PURCHASE_URL:String = "http://federaldev.digitalchocolate.com/payment/track_mobile_purchase";
      
      private static const FEDERAL_LIVE_SERVER_TRACK_PURCHASE_URL:String = "http://federal.digitalchocolate.com/payment/track_mobile_purchase";
      
      private static const FEDERAL_CURRENT_SERVER_TRACK_PURCHASE_URL:String = FeatureTuner.USE_LIVE_BUILD_PRODUCTION ? FEDERAL_LIVE_SERVER_TRACK_PURCHASE_URL : FEDERAL_STAGE_SERVER_TRACK_PURCHASE_URL;
       
      
      public function FederalInterface()
      {
         super();
      }
      
      public static function startUserSessionInFed() : void
      {
         startSessionInFed();
      }
      
      private static function startSessionInFed() : void
      {
         var jsonObject:Object = null;
         var gameId:String = FEDERAL_GAME_ID;
         var adId:String = Config.smUserId;
         var start_at:Number = getTimer() / 1000;
         var gameSecretKey:String = GAME_SECRET_KEY;
         var baseString:String = gameId + adId + start_at + gameSecretKey;
         var hash:String = MD5.hash(baseString);
         var url:String = FEDERAL_CURRENT_SERVER_TRACK_START_URL;
         try
         {
            jsonObject = {
               "ad_id":adId,
               "game_id":gameId,
               "start_at":start_at,
               "hash":hash
            };
            if(!checkForNetwork())
            {
               GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.FEDERAL_PROXY,jsonObject,false);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public static function trackPurchaseInFed(param1:int, param2:String, param3:int, param4:String, param5:String, param6:int) : void
      {
         var amount:int = param1;
         var price:String = param2;
         var paymentType:int = param3;
         var transactionId:String = param4;
         var currency:String = param5;
         var game_currency_id:int = param6;
         try
         {
            trackPurchase(amount,price,paymentType,transactionId,currency,game_currency_id);
         }
         catch(e:Error)
         {
         }
      }
      
      private static function trackPurchase(param1:int, param2:String, param3:int, param4:String, param5:String, param6:int) : void
      {
         var jsonObject:Object = null;
         var amount:int = param1;
         var price:String = param2;
         var paymentType:int = param3;
         var transactionId:String = param4;
         var currency:String = param5;
         var game_currency_id:int = param6;
         var gameId:String = FEDERAL_GAME_ID;
         var adId:String = Config.smUserId;
         var currencyId:int = game_currency_id;
         var created_at:Number = getTimer() / 1000;
         var gameSecretKey:String = GAME_SECRET_KEY;
         var baseString:String = gameId + adId + currencyId + paymentType + transactionId + amount + price + created_at + gameSecretKey;
         var hash:String = MD5.hash(baseString);
         var url:String = FEDERAL_CURRENT_SERVER_TRACK_PURCHASE_URL;
         try
         {
            jsonObject = {
               "game_id":gameId,
               "ad_id":adId,
               "currency_id":currencyId,
               "payment_type":paymentType,
               "transaction_id":transactionId,
               "amount":amount,
               "price":price,
               "price_currency":currency,
               "game_currency_id":game_currency_id,
               "created_at":created_at,
               "hash":hash
            };
            GameState.mInstance.mServer.serverCallServiceWithParameters(ServiceIDs.FEDERAL_PROXY,jsonObject,false);
         }
         catch(e:Error)
         {
         }
      }
      
      private static function checkForNetwork() : Boolean
      {
         return GameState.mInstance.mServer.isConnectionError();
      }
      
      private static function makeConnection(param1:String, param2:Object) : void
      {
         var _loc3_:HTTPService = new HTTPService(param1);
         _loc3_.method = "POST";
         _loc3_.request = param2;
         _loc3_.send();
      }
      
      private static function generateMD5(param1:String) : String
      {
         return "";
      }
   }
}
