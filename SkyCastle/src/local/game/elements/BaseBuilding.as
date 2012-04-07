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
	import flash.geom.Vector3D;
	
	import local.comm.GameSetting;
	import local.game.GameWorld;
	import local.game.cell.BuildingGridLayer;
	import local.model.MapGridDataModel;
	import local.model.buildings.vos.BaseBuildingVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.ResourceUtil;
	import local.views.loading.BuildingStepLoading;

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
		public var offsetY:Number ;//可用偏移Y
		public var selected:Boolean ; //当前是否选中
		protected var _skin:MovieClip ; //皮肤
		private var _stepLoading:BuildingStepLoading;
		
		public function BaseBuilding( vo :BuildingVO )
		{
			super(GameSetting.GRID_SIZE , vo.baseVO.xSpan , vo.baseVO.zSpan );
			this.buildingVO = vo ;
			mouseEnabled = false ;
			offsetY = Math.floor((buildingVO.baseVO.xSpan+buildingVO.baseVO.zSpan)*0.5-1)*GameSetting.GRID_SIZE ;
			
			itemLayer = new InteractivePNG(); //添加皮肤容器层
			itemLayer.mouseChildren = false ;
			itemLayer.scaleX = vo.scale ;
			this._isRotate = (vo.scale==-1) ;
			addChild(itemLayer);
			effectLayer = new Sprite(); //添加特效层
			effectLayer.mouseChildren = effectLayer.mouseEnabled = false ;
			addChild(effectLayer);
			
			this.addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler , false , 0 , true );
		}
		
		/** 获取此建筑的基础VO */
		public function get baseBuildingVO():BaseBuildingVO{
			return buildingVO.baseVO ;
		}
		
		/** 获取此建筑的标题 */
		public function get title():String 
		{
			return buildingVO.baseVO.name;
		}
		
		/** 获取此建筑的描述 */
		public function get description():String 
		{
			return buildingVO.baseVO.description;
		}
		
		/* 添加到舞台上*/
		protected function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			//加载资源
			loadRes();
		}
		
		/* 加载资源 */
		protected function loadRes():void
		{
			ResourceUtil.instance.addEventListener( buildingVO.baseVO.resId , resLoadedHandler );
			var resVO:ResVO = new ResVO( buildingVO.baseVO.resId , buildingVO.baseVO.url);
			ResourceUtil.instance.loadRes( resVO );
		}
		
		/* 加载资源完成*/
		protected function resLoadedHandler( e:Event ):void
		{
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.resId , resLoadedHandler );
			ContainerUtil.removeChildren(itemLayer);
			//获取元件
			_skin = ResourceUtil.instance.getInstanceByClassName( buildingVO.baseVO.resId , buildingVO.baseVO.alias ) as MovieClip;
			if(_skin){
				_skin.gotoAndStop( buildingVO.step );
				itemLayer.addChild(_skin);
			}
		}
		
		/** 显示步数*/
		public function showStep( value:Number , sum:Number  ):void
		{
			stepLoading.scaleX = stepLoading.scaleY = 1/GameWorld.instance.scaleX ;
			effectLayer.addChild(stepLoading);
			stepLoading.y = -itemLayer.height;
			stepLoading.setValue(value ,sum);
		}
		
		/** 步数loading */
		public function get stepLoading():BuildingStepLoading
		{
			if(!_stepLoading) _stepLoading=new BuildingStepLoading();
			return _stepLoading;
		}
		
		public function get enable():Boolean{
			return itemLayer.mouseEnabled ;
		}
		
		public function set enable( value:Boolean ):void{
			itemLayer.enabled = value ;
			if(value){
				itemLayer.alpha = 1 ;
				if(stepLoading&&stepLoading.parent){
					stepLoading.parent.removeChild(stepLoading);
				}
			}else{
				itemLayer.alpha = .6 ;
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
		
		override public function set nodeX(value:int):void
		{
			super.nodeX = value ;
			buildingVO.nodeX = value ;
		}
		
		override public function set nodeZ(value:int):void
		{
			super.nodeZ = value ;
			buildingVO.nodeZ = value ;
		}
		
		/**设置是否显示被选择状态  */		
		public function selectedStatus( flag:Boolean ):void
		{
			selected = flag ;
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
		
		/** 环绕的可用的点 ,返回Vector3D数组*/
		public function getRoundAblePoint():Array
		{
			var arr:Array = [];
			var pos:Vector3D;
			var nz:int ;
			var nx:int ;
			if(_isRotate) {
				for( i = -1 ;  i<=_zSpan ; i++) {
					for( j = -1 ; j<=_xSpan ; j++) {
						if( i==-1|| j==-1 || i==_zSpan || j==_xSpan) {
							pos = new Vector3D( i*_size+this.x , this.y , j*_size+this.z );
							nx = pos.x/_size ;
							nz = pos.z/_size ;
							if(nx<=GameSetting.GRID_X &&  nz<=GameSetting.GRID_Z && nx>=0 && nz>=0 &&
								MapGridDataModel.instance.astarGrid.getNode(nx,nz).walkable)
								arr.push( pos );
						}
					}
				}
			} else {
				for( var i:int = -1 ;  i<=_xSpan ; ++i){
					for( var j:int = -1 ; j<=_zSpan ; ++j) {
						if( i==-1|| j==-1 || i==_xSpan || j==_zSpan) {
							pos = new Vector3D( i*_size+this.x , this.y , j*_size+this.z );
							nx = pos.x/_size ;
							nz = pos.z/_size ;
							if(nx<=GameSetting.GRID_X &&  nz<=GameSetting.GRID_Z && nx>=0 && nz>=0 &&
								MapGridDataModel.instance.astarGrid.getNode(nx,nz).walkable)
								arr.push( pos );
						}
					}
				}
			}
			return arr;
		}
		
		/** 释放资源 */
		override public function dispose():void
		{
			super.dispose();
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.resId , resLoadedHandler );
			buildingVO = null ;
			itemLayer.disableInteractivePNG() ;
			itemLayer = null ;
			removeGrid();
			effectLayer = null ;
			if(_skin){
				_skin.stop();
				_skin = null ;
			}
			_stepLoading = null ;
		}
	}
}