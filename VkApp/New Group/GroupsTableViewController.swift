//
//  GroupsTableViewController.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 12.06.2023.
//

import UIKit

class GroupsTableViewController: UITableViewController {
    
    var groups = [Group]() {
        didSet {
//            tableView.reloadData()
        }
    }
    
        // Метод для добавления группы в список и обновления таблицы
//        func addGroup(group: Group) {
//            // Проверяем, что группы еще нет в списке, чтобы избежать повторного добавления
//            if !self.groups.contains(group) {
//                // Добавляем группу в список
//                self.groups.append(group)
//                // Сохраняем изменения и обновляем таблицу
//            }
//        }

        // ... (остальной код класса)
    var groupsResponse: [GroupsRequestName] = []

    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard
            // делаю проверку
            segue.identifier == "addGroup",
            // обращаюсь ко всем группам и кастю
            let allGroupController = segue.source as? AllGroupsTableViewController,
                        // нужен индекс нажатой ячейки
            let groupIndexPath = allGroupController.tableView.indexPathForSelectedRow,
            // чтобы не было повторений
            !self.groups.contains(allGroupController.group[groupIndexPath.section])
        else { return }
        self.groups.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        self.groups.append(allGroupController.group[groupIndexPath.section])
        tableView.reloadData()
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "GroupTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "groupCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        APIManager.shared.fetchGroups { [weak self] result in
            switch result {
            case .success(let groups):
                self?.handleRequestGroups(groups)
            case .failure(let error):
                print(error)
            }
                
        }
    }
    
    //MARK: - Actions
    func handleRequestGroups(_ groupsResponse: GroupsRequest) {
        self.groupsResponse = groupsResponse.response.items
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        groupsResponse.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupTableViewCell
        else { return UITableViewCell() }
        let groupsResponse = groupsResponse[indexPath.row]
        
        cell.configure(groups: groupsResponse)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        super.tableView(tableView, didSelectRowAt: indexPath)
        defer { tableView.deselectRow(at: indexPath, animated: true) }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)

            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
