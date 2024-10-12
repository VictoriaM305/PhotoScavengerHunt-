import SwiftUI

// Define the Task model
struct Task: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool = false
    var image: UIImage?
}

struct ContentView: View {
    // Create a list of tasks using a state property
    @State private var tasks: [Task] = [
        Task(title: "Find a sunset", description: "Take a photo of a sunset."),
        Task(title: "Your favorite hiking spot", description: "Take a photo at your favorite hiking spot.")
    ]

    var body: some View {
        NavigationView {
            List($tasks) { $task in
                NavigationLink(destination: TaskDetailView(task: $task)) {
                    HStack {
                        Text(task.title)
                            .strikethrough(task.isCompleted) // Strike through completed tasks
                            .padding()

                        if task.isCompleted {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .navigationTitle("Scavenger Hunt")
        }
    }
}

// Preview for testing in Xcode
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

