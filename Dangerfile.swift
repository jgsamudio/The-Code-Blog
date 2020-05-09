import Danger 
let danger = Danger()

//let editedFiles = danger.git.modifiedFiles + danger.git.createdFiles
//message("These files have changed: \(editedFiles.joined(separator: ", "))")
//
//// MARK: - 1 - Pull Request Description
//
//let pullRequestBody = danger.github.pullRequest.body ?? ""
//if !pullRequestBody.contains("📲 What") ||
//    !pullRequestBody.contains("👀 See") ||
//    !pullRequestBody.contains("🤔 Why") ||
//    !pullRequestBody.contains("🛠 How") {
//    warn("""
//    Pull request description is missing required information:
//     - 📲 What
//     - 🤔 Why
//     - 🛠 How
//     - 👀 See
//    Please use the pull request:template:
//    https://github.com/kickstarter/ios-oss/blob/master/.github/PULL_REQUEST_TEMPLATE.md
//    """)
//}

// MARK: - 2 - Large Pull Request

var largePRLineCount = 500;
let additions: Int = danger.github.pullRequest.additions ?? 0
let deletions: Int = danger.github.pullRequest.deletions ?? 0

if ((additions + deletions) > largePRLineCount) {
  warn("""
    Number of pull request changes is larger than 500! Consider breaking out future changes into smaller pull requests.
    """)
}

// MARK: - 3 - SwiftLint

SwiftLint.lint(inline: true, strict: true, lintAllFiles: true)

// MARK: - 4 - Celebrate Milestones

let pullRequestMilestones = [3, 10, 100]
let currentPRNumber = danger.github.pullRequest.number
if pullRequestMilestones.contains(currentPRNumber) {
    let githubHandle = danger.github.pullRequest.user.login
    message("Congratulations \(githubHandle)! You've made the \(currentPRNumber)th Pull Request!")
}
    
 // MARK: - 10 - Dispatch Async

 func checkDispatchSyncIsNotCalledOnMain() {
   let excludedFiles = [
     "Dangerfile"
   ]
   for file in filter(files: danger.git.modifiedFiles + danger.git.createdFiles, with: [.swift]) {
     guard excludedFiles.allSatisfy({ !file.contains($0) }) else { continue }
     let fileLines = read(file: file, danger: danger)

     for (index, line) in fileLines.enumerated() {
       if line.contains("DispatchQueue.main.sync") {
         let link = "https://stackoverflow.com/questions/44324595/difference-between-dispatchqueue-main-async-and-dispatchqueue-main-sync"
         warn(message: "Please async on the main queue. [More information](\(link))",
              file: file,
              line: index + 1)
       }
     }
   }
 }

// MARK: - Helper Functions

/// Reads the file and returns an array of file lines.
/// - Parameter file: Danger swift file.
/// - Parameter danger: Danger dsl used to read the file.
/// - Parameter filterFileTypes:
func read(file: File, danger: DangerDSL, filterFileTypes: [FileType]? = nil) -> [String] {
  danger.utils.readFile(file).components(separatedBy: "\n")
}

/// Filters the files provided with the given file types.
/// - Parameter files: Files to search through.
/// - Parameter fileTypes: File types to filter by.
func filter(files: [File], with fileTypes: [FileType]) -> [File] {
  guard !fileTypes.isEmpty else { return files }
  return files.filter {
    if let fileType = $0.fileType {
      return fileTypes.contains(fileType)
    }
    return false
  }
}

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
