package map.elements
{
	import bing.iso.IsoObject;
	import bing.res.ResVO;
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenMax;
	
	import comm.GameData;
	import comm.GameSetting;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import map.GameWorld;
	import map.GroundScene;
	import map.cell.BuildingGridLayer;
	
	import models.vos.BuildingVO;
	
	import utils.ResourceUtil;

	/**
	 * 建筑基类 
	 * @author zhouzhanglin
	 */	
	public class BuildingBase extends IsoObject
	{
		protected var _itemLayer:Sprite ; //放skin的容器
		public function get itemLayer():Sprite{ return _itemLayer; }
		
		protected var _gridLayer:BuildingGridLayer; //占用的格子
		public function get gridLayer():BuildingGridLayer{ return _gridLayer; }
		
		protected var _skin:MovieClip ; //皮肤
		protected var _itemLayerMatrix:Matrix=new Matrix(); //用于碰撞检测
		/** 当前建筑的builingVO*/
		public var buildingVO:BuildingVO ;
		/**
		 * 构造函数 
		 * @param buildingVO
		 */		
		public function BuildingBase(buildingVO:BuildingVO )
		{
			super(GameSetting.GRID_SIZE,buildingVO.baseVO.xSpan , buildingVO.baseVO.zSpan);
			this.buildingVO = buildingVO ;
			
			_itemLayer = new Sprite();
			addChild(_itemLayer);
			
			this.addEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
		}
		
		protected function addedToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			loadRes();
		}
		
		/**
		 * 加载资源  
		 */		
		protected function loadRes():void
		{
			ResourceUtil.instance.addEventListener( buildingVO.baseVO.alias , resLoadedHandler );
			var resVO:ResVO = new ResVO( buildingVO.baseVO.alias , buildingVO.baseVO.url);
			ResourceUtil.instance.loadRes( resVO );
		}
		
		/**添加网格*/		
		public function drawGrid():void
		{
			if(!_gridLayer){
				_gridLayer = new BuildingGridLayer(this);
				addChildAt(_gridLayer,0);
			}
			_gridLayer.drawGrid();
		}
		/** 移除网格*/
		public function removeGrid():void
		{
			if(_gridLayer)
			{
				_gridLayer.dispose();
				if(_gridLayer.parent){
					_gridLayer.parent.removeChild(_gridLayer);
				}
				_gridLayer = null ;
			}
		}
		
		protected function resLoadedHandler( e:Event):void
		{
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.alias , resLoadedHandler );
			ContainerUtil.removeChildren(_itemLayer);
			//获取元件
			_skin = ResourceUtil.instance.getInstanceByClassName( buildingVO.baseVO.alias , buildingVO.baseVO.alias ) as MovieClip;
			if(_skin){
				_skin.stop();
				_itemLayer.addChild(_skin);
			}
		}
		
		override public function update():void
		{
			var world:GameWorld = GameWorld.instance ;
			if( ( (~(nodeX-world.mouseNodePoint.x-1))<6 ||  (~(nodeZ-world.mouseNodePoint.y-1))<6 ) &&
				stage && _skin && world.mouseIsMove && world.mouseContainer.numChildren==0)
			{
				if(!GameWorld.instance.mapIsMove &&(GameData.mouseBuilding==null || 
					GameData.mouseBuilding.parent is GroundScene ||
					(GameData.mouseBuilding.parent==this.parent&&
					this.parent.getChildIndex(this)>this.parent.getChildIndex(GameData.mouseBuilding)))&&
					this.hitTestPoint(stage.mouseX,stage.mouseY))
				{
					var bound:Rectangle = _itemLayer.getBounds(_itemLayer);
					_itemLayerMatrix.identity();
					_itemLayerMatrix.translate(-bound.x,-bound.y);
					var bmd:BitmapData = new BitmapData(bound.width,bound.height,true,0xffffff);
					bmd.draw( _itemLayer,_itemLayerMatrix);
					if(bmd.hitTest( GameData.zeroPoint , 255 , new Point(_itemLayer.mouseX-bound.x,_itemLayer.mouseY-bound.y) ) )
					{
						if(GameData.mouseBuilding) GameData.mouseBuilding.selectedStatus(false);
						GameData.mouseBuilding = this ;
					}else{
						selectedStatus(false);
					}
				}else{
					selectedStatus(false);
				}
				
			}
		}
		
		/**
		 * 设置是否显示被选择状态 
		 * @param flag
		 */		
		public function selectedStatus( flag:Boolean ):void
		{
			if(flag ){
				TweenMax.to(_itemLayer, 0, {dropShadowFilter:{color:0xffff00, alpha:1, blurX:2, blurY:2, strength:5}});
			}else{
				_itemLayer.filters=null ;
			}
		}
		
		/**
		 * 主要用于旋转建筑，1为正，-1为旋转180度 
		 * @param value
		 */		
		override public function set scaleX(value:Number):void
		{
			var flag:Boolean = value==1?false:true;
			this.rotateX( flag );
			_itemLayer.scaleX = value ;
			this.buildingVO.scale = value ;
		}
		
		override public function get scaleX():Number
		{
			return _itemLayer.scaleX ;
		}
		
		/**
		 * 卸载该对象 
		 */		
		public function dispose():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.alias , resLoadedHandler );
			_itemLayer = null ;
			removeGrid();
			buildingVO = null ;
			_skin = null ;
			_itemLayerMatrix = null ;
		}
	}
}