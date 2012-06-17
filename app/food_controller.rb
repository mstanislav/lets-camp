class FoodController < UITableViewController
  attr_accessor :window, :item

  def viewWillAppear(animated)
    @items = FoodItems.all
    loadNavBar
    view.reloadData
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
    @items.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    ItemCell.cellForItem(@items[indexPath[1]], inTableView:tableView)
  end

  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    item = FoodItems.find(:name, NSFEqualTo, @items[indexPath.row].name).first
    item.delete
    @items = FoodItems.all
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
  end
end
