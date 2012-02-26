package local.game.elements
{
	import bing.iso.IsoObject;
	import bing.res.ResVO;
	import bing.utils.ContainerUtil;
	import bing.utils.InteractivePNG;
	
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import local.comm.GameSetting;
	import local.map.cell.BuildingGridLayer;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.ResourceUtil;

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
		protected var _skin:MovieClip ; //皮肤
		
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
			//加载资源
			ResourceUtil.instance.addEventListener( buildingVO.baseVO.alias , resLoadedHandler );
			var resVO:ResVO = new ResVO( buildingVO.baseVO.alias , buildingVO.baseVO.url);
			ResourceUtil.instance.loadRes( resVO );
		}
		
		/* 加载资源完成*/
		protected function resLoadedHandler( e:Event ):void
		{
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.alias , resLoadedHandler );
			ContainerUtil.removeChildren(itemLayer);
			//获取元件
			_skin = ResourceUtil.instance.getInstanceByClassName( buildingVO.baseVO.alias , buildingVO.baseVO.alias ) as MovieClip;
			if(_skin){
				_skin.stop();
				itemLayer.addChild(_skin);
			}
		}
		
		/**主要用于旋转建筑，1为正，-1为旋转180度 */		
		override public function set scaleX(value:Number):void
		{
			var flag:Boolean = value==1?false:true;
			this.rotateX( flag );
			itemLayer.scaleX = value ;
			this.buildingVO.scale = value ;
		}
		
		/** 当前是否旋转过*/
		override public function get scaleX():Number
		{
			return itemLayer.scaleX ;
		}
		
		/**设置是否显示被选择状态  */		
		public function selectedStatus( flag:Boolean ):void
		{
			if(flag ){
				TweenMax.to(itemLayer, 0, {dropShadowFilter:{color:0xffff00, alpha:1, blurX:2, blurY:2, strength:5}});
			}else{
				itemLayer.filters=null ;
			}
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
			if(_skin){
				_skin.stop();
				_skin = null ;
			}
		}
	}
}