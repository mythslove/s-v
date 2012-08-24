package local.game.layer
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	
	import flash.utils.setTimeout;
	
	import local.comm.GameData;
	import local.comm.GlobalDispatcher;
	import local.comm.GlobalEventType;
	import local.game.base.BaseFish;
	import local.game.fish.*;
	import local.utils.AssetsManager;
	import local.utils.FishPool;
	import local.utils.SoundManager;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * 游戏中的UI界面 
	 * @author zhouzhanglin
	 */	
	public class UILayer extends Sprite
	{
		private var info:TextField ;
		private var whiteBg:Image ;
		private var yellowBg:Image ;
		
		public function UILayer()
		{
			super();
			touchable=false;
			info = new TextField(800,100, "" , "desyrel" , 40 , 0xffffff );
			info.hAlign= HAlign.LEFT;
			info.vAlign = VAlign.TOP ;
			info.x = 20 ;
			
			whiteBg = new Image( AssetsManager.createTextureAtlas("uiTexture").getTexture("whitebg") );
			whiteBg.x = 560 ;
			whiteBg.y = 25 ;
			yellowBg = new Image( AssetsManager.createTextureAtlas("uiTexture").getTexture("yellowbg") );
			yellowBg.x = 560 ;
			yellowBg.y = 25 ;
		}
		
		public function init():void
		{
			removeAll();
			info.text="Level:"+(GameData.currentLv.level+1)+"     life:3"+"     score:0";
			addChild(info);
			
			yellowBg.scaleX = 0.001;
			addChild(whiteBg);
			addChild(yellowBg);
		}
		
		public function showInfo( lv:int, life:int , score:int ):void
		{
			info.text="Level:"+lv+"     life:"+life+"     score:"+score;
			var sc:Number = score/GameData.currentLv.requireScore ;
			sc = sc>1? 1 : sc ;
			yellowBg.scaleX = sc ; 
		}
		
		public function showComplete( nf1:int ,nf2:int ,nf3:int ,nf4:int , score:int ):void
		{
			SoundManager.playSoundLevelCom();
			var f1:BaseFish = FishPool.getFish(Fish1);
			f1.y = 320 ;
			f1.x=100 ;
			addChild(f1);
			Starling.juggler.add(f1);
			TweenLite.from( f1 , 1 , {scaleX:0,scaleY:0 , ease:Bounce.easeOut  } );
			
			var f2:BaseFish = FishPool.getFish(Fish2);
			f2.y = 320 ;
			f2.x=300 ;
			addChild(f2);
			Starling.juggler.add(f2);
			TweenLite.from( f2 , 1 , {scaleX:0,scaleY:0 , ease:Bounce.easeOut  } );
			
			var f3:BaseFish = FishPool.getFish(Fish3);
			f3.y = 320 ;
			f3.x=500 ;
			addChild(f3);
			Starling.juggler.add(f3);
			TweenLite.from( f3 , 1 , {scaleX:0,scaleY:0 , ease:Bounce.easeOut  } );
			
			var f4:BaseFish = FishPool.getFish(Fish4);
			f4.y = 300 ;
			f4.x=700 ;
			addChild(f4);
			Starling.juggler.add(f4);
			TweenLite.from( f4 , 1 , {scaleX:0,scaleY:0 , ease:Bounce.easeOut  } );
			
			var yy:Number =  f1.texture.height*0.8+f1.y;
			var tf:TextField = new TextField(100,100, nf1+"" , "desyrel" , 40 , 0xffcc00 );
			tf.x = f1.x-50 ;
			tf.y = yy ;
			addChild(tf);
			tf = new TextField(100,100, nf2+"" , "desyrel" , 40 , 0xffcc00 );
			tf.x = f2.x-50 ;
			tf.y = yy ;
			addChild(tf);
			tf = new TextField(100,100, nf3+"" , "desyrel" , 40 , 0xffcc00 );
			tf.x = f3.x-50 ;
			tf.y = yy ;
			addChild(tf);
			tf = new TextField(100,100, nf4+"" , "desyrel" , 40 , 0xffcc00 );
			tf.x = f4.x-50 ;
			tf.y = yy ;
			addChild(tf);
			
			tf = new TextField(200,100, "" , "desyrel" , 60 , 0xff0000 , true );
			tf.x = 10;
			tf.y = 150;
			addChild(tf);
			
			var myArray:Array=[0];
			function onUpdate():void{
				tf.text = ""+ (myArray[0]>>0) ;
			}
			function onComplete():void{
				tf.text = ""+ (myArray[0]>>0) ;
				SoundManager.playSoundTweenCom();
				setTimeout( goon , 3000 );			
			}
			TweenLite.to(myArray, 2 , {endArray:[score],onUpdate:onUpdate,onComplete:onComplete});
			
			
			var lvcom:Image = new Image( AssetsManager.createTextureAtlas("uiTexture").getTexture("com"));
			lvcom.pivotX=lvcom.texture.width>>1 ;
			lvcom.pivotY=lvcom.texture.height>>1 ;
			lvcom.x = 960>>1;
			lvcom.y = 200 ;
			lvcom.scaleX=lvcom.scaleY=0;
			addChild(lvcom);
			TweenLite.to( lvcom , 0.75 , {scaleX:1,scaleY:1 , ease:Back.easeOut });
		}
		
		private function goon():void{
			GlobalDispatcher.instance.dispatchEventWith( GlobalEventType.LEVEL_PASSED ); 
		}
		
		public function showOver():void
		{
			var over:Image = new Image( AssetsManager.createTextureAtlas("uiTexture").getTexture("over"));
			over.pivotX=over.texture.width>>1 ;
			over.pivotY=over.texture.height>>1 ;
			over.x = 960>>1;
			over.y = 600>>1 ;
			over.scaleX=over.scaleY=0;
			addChild(over);
			TweenLite.to( over , 0.75 , {scaleX:1,scaleY:1 , ease:Back.easeOut , onComplete: overCom});
			function overCom():void{
				setTimeout(overFun,2000);
			}
		}
		
		private function overFun():void{
			GlobalDispatcher.instance.dispatchEventWith( GlobalEventType.HERO_DEAD );	 //抛出英雄死亡的事件
		}
		
		
		private function removeAll():void
		{
			var obj:DisplayObject ;
			while(numChildren>0){
				obj = this.removeChildAt(0);
				if(obj is IAnimatable){
					Starling.juggler.remove( obj as IAnimatable ) ;
				}
			}
		}
	}
}