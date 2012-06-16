class MapController < UIViewController
  $default_address = '1600 Pennsylvania Ave NW Washington DC'
  $address = ''

  def viewDidLoad
    drawMap($default_address)
  end

  def drawMap(address)
    @@lat, @@lng = getCoordinates(view.url_encode(address))
    coordinate = CLLocationCoordinate2D.new(@@lat,@@lng)

    mapView = MKMapView.alloc.initWithFrame(view.bounds)
    mapView.delegate = self

    setRegion(mapView, coordinate)
    setPin(mapView, coordinate)
  
    view.addSubview(mapView)
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
