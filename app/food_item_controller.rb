class FoodItemController < UIViewController
  attr_accessor :window

  def loadView
    self.view = UIView.alloc.init
    self.view.backgroundColor = UIColor.whiteColor
  end

  def viewDidLoad
    @item = create_text_field(placeholder: 'Enter an item name', frame: [[10, 20], [300, 30]])
    @quantity = create_text_field(placeholder: 'Enter a quantity', frame: [[10, 90], [300, 30]])
  end

  def viewWillAppear(animated)
    navigationItem.title = 'New Food Item'
    navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCancel, target:self, action:'cancel')
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemSave, target:self, action:'save')
    navigationController.setNavigationBarHidden(false, animated:true)

    @item.text = nil
    @quantity.text = nil
  end

  def cancel
    navigationController.popViewControllerAnimated(true)
  end

  def save
    return if !@item.text || @item.text.length < 1
    return if !@quantity.text || @quantity.text.length < 1

    # TODO: ADD ITEM
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
