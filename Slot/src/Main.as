package
{
	import game.models.MeInfoModel;
	import game.models.vos.UserVO;
	import game.views.CenterView;
	import game.views.topbars.TopbarBg;
	
	[SWF(width="760",height="620",backgroundColor="#000000")]
	public class Main extends BaseGame
	{
		protected var _topbarBg:TopbarBg;
		
		public function Main()
		{
			super();
		}
		
		override protected function inited():void
		{
			super.inited();
			//调用getConfigBase接口，获取
			MeInfoModel.instance.me=new UserVO();
			MeInfoModel.instance.me.level=5;
			
			_topbarBg = new TopbarBg();
			addChild(_topbarBg);
			
			addChild(CenterView.instance);
		}
	}
}