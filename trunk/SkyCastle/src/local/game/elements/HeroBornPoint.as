package local.game.elements
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import local.enum.ItemType;
	import local.views.effects.BitmapMovieClip;
	import local.model.buildings.vos.BaseDecorationVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.EffectManager;
	import local.utils.ResourceUtil;

	/**
	 * 英雄的出生点 
	 * @author zzhanglin
	 */	
	public class HeroBornPoint extends Decortation
	{
		protected var _bmpMC:BitmapMovieClip;
		
		public function HeroBornPoint()
		{
			var decVO:BaseDecorationVO = new BaseDecorationVO();
			decVO.resId="HeroBornPointAnimation";
			decVO.alias="HeroBornPointAnimation";
			decVO.walkable=1 ;
			decVO.xSpan = 1 ;
			decVO.zSpan = 1 ;
			decVO.layer=2 ;
			decVO.type = ItemType.DECORATION ;
			var vo:BuildingVO = new BuildingVO();
			vo.baseVO = decVO ;
			super(vo);
		}
		
		/* 添加到舞台上*/
		override protected function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			//获取元件
			_skin = ResourceUtil.instance.getInstanceByClassName( "init_effect" , buildingVO.baseVO.alias ) as MovieClip;
			if(_skin){
				_bmpMC = EffectManager.instance.createBmpAnimByMC( _skin );
				itemLayer.y = 20 ;
				itemLayer.addChild(_bmpMC);
				_bmpMC.play();
			}
		}
		
		override public function get title():String{
			return "Sky channel";
		}
		override public function get description():String{
			return "";
		}
		override public function get isCanControl():Boolean{
			return false;
		}
		
		override public function update():void
		{
			if(_bmpMC && _bmpMC.update() ){
				var rect:Rectangle = _bmpMC.getBound();
				_bmpMC.x = rect.x ;
				_bmpMC.y = rect.y;
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