class MapController < UIViewController

  def viewDidLoad
    @@lat, @@lng = getCoordinates("1600%20Pennsylvania%20Avenue%20Washington%20DC")
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

end
