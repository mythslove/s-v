package game.elements.items
{
	import game.events.ChangeMapEvent;
	import game.mvc.base.GameContext;
	import game.mvc.model.vo.NpcVO;

	public class Npc extends LiveRole
	{
		public var npcVO:NpcVO ;
		private var _back:Boolean =false ; //是否单向行驶完成
		private var _canWalk:Boolean = false ; //是否可以走动了
		private var _standTime:int=10000 ; //站立计时器
		private var _topTime:int = (Math.random()*5+5)>>0 ;
		
		public function Npc( npcVO:NpcVO )
		{
			this.npcVO =npcVO;
			this.itemVO = npcVO ;
			super( npcVO.faceId , npcVO.name );
		}
		override protected function addedToStage():void
		{
			super.addedToStage() ;
			this.x = npcVO.px ;
			this.y = npcVO.py ;
			this.speed= npcVO.speed  ;
			this.direction = npcVO.direction;
			
			GameContext.instance.addContextListener( ChangeMapEvent.CHANGE_MAP_OVER , changeMapOverHandler);
		}
		
		override protected function init():void
		{
			if( npcVO.standAniName){
				this.createStandAnimation();
			}
			if(npcVO.runAniName){
				this.createRunAnimation();
			}
		}
		
		private function changeMapOverHandler(e:ChangeMapEvent):void 
		{
			GameContext.instance.removeContextListener( ChangeMapEvent.CHANGE_MAP_OVER , changeMapOverHandler);
			if(npcVO.runAniName && this.npcVO.endTx>0)
			{
				_canWalk = true ;
				this.findAndMove( this.npcVO.endTx,this.npcVO.endTy );
			}
		}
		
		override public function update():void
		{
			if(npcVO.standAniName)
			{
				if(_standTime>30*_topTime){ 
					actionName = "run";
					if(_standTime>30*_topTime*2){
						_standTime=0;
					}
				}else{
					actionName = "stand";
				}
				_standTime++;
			}
			else if(nextPoint ==null || roads==null  || roads.length==0 )
			{
				actionName = "stand" ;
			}else{
				actionName = "run";
			}
			if(actionName=="stand"){
				stand();
			}else if(actionName=="run"){
				move();
			}
			
			if(this.visible && _canWalk ){
				if(!nextPoint || !roads){
					_back = !_back ;
					roads.reverse();
					this.moveByRoads( roads );
				}
			}
			
		}
		
		override public function dispose():void
		{
			GameContext.instance.removeContextListener( ChangeMapEvent.CHANGE_MAP_OVER , changeMapOverHandler);
			npcVO = null ;
			super.dispose();
		}
	}
}