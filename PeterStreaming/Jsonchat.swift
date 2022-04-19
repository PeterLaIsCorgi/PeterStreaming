import Foundation

// MARK: - SendElement
struct SendElement: Codable {
    let event, room_id: String?
    let sender_role: Int?
    let body: Body?
    let time: String?

   
}

// MARK: - Body
struct Body: Codable {
    let chat_id, account, nickname, recipient: String?
    let type, text, accept_time: String?
    let info: Info?
    let entry_notice: EntryNotice?
    let room_count, real_count: Int?
    let user_infos: UserInfos?
    let guardian_count, guardian_sum, contribute_sum: Int?
    let content: Content?
}

// MARK: - Content
struct Content: Codable {
    let cn, en, tw: String?
}

// MARK: - EntryNotice
struct EntryNotice: Codable {
    let username, head_photo, action: String?
    let other_badges: [String]?
    
}

// MARK: - Info
struct Info: Codable {
    let last_login, is_ban, level, is_guardian: Int?
    let badges: Bool?
}

struct UserInfos: Codable {
    var guardianlist, onlinelist: [String]?
}

let chatString = """
{"event":"default_message","room_id":"chat:app_test","sender_role":-1,"body":{"chat_id":"Np5zcTgsKXRMhAHA8GbWsb","account":"Np5zcTgsKXRMhAHA8GbWsb","nickname":"test1","recipient":"","type":"N","text":"測試測試測試測試測試測試","accept_time":"1645500950878612400","info":{"last_login":1645500887,"is_ban":0,"level":1,"is_guardian":0,"badges":null}},"time":"1645500950878669900"},{"event":"sys_updateRoomStatus","room_id":"chat:app_test","sender_role":0,"body":{"entry_notice":{"username":"test2","head_photo":"","action":"enter","entry_banner":{"present_type":"","img_url":"","main_badge":"","other_badges":[]}},"room_count":456,"real_count":6,"user_infos":{"guardianlist":[],"onlinelist":null},"guardian_count":0,"guardian_sum":0,"contribute_sum":0},"time":"1645503136460420600"},{"event":"admin_all_broadcast","room_id":"chat:all","sender_role":5,"body":{"content":{"cn":"英語內容","en":"簡體內容","tw":"繁體內容"}},"time":"1645503300012957315"}
"""
