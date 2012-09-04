package local.map.item
{
	import bing.res.ResLoadedEvent;
	import bing.res.ResVO;
	
	import flash.display.Bitmap;
	
	import local.comm.GameSetting;
	import local.util.ResourceUtil;
	import local.vo.BitmapAnimResVO;

	/**
	 * 地图上基础建筑，主要是为了好看用的 
	 * @author zzhanglin
	 */	
	public class BasicBuilding extends BaseMapObject
	{
		private var _bavos:Vector.<BitmapAnimResVO> ;
		
		public function BasicBuilding( name:String , xSpan:int=1, zSpan:int=1)
		{
			super( GameSetting.GRID_SIZE , xSpan, zSpan);
			this.name = name ;
			mouseChildren = mouseEnabled = false ;
		}
		
		override public function showUI():void
		{
			if(ResourceUtil.instance.checkResLoaded(name)){
				_bavos = ResourceUtil.instance.getResVOByResId(name).resObject as Vector.<BitmapAnimResVO> ;
				changeUI();
			}else{
				ResourceUtil.instance.addEventListener( name , resLoadedHandler );
				ResourceUtil.instance.loadRes( new ResVO( name , "basic/"+name+".bd"));
			}
		}
		
		private function resLoadedHandler( e:ResLoadedEvent ):void
		{
			ResourceUtil.instance.removeEventListener( name , resLoadedHandler );
			_bavos = ResourceUtil.instance.getResVOByResId(name).resObject as Vector.<BitmapAnimResVO> ;
			changeUI();
		}
		
		private function changeUI():void
		{
			if(_bavos){
				var bmp:Bitmap = new Bitmap( _bavos[0].bmds[0] );
				bmp.x =  _bavos[0].offsetX ;
				bmp.y =  _bavos[0].offsetY ;
				addChild(bmp);
			}
		}
		
		override public function dispose():void
		{
			super.dispose() ;
			_bavos = null ;
		}
	}
}