package game.mvc.view.loading
{
	import flash.display.DisplayObjectContainer;
	
	import game.events.GameInitEvent;
	import game.events.GlobalEvent;
	import game.init.ConfigXMLInit;
	import game.init.GameResInit;
	import game.mvc.base.GameMediator;
	import game.mvc.control.ChangeMapCommand;
	import game.mvc.model.AniBaseModel;
	import game.mvc.model.ItemVOModel;
	import game.mvc.model.MapDataModel;
	
	public class MainLoadingMeditor extends GameMediator
	{
		public function get mainLoading():MainLoading
		{
			return view as MainLoading ;
		}
		public function MainLoadingMeditor(view:DisplayObjectContainer)
		{
			super(view);
		}
		
		private var _configXMLInit:ConfigXMLInit ; //游戏主配置文件
		private var _gameResInit:GameResInit; //游戏开始时的一些资源加载
		
		override public function onRegister():void
		{
			super.onRegister() ;
			loadConfigXML();
		}
		
		private function loadConfigXML():void 
		{
			_configXMLInit = new ConfigXMLInit();
			_configXMLInit.addEventListener(GameInitEvent.CONFIG_XML_LOADING , gameInitEventHandler );
			_configXMLInit.addEventListener(GameInitEvent.CONFIG_XML_LOADED , gameInitEventHandler );
			_configXMLInit.loadConfig() ;
		}
		
		private function configXMLLoaded():void 
		{
			_configXMLInit.removeEventListener(GameInitEvent.CONFIG_XML_LOADING , gameInitEventHandler );
			_configXMLInit.removeEventListener(GameInitEvent.CONFIG_XML_LOADED , gameInitEventHandler );
			
			AniBaseModel.instance.parseConfigXML(_configXMLInit.configXML );
			ItemVOModel.instance.parseConfigXML(_configXMLInit.configXML) ;
			MapDataModel.instance.parseConfigXML(_configXMLInit.configXML) ;
			
			loadGameRes();
		}
		
		/**
		 * 加载初始化的资源 
		 */		
		private function loadGameRes():void 
		{
			_gameResInit = new GameResInit();
			_gameResInit.addEventListener(GameInitEvent.UI_SWF_LOADING , gameInitEventHandler );
			_gameResInit.addEventListener(GameInitEvent.UI_SWF_LOADED , gameInitEventHandler );
			_gameResInit.loadInitRes();
		}
		
		/**
		 * 游戏初始化资源加载完成 
		 */		
		private function gameResInitLoaded():void 
		{
			_gameResInit.removeEventListener(GameInitEvent.UI_SWF_LOADING , gameInitEventHandler );
			_gameResInit.removeEventListener(GameInitEvent.UI_SWF_LOADED , gameInitEventHandler );
			
			this.dispatchContextEvent( new GlobalEvent(GlobalEvent.SHOW_VIEWS)); //显示UI界面
			new ChangeMapCommand( MapDataModel.instance.defaultMapId) ; //加载默认地图
			
			mainLoading.dispose();
		}
		
		private function gameInitEventHandler(e:GameInitEvent):void
		{			
			switch( e.type)
			{
				case GameInitEvent.CONFIG_XML_LOADING:
					mainLoading.update( 1 , e.progress );
					break ;
				case GameInitEvent.CONFIG_XML_LOADED:
					mainLoading.update( 1 , 0 );
					configXMLLoaded();
					break ;
				case GameInitEvent.UI_SWF_LOADING:
					mainLoading.update( 2 , e.progress );
					break ;
				case GameInitEvent.UI_SWF_LOADED:
					mainLoading.update( 2 , 1 );
					gameResInitLoaded();
					break ;
			}
		}
		
		override public function dispose():void
		{
			_gameResInit = null ;
			_configXMLInit = null ;
			super.dispose();
		}
	}
}