package
{
   public class JSONWrapper
   {
       
      
      public function JSONWrapper()
      {
         super();
      }
      
      public static function encode(param1:Object) : String
      {
         return JSON.stringify(param1);
      }
      
      public static function decode(param1:String) : *
      {
         return JSON.parse(param1);
      }
   }
}
