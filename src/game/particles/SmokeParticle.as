package game.particles
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class SmokeParticle
   {
       
      
      public var xVel:Number;
      
      public var yVel:Number;
      
      public var drag:Number = 1;
      
      public var fade:Number = 1;
      
      public var shrink:Number = 1;
      
      public var gravity:Number = 0;
      
      public var directionRotate:Boolean = false;
      
      public var clip:Sprite;
      
      public function SmokeParticle(param1:Class, param2:DisplayObjectContainer, param3:Number, param4:Number, param5:Boolean = false)
      {
         super();
         this.clip = new param1();
         if(param5)
         {
            param2.addChildAt(this.clip,0);
         }
         else
         {
            param2.addChild(this.clip);
         }
         this.clip.x = param3;
         this.clip.y = param4;
         this.clip.rotation = Math.random() * 360;
      }
      
      public function setVel(param1:Number, param2:Number) : void
      {
         this.xVel = param1;
         this.yVel = param2;
      }
      
      public function setScale(param1:Number) : void
      {
         this.clip.scaleX = param1;
         this.clip.scaleY = param1;
      }
      
      public function update() : void
      {
         this.clip.alpha = this.clip.alpha * 1000 * this.fade / 1000;
         this.clip.x += this.xVel;
         this.clip.y += this.yVel;
         this.xVel *= this.drag;
         this.yVel *= this.drag;
         this.clip.scaleX = this.clip.scaleY = this.clip.scaleY * this.shrink;
         this.yVel += this.gravity;
         if(this.directionRotate)
         {
            this.updateRotation();
         }
      }
      
      public function updateRotation() : void
      {
         this.clip.rotation = Math.atan2(this.yVel,this.xVel) * (180 / Math.PI);
      }
      
      public function destroy() : void
      {
         this.clip.parent.removeChild(this.clip);
         this.clip = null;
      }
   }
}
