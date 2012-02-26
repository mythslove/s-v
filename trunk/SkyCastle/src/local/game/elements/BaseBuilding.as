package local.game.elements
{
	import bing.iso.IsoObject;
	import bing.utils.InteractivePNG;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import local.comm.GameSetting;
	import local.map.cell.BuildingGridLayer;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * 建筑基类 
	 * @author zzhanglin
	 */	
	public class BaseBuilding extends IsoObject
	{
		public var buildingVO:BuildingVO ;
		public var gridLayer:BuildingGridLayer ; //建筑占据的网格层
		public var itemLayer:InteractivePNG ; //皮肤容器层
		public var effectLayer:Sprite ; //特效层
		protected var _skin:Sprite ; //皮肤
		
		public function BaseBuilding( vo :BuildingVO )
		{
			super(GameSetting.GRID_SIZE , vo.baseVO.xSpan , vo.baseVO.zSpan );
			this.buildingVO = vo ;
			mouseEnabled = false ;
			this.addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler , false , 0 , true );
		}
		
		/* 添加到舞台上*/
		protected function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			itemLayer = new InteractivePNG(); //添加皮肤容器层
			itemLayer.mouseChildren = false ;
			addChild(itemLayer);
			effectLayer = new Sprite(); //添加特效层
			effectLayer.mouseChildren = effectLayer.mouseEnabled = false ;
			addChild(effectLayer);
			loadRes(); 
		}
		
		/* 加载资源*/
		protected function loadRes():void
		{
			
		}
		
		/**还原原来的状态  */		
		public function recoverStatus():void
		{
			
		}
		
		/**添加网格*/		
		public function drawGrid():void
		{
			if(!gridLayer){
				gridLayer = new BuildingGridLayer(this);
				addChildAt(gridLayer,0);
			}
			gridLayer.drawGrid();
		}
		/** 移除网格*/
		public function removeGrid():void
		{
			if(gridLayer) {
				gridLayer.dispose();
				if(gridLayer.parent){
					gridLayer.parent.removeChild(gridLayer);
				}
				gridLayer = null ;
			}
		}
		
		/** 释放资源 */
		override public function dispose():void
		{
			super.dispose();
			buildingVO = null ;
			itemLayer.disableInteractivePNG() ;
			itemLayer = null ;
			removeGrid();
			effectLayer = null ;
			_skin = null ;
		}
	}
}