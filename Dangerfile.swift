import Danger 
let danger = Danger()

let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
message("These files have changed: \(editedFiles.joined(separator: ", "))")

var bigPRThreshold = 100;
if (danger.github.pullRequest.additions + danger.github.pullRequest.deletions > bigPRThreshold) {
  warn('> Pull Request size seems relatively large. If this Pull Request contains multiple changes, please split each into separate PR will helps faster, easier review.');
}


// if danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 300 {
//     warn("Big PR, try to keep changes smaller if you can")
// }


// // MARK: - 10 - Dispatch Async

// func checkDispatchSyncIsNotCalledOnMain() {
//   let excludedFiles = [
//     "Dangerfile"
//   ]
//   for file in filter(files: filesChanged, with: [.swift]) {
//     guard excludedFiles.allSatisfy({ !file.contains($0) }) else { continue }
//     let fileLines = read(file: file, danger: danger)

//     for (index, line) in fileLines.enumerated() {
//       if line.contains("DispatchQueue.main.sync") {
//         let link = "https://stackoverflow.com/questions/44324595/difference-between-dispatchqueue-main-async-and-dispatchqueue-main-sync"
//         warn(message: "Please async on the main queue. [More information](\(link))",
//              file: file,
//              line: index + 1)
//       }
//     }
//   }
// }


// // MARK: - 4 - Asset Template and Vector

// /// Checks is new assets are set as template and vectors.
// func checkAssetsAreTemplatesAndVectors() {
//   for file in filesChanged {
//     guard file.hasSuffix(".imageset/Contents.json") else { continue }

//     let fileLines = read(file: file, danger: danger)
//     var isTemplateRendering = false
//     var isVectorRepresentation = false

//     for line in fileLines {
//       if line.contains("\"template-rendering-intent\" : \"template\"") {
//         isTemplateRendering = true
//       }
//       if line.contains("\"preserves-vector-representation\" : true\"") {
//         isVectorRepresentation = true
//       }
//     }
//     if !isTemplateRendering {
//       warn(message: "Asset is not rendered as a template", file: file, line: fileLines.count - 1)
//     }
//     if !isVectorRepresentation {
//       warn(message: "Asset is not rendered as a vector", file: file, line: fileLines.count - 1)
//     }
//   }
// }

// /// Checks if enabled animations are able to be accessible. iOS allows animations to be disabled through accessibility options.
// func checkAnimationsAreAccessible() {
//   let excludedFiles = [
//     "Dangerfile"
//   ]
//   for file in filter(files: filesChanged, with: [.swift]) {
//     guard excludedFiles.allSatisfy({ !file.contains($0) }) else { continue }
//     let fileLines = read(file: file, danger: danger)
//     for (index, line) in fileLines.enumerated() {
//       if line.contains("animated: true"), !contains(token: .comment, in: line, excludeComments: false) {
//         warn(message: "Use `theme.animated` to handle accessibility changes", file: file, line: index + 1)
//       }
//     }
//   }
// }

// if danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 300 {
//     warn("Big PR, try to keep changes smaller if you can")
// }