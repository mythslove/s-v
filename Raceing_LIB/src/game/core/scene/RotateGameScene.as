package game.core.scene
{
	import game.vos.PlayerCarVO;
	import game.vos.TrackVO;
	
	import nape.geom.Vec2;
	
	/**
	 * 旋转模式 
	 * @author zzhanglin
	 */	
	public class RotateGameScene extends ContestGameScene
	{
		public function RotateGameScene(trackVO:TrackVO, playerCarVO:PlayerCarVO, competitorIndex:int=0)
		{
			super(trackVO, playerCarVO, competitorIndex);
		}
		
		override protected function moveCar():void
		{
			_car.leftWheel.rotation+=0.2 ;
			if(_carLeftWheelOnRoad) {
				_car.carBody.applyImpulse( Vec2.fromPolar(_car.maxImpulse,_car.carBody.rotation) );
			}
			if(_playerCarVO.carVO.drive==2){
				_car.rightWheel.rotation+=0.2 ;
				if(_carRightWheelOnRoad ){
					_car.carBody.applyImpulse( Vec2.fromPolar(_car.maxImpulse,_car.carBody.rotation)  );
				}
			}
			//旋转车身
			if(_moveDirection==2){
			_car.carBody.applyImpulse( Vec2.fromPolar(30,_car.carBody.rotation+Math.PI/2) ,_car.rightWheel.position);
			}else if(_moveDirection==1){
			_car.carBody.applyImpulse( Vec2.fromPolar(30,_car.carBody.rotation+Math.PI/2) , _car.leftWheel.position );
			}
			
			if(_car.leftWheel.velocity.x<-_car.maxVelocity)  _car.leftWheel.velocity.x = - _car.maxVelocity ;
			if(_car.leftWheel.velocity.x>_car.maxVelocity)  _car.leftWheel.velocity.x = _car.maxVelocity ;
			if(_car.rightWheel.velocity.x<-_car.maxVelocity)  _car.rightWheel.velocity.x = - _car.maxVelocity ;
			if(_car.rightWheel.velocity.x>_car.maxVelocity)  _car.rightWheel.velocity.x = _car.maxVelocity ;
		}
	}
}