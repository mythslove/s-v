package local.game.elements
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import local.comm.GameSetting;
	import local.enum.AvatarAction;
	import local.enum.MouseStatus;
	import local.enum.QuestType;
	import local.game.GameWorld;
	import local.model.MapGridDataModel;
	import local.model.QuestModel;
	import local.model.buildings.vos.BaseMobVO;
	import local.model.buildings.vos.BuildingVO;
	import local.model.vos.RewardsVO;
	import local.utils.CharacterManager;
	import local.utils.MouseManager;
	import local.utils.SoundManager;

	/**
	 * 怪(ATTACK,DAMAGE,IDLE,WALK,DEFEAT)
	 * @author zzhanglin
	 */	
	public class Mob extends Character
	{
		private var _canMove:Boolean ; 
		private var _endPoint:Point ;
		private var _flag:Boolean ;
		
		public function Mob(vo:BuildingVO)
		{
			super(vo);
		}
		
		/* 添加到舞台上*/
		override protected function addedToStageHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedToStageHandler );
			showSkin(); //加载资源
		}
		/*资源下载完成*/
		override protected function resLoadedHandler(e:Event):void
		{
			super.resLoadedHandler(e);
			if(_flag) actionAttack() ;
		}
		
		/** 怪刚出生时吓一次 */
		public function liveAttack():void
		{
			if(_bmpMC) actionAttack() ;
			else _flag =  true ;
		}
			
				
		
		override public function move():void
		{
			if(_canMove) super.move();
		}
		
		/** 获取此建筑的基础VO */
		public function get baseMobVO():BaseMobVO{
			return buildingVO.baseVO as BaseMobVO ;
		}
		
		/** 怪物攻击人 */
		public function actionAttack():void
		{
			gotoAndPlay( AvatarAction.ATTACK );
			_bmpMC.loopTime = 2 ;
			CharacterManager.instance.charactersCow();
			SoundManager.instance.playSoundMonsterRoar();
		}
		
		/** 被打 */
		public function actionDamage():void
		{
			gotoAndPlay( AvatarAction.DAMAGE );
			_bmpMC.loopTime = 4 ;
		}
		
		/** 死亡，被战胜 */
		public function actionDefeat():void
		{
			gotoAndPlay( AvatarAction.DEFEAT );
		}
		
		override protected function createCharacterSkin():void
		{
			super.createCharacterSkin();
			if(_bmpMC){
				_bmpMC.addEventListener(Event.COMPLETE , animComHandler );
			}
		}
		
		private function animComHandler( e:Event ):void
		{
			if( _bmpMC.currentLabel==AvatarAction.DEFEAT)
			{
				//死亡，从场景中移除
				_bmpMC.stop();
				GameWorld.instance.removeBuildFromScene( this , false );
				//清理
				dispose();
				//统计quest ,战胜怪
				QuestModel.instance.updateQuests( QuestType.DEFEAT_MOB  ) ;
				return ;
			}
			else if( _bmpMC.currentLabel==AvatarAction.DAMAGE || _bmpMC.currentLabel==AvatarAction.ATTACK )
			{
				gotoAndPlay(AvatarAction.IDLE);
				if(!enable) enable = true ;
				if(_bmpMC.currentLabel==AvatarAction.ATTACK){
					_canMove = true ;
				}
			}
		}
		
		override public function onClick():void
		{
			if( !nextPoint &&_currentActions==AvatarAction.IDLE){
				if(roads){
					if(roads.length==0) super.onClick() ;
				}else{
					super.onClick() ;
				}
				_canMove = true ;
			}
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			MouseManager.instance.mouseStatus = MouseStatus.SHOVEL_BUILDING ;
		}
		
		override public function execute():Boolean
		{
			if(checkEnergyAndMob())
			{
				itemLayer.alpha=1 ;
				_currentRewards = null ;
				_executeBack = false ;
				
				_endPoint = new Point(nodeX, nodeZ) ;
				if(Math.random()>0.5){ //跑动
					var p:Point = getFreeRoad(4);
					if( p && this.searchToRun(p.x , p.y)){
						_endPoint = p ;
						_canMove = false ;
						//将终点设置成false
						MapGridDataModel.instance.astarGrid.setWalkable( _endPoint.x , _endPoint.y , false );
						MapGridDataModel.instance.buildingGrid.setWalkable( _endPoint.x , _endPoint.y , false );
					}
				}
				
				ro.getOperation("attackMob").send( buildingVO.id , _endPoint.x , _endPoint.y );
				CharacterManager.instance.hero.gotoAndPlay(AvatarAction.HIT);
				if(!_canMove) this.actionAttack();
				else this.actionDamage();
				SoundManager.instance.playSoundHitMonster() ;
				setTimeout( 	SoundManager.instance.playSoundHitMonster , 1100 );
				_timeoutFlag = false ;
				_timeoutId = setTimeout( timeoutHandler , 2000 );
			}
			return true;
		}
		
		/**
		 * 寻路移动 
		 * @param endNodeX
		 * @param endNodeZ
		 * @return true表示有路径，false为没有路
		 */		
		override public function searchToRun( endNodeX:int , endNodeZ:int):Boolean
		{
			if(endNodeX<0 || endNodeZ<0||endNodeX+1>GameSetting.GRID_X||endNodeZ+1>GameSetting.GRID_Z ) return false;
			if(MapGridDataModel.instance.astarGrid.getNode(endNodeX,endNodeZ).walkable )
			{
				MapGridDataModel.instance.astarGrid.setStartNode( nodeX,nodeZ );
				MapGridDataModel.instance.astarGrid.setEndNode( endNodeX,endNodeZ );
				if(Character.astar.findPath()) 
				{
					var roadsArray:Array = Character.astar.path;
					if(roadsArray && roadsArray.length>0){
						roads = roadsArray ;
						roadIndex = 0 ;
						nextPoint = this.getNextPoint();
						return true;
					}
				}
			}
			return false;
		}
		
		override protected function onResultHandler(e:ResultEvent):void
		{
			SystemUtil.debug("返回数据：",e.service+"."+e.method , e.result);
			switch(e.method)
			{
				case "attackMob": 
					_executeBack = true ;
					//将当前设置成true
					MapGridDataModel.instance.astarGrid.setWalkable( nodeX , nodeZ , true );
					MapGridDataModel.instance.buildingGrid.setWalkable( nodeX ,nodeZ , true );
					_currentRewards = e.result as RewardsVO ;
					if(_currentRewards){
						//打死了怪
						this.showPickup();
						itemLayer.enabled = false ;
					}
					break ;
			}
		}
		
		override public function showPickup():void
		{
			if( _timeoutFlag && _executeBack)
			{
				if(_currentRewards){
					this.stopMove();
					_canMove = false ;
					//被打败的动画
					this.actionDefeat();
				}
				//特殊物品
				showRewardsPickup();
				//-------------------------------------
				_timeoutFlag=false ;
				_executeBack = false ;
				_currentRewards = null ;
				super.showPickup();
			}
		}
		
		
		override public function dispose():void
		{
			if( _bmpMC ) _bmpMC.removeEventListener(Event.COMPLETE , animComHandler );
			super.dispose();
			if(_endPoint){
				//将终点设置成true
				MapGridDataModel.instance.astarGrid.setWalkable( _endPoint.x , _endPoint.y , true );
				MapGridDataModel.instance.buildingGrid.setWalkable( _endPoint.x , _endPoint.y , true );
				_endPoint = null ;
			}
		}
	}
}