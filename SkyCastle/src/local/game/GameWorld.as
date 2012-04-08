package local.game
{
	import bing.iso.IsoScene;
	import bing.res.ResVO;
	import bing.utils.MathUtil;
	import bing.utils.ObjectUtil;
	import bing.utils.SystemUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import local.comm.GameData;
	import local.enum.BuildingOperation;
	import local.enum.LayerType;
	import local.enum.PayType;
	import local.game.elements.Building;
	import local.game.elements.Character;
	import local.game.elements.Hero;
	import local.game.elements.HeroBornPoint;
	import local.model.MapGridDataModel;
	import local.model.PlayerModel;
	import local.model.buildings.vos.BuildingVO;
	import local.model.map.vos.MapVO;
	import local.model.vos.PlayerVO;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;
	import local.utils.ResourceUtil;
	import local.views.CenterViewContainer;
	import local.views.effects.MapWordEffect;


	public class GameWorld extends BaseWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld{
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//------------------------------------------------------------
		//用于缓存移动的建筑的上次位置
		private var _cacheBuildPos:Point = new Point();
		
		/**
		 * 点击地图 
		 * @param e
		 */		
		override protected function onClick(e:MouseEvent):void 
		{
			if(_mouseOverBuild is HeroBornPoint){
				return ;
			}
			if(_mouseOverBuild && _mouseOverBuild is Character){
				_mouseOverBuild.onClick();
			}
			else if(GameData.buildingCurrOperation==BuildingOperation.BUY) //添加
			{	
				if( _topBuilding && _topBuilding.gridLayer && _topBuilding.gridLayer.getWalkable() )
				{
					var vo:BuildingVO = ObjectUtil.copyObj(_topBuilding.buildingVO) as BuildingVO ;
					if(checkMoney(vo) && checkWood(vo) && checkStone(vo) ){
						buyComplete( vo) ;
						var addedBuilding:Building = addBuildingByVO( _topBuilding.nodeX , _topBuilding.nodeZ ,vo );
						if(addedBuilding){
							addedBuilding.sendOperation(BuildingOperation.BUY); //发送添加到地图上的消息到服务器
							_topBuilding.gridLayer.updateBuildingGridLayer(_topBuilding.nodeX , _topBuilding.nodeZ , vo.baseVO.layer );
						}
					}
				}
			}
			else if(GameData.buildingCurrOperation==BuildingOperation.ROTATE) //旋转
			{	
				//路一层的建筑才可以旋转
				if(_mouseOverBuild && _mouseOverBuild.buildingVO.baseVO.layer==LayerType.BUILDING){
					if(_mouseOverBuild.getRotatable(MapGridDataModel.instance.buildingGrid)) {
						removeBuildFromScene( _mouseOverBuild );
						_mouseOverBuild.scaleX = ~_mouseOverBuild.scaleX+1 ;
						addBuildToScene(_mouseOverBuild);
						_mouseOverBuild.sendOperation(BuildingOperation.ROTATE); //发送旋转建筑消息到服务器
					}
				}
			}
			else if( GameData.buildingCurrOperation==BuildingOperation.MOVE) //移动时点击地面
			{
				if(_topBuilding){
					if( _topBuilding.gridLayer.getWalkable() )
					{
						addBuildToScene( _topBuilding );//添加到场景上
						_topBuilding.sendOperation(BuildingOperation.MOVE); //发送移动建筑的消息
						clearTopScene();
					}
				}
				else if(_mouseOverBuild)
				{
					_cacheBuildPos.x = _mouseOverBuild.nodeX ;
					_cacheBuildPos.y = _mouseOverBuild.nodeZ ;
					removeBuildFromScene( _mouseOverBuild ); //从场景上先移除
					addBuildingToTop( _mouseOverBuild );  //添加在鼠标容器上移动
					_mouseOverBuild = null ;
				}
			}
			else if(GameData.buildingCurrOperation==BuildingOperation.STASH) //收藏
			{
				if(_mouseOverBuild){
					removeBuildFromScene( _mouseOverBuild ); //从场景上先移除
					_mouseOverBuild.selectedStatus(false);
					_mouseOverBuild.sendOperation(BuildingOperation.STASH); //发送收藏建筑信息到服务器
					_mouseOverBuild = null ;
				}
			}
			else if(GameData.buildingCurrOperation==BuildingOperation.SELL) //卖出
			{
				if(_mouseOverBuild){
					//弹出卖出窗口
					_mouseOverBuild = null ;
				}
			}
			else if(_mouseOverBuild)
			{
				_mouseOverBuild.onClick() ;
			}
			else if(!CollectQueueUtil.instance.currentBuilding) //当前执行队列里没有建筑
			{
				var p:Point = pixelPointToGrid(stage.mouseX,stage.mouseY); 
				if( !CharacterManager.instance.hero.searchToRun( p.x , p.y )){
					var effect:MapWordEffect = new MapWordEffect("I can 't get here!");
					addEffect( effect , (stage.mouseX-x)/scaleX-sceneLayerOffsetX,(stage.mouseY-y)/scaleX-sceneLayerOffsetY);
				}
			}
		}
		
		/** 判断金钱是否足够，并提示*/	
		private function checkMoney( vo:BuildingVO ):Boolean
		{
			if(vo.payType==PayType.FREE) return true ;
			
			var result:Boolean ;
			var effect:Sprite ;
			if( vo.payType==PayType.COIN){
				if(PlayerModel.instance.checkCoinEnough(vo.price) ){
					result = true ;
				}else{
					effect = new MapWordEffect("You don't have enough Coin!");
				}
			} else if( vo.payType==PayType.CASH) {
				if(PlayerModel.instance.checkCashEnough(vo.price)){
					result = true ;
				}else{
					effect = new MapWordEffect("You don't have enough Cash!");
				}
			}
			if(effect && _topBuilding){
				addEffect( effect,_topBuilding.screenX  ,_topBuilding.screenY );
			}
			return result ;
		}
		
		/** 判断木头是否足够，并提示*/
		private function checkWood( vo:BuildingVO):Boolean
		{
			var result:Boolean = true ;
			var effect:Sprite ;
			if(vo.baseVO.hasOwnProperty("buildWood") && !PlayerModel.instance.checkWood(vo.baseVO["buildWood"])){
				result = false ;
				effect = new MapWordEffect("You don't have enough Wood!");
			}
			if(effect && _topBuilding){
				addEffect( effect,_topBuilding.screenX  ,_topBuilding.screenY );
			}
			return result ;
		}
		
		/** 判断石头是否足够，并提示*/
		private function checkStone( vo:BuildingVO):Boolean
		{
			var result:Boolean = true ;
			var effect:Sprite ;
			if(vo.baseVO.hasOwnProperty("buildStone") && !PlayerModel.instance.checkWood(vo.baseVO["buildStone"])){
				result = false ;
				effect = new MapWordEffect("You don't have enough Stone!");
			}
			if(effect && _topBuilding){
				addEffect( effect,_topBuilding.screenX  ,_topBuilding.screenY );
			}
			return result ;
		}
		
		private function buyComplete(vo:BuildingVO):void
		{
			var effect:Sprite ;
			if(vo.baseVO.hasOwnProperty("buildStone") && int(vo.baseVO["buildStone"])>0 ){
				PlayerModel.instance.me.stone-=int(vo.baseVO["buildStone"]);
				effect = new MapWordEffect("Stone -"+int(vo.baseVO["buildStone"]));
				if(effect && _topBuilding){
					addEffect( effect,_topBuilding.screenX +Math.random()*60*MathUtil.getRandomFlag()  ,_topBuilding.screenY+Math.random()*60*MathUtil.getRandomFlag()  );
				}
			}
			if(vo.baseVO.hasOwnProperty("buildWood")&&int(vo.baseVO["buildWood"])>0 ){
				PlayerModel.instance.me.stone-=int(vo.baseVO["buildWood"]);
				effect = new MapWordEffect("Wood -"+int(vo.baseVO["buildWood"]));
				if(effect && _topBuilding){
					addEffect( effect,_topBuilding.screenX +Math.random()*60*MathUtil.getRandomFlag() ,_topBuilding.screenY+Math.random()*60*MathUtil.getRandomFlag()  );
				}
			}
			if(vo.price!=0){
				if( vo.payType==PayType.COIN){
					PlayerModel.instance.me.coin-=vo.price ;
					effect = new MapWordEffect("Coin -"+vo.price);
					if(effect && _topBuilding){
						addEffect( effect,_topBuilding.screenX +Math.random()*60*MathUtil.getRandomFlag()  ,_topBuilding.screenY+Math.random()*60*MathUtil.getRandomFlag()  );
					}
				} else if( vo.payType==PayType.CASH) {
					PlayerModel.instance.me.cash-=vo.price;
					effect = new MapWordEffect("Cash -"+vo.price);
					if(effect && _topBuilding){
						addEffect( effect,_topBuilding.screenX +Math.random()*60*MathUtil.getRandomFlag()  ,_topBuilding.screenY+Math.random()*60*MathUtil.getRandomFlag()  );
					}
				}
			}
			CenterViewContainer.instance.topBar.updateTopBar();
		}
		
		/**
		 * 移动建筑失败，建筑返回原来的地点 
		 */		
		public function moveFail():void 
		{
			if(_topBuilding){
				_topBuilding.nodeX=_cacheBuildPos.x ;
				_topBuilding.nodeZ=_cacheBuildPos.y ;
				this.addBuildToScene( _topBuilding );
			}
			clearTopScene();
		}
		
		/**
		 * 将建筑加到topScene,跟随鼠标移动 
		 * @param building
		 */ 		
		public function addBuildingToTop( building:Building ):void
		{
			_topBuilding = building ;
			building.drawGrid();
			topScene.addIsoObject( building , false );
			building.itemLayer.alpha = 0.5 ;
			building.selectedStatus(false); //选择设置成false
			topScene.visible = true  ;
		}
		
		
		/** 显示世界 */
		public function initWorld():void
		{
			this.stop() ;
			this.clearWorld();
			//添加出生点
			var heroBornPoint:HeroBornPoint = new HeroBornPoint();
			heroBornPoint.nodeX = 55 ;
			heroBornPoint.nodeZ = 40 ;
			addBuildToScene(heroBornPoint,false,false);
			heroBornPoint = new HeroBornPoint();
			heroBornPoint.nodeX = 40 ;
			heroBornPoint.nodeZ = 30 ;
			addBuildToScene(heroBornPoint,false,false);
			heroBornPoint = new HeroBornPoint();
			heroBornPoint.nodeX = 21 ;
			heroBornPoint.nodeZ = 17 ;
			addBuildToScene(heroBornPoint,false,false);
			//添加英雄
			var avatar:Hero = new Hero();
			avatar.nodeX = 55;
			avatar.nodeZ = 40;
			var scene:IsoScene = this.getBuildingScene( avatar.nodeX , avatar.nodeZ );
			scene.addIsoObject( avatar ) ;
			CharacterManager.instance.hero = avatar ;
			//添加场景建筑
			var basicBuildingRes:ResVO = ResourceUtil.instance.getResVOByResId( GameData.currentMapId+"_BUILDINGS");
			var bytes:ByteArray = basicBuildingRes.resObject as ByteArray ;
			try{
				bytes.uncompress();
			}catch(e:Error){
				SystemUtil.debug(GameData.currentMapId+"_BUILDINGS没有压缩");
			}
			var mapVO:MapVO = bytes.readObject() as MapVO ;
			var player:PlayerVO = GameData.isHome ? PlayerModel.instance.me : PlayerModel.instance.friend ;
			var building:Building ;
			var currentStep:int ;
			for each( var vo:BuildingVO in mapVO.mapItems)
			{
				vo.currentStep = 0 ; ////////暂时使用
				if(player.basicItems && player.basicItems.hasOwnProperty(vo.nodeX+"_"+vo.nodeZ) )
				{
					vo.currentStep = player.basicItems[vo.nodeX+"_"+vo.nodeZ] ; 
					if(vo.currentStep>=vo.baseVO["step"]){
						continue ;
					}
				}
				GameWorld.instance.addBuildingByVO(vo.nodeX,vo.nodeZ,vo,false,false);
			}
			if( player.buildings)
			{
				for each( vo in player.buildings )
				{
					building = GameWorld.instance.addBuildingByVO(vo.nodeX,vo.nodeZ,vo,false,false);
					if(building){
						building.recoverStatus();
					}
				}
			}
			GameWorld.instance.buildingScene1.sortAll();
			GameWorld.instance.buildingScene2.sortAll();
			GameWorld.instance.buildingScene3.sortAll();
			GameWorld.instance.groundScene1.sortAll();
			GameWorld.instance.groundScene2.sortAll();
			GameWorld.instance.groundScene3.sortAll();
			GameWorld.instance.groundScene1.updateAllUI();
			GameWorld.instance.groundScene2.updateAllUI();
			GameWorld.instance.groundScene3.updateAllUI();
			//开始
			this.start();
		}
	}
}