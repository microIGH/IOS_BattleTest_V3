
import Network
import Foundation

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private(set) var isConnected: Bool = false
    private(set) var connectionType: ConnectionType = .none
    
    var onStatusChange: ((Bool, ConnectionType) -> Void)?
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case none
        
        var displayName: String {
            switch self {
            case .wifi: return "WiFi"
            case .cellular: return "Datos Celulares"
            case .ethernet: return "Ethernet"
            case .none: return "Sin Conexión"
            }
        }
    }
    
    private init() {}
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            let type: ConnectionType
            
            if path.usesInterfaceType(.wifi) {
                type = .wifi
            } else if path.usesInterfaceType(.cellular) {
                type = .cellular
            } else if path.usesInterfaceType(.wiredEthernet) {
                type = .ethernet
            } else {
                type = .none
            }
            
            DispatchQueue.main.async {
                self?.isConnected = connected
                self?.connectionType = type
                self?.onStatusChange?(connected, type)
            }
        }
        
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
