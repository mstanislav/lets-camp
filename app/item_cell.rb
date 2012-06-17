class ItemCell < UITableViewCell
  CellID = 'CellIdentifier'

  def self.cellForItem(item, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(ItemCell::CellID) || ItemCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:CellID)
    cell.textLabel.text = item.name
    cell.detailTextLabel.text = item.quantity
    cell
  end
end
