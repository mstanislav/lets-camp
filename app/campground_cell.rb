class CampgroundCell < UITableViewCell
  CellID = 'CellIdentifier'

  def self.cellForCampground(item, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(CampgroundCell::CellID) || CampgroundCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
    cell.font = UIFont.systemFontOfSize(14)
    cell.textLabel.text = item != nil ? item['facilityName'] : ''
    cell.detailTextLabel.text = item != nil ? "Pets: #{item['sitesWithPetsAllowed']} - Sewer: #{item['sitesWithSewerHookup']} - Power: #{item['sitesWithAmps']} - Water: #{item['sitesWithWaterHookup']}" : ''
    cell
  end
end
