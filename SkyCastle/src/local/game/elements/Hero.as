package local.game.elements
{
	import bing.utils.ContainerUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import local.enum.AvatarAction;
	import local.game.cell.BitmapMovieClip;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.ResourceUtil;
	
	public class Hero extends Character
	{
		protected var _bmpMC:BitmapMovieClip;
		protected var _currentActions:String ;
		
		public function Hero(vo:BuildingVO)
		{
			super(vo);
		}
		
		/* 加载资源完成*/
		override protected function resLoadedHandler( e:Event ):void
		{
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.alias , resLoadedHandler );
			ContainerUtil.removeChildren(itemLayer);
			//获取元件
			_skin = ResourceUtil.instance.getInstanceByClassName( buildingVO.baseVO.alias , buildingVO.baseVO.alias ) as MovieClip;
			if(_skin){
				_bmpMC = new BitmapMovieClip(_skin);
				itemLayer.addChild(_bmpMC);
				gotoAndPlay( AvatarAction.IDLE );
			}
		}
		
		public function gotoAndPlay( action:String ):void
		{
			if(_skin){
				_currentActions = action ;
				_skin.gotoAndPlay( action);
			}
		}
		
		override public function update():void
		{
			if(_bmpMC){
				if(_skin.currentFrameLabel && _skin.currentFrameLabel!=_currentActions){
					_skin.gotoAndPlay( _currentActions);
				}
				_bmpMC.update();
				var rect:Rectangle = _bmpMC.getBound();
				_bmpMC.x = rect.x ;
				_bmpMC.y = rect.y ;
			}
		}
		
		override public function dispose():void
		{
			if(_bmpMC){
				_bmpMC.dispose();
				_bmpMC = null ;
			}
			super.dispose();
		}
	}
}