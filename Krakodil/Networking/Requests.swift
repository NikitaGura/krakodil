//
//  Requests.swift
//  Krakodil
//
//  Created by Nikita Gura on 01/11/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import Foundation
import Alamofire


func fetchAllRooms(completion: @escaping ([Room]?) -> Void) {
    AF.request(ServerAPI.domian+ServerAPI.get_rooms, method: .get, encoding: URLEncoding.default).response {
        ( response) in
            guard let data = response.data else { return }
        do {
            let roomsResponse = try JSONDecoder().decode(RoomsResponse.self, from: data)
            completion(roomsResponse.rooms)
        } catch {
            completion(nil)
            print("Parse room error: \(error)")
        }
    }
}

func createRoom(room: Room, completion: @escaping () -> Void, errorResponse: @escaping () -> Void) {
        AF.request(ServerAPI.domian+ServerAPI.add_room, method: .post, parameters: [Naming.name: room.name, Naming.id_room: room.id_room], encoding: URLEncoding.default).response {
            ( response) in
                guard let data = response.data else { return }
            do {
                let createRoomResponse = try JSONDecoder().decode(CreateRoomResponse.self, from: data)
                if let status = createRoomResponse.status {
                    if(status == Strings.GENERAL_CREATED){
                        completion()
                    }
                }
            } catch {
                errorResponse()
                print("Parse room error: \(error)")
            }
        }
}

func getRoom(room: Room, completion: @escaping (Room) -> Void, errorResponse: @escaping () -> Void) {
    AF.request(ServerAPI.domian+ServerAPI.get_room, method: .post, parameters: [Naming.id_room: room.id_room], encoding: URLEncoding.default).response {
            ( response) in
                guard let data = response.data else { return }
            do {
                let room = try JSONDecoder().decode(Room.self, from: data)
                completion(room)
            } catch {
                errorResponse()
                print("Parse room error: \(error)")
                
            }
        }
}
