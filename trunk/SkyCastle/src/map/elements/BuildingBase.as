package map.elements
{
	import bing.iso.IsoObject;
	import bing.iso.IsoUtils;
	import bing.iso.Rhombus;
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
	import flash.geom.Vector3D;
	
	import map.GameWorld;
	
	import models.vos.BuildingVO;
	
	import utils.ResourceUtil;
	
	public class BuildingBase extends IsoObject
	{
		protected var _itemLayer:Sprite ;
		protected var _gridLayer:Sprite;
		protected var _skin:MovieClip ;
		protected var _itemLayerMatrix:Matrix=new Matrix();
		
		public var buildingVO:BuildingVO ;
		public function BuildingBase(buildingVO:BuildingVO )
		{
			super(GameSetting.GRID_SIZE,buildingVO.baseVO.xSpan , buildingVO.baseVO.zSpan);
			this.buildingVO = buildingVO ;
			
//			_gridLayer = new Sprite();
//			_gridLayer.visible=false;
//			_gridLayer.cacheAsBitmap = true ;
//			addChild(_gridLayer);
			
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
		
		public function drawGrid():void
		{
//			ContainerUtil.removeChildren(_gridLayer);
//			var points:Vector.<Vector3D> = this.spanPosition ;
//			for each( var point:Vector3D in points)
//			{
//				var rhomebus:Rhombus = new Rhombus( this.size );
//				var p:Vector3D = point.clone();
//				p.x -=this.x;
//				p.z -=this.z ;
//				var screenPos:Point = IsoUtils.isoToScreen(p);
//				rhomebus.x = screenPos.x ;
//				rhomebus.y = screenPos.y ;
//				_gridLayer.addChild( rhomebus );
//			}
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
			super.update() ;
			
			if(stage && _skin && (GameData.mouseBuilding==null || 
				GameData.mouseBuilding.parent==GameWorld.instance.groundScene ||
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
					GameData.mouseBuilding = this ;
				}else{
					selectedStatus(false);
				}
			}else{
				selectedStatus(false);
			}
		}
		
		public function selectedStatus( flag:Boolean ):void
		{
			if(flag ){
				TweenMax.to(_itemLayer, 0, {dropShadowFilter:{color:0xffff00, alpha:1, blurX:2, blurY:2, strength:5}});
			}else{
				_itemLayer.filters=null ;
			}
		}
		
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
		
		public function dispose():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.alias , resLoadedHandler );
			_itemLayer = null ;
			_gridLayer = null ;
			buildingVO = null ;
			_skin = null ;
			_itemLayerMatrix = null ;
		}
	}
}