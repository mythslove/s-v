package local.view.storage
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import local.util.GameUtil;
	
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
					icon.bitmapData = new StorageAllButtonIcon(0,0);
					break ;
				case "home":
					icon.bitmapData = new StorageHomeButtonIcon(0,0);
					break ;
				case "business":
					icon.bitmapData = new StorageBusinessButtonIcon(0,0);
					break ;
				case "decor":
					icon.bitmapData = new StorageDecorButtonIcon(0,0);
					break ;
				case "industry":
					icon.bitmapData = new StorageIndustryButtonIcon(0,0);
					break ;
				case "community":
					icon.bitmapData = new StorageCommunityButtonIcon(0,0);
					break ;
				case "wonder":
					icon.bitmapData = new StorageWondersButtonIcon(0,0);
					break ;
				case "comp":
					icon.bitmapData = new StorageCompButtonIcon(0,0);
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
	
	
	StorageAllButtonIcon,StorageBusinessButtonIcon,StorageCommunityButtonIcon,StorageCompButtonIcon,StorageDecorButtonIcon,StorageWondersButtonIcon,
	StorageHomeButtonIcon,StorageIndustryButtonIcon;
	
}