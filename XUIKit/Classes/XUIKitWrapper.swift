import Foundation

public struct XUIKitWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol XUIKitCompatible { }

extension XUIKitCompatible {
    public var x: XUIKitWrapper<Self> {
        get { return XUIKitWrapper(self) }
        set { }
    }
}
