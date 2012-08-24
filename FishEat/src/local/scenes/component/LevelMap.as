package local.scenes.component
{
	import local.comm.GameData;
	import local.utils.AssetsManager;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * 关卡地图 
	 * @author zhouzhanglin
	 */	
	public class LevelMap extends Sprite
	{
		public var levels:Array=[
			[76,396],[100,347],[132,297],[169,241],[214,200],[270,175],[335,162],[400,186],[443,235],[487,280],
			[534,323],[597,359],[660,383],[740,390],[783,436],[816,485],[854,540]
		];
		private var _xs:Vector.<Image> ;
		private var _ps:Vector.<Image> ;
		private var _flag:MovieClip ;
		
		public function LevelMap()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , added );
			addEventListener(Event.REMOVED_FROM_STAGE , removed );
			
			var len:int = levels.length ;
			_xs= new Vector.<Image>( len ,true );
			_ps=new Vector.<Image>( len ,true );
			var img:Image;
			for( var i:int = 0 ; i<len ;++i ){
				img = new Image( AssetsManager.createTextureAtlas("uiTexture").getTexture("LevelPoint")  );
				img.pivotX = img.texture.width>>1 ;
				img.pivotY = img.texture.height>>1 ;
				img.x = levels[i][0] ;
				img.y = levels[i][1] ;
				_ps[i] = img ;
				img = new Image( AssetsManager.createTextureAtlas("uiTexture").getTexture("LevelComplete_000")  );
				img.pivotX = img.texture.width>>1 ;
				img.pivotY = img.texture.height>>1 ;
				img.x = levels[i][0] ;
				img.y = levels[i][1] ;
				_xs[i] = img;
			}
			_flag = new MovieClip( AssetsManager.createTextureAtlas("uiTexture").getTextures("LevelFlag_")  );
			_flag.pivotX = 2;
			_flag.pivotY = _flag.texture.height-2  ;
		}
		
		private function added( e:Event ):void
		{
			var lv:int = GameData.currentLv.level ;
			var len:int = levels.length ;
			for( var i:int = 0 ; i<len ;++i ){
				if(i<lv){
					addChild( _xs[i] );
				}else if(i==lv){
					_flag.x = levels[i][0] ;
					_flag.y = levels[i][1] ;
				}
				else
				{
					addChild( _ps[i] );
				}
			}
			addChild(_flag);
			Starling.juggler.add( _flag );
		}
		
		private function removed( e:Event ):void
		{
			var obj:DisplayObject ;
			while(numChildren>0){
				this.removeChildAt(0);
			}
			Starling.juggler.remove( _flag );
		}
	}
}