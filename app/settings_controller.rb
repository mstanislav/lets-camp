class SettingsController < UIViewController
  attr_accessor :window, :map, :camp

  $states = { 'AL' => 'Alabama', 'AB' => 'Alberta', 'AK' => 'Alaska', 'AZ' => 'Arizona', 'AR' => 'Arkansas', 'BC' => 'British Columbia', 
              'CA' => 'California', 'CO' => 'Colorado', 'CT' => 'Connecticut', 'DE' => 'Delaware', 'FL' => 'Florida', 'GA' => 'Georgia',
              'HI' => 'Hawaii', 'ID' => 'Idaho', 'IL' => 'Illinois', 'IN' => 'Indiana', 'IA' => 'Iowa','KS' => 'Kansas', 'KY' => 'Kentucky',
              'LA' => 'Louisiana', 'ME' => 'Maine', 'MB' => 'Manitoba', 'MD' => 'Maryland', 'MA' => 'Massachusetts', 'MI' => 'Michigan',
              'MN' => 'Minnesota', 'MS' => 'Mississippi', 'MO' => 'Missouri', 'MT' => 'Montana', 'NE' => 'Nebraska', 'NV' => 'Nevada', 
              'NB' => 'New Brunswick', 'NH' => 'New Hampshire', 'NJ' => 'New Jersey', 'NM' => 'New Mexico', 'NY' => 'New York',
              'NL' => 'Newfoundland and Labrador', 'NC' => 'North Carolina', 'ND' => 'North Dakota', 'NT' => 'Northwest Territories',
              'NS' => 'Nova Scotia', 'NU' => 'Nunavut', 'OH' => 'Ohio', 'OK' => 'Oklahoma', 'ON' => 'Ontario', 'OR' => 'Oregon',
              'PA' => 'Pennsylvania', 'PE' => 'Prince Edward Island', 'QC' => 'Quebec', 'RI' => 'Rhode Island', 'SK' => 'Saskatchewan',
              'SC' => 'South Carolina', 'SD' => 'South Dakota', 'TN' => 'Tennessee', 'TX' => 'Texas', 'UT' => 'Utah', 'VT' => 'Vermont',
              'VA' => 'Virginia', 'WA' => 'Washington', 'WV' => 'West Virginia', 'WI' => 'Wisconsin', 'WY' => 'Wyoming', 'YT' => 'Yukon' }
  $states_array = []
  $states.each { |key,value| $states_array << value  }

  def viewDidLoad
    self.view.backgroundColor = UIColor.underPageBackgroundColor
    address_input
    reset_buttons
    mapTypeSelector
    siteTypeSelector
    stateSelector
  end

  def address_input
    add_label(18, 'Enter a Campground Address', 25, 5)
    @address_input = add_text_field(text: MapPin.all.first.address, frame: [[10, 40], [265, 25]])
    @address_input.delegate = self
    button = UIButton.buttonWithType UIButtonTypeRoundedRect
    button.addTarget(self, action:"set_address", forControlEvents: UIControlEventTouchDown)
    button.setTitle('Set', forState: UIControlStateNormal)
    button.frame = CGRectMake(280, 40, 30, 25)
    view.addSubview(button)
  end

  def mapTypeSelector
    add_label(18, 'Campground Map Style', 25, 75)
    @mapType = UISegmentedControl.alloc.initWithItems(['Map', 'Satellite', 'Hybrid', 'Topological']).tap do |w|
      w.frame = [[10, 110], [view.bounds.size.width - 20, 30]]
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
    add_label(18, 'Campground Site Need', 25, 150)
    @siteType = UISegmentedControl.alloc.initWithItems(['RV', 'Cabin', 'Tent', 'Horse', 'Boat']).tap do |w|
      w.frame = [[10, 185], [view.bounds.size.width - 20, 30]]
      w.segmentedControlStyle = UISegmentedControlStyleBar
      w.addTarget(self, action:'siteSelect:', forControlEvents:UIControlEventValueChanged)
      w.selectedSegmentIndex = CampgroundSearch.all.size > 0 ? $campground_site_types.invert[CampgroundSearch.all.first.type].to_i : $campground_site_types.invert[$default_campground_type].to_i
      view.addSubview(w)
    end
  end

  def siteSelect(selector)
    @camp.saveCampgroundType($campground_site_types[@siteType.selectedSegmentIndex])
  end

  def stateSelector
    add_label(18, 'State/Province for Campgrounds', 20, 225)
    @picker = UIPickerView.new
    @picker.showsSelectionIndicator = true
    @picker.delegate = self
    @picker.selectRow(CampgroundSearch.all.size > 0 ? $states_array.index($states[CampgroundSearch.all.first.state]) : $states_array.index($states[$default_campground_state]), inComponent:0, animated: false)
    @state = add_text_field(text: CampgroundSearch.all.size > 0 ? $states[CampgroundSearch.all.first.state] : $states[$default_campground_state],frame: [[10, 260], [300, 25]])
    @state.setInputView(@picker)
    toolbar = UIToolbar.new
    toolbar.frame = CGRectMake(265, 220, 55, 25)
    toolbar.delegate = self
    toolbar.barStyle = UIBarStyleBlackTranslucent
    @state.inputAccessoryView = toolbar
    leftSpace = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
    doneButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemDone, target:self, action:'set_campground_state')
    toolbar.setItems([leftSpace, doneButton], animated:false)
  end

  def set_campground_state
    @state.resignFirstResponder
    @camp.saveCampgroundState($states.invert[@state.text])
  end

  def numberOfComponentsInPickerView(pickerView)
    1
  end

  def pickerView(pickerView, numberOfRowsInComponent:component)
    $states_array.size
  end

  def pickerView(pickerView, titleForRow:row, forComponent:component)
    $states_array[row].to_s
  end

  def pickerView(pickerView, didSelectRow:row, inComponent:component)
    @state.text = $states_array[row]
  end

  def reset_buttons
    add_label(18, 'Reset Item List Data Storage', 25, 295)
    add_reset_button('supplies', 20, 330)
    add_reset_button('food', 180, 330)
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
  end

  def textFieldShouldReturn(text_field)
    set_address unless text_field != @address_input
    set_campground_state unless text_field != @state
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
    label.frame = [[x, y], [275, 40]]
    view.addSubview(label)
  end

  def add_text_field(params)
    text_field = UITextField.new
    text_field.font = UIFont.systemFontOfSize(16)
    text_field.text = params[:text]
    text_field.textAlignment = UITextAlignmentCenter
    text_field.textColor = UIColor.blackColor
    text_field.backgroundColor = UIColor.whiteColor
    text_field.borderStyle = UITextBorderStyleRoundedRect
    text_field.frame = params[:frame]
    view.addSubview(text_field)
    text_field
  end
end
