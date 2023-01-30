
import Foundation
import UIKit
import StreamChat
import StreamChatUI


// appidL (production) 1230208
// appid (development) 1230209
// pub rhde4ntthd8m
// priv kzpw3k6m79vfrvxeh3mxe9uawdamev523j8cj3em2j2gg94pyyam7mukcdave4dz

final class ChatManager {
    
    static let shared = ChatManager()
    private var client : ChatClient!
    
    private var isSignedOn : Bool { return false }
    private var currentUser: String? { return client.currentUserId }
    private var connectionStatus: Any? { return client.connectionStatus }
    private var baseURL: Any? { return client.config.baseURL}
    
    
    
    // MARK: API SETUP
    public let APIkeys = [
        "you": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoieW91In0.DRCr7JkI486XvALSVGTx0r76xJXGLJ88kQ0SMNcPxJ8",
        "me": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWUifQ.orBOu9HsVfGDs_2d5Y1yoIhjaE2JLUxCEPvqAg_-xrQ"
    ]
    
    public func APISetUp() {
        let client = ChatClient(config: .init(apiKey: .init("393gh67jgafprkuhzyzc6wr8q3vzhveft3dw8s73us9xyq6z9z5g9cczk62f289z")))
        self.client = client
    }
    //** fin
    
    
    
    // MARK: API Functionallity
    
    public func userSignIn(with userName : String, completion: @escaping (Bool) -> Void ) {
        print("[+] Start, client logging in..")
        print("[!] STATS: [USER] \(String(describing: currentUser)) [STATUS]: [\(String(describing: connectionStatus)) \(String(describing: baseURL))")
        
        // TODO: ADD ALERT TO SCREEN
        guard !userName.isEmpty else {
            completion (false)
            print(APIError.userNameError)
            return
        }
        guard let token = APIkeys[userName.lowercased()] else {
            completion(false)
            print(APIError.tokenError)
            print(ErrorPayload.self)
            return
        }
        
        print("[!] Token to be used \(token)")
        // uses ^^ userName && token to connect API
        client.connectUser(userInfo: UserInfo(id: userName,
                                              name: userName),
                           token: Token(stringLiteral: token))
        // closure,if error is nill then close out.
        { error in
            completion(error == nil)
        }
        print("[!] Error.. ")
        
    }
    
    
    public func userSignOut() {
        print("[+] End, client = \(String(describing: currentUser)) logged off [[\(String(describing: connectionStatus))]]..")
        client.disconnect()
        client.logout()
    }
    
    var isSignedIn: Bool {
        print("[+] Success, client \(String(describing: currentUser)) is logged in. [\(String(describing: connectionStatus))]")
        return (client.currentUserId != nil)
        
    }
    
    
    // The ChannelVC  will populate a list of channels with same ID (array)
    public func createChannelList() -> UIViewController? {
        guard let id = currentUser else { return nil }
        let list = client.channelListController(query: .init(filter: .containMembers(userIds: [id])))
        
        let vc = ChatChannelListVC()
        vc.content = list
        list.synchronize() // api for live updates
        return vc
    }
    
    
    public func createNewChannel(name: String ) {
        guard let user = currentUser else { return }
        let keys = APIkeys.keys.filter({ $0 != user })
        print("[!] current key \(keys) current user \(user)")
        do {
            let result = try client.channelController (
                createChannelWithId: .init(type: .messaging, id: name),
                name: name,
                members: [],
                isCurrentUserMember: true
                
            )
            result.synchronize()
        } catch {
            print("[-] Create new channel error..    \(error)")
        }
    }
}
//** Fin






