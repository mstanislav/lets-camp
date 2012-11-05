class SuppliesController < UITableViewController
  attr_accessor :window, :item

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:true)
    @items = SuppliesItems.all
    load_navbar
    view.reloadData
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
    SuppliesItems.find(:name, NSFEqualTo, @items[indexPath.row].name).first.delete unless SuppliesItems.find(:name, NSFEqualTo, @items[indexPath.row].name).size == 0
    @items = SuppliesItems.all
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
  end

  def load_navbar
    @window.rootViewController.navigationBar.topItem.title = 'Supplies'
    @window.rootViewController.navigationBar.topItem.leftBarButtonItem = editButtonItem
    @window.rootViewController.navigationBar.topItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add_supplies_item')
  end

  def add_supplies_item
    navigationController.pushViewController(@item, animated:true)
  end
end
