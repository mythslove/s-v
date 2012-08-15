package game.mvc.view.bar
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.events.ChangeMapEvent;
	import game.global.GameData;
	import game.mvc.base.GameMediator;
	import game.mvc.model.MapDataModel;
	import game.mvc.view.components.WindowsPopUpBg;
	import game.mvc.view.popup.MiniMapPopUp;
	import game.utils.PopUpManager;
	
	public class MapBarMediator extends GameMediator
	{
		public function get mapBar():MapBar
		{
			return view as MapBar ;
		}
		public function MapBarMediator(view:DisplayObjectContainer)
		{
			super(view);
		}
		
		private var _mapName:String ="";
		
		override public function onRegister():void
		{
			super.onRegister() ;
			mapBar.mapBtn.toolTipText = "打开地图寻路";
			
			mapBar.mapBtn.addEventListener(MouseEvent.CLICK , mapBtnClickHandler);
			mapBar.addEventListener(Event.ENTER_FRAME , update );
			this.addContextListener(ChangeMapEvent.CHANGE_MAP_OVER , changeMapOverHandler );
		}
		
		private function update( e:Event):void 
		{
			if(GameData.hero)
			{
				mapBar.infoTxt.text = _mapName+" "+(GameData.hero.x>>0)+" "+(GameData.hero.y>>0) ;
			}
		}
		
		private function changeMapOverHandler( e:ChangeMapEvent ):void
		{
			_mapName = MapDataModel.instance.currentMapVO.mapName ;
		}
		
		private function mapBtnClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			var bg:WindowsPopUpBg = new WindowsPopUpBg();
			bg.addView( new MiniMapPopUp());
			PopUpManager.addPopUp( bg,true );
		}
		
		override public function dispose():void
		{
			this.removeContextListener(ChangeMapEvent.CHANGE_MAP_OVER , changeMapOverHandler );
			mapBar.mapBtn.removeEventListener(MouseEvent.CLICK , mapBtnClickHandler);
			mapBar.removeEventListener(Event.ENTER_FRAME , update );
			super.dispose();
		}
	}
}