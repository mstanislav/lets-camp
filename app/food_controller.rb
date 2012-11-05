class FoodController < UITableViewController
  attr_accessor :window, :item

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:true)
    @items = FoodItems.all
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
    FoodItems.find(:name, NSFEqualTo, @items[indexPath.row].name).first.delete unless FoodItems.find(:name, NSFEqualTo, @items[indexPath.row].name).size == 0
    @items = FoodItems.all
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
  end

  def load_navbar
    @window.rootViewController.navigationBar.topItem.title = 'Food'
    @window.rootViewController.navigationBar.topItem.leftBarButtonItem = editButtonItem
    @window.rootViewController.navigationBar.topItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add_food_item')
  end

  def add_food_item
    navigationController.pushViewController(@item, animated:true)
  end
end
