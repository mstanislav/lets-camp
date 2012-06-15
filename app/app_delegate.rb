class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    mapController                      = MapController.alloc.init
    mapController.tabBarItem.title     = "Campsite Map"
    mapController.tabBarItem.image     = UIImage.imageNamed("map_button_icon.png")

    tabbar                             = UITabBarController.alloc.init
    tabbar.viewControllers             = [mapController]
    tabbar.selectedIndex               = 0

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(tabbar)
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    @window.rootViewController.navigationBar.topItem.title = "Let's Camp"

    return true
  end
end
