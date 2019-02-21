import UIKit

let data = "300".data(using: .utf8)

do {
    let value = try JSONDecoder().decode(String.self, from: data!)
} catch {
    print(error)
}
