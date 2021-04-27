//
//  RoomsViewController.swift
//  Krakodil
//
//  Created by Nikita Gura on 29/10/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import UIKit

class RoomsViewController: UIViewController, Storyboarded{
    
    @IBOutlet weak var roomsTableView: UITableView!
    @IBOutlet weak var nickNameText: UILabel!
    var refreshControl = UIRefreshControl()
    
    var rooms: [Room] = []
    var nickName: String?
    var socketProvider: SocketProvider = SocketProvider()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        navigationItem.setHidesBackButton(true, animated: false)
        let nibCell = UINib(nibName: CellNames.roomCollectionViewCell, bundle: nil)
        roomsTableView.register(nibCell, forCellReuseIdentifier: CellNames.roomCollectionViewCell)
        nickNameText.text = nickName
        refreshControl.addTarget(self, action: #selector(self.fetchRooms), for: .valueChanged)
        roomsTableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        fetchRooms()
    }
    
    func getUserData(){
        if let nickName =  UserDefaults.standard.string(forKey: UserDefaultsNames.user_name){
            let deviceId = UIDevice.current.identifierForVendor?.uuidString
            user = User(name: nickName, id_device: deviceId!)
        }
    }
    
   @objc func fetchRooms(){
        fetchAllRooms { (rooms) in
            self.rooms = rooms ?? []
            self.roomsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    @IBAction func refreshRoomsAction(_ sender: Any) {
        fetchRooms()
    }
    
    @IBAction func createGame(_ sender: Any) {
        let alert = UIAlertController(title: Strings.ROOMS_GREATE_GAME, message: Strings.ROOMS_NAME, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = Strings.ROOMS_INPUT_NAME
        })
        
        alert.addAction(UIAlertAction(title: Strings.GENERAL_YES, style: .default) {_ in
            if (alert.textFields![0].text?.count ?? 0 > 4) {
                let id_room = UUID().uuidString
                let room = Room(name: alert.textFields![0].text!, id_room: id_room, room_users: nil, room_points: nil)
                createRoom(room: room) {
                    let drawingViewController = DrawingViewController.instantiate()
                    drawingViewController.socketProvider = self.socketProvider
                    drawingViewController.room = room
                    drawingViewController.user = self.user
                    self.navigationController?.pushViewController(drawingViewController, animated: true)
                } errorResponse: {
                   // TODO: Analytics error
                }
            }else{
                self.showErrorName()
            }
        })
        alert.addAction(UIAlertAction(title: Strings.GENERAL_NO, style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    func showErrorName(){
        let alertError = UIAlertController(title: Strings.ROOMS_ROOM_NAME_IS_SMALL, message: Strings.ROOMS_ROOM_NAME_IS_SMALL, preferredStyle: .alert)
        alertError.addAction(UIAlertAction(title: Strings.GENERAL_YES, style: .default, handler: nil))
        self.present(alertError, animated: true)
    }

}

extension RoomsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = rooms[indexPath.row]
        getRoom(room: room) { (room) in
            if(room.room_users?.count ?? 0 < 8){
                let drawingViewController = DrawingViewController.instantiate()
                drawingViewController.socketProvider = self.socketProvider
                drawingViewController.room = room
                drawingViewController.user = self.user
                self.navigationController?.pushViewController(drawingViewController, animated: true)
            }else {
                //TODO popup room is full
            }
           
        } errorResponse: {
            // TODO Analytics
        }

        
       
    }
}

extension RoomsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = roomsTableView.dequeueReusableCell(withIdentifier: CellNames.roomCollectionViewCell) as! RoomTableViewCell
        cell.room = rooms[indexPath.row]
        return cell
    }
    
    
}
