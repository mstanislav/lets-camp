class MapController < UIViewController
  attr_accessor :window

  $default_address = '1600 Pennsylvania Ave NW Washington DC'
  $default_map_type = 2

  def viewDidLoad
    drawMap
  end

  def viewWillAppear(animated)
    drawMap
    loadNavBar
  end

  def loadNavBar
    @window.rootViewController.navigationBar.topItem.title = 'Campground Map'
    @window.rootViewController.navigationBar.topItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle('Settings', style: 0, target: UIApplication.sharedApplication.delegate, action: 'settings')
    @window.rootViewController.navigationBar.topItem.rightBarButtonItem = nil
  end

  def drawMap
    MapPin.create(:address => $default_address, :created_at => Time.now) unless MapPin.all.size > 0
    MapType.create(:type => $default_map_type, :created_at => Time.now) unless MapType.all.size > 0

    @@lat, @@lng = getCoordinates(view.url_encode(MapPin.all.first.address))
    checkCoordinates
    coordinate = CLLocationCoordinate2D.new(@@lat,@@lng)

    mapView = MKMapView.alloc.initWithFrame(view.bounds)
    mapView.mapType = MapType.all.first.type
    mapView.delegate = self

    view.addSubview(mapView)
    setRegion(mapView, coordinate)
    setPin(mapView, coordinate)
  end

  def checkCoordinates
    if @@lat == nil or @@lng == nil
      saveMapPin($default_address)
      @@lat, @@lng = getCoordinates(view.url_encode($default_address))
    end
  end

  def saveMapPin(address)
    pin = MapPin.all.first
    pin.address = address
    pin.save
  end

  def saveMapType(selection)
    type = MapType.all.first
    type.type = selection
    type.save
  end

  def getCoordinates(address)
    url = "http://maps.google.com/maps/api/geocode/json?address=#{address}&sensor=false"

    error_ptr = Pointer.new(:object)
    data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(url), options:NSDataReadingUncached, error:error_ptr)
    unless data
      raise error_ptr[0]
    end

    json = NSJSONSerialization.JSONObjectWithData(data, options:0, error:error_ptr)
    unless json
      raise error_ptr[0]
    end
   
    if json == nil or json['results'].size < 1
      return false
    end
    
    return [json['results'].first[:geometry][:location][:lat],json['results'].first[:geometry][:location][:lng]]
  end

  def setRegion(map, coordinate)
    span = MKCoordinateSpan.new(0.1, 0.1)
    region = MKCoordinateRegion.new(coordinate, span)
    map.setRegion(region, animated: "YES")
  end

  def setPin(map, coordinate, title = 'Campground')
    marker = MKPointAnnotation.alloc.init
    marker.setCoordinate(coordinate)

    pin_view = MKPinAnnotationView.alloc.initWithAnnotation(marker, reuseIdentifier: "id")

    map.addAnnotation(marker)
    marker.setTitle(title)
  end

end
