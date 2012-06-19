package
{
	import app.comm.Setting;
	import app.core.GameScene;
	import app.util.PopUpManager;
	
	import bing.res.ResLoadedEvent;
	import bing.res.ResPool;
	import bing.res.ResVO;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	import flash.system.Capabilities;
	
	public class Coloring extends Sprite
	{
		public function Coloring()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			
			//界面大小
			if(Capabilities.screenResolutionX>=1024){
				Setting.SCREEN_WID = 1024 ;
				Setting.SCREEN_HET = 768 ;
				if(Capabilities.screenResolutionX==2048){
					this.scaleX = this.scaleY = 2 ;
				}
				stage.frameRate = 30 ;
			}else if(Capabilities.screenResolutionX<=960){
				Setting.SCREEN_WID = 960 ;
				Setting.SCREEN_HET = 640 ;
				if(Capabilities.screenResolutionX==480){
					this.scaleX = this.scaleY = 0.5 ;
				}
				stage.frameRate = 24 ;
			}
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING , onOrientaionChange);
			
			addChild(PopUpManager.instance);
			initLoad();
		}
		
		private function onOrientaionChange( e:StageOrientationEvent):void
		{
			if(e.afterOrientation == StageOrientation.DEFAULT || e.afterOrientation == StageOrientation.UPSIDE_DOWN)
			{
				e.preventDefault() ;
			}
		}
		
		
		/** 加载资源和皮肤*/
		private function initLoad():void
		{
			var res:Vector.<ResVO> = new Vector.<ResVO>();
			res.push( new ResVO("skin","res/skin/960_640/Skin_960_640.swf"));
			ResPool.instance.isRemote = false ;
			ResPool.instance.addEventListener(ResLoadedEvent.QUEUE_LOADED ,queueLoadHandler);
			ResPool.instance.queueLoad( res , 5 );
		}
		
		/**
		 * 序列下载资源完成 
		 * @param e
		 */		
		protected function queueLoadHandler( e:Event):void
		{
			ResPool.instance.removeEventListener(ResLoadedEvent.QUEUE_LOADED ,queueLoadHandler);
			addChild( new GameScene("AnimalPack"));
		}
		
	}
}