class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    NanoStore.shared_store = NanoStore.store(:file, App.documents_path + "/letscamp.db")

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @mapController = MapController.alloc.init
    @mapController.tabBarItem.title = 'Campsite Map'
    @mapController.tabBarItem.image = UIImage.imageNamed('map.png')
    @mapController.navigationItem.title = "Let's Camp"
    @mapController.window = @window

    @campgroundController = CampgroundController.alloc.init
    @campgroundController.tabBarItem.title = 'Campgrounds'
    @campgroundController.tabBarItem.image = UIImage.imageNamed('camp.png')
    @campgroundController.navigationItem.title = "Campground Search"
    @campgroundController.window = @window
    @campgroundController.map = @mapController

    @foodController = FoodController.alloc.init
    @foodController.tabBarItem.title = 'Food'
    @foodController.tabBarItem.image = UIImage.imageNamed('pizza.png')
    @foodController.item = FoodItemController.alloc.init
    @foodController.window = @window

    @suppliesController = SuppliesController.alloc.init
    @suppliesController.tabBarItem.title = 'Supplies'
    @suppliesController.tabBarItem.image = UIImage.imageNamed('list.png')
    @suppliesController.item = SuppliesItemController.alloc.init
    @suppliesController.window = @window

    tabbar = UITabBarController.alloc.init
    tabbar.viewControllers = [@mapController,@campgroundController,@suppliesController,@foodController]
    tabbar.selectedIndex = 0

    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(tabbar)
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    @mapController.loadNavBar
    @campgroundController.tabbar = tabbar
  end

  def settings
    settingsController = SettingsController.alloc.init
    settingsController.window = @window
    settingsController.map = @mapController

    @window.rootViewController.pushViewController(settingsController, animated: true)
    @window.rootViewController.navigationBar.topItem.title = 'Settings'
  end
end
