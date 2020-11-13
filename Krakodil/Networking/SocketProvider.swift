//
//  SocketProvider.swift
//  Krakodil
//
//  Created by Nikita Gura on 11/10/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import Foundation
import SocketIO

public class SocketProvider{
    var socket: SocketIOClient!
    var manager: SocketManager!
    
    init() {
        manager = SocketManager(socketURL: URL(string: SocketAPI.domian)!, config: [.log(true), .compress])
        socket =  manager.defaultSocket
        socket.connect()
    }
    
    func emitJoinToRoom(room: Room){
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        if let nickName =  UserDefaults.standard.string(forKey: UserDefaultsNames.user_name){
            socket.emit(SocketAPI.event_user_join_to_room, [
                Naming.room: [Naming.id_room: room.id_room],
                Naming.user: [Naming.name: nickName, Naming.id_device: deviceId]
            ])
        }
    }
    
    func emitLeaveRoom(room: Room){
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        if let nickName =  UserDefaults.standard.string(forKey: UserDefaultsNames.user_name){
            socket.emit(SocketAPI.event_user_disconnect_from_room, [
                Naming.room: [Naming.id_room: room.id_room],
                Naming.user: [Naming.name: nickName, Naming.id_device: deviceId]
            ])
        }
    }
    
    func emitDraw(line: Line, room: Room){
        let points = line.points.map({[Naming.x :$0.x, Naming.y: $0.y]})
        socket.emit(SocketAPI.eventDraw, [Naming.line: [Naming.points: points,
                                                        Naming.colorLine: line.color.rgbJSON(),
                                                        Naming.widthLine: line.width],
                                          Naming.id_room: room.id_room])
    }
    
    func emitCleanLines(room: Room){
        socket.emit(SocketAPI.eventCleanLines,[Naming.isClean: true, Naming.id_room: room.id_room])
    }
    
    func onCleanLines(completion: @escaping  (_ isClean: Bool)->()){
        socket.on(SocketAPI.eventCleanLines){ data, ack  in
            let string = data[0] as! String
            let response = string.data(using: .utf8)!
            do {
                let cleanBool = try JSONDecoder().decode(CleanBool.self, from: response)
                completion(cleanBool.is_Clean)
            }
            catch let error as NSError {
                print(error)
            }
        }
    }
    
    func onDraw(completion: @escaping  (_ line: Line)->()){
        socket.on(SocketAPI.eventDraw){ data, ack  in
            let string = data[0] as! String
            let response = string.data(using: .utf8)!
            do {
                let lineResponse = try JSONDecoder().decode(LineResponse.self, from: response)
                completion(mapResponse(lineResponse: lineResponse))
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func sendMessage(room: Room, user: User, message: String){
        socket.emit(SocketAPI.event_send_message_room, [Naming.id_room: room.id_room,
                                                               Naming.user: [Naming.name: user.name, Naming.id_device: user.id_device],
                                                               Naming.message: message])

    }
    
    func onMessage(completion: @escaping  (_ message: Message)->()){
        socket.on(SocketAPI.event_message_room) { data, ack in
            let string = data[0] as! String
            let response = string.data(using: .utf8)!
            do {
                let message = try JSONDecoder().decode(Message.self, from: response)
                completion(message)
            } catch let error as NSError {
                print(error)
                
            }
        }
    }
    
    func onSelectPainter(completion: @escaping  (_ selectPainterResponse: SelectPainterResponse)->()) {
        socket.on(SocketAPI.event_select_painter){ data, ack in
            let string = data[0] as! String
            let response = string.data(using: .utf8)!
            do {
                let selectPainterResponse = try JSONDecoder().decode(SelectPainterResponse.self, from: response)
                completion(selectPainterResponse)
            } catch let error as NSError {
                print(error)
                
            }
        }
    }
    
    func onOnePlayerLeft(completion: @escaping ()->()){
        socket.on(SocketAPI.event_one_player_left){ data, ack in
            completion()
        }
    }
    
    func onConnectUserRoom(completion: @escaping (_ user: User)->()){
        socket.on(SocketAPI.event_user_connected_to_room){ data, ack in
            let string = data[0] as! String
            let response = string.data(using: .utf8)!
            do {
                let user = try JSONDecoder().decode(User.self, from: response)
                completion(user)
            } catch let error as NSError {
                print(error)
            }
        }
    }
    func onLeaveUserRoom(completion: @escaping (_ user: User)->()){
        socket.on(SocketAPI.event_user_leave_from_room){ data, ack in
            let string = data[0] as! String
            let response = string.data(using: .utf8)!
            do {
                let user = try JSONDecoder().decode(User.self, from: response)
                completion(user)
            } catch let error as NSError {
                print(error)
                
            }
        }
    }
    
    func emitGetWinner(user: User, room: Room, selectWord: String){
        socket.emit(SocketAPI.event_get_winner, [Naming.user: [Naming.name: user.name, Naming.id_device: user.id_device], Naming.id_room: room.id_room, Naming.select_word: selectWord])
    }
    
    func onSendWinner(completion: @escaping (_ user: WinnerResponse)->()){
        socket.on(SocketAPI.event_send_winner){ data, ack in
            let string = data[0] as! String
            let response = string.data(using: .utf8)!
            do {
                let winnerResponse = try JSONDecoder().decode(WinnerResponse.self, from: response)
                completion(winnerResponse)
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func emitClosePopupSelector(room: Room){
        socket.emit(SocketAPI.event_close_popup_selector, [Naming.id_room: room.id_room])
    }
    
    func onSendClosePopupSelector(completion: @escaping ()->()){
        socket.on(SocketAPI.event_send_close_popup_selector){ data, ack in
            completion()
        }
    }
    
    func emitMinusGameSecond(seconds: String, room: Room){
        socket.emit(SocketAPI.event_minus_game_second, [Naming.seconds: seconds, Naming.id_room: room.id_room])
    }
    
    func onSendMinusGameSecond(completion: @escaping (_ seconds: String)->()){
        socket.on(SocketAPI.event_send_minus_game_second) { data, ack in
            let string = data[0] as! String
            let response = string.data(using: .utf8)!
            do {
                let secondsResponse = try JSONDecoder().decode(SecondsResponse.self, from: response)
                completion(secondsResponse.seconds)
            } catch let error as NSError {
                print(error)
            }
        }
    }
}

