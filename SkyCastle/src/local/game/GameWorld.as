package local.game
{
	import bing.iso.IsoScene;
	import bing.utils.ContainerUtil;
	import bing.utils.MathUtil;
	import bing.utils.ObjectUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import local.comm.GameData;
	import local.enum.BuildingOperation;
	import local.enum.LayerType;
	import local.enum.PayType;
	import local.game.elements.Building;
	import local.game.elements.Character;
	import local.model.buildings.vos.BuildingVO;
	import local.model.map.MapGridDataModel;
	import local.model.village.VillageModel;
	import local.utils.CharacterManager;
	import local.views.effects.MapWordEffect;
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
			if(_mouseOverBuild && _mouseOverBuild is Character){
				_mouseOverBuild.onClick();
			}
			else if(GameData.buildingCurrOperation==BuildingOperation.ADD) //添加
			{	
				if( _topBuilding && _topBuilding.gridLayer && _topBuilding.gridLayer.getWalkable() )
				{
					var vo:BuildingVO = ObjectUtil.copyObj(_topBuilding.buildingVO) as BuildingVO ;
					if(checkMoney(vo) && checkWood(vo) && checkStone(vo) ){
						buyComplete( vo) ;
						var addedBuilding:Building = addBuildingByVO( _topBuilding.nodeX , _topBuilding.nodeZ ,vo );
						if(addedBuilding){
							addedBuilding.sendOperation(BuildingOperation.ADD); //发送添加到地图上的消息到服务器
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
			else
			{
				var p:Point = pixelPointToGrid(stage.mouseX,stage.mouseY); 
				if(!CharacterManager.instance.hero.searchToRun( p.x , p.y )){
					var effect:MapWordEffect = new MapWordEffect("I can 't get here!");
					addEffect( effect , stage.mouseX-sceneLayerOffsetX-x ,stage.mouseY-sceneLayerOffsetY-y);
				}
			}
		}
		
		/** 判断金钱是否足够，并提示*/	
		private function checkMoney( vo:BuildingVO ):Boolean
		{
			var result:Boolean ;
			var effect:Sprite ;
			if( vo.payType==PayType.COIN){
				if(VillageModel.instance.checkCoinEnough(vo.price) ){
					result = true ;
				}else{
					effect = new MapWordEffect("You don't have enough Coin!");
				}
			} else if( vo.payType==PayType.CASH) {
				if(VillageModel.instance.checkCashEnough(vo.price)){
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
			if(vo.baseVO.hasOwnProperty("buildWood") && !VillageModel.instance.checkWood(vo.baseVO["buildWood"])){
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
			if(vo.baseVO.hasOwnProperty("buildStone") && !VillageModel.instance.checkWood(vo.baseVO["buildStone"])){
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
				VillageModel.instance.me.stone-=int(vo.baseVO["buildStone"]);
				effect = new MapWordEffect("Stone -"+int(vo.baseVO["buildStone"]));
				if(effect && _topBuilding){
					addEffect( effect,_topBuilding.screenX +Math.random()*60*MathUtil.getRandomFlag()  ,_topBuilding.screenY+Math.random()*60*MathUtil.getRandomFlag()  );
				}
			}
			if(vo.baseVO.hasOwnProperty("buildWood")&&int(vo.baseVO["buildWood"])>0 ){
				VillageModel.instance.me.stone-=int(vo.baseVO["buildWood"]);
				effect = new MapWordEffect("Wood -"+int(vo.baseVO["buildWood"]));
				if(effect && _topBuilding){
					addEffect( effect,_topBuilding.screenX +Math.random()*60*MathUtil.getRandomFlag() ,_topBuilding.screenY+Math.random()*60*MathUtil.getRandomFlag()  );
				}
			}
			if(vo.price!=0){
				if( vo.payType==PayType.COIN){
					VillageModel.instance.me.coin-=vo.price ;
					effect = new MapWordEffect("Coin -"+vo.price);
					if(effect && _topBuilding){
						addEffect( effect,_topBuilding.screenX +Math.random()*60*MathUtil.getRandomFlag()  ,_topBuilding.screenY+Math.random()*60*MathUtil.getRandomFlag()  );
					}
				} else if( vo.payType==PayType.CASH) {
					VillageModel.instance.me.cash-=vo.price;
					effect = new MapWordEffect("Cash -"+vo.price);
					if(effect && _topBuilding){
						addEffect( effect,_topBuilding.screenX +Math.random()*60*MathUtil.getRandomFlag()  ,_topBuilding.screenY+Math.random()*60*MathUtil.getRandomFlag()  );
					}
				}
			}
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
		
		/**
		 * 清除topScene 
		 */		
		public function clearTopScene():void
		{
			ContainerUtil.removeChildren(topScene);
			topScene.visible = false  ;
			if(_topBuilding){
				_topBuilding.removeGrid();
				_topBuilding.itemLayer.alpha = 1;
			}
			_topBuilding = null ;
		}
		
		/**
		 * 清空世界 
		 */		
		public function clearWorld():void
		{
			for each( var scene:IsoScene in scenes){
				scene.clear();
			}
			clearTopScene() ;
		}
	}
}