import UIKit

/// Custom image view class for asynchronously loading and displaying images.
final class AsyncImageView: UIImageView {
    
    /// Holds a reference to the current image loading task, allowing it to be canceled if needed.
    private var workItem: DispatchWorkItem?
    
    /// Sets the image from a URL string.
    /// - Parameter string: The URL string representing the image location.
    func setImage(_ string: String) {
        if let url = URL(string: string) {
            setImage(url) // Converts string to URL and calls the URL-based setImage function.
        }
    }
    
    /// Asynchronously sets the image from a URL.
    /// - Parameter url: The URL where the image is located.
    func setImage(_ url: URL) {
        // Create a work item to download the image asynchronously.
        let workItem = DispatchWorkItem {
            // Download image data and convert it to a UIImage.
            let image = (try? Data(contentsOf: url)).flatMap { UIImage(data: $0) }
            
            // Once downloaded, update the image on the main thread.
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                self?.workItem = nil // Clear the work item after it's completed.
            }
        }
        // Execute the work item asynchronously in a global background queue.
        DispatchQueue.global().async(execute: workItem)
        self.workItem = workItem // Store the work item reference.
    }
    
    /// Cancels any ongoing image loading task.
    func cancel() {
        workItem?.cancel() // Cancel the current work item if it exists.
        workItem = nil // Clear the work item reference.
    }
}
