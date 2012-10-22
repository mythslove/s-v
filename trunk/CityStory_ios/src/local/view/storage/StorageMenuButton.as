package local.view.storage
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	import local.util.GameUtil;
	import local.util.ResourceUtil;
	
	public class StorageMenuButton extends MovieClip
	{
		public function StorageMenuButton( name:String )
		{
			super();
			mouseChildren = false ;
			stop();
			
			this.name = name ;
			
			var resId:String = "ui_popup";
			var icon:Bitmap = new Bitmap();
			switch(name){
				case "all":
					icon.bitmapData = ResourceUtil.instance.getInstanceByClassName(resId,"local.view.storage.StorageAllButtonIcon") as BitmapData;
					break ;
				case "home":
					icon.bitmapData = ResourceUtil.instance.getInstanceByClassName(resId,"local.view.storage.StorageHomeButtonIcon") as BitmapData;
					break ;
				case "business":
					icon.bitmapData = ResourceUtil.instance.getInstanceByClassName(resId,"local.view.storage.StorageBusinessButtonIcon") as BitmapData;
					break ;
				case "decor":
					icon.bitmapData = ResourceUtil.instance.getInstanceByClassName(resId,"local.view.storage.StorageDecorButtonIcon") as BitmapData;
					break ;
				case "industry":
					icon.bitmapData = ResourceUtil.instance.getInstanceByClassName(resId,"local.view.storage.StorageIndustryButtonIcon") as BitmapData;
					break ;
				case "community":
					icon.bitmapData = ResourceUtil.instance.getInstanceByClassName(resId,"local.view.storage.StorageCommunityeButtonIcon") as BitmapData;
					break ;
				case "wonder":
					icon.bitmapData = ResourceUtil.instance.getInstanceByClassName(resId,"local.view.storage.StorageWondersButtonIcon") as BitmapData;
					break ;
				case "comp":
					icon.bitmapData = ResourceUtil.instance.getInstanceByClassName(resId,"local.view.storage.StorageCompButtonIcon") as BitmapData;
					break ;
			}
			icon.x = (width-icon.width)>> 1; 
			icon.y = (height-icon.height)>> 1; 
			addChild(icon)
		}
		
		
		override public function gotoAndStop(frame:Object, scene:String=null):void{
			super.gotoAndStop(frame,scene);
			if(currentLabel=="up"){
				GameUtil.backDark(this);
			}else if(currentLabel=="selected-up"){
				GameUtil.backDark(this);
			}else if( currentLabel=="down"){
				GameUtil.dark(this);
			}
		}
	}
}