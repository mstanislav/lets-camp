class CampgroundController < UITableViewController
  attr_accessor :window, :map, :tabbar
  
  $api_key = 'k4nh5c33nrjf9xea6k63f2vf'

  def viewWillAppear(animated)
    @items = []
    getCampgrounds('MI', '2003')
    loadNavBar
  end

  def getCampgrounds(state, type)
    BubbleWrap::HTTP.get("http://api.amp.active.com/camping/campgrounds?pstate=#{state}&siteType=#{type}&api_key=#{$api_key}") do |response|
      if response.ok?
        data = Hpple.XML(response.body.to_str)
        data.xpath("/resultset/result").each do |item|
          @items << item
        end
        view.reloadData
      else
        raise "Unable to downlod data"
      end
    end
  end

  def getCampgroundDetails(item)
    BubbleWrap::HTTP.get("http://api.amp.active.com/camping/campground/details?contractCode=#{item['contractID']}&parkId=#{item['facilityID']}&api_key=#{$api_key}") do |response|
      if response.ok?
        data = Hpple.XML(response.body.to_str)
        result = data.xpath("/detailDescription/address").first
        @map.saveMapPin("#{result['streetAddress']} #{result['state']} #{result['zip']}")
        @tabbar.selectedIndex = 0
      else
        raise "Unable to downlod data"
      end
    end
  end

  def loadNavBar
    @window.rootViewController.navigationBar.topItem.title = 'Campground Search'
    @window.rootViewController.navigationBar.topItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle('Settings', style: 0, target: UIApplication.sharedApplication.delegate, action: "settings")
    @window.rootViewController.navigationBar.topItem.rightBarButtonItem = nil
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @items.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    CampgroundCell.cellForCampground(@items[indexPath[1]], inTableView:tableView)
  end

  def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
    getCampgroundDetails(@items[indexPath.row])
  end
end
