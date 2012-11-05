class MapController < UIViewController
  attr_accessor :window

  $default_address = '1600 Pennsylvania Ave NW Washington DC'
  $default_map_type = 2

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(true, animated:true)
    draw_map
  end

  def set_region(map, coordinate)
    span = MKCoordinateSpan.new(0.1, 0.1)
    region = MKCoordinateRegion.new(coordinate, span)
    map.setRegion(region, animated: 'YES')
  end

  def draw_map
    MapPin.create(:address => $default_address, :created_at => Time.now) unless MapPin.all.size > 0
    MapType.create(:type => $default_map_type, :created_at => Time.now) unless MapType.all.size > 0

    @@lat, @@lng = get_coordinates(view.url_encode(MapPin.all.first.address))
    check_coordinates

    if @@lat != nil and @@lng != nil
      coordinate = CLLocationCoordinate2D.new(@@lat, @@lng) 

      map = MKMapView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
      map.mapType = MapType.all.first.type
      map.delegate = self

      view.addSubview(map)
      set_region(map, coordinate)
      set_pin(map, coordinate)
    else
      map_load_failed
    end
  end

  def map_load_failed
    label = UILabel.new
    label.font = UIFont.systemFontOfSize(26)
    label.text = "Unable to load map data.\nPlease check your internet connection."
    label.textAlignment = UITextAlignmentCenter
    label.textColor = UIColor.whiteColor
    label.backgroundColor = UIColor.clearColor
    label.lineBreakMode = UILineBreakModeWordWrap
    label.numberOfLines = 0
    label.frame = [[10, 110], [300, 90]]
    view.addSubview(label)
  end

  def check_coordinates
    if @@lat == nil or @@lng == nil
      set_map_pin($default_address)
      @@lat, @@lng = get_coordinates(view.url_encode($default_address))
    end
  end

  def set_map_pin(address)
    pin = MapPin.all.first
    pin.address = address
    pin.save
  end

  def set_map_type(selection)
    type = MapType.all.first
    type.type = selection
    type.save
  end

  def get_coordinates(address)
    url = "http://maps.google.com/maps/api/geocode/json?address=#{address}&sensor=false"

    error_ptr = Pointer.new(:object)
    data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(url), options:NSDataReadingUncached, error:error_ptr)

    json = NSJSONSerialization.JSONObjectWithData(data, options:0, error:error_ptr) unless data == nil
   
    if json == nil or json['results'].size < 1
      return false
    end
    
    return [json['results'].first[:geometry][:location][:lat],json['results'].first[:geometry][:location][:lng]]
  end

  def set_pin(map, coordinate, title = 'Campground')
    marker = MKPointAnnotation.alloc.init
    marker.setCoordinate(coordinate)
    marker.setTitle(title)
    map.addAnnotation(marker)
    MKPinAnnotationView.alloc.initWithAnnotation(marker, reuseIdentifier: 'id') 
  end

end
