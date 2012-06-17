class SuppliesItemController < UIViewController
  attr_accessor :window

  def loadView
    self.view = UIView.alloc.init
    self.view.backgroundColor = UIColor.underPageBackgroundColor
  end

  def viewDidLoad
    @name = create_text_field(placeholder: 'Enter an item name', frame: [[10, 20], [300, 30]])
    @quantity = create_text_field(placeholder: 'Enter am item quantity', frame: [[10, 90], [300, 30]])
  end

  def viewWillAppear(animated)
    navigationItem.title = 'New Supplies Item'
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
    SuppliesItems.create(:name => @name.text, :quantity => @quantity.text, :created_at => Time.now)
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
    text_field.keyboardType = params[:keyboardType] if params[:keyboardType]
    text_field.frame = params[:frame]
    view.addSubview(text_field)
    text_field
  end
end
