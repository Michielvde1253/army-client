package game.net
{
   import com.dchoc.charlie.ServerDataListener;
   
   public class ServerCall
   {
       
      
      public var mServiceId:String;
      
      public var mParameters:Object;
      
      public var mObserver:ServerDataListener;
      
      public var mIsBlocking:Boolean;
      
      public var mData:Object;
      
      public function ServerCall(param1:String, param2:Object, param3:ServerDataListener, param4:Boolean)
      {
         super();
         this.mServiceId = param1;
         this.mParameters = param2;
         this.mObserver = param3;
         this.mIsBlocking = param4;
         this.mData = null;
      }
   }
}
