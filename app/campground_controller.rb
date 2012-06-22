class CampgroundController < UITableViewController
  attr_accessor :window, :map, :tabbar
  
  $api_key = 'k4nh5c33nrjf9xea6k63f2vf'
  $default_campground_type = 2001
  $default_campground_state = 'MI'
  $campground_site_types = { 0 => '2001', 1 => '1001', 2 => '2003', 3 => '3001', 4 => '2004' }
  
  def viewWillAppear(animated)
    @items = []
    get_campgrounds
    load_navbar
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @items.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    CampgroundCell.cellForCampground(@items[indexPath[1]], inTableView:tableView)
  end

  def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
    get_campground_details(@items[indexPath.row])
  end

  def get_campgrounds
    CampgroundSearch.create(:type => $default_campground_type, :state => $default_campground_state, :created_at => Time.now) unless CampgroundSearch.all.size > 0

    BubbleWrap::HTTP.get("http://api.amp.active.com/camping/campgrounds?pstate=#{CampgroundSearch.all.first.state}&siteType=#{CampgroundSearch.all.first.type}&api_key=#{$api_key}") do |response|
      if response.ok?
        data = Hpple.XML(response.body.to_str)
        data.xpath("/resultset/result").each { |item| @items << item } unless data == nil
      else
        @items << { 'facilityName' => 'Unable to load data.' }
      end
      view.reloadData
    end
  end

  def get_campground_details(item)
    BubbleWrap::HTTP.get("http://api.amp.active.com/camping/campground/details?contractCode=#{item['contractID']}&parkId=#{item['facilityID']}&api_key=#{$api_key}") do |response|
      if response.ok?
        data = Hpple.XML(response.body.to_str)
        result = data.xpath("/detailDescription/address").first unless data == nil
        @map.set_map_pin("#{result['streetAddress']} #{result['state']} #{result['zip']}") unless result == nil
        @tabbar.selectedIndex = 0
      end
    end
  end

  def set_campground_type(selection)
    CampgroundSearch.create(:type => $default_campground_type, :state => $default_campground_state, :created_at => Time.now) unless CampgroundSearch.all.size > 0
    setting = CampgroundSearch.all.first
    setting.type = selection
    setting.save
  end

  def set_campground_state(selection)
    CampgroundSearch.create(:type => $default_campground_type, :state => $default_campground_state, :created_at => Time.now) unless CampgroundSearch.all.size > 0
    setting = CampgroundSearch.all.first
    setting.state = selection
    setting.save
  end

  def load_navbar
    @window.rootViewController.navigationBar.topItem.title = 'Campground Search'
    @window.rootViewController.navigationBar.topItem.leftBarButtonItem = nil
    @window.rootViewController.navigationBar.topItem.rightBarButtonItem = nil
  end
end
