package local.views.pickup
{
	import bing.components.button.BaseButton;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GameSetting;
	import local.game.elements.Architecture;
	import local.model.PickupModel;
	import local.model.vos.PickupVO;
	import local.utils.PopUpManager;
	import local.utils.SoundManager;
	import local.views.base.BaseView;

	/**
	 * 建筑完成时需要的材料窗口 
	 * @author zzhanglin
	 */	
	public class BuildCompleteMaterialPopUp extends BaseView
	{
		public var txtBtn:TextField;
		public var btn:BaseButton;
		public var btnClose:BaseButton;
		public var container:Sprite;
		//==========================
		public var result:Boolean=true ; //是否能全部通过
		public var costCash:int; //最后要花多少钱
		private var _materials:Object;
		public function get materials():Object{
			return _materials ;
		}
		private var _architechture:Architecture ;
		public function get architechture():Architecture{
			return _architechture ;
		}
		
		public function BuildCompleteMaterialPopUp( architechture:Architecture )
		{
			super();
			txtBtn.mouseEnabled=false ;
			x = GameSetting.SCREEN_WIDTH>>1;
			y = -50 + GameSetting.SCREEN_HEIGHT>>1;
			container.visible=false;
			this._materials =architechture.baseBuildingVO["materials"]  ;
			this._architechture = architechture ;
		}
		
		override protected function added():void
		{
			TweenLite.from(this,0.3,{x:-200 , ease:Back.easeOut , onComplete:inTweenOver });
			SoundManager.instance.playSoundPopupShow();
			btnClose.addEventListener(MouseEvent.CLICK , onBtnClickHandler );
			btn.addEventListener(MouseEvent.CLICK , onBtnClickHandler );
			//内容
			var count:int ;
			var pkVO:PickupVO ; 
			var myCount:int ;
			var renderer:BuildCompleteItemRenderer ;
			for ( var key:String in _materials){
				pkVO=PickupModel.instance.getPickupById(key);
				myCount = PickupModel.instance.getMyPickupCount(key);
				renderer = new BuildCompleteItemRenderer();
				renderer.name = key ;
				renderer.txtCount.text = myCount+"/"+_materials[key] ;
				if(myCount<int(_materials[key] )){
					costCash+=myCount;
					result = false ;
					renderer.x = count*(renderer.width+10) ;
					container.addChild( renderer );
				}else{
					renderer.gotoAndStop("default");
				}
				++count ;
			}
			if(result){
				txtBtn.text = "Complete" ;
			}
		}
		
		public function refresh():void
		{
			costCash = 0 ;
			result = true ;
			var count:int ;
			var pkVO:PickupVO ; 
			var myCount:int ;
			var renderer:BuildCompleteItemRenderer ;
			for ( var i:int = 0 ; i<container.numChildren ; ++i){
				renderer = getChildAt(i) as BuildCompleteItemRenderer ;
				pkVO=PickupModel.instance.getPickupById(renderer.name);
				myCount = PickupModel.instance.getMyPickupCount(renderer.name);
				renderer.txtCount.text = myCount+"/"+_materials[renderer.name] ;
				if(myCount<int(_materials[renderer.name] )){
					costCash+=myCount;
					result = false ;
				}else{
					renderer.gotoAndStop("default");
				}
				++count ;
			}
			if(result){
				txtBtn.text = "Complete" ;
			}
		}
		
		private function inTweenOver():void{
			container.visible=true ;
		}
		private function onBtnClickHandler (e:MouseEvent):void
		{
			e.stopPropagation();
			switch(e.target)
			{
				case btnClose:
					mouseChildren = false ;
					container.visible=false;
					TweenLite.to(this,0.3,{x:x+200 , ease:Back.easeIn , onComplete:tweenComplete});
					break ;
				case btn:
					if(result){
						//建筑完成
					}else{
						//花钱完成
					}
					break ;
			}
		}
		private function tweenComplete():void{
			PopUpManager.instance.removeCurrentPopup();
		}
		
		override protected function removed():void
		{
			btnClose.removeEventListener(MouseEvent.CLICK , onBtnClickHandler );
			btn.removeEventListener(MouseEvent.CLICK , onBtnClickHandler );
			_materials = null ;
			_architechture = null ;
		}
	}
}