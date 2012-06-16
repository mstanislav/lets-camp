class SettingsController < UIViewController
  attr_accessor :window, :map

  def viewDidLoad
    self.view.backgroundColor = UIColor.underPageBackgroundColor
    address_input
  end

  def address_input
    address_input_label = UILabel.new
    address_input_label.font = UIFont.systemFontOfSize(18)
    address_input_label.text = "Enter a Campground Address"
    address_input_label.textAlignment = UITextAlignmentCenter
    address_input_label.textColor = UIColor.blackColor
    address_input_label.backgroundColor = UIColor.clearColor
    address_input_label.frame = [[10, 5], [250, 40]]
    view.addSubview(address_input_label)

    @address_input = add_text_field(frame: [[10, 45], [245, 30]])
    @address_input.delegate = self
    button = UIButton.buttonWithType UIButtonTypeRoundedRect
    button.addTarget(self, action:"set_address", forControlEvents: UIControlEventTouchDown)
    button.setTitle('Save', forState: UIControlStateNormal)
    button.frame = CGRectMake(265, 45, 50, 30)
    view.addSubview(button)
  end

  def set_address
    @address_input.resignFirstResponder
    address = @address_input.text != '' ? @address_input.text : MapPin.all.first.address
    @map.drawMap(address)
  end

  def textFieldShouldReturn(text_field)
    set_address unless text_field != @address_input
  end

private
  def add_text_field(params)
    text_field = UITextField.new
    text_field.font = UIFont.systemFontOfSize(16)
    text_field.text = MapPin.all.first.address
    text_field.textAlignment = UITextAlignmentCenter
    text_field.textColor = UIColor.blackColor
    text_field.backgroundColor = UIColor.whiteColor
    text_field.borderStyle = UITextBorderStyleRoundedRect
    text_field.keyboardType = params[:keyboardType] if params[:keyboardType]
    text_field.frame = params[:frame]
    view.addSubview(text_field)
    text_field
  end
end
