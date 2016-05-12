import Foundation

struct TestCheck {
    /**
    Method to check wheter your on testing mode or not.
    - returns: A Bool, `true` if you're on testing mode, `false` if you're not.
    */
    static let isTesting: Bool = {
        let enviroment = NSProcessInfo.processInfo().environment
        let serviceName = enviroment["XPC_SERVICE_NAME"]
        let injectBundle = enviroment["XCInjectBundle"]
        var isRunning = (enviroment["TRAVIS"] != nil || enviroment["XCTestConfigurationFilePath"] != nil)

        if !isRunning {
            if let serviceName = serviceName {
                isRunning = (serviceName as NSString).pathExtension == "xctest"
            }
        }

        if !isRunning {
            if let injectBundle = injectBundle {
                isRunning = (injectBundle as NSString).pathExtension == "xctest"
            }
        }

        return isRunning
    }()

    static func testBlock(disabled disabled: Bool, block: Void -> Void) {
        if TestCheck.isTesting && disabled == false {
            block()
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                block()
            }
        }
    }
}
