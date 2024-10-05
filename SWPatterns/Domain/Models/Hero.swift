/// Struct representing a hero, which includes its ID, name, description, photo, and whether it's marked as a favorite.
/// Conforms to `Equatable` and `Decodable` protocols.

struct Hero: Equatable, Decodable {
    let id: String
    let name: String
    let description: String
    let photo: String
    let favorite: Bool
}
