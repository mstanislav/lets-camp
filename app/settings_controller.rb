class SettingsController < UIViewController
  attr_accessor :window, :map, :camp

  def viewDidLoad
    self.view.backgroundColor = UIColor.underPageBackgroundColor
    address_input
    reset_buttons
    mapTypeSelector
    siteTypeSelector
  end

  def address_input
    add_label(18, 'Enter a Campground Address', 30, 5)
    @address_input = add_text_field(frame: [[10, 40], [245, 25]])
    @address_input.delegate = self
    button = UIButton.buttonWithType UIButtonTypeRoundedRect
    button.addTarget(self, action:"set_address", forControlEvents: UIControlEventTouchDown)
    button.setTitle('Save', forState: UIControlStateNormal)
    button.frame = CGRectMake(265, 40, 50, 25)
    view.addSubview(button)
  end

  def mapTypeSelector
    add_label(18, 'Campground Map Style', 30, 75)
    @mapType = UISegmentedControl.alloc.initWithItems(['Map', 'Satellite', 'Hybrid', 'Topological']).tap do |w|
      w.frame = [[0, 110], [view.bounds.size.width, 30]]
      w.segmentedControlStyle = UISegmentedControlStyleBar
      w.addTarget(self, action:'mapSelect:', forControlEvents:UIControlEventValueChanged)
      w.selectedSegmentIndex = MapType.all.first.type != nil ? MapType.all.first.type : $default_map_type
      view.addSubview(w)
    end
  end

  def mapSelect(selector)
    @map.saveMapType(@mapType.selectedSegmentIndex) 
  end

  def siteTypeSelector
    add_label(18, 'Campground Site Need', 30, 150)
    @siteType = UISegmentedControl.alloc.initWithItems(['RV', 'Cabin', 'Tent', 'Horse', 'Boat']).tap do |w|
      w.frame = [[0, 185], [view.bounds.size.width, 30]]
      w.segmentedControlStyle = UISegmentedControlStyleBar
      w.addTarget(self, action:'siteSelect:', forControlEvents:UIControlEventValueChanged)
      w.selectedSegmentIndex = CampgroundSearch.all.first.type != nil ? $campground_site_types.invert[CampgroundSearch.all.first.type] : $campground_site_types.invert[$default_campground_type]
      view.addSubview(w)
    end
  end

  def siteSelect(selector)
    @camp.saveCampgroundType($campground_site_types[@siteType.selectedSegmentIndex])
  end

  def reset_buttons
    add_label(18, 'Reset Item List Data Storage', 30, 225)
    add_reset_button('supplies', 20, 260)
    add_reset_button('food', 180, 260)
  end

  def reset_food
    show_alert('Food', "Selecting 'Confirm' will delete all of your current 'Food' items", 'Confirm')
  end

  def reset_supplies
    show_alert('Supplies', "Selecting 'Confirm' will delete all of your current 'Supplies' items", 'Confirm')
  end

  def set_address
    @address_input.resignFirstResponder
    address = @address_input.text != '' ? @address_input.text : MapPin.all.first.address
    @map.saveMapPin(address)
    @map.drawMap
    navigationController.popViewControllerAnimated(true)
  end

  def textFieldShouldReturn(text_field)
    set_address unless text_field != @address_input
  end

  def alertView(alertView, didDismissWithButtonIndex:buttonIndex)
    if alertView.title.lowercaseString == 'food'
      FoodItems.delete unless buttonIndex != 1
    elsif alertView.title.lowercaseString == 'supplies'
      SuppliesItems.delete unless buttonIndex != 1
    end
  end

private
  def show_alert(title, message, button)
    alert = UIAlertView.alloc.initWithTitle(title, message:message, delegate:self, cancelButtonTitle:"Cancel", otherButtonTitles:'Confirm', nil)
    alert.show
  end

  def add_reset_button(controller, x, y)
    button = UIButton.buttonWithType UIButtonTypeRoundedRect
    button.addTarget(self, action: "reset_#{controller}", forControlEvents: UIControlEventTouchDown)
    button.setTitle("Reset #{controller.capitalizedString}", forState: UIControlStateNormal)
    button.frame = CGRectMake(x, y, 120, 30)
    view.addSubview(button)
  end

  def add_label(font, text, x, y)
    label = UILabel.new
    label.font = UIFont.systemFontOfSize(font)
    label.text = text
    label.textAlignment = UITextAlignmentCenter
    label.textColor = UIColor.blackColor
    label.backgroundColor = UIColor.clearColor
    label.frame = [[x, y], [250, 40]]
    view.addSubview(label)
  end

  def add_text_field(params)
    text_field = UITextField.new
    text_field.font = UIFont.systemFontOfSize(16)
    text_field.text = MapPin.all.first.address
    text_field.textAlignment = UITextAlignmentCenter
    text_field.textColor = UIColor.blackColor
    text_field.backgroundColor = UIColor.whiteColor
    text_field.borderStyle = UITextBorderStyleRoundedRect
    text_field.frame = params[:frame]
    view.addSubview(text_field)
    text_field
  end
end
