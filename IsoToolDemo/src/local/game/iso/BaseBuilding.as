package local.game.iso
{
	import bing.iso.IsoObject;
	import bing.res.ResVO;
	
	import flash.events.Event;
	
	import local.comm.GameSetting;
	import local.game.cell.BuildingObject;
	import local.utils.ResourceUtil;
	import local.vos.BitmapAnimResVO;

	public class BaseBuilding extends IsoObject
	{
		public var buildingObj:BuildingObject ;
		private var _isLoaded:Boolean ;
		
		public function BaseBuilding( name:String )
		{
			var resVO:ResVO = ResourceUtil.instance.getResVOByResId(name);
			var gx:int = 1 ;
			var gz:int = 1;
			if(resVO && resVO.resObject  ){
				gx = resVO.userData.x ; 
				gz = resVO.userData.z ; 
				_isLoaded = true ;
			}
			super( GameSetting.GRID_SIZE , gx , gz );
			this.name = name ;
			mouseEnabled = false ;
			
			init();
		}
		
		protected function init():void
		{
			if(!_isLoaded){
				loadRes();
			}else{
				initLayer();
			}
		}
		
		protected function initLayer():void
		{
			buildingObj = new BuildingObject( ResourceUtil.instance.getResVOByResId(name).resObject as Vector.<BitmapAnimResVO> );
			addChild(buildingObj);
		}
		
		override public function update():void
		{
			super.update();
			if( buildingObj){
				buildingObj.update() ;
			}
		}
		
		public function flash( value:Boolean ):void
		{
			if(buildingObj) buildingObj.flash( value );
		}
		
		protected function loadRes():void
		{
			ResourceUtil.instance.addEventListener( name , resLoadedHandler );
			ResourceUtil.instance.loadRes( new ResVO(name, "houses/"+name+".bd"));
		}
		
		private function resLoadedHandler( e:Event ):void
		{
			ResourceUtil.instance.removeEventListener( name , resLoadedHandler );
			initLayer();
		}
		
		override public function dispose():void
		{
			super.dispose();
			if( buildingObj){
				buildingObj.dispose() ;
				buildingObj = null ;
			}
			ResourceUtil.instance.removeEventListener( name , resLoadedHandler );
		}
	}
}