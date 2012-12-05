package game.vos
{
	import bing.utils.ObjectUtil;
	
	import flash.utils.Dictionary;
	
	import game.model.CarModel;

	/**
	 * 机器车 
	 * @author zzhanglin
	 */	
	public class AIVO
	{
		public var carId:int ;
		public var name:String ;
		public var head:String ;
		public var earnExp:int ;
		public var earnCoin:int ;
		
		public var density:Number ;
		public var impulse:Number ;
		public var velocity:Number ;
		public var frequency:Number ;
		public var mass:Number ;
		public var drive:int ;
		
		public function get carVO():CarVO{
			var carVO:CarVO = ObjectUtil.copyObj(CarModel.instance.carsHash[carId] ) as CarVO ;
			for( var key:String in carVO.carParams)
			{
				carVO.carParams[key].value = this[key] ;
			}
			return  carVO;
		}
		
	}
}