class SuppliesController < UITableViewController
  attr_accessor :window, :item

  def viewWillAppear(animated)
    @items = SuppliesItems.all
    loadNavBar
    view.reloadData
  end

  def loadNavBar
    @window.rootViewController.navigationBar.topItem.title = 'Supplies'
    @window.rootViewController.navigationBar.topItem.leftBarButtonItem = editButtonItem
    @window.rootViewController.navigationBar.topItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'addSuppliesItem')
  end

  def addSuppliesItem
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
    item = SuppliesItems.find(:name, NSFEqualTo, @items[indexPath.row].name).first
    item.delete
    @items = SuppliesItems.all
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
  end
end
