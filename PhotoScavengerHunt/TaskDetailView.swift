import SwiftUI
import PhotosUI

struct TaskDetailView: View {
    // Binding to the selected task, allowing updates to reflect in ContentView
    @Binding var task: Task
    @State private var isPickerPresented = false
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            // Display the title and description of the task
            Text(task.title)
                .font(.title)
                .padding()

            Text(task.description)
                .padding()

            // If an image is selected, display it
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            }

            // Button to trigger the photo picker
            Button("Attach Photo") {
                isPickerPresented = true
            }
            .padding()
            .sheet(isPresented: $isPickerPresented) {
                PhotoPicker(selectedImage: $selectedImage)
            }

            // Update the task's completion status based on image selection
            if selectedImage != nil {
                Text("Task Completed!")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .navigationTitle(task.title)
        .padding()
        .onChange(of: selectedImage) { newImage in
            // Update the task's image and mark it as completed if an image is attached
            if let image = newImage {
                task.isCompleted = true
                task.image = image
            }
        }
    }
}

// A preview for testing in Xcode
struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Dummy task for preview purposes
        TaskDetailView(task: .constant(Task(title: "Preview Task", description: "This is a preview task.")))
    }
}

// Photo picker struct to handle image selection
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let result = results.first {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
            picker.dismiss(animated: true)
        }
    }
}

