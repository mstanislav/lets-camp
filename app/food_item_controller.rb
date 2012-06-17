class FoodItemController < UIViewController
  attr_accessor :window

  def loadView
    self.view = UIView.alloc.init
    self.view.backgroundColor = UIColor.underPageBackgroundColor
  end

  def viewDidLoad
    create_label(label: 'Enter an item name', frame: [[10, 10], [300, 30]])
    @name = create_text_field(placeholder: 'e.g. Apples or Crackers', frame: [[10, 40], [300, 30]])

    create_label(label: 'Enter a quantity', frame: [[10, 80], [300, 30]])
    @quantity = create_text_field(placeholder: 'e.g. 10 or 1 Box', frame: [[10, 110], [300, 30]])
  end

  def viewWillAppear(animated)
    navigationItem.title = 'New Food Item'
    navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCancel, target:self, action:'cancel')
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemSave, target:self, action:'save')
    navigationController.setNavigationBarHidden(false, animated:true)

    @name.text = @quantity.text = nil
    @name.becomeFirstResponder
  end

  def cancel
    navigationController.popViewControllerAnimated(true)
  end

  def save
    return if !@name.text || @name.text.length < 1
    return if !@quantity.text || @quantity.text.length < 1
    FoodItems.create(:name => @name.text, :quantity => @quantity.text, :created_at => Time.now)
    navigationController.popViewControllerAnimated(true)
  end

private
  def create_text_field(params)
    text_field = UITextField.new
    text_field.font = UIFont.systemFontOfSize(20)
    text_field.placeholder = params[:placeholder]
    text_field.textAlignment = UITextAlignmentCenter
    text_field.textColor = UIColor.blackColor
    text_field.borderStyle = UITextBorderStyleRoundedRect
    text_field.frame = params[:frame]
    view.addSubview(text_field)
    text_field
  end

  def create_label(params)
    label = UILabel.new
    label.font = UIFont.systemFontOfSize(20)
    label.text = params[:label]
    label.textColor = UIColor.blackColor
    label.backgroundColor = UIColor.clearColor
    label.frame = params[:frame]
    view.addSubview(label)
  end
end
