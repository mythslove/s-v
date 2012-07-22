package local.game.elements
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import local.comm.GameData;
	import local.enum.AvatarAction;
	import local.enum.BuildingOperation;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CollectQueueUtil;

	/**
	 * 怪(ATTACK,DAMAGE,IDLE,WALK,DEFEAT)
	 * @author zzhanglin
	 */	
	public class Mob extends Character
	{
		public function Mob(vo:BuildingVO)
		{
			super(vo);
			this.speed = 4 ;
		}
		
		/** 攻击 */
		public function attack():void
		{
			gotoAndPlay( AvatarAction.ATTACK );
		}
		
		/** 被打 */
		public function damage():void
		{
			gotoAndPlay( AvatarAction.DAMAGE );
		}
		
		/** 死亡，被战胜 */
		public function defeat():void
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
			if( _bmpMC.currentLabel==AvatarAction.DEFEAT.toUpperCase())
			{
				//死亡，从场景中移除
			}
			else if( _bmpMC.currentLabel==AvatarAction.DAMAGE.toUpperCase() || _bmpMC.currentLabel==AvatarAction.ATTACK.toUpperCase() )
			{
				gotoAndPlay(AvatarAction.IDLE);
				if(Math.random()>0.8){
					var p:Point = getFreeRoad(6);
					if( !p || !this.searchToRun(p.x , p.y)){
						gotoAndPlay( AvatarAction.IDLE );
					}
				}
			}
		}
		
		/**
		 * 发送操作到服务器
		 */		
		override public function onClick():void
		{
			if( GameData.buildingCurrOperation==BuildingOperation.NONE && CollectQueueUtil.instance.isNull() )
			{
				this.enable=false ;
				
			}
		}
		
		
		
		
		
		
		
		
		override public function dispose():void
		{
			if( _bmpMC ) _bmpMC.removeEventListener(Event.COMPLETE , animComHandler );
			super.dispose();
		}
	}
}