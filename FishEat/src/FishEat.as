package
{
	import com.greensock.plugins.EndArrayPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import local.scenes.World;
	import local.utils.AssetsManager;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	
	[SWF(width="960",height="640",frameRate="60",backgroundColor="0")]
	public class FishEat extends Sprite
	{
		private var _starling:Starling ;
		private var _default:Bitmap ;
		
		public function FishEat()
		{
			super();
			TweenPlugin.activate([EndArrayPlugin]);
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			_default = new AssetsManager.Default() ;
			addChild(_default);
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = true; // not necessary on iOS. Saves a lot of memory!
			
			
			_starling = new Starling( World , stage , null ,  null, "auto", "baseline" );
			_starling.showStats = true ;
			_starling.antiAliasing = 0 ;
			_starling.enableErrorChecking = true ;
			_starling.addEventListener("context3DCreate" , onContextCreated);
		}
		
		private function onContextCreated( e:Event ):void
		{
			AssetsManager.createTextureAtlas("uiTexture");
			AssetsManager.createTextureAtlas("fishTexture");
			
			var font:BitmapFont = new BitmapFont( AssetsManager.createTextureAtlas("uiTexture").getTexture("desyrel") , XML( new AssetsManager.DesyrelFnt() ));
			TextField.registerBitmapFont(font,"desyrel");
			
			removeChild(_default);
			_default.bitmapData.dispose();
			_default=null;
			_starling.start();
		}
	}
}