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
	import local.enum.ItemType;
	import local.enum.MouseStatus;
	import local.game.GameWorld;
	import local.game.cell.BuildingGridLayer;
	import local.model.MapGridDataModel;
	import local.model.buildings.vos.BaseBuildingVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.EffectManager;
	import local.utils.MouseManager;
	import local.utils.ResourceUtil;
	import local.views.effects.BaseMovieClipEffect;
	import local.views.effects.BuildCompleteEffect;
	import local.views.effects.BuildEffect;
	import local.views.effects.BuildStatus;
	import local.views.effects.EffectPlacementBuilding;
	import local.views.effects.EffectPlacementDecoration;
	import local.views.effects.RemoveBuildEffect;
	import local.views.loading.BaseStepLoading;
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
		public var fixedOffsetY:Number ; //固定的偏移值
		public var selected:Boolean ; //当前是否选中
		protected var _skin:MovieClip ; //皮肤
		protected var _stepLoading:BaseStepLoading;
		
		public function BaseBuilding( vo :BuildingVO )
		{
			super(GameSetting.GRID_SIZE , vo.baseVO.xSpan , vo.baseVO.zSpan );
			this.buildingVO = vo ;
			mouseEnabled = false ;
			fixedOffsetY = Math.floor((buildingVO.baseVO.xSpan+buildingVO.baseVO.zSpan)*0.5-1)*GameSetting.GRID_SIZE ;
			offsetY = fixedOffsetY ;
			
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
		
		//===========mouseEvent==============
		public function onClick():void
		{
			//判断当前建筑的状态，如果是收获，则执行收获；如果是修建，则执行修建。
		}
		
		public function onMouseOver():void
		{
			selectedStatus( true );
		}
		
		public function onMouseOut():void
		{
			if(itemLayer)
			{
				selectedStatus( false );
				if(!MouseManager.instance.checkControl()){
					MouseManager.instance.mouseStatus = MouseStatus.NONE;
				}
				if(itemLayer.alpha==1 && stepLoading&&stepLoading.parent){
					stepLoading.parent.removeChild(stepLoading);
				}
			}
		}
		//===========mouseEvent==============
		
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
			//显示建筑图片
			showSkin();
		}
		
		/* 显示建筑 */
		protected function showSkin():void
		{
			ResourceUtil.instance.removeEventListener( buildingVO.baseVO.resId , resLoadedHandler );
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
				_skin.gotoAndStop( buildingVO.currentStep+1 );
				itemLayer.addChild(_skin);
				itemLayer.drawBitmapHitArea();
				offsetY = _skin.getBounds(_skin).y-GameSetting.GRID_SIZE ;
			}
		}
		
		/** 显示步数*/
		public function showStep( value:Number , sum:Number  ):void
		{
			stepLoading.scaleX = stepLoading.scaleY = 1/GameWorld.instance.scaleX ;
			effectLayer.addChild(stepLoading);
			stepLoading.y = offsetY ;
			stepLoading.setValue(value ,sum);
		}
		
		/** 步数loading */
		public function get stepLoading():BaseStepLoading
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
			stepLoading.alpha=itemLayer.alpha ;
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
		/** 是否可以移动，旋转，收藏，卖*/
		public function get isCanControl():Boolean{
			return true ;
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
		{ }
		
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
			var minx:int = nodeX-1;
			var minz:int = nodeZ-1;
			var mX:int = nodeX+_xSpan ;
			var mZ:int = nodeZ+_zSpan ;
			
			if(_isRotate) {
				for( i = minz ;  i<=mZ ; i++) {
					for( j = minx ; j<=mX ; j++) {
						if( i==minz|| j==minx || i==mZ || j==mX) {
							if(i<GameSetting.GRID_X &&  j<GameSetting.GRID_Z && i>=0 && j>=0 &&
								MapGridDataModel.instance.astarGrid.getNode(i,j).walkable)
								arr.push( new Vector3D( i*_size , this.y , j*_size ) );
						}
					}
				}
			} else {
				for( var i:int = minx ;  i<=mX ; ++i){
					for( var j:int = minz ; j<=mZ ; ++j) {
						if( i==minx|| j==minz || i==mX || j==mZ) {
							if(i<GameSetting.GRID_X &&  j<GameSetting.GRID_Z && i>=0 && j>=0 &&
								MapGridDataModel.instance.astarGrid.getNode(i,j).walkable)
								arr.push( new Vector3D( i*_size , this.y , j*_size ) );
						}
					}
				}
			}
			return arr;
		}
		
		
		
		
		//============建筑特效＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
		/*清除建筑的特效*/
		protected function clearEffect():void{
			ContainerUtil.removeChildren(effectLayer);
		}
		
		/* 播放放置的动画*/
		protected function showPlaceEffect():void
		{
			var placementMC:MovieClip;
			var type:String = ItemType.getSumType( baseBuildingVO.type );
			if(type==ItemType.BUILDING){
				placementMC= new  EffectPlacementBuilding ();
			}else if(type==ItemType.DECORATION){
				placementMC= new  EffectPlacementDecoration ();
			}
			if(placementMC){
				var placementEffect:BaseMovieClipEffect = EffectManager.instance.createMapEffectByMC(placementMC);
				placementEffect.y = fixedOffsetY+this.screenY ;
				placementEffect.x = this.screenX;
				GameWorld.instance.effectScene.addChild(placementEffect);
			}
		}
		/*显示建造时的动画*/
		protected function showBuildEffect():void
		{
			clearEffect();
			var buildEffectMC:MovieClip = new BuildEffect();
			if(buildEffectMC){
				var buildEffectEffect:BaseMovieClipEffect = EffectManager.instance.createMapEffectByMC(buildEffectMC,0);
				buildEffectEffect.y = fixedOffsetY ;
				effectLayer.addChild(buildEffectEffect);
			}
		}
		/*显示建造的步骤状态图片*/
		protected function showBuildStatus():void
		{
			ContainerUtil.removeChildren(itemLayer);
			_skin = new BuildStatus();
			_skin.gotoAndStop(baseBuildingVO.xSpan+"_"+baseBuildingVO.zSpan) ;
			itemLayer.addChild(_skin);
			itemLayer.drawBitmapHitArea();
		}
		
		/*显示收藏时的特效*/
		protected function showStashEffect():void
		{
			clearEffect();
			var removeEffectMC:MovieClip = new RemoveBuildEffect() ;
			if(removeEffectMC){
				var removeEffectEffect:BaseMovieClipEffect = EffectManager.instance.createMapEffectByMC(removeEffectMC);
				removeEffectEffect.y = fixedOffsetY+this.screenY ;
				removeEffectEffect.x = this.screenX;
				GameWorld.instance.effectScene.addChild(removeEffectEffect);
			}
		}
		
		/*显示建筑完成时的特效*/
		protected function showBuildCompleteEffect():void
		{
			clearEffect();
			var buildComMC:MovieClip = new BuildCompleteEffect();
			if(buildComMC){
				var removeEffectEffect:BaseMovieClipEffect = EffectManager.instance.createMapEffectByMC(buildComMC);
				removeEffectEffect.y = fixedOffsetY ;
				effectLayer.addChild(removeEffectEffect);
			}
		}
		
		//============建筑特效＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
		
		
		
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