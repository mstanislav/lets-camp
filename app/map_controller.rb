class MapController < UIViewController
  $default_address = '1600 Pennsylvania Ave NW Washington DC'

  def viewDidLoad
    address = MapPin.all.first.address 

    if address == nil
      MapPin.create(:address => $default_address, :created_at => Time.now)
      address = MapPin.all.first.address 
    end

    drawMap(address)
  end

  def drawMap(address)
    saveMapPin(address)

    @@lat, @@lng = getCoordinates(view.url_encode(address))
    checkCoordinates
    coordinate = CLLocationCoordinate2D.new(@@lat,@@lng)

    mapView = MKMapView.alloc.initWithFrame(view.bounds)
    mapView.delegate = self

    setRegion(mapView, coordinate)
    setPin(mapView, coordinate)
  
    view.addSubview(mapView)
  end

  def checkCoordinates
    if @@lat == nil or @@lng == nil
      pin = MapPin.all.first
      pin.address = $default_address
      pin.save

      @@lat, @@lng = getCoordinates(view.url_encode($default_address))
    end
  end

  def saveMapPin(address)
    pin = MapPin.all.first
    pin.address = address
    pin.save
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

  def setPin(map, coordinate)
    marker = MKPointAnnotation.alloc.init
    marker.setCoordinate(coordinate)

    pin_view = MKPinAnnotationView.alloc.initWithAnnotation(marker, reuseIdentifier: "id")
    pin_view.animatesDrop = true

    map.addAnnotation(marker)
    marker.setTitle('Campground')
  end

end
