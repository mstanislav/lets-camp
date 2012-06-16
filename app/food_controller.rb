class FoodController < UITableViewController
  attr_accessor :window, :item

  def loadView
    self.view = UITableView.alloc.init
  end

  def viewDidLoad
    loadNavBar
    view.reloadData
  end

  def viewWillAppear(animated)
    loadNavBar
  end

  def loadNavBar
    @window.rootViewController.navigationBar.topItem.title = 'Food'
    @window.rootViewController.navigationBar.topItem.leftBarButtonItem = editButtonItem
    @window.rootViewController.navigationBar.topItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'addFoodItem')
  end

  def addFoodItem
    navigationController.pushViewController(@item, animated:true)
  end

  def tableView(tableView, numberOfRowsInSection:section)
    #TODO: Size of FoodItem array
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:CellID)
      cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
      cell
    end
    item = get_row(indexPath.row)

    cell.textLabel.text = item.name
    cell.detailTextLabel.text = player.quantity
    cell
  end

  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    item = get_row(indexPath.row)
    #TODO: Delete item
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
  end

private
  def get_row(row)
    #TODO: Get selected row?
  end
end
