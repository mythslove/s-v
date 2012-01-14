package map.elements
{
	import bing.iso.IsoObject;
	import bing.res.ResVO;
	import bing.utils.ContainerUtil;
	import bing.utils.InteractivePNG;
	
	import com.greensock.TweenMax;
	
	import comm.GameSetting;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import map.cell.BuildingGridLayer;
	
	import models.vos.BuildingVO;
	
	import utils.ResourceUtil;

	/**
	 * 建筑基类 
	 * @author zhouzhanglin
	 */	
	public class BuildingBase extends IsoObject
	{
		protected var _skin:MovieClip ; //皮肤
		
		public var gridLayer:BuildingGridLayer; //占用的格子
		public var itemLayer:InteractivePNG ; //放skin的容器
		public var buildingVO:BuildingVO ; //此建筑的信息
		
		/**
		 * 构造函数 
		 * @param buildingVO
		 */		
		public function BuildingBase(buildingVO:BuildingVO )
		{
			super(GameSetting.GRID_SIZE,buildingVO.baseVO.xSpan , buildingVO.baseVO.zSpan);
			this.buildingVO = buildingVO ;
			this.mouseEnabled  = false ;
			if(!buildingVO.baseVO.animClsName) {//没有动画
				this.cacheAsBitmap = true ;	
			}
			
			itemLayer = new InteractivePNG();
			itemLayer.mouseChildren = false ;
			addChild(itemLayer);
			
			this.addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
		}
		
		/** 添加到舞台上 */
		protected function addedToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			loadRes();
		}
		
		/** 加载资源   */		
		protected function loadRes():void
		{
			ResourceUtil.instance.addEventListener( buildingVO.baseVO.resId , resLoadedHandler );
			var resVO:ResVO = new ResVO( buildingVO.baseVO.resId , buildingVO.baseVO.url);
			ResourceUtil.instance.loadRes( resVO );
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
			if(gridLayer)
			{
				gridLayer.dispose();
				if(gridLayer.parent){
					gridLayer.parent.removeChild(gridLayer);
				}
				gridLayer = null ;
			}
		}
		
		/** 资源加载完成 */
		protected function resLoadedHandler( e:Event):void
		{
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.resId , resLoadedHandler );
			ContainerUtil.removeChildren(itemLayer);
			//获取元件
			_skin = ResourceUtil.instance.getInstanceByClassName( buildingVO.baseVO.resId , buildingVO.baseVO.clsName ) as MovieClip;
			if(_skin){
				_skin.stop();
				itemLayer.addChild(_skin);
			}
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
		
		/**  卸载该对象  */		
		override public function dispose():void
		{
			super.dispose();
			this.removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.resId , resLoadedHandler );
			itemLayer.disableInteractivePNG();
			itemLayer = null ;
			removeGrid();
			buildingVO = null ;
			_skin = null ;
		}
	}
}