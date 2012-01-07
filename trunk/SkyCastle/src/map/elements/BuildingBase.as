package map.elements
{
	import bing.animation.ActionVO;
	import bing.animation.AnimationBitmap;
	import bing.iso.IsoObject;
	import bing.iso.IsoUtils;
	import bing.iso.Rhombus;
	import bing.res.ResVO;
	import bing.utils.ContainerUtil;
	
	import comm.GameSetting;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import map.GameWorld;
	
	import models.vos.BuildingVO;
	
	import utils.ResourceUtil;
	
	public class BuildingBase extends IsoObject
	{
		protected var _itemLayer:Sprite ;
		protected var _gridLayer:Sprite;
		protected var _skin:Bitmap;
		protected var _animation:AnimationBitmap;
		
		public var buildingVO:BuildingVO ;
		public function BuildingBase(buildingVO:BuildingVO )
		{
			super(GameSetting.GRID_SIZE,buildingVO.baseVO.xSpan , buildingVO.baseVO.zSpan);
			this.buildingVO = buildingVO ;
			
			_gridLayer = new Sprite();
			_gridLayer.visible=false;
			_gridLayer.cacheAsBitmap = true ;
			addChild(_gridLayer);
			
			_itemLayer = new Sprite();
			addChild(_itemLayer);
			
			this.addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		protected function addedHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			
			ResourceUtil.instance.addEventListener( buildingVO.baseVO.alias , resLoadedHandler );
			var resVO:ResVO = new ResVO( buildingVO.baseVO.alias , buildingVO.baseVO.url);
			if(buildingVO.baseVO.frames>0){
				resVO.frames = buildingVO.baseVO.frames ;
				resVO.row = buildingVO.baseVO.row ;
				resVO.col = buildingVO.baseVO.col ;
			}
			ResourceUtil.instance.loadRes( resVO );
		}
		
		public function drawGrid():void
		{
			ContainerUtil.removeChildren(_gridLayer);
			var points:Vector.<Vector3D> = this.spanPosition ;
			for each( var point:Vector3D in points)
			{
				var rhomebus:Rhombus = new Rhombus( this.size );
				var p:Vector3D = point.clone();
				p.x -=this.x;
				p.z -=this.z ;
				var screenPos:Point = IsoUtils.isoToScreen(p);
				rhomebus.x = screenPos.x ;
				rhomebus.y = screenPos.y ;
				_gridLayer.addChild( rhomebus );
			}
		}
		
		protected function resLoadedHandler( e:Event):void
		{
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.alias , resLoadedHandler );
			ContainerUtil.removeChildren(_itemLayer);
			var resVO:ResVO = ResourceUtil.instance.getResVOByName(buildingVO.baseVO.alias);
			if(buildingVO.baseVO.frames>1) {
				_skin = new Bitmap();
				_animation = new AnimationBitmap( resVO.resObject as Vector.<BitmapData>, Vector.<ActionVO>([new ActionVO("effect",buildingVO.baseVO.frames)]) ,1 )
				_animation.playAction("effect");
				_skin.bitmapData = _skin.bitmapData;
			} else {
				_skin = new Bitmap( resVO.resObject as BitmapData );
			}
			_skin.x = buildingVO.baseVO.offsetX;
			_skin.y = buildingVO.baseVO.offsetY;
			_itemLayer.addChild(_skin);
		}
		
		
		override public function update():void
		{
			super.update() ;
			if(_animation){ //播放动画
				_animation.playAction("effect");
				_skin.bitmapData =  _animation.animationBmd ;
			}
			if(stage && _skin && (GameWorld.instance.mouseBuilding==null || 
				GameWorld.instance.mouseBuilding.parent==GameWorld.instance.groundScene ||
					(GameWorld.instance.mouseBuilding.parent==this.parent&&
						this.parent.getChildIndex(this)>this.parent.getChildIndex(GameWorld.instance.mouseBuilding))) )
			{
				var curr:DisplayObjectContainer = this.parent ;
				var stage_x:Number = this.screenX;
				var stage_y:Number = this.screenY ;
				while(curr){
					stage_x+=curr.x ;
					stage_y+=curr.y ;
					curr = curr.parent ;
				}
				if( stage_x>-100 && stage_x<stage.stageWidth+100
					&& stage_y>-_skin.height 
					&& stage_y<stage.stageHeight+_skin.height)
				{
					if(_skin.bitmapData  && _skin.bitmapData.hitTest( new Point(_skin.x,_skin.y),255,new Point(this.mouseX,this.mouseY) ) )
					{
						GameWorld.instance.mouseBuilding = this ;
					}else{
						selectedStatus(false);
					}
				}
			}else{
				selectedStatus(false);
			}
		}
		
		public function selectedStatus( flag:Boolean ):void
		{
			if(flag ){
				_gridLayer.visible=true;
			}else{
				_gridLayer.visible=false;
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
			this.removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.alias , resLoadedHandler );
			_itemLayer = null ;
			_gridLayer = null ;
			buildingVO = null ;
			_skin = null ;
			if(_animation){
				_animation.dispose();
				_animation = null ;
			}
		}
	}
}