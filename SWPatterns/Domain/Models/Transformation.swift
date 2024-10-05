/// Struct representing a transformation, which includes its ID, name, description, photo, and associated hero.
/// Conforms to `Equatable` and `Decodable` protocols.
struct Transformation: Equatable, Decodable {
    let id: String
    let name: String
    let description: String
    let photo: String
    let hero: HeroIDContainer
}

/// Struct representing the container for the hero's ID.
/// Conforms to `Equatable` and `Decodable` protocols.
struct HeroIDContainer: Equatable, Decodable {
    
    /// The unique identifier of the hero associated with the transformation.
    let id: String
}
