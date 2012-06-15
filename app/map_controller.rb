class MapController < UIViewController

  def viewDidLoad
    @@lat, @@lng = getCoordinates("1600%20Pennsylvania%20Avenue%20Washington%20DC")
    coordinate = CLLocationCoordinate2D.new(@@lat,@@lng)

    mapView = MKMapView.alloc.initWithFrame(view.bounds)
    mapView.delegate = self
    view.addSubview(mapView)

    setRegion(mapView, coordinate)
    setPin(mapView, coordinate)
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
    span = MKCoordinateSpan.new(0.52, 0.52)
    region = MKCoordinateRegion.new(coordinate, span)
    map.setRegion(region, animated: "YES")
  end

  def setPin(map, coordinate)
    marker = MKPointAnnotation.alloc.init
    marker.setCoordinate(coordinate)

    pin_view = MKPinAnnotationView.alloc.initWithAnnotation(@marker, reuseIdentifier: "id")
    pin_view.animatesDrop = true

    map.addAnnotation(marker)
    marker.setTitle('Campground')
  end

end
