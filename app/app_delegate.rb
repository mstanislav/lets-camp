class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    NanoStore.shared_store = NanoStore.store(:file, App.documents_path + "/letscamp.db")

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @mapController = MapController.alloc.init
    @mapController.tabBarItem.title = 'Campsite Map'
    @mapController.tabBarItem.image = UIImage.imageNamed('map.png')
    @mapController.navigationItem.title = "Let's Camp"
    @mapController.window = @window

    @foodController = FoodController.alloc.init
    @foodController.tabBarItem.title = 'Food'
    @foodController.tabBarItem.image = UIImage.imageNamed('pizza.png')
    @foodController.item = FoodItemController.alloc.init
    @foodController.window = @window

    tabbar = UITabBarController.alloc.init
    tabbar.viewControllers = [@mapController,@foodController]
    tabbar.selectedIndex = 0

    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(tabbar)
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    @mapController.loadNavBar
  end

  def settings
    settingsController = SettingsController.alloc.init
    settingsController.window = @window
    settingsController.map = @mapController

    @window.rootViewController.pushViewController(settingsController, animated: true)
    @window.rootViewController.navigationBar.topItem.title = 'Settings'
  end
end
