import UIKit

/// Custom `UITableViewCell` subclass to display hero details in a table view.
final class PhotoRoundedAndLabelCell: UITableViewCell {
    
    /// Static identifier for cell reuse
    static let reuseIdentifier = "PhotoRoundedAndLabelCell"
    
    /// Provides the nib for the cell
    static var nib: UINib { UINib(nibName: "PhotoRoundedAndLabelCell", bundle: Bundle(for: PhotoRoundedAndLabelCell.self)) }
    
    /// Outlet for the label that displays the label name
    @IBOutlet weak var labelText: UILabel!
    
    /// Outlet for the image view that displays the avatar
    @IBOutlet weak var avatar: AsyncImageView!
    
    // MARK: - Lifecycle
    
    /// Prepares the cell for reuse by clearing the avatar image request
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.cancel() // Cancel any ongoing image loading
    }
    
    /// Called when the view is laid out, used to set the corner radius for the avatar
    override func layoutSubviews() {
        super.layoutSubviews()
        // Round the avatar image
        avatar.layer.cornerRadius = avatar.frame.size.width / 2 // Set the corner radius to half the width for a circular image
        avatar.clipsToBounds = true // Ensure that the rounded corners are applied
    }
    
    // MARK: - Configuration
    
    /// Sets the avatar image from a URL string
    /// - Parameter avatar: A string representing the URL of the avatar image
    func setAvatar(_ avatar: String) {
        self.avatar.setImage(avatar)
    }
    
    /// Sets the hero's name in the label
    /// - Parameter heroName: The name of the hero to be displayed
    func setHeroName(_ textLabel: String) {
        self.labelText.text = textLabel
    }
}
